Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F54A377000
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301618; cv=none; b=rGF3JdOGNUy2kDGSDxnSpUvLzVYck4/LmJhDK54upvX0rIrlHExMLFI6ljeEpND/BvfumizK6t0LdnhpUl3Fhjrf/IQwtX0j2bF/cEiFS65AEI7tUQ57aP2dBAmMgw3+cIl6y0GWJiDvOB85SVCMtoII1VGHa0wWZw3UkfDEVmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301618; c=relaxed/simple;
	bh=bTxyUfepSfK6Co9wPysehD0lC94SXeKrByy5yZiXTaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EbsfhTzbIiq3OMyk3gaQfrVej6+S03brr01JOaK3BIeLZpBs9eq6A4wQ81azGnC3Gtz28kO+HxZCrgWNvqai7UgF8FIywZI8J6Aah9v/3tm7ehi+z8ueDBbbv84OPYH+IqE6mPOGBUvkCNvogkb+ucd2ZMFhjdKBqsbrHVhLKEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C19pU1MS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C19pU1MS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54ABBC2BC87;
	Sat, 28 Feb 2026 18:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301618;
	bh=bTxyUfepSfK6Co9wPysehD0lC94SXeKrByy5yZiXTaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C19pU1MSsC8mkRRFPAOwce4vUK36jQXsOdPzGiSwjO5JXMCo0fBl0Cz+U+VyWTqVl
	 qdpTxIZBv83vjEQAuDj0nmhNfy7UP3hMj65vHNUJeQk8LXTIm+t9R3d8g6WINMuOhJ
	 eWpRzM6SuW71zisxm05sxjNAfWKIZoeQ6hDBKd+NeRn3T2mw0ft8awslfgHJpopKD2
	 Iip36IvvTh+pRyEZ72tkDHNnjr2KEpnIegVBwp3FS8ybrNpgqAn9QjLvTtc34Pg9IT
	 aDCakoZWDIO1CGgjq6DdlDPoq4KpGBKy6tt4URcJrnngN+w3+gojwFKlbTv1bSnvMB
	 D5WMtSt3D2gpw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Yao Kai <yaokai34@huawei.com>,
	Tengda Wu <wutengda2@huawei.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 007/385] rcu: Fix rcu_read_unlock() deadloop due to softirq
Date: Sat, 28 Feb 2026 12:53:49 -0500
Message-ID: <20260228180011.1568201-7-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Yao Kai <yaokai34@huawei.com>

[ Upstream commit d41e37f26b3157b3f1d10223863519a943aa239b ]

