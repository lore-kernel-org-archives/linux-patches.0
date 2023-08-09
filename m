Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC4B17AAD
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:35:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5035BC433CA;
	Wed,  9 Aug 2023 11:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580906;
	bh=Gtstr+tTd9h2EDY0YEg63xrJPce3hVXfPbL78YmGZGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hG0d5POE8/o0iIea1PsOy/PJ4l1UuqOrCMWo9wpI06qKMxbz6vnBjQvk4GVKDVbiX
	 1NtN2cZj2hxyvnCpi7ise2FqcN85HdmFiYRQXLrehcfyhSOwO/5RuDR1iqLjscX79+
	 gDuDnkr2vQxW9uu/1JUXtMPh8H2t9KkekQPMhY1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 019/201] tracing: Show real address for trace event arguments
Date: Wed,  9 Aug 2023 12:40:21 +0200
Message-ID: <20230809103644.466730045@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
References: <20230809103643.799166053@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit efbbdaa22bb78761bff8dfdde027ad04bedd47ce ]

To help debugging kernel, show real address for trace event arguments
in tracefs/trace{,pipe} instead of hashed pointer value.

Since ftrace human-readable format uses vsprintf(), all %p are
translated to hash values instead of pointer address.

However, when debugging the kernel, raw address value gives a
hint when comparing with the memory mapping in the kernel.
(Those are sometimes used with crash log, which is not hashed too)
So converting %p with %px when calling trace_seq_printf().

Moreover, this is not improving the security because the tracefs
can be used only by root user and the raw address values are readable
from tracefs/percpu/cpu*/trace_pipe_raw file.

Link: https://lkml.kernel.org/r/160277370703.29307.5134475491761971203.stgit@devnote2

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Stable-dep-of: d5a821896360 ("tracing: Fix memory leak of iter->temp when reading trace_pipe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/trace_events.h |  4 ++
 include/trace/trace_events.h |  2 +-
 kernel/trace/trace.c         | 71 +++++++++++++++++++++++++++++++++++-
 kernel/trace/trace.h         |  2 +
 kernel/trace/trace_output.c  | 12 +++++-
 5 files changed, 88 insertions(+), 3 deletions(-)

diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index c57b79301a75e..e418065c2c909 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -55,6 +55,8 @@ struct trace_event;
 
 int trace_raw_output_prep(struct trace_iterator *iter,
 			  struct trace_event *event);
+extern __printf(2, 3)
+void trace_event_printf(struct trace_iterator *iter, const char *fmt, ...);
 
 /*
  * The trace entry - the most basic unit of tracing. This is what
@@ -87,6 +89,8 @@ struct trace_iterator {
 	unsigned long		iter_flags;
 	void			*temp;	/* temp holder */
 	unsigned int		temp_size;
+	char			*fmt;	/* modified format holder */
+	unsigned int		fmt_size;
 
 	/* trace_seq for __print_flags() and __print_symbolic() etc. */
 	struct trace_seq	tmp_seq;
diff --git a/include/trace/trace_events.h b/include/trace/trace_events.h
index 717d388ecbd6a..29917bce6dbc5 100644
--- a/include/trace/trace_events.h
+++ b/include/trace/trace_events.h
@@ -364,7 +364,7 @@ trace_raw_output_##call(struct trace_iterator *iter, int flags,		\
 	if (ret != TRACE_TYPE_HANDLED)					\
 		return ret;						\
 									\
-	trace_seq_printf(s, print);					\
+	trace_event_printf(iter, print);				\
 									\
 	return trace_handle_return(s);					\
 }									\
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7867fc39c4fc5..bed792f065758 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3582,6 +3582,62 @@ __find_next_entry(struct trace_iterator *iter, int *ent_cpu,
 	return next;
 }
 
