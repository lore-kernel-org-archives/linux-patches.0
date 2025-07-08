Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF62289E2C;
	Tue,  8 Jul 2025 16:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992883; cv=none; b=Bbm1F1aQ1ZEP60mbCd1yJ82G8N3huBzS9DNjGCh7KG9RNbWdwHdY092COGIhO8WmXgP4OVTi/kYnJ6g6Sr7aBnVePkiM7AZBUf8NQugV2Ip+HQZcDMTxNagLB6sDPTrTQvvN895NFHApicm7ha9m+dBrI7j2EeyphGJgQNN4fps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992883; c=relaxed/simple;
	bh=NayUoOfdM0tLCbH52YgVb+N1lGVIDZC0CXXHlPNxTVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qIMw8TjDsAUIeCQmCI/5e/9kGwvAV+6rNJ/vbksoxO7Eq/LQkfHgA4oQV5WoY7uu9ZkHzPaIlLfZs/oxEIQOG9yXe0WsVrlJKt7ZOQoa+tmg+1cYRCGboQl9YZ4U9bncCBT3mt8Z7kDPIyX6bfsNYGfTej3R0sC8pWeBLcYbRFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MKVF0U8Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MKVF0U8Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD6BAC4CEED;
	Tue,  8 Jul 2025 16:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992883;
	bh=NayUoOfdM0tLCbH52YgVb+N1lGVIDZC0CXXHlPNxTVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MKVF0U8QzxJ67io3QG9UybZFV0qH0GsPG5TuxQYldWjt/dsKo6ino2531/nXSj2dc
	 1/akFRroH0q4IiGEIe7eZeczZHd1eix+9Barv+l3cym07xoO7jV66RBBMSLRAwy8KQ
	 MXBAycZ/S4FT5lVxS7ybyY8sJ+OQG5sh9fFSQKtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 114/232] sched/fair: Add new cfs_rq.h_nr_runnable
Date: Tue,  8 Jul 2025 18:21:50 +0200
Message-ID: <20250708162244.422660506@linuxfoundation.org>
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

[ Upstream commit c2a295bffeaf9461ecba76dc9e4780c898c94f03 ]

With delayed dequeued feature, a sleeping sched_entity remains queued in
the rq until its lag has elapsed. As a result, it stays also visible
in the statistics that are used to balance the system and in particular
the field cfs.h_nr_queued when the sched_entity is associated to a task.

Create a new h_nr_runnable that tracks only queued and runnable tasks.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Link: https://lore.kernel.org/r/20241202174606.4074512-5-vincent.guittot@linaro.org
Stable-dep-of: aa3ee4f0b754 ("sched/fair: Fixup wake_up_sync() vs DELAYED_DEQUEUE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/debug.c |  1 +
 kernel/sched/fair.c  | 20 ++++++++++++++++++--
 kernel/sched/sched.h |  1 +
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 7cf0c138c78e5..9815f9a0cd592 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -843,6 +843,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 	spread = right_vruntime - left_vruntime;
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "spread", SPLIT_NS(spread));
 	SEQ_printf(m, "  .%-30s: %d\n", "nr_running", cfs_rq->nr_running);
+	SEQ_printf(m, "  .%-30s: %d\n", "h_nr_runnable", cfs_rq->h_nr_runnable);
 	SEQ_printf(m, "  .%-30s: %d\n", "h_nr_queued", cfs_rq->h_nr_queued);
 	SEQ_printf(m, "  .%-30s: %d\n", "h_nr_delayed", cfs_rq->h_nr_delayed);
 	SEQ_printf(m, "  .%-30s: %d\n", "idle_nr_running",
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 33438b6c35478..47ff4856561ea 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5511,6 +5511,7 @@ static void set_delayed(struct sched_entity *se)
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
+		cfs_rq->h_nr_runnable--;
 		cfs_rq->h_nr_delayed++;
 		if (cfs_rq_throttled(cfs_rq))
 			break;
@@ -5533,6 +5534,7 @@ static void clear_delayed(struct sched_entity *se)
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
+		cfs_rq->h_nr_runnable++;
 		cfs_rq->h_nr_delayed--;
 		if (cfs_rq_throttled(cfs_rq))
 			break;
@@ -5985,7 +5987,7 @@ static bool throttle_cfs_rq(struct cfs_rq *cfs_rq)
 	struct rq *rq = rq_of(cfs_rq);
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
 	struct sched_entity *se;
-	long queued_delta, idle_task_delta, delayed_delta, dequeue = 1;
+	long queued_delta, runnable_delta, idle_task_delta, delayed_delta, dequeue = 1;
 	long rq_h_nr_queued = rq->cfs.h_nr_queued;
 
 	raw_spin_lock(&cfs_b->lock);
@@ -6017,6 +6019,7 @@ static bool throttle_cfs_rq(struct cfs_rq *cfs_rq)
 	rcu_read_unlock();
 
 	queued_delta = cfs_rq->h_nr_queued;
+	runnable_delta = cfs_rq->h_nr_runnable;
 	idle_task_delta = cfs_rq->idle_h_nr_running;
 	delayed_delta = cfs_rq->h_nr_delayed;
 	for_each_sched_entity(se) {
@@ -6041,6 +6044,7 @@ static bool throttle_cfs_rq(struct cfs_rq *cfs_rq)
 			idle_task_delta = cfs_rq->h_nr_queued;
 
 		qcfs_rq->h_nr_queued -= queued_delta;
+		qcfs_rq->h_nr_runnable -= runnable_delta;
 		qcfs_rq->idle_h_nr_running -= idle_task_delta;
 		qcfs_rq->h_nr_delayed -= delayed_delta;
 
@@ -6064,6 +6068,7 @@ static bool throttle_cfs_rq(struct cfs_rq *cfs_rq)
 			idle_task_delta = cfs_rq->h_nr_queued;
 
 		qcfs_rq->h_nr_queued -= queued_delta;
+		qcfs_rq->h_nr_runnable -= runnable_delta;
 		qcfs_rq->idle_h_nr_running -= idle_task_delta;
 		qcfs_rq->h_nr_delayed -= delayed_delta;
 	}
@@ -6091,7 +6096,7 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 	struct rq *rq = rq_of(cfs_rq);
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
 	struct sched_entity *se;
-	long queued_delta, idle_task_delta, delayed_delta;
+	long queued_delta, runnable_delta, idle_task_delta, delayed_delta;
 	long rq_h_nr_queued = rq->cfs.h_nr_queued;
 
 	se = cfs_rq->tg->se[cpu_of(rq)];
@@ -6126,6 +6131,7 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 	}
 
 	queued_delta = cfs_rq->h_nr_queued;
