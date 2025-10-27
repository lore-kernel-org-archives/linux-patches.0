Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3813081AE;
	Mon, 27 Oct 2025 18:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591377; cv=none; b=H6UHg4r+JIUWDZ8ao272dQN1gMjgzkoII9qRFHcvMJJOR/mTXae695gcQBnUSOw/Kr6sX7I6vlaM2J9FgZI1OhTMevGjWst+GM9k5mFLQRNz+W2c03aaqVjV/Lom6K6ZT0z819ZSDEkJN6ADSaIfGdr4BSWls6hK4eRcTCq/QIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591377; c=relaxed/simple;
	bh=hMszEKO2MyfpOh8G0jssNo2jy6aViXR084Y4DD4ovMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TCaE2DlmIzUT8LTz+hRusxOAmN2qYI5xVNzNtzmXPpa/N/qWz/sRhaacoihtsBvudgZGPjNAZXlTKtrw6G8ZwuRNKKmGkFwFPjk5awb8YOr8UMSZiG4aSwuYj5unjEAehOotbo25t7Oydn1MWMjb4vZi+SgVUXa4hi2qO7L/dUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LsFdUN9y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LsFdUN9y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D51EC4CEF1;
	Mon, 27 Oct 2025 18:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591376;
	bh=hMszEKO2MyfpOh8G0jssNo2jy6aViXR084Y4DD4ovMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LsFdUN9y+geknia/4SxRxnHnWXM6j8p6kv0pIff8oBt0hT+CS4y+icj9UTBInmMFT
	 jSUmXoXEN+9SxLl+ThWFwUjWhJEknQ6S0jpSXhkrQqoN3dogxGkODJW58U/AU6ulzM
	 e/efdQBmEewT9UYtdZUhiqfQAmcad6ojBDiLTVPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 173/332] tracing: Fix race condition in kprobe initialization causing NULL pointer dereference
Date: Mon, 27 Oct 2025 19:33:46 +0100
Message-ID: <20251027183529.198853734@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
User-Agent: quilt/0.69
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Chen <chenyuan@kylinos.cn>

[ Upstream commit 9cf9aa7b0acfde7545c1a1d912576e9bab28dc6f ]

There is a critical race condition in kprobe initialization that can lead to
NULL pointer dereference and kernel crash.

[1135630.084782] Unable to handle kernel paging request at virtual address 0000710a04630000
...
[1135630.260314] pstate: 404003c9 (nZcv DAIF +PAN -UAO)
[1135630.269239] pc : kprobe_perf_func+0x30/0x260
[1135630.277643] lr : kprobe_dispatcher+0x44/0x60
[1135630.286041] sp : ffffaeff4977fa40
[1135630.293441] x29: ffffaeff4977fa40 x28: ffffaf015340e400
[1135630.302837] x27: 0000000000000000 x26: 0000000000000000
[1135630.312257] x25: ffffaf029ed108a8 x24: ffffaf015340e528
[1135630.321705] x23: ffffaeff4977fc50 x22: ffffaeff4977fc50
[1135630.331154] x21: 0000000000000000 x20: ffffaeff4977fc50
[1135630.340586] x19: ffffaf015340e400 x18: 0000000000000000
[1135630.349985] x17: 0000000000000000 x16: 0000000000000000
[1135630.359285] x15: 0000000000000000 x14: 0000000000000000
[1135630.368445] x13: 0000000000000000 x12: 0000000000000000
[1135630.377473] x11: 0000000000000000 x10: 0000000000000000
[1135630.386411] x9 : 0000000000000000 x8 : 0000000000000000
[1135630.395252] x7 : 0000000000000000 x6 : 0000000000000000
[1135630.403963] x5 : 0000000000000000 x4 : 0000000000000000
[1135630.412545] x3 : 0000710a04630000 x2 : 0000000000000006
[1135630.421021] x1 : ffffaeff4977fc50 x0 : 0000710a04630000
[1135630.429410] Call trace:
[1135630.434828]  kprobe_perf_func+0x30/0x260
[1135630.441661]  kprobe_dispatcher+0x44/0x60
[1135630.448396]  aggr_pre_handler+0x70/0xc8
[1135630.454959]  kprobe_breakpoint_handler+0x140/0x1e0
[1135630.462435]  brk_handler+0xbc/0xd8
[1135630.468437]  do_debug_exception+0x84/0x138
[1135630.475074]  el1_dbg+0x18/0x8c
[1135630.480582]  security_file_permission+0x0/0xd0
[1135630.487426]  vfs_write+0x70/0x1c0
[1135630.493059]  ksys_write+0x5c/0xc8
[1135630.498638]  __arm64_sys_write+0x24/0x30
[1135630.504821]  el0_svc_common+0x78/0x130
[1135630.510838]  el0_svc_handler+0x38/0x78
[1135630.516834]  el0_svc+0x8/0x1b0

