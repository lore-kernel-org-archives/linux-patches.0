Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC53519E98B;
	Mon, 23 Dec 2024 16:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970478; cv=none; b=HEdv5CIlsqh9FqSm+2eRAW+B4XtM7rHSXodQzIqRtllP0sxU0/vFvhiphYDjR2CSz2DAsO64897CJD3BTdNO/4iQ6Ucf3nuwwQTk/jP0X6EvquqKToTYdwa+zZsPsCGw+zkTVTnxW7++G9cgSR2wYyf27TUrtj2V6YHYfihN5Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970478; c=relaxed/simple;
	bh=3SxxkRfrrVKlk2CtD2MnsepA7357MizlKRqelOW2DWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q2Cp5kAIHMd/KZVhe1l5HOG52EKbZrRHdO0vUTq0hzIGRx/Qx+HgG42UwTFeshvEmguQkG2AlbTP9OfrVMxMCPngm141X1xKbi18qKrrJ25rKwiscQXI/94jCIW8+gLHyuOrr+a/CZq0Q22gN9t+bDiPKlNMfK/6xMV28xzE0Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dRv0qY8B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dRv0qY8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CEE3C4CED3;
	Mon, 23 Dec 2024 16:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970478;
	bh=3SxxkRfrrVKlk2CtD2MnsepA7357MizlKRqelOW2DWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dRv0qY8B6dRgwc3PNlvX3CiLjCKjhH2Uf9njh1KkGVOXfkdOsVXk069F+wg3ml3Za
	 d/YvQo0myJ0a/bptdWpR7GOCY/pCLGdTr3gyHNqj+xuPZ02DPF5mNROhC1BPK5djjI
	 /IvVEvD7ObJfzaRN9X4ofOD5fycHEGj5tCMzaxms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 094/116] tracing: Add "%s" check in test_event_printk()
Date: Mon, 23 Dec 2024 16:59:24 +0100
Message-ID: <20241223155403.216513573@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit 65a25d9f7ac02e0cf361356e834d1c71d36acca9 upstream.

The test_event_printk() code makes sure that when a trace event is
registered, any dereferenced pointers in from the event's TP_printk() are
pointing to content in the ring buffer. But currently it does not handle
"%s", as there's cases where the string pointer saved in the ring buffer
points to a static string in the kernel that will never be freed. As that
is a valid case, the pointer needs to be checked at runtime.

Currently the runtime check is done via trace_check_vprintf(), but to not
have to replicate everything in vsnprintf() it does some logic with the
va_list that may not be reliable across architectures. In order to get rid
of that logic, more work in the test_event_printk() needs to be done. Some
of the strings can be validated at this time when it is obvious the string
is valid because the string will be saved in the ring buffer content.

Do all the validation of strings in the ring buffer at boot in
test_event_printk(), and make sure that the field of the strings that
point into the kernel are accessible. This will allow adding checks at
runtime that will validate the fields themselves and not rely on paring
the TP_printk() format at runtime.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/20241217024720.685917008@goodmis.org
Fixes: 5013f454a352c ("tracing: Add check of trace event print fmts for dereferencing pointers")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events.c |  104 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 89 insertions(+), 15 deletions(-)

--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -244,19 +244,16 @@ int trace_event_get_offsets(struct trace
 	return tail->offset + tail->size;
 }
 
