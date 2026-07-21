Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6CE46C4D7;
	Tue, 21 Jul 2026 15:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648530; cv=none; b=mNm1/mumgOQz2gnhOiCkiSYu5F7qK+a8eILdVe3VzdBccJPlLxWCXlVxpaoBSjzGFJKdeOaJLQPv88BugfXsDmi6B1fRkxPSymr8BDwEdil6NY7M8GQKk/rfuC9QyxVA/qyk6EA1Ijq3VUSWXUVWjFqJyvKuPVnNK8C7NNJJ8Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648530; c=relaxed/simple;
	bh=oYbA9XtxOXRgi07tVUPZywjEta4S1br+hGAcsPspEk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCFq6JW0I213nKpxstg2g/K3LD8kEL+BrHWWhXZIFZRHkRlIiTNRFB8LLTNYTKQLc/PQbGoCX5nv90W7iNRdn4CsPM7GJSIQdR8sdzBEFPoo/y0B8ny6X4F0wcCXQbfK1Lp8o1ZsbhKNPXqradFvFU/jHHj5PBglg+naEtAqUqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0FzL/7hQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0FzL/7hQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90BF71F00A3A;
	Tue, 21 Jul 2026 15:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648529;
	bh=3edNQZ9vfjsh5GfXfOngNprgMnOLu0M0vxFtxcRXYHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0FzL/7hQRf+P3cKziOGIo7DvNQF2Ocji4NEvCgn15dnMEj5CzuE7CgfnP0aAi9hBb
	 2n5t3sFfSu7kybUdZBPj7dCn+9kNUiwVXCux4DHJBOhwJ9YzhjPFDsHzP8rkgn9MSc
	 6ReJFLIG9xAhhBGIxi5iZ3o9vLqwoXY409rHtLKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qais Yousef <qyousef@layalina.io>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0235/2077] sched/fair: Update util_est after updating util_avg during dequeue
Date: Tue, 21 Jul 2026 16:58:28 +0200
Message-ID: <20260721152558.217662938@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit 6d2051403d6c93832d3058a1b275c6aef2c97f44 ]

util_est_update() must be called after updating util_avg during the dequeue
of a task and only when the task is not delayed dequeue.

Move util_est_update() in update_load_avg().

Fixes: b55945c500c5 ("sched: Fix pick_next_task_fair() vs try_to_wake_up() race")
Closes: https://lore.kernel.org/all/20260512124653.305275-1-qyousef@layalina.io/
Reported-by: Qais Yousef <qyousef@layalina.io>
Reviewed-and-tested-by: Qais Yousef <qyousef@layalina.io>
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260518102345.268452-1-vincent.guittot@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 188 ++++++++++++++++++++++----------------------
 1 file changed, 92 insertions(+), 96 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3ebec186f98236..bcc984e462272d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4959,13 +4959,86 @@ static void detach_entity_load_avg(struct cfs_rq *cfs_rq, struct sched_entity *s
 	trace_pelt_cfs_tp(cfs_rq);
 }
 
