Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE5B15B10D;
	Mon, 28 Oct 2024 06:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097705; cv=none; b=ZTFOClx+fA+LdkVPJGDHjYboB3a/SQmXozYdRgnohCCHf2blBeCjYkIdSN9s5HIcImWPO2LwxTO+kR2GNQJXeXMOFcKto9IpFe221yzFvGO9RKjxWbd3128HHEAUXs54KTec+hB+SzxoSY0hQbxv1KmI47ehjoRUlw/X1RUY4LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097705; c=relaxed/simple;
	bh=gTO/Jxpat3+yd/v5HklZIi/RsrxW7hRMx0TYLo6kl28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g8d3uS2b15GoVti/GiFpOH8osgnTJ7CAkFlf7CcOVFp9KvTysr5f0utAJd1hDXWGWMihCYuadP0Po3L/Tx6G2wglCTa4opPfdOghO262YLkDLMZ64k7ginkkbDSh5X7JnJuWlFhR7nIlGvAE9YnH2vo5079mAvhLiUEtXtrlkZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MqxAmQjR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MqxAmQjR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB01C4CEC3;
	Mon, 28 Oct 2024 06:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097705;
	bh=gTO/Jxpat3+yd/v5HklZIi/RsrxW7hRMx0TYLo6kl28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MqxAmQjRXFJUFNOvxxvILaNUHruBDngKB0rcZHgpYUMcUci784bSAWlEOHxMl32KS
	 e521h1A0TvLJ3AHyP03j6DdPPrSCr0yyKQvG625udQV+MOzeHNO66jCJByxUKkbdRf
	 4oMzP5L+Q0XUDGrzmzKZJWBNI23yF93k7avrrmEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 112/208] uprobes: prevent mutex_lock() under rcu_read_lock()
Date: Mon, 28 Oct 2024 07:24:52 +0100
Message-ID: <20241028062309.415389381@linuxfoundation.org>
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

[ Upstream commit 699646734ab51bf5b1cd4a7a30c20074f6e74f6e ]

Recent changes made uprobe_cpu_buffer preparation lazy, and moved it
deeper into __uprobe_trace_func(). This is problematic because
__uprobe_trace_func() is called inside rcu_read_lock()/rcu_read_unlock()
block, which then calls prepare_uprobe_buffer() -> uprobe_buffer_get() ->
mutex_lock(&ucb->mutex), leading to a splat about using mutex under
non-sleepable RCU:

  BUG: sleeping function called from invalid context at kernel/locking/mutex.c:585
   in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 98231, name: stress-ng-sigq
   preempt_count: 0, expected: 0
   RCU nest depth: 1, expected: 0
   ...
   Call Trace:
    <TASK>
    dump_stack_lvl+0x3d/0xe0
    __might_resched+0x24c/0x270
    ? prepare_uprobe_buffer+0xd5/0x1d0
    __mutex_lock+0x41/0x820
    ? ___perf_sw_event+0x206/0x290
    ? __perf_event_task_sched_in+0x54/0x660
    ? __perf_event_task_sched_in+0x54/0x660
    prepare_uprobe_buffer+0xd5/0x1d0
    __uprobe_trace_func+0x4a/0x140
    uprobe_dispatcher+0x135/0x280
    ? uprobe_dispatcher+0x94/0x280
    uprobe_notify_resume+0x650/0xec0
    ? atomic_notifier_call_chain+0x21/0x110
    ? atomic_notifier_call_chain+0xf8/0x110
    irqentry_exit_to_user_mode+0xe2/0x1e0
    asm_exc_int3+0x35/0x40
   RIP: 0033:0x7f7e1d4da390
   Code: 33 04 00 0f 1f 80 00 00 00 00 f3 0f 1e fa b9 01 00 00 00 e9 b2 fc ff ff 66 90 f3 0f 1e fa 31 c9 e9 a5 fc ff ff 0f 1f 44 00 00 <cc> 0f 1e fa b8 27 00 00 00 0f 05 c3 0f 1f 40 00 f3 0f 1e fa b8 6e
   RSP: 002b:00007ffd2abc3608 EFLAGS: 00000246
   RAX: 0000000000000000 RBX: 0000000076d325f1 RCX: 0000000000000000
   RDX: 0000000076d325f1 RSI: 000000000000000a RDI: 00007ffd2abc3690
   RBP: 000000000000000a R08: 00017fb700000000 R09: 00017fb700000000
   R10: 00017fb700000000 R11: 0000000000000246 R12: 0000000000017ff2
   R13: 00007ffd2abc3610 R14: 0000000000000000 R15: 00007ffd2abc3780
    </TASK>

