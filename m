Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22FE2C15AC;
	Thu, 28 May 2026 20:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000458; cv=none; b=JWm08oTTGRYwEtvCPl/FsgjvGlKAop+i4nW7++HqdJb7sG/s5tkxmdJAh38imJT0wYx1rOBrKPpftl2t1JC5wZaHuJQjNLPd5sBhEbAnRHO5j8Cj/o2S5FsW+dStiEpGa2qFGeuNeftzqBovzuZfXUJlS0MEbUbuKgNbJ4XkFhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000458; c=relaxed/simple;
	bh=gnvKV8PtreG+j2x3RAgQH7X22zS2hNFsTJeWQDHbVx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j0noEIr65r1m1OZxSILNz0ysDTI1VTZ8mEBvA8i80J5XwWgwUQepDaLScWUN2YY+AjsMDdzdMsFDL33qK2vo58H8FIfBZSWcY71yW+8E2wqBkb5UoeNszZwyJTJe/jhxsvsNOWqVzoqYcqD3/U0fCH9vQ68brY0p6g6DVb4AiE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gvExL9M7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gvExL9M7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78211F000E9;
	Thu, 28 May 2026 20:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000457;
	bh=4bzVyFxH91sf7ya/eRIkC2s0eSu18hOUVVJOGA3TD2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gvExL9M7XladyBzCqX1S+FUeZY+WFU954pM61ULedU6FpLTlN5zYWf9prYx/kgOlh
	 +mnNHNGN020oVjI5oL3Mhw1UBuezElDeAtEQYsen2ul9Rt9CA9vPxEFxE2/zCk8Soj
	 w6msyT5+VFUbTObM4EoyiidwmrRQ8te8QH8xMYf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Lukas Beckmann <lbckmnn@mailbox.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/272] sched/deadline: Less agressive dl_server handling
Date: Thu, 28 May 2026 21:46:29 +0200
Message-ID: <20260528194629.810918791@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit cccb45d7c4295bbfeba616582d0249f2d21e6df5 upstream.

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
[ adjust context for renamed/removed variable names ]
Signed-off-by: Lukas Beckmann <lbckmnn@mailbox.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched.h   |  1 +
 kernel/sched/deadline.c | 25 ++++++++++++++++++++++---
 kernel/sched/fair.c     |  9 ---------
 3 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2e4c437c7c902..299a65a92d2e6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -674,6 +674,7 @@ struct sched_dl_entity {
 	unsigned int			dl_defer	  : 1;
 	unsigned int			dl_defer_armed	  : 1;
 	unsigned int			dl_defer_running  : 1;
+	unsigned int			dl_server_idle    : 1;
 
 	/*
 	 * Bandwidth enforcement timer. Each -deadline task has its
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 1ef891f8e3f2f..9c5fa95b345a5 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1201,6 +1201,8 @@ static void __push_dl_task(struct rq *rq, struct rq_flags *rf)
 /* a defer timer will not be reset if the runtime consumed was < dl_server_min_res */
 static const u64 dl_server_min_res = 1 * NSEC_PER_MSEC;
 
+static bool dl_server_stopped(struct sched_dl_entity *dl_se);
+
 static enum hrtimer_restart dl_server_timer(struct hrtimer *timer, struct sched_dl_entity *dl_se)
 {
 	struct rq *rq = rq_of_dl_se(dl_se);
@@ -1220,6 +1222,7 @@ static enum hrtimer_restart dl_server_timer(struct hrtimer *timer, struct sched_
 
 		if (!dl_se->server_has_tasks(dl_se)) {
 			replenish_dl_entity(dl_se);
+			dl_server_stopped(dl_se);
 			return HRTIMER_NORESTART;
 		}
 
@@ -1626,8 +1629,10 @@ void dl_server_update_idle_time(struct rq *rq, struct task_struct *p)
 void dl_server_update(struct sched_dl_entity *dl_se, s64 delta_exec)
 {
 	/* 0 runtime = fair server disabled */
-	if (dl_se->dl_runtime)
+	if (dl_se->dl_runtime) {
+		dl_se->dl_server_idle = 0;
 		update_curr_dl_se(dl_se->rq, dl_se, delta_exec);
+	}
 }
 
 /*
@@ -1850,7 +1855,7 @@ void dl_server_start(struct sched_dl_entity *dl_se)
 		setup_new_dl_entity(dl_se);
 	}
 
-	if (!dl_se->dl_runtime)
+	if (!dl_se->dl_runtime || dl_se->dl_server_active)
 		return;
 
 	dl_se->dl_server_active = 1;
@@ -1871,6 +1876,20 @@ void dl_server_stop(struct sched_dl_entity *dl_se)
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
@@ -2628,7 +2647,7 @@ static struct task_struct *__pick_task_dl(struct rq *rq)
 	if (dl_server(dl_se)) {
 		p = dl_se->server_pick_task(dl_se);
 		if (!p) {
-			if (dl_server_active(dl_se)) {
+			if (!dl_server_stopped(dl_se)) {
 				dl_se->dl_yielded = 1;
 				update_curr_dl_se(rq, dl_se, 0);
 			}
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a0a47e50b71ca..d26e078d0623f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5972,7 +5972,6 @@ static bool throttle_cfs_rq(struct cfs_rq *cfs_rq)
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
 	struct sched_entity *se;
 	long queued_delta, runnable_delta, idle_task_delta, delayed_delta, dequeue = 1;
-	long rq_h_nr_queued = rq->cfs.h_nr_queued;
 
 	raw_spin_lock(&cfs_b->lock);
 	/* This will start the period timer if necessary */
@@ -6059,10 +6058,6 @@ static bool throttle_cfs_rq(struct cfs_rq *cfs_rq)
 
 	/* At this point se is NULL and we are at root level*/
 	sub_nr_running(rq, queued_delta);
-
-	/* Stop the fair server if throttling resulted in no runnable tasks */
-	if (rq_h_nr_queued && !rq->cfs.h_nr_queued)
-		dl_server_stop(&rq->fair_server);
 done:
 	/*
 	 * Note: distribution will already see us throttled via the
@@ -7162,7 +7157,6 @@ static void set_next_buddy(struct sched_entity *se);
 static int dequeue_entities(struct rq *rq, struct sched_entity *se, int flags)
 {
 	bool was_sched_idle = sched_idle_rq(rq);
-	int rq_h_nr_queued = rq->cfs.h_nr_queued;
 	bool task_sleep = flags & DEQUEUE_SLEEP;
 	bool task_delayed = flags & DEQUEUE_DELAYED;
 	struct task_struct *p = NULL;
@@ -7251,9 +7245,6 @@ static int dequeue_entities(struct rq *rq, struct sched_entity *se, int flags)
 
 	sub_nr_running(rq, h_nr_queued);
 
-	if (rq_h_nr_queued && !rq->cfs.h_nr_queued)
-		dl_server_stop(&rq->fair_server);
-
 	/* balance early to pull high priority tasks */
 	if (unlikely(!was_sched_idle && sched_idle_rq(rq)))
 		rq->next_balance = jiffies;
-- 
2.53.0



