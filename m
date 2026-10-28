Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214380;
	b=Y+nKMbhMndfvB/Xw/Jz3mACGe9yjQpaEMQ0YaufsuQyzTJuRzoLq4SMj20ZjjWX1PIRJ
	 gZQl22g1WIqf/Z12Fdo4EwaXvpzw8ysxXqeVyy2g3qdtlupK163l35Cg6VdR3DzVj/Xcf
	 fGRSjEho6fKOlQ2z25Y7jfwYuqQTHagcdlZidn3rGUThJfyoRNa2TQtrK8DcAAy/j7K3H
	 AjqxmpcqyjRA1OkMSADju523gOqkrmMYqJq5WN5//7dgmKoyD8o6u1xCx6mYhIE6zONT9
	 s+lTago+GZQa+pxUnVNT57J1uFu9CES3Gh5016nhu1sM1mWmPqvy48y1AGBpp//4ohQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214380;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f28tOee5ToZYHMKPxzwix/CH3wN8HXrY6+FDGlx+M30=;
	b=Oi0gWy3ta+umHrwF1KjbpbPIvZXKAvp/o18MhSkKYRrMZYwgAzgExBfqOiUZC8jSDQLf
	 oW4DqD9YgHrLOne/Lq4xNMZw+RMDdZA1E8zfJ3OKQUfKYuz/Nmc+SuV0HBt/g5atFEgzD
	 MX1PL5JtLakZNHEYU2IV/MBHk6pJdjES/20zAx5XirfnCnI6ep1bDGrtv54zcFgjWmZVz
	 gvSc2wTCuyMCIm97JN6+/ZHW1nyPLOVB4oA415q6a6wCEfvub3wTr4FNmdqdDllkjQ9Gn
	 0tCzqhDf35by3Ut0+sUMWeufRHEwftfMGhzTV/PNgNijeJYocm5n6b1CHpx++iS1myg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BEjMfm1l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EF560A262F;
	Wed, 28 Oct 2026 19:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BEjMfm1l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 355D11F01829;
	Wed, 28 Oct 2026 19:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214379;
	bh=f28tOee5ToZYHMKPxzwix/CH3wN8HXrY6+FDGlx+M30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BEjMfm1lEt1P582eE94cXRxk6i3lzIHLkUYwuO3hRAPUUAxBhwe+2sOR/Ltx/UKAh
	 VzfnbFtlj82tb/Wt5Bew12nNyN8g1XpWQ5ZJDtX8TWbDzZXkZjcGL+r012ibYZkFGE
	 43Eqwh7Kt28pmBnUop5OG7cVP7dmCPdkPY3hO0rE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiongfeng Wang <wangxiongfeng2@huawei.com>,
	Qi Xi <xiqi2@huawei.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	"Neeraj Upadhyay (AMD)" <neeraj.upadhyay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0837/1887] rcu: Fix rcu_read_unlock() deadloop due to IRQ work
Date: Wed, 28 Oct 2026 17:48:53 +0100
Message-ID: <20261028170518.473639966@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joel Fernandes <joelagnelf@nvidia.com>

[ Upstream commit b41642c87716bbd09797b1e4ea7d904f06c39b7b ]

During rcu_read_unlock_special(), if this happens during irq_exit(), we
can lockup if an IPI is issued. This is because the IPI itself triggers
the irq_exit() path causing a recursive lock up.

This is precisely what Xiongfeng found when invoking a BPF program on
the trace_tick_stop() tracepoint As shown in the trace below. Fix by
managing the irq_work state correctly.

irq_exit()
  __irq_exit_rcu()
    /* in_hardirq() returns false after this */
    preempt_count_sub(HARDIRQ_OFFSET)
    tick_irq_exit()
      tick_nohz_irq_exit()
	    tick_nohz_stop_sched_tick()
	      trace_tick_stop()  /* a bpf prog is hooked on this trace point */
		   __bpf_trace_tick_stop()
		      bpf_trace_run2()
			    rcu_read_unlock_special()
                              /* will send a IPI to itself */
			      irq_work_queue_on(&rdp->defer_qs_iw, rdp->cpu);

