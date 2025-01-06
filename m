Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB521DE897;
	Mon,  6 Jan 2025 15:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178640; cv=none; b=Dz6Urote7Qgd8grAyZwPp0j9abt62pSHvSU9BPpx8g+tiyoYNJkOH8OsaADdMk+1Rn8QvGwhh/XxWrhxF5QEn2p+bMX1VNo3DNw7AjF7iUS5SY9IBhz6KFC8gVuosIoaQx1xY7CWQ9APWxHBiETLdaqROdyFp/IpgL7dWadRcWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178640; c=relaxed/simple;
	bh=6nyg5QW3bit0Y/FC8d/I1M+51nCRUwDuuxjnqPh92Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fLQDeFnzD6aLRROOR9p18VOOImTG62rax3ypLhj0kyQBFR2So0pZwRxDqazt1+M569o9TrSAlnASkq8yyOMYIEhoF2xaGBa/a6SbVd0SZFk6UpJu5L1sQbMJaTGuk2ZWYY6RhMkmfxUrIr6bvGUO0wpac/hYC2htOh7MSp8zFC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XhrCSMiZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XhrCSMiZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D81EC4CED2;
	Mon,  6 Jan 2025 15:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178640;
	bh=6nyg5QW3bit0Y/FC8d/I1M+51nCRUwDuuxjnqPh92Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XhrCSMiZiAt1pEhwUJhYWoBTBZQIcG4OPFZ7qB9w+oyBLgTSp6Dn/7i8DuXF7xSgA
	 9jbcfMH77ujOGTrFdUoJDrSJk/BY9qGB7YDTtWUgjScfW1Pxfcr5v36LkEIcTwRyJJ
	 1yDG+Yl0X+XJ8jQ8ctcqumRQDYHDI5zo2uc2Hljk=
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
Subject: [PATCH 5.15 045/168] tracing: Fix test_event_printk() to process entire print argument
Date: Mon,  6 Jan 2025 16:15:53 +0100
Message-ID: <20250106151140.165342100@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit a6629626c584200daf495cc9a740048b455addcd upstream.

The test_event_printk() analyzes print formats of trace events looking for
cases where it may dereference a pointer that is not in the ring buffer
which can possibly be a bug when the trace event is read from the ring
buffer and the content of that pointer no longer exists.

The function needs to accurately go from one print format argument to the
next. It handles quotes and parenthesis that may be included in an
argument. When it finds the start of the next argument, it uses a simple
"c = strstr(fmt + i, ',')" to find the end of that argument!

In order to include "%s" dereferencing, it needs to process the entire
content of the print format argument and not just the content of the first
',' it finds. As there may be content like:

 ({ const char *saved_ptr = trace_seq_buffer_ptr(p); static const char
   *access_str[] = { "---", "--x", "w--", "w-x", "-u-", "-ux", "wu-", "wux"
   }; union kvm_mmu_page_role role; role.word = REC->role;
   trace_seq_printf(p, "sp gen %u gfn %llx l%u %u-byte q%u%s %s%s" " %snxe
   %sad root %u %s%c", REC->mmu_valid_gen, REC->gfn, role.level,
   role.has_4_byte_gpte ? 4 : 8, role.quadrant, role.direct ? " direct" : "",
   access_str[role.access], role.invalid ? " invalid" : "", role.efer_nx ? ""
   : "!", role.ad_disabled ? "!" : "", REC->root_count, REC->unsync ?
   "unsync" : "sync", 0); saved_ptr; })

Which is an example of a full argument of an existing event. As the code
already handles finding the next print format argument, process the
argument at the end of it and not the start of it. This way it has both
the start of the argument as well as the end of it.

Add a helper function "process_pointer()" that will do the processing during
the loop as well as at the end. It also makes the code cleaner and easier
to read.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/20241217024720.362271189@goodmis.org
Fixes: 5013f454a352c ("tracing: Add check of trace event print fmts for dereferencing pointers")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events.c |   82 ++++++++++++++++++++++++++++----------------
 1 file changed, 53 insertions(+), 29 deletions(-)

