Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623887;
	b=CCM+iVIy2Sv/t1MGNXDK2ZDVzxuOCghENX5ZB95PVPDSeyqzmjGutD0wBh50EHStWIKa
	 dZiHdjDPkxFF8cyg1rL79ejTE4qG1Cb5GCyL24Wo5zROBkr81SSDKShz0EA6bza3oRt0W
	 yNDfpRDaJalisX1780fFvuPSIOc8zYTuJq1XF9SeR80Hr6hiVQ8pM2mGs4sU/0Zclq3Zh
	 kYGqbOaA8rCc4tMkav8LL94ARiEZ/vxdPXzW0RpxDLGmpciU8lCcLPrchvCi8SFmii8xv
	 EH4+oUjsLb9qlX+FwWwFnBJQoosFY2pdJKyscPKF/3eiLqX8GZF3YLtqHO7ikJSUfPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623887;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IGyvuCTsRQq8iN82hbxG8k81ISAHQP3tpoR/9GVrtNw=;
	b=Bvvv9JhhRicsftGY7n5t6zLrOLRnRFgXQPdG1OkJzNuGS3+SaKCfrtH8yprPNGk0u7Qe
	 LlZQkG/Z2bwsUqBz5BSl0pnf6a/IIHldkK5EKM+zzon6P0XCOdCZyVH0XGw+I8rMQwMBW
	 dFlwUcf+/AMnorRYRb5cLhuLrVb9xd3lOL60cmpfa0egcb92T7dSuqL3Os4loh8kPtN5i
	 FENgZsTfjnH2Y8Q24NF+4RbVzxDGcaeFjiNfO6XXgYIkgS6GDjjhEv7pIpcjxHAj14vI/
	 WS9nexdtFnS91iGpYL5qvaMhn+MuQhlFA1imVEJi+Q2YlkAtIENdN8cJmFv31MmgSCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tbQidxOV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7008A606A31E;
	Wed, 25 Nov 2026 16:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tbQidxOV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5EDA1F000C4;
	Wed, 25 Nov 2026 16:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623887;
	bh=IGyvuCTsRQq8iN82hbxG8k81ISAHQP3tpoR/9GVrtNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tbQidxOVZrpX0KDbQkRvHNaF3HERouT9DwYEOB4u6Lei78TLoBrVySaysm5sxubkz
	 8LQLizeNTKIkQfF338OilXKpUbFlcELhyK2C3gO9FoAFe+mMGYNmeyY8a0SzX9GDM7
	 asKg9pgdh13SC6hxS6qLyS2sG1zcNqX26IW1gsIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriele Monaco <gmonaco@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Florent Carli <fcarli@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 017/816] sched/deadline: Fix dl_server stop condition
Date: Wed, 25 Nov 2026 15:26:05 +0100
Message-ID: <20261125143849.614711523@linuxfoundation.org>
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

commit f5a538c07df26f5c601e41f7b9c7ade3e1e75803 upstream.

Gabriel reported that the dl_server doesn't stop as expected.

The problem was found to be the fact that idle time and fair runtime are
treated equally. Both will count towards dl_server runtime and push the
activation forwards when it is in the zero-laxity wait state.

Notably:

  dl_server_update_idle()
    update_curr_dl_se()
      if (dl_defer && dl_throttled && dl_runtime_exceeded())
        hrtimer_try_to_cancel(); // stop timer
	replenish_dl_new_period()
	  deadline = now + dl_deadline; // fwd period
	  runtime = dl_runtime;
        start_dl_timer(); // restart timer

And while we do want idle time accounted towards the *current* activation of
the dl_server -- after all, a fair task could've ran if we had any -- we don't
necessarily want idle time to cause or push forward an activation.

Introduce dl_defer_idle to make this distinction. It will be set once idle time
pushed the activation forward, once set idle time will only be allowed to
consume any runtime but not push the activation. This will then cause
dl_server_timer() to fire, which will stop the dl_server.

Any non-idle time accounting during this phase will clear dl_defer_idle, so
only a full period of idle will cause the dl_server to stop.

