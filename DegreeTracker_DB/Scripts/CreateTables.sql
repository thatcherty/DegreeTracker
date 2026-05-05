use DegreeTracker;

create table Degree (
	degree_id int identity(100,1),
	degree_name varchar(100) not null

	constraint PK_Degree primary key (degree_id),
	constraint UQ_Name unique (degree_name)
);

create table Requirements (
	req_id int identity(1000,1),
	req_name varchar(100) not null,
	credits int not null constraint DEF_Req_Credits default 3

	constraint PK_Req primary key (req_id),
	constraint UQ_Req unique (req_name)
);

create table Categories (
	cat_id int identity(100,1),
	cat_name varchar not null

	constraint PK_Cat primary key (cat_id),
	constraint UQ_Cat unique (cat_name)
);

create table Degree_Statuses (
	deg_status_id int identity(10,1),
	deg_status_name varchar(15) not null

	constraint PK_Degree_Status primary key (deg_status_id)
);

create table Course_Statuses (
	course_status_id int identity(10,1),
	course_status_name varchar(15) not null

	constraint PK_Course_Status primary key (course_status_id)
);

create table Courses (
	course_id int identity(10000, 1),
	cat_id integer not null,
	course_level varchar(20) not null,
	course_name varchar(50) not null,
	credits int not null constraint DEF_Course_Credits default 3

	constraint PK_Courses primary key (course_id),
	constraint UQ_Courses unique (course_level, course_name),
	constraint FK_Course_Cat foreign key (cat_id) references Categories(cat_id)
);

create table Students (
	student_id int identity(100000, 1),
	fname nvarchar(50) not null,
	lname nvarchar(50) not null,
	email varchar(60) not null

	constraint PK_Students primary key (student_id),
	constraint UQ_Student_Email unique (email)
);

create table Degree_Req (
	degree_id int,
	req_id int

	constraint PK_Degree_Req primary key (degree_id, req_id),
	constraint FK_Degree foreign key (degree_id) references Degree(degree_id),
	constraint FK_Req foreign key (req_id) references Requirements(req_id)
);

create table Student_Degrees (
	student_id int,
	degree_id int,
	deg_status_id int

	constraint PK_Student_Degrees primary key (student_id, degree_id),
	constraint FK_Student_ID_Degrees foreign key (student_id) references Students(student_id),
	constraint FK_Degree_ID_Degrees foreign key (degree_id) references Degree(degree_id),
	constraint FK_Degree_Status foreign key (deg_status_id) references Degree_Statuses(deg_status_id)
);

create table Courses_Req (
	course_id int,
	req_id int

	constraint PK_Courses_Req primary key (course_id, req_id)
);

create table Terms (
	term_id int identity(1000,1),
	term_name varchar(25) not null

	constraint PK_Terms primary key (term_id)
);

create table Courses_Reg (
	student_id int,
	course_id int,
	course_status_id int not null,
	grade int,
	term_id int not null

	constraint PK_Courses_Reg primary key (student_id, course_id),
	constraint FK_Course_Term foreign key (term_id) references Terms(term_id),
	constraint FK_Course_Status foreign key (course_status_id) references Course_Statuses(course_status_id),
	constraint Chk_Grade check (grade >= 0),
	
	-- checks that if a course is marked complete, there must be a grade
	constraint Chk_Valid_Grade check (course_status_id <> 'Complete' or grade is not null)
);