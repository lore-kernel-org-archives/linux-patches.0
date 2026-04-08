Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6A83624B9;
	Wed,  8 Apr 2026 18:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674626; cv=none; b=HvAycksZ6YXO81ZwUZYnOkeb/AI4w+xv4HKmpALFnwT4UJ6qaeOggODeMEAL1dVmTnEltvTMUAp40kG46qFJiWu7ktRbj6PDkgzoOp0SgrcL2mx1fE1ssV5Go6inZM64CqvkDRjB2sghWuJmJpUdVA/nd9wv1CoZQI0bO/W2b5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674626; c=relaxed/simple;
	bh=WTOnXHODuVML4uYAKQJa2+4sdaV8AA+DGe1lRSERfEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DrdBaGAb3VIrUBzg+nJGJVt2Vd2Hw4M7IrJAumhlK+96gDHIaagzJsF07deUj5SdhqQqBMhRaOh6O2heMJkO/Us3KO1bmXxJa1z0aMHWYQ1CvkmrX6G2ZDvS9wMZqThL/W5H4D9XZJ+T3BnWrFvgASFkCgHkuE9iGtFCb9bogkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M9nbsgdb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M9nbsgdb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4ED2C19421;
	Wed,  8 Apr 2026 18:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674626;
	bh=WTOnXHODuVML4uYAKQJa2+4sdaV8AA+DGe1lRSERfEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M9nbsgdbVdwWrQ9amaUH0Q1wiNgjJs28clzveBo5ImB7GApb6Yo5Q3tgSszCxAATV
	 fz8UqfQ6WvDJcCuzSc3yem/zCVIEq5rrDG4T5xvqesBVBtB567NVgKRtYEdghr9sZy
	 tA3vZDZYVvFpTV8LSluEs12ABr/Ea+cdNU/NJvck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.19 169/311] sched_ext: Fix SCX_KICK_WAIT deadlock by deferring wait to balance callback
Date: Wed,  8 Apr 2026 20:02:49 +0200
Message-ID: <20260408175945.714039488@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 415cb193bb9736f0e830286c72a6fa8eb2a9cc5c upstream.

SCX_KICK_WAIT busy-waits in kick_cpus_irq_workfn() using
smp_cond_load_acquire() until the target CPU's kick_sync advances. Because
the irq_work runs in hardirq context, the waiting CPU cannot reschedule and
its own kick_sync never advances. If multiple CPUs form a wait cycle, all
CPUs deadlock.

Replace the busy-wait in kick_cpus_irq_workfn() with resched_curr() to
force the CPU through do_pick_task_scx(), which queues a balance callback
to perform the wait. The balance callback drops the rq lock and enables
IRQs following the sched_core_balance() pattern, so the CPU can process
IPIs while waiting. The local CPU's kick_sync is advanced on entry to
do_pick_task_scx() and continuously during the wait, ensuring any CPU that
starts waiting for us sees the advancement and cannot form cyclic
dependencies.

