Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E0818E03A;
	Mon, 28 Oct 2024 06:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097703; cv=none; b=GTgXjfi+6tBp6KXNdNjf8TqjThqyA0+98dIjWZSCkH0Mo9YRad5nlb5Y33aHYtSQV0jD2+lm4rjSXKjplcisgBt973GoDPONK5ZtZz9ng7ZCc4LZ37cM9JMw3sb8NgIM22yDZaDc/9YrgtixIVJza32Hd3er6Z8BRxGx7Fn6BSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097703; c=relaxed/simple;
	bh=h6WzeSPZBwmxJzKR4qYX6BoXvvGelif527fUMj3NjOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BDSldrNYzLsDOWdCsWmufHaHXU+FVJIqx8EB9OLsA3Mg5JgeNLX77fPebc42368U/SDasgXNrTwzok6Hby1g5sWOfNjJSBEqiBvePt8maFX7yyYWeiCPFfk4DLlbX7kB18Ou4omHTd54y4wY5/L7bE66Z+ZQ28ol0hx42H4Q93k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=un/3B3zG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="un/3B3zG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8A0C4CEC3;
	Mon, 28 Oct 2024 06:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097703;
	bh=h6WzeSPZBwmxJzKR4qYX6BoXvvGelif527fUMj3NjOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=un/3B3zGT+ZiEKovTpr4MQcf1a7mBNh0GwkoT5BSzZQ43QPkTJ2uvBOJFrPckK080
	 OvALkSqdJKBXRnn7u1vCdRiXh7TYeGpkxDWAdkrvq1LHOdZWGh+9YcPnuRQGcWH6Vs
	 u0nB/Jc583t6astUQEXLY6iMO31GAUEDHEr7eJOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 111/208] uprobes: prepare uprobe args buffer lazily
Date: Mon, 28 Oct 2024 07:24:51 +0100
Message-ID: <20241028062309.391594665@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 1b8f85defbc82e2eb8f27c5f6060ea507ad4d5a3 ]

uprobe_cpu_buffer and corresponding logic to store uprobe args into it
are used for uprobes/uretprobes that are created through tracefs or
perf events.

BPF is yet another user of uprobe/uretprobe infrastructure, but doesn't
need uprobe_cpu_buffer and associated data. For BPF-only use cases this
buffer handling and preparation is a pure overhead. At the same time,
BPF-only uprobe/uretprobe usage is very common in practice. Also, for
a lot of cases applications are very senstivie to performance overheads,
as they might be tracing a very high frequency functions like
malloc()/free(), so every bit of performance improvement matters.

All that is to say that this uprobe_cpu_buffer preparation is an
unnecessary overhead that each BPF user of uprobes/uretprobe has to pay.
This patch is changing this by making uprobe_cpu_buffer preparation
optional. It will happen only if either tracefs-based or perf event-based
uprobe/uretprobe consumer is registered for given uprobe/uretprobe. For
BPF-only use cases this step will be skipped.

We used uprobe/uretprobe benchmark which is part of BPF selftests (see [0])
to estimate the improvements. We have 3 uprobe and 3 uretprobe
scenarios, which vary an instruction that is replaced by uprobe: nop
(fastest uprobe case), `push rbp` (typical case), and non-simulated
`ret` instruction (slowest case). Benchmark thread is constantly calling
user space function in a tight loop. User space function has attached
BPF uprobe or uretprobe program doing nothing but atomic counter
increments to count number of triggering calls. Benchmark emits
throughput in millions of executions per second.

BEFORE these changes
====================
uprobe-nop     :    2.657 ± 0.024M/s
uprobe-push    :    2.499 ± 0.018M/s
uprobe-ret     :    1.100 ± 0.006M/s
uretprobe-nop  :    1.356 ± 0.004M/s
uretprobe-push :    1.317 ± 0.019M/s
uretprobe-ret  :    0.785 ± 0.007M/s

AFTER these changes
===================
uprobe-nop     :    2.732 ± 0.022M/s (+2.8%)
uprobe-push    :    2.621 ± 0.016M/s (+4.9%)
uprobe-ret     :    1.105 ± 0.007M/s (+0.5%)
uretprobe-nop  :    1.396 ± 0.007M/s (+2.9%)
uretprobe-push :    1.347 ± 0.008M/s (+2.3%)
uretprobe-ret  :    0.800 ± 0.006M/s (+1.9)

