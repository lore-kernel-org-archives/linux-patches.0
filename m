Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4332FE565;
	Tue, 12 Aug 2025 18:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023850; cv=none; b=CCDG4d+Qgw03zMVCD8+/AVe15o4vSUF1pw6IK/VDUtIWcFUUZ8qCda1k5jRL163JReHnQF4gLOo01m6WGlpRTHqzKwITq4zVIB1/CpD4j0Om0AzgvDwRp36eeWBKoWCyLVsYfeLhvA/pvz1WxOXt8spey8c19Ds0nJDkZXFD9Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023850; c=relaxed/simple;
	bh=mKk/YAvKf9kz9NXfYTYQOIU9iY+ciXxXuSEUnGNB0v0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZOErlzuIX/uDULUJ4GU8ZkAqhz1QPn5ecPtgnefJ9EJR5R1+NU8oVRCIho6XGzgy4KpuwUy5a46tiHM+trAyBTjNp+88M39ZhLOqxwNQeY/guBLjVG65hupHbGQAMGo4Lpl1581EgoPDXI/XdDyb3jOeFXZOhYOvDORXLACE4ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=maUngckA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="maUngckA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B58C4CEF0;
	Tue, 12 Aug 2025 18:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023849;
	bh=mKk/YAvKf9kz9NXfYTYQOIU9iY+ciXxXuSEUnGNB0v0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=maUngckALr0JX/1B1sQB4wPLq2gGesvlsvclZGgrhRlB/dU7cRycmk4NF6w4HyQzu
	 GSaS+/xYx+IJTDVCz/rBqxIipd9K9HS7B5UPZcWDtx4s4bIK539X8OyD1DqMSzG0E4
	 CYK2xpLeJRPP3zjPvs7U9M/mi2+xIUkNldq5C+9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 199/627] sched/deadline: Less agressive dl_server handling
Date: Tue, 12 Aug 2025 19:28:14 +0200
Message-ID: <20250812173426.853672780@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit cccb45d7c4295bbfeba616582d0249f2d21e6df5 ]

