%option noyywrap 
%{
#include <stdio.h>
#include "header.h" 
int linenumber;
int idCounter;
char* comments;
symtab * lookup();
    symtab * ptr;
void     insertID();
void 	 printSymTab();
/* You need to define for all tokens in C--, here are some examples */
#define INT		10
#define FLOAT 		11 
#define OP_ASSIGN 	12 
#define OP_OR 		13 
#define MK_LPAREN 	14 
#define MK_RPAREN 	15 
#define MK_LBRACE   16
#define MK_RBRACE   17
#define MK_LBRACKET 18
#define MK_RIGHTBRACKET     19
#define MK_SEMICOLON    20
#define MK_COMMA    21
#define MK_DOT  22
#define MK_NEWLINE  23

#define OP_AND  24
#define OP_NOT  25
#define OP_LT   26
#define OP_GT   27
#define OP_GE   28
#define OP_LE   29
#define OP_NE   30
#define OP_EQ   31
#define OP_PLUS  32
#define OP_MINUS    33
#define OP_MULTIPLY 34
#define OP_DIVIDE   35

#define RETURN  36
#define TYPEDEF 37
#define IF      38
#define ELSE    39
#define FOR     40
#define VOID    41
#define WHILE   42

#define INT_CONSTANT 43
#define FLOAT_CONSTANT 44
#define COMMENT 45
#define STRING_CONSTENT 46

#define WHITE 47
#define ERROR 		100 


%}

letter   [A-Za-z]
digit    [0-9]
ID	 {letter}({letter}|{digit}|"_")*
WS	 [ \t]+
Int_constant {digit}+
exp     [eE][+-]?{digit}+
float1  {digit}+{exp}
float2  ({digit}+"."{digit}*|"."{digit}+){exp}?
special_char "a"|"b"|"f"|"n"|"r"|"t"|"v"|\\|\'|\"|"0"|"ddd"|"xhh"

Float_constant  [+-]?({float1}|{float2})
String_constant_c \"(\\{special_char}|[^\\"\n])*\"
String_constant_cminus \"[^\"]*\"
comment    "/*"(([^*])|([*]+[^/*]))*("*")+"/"

OP_assign        "="
OP_or   "||"
OP_and  "&&"
OP_not  "!" 
OP_lt   "<"
OP_gt   ">"
OP_ge   ">="
OP_le   "<="
OP_ne   "!="
OP_eq   "=="
OP_plus "+"
OP_minus    "-"
OP_multiply     "*"
OP_divide   "/"
/* Other operators appear here */ 


newline  "\n"

DL_lparen "("
DL_rparen ")"
DL_lbrace "{"
DL_rbrace "}"
DL_lbracket "["
DL_rbracket "]"
DL_comma  ","
DL_semicol ";"
DL_dot  "."

/* Other separators appear here */


error    .

%%

{WS}            {/*printf("this is white space\n");return WHITE;*/}
{Float_constant} {/*printf("float: %s\n", yytext);*/}
{Int_constant}  {/*return INT_CONSTANT;*/}
{String_constant_cminus}   {/*printf("string: %s\n", yytext);return STRING_CONSTENT*/}
{comment}       {
                comments = realloc(comments, sizeof(char*) * (strlen(yytext) + 2));
                comments = strcat(comments, yytext);
                comments = strcat(comments, "\n");
                /*return COMMENT*/
                }


{ID}            { 
			ptr = lookup(yytext);
			if (ptr == NULL){
			     insertID(yytext);	
                idCounter = idCounter+1;
            }
			else 
			     ptr->counter++;
		}

{OP_assign}     { /*return OP_ASSIGN;*/ }
{OP_or}         { /*return OP_OR;*/ }
{OP_and}        { /*return OP_AND;*/ }
{OP_not}        {/*return OP_NOT;*/}
{OP_lt}         {/*return OP_LT;*/}
{OP_gt}         {/*return OP_GT;*/}
{OP_ge}         {/*return OP_GE;*/}
{OP_le}         {/*return OP_LE;*/}
{OP_ne}         {/*return OP_NE;*/}
{OP_eq}         {/*return OP_EQ;*/}
{OP_plus}        {/*return OP_PLUS;*/}
{OP_minus}      {/*return OP_MINUS;*/}
{OP_multiply}   {/*return OP_MULTIPLY;*/}
{OP_divide}     {/*return OP_DIVIDE;*/}

{DL_lparen}     { /*return MK_LPAREN;*/ }
{DL_rparen}     { /*return MK_RPAREN;*/ }
{DL_lbrace}     { /*return MK_LBRACE;*/ }
{DL_rbrace}     { /*return MK_RBRACE;*/ }
{DL_rbracket}   {/*return MK_RIGHTBRACKET;*/}
{DL_lbracket}   {/*return MK_LBRACKET;*/}
{DL_comma}      {/*return MK_COMMA;*/}
{DL_semicol}    {/*return MK_SEMICOLON;*/}
{newline}   { linenumber += 1; 
             /*printf("linenumber: %d\n",linenumber);
             return MK_NEWLINE;*/}
{error}         {printf("ERR: %s \nexit!\n",yytext); exit(1); }


%%

int main(int argc, char **argv)
{
 argc--; ++argv;
   if (argc > 0){
      yyin = fopen(argv[0], "r");
      printf("Open file successfully\n");
   }
   else
      yyin = stdin;
   printf("Start scanning\n");
   yylex();
   printf("print symbolic table\n");
   printSymTab();
   return 0;
}