So the improvements on this particular machine seems to be between 2% and 5%.

  [0] https://github.com/torvalds/linux/blob/master/tools/testing/selftests/bpf/benchs/bench_trigger.c

Reviewed-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/all/20240318181728.2795838-3-andrii@kernel.org/

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Stable-dep-of: 373b9338c972 ("uprobe: avoid out-of-bounds memory access of fetching args")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_uprobe.c | 49 +++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 21 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 58506c9632eae..6c2ab0e316d6a 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -941,15 +941,21 @@ static struct uprobe_cpu_buffer *uprobe_buffer_get(void)
 
 static void uprobe_buffer_put(struct uprobe_cpu_buffer *ucb)
 {
+	if (!ucb)
+		return;
 	mutex_unlock(&ucb->mutex);
 }
 
 static struct uprobe_cpu_buffer *prepare_uprobe_buffer(struct trace_uprobe *tu,
-						       struct pt_regs *regs)
+						       struct pt_regs *regs,
+						       struct uprobe_cpu_buffer **ucbp)
 {
 	struct uprobe_cpu_buffer *ucb;
 	int dsize, esize;
 
+	if (*ucbp)
+		return *ucbp;
+
 	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
 	dsize = __get_data_size(&tu->tp, regs, NULL);
 
@@ -958,22 +964,25 @@ static struct uprobe_cpu_buffer *prepare_uprobe_buffer(struct trace_uprobe *tu,
 
 	store_trace_args(ucb->buf, &tu->tp, regs, NULL, esize, dsize);
 
+	*ucbp = ucb;
 	return ucb;
 }
 
 static void __uprobe_trace_func(struct trace_uprobe *tu,
 				unsigned long func, struct pt_regs *regs,
-				struct uprobe_cpu_buffer *ucb,
+				struct uprobe_cpu_buffer **ucbp,
 				struct trace_event_file *trace_file)
 {
 	struct uprobe_trace_entry_head *entry;
 	struct trace_event_buffer fbuffer;
+	struct uprobe_cpu_buffer *ucb;
 	void *data;
 	int size, esize;
 	struct trace_event_call *call = trace_probe_event_call(&tu->tp);
 
 	WARN_ON(call != trace_file->event_call);
 
+	ucb = prepare_uprobe_buffer(tu, regs, ucbp);
 	if (WARN_ON_ONCE(ucb->dsize > PAGE_SIZE))
 		return;
 
@@ -1002,7 +1011,7 @@ static void __uprobe_trace_func(struct trace_uprobe *tu,
 
 /* uprobe handler */
 static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs,
-			     struct uprobe_cpu_buffer *ucb)
+			     struct uprobe_cpu_buffer **ucbp)
 {
 	struct event_file_link *link;
 
@@ -1011,7 +1020,7 @@ static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs,
 
 	rcu_read_lock();
 	trace_probe_for_each_link_rcu(link, &tu->tp)
-		__uprobe_trace_func(tu, 0, regs, ucb, link->file);
+		__uprobe_trace_func(tu, 0, regs, ucbp, link->file);
 	rcu_read_unlock();
 
 	return 0;
@@ -1019,13 +1028,13 @@ static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs,
 
 static void uretprobe_trace_func(struct trace_uprobe *tu, unsigned long func,
 				 struct pt_regs *regs,
-				 struct uprobe_cpu_buffer *ucb)
+				 struct uprobe_cpu_buffer **ucbp)
 {
 	struct event_file_link *link;
 
 	rcu_read_lock();
 	trace_probe_for_each_link_rcu(link, &tu->tp)
-		__uprobe_trace_func(tu, func, regs, ucb, link->file);
+		__uprobe_trace_func(tu, func, regs, ucbp, link->file);
 	rcu_read_unlock();
 }
 
@@ -1353,10 +1362,11 @@ static bool uprobe_perf_filter(struct uprobe_consumer *uc,
 
 static void __uprobe_perf_func(struct trace_uprobe *tu,
 			       unsigned long func, struct pt_regs *regs,
-			       struct uprobe_cpu_buffer *ucb)
+			       struct uprobe_cpu_buffer **ucbp)
 {
 	struct trace_event_call *call = trace_probe_event_call(&tu->tp);
 	struct uprobe_trace_entry_head *entry;
+	struct uprobe_cpu_buffer *ucb;
 	struct hlist_head *head;
 	void *data;
 	int size, esize;
@@ -1374,6 +1384,7 @@ static void __uprobe_perf_func(struct trace_uprobe *tu,
 
 	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
 
+	ucb = prepare_uprobe_buffer(tu, regs, ucbp);
 	size = esize + ucb->dsize;
 	size = ALIGN(size + sizeof(u32), sizeof(u64)) - sizeof(u32);
 	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE, "profile buffer not large enough"))
@@ -1410,21 +1421,21 @@ static void __uprobe_perf_func(struct trace_uprobe *tu,
 
 /* uprobe profile handler */
 static int uprobe_perf_func(struct trace_uprobe *tu, struct pt_regs *regs,
-			    struct uprobe_cpu_buffer *ucb)
+			    struct uprobe_cpu_buffer **ucbp)
 {
 	if (!uprobe_perf_filter(&tu->consumer, 0, current->mm))
 		return UPROBE_HANDLER_REMOVE;
 
 	if (!is_ret_probe(tu))
-		__uprobe_perf_func(tu, 0, regs, ucb);
+		__uprobe_perf_func(tu, 0, regs, ucbp);
 	return 0;
 }
 
 static void uretprobe_perf_func(struct trace_uprobe *tu, unsigned long func,
 				struct pt_regs *regs,
-				struct uprobe_cpu_buffer *ucb)
+				struct uprobe_cpu_buffer **ucbp)
 {
-	__uprobe_perf_func(tu, func, regs, ucb);
+	__uprobe_perf_func(tu, func, regs, ucbp);
 }
 
 int bpf_get_uprobe_info(const struct perf_event *event, u32 *fd_type,
@@ -1489,7 +1500,7 @@ static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
 {
 	struct trace_uprobe *tu;
 	struct uprobe_dispatch_data udd;
-	struct uprobe_cpu_buffer *ucb;
+	struct uprobe_cpu_buffer *ucb = NULL;
 	int ret = 0;
 
 	tu = container_of(con, struct trace_uprobe, consumer);
@@ -1503,14 +1514,12 @@ static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
 	if (WARN_ON_ONCE(!uprobe_cpu_buffer))
 		return 0;
 
-	ucb = prepare_uprobe_buffer(tu, regs);
-
 	if (trace_probe_test_flag(&tu->tp, TP_FLAG_TRACE))
-		ret |= uprobe_trace_func(tu, regs, ucb);
+		ret |= uprobe_trace_func(tu, regs, &ucb);
 
 #ifdef CONFIG_PERF_EVENTS
 	if (trace_probe_test_flag(&tu->tp, TP_FLAG_PROFILE))
-		ret |= uprobe_perf_func(tu, regs, ucb);
+		ret |= uprobe_perf_func(tu, regs, &ucb);
 #endif
 	uprobe_buffer_put(ucb);
 	return ret;
@@ -1521,7 +1530,7 @@ static int uretprobe_dispatcher(struct uprobe_consumer *con,
 {
 	struct trace_uprobe *tu;
 	struct uprobe_dispatch_data udd;
-	struct uprobe_cpu_buffer *ucb;
+	struct uprobe_cpu_buffer *ucb = NULL;
 
 	tu = container_of(con, struct trace_uprobe, consumer);
 
@@ -1533,14 +1542,12 @@ static int uretprobe_dispatcher(struct uprobe_consumer *con,
 	if (WARN_ON_ONCE(!uprobe_cpu_buffer))
 		return 0;
 
-	ucb = prepare_uprobe_buffer(tu, regs);
-
 	if (trace_probe_test_flag(&tu->tp, TP_FLAG_TRACE))
-		uretprobe_trace_func(tu, func, regs, ucb);
+		uretprobe_trace_func(tu, func, regs, &ucb);
 
 #ifdef CONFIG_PERF_EVENTS
 	if (trace_probe_test_flag(&tu->tp, TP_FLAG_PROFILE))
-		uretprobe_perf_func(tu, func, regs, ucb);
+		uretprobe_perf_func(tu, func, regs, &ucb);
 #endif
 	uprobe_buffer_put(ucb);
 	return 0;
-- 
2.43.0



