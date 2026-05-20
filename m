Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4479D3F54D4;
	Wed, 20 May 2026 17:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299483; cv=none; b=iA8jJzc2l1m6J7yiGnMnsMkDoXfOyKZSgpY2TJ+JLI3dsI18Nt1MS4DjUDMdo6ApcbSVAKeTNdJCpfcR1CEG5aftQRagf51symbh6vet6cEfReVlE25rF2yCH+SWcPzwtiJP4FKK0DNBaX4he6cK/HnqNiISSZP3f42D+yELh3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299483; c=relaxed/simple;
	bh=CuthVG4D14aMvqUA6PXSecAFhEaTCnmE8DyhEyLvel8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XywmpmcfWqb/mj50oLv0mFDtX5FZO9PapDaMKi+kOSKv9ij+ju5h9LYdY3qHSAgQTpCfJ/D0ETST2LjTQ2msITaVvwyp57YqJEscFGgnd+pxAo2+b2QLP70hSMaefzW7BaSVYG88t2hmJyjhdsd+a7SO9FLVwmFK0lkt9+eewXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X9zV5YF9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X9zV5YF9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB651F00896;
	Wed, 20 May 2026 17:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299482;
	bh=7xCWUXU+UgrmiQBW1MXx68nnHAqM23hd9Nzj8UC0MMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X9zV5YF9KPmf8qETdUflkAq86cDNPkvBWemrF77jTkeqL1Wc/V60UH/R96x9c/Y6g
	 oYrlO2WVyfVjdikSU4fWWqU83zBMUmBwQnhZNdBgCCCmQgsLrwzn5XpweZqCJj0hc7
	 uk+VYX341U1gZMDptI2SlU/1qNZ7s4w0XosxdfW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 788/957] sched/fair: Fix wakeup_preempt_fair() vs delayed dequeue
Date: Wed, 20 May 2026 18:21:11 +0200
Message-ID: <20260520162151.651614361@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit ac8e69e693631689d74d8f1ebee6f84f737f797f ]

Similar to how pick_next_entity() must dequeue delayed entities, so too must
wakeup_preempt_fair(). Any delayed task being found means it is eligible and
hence past the 0-lag point, ready for removal.

Worse, by not removing delayed entities from consideration, it can skew the
preemption decision, with the end result that a short slice wakeup will not
result in a preemption.

                     tip/sched/core  tip/sched/core    +this patch
cyclictest slice  (ms) (default)2.8             8               8
hackbench slice   (ms) (default)2.8            20              20
Total Samples          |    22559           22595           22683
Average           (us) |      157              64( 59%)        59(  8%)
Median (P50)      (us) |       57              57(  0%)        58(- 2%)
90th Percentile   (us) |       64              60(  6%)        60(  0%)
99th Percentile   (us) |     2407              67( 97%)        67(  0%)
99.9th Percentile (us) |     3400            2288( 33%)       727( 68%)
Maximum           (us) |     5037            9252(-84%)      7461( 19%)

Fixes: f12e148892ed ("sched/fair: Prepare pick_next_task() for delayed dequeue")
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260422093400.319251-1-vincent.guittot@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 293a8804428b0..565a96d6811e7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1007,7 +1007,7 @@ static inline void cancel_protect_slice(struct sched_entity *se)
  *
  * Which allows tree pruning through eligibility.
  */
-static struct sched_entity *__pick_eevdf(struct cfs_rq *cfs_rq, bool protect)
+static struct sched_entity *pick_eevdf(struct cfs_rq *cfs_rq, bool protect)
 {
 	struct rb_node *node = cfs_rq->tasks_timeline.rb_root.rb_node;
 	struct sched_entity *se = __pick_first_entity(cfs_rq);
@@ -1078,11 +1078,6 @@ static struct sched_entity *__pick_eevdf(struct cfs_rq *cfs_rq, bool protect)
 	return best;
 }
 
-static struct sched_entity *pick_eevdf(struct cfs_rq *cfs_rq)
-{
-	return __pick_eevdf(cfs_rq, true);
-}
-
 struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
 {
 	struct rb_node *last = rb_last(&cfs_rq->tasks_timeline.rb_root);
@@ -5584,11 +5579,11 @@ static int dequeue_entities(struct rq *rq, struct sched_entity *se, int flags);
  * 4) do not run the "skip" process, if something else is available
  */
 static struct sched_entity *
-pick_next_entity(struct rq *rq, struct cfs_rq *cfs_rq)
+pick_next_entity(struct rq *rq, struct cfs_rq *cfs_rq, bool protect)
 {
 	struct sched_entity *se;
 
-	se = pick_eevdf(cfs_rq);
+	se = pick_eevdf(cfs_rq, protect);
 	if (se->sched_delayed) {
 		dequeue_entities(rq, se, DEQUEUE_SLEEP | DEQUEUE_DELAYED);
 		/*
@@ -8868,7 +8863,7 @@ static void check_preempt_wakeup_fair(struct rq *rq, struct task_struct *p, int
 {
 	enum preempt_wakeup_action preempt_action = PREEMPT_WAKEUP_PICK;
 	struct task_struct *donor = rq->donor;
-	struct sched_entity *se = &donor->se, *pse = &p->se;
+	struct sched_entity *nse, *se = &donor->se, *pse = &p->se;
 	struct cfs_rq *cfs_rq = task_cfs_rq(donor);
 	int cse_is_idle, pse_is_idle;
 
@@ -8983,11 +8978,17 @@ static void check_preempt_wakeup_fair(struct rq *rq, struct task_struct *p, int
 	}
 
 pick:
+	nse = pick_next_entity(rq, cfs_rq, preempt_action != PREEMPT_WAKEUP_SHORT);
+	/* If @p has become the most eligible task, force preemption */
+	if (nse == pse)
+		goto preempt;
+
 	/*
-	 * If @p has become the most eligible task, force preemption.
+	 * Because p is enqueued, nse being null can only mean that we
+	 * dequeued a delayed task.
 	 */
-	if (__pick_eevdf(cfs_rq, preempt_action != PREEMPT_WAKEUP_SHORT) == pse)
-		goto preempt;
+	if (!nse)
+		goto pick;
 
 	if (sched_feat(RUN_TO_PARITY))
 		update_protect_slice(cfs_rq, se);
@@ -9022,7 +9023,7 @@ static struct task_struct *pick_task_fair(struct rq *rq)
 
 		throttled |= check_cfs_rq_runtime(cfs_rq);
 
-		se = pick_next_entity(rq, cfs_rq);
+		se = pick_next_entity(rq, cfs_rq, true);
 		if (!se)
 			goto again;
 		cfs_rq = group_cfs_rq(se);
-- 
2.53.0