kernel/trace/trace_kprobe.c: 1308
0xffff3df8995039ec <kprobe_perf_func+0x2c>:     ldr     x21, [x24,#120]
include/linux/compiler.h: 294
0xffff3df8995039f0 <kprobe_perf_func+0x30>:     ldr     x1, [x21,x0]

kernel/trace/trace_kprobe.c
1308: head = this_cpu_ptr(call->perf_events);
1309: if (hlist_empty(head))
1310: 	return 0;

crash> struct trace_event_call -o
struct trace_event_call {
  ...
  [120] struct hlist_head *perf_events;  //(call->perf_event)
  ...
}

crash> struct trace_event_call ffffaf015340e528
struct trace_event_call {
  ...
  perf_events = 0xffff0ad5fa89f088, //this value is correct, but x21 = 0
  ...
}

Race Condition Analysis:

The race occurs between kprobe activation and perf_events initialization:

  CPU0                                    CPU1
  ====                                    ====
  perf_kprobe_init
    perf_trace_event_init
      tp_event->perf_events = list;(1)
      tp_event->class->reg (2)← KPROBE ACTIVE
                                          Debug exception triggers
                                          ...
                                          kprobe_dispatcher
                                            kprobe_perf_func (tk->tp.flags & TP_FLAG_PROFILE)
                                              head = this_cpu_ptr(call->perf_events)(3)
                                              (perf_events is still NULL)

Problem:
1. CPU0 executes (1) assigning tp_event->perf_events = list
2. CPU0 executes (2) enabling kprobe functionality via class->reg()
3. CPU1 triggers and reaches kprobe_dispatcher
4. CPU1 checks TP_FLAG_PROFILE - condition passes (step 2 completed)
5. CPU1 calls kprobe_perf_func() and crashes at (3) because
   call->perf_events is still NULL

CPU1 sees that kprobe functionality is enabled but does not see that
perf_events has been assigned.

Add pairing read and write memory barriers to guarantee that if CPU1
sees that kprobe functionality is enabled, it must also see that
perf_events has been assigned.

Link: https://lore.kernel.org/all/20251001022025.44626-1-chenyuan_fl@163.com/

Fixes: 50d780560785 ("tracing/kprobes: Add probe handler dispatcher to support perf and ftrace concurrent use")
Cc: stable@vger.kernel.org
Signed-off-by: Yuan Chen <chenyuan@kylinos.cn>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
[ Dropped ftrace changes + context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_kprobe.c |   11 +++++++----
 kernel/trace/trace_probe.h  |    9 +++++++--
 kernel/trace/trace_uprobe.c |   12 ++++++++----
 3 files changed, 22 insertions(+), 10 deletions(-)

--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1782,14 +1782,15 @@ static int kprobe_register(struct trace_
 static int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs)
 {
 	struct trace_kprobe *tk = container_of(kp, struct trace_kprobe, rp.kp);
+	unsigned int flags = trace_probe_load_flag(&tk->tp);
 	int ret = 0;
 
 	raw_cpu_inc(*tk->nhit);
 
-	if (trace_probe_test_flag(&tk->tp, TP_FLAG_TRACE))
+	if (flags & TP_FLAG_TRACE)
 		kprobe_trace_func(tk, regs);
 #ifdef CONFIG_PERF_EVENTS
-	if (trace_probe_test_flag(&tk->tp, TP_FLAG_PROFILE))
+	if (flags & TP_FLAG_PROFILE)
 		ret = kprobe_perf_func(tk, regs);
 #endif
 	return ret;
@@ -1800,13 +1801,15 @@ static int
 kretprobe_dispatcher(struct kretprobe_instance *ri, struct pt_regs *regs)
 {
 	struct trace_kprobe *tk = container_of(ri->rp, struct trace_kprobe, rp);
+	unsigned int flags;
 
 	raw_cpu_inc(*tk->nhit);
 
-	if (trace_probe_test_flag(&tk->tp, TP_FLAG_TRACE))
+	flags = trace_probe_load_flag(&tk->tp);
+	if (flags & TP_FLAG_TRACE)
 		kretprobe_trace_func(tk, ri, regs);
 #ifdef CONFIG_PERF_EVENTS
-	if (trace_probe_test_flag(&tk->tp, TP_FLAG_PROFILE))
+	if (flags & TP_FLAG_PROFILE)
 		kretprobe_perf_func(tk, ri, regs);
 #endif
 	return 0;	/* We don't tweek kernel, so just return 0 */
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -251,16 +251,21 @@ struct event_file_link {
 	struct list_head		list;
 };
 
+static inline unsigned int trace_probe_load_flag(struct trace_probe *tp)
+{
+	return smp_load_acquire(&tp->event->flags);
+}
+
 static inline bool trace_probe_test_flag(struct trace_probe *tp,
 					 unsigned int flag)
 {
-	return !!(tp->event->flags & flag);
+	return !!(trace_probe_load_flag(tp) & flag);
 }
 
 static inline void trace_probe_set_flag(struct trace_probe *tp,
 					unsigned int flag)
 {
-	tp->event->flags |= flag;
+	smp_store_release(&tp->event->flags, tp->event->flags | flag);
 }
 
 static inline void trace_probe_clear_flag(struct trace_probe *tp,
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -1484,6 +1484,7 @@ static int uprobe_dispatcher(struct upro
 	struct uprobe_dispatch_data udd;
 	struct uprobe_cpu_buffer *ucb;
 	int dsize, esize;
+	unsigned int flags;
 	int ret = 0;
 
 
@@ -1504,11 +1505,12 @@ static int uprobe_dispatcher(struct upro
 	ucb = uprobe_buffer_get();
 	store_trace_args(ucb->buf, &tu->tp, regs, esize, dsize);
 
-	if (trace_probe_test_flag(&tu->tp, TP_FLAG_TRACE))
+	flags = trace_probe_load_flag(&tu->tp);
+	if (flags & TP_FLAG_TRACE)
 		ret |= uprobe_trace_func(tu, regs, ucb, dsize);
 
 #ifdef CONFIG_PERF_EVENTS
-	if (trace_probe_test_flag(&tu->tp, TP_FLAG_PROFILE))
+	if (flags & TP_FLAG_PROFILE)
 		ret |= uprobe_perf_func(tu, regs, ucb, dsize);
 #endif
 	uprobe_buffer_put(ucb);
@@ -1522,6 +1524,7 @@ static int uretprobe_dispatcher(struct u
 	struct uprobe_dispatch_data udd;
 	struct uprobe_cpu_buffer *ucb;
 	int dsize, esize;
+	unsigned int flags;
 
 	tu = container_of(con, struct trace_uprobe, consumer);
 
@@ -1539,11 +1542,12 @@ static int uretprobe_dispatcher(struct u
 	ucb = uprobe_buffer_get();
 	store_trace_args(ucb->buf, &tu->tp, regs, esize, dsize);
 
-	if (trace_probe_test_flag(&tu->tp, TP_FLAG_TRACE))
+	flags = trace_probe_load_flag(&tu->tp);
+	if (flags & TP_FLAG_TRACE)
 		uretprobe_trace_func(tu, func, regs, ucb, dsize);
 
 #ifdef CONFIG_PERF_EVENTS
-	if (trace_probe_test_flag(&tu->tp, TP_FLAG_PROFILE))
+	if (flags & TP_FLAG_PROFILE)
 		uretprobe_perf_func(tu, func, regs, ucb, dsize);
 #endif
 	uprobe_buffer_put(ucb);


