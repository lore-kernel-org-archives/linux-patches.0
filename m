Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B68289E2C;
	Tue,  8 Jul 2025 16:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992880; cv=none; b=if3ZFgR46BmIrsNOmnWtO1M1Bkbo8w6fClyYKAjoYGSprE3btIagJBXjPqQJyIklDjlq8PiqMUu16Hf18L+H5pxEb5VLsGGOegr3TTyYT/TBKwf9Dqx/Ct4Xy4WaqQfL8Nt7YmNcrxDtXZGtO5u2ad+UN/tbdZ1ropZDupRkPlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992880; c=relaxed/simple;
	bh=D6q+IxbrSqaUtiADTjehf4a7h0mAVSrEp8qSSQVBtF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvzeVhLgjAWbeCOUBbctXdbnQwQSxPARZ9Hh8EdpvaKYPwQJf/JPpfPibDDdFlzDz62Nd0pb1RjsKKGir1txhDnFsaPtlrg7T9X3Ack4DYfyuurFvUPcKdDe7jZX5Vlrzfiakp0wKWbi9f4E6SiElI/ERr7Xy2Wd5NL0jZUZ8uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S9BkRfst; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S9BkRfst"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05B9C4CEED;
	Tue,  8 Jul 2025 16:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992880;
	bh=D6q+IxbrSqaUtiADTjehf4a7h0mAVSrEp8qSSQVBtF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S9BkRfstSslqrJZXW9D3dNGvBS4tHBYXE/BWMSdSbzf0Fb0deiGAuIjDyoqsuZw54
	 +/T9oNr0LL8s192gtkHEQyebViMPBuoJjupY/XhStvvpw2IBxQEMFer910f+lSTU4i
	 DqJV5oJrZoribECM2Iz4irRh+xsNf7alwNmU8VVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 113/232] sched/fair: Rename h_nr_running into h_nr_queued
Date: Tue,  8 Jul 2025 18:21:49 +0200
Message-ID: <20250708162244.396176384@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit 7b8a702d943827130cc00ae36075eff5500f86f1 ]