-/*
- * Check if the referenced field is an array and return true,
- * as arrays are OK to dereference.
- */
-static bool test_field(const char *fmt, struct trace_event_call *call)
+
+static struct trace_event_fields *find_event_field(const char *fmt,
+						   struct trace_event_call *call)
 {
 	struct trace_event_fields *field = call->class->fields_array;
-	const char *array_descriptor;
 	const char *p = fmt;
 	int len;
 
 	if (!(len = str_has_prefix(fmt, "REC->")))
-		return false;
+		return NULL;
 	fmt += len;
 	for (p = fmt; *p; p++) {
 		if (!isalnum(*p) && *p != '_')
@@ -267,11 +264,26 @@ static bool test_field(const char *fmt,
 	for (; field->type; field++) {
 		if (strncmp(field->name, fmt, len) || field->name[len])
 			continue;
-		array_descriptor = strchr(field->type, '[');
-		/* This is an array and is OK to dereference. */
-		return array_descriptor != NULL;
+
+		return field;
 	}
-	return false;
+	return NULL;
+}
+
+/*
+ * Check if the referenced field is an array and return true,
+ * as arrays are OK to dereference.
+ */
+static bool test_field(const char *fmt, struct trace_event_call *call)
+{
+	struct trace_event_fields *field;
+
+	field = find_event_field(fmt, call);
+	if (!field)
+		return false;
+
+	/* This is an array and is OK to dereference. */
+	return strchr(field->type, '[') != NULL;
 }
 
 /* Look for a string within an argument */
@@ -317,6 +329,53 @@ static bool process_pointer(const char *
 	return false;
 }
 
+/* Return true if the string is safe */
+static bool process_string(const char *fmt, int len, struct trace_event_call *call)
+{
+	const char *r, *e, *s;
+
+	e = fmt + len;
+
+	/*
+	 * There are several helper functions that return strings.
+	 * If the argument contains a function, then assume its field is valid.
+	 * It is considered that the argument has a function if it has:
+	 *   alphanumeric or '_' before a parenthesis.
+	 */
+	s = fmt;
+	do {
+		r = strstr(s, "(");
+		if (!r || r >= e)
+			break;
+		for (int i = 1; r - i >= s; i++) {
+			char ch = *(r - i);
+			if (isspace(ch))
+				continue;
+			if (isalnum(ch) || ch == '_')
+				return true;
+			/* Anything else, this isn't a function */
+			break;
+		}
+		/* A function could be wrapped in parethesis, try the next one */
+		s = r + 1;
+	} while (s < e);
+
+	/*
+	 * If there's any strings in the argument consider this arg OK as it
+	 * could be: REC->field ? "foo" : "bar" and we don't want to get into
+	 * verifying that logic here.
+	 */
+	if (find_print_string(fmt, "\"", e))
+		return true;
+
+	/* Dereferenced strings are also valid like any other pointer */
+	if (process_pointer(fmt, len, call))
+		return true;
+
+	/* Make sure the field is found, and consider it OK for now if it is */
+	return find_event_field(fmt, call) != NULL;
+}
+
 /*
  * Examine the print fmt of the event looking for unsafe dereference
  * pointers using %p* that could be recorded in the trace event and
@@ -326,6 +385,7 @@ static bool process_pointer(const char *
 static void test_event_printk(struct trace_event_call *call)
 {
 	u64 dereference_flags = 0;
+	u64 string_flags = 0;
 	bool first = true;
 	const char *fmt;
 	int parens = 0;
@@ -416,8 +476,16 @@ static void test_event_printk(struct tra
 						star = true;
 						continue;
 					}
-					if ((fmt[i + j] == 's') && star)
-						arg++;
+					if ((fmt[i + j] == 's')) {
+						if (star)
+							arg++;
+						if (WARN_ONCE(arg == 63,
+							      "Too many args for event: %s",
+							      trace_event_name(call)))
+							return;
+						dereference_flags |= 1ULL << arg;
+						string_flags |= 1ULL << arg;
+					}
 					break;
 				}
 				break;
@@ -464,7 +532,10 @@ static void test_event_printk(struct tra
 			}
 
 			if (dereference_flags & (1ULL << arg)) {
-				if (process_pointer(fmt + start_arg, e - start_arg, call))
+				if (string_flags & (1ULL << arg)) {
+					if (process_string(fmt + start_arg, e - start_arg, call))
+						dereference_flags &= ~(1ULL << arg);
+				} else if (process_pointer(fmt + start_arg, e - start_arg, call))
 					dereference_flags &= ~(1ULL << arg);
 			}
 
@@ -476,7 +547,10 @@ static void test_event_printk(struct tra
 	}
 
 	if (dereference_flags & (1ULL << arg)) {
-		if (process_pointer(fmt + start_arg, i - start_arg, call))
+		if (string_flags & (1ULL << arg)) {
+			if (process_string(fmt + start_arg, i - start_arg, call))
+				dereference_flags &= ~(1ULL << arg);
+		} else if (process_pointer(fmt + start_arg, i - start_arg, call))
 			dereference_flags &= ~(1ULL << arg);
 	}
 


