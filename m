Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7540B37756C;
	Mon,  9 Feb 2026 14:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647265; cv=none; b=iL55TAIdr/3QKwRUfCUUzS+T+tne+szjhIDD7VIgOxIRS/rh7O9mm/2UGR+q36XxeZo4OTJXWOvdg5ioO9vxPGJiGfcOxvRfl+3AMY8CtFtu5N4vLZkX6ojEzb5D20vOzKszaNs0M0/7VMZwPNDlfB6clYdQ7XvFGEfPmab5kd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647265; c=relaxed/simple;
	bh=zMh7C2si9T4JF7MqLlLHXll4yvZnCYveDHk71JOciKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=feMSOVjKfFarhVeuJ0y4gCePR6zCnOTDiqc6NSCiMYLsYTa6L91dPRx2nZ6AyaOcxBHwMYvjftqfIbGwZdUzeNOR/NzwnDZ1DnFuuguWfu17cB/dEnFRkjkexHauaPgcMy/2TawyAqAcjvMNGuamHQMqhT9A59AOzuf1RLPjQss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uAP4akQW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uAP4akQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B3FC116C6;
	Mon,  9 Feb 2026 14:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647265;
	bh=zMh7C2si9T4JF7MqLlLHXll4yvZnCYveDHk71JOciKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uAP4akQWPToEhv7bWICBvJ9Fx0qUBHFxZg+VLDzb6Ha1dIKs79/8qhk6OJOO2Lrhs
	 +ibbFLRdgkovTh9aQMTHLamB0x3K9vwHti6ZTCeFuFPvE8jYsfIKH4jFR4/QluuNcw
	 9Yq5HfgXUyXpG9RpvvuhAV8Upe5/Ujte+oPW6chk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mark Rutland <mark.rutland@arm.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"jempty.liang" <imntjempty@163.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 047/175] tracing: Fix ftrace event field alignments
Date: Mon,  9 Feb 2026 15:22:00 +0100
Message-ID: <20260209142322.164777808@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 033c55fe2e326bea022c3cc5178ecf3e0e459b82 ]

The fields of ftrace specific events (events used to save ftrace internal
events like function traces and trace_printk) are generated similarly to
how normal trace event fields are generated. That is, the fields are added
to a trace_events_fields array that saves the name, offset, size,
alignment and signness of the field. It is used to produce the output in
the format file in tracefs so that tooling knows how to parse the binary
data of the trace events.

The issue is that some of the ftrace event structures are packed. The
function graph exit event structures are one of them. The 64 bit calltime
and rettime fields end up 4 byte aligned, but the algorithm to show to
userspace shows them as 8 byte aligned.

The macros that create the ftrace events has one for embedded structure
fields. There's two macros for theses fields:

  __field_desc() and __field_packed()

The difference of the latter macro is that it treats the field as packed.

Rename that field to __field_desc_packed() and create replace the
__field_packed() to be a normal field that is packed and have the calltime
and rettime use those.

This showed up on 32bit architectures for function graph time fields. It
had:

 ~# cat /sys/kernel/tracing/events/ftrace/funcgraph_exit/format
[..]
        field:unsigned long func;       offset:8;       size:4; signed:0;
        field:unsigned int depth;       offset:12;      size:4; signed:0;
        field:unsigned int overrun;     offset:16;      size:4; signed:0;
        field:unsigned long long calltime;      offset:24;      size:8; signed:0;
        field:unsigned long long rettime;       offset:32;      size:8; signed:0;

Notice that overrun is at offset 16 with size 4, where in the structure
calltime is at offset 20 (16 + 4), but it shows the offset at 24. That's
because it used the alignment of unsigned long long when used as a
declaration and not as a member of a structure where it would be aligned
by word size (in this case 4).

By using the proper structure alignment, the format has it at the correct
offset:

 ~# cat /sys/kernel/tracing/events/ftrace/funcgraph_exit/format
[..]
        field:unsigned long func;       offset:8;       size:4; signed:0;
        field:unsigned int depth;       offset:12;      size:4; signed:0;
        field:unsigned int overrun;     offset:16;      size:4; signed:0;
        field:unsigned long long calltime;      offset:20;      size:8; signed:0;
        field:unsigned long long rettime;       offset:28;      size:8; signed:0;