Chris reported that commit 5f6bd380c7bd ("sched/rt: Remove default
bandwidth control") caused a significant dip in his favourite
benchmark of the day. Simply disabling dl_server cured things.

His workload hammers the 0->1, 1->0 transitions, and the
dl_server_{start,stop}() overhead kills it -- fairly obviously a bad
idea in hind sight and all that.

Change things around to only disable the dl_server when there has not
been a fair task around for a whole period. Since the default period
is 1 second, this ensures the benchmark never trips this, overhead
gone.

Fixes: 557a6bfc662c ("sched/fair: Add trivial fair server")
Reported-by: Chris Mason <clm@meta.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
Acked-by: Juri Lelli <juri.lelli@redhat.com>
Link: https://lkml.kernel.org/r/20250702121158.465086194@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched.h   |  1 +
 kernel/sched/deadline.c | 25 ++++++++++++++++++++++---
 kernel/sched/fair.c     |  9 ---------
 3 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index aa9c5be7a632..ae75562cca59 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -701,6 +701,7 @@ struct sched_dl_entity {
 	unsigned int			dl_defer	  : 1;
 	unsigned int			dl_defer_armed	  : 1;
 	unsigned int			dl_defer_running  : 1;
+	unsigned int			dl_server_idle    : 1;
 
 	/*
 	 * Bandwidth enforcement timer. Each -deadline task has its
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 89019a140826..094134c9b135 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1215,6 +1215,8 @@ static void __push_dl_task(struct rq *rq, struct rq_flags *rf)
 /* a defer timer will not be reset if the runtime consumed was < dl_server_min_res */
 static const u64 dl_server_min_res = 1 * NSEC_PER_MSEC;
 
+static bool dl_server_stopped(struct sched_dl_entity *dl_se);
+
 static enum hrtimer_restart dl_server_timer(struct hrtimer *timer, struct sched_dl_entity *dl_se)
 {
 	struct rq *rq = rq_of_dl_se(dl_se);
@@ -1234,6 +1236,7 @@ static enum hrtimer_restart dl_server_timer(struct hrtimer *timer, struct sched_
 
 		if (!dl_se->server_has_tasks(dl_se)) {
 			replenish_dl_entity(dl_se);
+			dl_server_stopped(dl_se);
 			return HRTIMER_NORESTART;
 		}
 
@@ -1639,8 +1642,10 @@ void dl_server_update_idle_time(struct rq *rq, struct task_struct *p)
 void dl_server_update(struct sched_dl_entity *dl_se, s64 delta_exec)
 {
 	/* 0 runtime = fair server disabled */
-	if (dl_se->dl_runtime)
+	if (dl_se->dl_runtime) {
+		dl_se->dl_server_idle = 0;
 		update_curr_dl_se(dl_se->rq, dl_se, delta_exec);
+	}
 }
 
 void dl_server_start(struct sched_dl_entity *dl_se)
@@ -1663,7 +1668,7 @@ void dl_server_start(struct sched_dl_entity *dl_se)
 		setup_new_dl_entity(dl_se);
 	}
 
-	if (!dl_se->dl_runtime)
+	if (!dl_se->dl_runtime || dl_se->dl_server_active)
 		return;
 
 	dl_se->dl_server_active = 1;
@@ -1684,6 +1689,20 @@ void dl_server_stop(struct sched_dl_entity *dl_se)
 	dl_se->dl_server_active = 0;
 }
 
+static bool dl_server_stopped(struct sched_dl_entity *dl_se)
+{
+	if (!dl_se->dl_server_active)
+		return false;
+
+	if (dl_se->dl_server_idle) {
+		dl_server_stop(dl_se);
+		return true;
+	}
+
+	dl_se->dl_server_idle = 1;
+	return false;
+}
+
 void dl_server_init(struct sched_dl_entity *dl_se, struct rq *rq,
 		    dl_server_has_tasks_f has_tasks,
 		    dl_server_pick_f pick_task)
@@ -2435,7 +2454,7 @@ static struct task_struct *__pick_task_dl(struct rq *rq)
 	if (dl_server(dl_se)) {
 		p = dl_se->server_pick_task(dl_se);
 		if (!p) {
-			if (dl_server_active(dl_se)) {
+			if (!dl_server_stopped(dl_se)) {
 				dl_se->dl_yielded = 1;
 				update_curr_dl_se(rq, dl_se, 0);
 			}
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7a14da5396fb..3ab8d4765edd 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5889,7 +5889,6 @@ static bool throttle_cfs_rq(struct cfs_rq *cfs_rq)
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
 	struct sched_entity *se;
 	long queued_delta, runnable_delta, idle_delta, dequeue = 1;
-	long rq_h_nr_queued = rq->cfs.h_nr_queued;
 
 	raw_spin_lock(&cfs_b->lock);
 	/* This will start the period timer if necessary */
@@ -5973,10 +5972,6 @@ static bool throttle_cfs_rq(struct cfs_rq *cfs_rq)
 
 	/* At this point se is NULL and we are at root level*/
 	sub_nr_running(rq, queued_delta);
-
-	/* Stop the fair server if throttling resulted in no runnable tasks */
-	if (rq_h_nr_queued && !rq->cfs.h_nr_queued)
-		dl_server_stop(&rq->fair_server);
 done:
 	/*
 	 * Note: distribution will already see us throttled via the
@@ -7070,7 +7065,6 @@ static void set_next_buddy(struct sched_entity *se);
 static int dequeue_entities(struct rq *rq, struct sched_entity *se, int flags)
 {
 	bool was_sched_idle = sched_idle_rq(rq);
-	int rq_h_nr_queued = rq->cfs.h_nr_queued;
 	bool task_sleep = flags & DEQUEUE_SLEEP;
 	bool task_delayed = flags & DEQUEUE_DELAYED;
 	struct task_struct *p = NULL;
@@ -7154,9 +7148,6 @@ static int dequeue_entities(struct rq *rq, struct sched_entity *se, int flags)
 
 	sub_nr_running(rq, h_nr_queued);
 
-	if (rq_h_nr_queued && !rq->cfs.h_nr_queued)
-		dl_server_stop(&rq->fair_server);
-
 	/* balance early to pull high priority tasks */
 	if (unlikely(!was_sched_idle && sched_idle_rq(rq)))
 		rq->next_balance = jiffies;
-- 
2.39.5