Reported-by: Gabriele Monaco <gmonaco@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20251101000057.GA2184199@noisy.programming.kicks-ass.net
Signed-off-by: Florent Carli <fcarli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched.h   | 15 +++++++++------
 kernel/sched/deadline.c | 40 ++++++++++++++++++++++++++++++++++++++--
 2 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1c584a1f0b835..7f0fb62df348e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -650,20 +650,22 @@ struct sched_dl_entity {
 	 *
 	 * @dl_server tells if this is a server entity.
 	 *
-	 * @dl_defer tells if this is a deferred or regular server. For
-	 * now only defer server exists.
-	 *
-	 * @dl_defer_armed tells if the deferrable server is waiting
-	 * for the replenishment timer to activate it.
-	 *
 	 * @dl_server_active tells if the dlserver is active(started).
 	 * dlserver is started on first cfs enqueue on an idle runqueue
 	 * and is stopped when a dequeue results in 0 cfs tasks on the
 	 * runqueue. In other words, dlserver is active only when cpu's
 	 * runqueue has atleast one cfs task.
 	 *
+	 * @dl_defer tells if this is a deferred or regular server. For
+	 * now only defer server exists.
+	 *
+	 * @dl_defer_armed tells if the deferrable server is waiting
+	 * for the replenishment timer to activate it.
+	 *
 	 * @dl_defer_running tells if the deferrable server is actually
 	 * running, skipping the defer phase.
+	 *
+	 * @dl_defer_idle tracks idle state
 	 */
 	unsigned int			dl_throttled      : 1;
 	unsigned int			dl_yielded        : 1;
@@ -674,6 +676,7 @@ struct sched_dl_entity {
 	unsigned int			dl_defer	  : 1;
 	unsigned int			dl_defer_armed	  : 1;
 	unsigned int			dl_defer_running  : 1;
+	unsigned int			dl_defer_idle     : 1;
 
 	/*
 	 * Bandwidth enforcement timer. Each -deadline task has its
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 2e3bd43afd535..ea64ab4364f77 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1223,6 +1223,11 @@ static enum hrtimer_restart dl_server_timer(struct hrtimer *timer, struct sched_
 		 */
 		rq->curr->sched_class->update_curr(rq);
 
+		if (dl_se->dl_defer_idle) {
+			dl_server_stop(dl_se);
+			return HRTIMER_NORESTART;
+		}
+
 		if (dl_se->dl_defer_armed) {
 			/*
 			 * First check if the server could consume runtime in background.
@@ -1473,10 +1478,11 @@ s64 dl_scaled_delta_exec(struct rq *rq, struct sched_dl_entity *dl_se, s64 delta
 }
 
 static inline void
-update_stats_dequeue_dl(struct dl_rq *dl_rq, struct sched_dl_entity *dl_se,
-			int flags);
+update_stats_dequeue_dl(struct dl_rq *dl_rq, struct sched_dl_entity *dl_se, int flags);
+
 static void update_curr_dl_se(struct rq *rq, struct sched_dl_entity *dl_se, s64 delta_exec)
 {
+	bool idle = rq->curr == rq->idle;
 	s64 scaled_delta_exec;
 
 	if (unlikely(delta_exec <= 0)) {
@@ -1497,6 +1503,9 @@ static void update_curr_dl_se(struct rq *rq, struct sched_dl_entity *dl_se, s64
 
 	dl_se->runtime -= scaled_delta_exec;
 
+	if (dl_se->dl_defer_idle && !idle)
+		dl_se->dl_defer_idle = 0;
+
 	/*
 	 * The fair server can consume its runtime while throttled (not queued/
 	 * running as regular CFS).
@@ -1506,6 +1515,29 @@ static void update_curr_dl_se(struct rq *rq, struct sched_dl_entity *dl_se, s64
 	 * starting a new period, pushing the activation.
 	 */
 	if (dl_se->dl_defer && dl_se->dl_throttled && dl_runtime_exceeded(dl_se)) {
+		/*
+		 * Non-servers would never get time accounted while throttled.
+		 */
+		WARN_ON_ONCE(!dl_server(dl_se));
+
+		/*
+		 * While the server is marked idle, do not push out the
+		 * activation further, instead wait for the period timer
+		 * to lapse and stop the server.
+		 */
+		if (dl_se->dl_defer_idle && idle) {
+			/*
+			 * The timer is at the zero-laxity point, this means
+			 * dl_server_stop() / dl_server_start() can happen
+			 * while now < deadline. This means update_dl_entity()
+			 * will not replenish. Additionally start_dl_timer()
+			 * will be set for 'deadline - runtime'. Negative
+			 * runtime will not do.
+			 */
+			dl_se->runtime = 0;
+			return;
+		}
+
 		/*
 		 * If the server was previously activated - the starving condition
 		 * took place, it this point it went away because the fair scheduler
@@ -1518,6 +1550,9 @@ static void update_curr_dl_se(struct rq *rq, struct sched_dl_entity *dl_se, s64
 
 		replenish_dl_new_period(dl_se, dl_se->rq);
 
+		if (idle)
+			dl_se->dl_defer_idle = 1;
+
 		/*
 		 * Not being able to start the timer seems problematic. If it could not
 		 * be started for whatever reason, we need to "unthrottle" the DL server
@@ -1857,6 +1892,7 @@ void dl_server_stop(struct sched_dl_entity *dl_se)
 	hrtimer_try_to_cancel(&dl_se->dl_timer);
 	dl_se->dl_defer_armed = 0;
 	dl_se->dl_throttled = 0;
+	dl_se->dl_defer_idle = 0;
 	dl_se->dl_server_active = 0;
 }
 
-- 
2.53.0



