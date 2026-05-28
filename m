Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A9F25F7B9;
	Thu, 28 May 2026 20:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000364; cv=none; b=DG74ciJ1t+qAvwd+LovY5d+4ipVi/AQv4ivGwbYUopJ1q73No3u8JPZeWGaHr+6IHVS9LDPhGAWv4su235m5hQibXYVFMbddVd89lNy/lo6Y3J4GHFppFSPt/WoQYvtXrKBmoZDT4K7s9LOTFOcJXuDcoxZOKgJLnXA4bQB8B0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000364; c=relaxed/simple;
	bh=M+ufhVo6aSsOxP8AI4LV88Ac0eiDl/Ug1FNuEaxK+d4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKH3V/ioSdcHq13o4YGlumznGtUiZkZw5FnRj3N2tzu55QPdD0MHTLThoew4/1GpiLcTaub8PeNx9zEs5zqfmXEYlwARuAFBb9OhSGpCC1zABJx6YmKP/1+K+oef2gYcA7aJgux9grhPy7c2nuCWRHoLFr9w5Prp8PBv7dYtDmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=loR3yyMr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="loR3yyMr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37731F000E9;
	Thu, 28 May 2026 20:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000363;
	bh=lYzNuu6WepgvM2LrtbD1hTcjAUtwatiUHPf8M3hr8G4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=loR3yyMrE0jEff35M5dj4J57puwvmCYVLKgtL6mZ/6zCxyEbZWWCQikJN14homqXg
	 e7SAyHFjUjutnsUTy4eUF5o9TL/ioI0G/uCYwv1RQqiiUddhIBagz7VccNgOrMQJdh
	 H5Hg+wdPkno54axlEqUpqXHA3dLC0GeIMuxQbpow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Stultz <jstultz@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Lukas Beckmann <lbckmnn@mailbox.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 019/272] sched/deadline: Fix dl_server behaviour
Date: Thu, 28 May 2026 21:46:33 +0200
Message-ID: <20260528194629.918741234@linuxfoundation.org>
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

commit a3a70caf7906708bf9bbc80018752a6b36543808 upstream.

John reported undesirable behaviour with the dl_server since commit:
cccb45d7c4295 ("sched/deadline: Less agressive dl_server handling").

When starving fair tasks on purpose (starting spinning FIFO tasks),
his fair workload, which often goes (briefly) idle, would delay fair
invocations for a second, running one invocation per second was both
unexpected and terribly slow.

The reason this happens is that when dl_se->server_pick_task() returns
NULL, indicating no runnable tasks, it would yield, pushing any later
jobs out a whole period (1 second).

Instead simply stop the server. This should restore behaviour in that
a later wakeup (which restarts the server) will be able to continue
running (subject to the CBS wakeup rules).

Notably, this does not re-introduce the behaviour cccb45d7c4295 set
out to solve, any start/stop cycle is naturally throttled by the timer
period (no active cancel).