--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -248,8 +248,7 @@ static bool test_field(const char *fmt,
 	len = p - fmt;
 
 	for (; field->type; field++) {
-		if (strncmp(field->name, fmt, len) ||
-		    field->name[len])
+		if (strncmp(field->name, fmt, len) || field->name[len])
 			continue;
 		array_descriptor = strchr(field->type, '[');
 		/* This is an array and is OK to dereference. */
@@ -258,6 +257,32 @@ static bool test_field(const char *fmt,
 	return false;
 }
 
+/* Return true if the argument pointer is safe */
+static bool process_pointer(const char *fmt, int len, struct trace_event_call *call)
+{
+	const char *r, *e, *a;
+
+	e = fmt + len;
+
+	/* Find the REC-> in the argument */
+	r = strstr(fmt, "REC->");
+	if (r && r < e) {
+		/*
+		 * Addresses of events on the buffer, or an array on the buffer is
+		 * OK to dereference. There's ways to fool this, but
+		 * this is to catch common mistakes, not malicious code.
+		 */
+		a = strchr(fmt, '&');
+		if ((a && (a < r)) || test_field(r, call))
+			return true;
+	} else if ((r = strstr(fmt, "__get_dynamic_array(")) && r < e) {
+		return true;
+	} else if ((r = strstr(fmt, "__get_sockaddr(")) && r < e) {
+		return true;
+	}
+	return false;
+}
+
 /*
  * Examine the print fmt of the event looking for unsafe dereference
  * pointers using %p* that could be recorded in the trace event and
@@ -268,12 +293,12 @@ static void test_event_printk(struct tra
 {
 	u64 dereference_flags = 0;
 	bool first = true;
-	const char *fmt, *c, *r, *a;
+	const char *fmt;
 	int parens = 0;
 	char in_quote = 0;
 	int start_arg = 0;
 	int arg = 0;
-	int i;
+	int i, e;
 
 	fmt = call->print_fmt;
 
@@ -386,42 +411,41 @@ static void test_event_printk(struct tra
 		case ',':
 			if (in_quote || parens)
 				continue;
+			e = i;
 			i++;
 			while (isspace(fmt[i]))
 				i++;
-			start_arg = i;
-			if (!(dereference_flags & (1ULL << arg)))
-				goto next_arg;
 
-			/* Find the REC-> in the argument */
-			c = strchr(fmt + i, ',');
-			r = strstr(fmt + i, "REC->");
-			if (r && (!c || r < c)) {
-				/*
-				 * Addresses of events on the buffer,
-				 * or an array on the buffer is
-				 * OK to dereference.
-				 * There's ways to fool this, but
-				 * this is to catch common mistakes,
-				 * not malicious code.
-				 */
-				a = strchr(fmt + i, '&');
-				if ((a && (a < r)) || test_field(r, call))
+			/*
+			 * If start_arg is zero, then this is the start of the
+			 * first argument. The processing of the argument happens
+			 * when the end of the argument is found, as it needs to
+			 * handle paranthesis and such.
+			 */
+			if (!start_arg) {
+				start_arg = i;
+				/* Balance out the i++ in the for loop */
+				i--;
+				continue;
+			}
+
+			if (dereference_flags & (1ULL << arg)) {
+				if (process_pointer(fmt + start_arg, e - start_arg, call))
 					dereference_flags &= ~(1ULL << arg);
-			} else if ((r = strstr(fmt + i, "__get_dynamic_array(")) &&
-				   (!c || r < c)) {
-				dereference_flags &= ~(1ULL << arg);
-			} else if ((r = strstr(fmt + i, "__get_sockaddr(")) &&
-				   (!c || r < c)) {
-				dereference_flags &= ~(1ULL << arg);
 			}
 
-		next_arg:
-			i--;
+			start_arg = i;
 			arg++;
+			/* Balance out the i++ in the for loop */
+			i--;
 		}
 	}
 
+	if (dereference_flags & (1ULL << arg)) {
+		if (process_pointer(fmt + start_arg, i - start_arg, call))
+			dereference_flags &= ~(1ULL << arg);
+	}
+
 	/*
 	 * If you triggered the below warning, the trace event reported
 	 * uses an unsafe dereference pointer %p*. As the data stored