Cc: stable@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reported-by: "jempty.liang" <imntjempty@163.com>
Link: https://patch.msgid.link/20260204113628.53faec78@gandalf.local.home
Fixes: 04ae87a52074e ("ftrace: Rework event_create_dir()")
Closes: https://lore.kernel.org/all/20260130015740.212343-1-imntjempty@163.com/
Closes: https://lore.kernel.org/all/20260202123342.2544795-1-imntjempty@163.com/
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
[ Different variable types and some renames ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.h         |    7 +++++--
 kernel/trace/trace_entries.h |   32 ++++++++++++++++----------------
 kernel/trace/trace_export.c  |   21 +++++++++++++++------
 3 files changed, 36 insertions(+), 24 deletions(-)

--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -67,14 +67,17 @@ enum trace_type {
 #undef __field_fn
 #define __field_fn(type, item)		type	item;
 
+#undef __field_packed
+#define __field_packed(type, item)	type	item;
+
 #undef __field_struct
 #define __field_struct(type, item)	__field(type, item)
 
 #undef __field_desc
 #define __field_desc(type, container, item)
 
-#undef __field_packed
-#define __field_packed(type, container, item)
+#undef __field_desc_packed
+#define __field_desc_packed(type, container, item)
 
 #undef __array
 #define __array(type, item, size)	type	item[size];
--- a/kernel/trace/trace_entries.h
+++ b/kernel/trace/trace_entries.h
@@ -79,8 +79,8 @@ FTRACE_ENTRY(funcgraph_entry, ftrace_gra
 
 	F_STRUCT(
 		__field_struct(	struct ftrace_graph_ent,	graph_ent	)
-		__field_packed(	unsigned long,	graph_ent,	func		)
-		__field_packed(	unsigned int,	graph_ent,	depth		)
+		__field_desc_packed(unsigned long,	graph_ent,	func	)
+		__field_desc_packed(unsigned int,	graph_ent,	depth	)
 		__dynamic_array(unsigned long,	args				)
 	),
 
@@ -96,9 +96,9 @@ FTRACE_ENTRY_PACKED(fgraph_retaddr_entry
 
 	F_STRUCT(
 		__field_struct(	struct fgraph_retaddr_ent,	graph_ent	)
-		__field_packed(	unsigned long,	graph_ent,	func		)
-		__field_packed(	unsigned int,	graph_ent,	depth		)
-		__field_packed(	unsigned long,	graph_ent,	retaddr		)
+		__field_desc_packed(	unsigned long,	graph_ent,	func	)
+		__field_desc_packed(	unsigned int,	graph_ent,	depth	)
+		__field_desc_packed(	unsigned long,	graph_ent,	retaddr	)
 	),
 
 	F_printk("--> %ps (%u) <- %ps", (void *)__entry->func, __entry->depth,
@@ -122,12 +122,12 @@ FTRACE_ENTRY_PACKED(funcgraph_exit, ftra
 
 	F_STRUCT(
 		__field_struct(	struct ftrace_graph_ret,	ret	)
-		__field_packed(	unsigned long,	ret,		func	)
-		__field_packed(	unsigned long,	ret,		retval	)
-		__field_packed(	unsigned int,	ret,		depth	)
-		__field_packed(	unsigned int,	ret,		overrun	)
-		__field(unsigned long long,	calltime		)
-		__field(unsigned long long,	rettime			)
+		__field_desc_packed(	unsigned long,	ret,	func	)
+		__field_desc_packed(	unsigned long,	ret,	retval	)
+		__field_desc_packed(	unsigned int,	ret,	depth	)
+		__field_desc_packed(	unsigned int,	ret,	overrun	)
+		__field_packed(unsigned long long,	calltime)
+		__field_packed(unsigned long long,	rettime	)
 	),
 
 	F_printk("<-- %ps (%u) (start: %llx  end: %llx) over: %u retval: %lx",
@@ -145,11 +145,11 @@ FTRACE_ENTRY_PACKED(funcgraph_exit, ftra
 
 	F_STRUCT(
 		__field_struct(	struct ftrace_graph_ret,	ret	)
-		__field_packed(	unsigned long,	ret,		func	)
-		__field_packed(	unsigned int,	ret,		depth	)
-		__field_packed(	unsigned int,	ret,		overrun	)
-		__field(unsigned long long,	calltime		)
-		__field(unsigned long long,	rettime			)
+		__field_desc_packed(	unsigned long,	ret,	func	)
+		__field_desc_packed(	unsigned int,	ret,	depth	)
+		__field_desc_packed(	unsigned int,	ret,	overrun	)
+		__field_packed(unsigned long long,	calltime	)
+		__field_packed(unsigned long long,	rettime		)
 	),
 
 	F_printk("<-- %ps (%u) (start: %llx  end: %llx) over: %u",
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -42,11 +42,14 @@ static int ftrace_event_register(struct
 #undef __field_fn
 #define __field_fn(type, item)				type item;
 
+#undef __field_packed
+#define __field_packed(type, item)			type item;
+
 #undef __field_desc
 #define __field_desc(type, container, item)		type item;
 
-#undef __field_packed
-#define __field_packed(type, container, item)		type item;
+#undef __field_desc_packed
+#define __field_desc_packed(type, container, item)	type item;
 
 #undef __array
 #define __array(type, item, size)			type item[size];
@@ -104,11 +107,14 @@ static void __always_unused ____ftrace_c
 #undef __field_fn
 #define __field_fn(_type, _item) __field_ext(_type, _item, FILTER_TRACE_FN)
 
+#undef __field_packed
+#define __field_packed(_type, _item) __field_ext_packed(_type, _item, FILTER_OTHER)
+
 #undef __field_desc
 #define __field_desc(_type, _container, _item) __field_ext(_type, _item, FILTER_OTHER)
 
-#undef __field_packed
-#define __field_packed(_type, _container, _item) __field_ext_packed(_type, _item, FILTER_OTHER)
+#undef __field_desc_packed
+#define __field_desc_packed(_type, _container, _item) __field_ext_packed(_type, _item, FILTER_OTHER)
 
 #undef __array
 #define __array(_type, _item, _len) {					\
@@ -146,11 +152,14 @@ static struct trace_event_fields ftrace_
 #undef __field_fn
 #define __field_fn(type, item)
 
+#undef __field_packed
+#define __field_packed(type, item)
+
 #undef __field_desc
 #define __field_desc(type, container, item)
 
-#undef __field_packed
-#define __field_packed(type, container, item)
+#undef __field_desc_packed
+#define __field_desc_packed(type, container, item)
 
 #undef __array
 #define __array(type, item, len)


