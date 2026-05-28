Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21BE33987F;
	Thu, 28 May 2026 20:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000362; cv=none; b=XVOpoT8a+evfQ0OWY8/40r7gVqEZd6cCmFOClHnS4F0CvKVIrdE++7ok+I/XROgvcGL6TWMFo6Sy7LJPzYj8Ceykn87rPpPJ1pPPE/gHHC/64kHniXxKM7jCJjFpXcx5Y45ebe88TrRWXqB3eYtcpchIBV7lRXrT/nglflCQpm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000362; c=relaxed/simple;
	bh=nCAN7SWkn9jWUcZLIQXPOP1Rnh1u/CrH4uQMLaUwaWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DgYWy3r+HS0F043RyOsRn4VEolazC7gvCP/CzYGKlYYTLYIv+Wi7rtE4iNih0CJEidMbgD2cS6JQhqzpGE/P91fcWAmseO70Wcoz4rB3E5BDb2gQOvpOTmn44t0OglXeBTQ49hHBHAZ+q3XQ2eku+q7BfILWgOTI6LBpmHJWhyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h19TRPlT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h19TRPlT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015AB1F00A3A;
	Thu, 28 May 2026 20:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000360;
	bh=1FgtFi2AVLEZTI1VORZ/1N2wHVVYGGc5a5EgZhvIMNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h19TRPlTuodo19akuOI0n/kWXnL1f/fGy5tXCQ2Axpspe+O/pqXimlfNPeM91SxYv
	 4GTHTnDrwO2doy7eZKTWCD+nwWiN09oMbg+EAsQ4jt08hOEHzIAh/tipJp7ybF4ixf
	 akVMY5Lj/qheI5O5plpXSiskEA2gwHp32td3vzJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Stultz <jstultz@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Lukas Beckmann <lbckmnn@mailbox.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 018/272] sched/deadline: Fix dl_server getting stuck
Date: Thu, 28 May 2026 21:46:32 +0200
Message-ID: <20260528194629.892351076@linuxfoundation.org>
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

commit 4ae8d9aa9f9dc7137ea5e564d79c5aa5af1bc45c upstream.

John found it was easy to hit lockup warnings when running locktorture
on a 2 CPU VM, which he bisected down to: commit cccb45d7c429
("sched/deadline: Less agressive dl_server handling").

While debugging it seems there is a chance where we end up with the
dl_server dequeued, with dl_se->dl_server_active. This causes
dl_server_start() to return without enqueueing the dl_server, thus it
fails to run when RT tasks starve the cpu.

When this happens, dl_server_timer() catches the
'!dl_se->server_has_tasks(dl_se)' case, which then calls
replenish_dl_entity() and dl_server_stopped() and finally return
HRTIMER_NO_RESTART.

This ends in no new timer and also no enqueue, leaving the dl_server
'dead', allowing starvation.

What should have happened is for the bandwidth timer to start the
zero-laxity timer, which in turn would enqueue the dl_server and cause
dl_se->server_pick_task() to be called -- which will stop the
dl_server if no fair tasks are observed for a whole period.

IOW, it is totally irrelevant if there are fair tasks at the moment of
bandwidth refresh.

This removes all dl_se->server_has_tasks() users, so remove the whole
thing.