Commit 5f5fa7ea89dc ("rcu: Don't use negative nesting depth in
__rcu_read_unlock()") removes the recursion-protection code from
__rcu_read_unlock(). Therefore, we could invoke the deadloop in
raise_softirq_irqoff() with ftrace enabled as follows:

WARNING: CPU: 0 PID: 0 at kernel/trace/trace.c:3021 __ftrace_trace_stack.constprop.0+0x172/0x180
Modules linked in: my_irq_work(O)
CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Tainted: G O 6.18.0-rc7-dirty #23 PREEMPT(full)
Tainted: [O]=OOT_MODULE
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
RIP: 0010:__ftrace_trace_stack.constprop.0+0x172/0x180
RSP: 0018:ffffc900000034a8 EFLAGS: 00010002
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000000000
RDX: 0000000000000003 RSI: ffffffff826d7b87 RDI: ffffffff826e9329
RBP: 0000000000090009 R08: 0000000000000005 R09: ffffffff82afbc4c
R10: 0000000000000008 R11: 0000000000011d7a R12: 0000000000000000
R13: ffff888003874100 R14: 0000000000000003 R15: ffff8880038c1054
FS:  0000000000000000(0000) GS:ffff8880fa8ea000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055b31fa7f540 CR3: 00000000078f4005 CR4: 0000000000770ef0
PKRU: 55555554
Call Trace:
 <IRQ>
 trace_buffer_unlock_commit_regs+0x6d/0x220
 trace_event_buffer_commit+0x5c/0x260
 trace_event_raw_event_softirq+0x47/0x80
 raise_softirq_irqoff+0x6e/0xa0
 rcu_read_unlock_special+0xb1/0x160
 unwind_next_frame+0x203/0x9b0
 __unwind_start+0x15d/0x1c0
 arch_stack_walk+0x62/0xf0
 stack_trace_save+0x48/0x70
 __ftrace_trace_stack.constprop.0+0x144/0x180
 trace_buffer_unlock_commit_regs+0x6d/0x220
 trace_event_buffer_commit+0x5c/0x260
 trace_event_raw_event_softirq+0x47/0x80
 raise_softirq_irqoff+0x6e/0xa0
 rcu_read_unlock_special+0xb1/0x160
 unwind_next_frame+0x203/0x9b0
 __unwind_start+0x15d/0x1c0
 arch_stack_walk+0x62/0xf0
 stack_trace_save+0x48/0x70
 __ftrace_trace_stack.constprop.0+0x144/0x180
 trace_buffer_unlock_commit_regs+0x6d/0x220
 trace_event_buffer_commit+0x5c/0x260
 trace_event_raw_event_softirq+0x47/0x80
 raise_softirq_irqoff+0x6e/0xa0
 rcu_read_unlock_special+0xb1/0x160
 unwind_next_frame+0x203/0x9b0
 __unwind_start+0x15d/0x1c0
 arch_stack_walk+0x62/0xf0
 stack_trace_save+0x48/0x70
 __ftrace_trace_stack.constprop.0+0x144/0x180
 trace_buffer_unlock_commit_regs+0x6d/0x220
 trace_event_buffer_commit+0x5c/0x260
 trace_event_raw_event_softirq+0x47/0x80
 raise_softirq_irqoff+0x6e/0xa0
 rcu_read_unlock_special+0xb1/0x160
 __is_insn_slot_addr+0x54/0x70
 kernel_text_address+0x48/0xc0
 __kernel_text_address+0xd/0x40
 unwind_get_return_address+0x1e/0x40
 arch_stack_walk+0x9c/0xf0
 stack_trace_save+0x48/0x70
 __ftrace_trace_stack.constprop.0+0x144/0x180
 trace_buffer_unlock_commit_regs+0x6d/0x220
 trace_event_buffer_commit+0x5c/0x260
 trace_event_raw_event_softirq+0x47/0x80
 __raise_softirq_irqoff+0x61/0x80
 __flush_smp_call_function_queue+0x115/0x420
 __sysvec_call_function_single+0x17/0xb0
 sysvec_call_function_single+0x8c/0xc0
 </IRQ>

Commit b41642c87716 ("rcu: Fix rcu_read_unlock() deadloop due to IRQ work")
fixed the infinite loop in rcu_read_unlock_special() for IRQ work by
setting a flag before calling irq_work_queue_on(). We fix this issue by
setting the same flag before calling raise_softirq_irqoff() and rename the
flag to defer_qs_pending for more common.

Fixes: 5f5fa7ea89dc ("rcu: Don't use negative nesting depth in __rcu_read_unlock()")
Reported-by: Tengda Wu <wutengda2@huawei.com>
Signed-off-by: Yao Kai <yaokai34@huawei.com>
Reviewed-by: Joel Fernandes <joelagnelf@nvidia.com>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Joel Fernandes <joelagnelf@nvidia.com>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree.h        |  2 +-
 kernel/rcu/tree_plugin.h | 15 +++++++++------
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 8ba04b179416a..08c020e01425d 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -202,7 +202,7 @@ struct rcu_data {
 					/*  during and after the last grace */
 					/* period it is aware of. */
 	struct irq_work defer_qs_iw;	/* Obtain later scheduler attention. */
-	int defer_qs_iw_pending;	/* Scheduler attention pending? */
+	int defer_qs_pending;		/* irqwork or softirq pending? */
 	struct work_struct strict_work;	/* Schedule readers for strict GPs. */
 
 	/* 2) batch handling */
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index ada3cf2e72fc6..47a44f6dede0c 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -486,8 +486,8 @@ rcu_preempt_deferred_qs_irqrestore(struct task_struct *t, unsigned long flags)
 	union rcu_special special;
 
 	rdp = this_cpu_ptr(&rcu_data);
-	if (rdp->defer_qs_iw_pending == DEFER_QS_PENDING)
-		rdp->defer_qs_iw_pending = DEFER_QS_IDLE;
+	if (rdp->defer_qs_pending == DEFER_QS_PENDING)
+		rdp->defer_qs_pending = DEFER_QS_IDLE;
 
 	/*
 	 * If RCU core is waiting for this CPU to exit its critical section,
@@ -645,7 +645,7 @@ static void rcu_preempt_deferred_qs_handler(struct irq_work *iwp)
 	 * 5. Deferred QS reporting does not happen.
 	 */
 	if (rcu_preempt_depth() > 0)
-		WRITE_ONCE(rdp->defer_qs_iw_pending, DEFER_QS_IDLE);
+		WRITE_ONCE(rdp->defer_qs_pending, DEFER_QS_IDLE);
 }
 
 /*
@@ -747,7 +747,10 @@ static void rcu_read_unlock_special(struct task_struct *t)
 			// Using softirq, safe to awaken, and either the
 			// wakeup is free or there is either an expedited
 			// GP in flight or a potential need to deboost.
-			raise_softirq_irqoff(RCU_SOFTIRQ);
+			if (rdp->defer_qs_pending != DEFER_QS_PENDING) {
+				rdp->defer_qs_pending = DEFER_QS_PENDING;
+				raise_softirq_irqoff(RCU_SOFTIRQ);
+			}
 		} else {
 			// Enabling BH or preempt does reschedule, so...
 			// Also if no expediting and no possible deboosting,
@@ -756,11 +759,11 @@ static void rcu_read_unlock_special(struct task_struct *t)
 			set_tsk_need_resched(current);
 			set_preempt_need_resched();
 			if (IS_ENABLED(CONFIG_IRQ_WORK) && irqs_were_disabled &&
-			    needs_exp && rdp->defer_qs_iw_pending != DEFER_QS_PENDING &&
+			    needs_exp && rdp->defer_qs_pending != DEFER_QS_PENDING &&
 			    cpu_online(rdp->cpu)) {
 				// Get scheduler to re-evaluate and call hooks.
 				// If !IRQ_WORK, FQS scan will eventually IPI.
-				rdp->defer_qs_iw_pending = DEFER_QS_PENDING;
+				rdp->defer_qs_pending = DEFER_QS_PENDING;
 				irq_work_queue_on(&rdp->defer_qs_iw, rdp->cpu);
 			}
 		}
-- 
2.51.0

