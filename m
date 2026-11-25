Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623884;
	b=ukUXOxN98CH8tyckB1hRJtf9UccUud4K7Itq55osm023VWrUpdbquDXW1Up5qXO7yTzT
	 6/rq4X7bFyks6t9gTpKZ//MO/GONymsMf9XFY9BK+7eSXWjZaqLTLL2DDaaCTl5zUzMPL
	 hnTCVsFvmz5j68JoXm1TmGLDFbU1jBgZdmx9fkgEfdzPJLsOziWN7RBQ22WcXFWQ/+1y2
	 vGYPtl4U10uYWx120BzG7OTQVqC9XIhGifeYeiYh1sbQ9+y81DBQkvkTQQGFFPw+UF+7q
	 n4cs/KkxTrLtjgAp1IMdvqehBr0VHeGuv+5hm2F1Fr/hrvg9AmQmyQ84fm1dPlzQeSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623884;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fjlnVSOuc8pACYPnK2Mfc8j9AV8TKkvJ+uofARXINFk=;
	b=DabYe/XQFw7LxPTEmMtkvu/ENasAulZpQaVZ1DkLsnF0m/sSv4pmk9bDnMD3tMaKufBB
	 qz0ly1UP0p46g5fbd1Qm0ppvw/4+2zjFtlGu0T6HXjwKLwLoQ/atj5iec0d4bHH+dX8S9
	 uxcXdDkG/gQl1qcavfBoPk01SzRxaDK5fEIMHh7RAO3VorrMJOzgWErl/cYECB2jNffFy
	 ncxzpXySYVEkgkDvWQHo9LLHOA9MGel2Z2C8In4KDFTuvZndIip/2VK5tBcJ5ZF9N9K2c
	 jsNvbfE2Lugs0U0ZEwPf/VxCi/75ec5ry0OIG/v1paLxn89swx/1aEgRSNK7pzf3B9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hyI2pkGC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F481606A321;
	Wed, 25 Nov 2026 16:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hyI2pkGC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802DA1F000CF;
	Wed, 25 Nov 2026 16:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623884;
	bh=fjlnVSOuc8pACYPnK2Mfc8j9AV8TKkvJ+uofARXINFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hyI2pkGC6aVFQk+NOyp+fNzyGApNCjEzMNA95TS6+pbmeBvut/TerIqeWf05MBtAU
	 xJ2kOCI3sejbPGNsXZOcGVwozQpbVnPWRiZ6R4iMr+m2y/X54tGeJ0nPuEMu25JWrr
	 hVENFeh4/BbZySu6QkMQmdEApiaHYKcqVVEstqKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Florent Carli <fcarli@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 016/816] sched/deadline: Fix dl_server time accounting
Date: Wed, 25 Nov 2026 15:26:04 +0100
Message-ID: <20261125143849.592364643@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit e636ffb9e31b4f7dde7fef5358669266b9ce02ec upstream.

The dl_server time accounting code is a little odd. The normal scheduler
pattern is to update curr before doing something, such that the old state is
fully accounted before changing state.

Notably, the dl_server_timer() needs to propagate the current time accounting
since the current task could be ran by dl_server and thus this can affect
dl_se->runtime. Similarly for dl_server_start().