Fixes: 90e55164dad4 ("sched_ext: Implement SCX_KICK_WAIT")
Cc: stable@vger.kernel.org # v6.12+
Reported-by: Christian Loehle <christian.loehle@arm.com>
Link: https://lore.kernel.org/r/20260316100249.1651641-1-christian.loehle@arm.com
Signed-off-by: Tejun Heo <tj@kernel.org>
Tested-by: Christian Loehle <christian.loehle@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c   |   95 +++++++++++++++++++++++++++++++++++++--------------
 kernel/sched/sched.h |    3 +
 2 files changed, 73 insertions(+), 25 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -2394,7 +2394,7 @@ static void put_prev_task_scx(struct rq
 {
 	struct scx_sched *sch = scx_root;
 
-	/* see kick_cpus_irq_workfn() */
+	/* see kick_sync_wait_bal_cb() */
 	smp_store_release(&rq->scx.kick_sync, rq->scx.kick_sync + 1);
 
 	update_curr_scx(rq);
@@ -2437,6 +2437,48 @@ switch_class:
 		switch_class(rq, next);
 }
 
+static void kick_sync_wait_bal_cb(struct rq *rq)
+{
+	struct scx_kick_syncs __rcu *ks = __this_cpu_read(scx_kick_syncs);
+	unsigned long *ksyncs = rcu_dereference_sched(ks)->syncs;
+	bool waited;
+	s32 cpu;
+
+	/*
+	 * Drop rq lock and enable IRQs while waiting. IRQs must be enabled
+	 * — a target CPU may be waiting for us to process an IPI (e.g. TLB
+	 * flush) while we wait for its kick_sync to advance.
+	 *
+	 * Also, keep advancing our own kick_sync so that new kick_sync waits
+	 * targeting us, which can start after we drop the lock, cannot form
+	 * cyclic dependencies.
+	 */
+retry:
+	waited = false;
+	for_each_cpu(cpu, rq->scx.cpus_to_sync) {
+		/*
+		 * smp_load_acquire() pairs with smp_store_release() on
+		 * kick_sync updates on the target CPUs.
+		 */
+		if (cpu == cpu_of(rq) ||
+		    smp_load_acquire(&cpu_rq(cpu)->scx.kick_sync) != ksyncs[cpu]) {
+			cpumask_clear_cpu(cpu, rq->scx.cpus_to_sync);
+			continue;
+		}
+
+		raw_spin_rq_unlock_irq(rq);
+		while (READ_ONCE(cpu_rq(cpu)->scx.kick_sync) == ksyncs[cpu]) {
+			smp_store_release(&rq->scx.kick_sync, rq->scx.kick_sync + 1);
+			cpu_relax();
+		}
+		raw_spin_rq_lock_irq(rq);
+		waited = true;
+	}
+
+	if (waited)
+		goto retry;
+}
+
 static struct task_struct *first_local_task(struct rq *rq)
 {
 	return list_first_entry_or_null(&rq->scx.local_dsq.list,
@@ -2450,7 +2492,7 @@ do_pick_task_scx(struct rq *rq, struct r
 	bool keep_prev;
 	struct task_struct *p;
 
-	/* see kick_cpus_irq_workfn() */
+	/* see kick_sync_wait_bal_cb() */
 	smp_store_release(&rq->scx.kick_sync, rq->scx.kick_sync + 1);
 
 	rq_modified_clear(rq);
@@ -2461,6 +2503,17 @@ do_pick_task_scx(struct rq *rq, struct r
 	maybe_queue_balance_callback(rq);
 
 	/*
+	 * Defer to a balance callback which can drop rq lock and enable
+	 * IRQs. Waiting directly in the pick path would deadlock against
+	 * CPUs sending us IPIs (e.g. TLB flushes) while we wait for them.
+	 */
+	if (unlikely(rq->scx.kick_sync_pending)) {
+		rq->scx.kick_sync_pending = false;
+		queue_balance_callback(rq, &rq->scx.kick_sync_bal_cb,
+				       kick_sync_wait_bal_cb);
+	}
+
+	/*
 	 * If any higher-priority sched class enqueued a runnable task on
 	 * this rq during balance_one(), abort and return RETRY_TASK, so
 	 * that the scheduler loop can restart.
@@ -4673,6 +4726,9 @@ static void scx_dump_state(struct scx_ex
 		if (!cpumask_empty(rq->scx.cpus_to_wait))
 			dump_line(&ns, "  cpus_to_wait   : %*pb",
 				  cpumask_pr_args(rq->scx.cpus_to_wait));
+		if (!cpumask_empty(rq->scx.cpus_to_sync))
+			dump_line(&ns, "  cpus_to_sync   : %*pb",
+				  cpumask_pr_args(rq->scx.cpus_to_sync));
 
 		used = seq_buf_used(&ns);
 		if (SCX_HAS_OP(sch, dump_cpu)) {
@@ -5571,11 +5627,11 @@ static bool kick_one_cpu(s32 cpu, struct
 
 		if (cpumask_test_cpu(cpu, this_scx->cpus_to_wait)) {
 			if (cur_class == &ext_sched_class) {
+				cpumask_set_cpu(cpu, this_scx->cpus_to_sync);
 				ksyncs[cpu] = rq->scx.kick_sync;
 				should_wait = true;
-			} else {
-				cpumask_clear_cpu(cpu, this_scx->cpus_to_wait);
 			}
+			cpumask_clear_cpu(cpu, this_scx->cpus_to_wait);
 		}
 
 		resched_curr(rq);
@@ -5630,27 +5686,15 @@ static void kick_cpus_irq_workfn(struct
 		cpumask_clear_cpu(cpu, this_scx->cpus_to_kick_if_idle);
 	}
 
-	if (!should_wait)
-		return;
-
-	for_each_cpu(cpu, this_scx->cpus_to_wait) {
-		unsigned long *wait_kick_sync = &cpu_rq(cpu)->scx.kick_sync;
-
-		/*
-		 * Busy-wait until the task running at the time of kicking is no
-		 * longer running. This can be used to implement e.g. core
-		 * scheduling.
-		 *
-		 * smp_cond_load_acquire() pairs with store_releases in
-		 * pick_task_scx() and put_prev_task_scx(). The former breaks
-		 * the wait if SCX's scheduling path is entered even if the same
-		 * task is picked subsequently. The latter is necessary to break
-		 * the wait when $cpu is taken by a higher sched class.
-		 */
-		if (cpu != cpu_of(this_rq))
-			smp_cond_load_acquire(wait_kick_sync, VAL != ksyncs[cpu]);
-
-		cpumask_clear_cpu(cpu, this_scx->cpus_to_wait);
+	/*
+	 * Can't wait in hardirq — kick_sync can't advance, deadlocking if
+	 * CPUs wait for each other. Defer to kick_sync_wait_bal_cb().
+	 */
+	if (should_wait) {
+		raw_spin_rq_lock(this_rq);
+		this_scx->kick_sync_pending = true;
+		resched_curr(this_rq);
+		raw_spin_rq_unlock(this_rq);
 	}
 }
 
@@ -5755,6 +5799,7 @@ void __init init_sched_ext_class(void)
 		BUG_ON(!zalloc_cpumask_var_node(&rq->scx.cpus_to_kick_if_idle, GFP_KERNEL, n));
 		BUG_ON(!zalloc_cpumask_var_node(&rq->scx.cpus_to_preempt, GFP_KERNEL, n));
 		BUG_ON(!zalloc_cpumask_var_node(&rq->scx.cpus_to_wait, GFP_KERNEL, n));
+		BUG_ON(!zalloc_cpumask_var_node(&rq->scx.cpus_to_sync, GFP_KERNEL, n));
 		rq->scx.deferred_irq_work = IRQ_WORK_INIT_HARD(deferred_irq_workfn);
 		rq->scx.kick_cpus_irq_work = IRQ_WORK_INIT_HARD(kick_cpus_irq_workfn);
 
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -803,9 +803,12 @@ struct scx_rq {
 	cpumask_var_t		cpus_to_kick_if_idle;
 	cpumask_var_t		cpus_to_preempt;
 	cpumask_var_t		cpus_to_wait;
+	cpumask_var_t		cpus_to_sync;
+	bool			kick_sync_pending;
 	unsigned long		kick_sync;
 	local_t			reenq_local_deferred;
 	struct balance_callback	deferred_bal_cb;
+	struct balance_callback	kick_sync_bal_cb;
 	struct irq_work		deferred_irq_work;
 	struct irq_work		kick_cpus_irq_work;
 	struct scx_dispatch_q	bypass_dsq;