+#define STATIC_FMT_BUF_SIZE	128
+static char static_fmt_buf[STATIC_FMT_BUF_SIZE];
+
+static char *trace_iter_expand_format(struct trace_iterator *iter)
+{
+	char *tmp;
+
+	if (iter->fmt == static_fmt_buf)
+		return NULL;
+
+	tmp = krealloc(iter->fmt, iter->fmt_size + STATIC_FMT_BUF_SIZE,
+		       GFP_KERNEL);
+	if (tmp) {
+		iter->fmt_size += STATIC_FMT_BUF_SIZE;
+		iter->fmt = tmp;
+	}
+
+	return tmp;
+}
+
+const char *trace_event_format(struct trace_iterator *iter, const char *fmt)
+{
+	const char *p, *new_fmt;
+	char *q;
+
+	if (WARN_ON_ONCE(!fmt))
+		return fmt;
+
+	p = fmt;
+	new_fmt = q = iter->fmt;
+	while (*p) {
+		if (unlikely(q - new_fmt + 3 > iter->fmt_size)) {
+			if (!trace_iter_expand_format(iter))
+				return fmt;
+
+			q += iter->fmt - new_fmt;
+			new_fmt = iter->fmt;
+		}
+
+		*q++ = *p++;
+
+		/* Replace %p with %px */
+		if (p[-1] == '%') {
+			if (p[0] == '%') {
+				*q++ = *p++;
+			} else if (p[0] == 'p' && !isalnum(p[1])) {
+				*q++ = *p++;
+				*q++ = 'x';
+			}
+		}
+	}
+	*q = '\0';
+
+	return new_fmt;
+}
+
 #define STATIC_TEMP_BUF_SIZE	128
 static char static_temp_buf[STATIC_TEMP_BUF_SIZE] __aligned(4);
 
@@ -4368,6 +4424,16 @@ __tracing_open(struct inode *inode, struct file *file, bool snapshot)
 	if (iter->temp)
 		iter->temp_size = 128;
 
+	/*
+	 * trace_event_printf() may need to modify given format
+	 * string to replace %p with %px so that it shows real address
+	 * instead of hash value. However, that is only for the event
+	 * tracing, other tracer may not need. Defer the allocation
+	 * until it is needed.
+	 */
+	iter->fmt = NULL;
+	iter->fmt_size = 0;
+
 	/*
 	 * We make a copy of the current tracer to avoid concurrent
 	 * changes on it while we are reading.
@@ -4519,6 +4585,7 @@ static int tracing_release(struct inode *inode, struct file *file)
 
 	mutex_destroy(&iter->mutex);
 	free_cpumask_var(iter->started);
+	kfree(iter->fmt);
 	kfree(iter->temp);
 	kfree(iter->trace);
 	kfree(iter->buffer_iter);
@@ -9382,9 +9449,11 @@ void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
 
 	/* Simulate the iterator */
 	trace_init_global_iter(&iter);
-	/* Can not use kmalloc for iter.temp */
+	/* Can not use kmalloc for iter.temp and iter.fmt */
 	iter.temp = static_temp_buf;
 	iter.temp_size = STATIC_TEMP_BUF_SIZE;
+	iter.fmt = static_fmt_buf;
+	iter.fmt_size = STATIC_FMT_BUF_SIZE;
 
 	for_each_tracing_cpu(cpu) {
 		atomic_inc(&per_cpu_ptr(iter.array_buffer->data, cpu)->disabled);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index e5b505b5b7d09..892b3d2f33b79 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -758,6 +758,8 @@ struct trace_entry *trace_find_next_entry(struct trace_iterator *iter,
 void trace_buffer_unlock_commit_nostack(struct trace_buffer *buffer,
 					struct ring_buffer_event *event);
 
+const char *trace_event_format(struct trace_iterator *iter, const char *fmt);
+
 int trace_empty(struct trace_iterator *iter);
 
 void *trace_find_next_entry_inc(struct trace_iterator *iter);
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index b3ee8d9b6b62a..94b0991717b6d 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -312,13 +312,23 @@ int trace_raw_output_prep(struct trace_iterator *iter,
 }
 EXPORT_SYMBOL(trace_raw_output_prep);
 
+void trace_event_printf(struct trace_iterator *iter, const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	trace_seq_vprintf(&iter->seq, trace_event_format(iter, fmt), ap);
+	va_end(ap);
+}
+EXPORT_SYMBOL(trace_event_printf);
+
 static int trace_output_raw(struct trace_iterator *iter, char *name,
 			    char *fmt, va_list ap)
 {
 	struct trace_seq *s = &iter->seq;
 
 	trace_seq_printf(s, "%s: ", name);
-	trace_seq_vprintf(s, fmt, ap);
+	trace_seq_vprintf(s, trace_event_format(iter, fmt), ap);
 
 	return trace_handle_return(s);
 }
-- 
2.39.2