+#define UTIL_EST_MARGIN (SCHED_CAPACITY_SCALE / 100)
+
+static inline void util_est_update(struct sched_entity *se)
+{
+	unsigned int ewma, dequeued, last_ewma_diff;
+
+	if (!sched_feat(UTIL_EST))
+		return;
+
+	/* Get current estimate of utilization */
+	ewma = READ_ONCE(se->avg.util_est);
+
+	/*
+	 * If the PELT values haven't changed since enqueue time,
+	 * skip the util_est update.
+	 */
+	if (ewma & UTIL_AVG_UNCHANGED)
+		return;
+
+	/* Get utilization at dequeue */
+	dequeued = READ_ONCE(se->avg.util_avg);
+
+	/*
+	 * Reset EWMA on utilization increases, the moving average is used only
+	 * to smooth utilization decreases.
+	 */
+	if (ewma <= dequeued) {
+		ewma = dequeued;
+		goto done;
+	}
+
+	/*
+	 * Skip update of task's estimated utilization when its members are
+	 * already ~1% close to its last activation value.
+	 */
+	last_ewma_diff = ewma - dequeued;
+	if (last_ewma_diff < UTIL_EST_MARGIN)
+		goto done;
+
+	/*
+	 * To avoid underestimate of task utilization, skip updates of EWMA if
+	 * we cannot grant that thread got all CPU time it wanted.
+	 */
+	if ((dequeued + UTIL_EST_MARGIN) < READ_ONCE(se->avg.runnable_avg))
+		goto done;
+
+	/*
+	 * Update Task's estimated utilization
+	 *
+	 * When *p completes an activation we can consolidate another sample
+	 * of the task size. This is done by using this value to update the
+	 * Exponential Weighted Moving Average (EWMA):
+	 *
+	 *  ewma(t) = w *  task_util(p) + (1-w) * ewma(t-1)
+	 *          = w *  task_util(p) +         ewma(t-1)  - w * ewma(t-1)
+	 *          = w * (task_util(p) -         ewma(t-1)) +     ewma(t-1)
+	 *          = w * (      -last_ewma_diff           ) +     ewma(t-1)
+	 *          = w * (-last_ewma_diff +  ewma(t-1) / w)
+	 *
+	 * Where 'w' is the weight of new samples, which is configured to be
+	 * 0.25, thus making w=1/4 ( >>= UTIL_EST_WEIGHT_SHIFT)
+	 */
+	ewma <<= UTIL_EST_WEIGHT_SHIFT;
+	ewma  -= last_ewma_diff;
+	ewma >>= UTIL_EST_WEIGHT_SHIFT;
+done:
+	ewma |= UTIL_AVG_UNCHANGED;
+	WRITE_ONCE(se->avg.util_est, ewma);
+
+	trace_sched_util_est_se_tp(se);
+}
+
 /*
  * Optional action to be done while updating the load average
  */