With delayed dequeued feature, a sleeping sched_entity remains queued
in the rq until its lag has elapsed but can't run.
Rename h_nr_running into h_nr_queued to reflect this new behavior.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Link: https://lore.kernel.org/r/20241202174606.4074512-4-vincent.guittot@linaro.org
Stable-dep-of: aa3ee4f0b754 ("sched/fair: Fixup wake_up_sync() vs DELAYED_DEQUEUE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c  |  4 +-
 kernel/sched/debug.c |  6 +--
 kernel/sched/fair.c  | 88 ++++++++++++++++++++++----------------------
 kernel/sched/pelt.c  |  4 +-
 kernel/sched/sched.h |  4 +-
 5 files changed, 53 insertions(+), 53 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d4948a8629929..50531e462a4ba 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1303,7 +1303,7 @@ bool sched_can_stop_tick(struct rq *rq)
 	if (scx_enabled() && !scx_can_stop_tick(rq))
 		return false;
 
-	if (rq->cfs.h_nr_running > 1)
+	if (rq->cfs.h_nr_queued > 1)
 		return false;
 
 	/*
@@ -5976,7 +5976,7 @@ __pick_next_task(struct rq *rq, struct task_struct *prev, struct rq_flags *rf)
 	 * opportunity to pull in more work from other CPUs.
 	 */
 	if (likely(!sched_class_above(prev->sched_class, &fair_sched_class) &&
-		   rq->nr_running == rq->cfs.h_nr_running)) {
+		   rq->nr_running == rq->cfs.h_nr_queued)) {
 
 		p = pick_next_task_fair(rq, prev, rf);
 		if (unlikely(p == RETRY_TASK))
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 1e3bc0774efd5..7cf0c138c78e5 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -378,7 +378,7 @@ static ssize_t sched_fair_server_write(struct file *filp, const char __user *ubu
 			return  -EINVAL;
 		}
 
-		if (rq->cfs.h_nr_running) {
+		if (rq->cfs.h_nr_queued) {
 			update_rq_clock(rq);
 			dl_server_stop(&rq->fair_server);
 		}
@@ -391,7 +391,7 @@ static ssize_t sched_fair_server_write(struct file *filp, const char __user *ubu
 			printk_deferred("Fair server disabled in CPU %d, system may crash due to starvation.\n",
 					cpu_of(rq));
 
-		if (rq->cfs.h_nr_running)
+		if (rq->cfs.h_nr_queued)
 			dl_server_start(&rq->fair_server);
 	}
 
@@ -843,7 +843,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 	spread = right_vruntime - left_vruntime;
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "spread", SPLIT_NS(spread));
 	SEQ_printf(m, "  .%-30s: %d\n", "nr_running", cfs_rq->nr_running);
-	SEQ_printf(m, "  .%-30s: %d\n", "h_nr_running", cfs_rq->h_nr_running);
+	SEQ_printf(m, "  .%-30s: %d\n", "h_nr_queued", cfs_rq->h_nr_queued);
 	SEQ_printf(m, "  .%-30s: %d\n", "h_nr_delayed", cfs_rq->h_nr_delayed);
 	SEQ_printf(m, "  .%-30s: %d\n", "idle_nr_running",
 			cfs_rq->idle_nr_running);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 443f6a9ef3f8f..33438b6c35478 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2147,7 +2147,7 @@ static void update_numa_stats(struct task_numa_env *env,
 		ns->load += cpu_load(rq);
 		ns->runnable += cpu_runnable(rq);
 		ns->util += cpu_util_cfs(cpu);
-		ns->nr_running += rq->cfs.h_nr_running;
+		ns->nr_running += rq->cfs.h_nr_queued;
 		ns->compute_capacity += capacity_of(cpu);
 
 		if (find_idle && idle_core < 0 && !rq->nr_running && idle_cpu(cpu)) {
@@ -5427,7 +5427,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 * When enqueuing a sched_entity, we must:
 	 *   - Update loads to have both entity and cfs_rq synced with now.
 	 *   - For group_entity, update its runnable_weight to reflect the new
-	 *     h_nr_running of its group cfs_rq.
+	 *     h_nr_queued of its group cfs_rq.
 	 *   - For group_entity, update its weight to reflect the new share of
 	 *     its group cfs_rq
 	 *   - Add its new weight to cfs_rq->load.weight
@@ -5583,7 +5583,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 * When dequeuing a sched_entity, we must:
 	 *   - Update loads to have both entity and cfs_rq synced with now.
 	 *   - For group_entity, update its runnable_weight to reflect the new
-	 *     h_nr_running of its group cfs_rq.
+	 *     h_nr_queued of its group cfs_rq.
 	 *   - Subtract its previous weight from cfs_rq->load.weight.
 	 *   - For group entity, update its weight to reflect the new share
 	 *     of its group cfs_rq.
@@ -5985,8 +5985,8 @@ static bool throttle_cfs_rq(struct cfs_rq *cfs_rq)
 	struct rq *rq = rq_of(cfs_rq);
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
 	struct sched_entity *se;
-	long task_delta, idle_task_delta, delayed_delta, dequeue = 1;
-	long rq_h_nr_running = rq->cfs.h_nr_running;
+	long queued_delta, idle_task_delta, delayed_delta, dequeue = 1;
+	long rq_h_nr_queued = rq->cfs.h_nr_queued;
 
 	raw_spin_lock(&cfs_b->lock);
 	/* This will start the period timer if necessary */
@@ -6016,7 +6016,7 @@ static bool throttle_cfs_rq(struct cfs_rq *cfs_rq)
 	walk_tg_tree_from(cfs_rq->tg, tg_throttle_down, tg_nop, (void *)rq);
 	rcu_read_unlock();
 
-	task_delta = cfs_rq->h_nr_running;
+	queued_delta = cfs_rq->h_nr_queued;
 	idle_task_delta = cfs_rq->idle_h_nr_running;
 	delayed_delta = cfs_rq->h_nr_delayed;
 	for_each_sched_entity(se) {
@@ -6038,9 +6038,9 @@ static bool throttle_cfs_rq(struct cfs_rq *cfs_rq)
 		dequeue_entity(qcfs_rq, se, flags);
 
 		if (cfs_rq_is_idle(group_cfs_rq(se)))
-			idle_task_delta = cfs_rq->h_nr_running;
+			idle_task_delta = cfs_rq->h_nr_queued;
 
-		qcfs_rq->h_nr_running -= task_delta;
+		qcfs_rq->h_nr_queued -= queued_delta;
 		qcfs_rq->idle_h_nr_running -= idle_task_delta;
 		qcfs_rq->h_nr_delayed -= delayed_delta;
 
@@ -6061,18 +6061,18 @@ static bool throttle_cfs_rq(struct cfs_rq *cfs_rq)
 		se_update_runnable(se);
 
 		if (cfs_rq_is_idle(group_cfs_rq(se)))
-			idle_task_delta = cfs_rq->h_nr_running;
+			idle_task_delta = cfs_rq->h_nr_queued;
 
-		qcfs_rq->h_nr_running -= task_delta;
+		qcfs_rq->h_nr_queued -= queued_delta;
 		qcfs_rq->idle_h_nr_running -= idle_task_delta;
 		qcfs_rq->h_nr_delayed -= delayed_delta;
 	}
 
 	/* At this point se is NULL and we are at root level*/
-	sub_nr_running(rq, task_delta);
+	sub_nr_running(rq, queued_delta);
 
 	/* Stop the fair server if throttling resulted in no runnable tasks */
-	if (rq_h_nr_running && !rq->cfs.h_nr_running)
+	if (rq_h_nr_queued && !rq->cfs.h_nr_queued)
 		dl_server_stop(&rq->fair_server);
 done:
 	/*
@@ -6091,8 +6091,8 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 	struct rq *rq = rq_of(cfs_rq);
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
 	struct sched_entity *se;
-	long task_delta, idle_task_delta, delayed_delta;
-	long rq_h_nr_running = rq->cfs.h_nr_running;
+	long queued_delta, idle_task_delta, delayed_delta;
+	long rq_h_nr_queued = rq->cfs.h_nr_queued;
 
 	se = cfs_rq->tg->se[cpu_of(rq)];
 
@@ -6125,7 +6125,7 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 		goto unthrottle_throttle;
 	}
 
-	task_delta = cfs_rq->h_nr_running;
+	queued_delta = cfs_rq->h_nr_queued;
 	idle_task_delta = cfs_rq->idle_h_nr_running;
 	delayed_delta = cfs_rq->h_nr_delayed;
 	for_each_sched_entity(se) {
@@ -6141,9 +6141,9 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 		enqueue_entity(qcfs_rq, se, ENQUEUE_WAKEUP);
 
 		if (cfs_rq_is_idle(group_cfs_rq(se)))
-			idle_task_delta = cfs_rq->h_nr_running;
+			idle_task_delta = cfs_rq->h_nr_queued;
 
-		qcfs_rq->h_nr_running += task_delta;
+		qcfs_rq->h_nr_queued += queued_delta;
 		qcfs_rq->idle_h_nr_running += idle_task_delta;
 		qcfs_rq->h_nr_delayed += delayed_delta;
 
@@ -6159,9 +6159,9 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 		se_update_runnable(se);
 
 		if (cfs_rq_is_idle(group_cfs_rq(se)))
-			idle_task_delta = cfs_rq->h_nr_running;
+			idle_task_delta = cfs_rq->h_nr_queued;
 
-		qcfs_rq->h_nr_running += task_delta;
+		qcfs_rq->h_nr_queued += queued_delta;
 		qcfs_rq->idle_h_nr_running += idle_task_delta;
 		qcfs_rq->h_nr_delayed += delayed_delta;
 
@@ -6171,11 +6171,11 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 	}
 
 	/* Start the fair server if un-throttling resulted in new runnable tasks */
-	if (!rq_h_nr_running && rq->cfs.h_nr_running)
+	if (!rq_h_nr_queued && rq->cfs.h_nr_queued)
 		dl_server_start(&rq->fair_server);
 
 	/* At this point se is NULL and we are at root level*/
-	add_nr_running(rq, task_delta);
+	add_nr_running(rq, queued_delta);
 
 unthrottle_throttle:
 	assert_list_leaf_cfs_rq(rq);
@@ -6890,7 +6890,7 @@ static void hrtick_start_fair(struct rq *rq, struct task_struct *p)
 
 	SCHED_WARN_ON(task_rq(p) != rq);
 
-	if (rq->cfs.h_nr_running > 1) {
+	if (rq->cfs.h_nr_queued > 1) {
 		u64 ran = se->sum_exec_runtime - se->prev_sum_exec_runtime;
 		u64 slice = se->slice;
 		s64 delta = slice - ran;
@@ -7033,7 +7033,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	int idle_h_nr_running = task_has_idle_policy(p);
 	int h_nr_delayed = 0;
 	int task_new = !(flags & ENQUEUE_WAKEUP);
-	int rq_h_nr_running = rq->cfs.h_nr_running;
+	int rq_h_nr_queued = rq->cfs.h_nr_queued;
 	u64 slice = 0;
 
 	/*
@@ -7081,7 +7081,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		enqueue_entity(cfs_rq, se, flags);
 		slice = cfs_rq_min_slice(cfs_rq);
 
-		cfs_rq->h_nr_running++;
+		cfs_rq->h_nr_queued++;
 		cfs_rq->idle_h_nr_running += idle_h_nr_running;
 		cfs_rq->h_nr_delayed += h_nr_delayed;
 
@@ -7107,7 +7107,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 			min_vruntime_cb_propagate(&se->run_node, NULL);
 		slice = cfs_rq_min_slice(cfs_rq);
 
-		cfs_rq->h_nr_running++;
+		cfs_rq->h_nr_queued++;
 		cfs_rq->idle_h_nr_running += idle_h_nr_running;
 		cfs_rq->h_nr_delayed += h_nr_delayed;
 
@@ -7119,7 +7119,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 			goto enqueue_throttle;
 	}
 
-	if (!rq_h_nr_running && rq->cfs.h_nr_running) {
+	if (!rq_h_nr_queued && rq->cfs.h_nr_queued) {
 		/* Account for idle runtime */
 		if (!rq->nr_running)
 			dl_server_update_idle_time(rq, rq->curr);
@@ -7166,19 +7166,19 @@ static void set_next_buddy(struct sched_entity *se);
 static int dequeue_entities(struct rq *rq, struct sched_entity *se, int flags)
 {
 	bool was_sched_idle = sched_idle_rq(rq);
-	int rq_h_nr_running = rq->cfs.h_nr_running;
+	int rq_h_nr_queued = rq->cfs.h_nr_queued;
 	bool task_sleep = flags & DEQUEUE_SLEEP;
 	bool task_delayed = flags & DEQUEUE_DELAYED;
 	struct task_struct *p = NULL;
 	int idle_h_nr_running = 0;
-	int h_nr_running = 0;
+	int h_nr_queued = 0;
 	int h_nr_delayed = 0;
 	struct cfs_rq *cfs_rq;
 	u64 slice = 0;
 
 	if (entity_is_task(se)) {
 		p = task_of(se);
-		h_nr_running = 1;
+		h_nr_queued = 1;
 		idle_h_nr_running = task_has_idle_policy(p);
 		if (!task_sleep && !task_delayed)
 			h_nr_delayed = !!se->sched_delayed;
@@ -7195,12 +7195,12 @@ static int dequeue_entities(struct rq *rq, struct sched_entity *se, int flags)
 			break;
 		}
 
-		cfs_rq->h_nr_running -= h_nr_running;
+		cfs_rq->h_nr_queued -= h_nr_queued;
 		cfs_rq->idle_h_nr_running -= idle_h_nr_running;
 		cfs_rq->h_nr_delayed -= h_nr_delayed;
 
 		if (cfs_rq_is_idle(cfs_rq))
-			idle_h_nr_running = h_nr_running;
+			idle_h_nr_running = h_nr_queued;
 
 		/* end evaluation on encountering a throttled cfs_rq */
 		if (cfs_rq_throttled(cfs_rq))
@@ -7236,21 +7236,21 @@ static int dequeue_entities(struct rq *rq, struct sched_entity *se, int flags)
 			min_vruntime_cb_propagate(&se->run_node, NULL);
 		slice = cfs_rq_min_slice(cfs_rq);
 
-		cfs_rq->h_nr_running -= h_nr_running;
+		cfs_rq->h_nr_queued -= h_nr_queued;
 		cfs_rq->idle_h_nr_running -= idle_h_nr_running;
 		cfs_rq->h_nr_delayed -= h_nr_delayed;
 
 		if (cfs_rq_is_idle(cfs_rq))
-			idle_h_nr_running = h_nr_running;
+			idle_h_nr_running = h_nr_queued;
 
 		/* end evaluation on encountering a throttled cfs_rq */
 		if (cfs_rq_throttled(cfs_rq))
 			return 0;
 	}
 
-	sub_nr_running(rq, h_nr_running);
+	sub_nr_running(rq, h_nr_queued);
 
-	if (rq_h_nr_running && !rq->cfs.h_nr_running)
+	if (rq_h_nr_queued && !rq->cfs.h_nr_queued)
 		dl_server_stop(&rq->fair_server);
 
 	/* balance early to pull high priority tasks */
@@ -10394,7 +10394,7 @@ sched_reduced_capacity(struct rq *rq, struct sched_domain *sd)
 	 * When there is more than 1 task, the group_overloaded case already
 	 * takes care of cpu with reduced capacity
 	 */
-	if (rq->cfs.h_nr_running != 1)
+	if (rq->cfs.h_nr_queued != 1)
 		return false;
 
 	return check_cpu_capacity(rq, sd);
@@ -10429,7 +10429,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 		sgs->group_load += load;
 		sgs->group_util += cpu_util_cfs(i);
 		sgs->group_runnable += cpu_runnable(rq);
-		sgs->sum_h_nr_running += rq->cfs.h_nr_running;
+		sgs->sum_h_nr_running += rq->cfs.h_nr_queued;
 
 		nr_running = rq->nr_running;
 		sgs->sum_nr_running += nr_running;
@@ -10744,7 +10744,7 @@ static inline void update_sg_wakeup_stats(struct sched_domain *sd,
 		sgs->group_util += cpu_util_without(i, p);
 		sgs->group_runnable += cpu_runnable_without(rq, p);
 		local = task_running_on_cpu(i, p);
-		sgs->sum_h_nr_running += rq->cfs.h_nr_running - local;
+		sgs->sum_h_nr_running += rq->cfs.h_nr_queued - local;
 
 		nr_running = rq->nr_running - local;
 		sgs->sum_nr_running += nr_running;
@@ -11526,7 +11526,7 @@ static struct rq *sched_balance_find_src_rq(struct lb_env *env,
 		if (rt > env->fbq_type)
 			continue;
 
-		nr_running = rq->cfs.h_nr_running;
+		nr_running = rq->cfs.h_nr_queued;
 		if (!nr_running)
 			continue;
 
@@ -11685,7 +11685,7 @@ static int need_active_balance(struct lb_env *env)
 	 * available on dst_cpu.
 	 */
 	if (env->idle &&
-	    (env->src_rq->cfs.h_nr_running == 1)) {
+	    (env->src_rq->cfs.h_nr_queued == 1)) {
 		if ((check_cpu_capacity(env->src_rq, sd)) &&
 		    (capacity_of(env->src_cpu)*sd->imbalance_pct < capacity_of(env->dst_cpu)*100))
 			return 1;
@@ -12428,7 +12428,7 @@ static void nohz_balancer_kick(struct rq *rq)
 		 * If there's a runnable CFS task and the current CPU has reduced
 		 * capacity, kick the ILB to see if there's a better CPU to run on:
 		 */
-		if (rq->cfs.h_nr_running >= 1 && check_cpu_capacity(rq, sd)) {
+		if (rq->cfs.h_nr_queued >= 1 && check_cpu_capacity(rq, sd)) {
 			flags = NOHZ_STATS_KICK | NOHZ_BALANCE_KICK;
 			goto unlock;
 		}
@@ -12926,11 +12926,11 @@ static int sched_balance_newidle(struct rq *this_rq, struct rq_flags *rf)
 	 * have been enqueued in the meantime. Since we're not going idle,
 	 * pretend we pulled a task.
 	 */
-	if (this_rq->cfs.h_nr_running && !pulled_task)
+	if (this_rq->cfs.h_nr_queued && !pulled_task)
 		pulled_task = 1;
 
 	/* Is there a task of a high priority class? */
-	if (this_rq->nr_running != this_rq->cfs.h_nr_running)
+	if (this_rq->nr_running != this_rq->cfs.h_nr_queued)
 		pulled_task = -1;
 
 out:
@@ -13617,7 +13617,7 @@ int sched_group_set_idle(struct task_group *tg, long idle)
 				parent_cfs_rq->idle_nr_running--;
 		}
 
-		idle_task_delta = grp_cfs_rq->h_nr_running -
+		idle_task_delta = grp_cfs_rq->h_nr_queued -
 				  grp_cfs_rq->idle_h_nr_running;
 		if (!cfs_rq_is_idle(grp_cfs_rq))
 			idle_task_delta *= -1;
diff --git a/kernel/sched/pelt.c b/kernel/sched/pelt.c
index 171a802420a10..8189a35e53fe1 100644
--- a/kernel/sched/pelt.c
+++ b/kernel/sched/pelt.c
@@ -275,7 +275,7 @@ ___update_load_avg(struct sched_avg *sa, unsigned long load)
  *
  *   group: [ see update_cfs_group() ]
  *     se_weight()   = tg->weight * grq->load_avg / tg->load_avg
- *     se_runnable() = grq->h_nr_running
+ *     se_runnable() = grq->h_nr_queued
  *
  *   runnable_sum = se_runnable() * runnable = grq->runnable_sum
  *   runnable_avg = runnable_sum
@@ -321,7 +321,7 @@ int __update_load_avg_cfs_rq(u64 now, struct cfs_rq *cfs_rq)
 {
 	if (___update_load_sum(now, &cfs_rq->avg,
 				scale_load_down(cfs_rq->load.weight),
-				cfs_rq->h_nr_running - cfs_rq->h_nr_delayed,
+				cfs_rq->h_nr_queued - cfs_rq->h_nr_delayed,
 				cfs_rq->curr != NULL)) {
 
 		___update_load_avg(&cfs_rq->avg, 1);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index d79de755c1c26..dc338f4f911dd 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -651,7 +651,7 @@ struct balance_callback {
 struct cfs_rq {
 	struct load_weight	load;
 	unsigned int		nr_running;
-	unsigned int		h_nr_running;      /* SCHED_{NORMAL,BATCH,IDLE} */
+	unsigned int		h_nr_queued;       /* SCHED_{NORMAL,BATCH,IDLE} */
 	unsigned int		idle_nr_running;   /* SCHED_IDLE */
 	unsigned int		idle_h_nr_running; /* SCHED_IDLE */
 	unsigned int		h_nr_delayed;
@@ -907,7 +907,7 @@ static inline void se_update_runnable(struct sched_entity *se)
 	if (!entity_is_task(se)) {
 		struct cfs_rq *cfs_rq = se->my_q;
 
-		se->runnable_weight = cfs_rq->h_nr_running - cfs_rq->h_nr_delayed;
+		se->runnable_weight = cfs_rq->h_nr_queued - cfs_rq->h_nr_delayed;
 	}
 }
 
-- 
2.39.5