Fixes: cccb45d7c4295 ("sched/deadline: Less agressive dl_server handling")
Reported-by: John Stultz <jstultz@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: John Stultz <jstultz@google.com>
Closes: https://lore.kernel.org/regressions/04657838-46d1-432d-95e1-eb73b930b032@mailbox.org
Signed-off-by: Lukas Beckmann <lbckmnn@mailbox.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched.h   |  1 -
 kernel/sched/deadline.c | 23 ++---------------------
 kernel/sched/sched.h    | 33 +++++++++++++++++++++++++++++++--
 3 files changed, 33 insertions(+), 24 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 464d281aa2e49..f9ffe42cae171 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -674,7 +674,6 @@ struct sched_dl_entity {
 	unsigned int			dl_defer	  : 1;
 	unsigned int			dl_defer_armed	  : 1;
 	unsigned int			dl_defer_running  : 1;
-	unsigned int			dl_server_idle    : 1;
 
 	/*
 	 * Bandwidth enforcement timer. Each -deadline task has its
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 609783d7de290..a6c699e43111d 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1621,10 +1621,8 @@ void dl_server_update_idle_time(struct rq *rq, struct task_struct *p)
 void dl_server_update(struct sched_dl_entity *dl_se, s64 delta_exec)
 {
 	/* 0 runtime = fair server disabled */
-	if (dl_se->dl_runtime) {
-		dl_se->dl_server_idle = 0;
+	if (dl_se->dl_runtime)
 		update_curr_dl_se(dl_se->rq, dl_se, delta_exec);
-	}
 }
 
 /*
@@ -1868,20 +1866,6 @@ void dl_server_stop(struct sched_dl_entity *dl_se)
 	dl_se->dl_server_active = 0;
 }
 
-static bool dl_server_stopped(struct sched_dl_entity *dl_se)
-{
-	if (!dl_se->dl_server_active)
-		return true;
-
-	if (dl_se->dl_server_idle) {
-		dl_server_stop(dl_se);
-		return true;
-	}
-
-	dl_se->dl_server_idle = 1;
-	return false;
-}
-
 void dl_server_init(struct sched_dl_entity *dl_se, struct rq *rq,
 		    dl_server_pick_f pick_task)
 {
@@ -2637,10 +2621,7 @@ static struct task_struct *__pick_task_dl(struct rq *rq)
 	if (dl_server(dl_se)) {
 		p = dl_se->server_pick_task(dl_se);
 		if (!p) {
-			if (!dl_server_stopped(dl_se)) {
-				dl_se->dl_yielded = 1;
-				update_curr_dl_se(rq, dl_se, 0);
-			}
+			dl_server_stop(dl_se);
 			goto again;
 		}
 		rq->dl_server = dl_se;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 9391ff62cdaaa..7956abeb9154e 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -377,10 +377,39 @@ extern s64 dl_scaled_delta_exec(struct rq *rq, struct sched_dl_entity *dl_se, s6
  *   dl_server_update() -- called from update_curr_common(), propagates runtime
  *                         to the server.
  *
- *   dl_server_start()
- *   dl_server_stop()  -- start/stop the server when it has (no) tasks.
+ *   dl_server_start() -- start the server when it has tasks; it will stop
+ *			  automatically when there are no more tasks, per
+ *			  dl_se::server_pick() returning NULL.
+ *
+ *   dl_server_stop() -- (force) stop the server; use when updating
+ *                       parameters.
  *
  *   dl_server_init() -- initializes the server.
+ *
+ * When started the dl_server will (per dl_defer) schedule a timer for its
+ * zero-laxity point -- that is, unlike regular EDF tasks which run ASAP, a
+ * server will run at the very end of its period.
+ *
+ * This is done such that any runtime from the target class can be accounted
+ * against the server -- through dl_server_update() above -- such that when it
+ * becomes time to run, it might already be out of runtime and get deferred
+ * until the next period. In this case dl_server_timer() will alternate
+ * between defer and replenish but never actually enqueue the server.
+ *
+ * Only when the target class does not manage to exhaust the server's runtime
+ * (there's actualy starvation in the given period), will the dl_server get on
+ * the runqueue. Once queued it will pick tasks from the target class and run
+ * them until either its runtime is exhaused, at which point its back to
+ * dl_server_timer, or until there are no more tasks to run, at which point
+ * the dl_server stops itself.
+ *
+ * By stopping at this point the dl_server retains bandwidth, which, if a new
+ * task wakes up imminently (starting the server again), can be used --
+ * subject to CBS wakeup rules -- without having to wait for the next period.
+ *
+ * Additionally, because of the dl_defer behaviour the start/stop behaviour is
+ * naturally thottled to once per period, avoiding high context switch
+ * workloads from spamming the hrtimer program/cancel paths.
  */
 extern void dl_server_update(struct sched_dl_entity *dl_se, s64 delta_exec);
 extern void dl_server_start(struct sched_dl_entity *dl_se);
-- 
2.53.0



