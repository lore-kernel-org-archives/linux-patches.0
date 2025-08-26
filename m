Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B772D1C54A9;
	Tue, 26 Aug 2025 12:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213079; cv=none; b=Ma8GhgNPAfWvGzRLdipm0v2uQrt03HmofA19BGeQX5KgR0myrmoArNcWR+yUnz/7LtdJJOgbhswO5yRNMOFRNqU7BnpH9VJWUBnmhPfhnaOEGUPclgOU0MENh2Mykk0cFrvF9j1W9qmUFTKa6CuSGaYPnxERF2tuaj7izxaJWH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213079; c=relaxed/simple;
	bh=+qAS97AhzWwsXe4fLnx2lOS4GBFBAdbm5dNlzQMVUZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EKlhi965wIL+pXJzLoNfMMRvhclJhz9JopoZ/kZR2+f+cIGwlDkzuX2pAhj5wgU3FE/4/byZcCudgxMGTQczm8w+x6qOTHIP1VoUav2hjeBFi6ZGxNJMMmpWqULbJlWpf0iv2MG22vINjxkgutEbv940mWQUpOEx96Wy0ZQHoh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NwP3vLnH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NwP3vLnH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B50FC4CEF1;
	Tue, 26 Aug 2025 12:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213079;
	bh=+qAS97AhzWwsXe4fLnx2lOS4GBFBAdbm5dNlzQMVUZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NwP3vLnHWVS9jSTxAfXUPGOWdOj2lCp1/icIsM/QrWrhR+kXZWy6/sBOPDgL0++X3
	 GYpDo/QyAf8RovcD9ZkDq+NgQKPcKzUdR+NsWHZljmhU1yvOYrcxPKokYgM7652EJt
	 rPr7kJzexvtlH3RtVHkM/UETVXRmL/P94KKf/Naw=
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
Subject: [PATCH 6.6 213/587] rcu: Fix rcu_read_unlock() deadloop due to IRQ work
Date: Tue, 26 Aug 2025 13:06:02 +0200
Message-ID: <20250826110958.356712052@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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
index ac8cc756920d..08f5d019c6ce 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -175,6 +175,17 @@ struct rcu_snap_record {
 	unsigned long   jiffies;	/* Track jiffies value */
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
@@ -192,7 +203,7 @@ struct rcu_data {
 					/*  during and after the last grace */
 					/* period it is aware of. */
 	struct irq_work defer_qs_iw;	/* Obtain later scheduler attention. */
-	bool defer_qs_iw_pending;	/* Scheduler attention pending? */
+	int defer_qs_iw_pending;	/* Scheduler attention pending? */
 	struct work_struct strict_work;	/* Schedule readers for strict GPs. */
 
 	/* 2) batch handling */
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index de727f2568bf..771e8cbb10d7 100644
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
2.39.5