+	runnable_delta = cfs_rq->h_nr_runnable;
 	idle_task_delta = cfs_rq->idle_h_nr_running;
 	delayed_delta = cfs_rq->h_nr_delayed;
 	for_each_sched_entity(se) {
@@ -6144,6 +6150,7 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 			idle_task_delta = cfs_rq->h_nr_queued;
 
 		qcfs_rq->h_nr_queued += queued_delta;
+		qcfs_rq->h_nr_runnable += runnable_delta;
 		qcfs_rq->idle_h_nr_running += idle_task_delta;
 		qcfs_rq->h_nr_delayed += delayed_delta;
 
@@ -6162,6 +6169,7 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 			idle_task_delta = cfs_rq->h_nr_queued;
 
 		qcfs_rq->h_nr_queued += queued_delta;
+		qcfs_rq->h_nr_runnable += runnable_delta;
 		qcfs_rq->idle_h_nr_running += idle_task_delta;
 		qcfs_rq->h_nr_delayed += delayed_delta;
 
@@ -7081,6 +7089,8 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		enqueue_entity(cfs_rq, se, flags);
 		slice = cfs_rq_min_slice(cfs_rq);
 
+		if (!h_nr_delayed)
+			cfs_rq->h_nr_runnable++;
 		cfs_rq->h_nr_queued++;
 		cfs_rq->idle_h_nr_running += idle_h_nr_running;
 		cfs_rq->h_nr_delayed += h_nr_delayed;
@@ -7107,6 +7117,8 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 			min_vruntime_cb_propagate(&se->run_node, NULL);
 		slice = cfs_rq_min_slice(cfs_rq);
 
+		if (!h_nr_delayed)
+			cfs_rq->h_nr_runnable++;
 		cfs_rq->h_nr_queued++;
 		cfs_rq->idle_h_nr_running += idle_h_nr_running;
 		cfs_rq->h_nr_delayed += h_nr_delayed;
@@ -7195,6 +7207,8 @@ static int dequeue_entities(struct rq *rq, struct sched_entity *se, int flags)
 			break;
 		}
 
+		if (!h_nr_delayed)
+			cfs_rq->h_nr_runnable -= h_nr_queued;
 		cfs_rq->h_nr_queued -= h_nr_queued;
 		cfs_rq->idle_h_nr_running -= idle_h_nr_running;
 		cfs_rq->h_nr_delayed -= h_nr_delayed;
@@ -7236,6 +7250,8 @@ static int dequeue_entities(struct rq *rq, struct sched_entity *se, int flags)
 			min_vruntime_cb_propagate(&se->run_node, NULL);
 		slice = cfs_rq_min_slice(cfs_rq);
 
+		if (!h_nr_delayed)
+			cfs_rq->h_nr_runnable -= h_nr_queued;
 		cfs_rq->h_nr_queued -= h_nr_queued;
 		cfs_rq->idle_h_nr_running -= idle_h_nr_running;
 		cfs_rq->h_nr_delayed -= h_nr_delayed;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index dc338f4f911dd..e7f5ab21221c4 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -652,6 +652,7 @@ struct cfs_rq {
 	struct load_weight	load;
 	unsigned int		nr_running;
 	unsigned int		h_nr_queued;       /* SCHED_{NORMAL,BATCH,IDLE} */
+	unsigned int		h_nr_runnable;     /* SCHED_{NORMAL,BATCH,IDLE} */
 	unsigned int		idle_nr_running;   /* SCHED_IDLE */
 	unsigned int		idle_h_nr_running; /* SCHED_IDLE */
 	unsigned int		h_nr_delayed;
-- 
2.39.5



