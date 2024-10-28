Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23FE18E04F;
	Mon, 28 Oct 2024 06:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097701; cv=none; b=qROVDroXyOTqnwWASHKrBm+2gg9Arm16C8X4yphFiMUik+8r78PMqzY38NpXdorPJoLYNdUswRBECbFrD911NgMqeqQFAO1FbGV93xgFUvty4GYYTRsnN+IHqBJTa8xZwb3bmT6gz52KWUitHzq7KYDyV+iPJFAhyIjlS4Yr35Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097701; c=relaxed/simple;
	bh=W3urXZBcaIi9AEenuT/etlqPa6OmxHGRLUTBKLfYpfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLy7xNPvCqhriyCmeQKzQYLq5ZrxqLuAK7XCzeRypE7Zm6An+XMQjwR5munTmHJkasHw9N3Qd7HgV+2Sa/TnuWDXcgtCJXV/Mpj6fdGsNPk4rdwtomoiujEKZeIbZc1p53Lu3RR+o1u06QbzzEaN+uPjykrNZ2gAHiAqtQze5bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WxYhmt+r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WxYhmt+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92207C4CEC3;
	Mon, 28 Oct 2024 06:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097700;
	bh=W3urXZBcaIi9AEenuT/etlqPa6OmxHGRLUTBKLfYpfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WxYhmt+rvwhDsqYCcYqLn2vcrWIwUPIf3Q245ieLK2AtgQRYlUF0C/+RryZFG7nyi
	 u9N1pxIlz+m//qwIqRkkP83PPIAKPKAMRoq8msPQhxT/3AvUEqHclm5NwJcCP7UaZp
	 natzyXMg/Y/Km8JFuHi54VJxp4jS8Ijphhg0XmfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 110/208] uprobes: encapsulate preparation of uprobe args buffer
Date: Mon, 28 Oct 2024 07:24:50 +0100
Message-ID: <20241028062309.368306926@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 3eaea21b4d27cff0017c20549aeb53034c58fc23 ]

Move the logic of fetching temporary per-CPU uprobe buffer and storing
uprobes args into it to a new helper function. Store data size as part
of this buffer, simplifying interfaces a bit, as now we only pass single
uprobe_cpu_buffer reference around, instead of pointer + dsize.

This logic was duplicated across uprobe_dispatcher and uretprobe_dispatcher,
and now will be centralized. All this is also in preparation to make
this uprobe_cpu_buffer handling logic optional in the next patch.

Link: https://lore.kernel.org/all/20240318181728.2795838-2-andrii@kernel.org/
[Masami: update for v6.9-rc3 kernel]

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Stable-dep-of: 373b9338c972 ("uprobe: avoid out-of-bounds memory access of fetching args")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_uprobe.c | 78 +++++++++++++++++++------------------
 1 file changed, 41 insertions(+), 37 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 78d76d74f45bc..58506c9632eae 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -854,6 +854,7 @@ static const struct file_operations uprobe_profile_ops = {
 struct uprobe_cpu_buffer {
 	struct mutex mutex;
 	void *buf;
+	int dsize;
 };
 static struct uprobe_cpu_buffer __percpu *uprobe_cpu_buffer;
 static int uprobe_buffer_refcnt;
@@ -943,9 +944,26 @@ static void uprobe_buffer_put(struct uprobe_cpu_buffer *ucb)
 	mutex_unlock(&ucb->mutex);
 }
 
