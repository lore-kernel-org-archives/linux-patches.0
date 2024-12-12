Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BD32210FB;
	Thu, 12 Dec 2024 15:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018619; cv=none; b=HExlRqvyD8tHfI+GhVdQQ1lCa/OaNTm4vXHOi/ISpttXB0AYrAjWBMU95Gqklxn7PvHKxZVC5qP5N/y32tY3UcAPJQOAaEBn+WZh/eq+4kRPqL2ZEi9nscNrnf0uaqOGT98NzoHUj9gQOnYMOF9k4JeTKPRRtBNYztyIYKf/exM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018619; c=relaxed/simple;
	bh=zGQNZh6RLY4mR5mZA7mGfSY6UuJEiKt/qi8Iu/2KC5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dxDaWBK+H3pzJBCVMwWax8FEIrfZsoDvHs9EcqfVyu9EoO/Y7Ev+i9EgqXrZtOfxmF8KzDNV0ST9yrwTWhh8L7B6pdjs8uTsm6IGYXW/1ELcA9be59vHnL3WcfftY8uL21rGGomXBhqm9Msa/2dSiW1w5rd37xrC/LHGMrl9jYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Acjzgr/d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Acjzgr/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727B4C4CECE;
	Thu, 12 Dec 2024 15:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018619;
	bh=zGQNZh6RLY4mR5mZA7mGfSY6UuJEiKt/qi8Iu/2KC5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Acjzgr/dOSOGQ13XB72oAISaJPtHEki546HFhqzjQyq0JvW5N91tsFwJB2UgZrCtz
	 d5fCjJysRi/YJrUko3NqVIsVFJr0WkweJ37uIZQ/bvmHqcQAEN0cih4bNid0WSTqX1
	 MFZ+PP1bm1Wqk+vHxWCCSE8jLiaml8mQVCziRLHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Molnar <mingo@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 324/356] sched/fair: Rename check_preempt_curr() to wakeup_preempt()
Date: Thu, 12 Dec 2024 16:00:43 +0100
Message-ID: <20241212144257.357592769@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Ingo Molnar <mingo@kernel.org>

[ Upstream commit e23edc86b09df655bf8963bbcb16647adc787395 ]

The name is a bit opaque - make it clear that this is about wakeup
preemption.