A simple reproducer can also be obtained by doing the following in
tick_irq_exit(). It will hang on boot without the patch:

  static inline void tick_irq_exit(void)
  {
 +	rcu_read_lock();
 +	WRITE_ONCE(current->rcu_read_unlock_special.b.need_qs, true);
 +	rcu_read_unlock();
 +

Reported-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Closes: https://lore.kernel.org/all/9acd5f9f-6732-7701-6880-4b51190aa070@huawei.com/
Tested-by: Qi Xi <xiqi2@huawei.com>
Signed-off-by: Joel Fernandes <joelagnelf@nvidia.com>
Reviewed-by: "Paul E. McKenney" <paulmck@kernel.org>
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
[neeraj: Apply Frederic's suggested fix for PREEMPT_RT]
Signed-off-by: Neeraj Upadhyay (AMD) <neeraj.upadhyay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree.h        | 13 ++++++++++++-
 kernel/rcu/tree_plugin.h | 37 ++++++++++++++++++++++++++-----------
 2 files changed, 38 insertions(+), 12 deletions(-)

diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index aa16d3cd62ba5..4770ff998f27d 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -158,6 +158,17 @@ union rcu_noqs {
 	u16 s; /* Set of bits, aggregate OR here. */
 };
 
+/*
+ * An IRQ work (deferred_qs_iw) is used by RCU to get the scheduler's attention.
+ * to report quiescent states at the soonest possible time.
+ * The request can be in one of the following states:
+ * - DEFER_QS_IDLE: An IRQ work is yet to be scheduled.
+ * - DEFER_QS_PENDING: An IRQ work was scheduled but either not yet run, or it
+ *                     ran and we still haven't reported a quiescent state.
+ */
+#define DEFER_QS_IDLE		0
+#define DEFER_QS_PENDING	1
+
 /* Per-CPU data for read-copy update. */
 struct rcu_data {
 	/* 1) quiescent-state and grace-period handling : */
@@ -175,7 +186,7 @@ struct rcu_data {
 					/*  during and after the last grace */
 					/* period it is aware of. */
 	struct irq_work defer_qs_iw;	/* Obtain later scheduler attention. */
-	bool defer_qs_iw_pending;	/* Scheduler attention pending? */
+	int defer_qs_iw_pending;	/* Scheduler attention pending? */
 	struct work_struct strict_work;	/* Schedule readers for strict GPs. */
 
 	/* 2) batch handling */
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 4cb5c901a2049..7dd83a4d86810 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -474,13 +474,16 @@ rcu_preempt_deferred_qs_irqrestore(struct task_struct *t, unsigned long flags)
 	struct rcu_node *rnp;
 	union rcu_special special;
 
+	rdp = this_cpu_ptr(&rcu_data);
+	if (rdp->defer_qs_iw_pending == DEFER_QS_PENDING)
+		rdp->defer_qs_iw_pending = DEFER_QS_IDLE;
+
 	/*
 	 * If RCU core is waiting for this CPU to exit its critical section,
 	 * report the fact that it has exited.  Because irqs are disabled,
 	 * t->rcu_read_unlock_special cannot change.
 	 */
 	special = t->rcu_read_unlock_special;
-	rdp = this_cpu_ptr(&rcu_data);
 	if (!special.s && !rdp->cpu_no_qs.b.exp) {
 		local_irq_restore(flags);
 		return;
@@ -617,7 +620,23 @@ static void rcu_preempt_deferred_qs_handler(struct irq_work *iwp)
 
 	rdp = container_of(iwp, struct rcu_data, defer_qs_iw);
 	local_irq_save(flags);
-	rdp->defer_qs_iw_pending = false;
+
+	/*
+	 * If the IRQ work handler happens to run in the middle of RCU read-side
+	 * critical section, it could be ineffective in getting the scheduler's
+	 * attention to report a deferred quiescent state (the whole point of the
+	 * IRQ work). For this reason, requeue the IRQ work.
+	 *
+	 * Basically, we want to avoid following situation:
+	 * 1. rcu_read_unlock() queues IRQ work (state -> DEFER_QS_PENDING)
+	 * 2. CPU enters new rcu_read_lock()
+	 * 3. IRQ work runs but cannot report QS due to rcu_preempt_depth() > 0
+	 * 4. rcu_read_unlock() does not re-queue work (state still PENDING)
+	 * 5. Deferred QS reporting does not happen.
+	 */
+	if (rcu_preempt_depth() > 0)
+		WRITE_ONCE(rdp->defer_qs_iw_pending, DEFER_QS_IDLE);
+
 	local_irq_restore(flags);
 }
 
@@ -664,17 +683,13 @@ static void rcu_read_unlock_special(struct task_struct *t)
 			set_tsk_need_resched(current);
 			set_preempt_need_resched();
 			if (IS_ENABLED(CONFIG_IRQ_WORK) && irqs_were_disabled &&
-			    expboost && !rdp->defer_qs_iw_pending && cpu_online(rdp->cpu)) {
+			    expboost && rdp->defer_qs_iw_pending != DEFER_QS_PENDING &&
+			    cpu_online(rdp->cpu)) {
 				// Get scheduler to re-evaluate and call hooks.
 				// If !IRQ_WORK, FQS scan will eventually IPI.
-				if (IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD) &&
-				    IS_ENABLED(CONFIG_PREEMPT_RT))
-					rdp->defer_qs_iw = IRQ_WORK_INIT_HARD(
-								rcu_preempt_deferred_qs_handler);
-				else
-					init_irq_work(&rdp->defer_qs_iw,
-						      rcu_preempt_deferred_qs_handler);
-				rdp->defer_qs_iw_pending = true;
+				rdp->defer_qs_iw =
+					IRQ_WORK_INIT_HARD(rcu_preempt_deferred_qs_handler);
+				rdp->defer_qs_iw_pending = DEFER_QS_PENDING;
 				irq_work_queue_on(&rdp->defer_qs_iw, rdp->cpu);
 			}
 		}
-- 
2.53.0