Fixes: cccb45d7c4295 ("sched/deadline: Less agressive dl_server handling")
Reported-by: John Stultz <jstultz@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: John Stultz <jstultz@google.com>
[ adjust renamed variable in fair_server_has_tasks (which this patch
removes) ]
Signed-off-by: Lukas Beckmann <lbckmnn@mailbox.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched.h   |  1 -
 kernel/sched/deadline.c | 12 +-----------
 kernel/sched/fair.c     |  7 +------
 kernel/sched/sched.h    |  4 ----
 4 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 299a65a92d2e6..464d281aa2e49 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -701,7 +701,6 @@ struct sched_dl_entity {
 	 * runnable task.
 	 */
 	struct rq			*rq;
-	dl_server_has_tasks_f		server_has_tasks;
 	dl_server_pick_f		server_pick_task;
 
 #ifdef CONFIG_RT_MUTEXES
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 6ff9055a69811..609783d7de290 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -916,7 +916,7 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 	 */
 	if (dl_se->dl_defer && !dl_se->dl_defer_running &&
 	    dl_time_before(rq_clock(dl_se->rq), dl_se->deadline - dl_se->runtime)) {
-		if (!is_dl_boosted(dl_se) && dl_se->server_has_tasks(dl_se)) {
+		if (!is_dl_boosted(dl_se)) {
 
 			/*
 			 * Set dl_se->dl_defer_armed and dl_throttled variables to
@@ -1201,8 +1201,6 @@ static void __push_dl_task(struct rq *rq, struct rq_flags *rf)
 /* a defer timer will not be reset if the runtime consumed was < dl_server_min_res */
 static const u64 dl_server_min_res = 1 * NSEC_PER_MSEC;
 
-static bool dl_server_stopped(struct sched_dl_entity *dl_se);
-
 static enum hrtimer_restart dl_server_timer(struct hrtimer *timer, struct sched_dl_entity *dl_se)
 {
 	struct rq *rq = rq_of_dl_se(dl_se);
@@ -1220,12 +1218,6 @@ static enum hrtimer_restart dl_server_timer(struct hrtimer *timer, struct sched_
 		if (!dl_se->dl_runtime)
 			return HRTIMER_NORESTART;
 
-		if (!dl_se->server_has_tasks(dl_se)) {
-			replenish_dl_entity(dl_se);
-			dl_server_stopped(dl_se);
-			return HRTIMER_NORESTART;
-		}
-
 		if (dl_se->dl_defer_armed) {
 			/*
 			 * First check if the server could consume runtime in background.
@@ -1891,11 +1883,9 @@ static bool dl_server_stopped(struct sched_dl_entity *dl_se)
 }
 
 void dl_server_init(struct sched_dl_entity *dl_se, struct rq *rq,
-		    dl_server_has_tasks_f has_tasks,
 		    dl_server_pick_f pick_task)
 {
 	dl_se->rq = rq;
-	dl_se->server_has_tasks = has_tasks;
 	dl_se->server_pick_task = pick_task;
 }
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d26e078d0623f..f36512892adf9 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -9058,11 +9058,6 @@ static struct task_struct *__pick_next_task_fair(struct rq *rq, struct task_stru
 	return pick_next_task_fair(rq, prev, NULL);
 }
 
-static bool fair_server_has_tasks(struct sched_dl_entity *dl_se)
-{
-	return !!dl_se->rq->cfs.nr_running;
-}
-
 static struct task_struct *fair_server_pick_task(struct sched_dl_entity *dl_se)
 {
 	return pick_task_fair(dl_se->rq);
@@ -9074,7 +9069,7 @@ void fair_server_init(struct rq *rq)
 
 	init_dl_entity(dl_se);
 
-	dl_server_init(dl_se, rq, fair_server_has_tasks, fair_server_pick_task);
+	dl_server_init(dl_se, rq, fair_server_pick_task);
 }
 
 /*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index a09e2d25edd57..9391ff62cdaaa 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -371,9 +371,6 @@ extern s64 dl_scaled_delta_exec(struct rq *rq, struct sched_dl_entity *dl_se, s6
  *
  *   dl_se::rq -- runqueue we belong to.
  *
- *   dl_se::server_has_tasks() -- used on bandwidth enforcement; we 'stop' the
- *                                server when it runs out of tasks to run.
- *
  *   dl_se::server_pick() -- nested pick_next_task(); we yield the period if this
  *                           returns NULL.
  *
@@ -389,7 +386,6 @@ extern void dl_server_update(struct sched_dl_entity *dl_se, s64 delta_exec);
 extern void dl_server_start(struct sched_dl_entity *dl_se);
 extern void dl_server_stop(struct sched_dl_entity *dl_se);
 extern void dl_server_init(struct sched_dl_entity *dl_se, struct rq *rq,
-		    dl_server_has_tasks_f has_tasks,
 		    dl_server_pick_f pick_task);
 
 extern void dl_server_update_idle_time(struct rq *rq,
-- 
2.53.0



