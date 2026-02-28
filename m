Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121AA3446B0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302038; cv=none; b=QqaFF9I8UVQBHd/iZzVagYvWDjVkC8y47Zt4y0AN4jbYIbmIN/HIM4pkPdL3rW+49BJBCapr5NliwzmKX+N3IVlAozduNseqXBLVYgMhEYn2djaI5eSyDkO9wHfQWYVh1vWy8wtdZ7/MnEGBQrqzkiwpXysWH2LSZf9YZZvT70c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302038; c=relaxed/simple;
	bh=gAbmGD033n4QaDbS640GbtA8BEWZy2zAHBqTWV524Z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGPX+hSk3PLC52v5n3gOZy+E0ZM+CRisG4ApNtZFaXTMOv99F+ZVXcsQ2n90yJYGT/fChcEV/MYUgNeKe6s5EcuEV+IjJQwNa3utVj3n1cglhNGHNCXyqvJ0KD8h4mRtavKa82aqUbgKiaa5lEUf+TQ59EC4lA/7LhUNYuCpmUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mSnq/H3j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mSnq/H3j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35765C19423;
	Sat, 28 Feb 2026 18:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302038;
	bh=gAbmGD033n4QaDbS640GbtA8BEWZy2zAHBqTWV524Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mSnq/H3j2YPAbxpfUDDRA0d5IiBvxkv6CNk3oeleZtYQeL/vteSMc0ly0Hc8vbKbK
	 xyV0eSXouFvxRCh0i2B0poiHrjgqjmnbkckwN9I5UpPSbpqNsN5wCaQk81Wa+xXO+/
	 NT8aixWXu873y0XVN7XHmPJZJ+gkoQ5JsxVP2hr+WXBC4Cw/BF5SokK6boB4eIsm6t
	 qMK2/HaYlPnskfA+Pw3lxb+Wj+xrhTQm1dGf8+PAVL53JDa7lqMp1Pz5WlRcOugNH9
	 H71pUygXnHzy4P1u0mgswV/l1AwUFNym++4TGobJXLd/GNNk5GTH2ZmYd61ohLPV40
	 bOST6nKO3nWsg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Yao Kai <yaokai34@huawei.com>,
	Tengda Wu <wutengda2@huawei.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/283] rcu: Fix rcu_read_unlock() deadloop due to softirq
Date: Sat, 28 Feb 2026 13:02:31 -0500
Message-ID: <20260228180709.1583486-9-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index f8408e7a5f824..b79599b2059cc 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -203,7 +203,7 @@ struct rcu_data {
 					/*  during and after the last grace */
 					/* period it is aware of. */
 	struct irq_work defer_qs_iw;	/* Obtain later scheduler attention. */
-	int defer_qs_iw_pending;	/* Scheduler attention pending? */
+	int defer_qs_pending;		/* irqwork or softirq pending? */
 	struct work_struct strict_work;	/* Schedule readers for strict GPs. */
 
 	/* 2) batch handling */
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 04044b492cc31..8cf1adcd259ba 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -475,8 +475,8 @@ rcu_preempt_deferred_qs_irqrestore(struct task_struct *t, unsigned long flags)
 	union rcu_special special;
 
 	rdp = this_cpu_ptr(&rcu_data);
-	if (rdp->defer_qs_iw_pending == DEFER_QS_PENDING)
-		rdp->defer_qs_iw_pending = DEFER_QS_IDLE;
+	if (rdp->defer_qs_pending == DEFER_QS_PENDING)
+		rdp->defer_qs_pending = DEFER_QS_IDLE;
 
 	/*
 	 * If RCU core is waiting for this CPU to exit its critical section,
@@ -634,7 +634,7 @@ static void rcu_preempt_deferred_qs_handler(struct irq_work *iwp)
 	 * 5. Deferred QS reporting does not happen.
 	 */
 	if (rcu_preempt_depth() > 0)
-		WRITE_ONCE(rdp->defer_qs_iw_pending, DEFER_QS_IDLE);
+		WRITE_ONCE(rdp->defer_qs_pending, DEFER_QS_IDLE);
 }
 
 /*
@@ -736,7 +736,10 @@ static void rcu_read_unlock_special(struct task_struct *t)
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
@@ -745,11 +748,11 @@ static void rcu_read_unlock_special(struct task_struct *t)
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