-#define UPDATE_TG	0x1
-#define SKIP_AGE_LOAD	0x2
-#define DO_ATTACH	0x4
-#define DO_DETACH	0x8
+#define UPDATE_TG	0x01
+#define SKIP_AGE_LOAD	0x02
+#define DO_ATTACH	0x04
+#define DO_DETACH	0x08
+#define UPDATE_UTIL_EST	0x10
 
 /* Update task and its cfs_rq load average */
 static inline void update_load_avg(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
@@ -5008,6 +5081,9 @@ static inline void update_load_avg(struct cfs_rq *cfs_rq, struct sched_entity *s
 		if (flags & UPDATE_TG)
 			update_tg_load_avg(cfs_rq);
 	}
+
+	if (flags & UPDATE_UTIL_EST)
+		util_est_update(se);
 }
 
 /*
@@ -5066,11 +5142,6 @@ static inline unsigned long task_util(struct task_struct *p)
 	return READ_ONCE(p->se.avg.util_avg);
 }
 
-static inline unsigned long task_runnable(struct task_struct *p)
-{
-	return READ_ONCE(p->se.avg.runnable_avg);
-}
-
 static inline unsigned long _task_util_est(struct task_struct *p)
 {
 	return READ_ONCE(p->se.avg.util_est) & ~UTIL_AVG_UNCHANGED;
@@ -5113,88 +5184,6 @@ static inline void util_est_dequeue(struct cfs_rq *cfs_rq,
 	trace_sched_util_est_cfs_tp(cfs_rq);
 }
 
-#define UTIL_EST_MARGIN (SCHED_CAPACITY_SCALE / 100)
-
-static inline void util_est_update(struct cfs_rq *cfs_rq,
-				   struct task_struct *p,
-				   bool task_sleep)
-{
-	unsigned int ewma, dequeued, last_ewma_diff;
-
-	if (!sched_feat(UTIL_EST))
-		return;
-
-	/*
-	 * Skip update of task's estimated utilization when the task has not
-	 * yet completed an activation, e.g. being migrated.
-	 */
-	if (!task_sleep)
-		return;
-
-	/* Get current estimate of utilization */
-	ewma = READ_ONCE(p->se.avg.util_est);
-
-	/*
-	 * If the PELT values haven't changed since enqueue time,
-	 * skip the util_est update.
-	 */
-	if (ewma & UTIL_AVG_UNCHANGED)
-		return;
-
-	/* Get utilization at dequeue */
-	dequeued = task_util(p);
-
-	/*
-	 * Reset EWMA on utilization increases, the moving average is used only
-	 * to smooth utilization decreases.
-	 */
-	if (ewma <= dequeued) {
-		ewma = dequeued;
-		goto done;
-	}
-
-	/*
-	 * Skip update of task's estimated utilization when its members are
-	 * already ~1% close to its last activation value.
-	 */
-	last_ewma_diff = ewma - dequeued;
-	if (last_ewma_diff < UTIL_EST_MARGIN)
-		goto done;
-
-	/*
-	 * To avoid underestimate of task utilization, skip updates of EWMA if
-	 * we cannot grant that thread got all CPU time it wanted.
-	 */
-	if ((dequeued + UTIL_EST_MARGIN) < task_runnable(p))
-		goto done;
-
-
-	/*
-	 * Update Task's estimated utilization
-	 *
-	 * When *p completes an activation we can consolidate another sample
-	 * of the task size. This is done by using this value to update the
-	 * Exponential Weighted Moving Average (EWMA):
-	 *
-	 *  ewma(t) = w *  task_util(p) + (1-w) * ewma(t-1)
-	 *          = w *  task_util(p) +         ewma(t-1)  - w * ewma(t-1)
-	 *          = w * (task_util(p) -         ewma(t-1)) +     ewma(t-1)
-	 *          = w * (      -last_ewma_diff           ) +     ewma(t-1)
-	 *          = w * (-last_ewma_diff +  ewma(t-1) / w)
-	 *
-	 * Where 'w' is the weight of new samples, which is configured to be
-	 * 0.25, thus making w=1/4 ( >>= UTIL_EST_WEIGHT_SHIFT)
-	 */
-	ewma <<= UTIL_EST_WEIGHT_SHIFT;
-	ewma  -= last_ewma_diff;
-	ewma >>= UTIL_EST_WEIGHT_SHIFT;
-done:
-	ewma |= UTIL_AVG_UNCHANGED;
-	WRITE_ONCE(p->se.avg.util_est, ewma);
-
-	trace_sched_util_est_se_tp(&p->se);
-}
-
 static inline unsigned long get_actual_cpu_capacity(int cpu)
 {
 	unsigned long capacity = arch_scale_cpu_capacity(cpu);
@@ -5647,7 +5636,7 @@ static bool
 dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 {
 	bool sleep = flags & DEQUEUE_SLEEP;
-	int action = UPDATE_TG;
+	int action = 0;
 
 	update_curr(cfs_rq);
 	clear_buddies(cfs_rq, se);
@@ -5667,15 +5656,23 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 
 		if (sched_feat(DELAY_DEQUEUE) && delay &&
 		    !entity_eligible(cfs_rq, se)) {
-			update_load_avg(cfs_rq, se, 0);
+			if (entity_is_task(se))
+				action |= UPDATE_UTIL_EST;
+			update_load_avg(cfs_rq, se, action);
 			update_entity_lag(cfs_rq, se);
 			set_delayed(se);
 			return false;
 		}
 	}
 
-	if (entity_is_task(se) && task_on_rq_migrating(task_of(se)))
-		action |= DO_DETACH;
+	action = UPDATE_TG;
+	if (entity_is_task(se)) {
+		if (task_on_rq_migrating(task_of(se)))
+			action |= DO_DETACH;
+
+		if (sleep && !(flags & DEQUEUE_DELAYED))
+			action |= UPDATE_UTIL_EST;
+	}
 
 	/*
 	 * When dequeuing a sched_entity, we must:
@@ -7438,7 +7435,6 @@ static bool dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	if (!p->se.sched_delayed)
 		util_est_dequeue(&rq->cfs, p);
 
-	util_est_update(&rq->cfs, p, flags & DEQUEUE_SLEEP);
 	if (dequeue_entities(rq, &p->se, flags) < 0)
 		return false;
 
-- 
2.53.0