+static struct uprobe_cpu_buffer *prepare_uprobe_buffer(struct trace_uprobe *tu,
+						       struct pt_regs *regs)
+{
+	struct uprobe_cpu_buffer *ucb;
+	int dsize, esize;
+
+	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
+	dsize = __get_data_size(&tu->tp, regs, NULL);
+
+	ucb = uprobe_buffer_get();
+	ucb->dsize = tu->tp.size + dsize;
+
+	store_trace_args(ucb->buf, &tu->tp, regs, NULL, esize, dsize);
+
+	return ucb;
+}
+
 static void __uprobe_trace_func(struct trace_uprobe *tu,
 				unsigned long func, struct pt_regs *regs,
-				struct uprobe_cpu_buffer *ucb, int dsize,
+				struct uprobe_cpu_buffer *ucb,
 				struct trace_event_file *trace_file)
 {
 	struct uprobe_trace_entry_head *entry;
@@ -956,14 +974,14 @@ static void __uprobe_trace_func(struct trace_uprobe *tu,
 
 	WARN_ON(call != trace_file->event_call);
 
-	if (WARN_ON_ONCE(tu->tp.size + dsize > PAGE_SIZE))
+	if (WARN_ON_ONCE(ucb->dsize > PAGE_SIZE))
 		return;
 
 	if (trace_trigger_soft_disabled(trace_file))
 		return;
 
 	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
-	size = esize + tu->tp.size + dsize;
+	size = esize + ucb->dsize;
 	entry = trace_event_buffer_reserve(&fbuffer, trace_file, size);
 	if (!entry)
 		return;
@@ -977,14 +995,14 @@ static void __uprobe_trace_func(struct trace_uprobe *tu,
 		data = DATAOF_TRACE_ENTRY(entry, false);
 	}
 
-	memcpy(data, ucb->buf, tu->tp.size + dsize);
+	memcpy(data, ucb->buf, ucb->dsize);
 
 	trace_event_buffer_commit(&fbuffer);
 }
 
 /* uprobe handler */
 static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs,
-			     struct uprobe_cpu_buffer *ucb, int dsize)
+			     struct uprobe_cpu_buffer *ucb)
 {
 	struct event_file_link *link;
 
@@ -993,7 +1011,7 @@ static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs,
 
 	rcu_read_lock();
 	trace_probe_for_each_link_rcu(link, &tu->tp)
-		__uprobe_trace_func(tu, 0, regs, ucb, dsize, link->file);
+		__uprobe_trace_func(tu, 0, regs, ucb, link->file);
 	rcu_read_unlock();
 
 	return 0;
@@ -1001,13 +1019,13 @@ static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs,
 
 static void uretprobe_trace_func(struct trace_uprobe *tu, unsigned long func,
 				 struct pt_regs *regs,
-				 struct uprobe_cpu_buffer *ucb, int dsize)
+				 struct uprobe_cpu_buffer *ucb)
 {
 	struct event_file_link *link;
 
 	rcu_read_lock();
 	trace_probe_for_each_link_rcu(link, &tu->tp)
-		__uprobe_trace_func(tu, func, regs, ucb, dsize, link->file);
+		__uprobe_trace_func(tu, func, regs, ucb, link->file);
 	rcu_read_unlock();
 }
 
@@ -1335,7 +1353,7 @@ static bool uprobe_perf_filter(struct uprobe_consumer *uc,
 
 static void __uprobe_perf_func(struct trace_uprobe *tu,
 			       unsigned long func, struct pt_regs *regs,
-			       struct uprobe_cpu_buffer *ucb, int dsize)
+			       struct uprobe_cpu_buffer *ucb)
 {
 	struct trace_event_call *call = trace_probe_event_call(&tu->tp);
 	struct uprobe_trace_entry_head *entry;
@@ -1356,7 +1374,7 @@ static void __uprobe_perf_func(struct trace_uprobe *tu,
 
 	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
 
-	size = esize + tu->tp.size + dsize;
+	size = esize + ucb->dsize;
 	size = ALIGN(size + sizeof(u32), sizeof(u64)) - sizeof(u32);
 	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE, "profile buffer not large enough"))
 		return;
@@ -1379,13 +1397,10 @@ static void __uprobe_perf_func(struct trace_uprobe *tu,
 		data = DATAOF_TRACE_ENTRY(entry, false);
 	}
 
-	memcpy(data, ucb->buf, tu->tp.size + dsize);
+	memcpy(data, ucb->buf, ucb->dsize);
 
-	if (size - esize > tu->tp.size + dsize) {
-		int len = tu->tp.size + dsize;
-
-		memset(data + len, 0, size - esize - len);
-	}
+	if (size - esize > ucb->dsize)
+		memset(data + ucb->dsize, 0, size - esize - ucb->dsize);
 
 	perf_trace_buf_submit(entry, size, rctx, call->event.type, 1, regs,
 			      head, NULL);