Luckily, it's easy to fix by moving prepare_uprobe_buffer() to be called
slightly earlier: into uprobe_trace_func() and uretprobe_trace_func(), outside
of RCU locked section. This still keeps this buffer preparation lazy and helps
avoid the overhead when it's not needed. E.g., if there is only BPF uprobe
handler installed on a given uprobe, buffer won't be initialized.

Note, the other user of prepare_uprobe_buffer(), __uprobe_perf_func(), is not
affected, as it doesn't prepare buffer under RCU read lock.

Link: https://lore.kernel.org/all/20240521053017.3708530-1-andrii@kernel.org/

Fixes: 1b8f85defbc8 ("uprobes: prepare uprobe args buffer lazily")
Reported-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Stable-dep-of: 373b9338c972 ("uprobe: avoid out-of-bounds memory access of fetching args")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_uprobe.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 6c2ab0e316d6a..0d52588329b29 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -970,19 +970,17 @@ static struct uprobe_cpu_buffer *prepare_uprobe_buffer(struct trace_uprobe *tu,
 
 static void __uprobe_trace_func(struct trace_uprobe *tu,
 				unsigned long func, struct pt_regs *regs,
-				struct uprobe_cpu_buffer **ucbp,
+				struct uprobe_cpu_buffer *ucb,
 				struct trace_event_file *trace_file)
 {
 	struct uprobe_trace_entry_head *entry;
 	struct trace_event_buffer fbuffer;
-	struct uprobe_cpu_buffer *ucb;
 	void *data;
 	int size, esize;
 	struct trace_event_call *call = trace_probe_event_call(&tu->tp);
 
 	WARN_ON(call != trace_file->event_call);
 
-	ucb = prepare_uprobe_buffer(tu, regs, ucbp);
 	if (WARN_ON_ONCE(ucb->dsize > PAGE_SIZE))
 		return;
 
@@ -1014,13 +1012,16 @@ static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs,
 			     struct uprobe_cpu_buffer **ucbp)
 {
 	struct event_file_link *link;
+	struct uprobe_cpu_buffer *ucb;
 
 	if (is_ret_probe(tu))
 		return 0;
 
+	ucb = prepare_uprobe_buffer(tu, regs, ucbp);
+
 	rcu_read_lock();
 	trace_probe_for_each_link_rcu(link, &tu->tp)
-		__uprobe_trace_func(tu, 0, regs, ucbp, link->file);
+		__uprobe_trace_func(tu, 0, regs, ucb, link->file);
 	rcu_read_unlock();
 
 	return 0;
@@ -1031,10 +1032,13 @@ static void uretprobe_trace_func(struct trace_uprobe *tu, unsigned long func,
 				 struct uprobe_cpu_buffer **ucbp)
 {
 	struct event_file_link *link;
+	struct uprobe_cpu_buffer *ucb;
+
+	ucb = prepare_uprobe_buffer(tu, regs, ucbp);
 
 	rcu_read_lock();
 	trace_probe_for_each_link_rcu(link, &tu->tp)
-		__uprobe_trace_func(tu, func, regs, ucbp, link->file);
+		__uprobe_trace_func(tu, func, regs, ucb, link->file);
 	rcu_read_unlock();
 }
 
-- 
2.43.0



