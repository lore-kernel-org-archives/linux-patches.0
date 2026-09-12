Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0BA7364038;
	Sat, 12 Sep 2026 09:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205561; cv=none; b=DyaEU/+eKfv7re9BzJz3sdTA05RZXyQkfUJEbJPqaC6y7siG3OTfUaKCvFjKYCl8cZvK1SFlYTfhPyGMni3lKE4t+nzmVHa+OC9RRFXM11o7dCBiiP9gFJ8WV3ax0J7LfJpvjZW/LCRBStRScLcaJ9jr+sNGwGtfSjpqOwiJkMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205561; c=relaxed/simple;
	bh=asSU820FXukQjntt6S5yRE2WHzFjLC1oom5BfGrFsy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TpEwCpFX6qN9LZ3N6o2w3bAh2rj4Trov50+Txg2j1OTcqfdUIHKKC/99bbjZq5qOYJP0Kq0JBtyd527dpCPcIjv7yOtl/1XY83hLHi7Ksf9+CKIp9kGGBgu7uLEpNpKjUy9MqFrrZHkJ9T4pYDxHHdNfvjJ9yuqizUez5mO5el8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OzrK4rCm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OzrK4rCm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9941F000FF;
	Sat, 12 Sep 2026 09:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205559;
	bh=fs2ncthn4eFfxiq08f1h2z1PDeUC6hQHQm28uk2EFwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OzrK4rCmW7mJ+90iLqlIOaqtuE0ylW8I+6p9LYRqKkk0f3fwIShgR3OB23LsC8P4Y
	 ah6Gy6LZr+4j2/VWC6kfyU7BnhfkQjFmq4bgsMRWVvGr3ah50TwwAMfd67Gw8JqGEe
	 mXzY1OEhRy2bBKCwRZngMQnkNbDj2uzOzoS91EQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0027/1518] tracing: Clean up use of trace_create_maxlat_file()
Date: Sat, 12 Sep 2026 08:36:36 +0200
Message-ID: <20260912065624.036743582@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

[ Upstream commit ba73713da50e5c24499ca8941171593466ea34f7 ]

In trace.c, the function trace_create_maxlat_file() is defined behind the
 #ifdef CONFIG_TRACER_MAX_TRACE block. The #else part defines it as:

 #define trace_create_maxlat_file(tr, d_tracer)				\
	trace_create_file("tracing_max_latency", TRACE_MODE_WRITE,	\
			  d_tracer, tr, &tracing_max_lat_fops)

But the one place that it it used has:

 #ifdef CONFIG_TRACER_MAX_TRACE
	trace_create_maxlat_file(tr, d_tracer);
 #endif

Which is pointless and also wrong!

It only gets created when both CONFIG_TRACE_MAX_TRACE and CONFIG_FS_NOTIFY
is defined, but the file itself should not be dependent on
CONFIG_FS_NOTIFY. Always create that file when TRACE_MAX_TRACE is defined
regardless if FS_NOTIFY is or is not.

Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Link: https://patch.msgid.link/20260207191101.0e014abd@robin
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: f2951ebd15c3 ("tracing: Take trace_array reference when opening options file")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |   38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1904,10 +1904,7 @@ static ssize_t trace_seq_to_buffer(struc
 unsigned long __read_mostly	tracing_thresh;
 
 #ifdef CONFIG_TRACER_MAX_TRACE
-static const struct file_operations tracing_max_lat_fops;
-
 #ifdef LATENCY_FS_NOTIFY
-
 static struct workqueue_struct *fsnotify_wq;
 
 static void latency_fsnotify_workfn(struct work_struct *work)
@@ -1924,17 +1921,6 @@ static void latency_fsnotify_workfn_irq(
 	queue_work(fsnotify_wq, &tr->fsnotify_work);
 }
 
-static void trace_create_maxlat_file(struct trace_array *tr,
-				     struct dentry *d_tracer)
-{
-	INIT_WORK(&tr->fsnotify_work, latency_fsnotify_workfn);
-	init_irq_work(&tr->fsnotify_irqwork, latency_fsnotify_workfn_irq);
-	tr->d_max_latency = trace_create_file("tracing_max_latency",
-					      TRACE_MODE_WRITE,
-					      d_tracer, tr,
-					      &tracing_max_lat_fops);
-}
-
 __init static int latency_fsnotify_init(void)
 {
 	fsnotify_wq = alloc_workqueue("tr_max_lat_wq",
@@ -1959,14 +1945,22 @@ void latency_fsnotify(struct trace_array
 	 */
 	irq_work_queue(&tr->fsnotify_irqwork);
 }
+#endif /* !LATENCY_FS_NOTIFY */
 
-#else /* !LATENCY_FS_NOTIFY */
-
-#define trace_create_maxlat_file(tr, d_tracer)				\
-	trace_create_file("tracing_max_latency", TRACE_MODE_WRITE,	\
-			  d_tracer, tr, &tracing_max_lat_fops)
+static const struct file_operations tracing_max_lat_fops;
 
+static void trace_create_maxlat_file(struct trace_array *tr,
+				     struct dentry *d_tracer)
+{
+#ifdef LATENCY_FS_NOTIFY
+	INIT_WORK(&tr->fsnotify_work, latency_fsnotify_workfn);
+	init_irq_work(&tr->fsnotify_irqwork, latency_fsnotify_workfn_irq);
 #endif
+	tr->d_max_latency = trace_create_file("tracing_max_latency",
+					      TRACE_MODE_WRITE,
+					      d_tracer, tr,
+					      &tracing_max_lat_fops);
+}
 
 /*
  * Copy the new maximum trace into the separate maximum-trace
@@ -2101,7 +2095,9 @@ update_max_tr_single(struct trace_array
 	__update_max_tr(tr, tsk, cpu);
 	arch_spin_unlock(&tr->max_lock);
 }
-
+#else /* !CONFIG_TRACER_MAX_TRACE */
+static inline void trace_create_maxlat_file(struct trace_array *tr,
+					    struct dentry *d_tracer) { }
 #endif /* CONFIG_TRACER_MAX_TRACE */
 
 struct pipe_wait {
@@ -10392,9 +10388,7 @@ init_tracer_tracefs(struct trace_array *
 
 	create_trace_options_dir(tr);
 
-#ifdef CONFIG_TRACER_MAX_TRACE
 	trace_create_maxlat_file(tr, d_tracer);
-#endif
 
 	if (ftrace_create_function_files(tr, d_tracer))
 		MEM_FAIL(1, "Could not allocate function filter files");