@@ -1395,21 +1410,21 @@ static void __uprobe_perf_func(struct trace_uprobe *tu,
 
 /* uprobe profile handler */
 static int uprobe_perf_func(struct trace_uprobe *tu, struct pt_regs *regs,
-			    struct uprobe_cpu_buffer *ucb, int dsize)
+			    struct uprobe_cpu_buffer *ucb)
 {
 	if (!uprobe_perf_filter(&tu->consumer, 0, current->mm))
 		return UPROBE_HANDLER_REMOVE;
 
 	if (!is_ret_probe(tu))
-		__uprobe_perf_func(tu, 0, regs, ucb, dsize);
+		__uprobe_perf_func(tu, 0, regs, ucb);
 	return 0;
 }
 
 static void uretprobe_perf_func(struct trace_uprobe *tu, unsigned long func,
 				struct pt_regs *regs,
-				struct uprobe_cpu_buffer *ucb, int dsize)
+				struct uprobe_cpu_buffer *ucb)
 {
-	__uprobe_perf_func(tu, func, regs, ucb, dsize);
+	__uprobe_perf_func(tu, func, regs, ucb);
 }
 
 int bpf_get_uprobe_info(const struct perf_event *event, u32 *fd_type,
@@ -1475,10 +1490,8 @@ static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
 	struct trace_uprobe *tu;
 	struct uprobe_dispatch_data udd;
 	struct uprobe_cpu_buffer *ucb;
-	int dsize, esize;
 	int ret = 0;
 
-
 	tu = container_of(con, struct trace_uprobe, consumer);
 	tu->nhit++;
 
@@ -1490,18 +1503,14 @@ static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
 	if (WARN_ON_ONCE(!uprobe_cpu_buffer))
 		return 0;
 
-	dsize = __get_data_size(&tu->tp, regs, NULL);
-	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
-
-	ucb = uprobe_buffer_get();
-	store_trace_args(ucb->buf, &tu->tp, regs, NULL, esize, dsize);
+	ucb = prepare_uprobe_buffer(tu, regs);
 
 	if (trace_probe_test_flag(&tu->tp, TP_FLAG_TRACE))
-		ret |= uprobe_trace_func(tu, regs, ucb, dsize);
+		ret |= uprobe_trace_func(tu, regs, ucb);
 
 #ifdef CONFIG_PERF_EVENTS
 	if (trace_probe_test_flag(&tu->tp, TP_FLAG_PROFILE))
-		ret |= uprobe_perf_func(tu, regs, ucb, dsize);
+		ret |= uprobe_perf_func(tu, regs, ucb);
 #endif
 	uprobe_buffer_put(ucb);
 	return ret;
@@ -1513,7 +1522,6 @@ static int uretprobe_dispatcher(struct uprobe_consumer *con,
 	struct trace_uprobe *tu;
 	struct uprobe_dispatch_data udd;
 	struct uprobe_cpu_buffer *ucb;
-	int dsize, esize;
 
 	tu = container_of(con, struct trace_uprobe, consumer);
 
@@ -1525,18 +1533,14 @@ static int uretprobe_dispatcher(struct uprobe_consumer *con,
 	if (WARN_ON_ONCE(!uprobe_cpu_buffer))
 		return 0;
 
-	dsize = __get_data_size(&tu->tp, regs, NULL);
-	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
-
-	ucb = uprobe_buffer_get();
-	store_trace_args(ucb->buf, &tu->tp, regs, NULL, esize, dsize);
+	ucb = prepare_uprobe_buffer(tu, regs);
 
 	if (trace_probe_test_flag(&tu->tp, TP_FLAG_TRACE))
-		uretprobe_trace_func(tu, func, regs, ucb, dsize);
+		uretprobe_trace_func(tu, func, regs, ucb);
 
 #ifdef CONFIG_PERF_EVENTS
 	if (trace_probe_test_flag(&tu->tp, TP_FLAG_PROFILE))
-		uretprobe_perf_func(tu, func, regs, ucb, dsize);
+		uretprobe_perf_func(tu, func, regs, ucb);
 #endif
 	uprobe_buffer_put(ucb);
 	return 0;
-- 
2.43.0