Also rename the ->check_preempt_curr() methods similarly.

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Stable-dep-of: 0664e2c311b9 ("sched/deadline: Fix warning in migrate_enable for boosted tasks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c      | 14 +++++++-------
 kernel/sched/deadline.c  | 10 +++++-----
 kernel/sched/fair.c      | 10 +++++-----
 kernel/sched/idle.c      |  4 ++--
 kernel/sched/rt.c        |  6 +++---
 kernel/sched/sched.h     |  4 ++--
 kernel/sched/stop_task.c |  4 ++--
 7 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index da14c7450156b..7181e6aae16b4 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2214,10 +2214,10 @@ static inline void check_class_changed(struct rq *rq, struct task_struct *p,
 		p->sched_class->prio_changed(rq, p, oldprio);
 }
 
-void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
+void wakeup_preempt(struct rq *rq, struct task_struct *p, int flags)
 {
 	if (p->sched_class == rq->curr->sched_class)
-		rq->curr->sched_class->check_preempt_curr(rq, p, flags);
+		rq->curr->sched_class->wakeup_preempt(rq, p, flags);
 	else if (sched_class_above(p->sched_class, rq->curr->sched_class))
 		resched_curr(rq);
 
@@ -2523,7 +2523,7 @@ static struct rq *move_queued_task(struct rq *rq, struct rq_flags *rf,
 	rq_lock(rq, rf);
 	WARN_ON_ONCE(task_cpu(p) != new_cpu);
 	activate_task(rq, p, 0);
-	check_preempt_curr(rq, p, 0);
+	wakeup_preempt(rq, p, 0);
 
 	return rq;
 }
@@ -3409,7 +3409,7 @@ static void __migrate_swap_task(struct task_struct *p, int cpu)
 		deactivate_task(src_rq, p, 0);
 		set_task_cpu(p, cpu);
 		activate_task(dst_rq, p, 0);
-		check_preempt_curr(dst_rq, p, 0);
+		wakeup_preempt(dst_rq, p, 0);
 
 		rq_unpin_lock(dst_rq, &drf);
 		rq_unpin_lock(src_rq, &srf);
@@ -3785,7 +3785,7 @@ ttwu_do_activate(struct rq *rq, struct task_struct *p, int wake_flags,
 	}
 
 	activate_task(rq, p, en_flags);
-	check_preempt_curr(rq, p, wake_flags);
+	wakeup_preempt(rq, p, wake_flags);
 
 	ttwu_do_wakeup(p);
 
@@ -3856,7 +3856,7 @@ static int ttwu_runnable(struct task_struct *p, int wake_flags)
 			 * it should preempt the task that is current now.
 			 */
 			update_rq_clock(rq);
-			check_preempt_curr(rq, p, wake_flags);
+			wakeup_preempt(rq, p, wake_flags);
 		}
 		ttwu_do_wakeup(p);
 		ret = 1;
@@ -4871,7 +4871,7 @@ void wake_up_new_task(struct task_struct *p)
 
 	activate_task(rq, p, ENQUEUE_NOCLOCK);
 	trace_sched_wakeup_new(p);
-	check_preempt_curr(rq, p, WF_FORK);
+	wakeup_preempt(rq, p, WF_FORK);
 #ifdef CONFIG_SMP
 	if (p->sched_class->task_woken) {
 		/*
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index d78f2e8769fb4..36aeaaf9ab090 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -763,7 +763,7 @@ static inline void deadline_queue_pull_task(struct rq *rq)
 
 static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags);
 static void __dequeue_task_dl(struct rq *rq, struct task_struct *p, int flags);
-static void check_preempt_curr_dl(struct rq *rq, struct task_struct *p, int flags);
+static void wakeup_preempt_dl(struct rq *rq, struct task_struct *p, int flags);
 
 static inline void replenish_dl_new_period(struct sched_dl_entity *dl_se,
 					    struct rq *rq)
@@ -1175,7 +1175,7 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
 
 	enqueue_task_dl(rq, p, ENQUEUE_REPLENISH);
 	if (dl_task(rq->curr))
-		check_preempt_curr_dl(rq, p, 0);
+		wakeup_preempt_dl(rq, p, 0);
 	else
 		resched_curr(rq);
 
@@ -1939,7 +1939,7 @@ static int balance_dl(struct rq *rq, struct task_struct *p, struct rq_flags *rf)
  * Only called when both the current and waking task are -deadline
  * tasks.
  */
-static void check_preempt_curr_dl(struct rq *rq, struct task_struct *p,
+static void wakeup_preempt_dl(struct rq *rq, struct task_struct *p,
 				  int flags)
 {
 	if (dl_entity_preempt(&p->dl, &rq->curr->dl)) {
@@ -2654,7 +2654,7 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
 			deadline_queue_push_tasks(rq);
 #endif
 		if (dl_task(rq->curr))
-			check_preempt_curr_dl(rq, p, 0);
+			wakeup_preempt_dl(rq, p, 0);
 		else
 			resched_curr(rq);
 	} else {
@@ -2723,7 +2723,7 @@ DEFINE_SCHED_CLASS(dl) = {
 	.dequeue_task		= dequeue_task_dl,
 	.yield_task		= yield_task_dl,
 
-	.check_preempt_curr	= check_preempt_curr_dl,
+	.wakeup_preempt		= wakeup_preempt_dl,
 
 	.pick_next_task		= pick_next_task_dl,
 	.put_prev_task		= put_prev_task_dl,
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 685774895bcec..a32d344623716 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8268,7 +8268,7 @@ static void check_preempt_wakeup_fair(struct rq *rq, struct task_struct *p, int
 
 	/*
 	 * This is possible from callers such as attach_tasks(), in which we
-	 * unconditionally check_preempt_curr() after an enqueue (which may have
+	 * unconditionally wakeup_preempt() after an enqueue (which may have
 	 * lead to a throttle).  This both saves work and prevents false
 	 * next-buddy nomination below.
 	 */
@@ -9167,7 +9167,7 @@ static void attach_task(struct rq *rq, struct task_struct *p)
 
 	WARN_ON_ONCE(task_rq(p) != rq);
 	activate_task(rq, p, ENQUEUE_NOCLOCK);
-	check_preempt_curr(rq, p, 0);
+	wakeup_preempt(rq, p, 0);
 }
 
 /*
@@ -12641,7 +12641,7 @@ prio_changed_fair(struct rq *rq, struct task_struct *p, int oldprio)
 		if (p->prio > oldprio)
 			resched_curr(rq);
 	} else
-		check_preempt_curr(rq, p, 0);
+		wakeup_preempt(rq, p, 0);
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -12743,7 +12743,7 @@ static void switched_to_fair(struct rq *rq, struct task_struct *p)
 		if (task_current(rq, p))
 			resched_curr(rq);
 		else
-			check_preempt_curr(rq, p, 0);
+			wakeup_preempt(rq, p, 0);
 	}
 }
 
@@ -13102,7 +13102,7 @@ DEFINE_SCHED_CLASS(fair) = {
 	.yield_task		= yield_task_fair,
 	.yield_to_task		= yield_to_task_fair,
 
-	.check_preempt_curr	= check_preempt_wakeup_fair,
+	.wakeup_preempt		= check_preempt_wakeup_fair,
 
 	.pick_next_task		= __pick_next_task_fair,
 	.put_prev_task		= put_prev_task_fair,
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 5007b25c5bc65..565f8374ddbbf 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -401,7 +401,7 @@ balance_idle(struct rq *rq, struct task_struct *prev, struct rq_flags *rf)
 /*
  * Idle tasks are unconditionally rescheduled:
  */
-static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p, int flags)
+static void wakeup_preempt_idle(struct rq *rq, struct task_struct *p, int flags)
 {
 	resched_curr(rq);
 }
@@ -482,7 +482,7 @@ DEFINE_SCHED_CLASS(idle) = {
 	/* dequeue is not valid, we print a debug message there: */
 	.dequeue_task		= dequeue_task_idle,
 
-	.check_preempt_curr	= check_preempt_curr_idle,
+	.wakeup_preempt		= wakeup_preempt_idle,
 
 	.pick_next_task		= pick_next_task_idle,
 	.put_prev_task		= put_prev_task_idle,
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 4ac36eb4cdee5..a8c47d8d51bde 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -957,7 +957,7 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 
 				/*
 				 * When we're idle and a woken (rt) task is
-				 * throttled check_preempt_curr() will set
+				 * throttled wakeup_preempt() will set
 				 * skip_update and the time between the wakeup
 				 * and this unthrottle will get accounted as
 				 * 'runtime'.
@@ -1719,7 +1719,7 @@ static int balance_rt(struct rq *rq, struct task_struct *p, struct rq_flags *rf)
 /*
  * Preempt the current task with a newly woken task if needed:
  */
-static void check_preempt_curr_rt(struct rq *rq, struct task_struct *p, int flags)
+static void wakeup_preempt_rt(struct rq *rq, struct task_struct *p, int flags)
 {
 	if (p->prio < rq->curr->prio) {
 		resched_curr(rq);
@@ -2710,7 +2710,7 @@ DEFINE_SCHED_CLASS(rt) = {
 	.dequeue_task		= dequeue_task_rt,
 	.yield_task		= yield_task_rt,
 
-	.check_preempt_curr	= check_preempt_curr_rt,
+	.wakeup_preempt		= wakeup_preempt_rt,
 
 	.pick_next_task		= pick_next_task_rt,
 	.put_prev_task		= put_prev_task_rt,
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 8cbbbea7fdbbd..0e289300fe78d 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2242,7 +2242,7 @@ struct sched_class {
 	void (*yield_task)   (struct rq *rq);
 	bool (*yield_to_task)(struct rq *rq, struct task_struct *p);
 
-	void (*check_preempt_curr)(struct rq *rq, struct task_struct *p, int flags);
+	void (*wakeup_preempt)(struct rq *rq, struct task_struct *p, int flags);
 
 	struct task_struct *(*pick_next_task)(struct rq *rq);
 
@@ -2516,7 +2516,7 @@ static inline void sub_nr_running(struct rq *rq, unsigned count)
 extern void activate_task(struct rq *rq, struct task_struct *p, int flags);
 extern void deactivate_task(struct rq *rq, struct task_struct *p, int flags);
 
-extern void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags);
+extern void wakeup_preempt(struct rq *rq, struct task_struct *p, int flags);
 
 #ifdef CONFIG_PREEMPT_RT
 #define SCHED_NR_MIGRATE_BREAK 8
diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
index 85590599b4d60..6cf7304e6449d 100644
--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -23,7 +23,7 @@ balance_stop(struct rq *rq, struct task_struct *prev, struct rq_flags *rf)
 #endif /* CONFIG_SMP */
 
 static void
-check_preempt_curr_stop(struct rq *rq, struct task_struct *p, int flags)
+wakeup_preempt_stop(struct rq *rq, struct task_struct *p, int flags)
 {
 	/* we're never preempted */
 }
@@ -120,7 +120,7 @@ DEFINE_SCHED_CLASS(stop) = {
 	.dequeue_task		= dequeue_task_stop,
 	.yield_task		= yield_task_stop,
 
-	.check_preempt_curr	= check_preempt_curr_stop,
+	.wakeup_preempt		= wakeup_preempt_stop,
 
 	.pick_next_task		= pick_next_task_stop,
 	.put_prev_task		= put_prev_task_stop,
-- 
2.43.0



