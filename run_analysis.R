#Module 3 assignment
#Open zip file without unzipping it
files.temp <- "getdata_projectfiles_UCI HAR Dataset.zip"
unzip("getdata_projectfiles_UCI HAR Dataset.zip", exdir = "./UCI HAR Dataset")

#Setting the correct directory
getwd()
setwd( "D:/LearningR/gitandR/tsa-learner/Assignment_module3/")
getwd()

#changed_path <- setwd("./UCI HAR Dataset")
Dataset <- file.path("./UCI HAR Dataset", "UCI HAR Dataset")
files <- list.files(Dataset, recursive = TRUE)
files

#In the given dataset, the README.txt consists of the info about variables
#The dataframe or interest are 'train', 'test' and 'features'

#Features and activities 
#Get features
features <- read.table("./UCI HAR Dataset/features.txt", col.names = c("n", "functions"))
#head(features)

#Get activities 
activities <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
#head(activities)

#Get subject test and subject train
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = c("subject"))
#head(subject_test)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = c("subject"))
#head(subject_train)

#Test data
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
#head(x_test)

y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "code")

#Train dataset
library('dplyr')
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "code")
#head(y_train)

#To merge the various tables as a data set
x <- rbind(x_train, x_test)
#str(x)

y <- rbind(y_train, y_test)
#head(y)
#str(y)

Subjects <- rbind(subject_train, subject_test)
finalMerged <- cbind(Subjects, y, x)
#head(finalMerged)
#str(finalMerged)


#Making tidydata
tidydata <- finalMerged %>% select(subject, code, contains("mean"), contains("std"))
View(tidydata)


#Rename variables to make it tidy
names(tidydata)[2] = "activity"
#head(tidydata)

names(tidydata) <- gsub("Acc", 'Accelerometer', names(tidydata))
names(tidydata) <- gsub("BodyBody", 'Body', names(tidydata))
names(tidydata) <- gsub("Gyro", 'Gyroscope', names(tidydata))
names(tidydata) <- gsub("^t", 'Time', names(tidydata))
names(tidydata) <- gsub("^f", "Frequency", names(tidydata))
names(tidydata) <- gsub("tBody", 'TimeBody', names(tidydata))
names(tidydata) <- gsub("-mean()", 'Mean', names(tidydata))
names(tidydata) <- gsub("-std()", 'STDEV', names(tidydata))
head(tidydata)
str(tidydata)

#Creating the final data
FinalData <- tidydata %>% group_by(subject, activity) %>%
  summarise_all(funs(mean))
head(FinalData)
write.table(FinalData, "FinalData.txt", row.name = FALSE)
FinalData #Final data looks fine

#Save as run_analysis.R 