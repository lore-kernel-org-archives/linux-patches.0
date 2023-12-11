Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB99524C4;
	Mon, 11 Dec 2023 18:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hcw1+fUz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6DEC433C9;
	Mon, 11 Dec 2023 18:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702321037;
	bh=QC8XM/FO2iMoW1URYo4cuQW0j9P+PKNciVB7WEdRAYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hcw1+fUzatV+vMET+KpWHx5AXiZyP5v9J4wwv2bTOWJD8sx8+ZpFftop4A45S3yej
	 WT3nkhPk7KMkZVGcuFCweZ/UFPivvWxikOObOVYNj0qnLiyXSAG0YhX0DHoIenkNfy
	 g+SuE1J8Tn3fWFS2+Yar3a3f+vFjB7pxaw8LBS18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 086/141] tracing: Disable snapshot buffer when stopping instance tracers
Date: Mon, 11 Dec 2023 19:22:25 +0100
Message-ID: <20231211182030.302029343@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182026.503492284@linuxfoundation.org>
References: <20231211182026.503492284@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit b538bf7d0ec11ca49f536dfda742a5f6db90a798 upstream.

It use to be that only the top level instance had a snapshot buffer (for
latency tracers like wakeup and irqsoff). When stopping a tracer in an
instance would not disable the snapshot buffer. This could have some
unintended consequences if the irqsoff tracer is enabled.

Consolidate the tracing_start/stop() with tracing_start/stop_tr() so that
all instances behave the same. The tracing_start/stop() functions will
just call their respective tracing_start/stop_tr() with the global_array
passed in.

Link: https://lkml.kernel.org/r/20231205220011.041220035@goodmis.org

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Fixes: 6d9b3fa5e7f6 ("tracing: Move tracing_max_latency into trace_array")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |  110 +++++++++++++++------------------------------------
 1 file changed, 34 insertions(+), 76 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2284,13 +2284,7 @@ int is_tracing_stopped(void)
 	return global_trace.stop_count;
 }
 
-/**
- * tracing_start - quick start of the tracer
- *
- * If tracing is enabled but was stopped by tracing_stop,
- * this will start the tracer back up.
- */
-void tracing_start(void)
+static void tracing_start_tr(struct trace_array *tr)
 {
 	struct trace_buffer *buffer;
 	unsigned long flags;
@@ -2298,119 +2292,83 @@ void tracing_start(void)
 	if (tracing_disabled)
 		return;
 
-	raw_spin_lock_irqsave(&global_trace.start_lock, flags);
-	if (--global_trace.stop_count) {
-		if (global_trace.stop_count < 0) {
+	raw_spin_lock_irqsave(&tr->start_lock, flags);
+	if (--tr->stop_count) {
+		if (WARN_ON_ONCE(tr->stop_count < 0)) {
 			/* Someone screwed up their debugging */
-			WARN_ON_ONCE(1);
-			global_trace.stop_count = 0;
+			tr->stop_count = 0;
 		}
 		goto out;
 	}
 
 	/* Prevent the buffers from switching */
-	arch_spin_lock(&global_trace.max_lock);
+	arch_spin_lock(&tr->max_lock);
 
-	buffer = global_trace.array_buffer.buffer;
+	buffer = tr->array_buffer.buffer;
 	if (buffer)
 		ring_buffer_record_enable(buffer);
 
 #ifdef CONFIG_TRACER_MAX_TRACE
-	buffer = global_trace.max_buffer.buffer;
+	buffer = tr->max_buffer.buffer;
 	if (buffer)
 		ring_buffer_record_enable(buffer);
 #endif
 
-	arch_spin_unlock(&global_trace.max_lock);
-
- out:
-	raw_spin_unlock_irqrestore(&global_trace.start_lock, flags);
-}
-
-static void tracing_start_tr(struct trace_array *tr)
-{
-	struct trace_buffer *buffer;
-	unsigned long flags;
-
-	if (tracing_disabled)
-		return;
-
-	/* If global, we need to also start the max tracer */
-	if (tr->flags & TRACE_ARRAY_FL_GLOBAL)
-		return tracing_start();
-
-	raw_spin_lock_irqsave(&tr->start_lock, flags);
-
-	if (--tr->stop_count) {
-		if (tr->stop_count < 0) {
-			/* Someone screwed up their debugging */
-			WARN_ON_ONCE(1);
-			tr->stop_count = 0;
-		}
-		goto out;
-	}
-
-	buffer = tr->array_buffer.buffer;
-	if (buffer)
-		ring_buffer_record_enable(buffer);
+	arch_spin_unlock(&tr->max_lock);
 
  out:
 	raw_spin_unlock_irqrestore(&tr->start_lock, flags);
 }
 
 /**
- * tracing_stop - quick stop of the tracer
+ * tracing_start - quick start of the tracer
  *
- * Light weight way to stop tracing. Use in conjunction with
- * tracing_start.
+ * If tracing is enabled but was stopped by tracing_stop,
+ * this will start the tracer back up.
  */
-void tracing_stop(void)
+void tracing_start(void)
+
+{
+	return tracing_start_tr(&global_trace);
+}
+
+static void tracing_stop_tr(struct trace_array *tr)
 {
 	struct trace_buffer *buffer;
 	unsigned long flags;
 
-	raw_spin_lock_irqsave(&global_trace.start_lock, flags);
-	if (global_trace.stop_count++)
+	raw_spin_lock_irqsave(&tr->start_lock, flags);
+	if (tr->stop_count++)
 		goto out;
 
 	/* Prevent the buffers from switching */
-	arch_spin_lock(&global_trace.max_lock);
+	arch_spin_lock(&tr->max_lock);
 
-	buffer = global_trace.array_buffer.buffer;
+	buffer = tr->array_buffer.buffer;
 	if (buffer)
 		ring_buffer_record_disable(buffer);
 
 #ifdef CONFIG_TRACER_MAX_TRACE
-	buffer = global_trace.max_buffer.buffer;
+	buffer = tr->max_buffer.buffer;
 	if (buffer)
 		ring_buffer_record_disable(buffer);
 #endif
 
-	arch_spin_unlock(&global_trace.max_lock);
+	arch_spin_unlock(&tr->max_lock);
 
  out:
-	raw_spin_unlock_irqrestore(&global_trace.start_lock, flags);
+	raw_spin_unlock_irqrestore(&tr->start_lock, flags);
 }
 
-static void tracing_stop_tr(struct trace_array *tr)
+/**
+ * tracing_stop - quick stop of the tracer
+ *
+ * Light weight way to stop tracing. Use in conjunction with
+ * tracing_start.
+ */
+void tracing_stop(void)
 {
-	struct trace_buffer *buffer;
-	unsigned long flags;
-
-	/* If global, we need to also stop the max tracer */
-	if (tr->flags & TRACE_ARRAY_FL_GLOBAL)
-		return tracing_stop();
-
-	raw_spin_lock_irqsave(&tr->start_lock, flags);
-	if (tr->stop_count++)
-		goto out;
-
-	buffer = tr->array_buffer.buffer;
-	if (buffer)
-		ring_buffer_record_disable(buffer);
-
- out:
-	raw_spin_unlock_irqrestore(&tr->start_lock, flags);
+	return tracing_stop_tr(&global_trace);
 }
 
 static int trace_save_cmdline(struct task_struct *tsk)