And since the (deferred) dl_server wants idle time accounted, rework
sched_idle_class time accounting to be more like all the others.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20251020141130.GJ3245006@noisy.programming.kicks-ass.net
[ Florent: rq->donor does not exist in 6.12, use rq->curr ]
Signed-off-by: Florent Carli <fcarli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 40 +++++++++++++++-------------------------
 kernel/sched/fair.c     |  9 ++-------
 kernel/sched/idle.c     | 16 +++++++++++++++-
 kernel/sched/sched.h    |  3 +--
 4 files changed, 33 insertions(+), 35 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index f5c64d1a019d5..2e3bd43afd535 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1216,8 +1216,12 @@ static enum hrtimer_restart dl_server_timer(struct hrtimer *timer, struct sched_
 		sched_clock_tick();
 		update_rq_clock(rq);
 
-		if (!dl_se->dl_runtime)
-			return HRTIMER_NORESTART;
+		/*
+		 * Make sure current has propagated its pending runtime into
+		 * any relevant server through calling dl_server_update() and
+		 * friends.
+		 */
+		rq->curr->sched_class->update_curr(rq);
 
 		if (dl_se->dl_defer_armed) {
 			/*
@@ -1594,35 +1598,16 @@ static void update_curr_dl_se(struct rq *rq, struct sched_dl_entity *dl_se, s64
  * as time available for the fair server, avoiding a penalty for the
  * rt scheduler that did not consumed that time.
  */
-void dl_server_update_idle_time(struct rq *rq, struct task_struct *p)
+void dl_server_update_idle(struct sched_dl_entity *dl_se, s64 delta_exec)
 {
-	s64 delta_exec;
-
-	if (!rq->fair_server.dl_defer)
-		return;
-
-	/* no need to discount more */
-	if (rq->fair_server.runtime < 0)
-		return;
-
-	delta_exec = rq_clock_task(rq) - p->se.exec_start;
-	if (delta_exec < 0)
-		return;
-
-	rq->fair_server.runtime -= delta_exec;
-
-	if (rq->fair_server.runtime < 0) {
-		rq->fair_server.dl_defer_running = 0;
-		rq->fair_server.runtime = 0;
-	}
-
-	p->se.exec_start = rq_clock_task(rq);
+	if (dl_se->dl_server_active && dl_se->dl_runtime && dl_se->dl_defer)
+		update_curr_dl_se(dl_se->rq, dl_se, delta_exec);
 }
 
 void dl_server_update(struct sched_dl_entity *dl_se, s64 delta_exec)
 {
 	/* 0 runtime = fair server disabled */
-	if (dl_se->dl_runtime)
+	if (dl_se->dl_server_active && dl_se->dl_runtime)
 		update_curr_dl_se(dl_se->rq, dl_se, delta_exec);
 }
 
@@ -1849,6 +1834,11 @@ void dl_server_start(struct sched_dl_entity *dl_se)
 	if (!dl_se->dl_runtime || dl_se->dl_server_active)
 		return;
 
+	/*
+	 * Update the current task to 'now'.
+	 */
+	rq->curr->sched_class->update_curr(rq);
+
 	if (WARN_ON_ONCE(!cpu_online(cpu_of(rq))))
 		return;
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 020a39fe0e7b3..7e5179189660b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1259,8 +1259,7 @@ static void update_curr(struct cfs_rq *cfs_rq)
 		 *    against fair_server such that it can account for this time
 		 *    and possibly avoid running this period.
 		 */
-		if (dl_server_active(&rq->fair_server))
-			dl_server_update(&rq->fair_server, delta_exec);
+		dl_server_update(&rq->fair_server, delta_exec);
 	}
 
 	account_cfs_rq_runtime(cfs_rq, delta_exec);
@@ -7114,12 +7113,8 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 			goto enqueue_throttle;
 	}
 
-	if (!rq_h_nr_queued && rq->cfs.h_nr_queued) {
-		/* Account for idle runtime */
-		if (!rq->nr_running)
-			dl_server_update_idle_time(rq, rq->curr);
+	if (!rq_h_nr_queued && rq->cfs.h_nr_queued)
 		dl_server_start(&rq->fair_server);
-	}
 
 	/* At this point se is NULL and we are at root level*/
 	add_nr_running(rq, 1);
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 1f0f0d9a5a5cf..a2ab252e7d53e 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -471,9 +471,11 @@ static void wakeup_preempt_idle(struct rq *rq, struct task_struct *p, int flags)
 	resched_curr(rq);
 }
 
+static void update_curr_idle(struct rq *rq);
+
 static void put_prev_task_idle(struct rq *rq, struct task_struct *prev, struct task_struct *next)
 {
-	dl_server_update_idle_time(rq, prev);
+	update_curr_idle(rq);
 	scx_update_idle(rq, false, true);
 }
 
@@ -521,6 +523,7 @@ dequeue_task_idle(struct rq *rq, struct task_struct *p, int flags)
  */
 static void task_tick_idle(struct rq *rq, struct task_struct *curr, int queued)
 {
+	update_curr_idle(rq);
 }
 
 static void switched_to_idle(struct rq *rq, struct task_struct *p)
@@ -536,6 +539,17 @@ prio_changed_idle(struct rq *rq, struct task_struct *p, int oldprio)
 
 static void update_curr_idle(struct rq *rq)
 {
+	struct sched_entity *se = &rq->idle->se;
+	u64 now = rq_clock_task(rq);
+	s64 delta_exec;
+
+	delta_exec = now - se->exec_start;
+	if (unlikely(delta_exec <= 0))
+		return;
+
+	se->exec_start = now;
+
+	dl_server_update_idle(&rq->fair_server, delta_exec);
 }
 
 /*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 5e788dc39f630..598dd26fe5a69 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -411,14 +411,13 @@ extern s64 dl_scaled_delta_exec(struct rq *rq, struct sched_dl_entity *dl_se, s6
  * naturally thottled to once per period, avoiding high context switch
  * workloads from spamming the hrtimer program/cancel paths.
  */
+extern void dl_server_update_idle(struct sched_dl_entity *dl_se, s64 delta_exec);
 extern void dl_server_update(struct sched_dl_entity *dl_se, s64 delta_exec);
 extern void dl_server_start(struct sched_dl_entity *dl_se);
 extern void dl_server_stop(struct sched_dl_entity *dl_se);
 extern void dl_server_init(struct sched_dl_entity *dl_se, struct rq *rq,
 		    dl_server_pick_f pick_task);
 
-extern void dl_server_update_idle_time(struct rq *rq,
-		    struct task_struct *p);
 extern void fair_server_init(struct rq *rq);
 extern void __dl_server_attach_root(struct sched_dl_entity *dl_se, struct rq *rq);
 extern int dl_server_apply_params(struct sched_dl_entity *dl_se,
-- 
2.53.0



