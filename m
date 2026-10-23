Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774585;
	b=VPCW9i884tXZfVo5rxh0ZEh65TFfKUUwVfAKg617ugnhU1pDnGhsseUMtEwlG/t3C/l0
	 3e3C+7Ticp6ltEwthF8/hDjkmKVIStJdx5L3OrggAj0yy/uNVgQm8+dGtZJHAvi6ncVow
	 VP/lb+XGesgHqqndLQvlZmVb0iNQG/uq9T0/k7Kyday43JU989NYhnd9f/pkInVTy5/zG
	 B6RjjKVBwiyjsMCBT/bHLOCdmLp7dmc3QzmrdE4RLbZaPhrEkoBU1Hg8i+pKGlz7Jde0A
	 v50dsO/AEescd8VwezpoEPwj1zTnGlUAj9l8iv2FxpBzJOcRgjAKdlSjUovSCl2IKAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774585;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CzjOi2yNlPs/qbje9QjwkIKiyg8deXx0g7nvrxxi08I=;
	b=oW3WCPzIBoy0iT6eGiv4tP1gqPrUQpdjU40bgrOZVAG6nvnMbdUvrf8PgSs6+oJcxa3H
	 XpkcPC62f8du3WWcipkYhI7wYSuosiDqvNYtQMVS9XMVM1m4rxgHEBi0elhAeYrt0LHEd
	 EcDbqWT4ouhPF9qa2MNlqAISwNIY3o1wfdII5hqVsrh52cwUjjMPM9rn61eAzzF9+2VwY
	 KOPSrHUOU3Vr5/1aVAGkr2JtP6YV9Mpj/aefCrEMeSS/iP++zUXh03xeMagKlojf27P1t
	 LWhjtnU3XDwxkkhofit9zVy/Ntl2XGP/yURwkujjsgXR73aXIttFsPxO/qMaBxkn16Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qdMyD49L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F87606A31A;
	Fri, 23 Oct 2026 16:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qdMyD49L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A42A1F01825;
	Fri, 23 Oct 2026 16:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774584;
	bh=CzjOi2yNlPs/qbje9QjwkIKiyg8deXx0g7nvrxxi08I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qdMyD49LM8PdVI7I68vPJalLfE21tkD1kf021AQ55kwjbcbG5s7voEheB5yv4i6b9
	 Vu3Ly04k4Sgjg2lzgwjymp6EZ+SLsSRx8QCYH0pK0KptJqgM/HHyKu9RL1c8xIbQFz
	 PhF3Jd1FSx1gPGU1TiFztGUThDcDpU1mkOKCBg5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Phil Auld <pauld@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 052/242] sched/core: Call wakeup_preempt() for queued tasks during class change
Date: Fri, 23 Oct 2026 18:38:14 +0200
Message-ID: <20261023163715.008638905@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: K Prateek Nayak <kprateek.nayak@amd.com>

[ Upstream commit 118a2cf4ced60777a2408001e2b4838fed1cea55 ]

Paul reported recent RCU changes exposed a lost resched where CPU idles
with a rcutorture thread waiting while being completely runnable.

Dumping the rq state at the time of idling with runnable tasks showed
the following:

  rq->next_class = &fair_sched_class
  rq->nr_running = 1
  rq->cfs.h_nr_queued = 0
  rq->rt.rt_nr_running = 1

Although the waiting task was an RT task, "rq->next_class" did not point
to rt_sched_class and was stuck at the lower priority fair_sched_class.

Inspecting sched_change_end() revealed the following race with
__sched_setscheduler() for queued, but non-running tasks:

    CPU0                                   CPU1
    ====                                   ====

  __schedule()

    /*
     * rq->donor is a fair task that blocks.
     * rq->next_class = &fair_sched_class
     */

    rq_lock(rq0)

    pick_next_task()
      /* nr_running = 0 */
      pick_task_fair()
        sched_balance_newidle()
          raw_spin_rq_unlock(rq0)
                                    rq_lock(rq0)

                                    activate_task(rq0, p)
                                      /* p is a fair task */
                                      rq0->nr_running++;
                                      rq0->cfs.h_nr_queued++;
                                      wakeup_preempt(rq, p)
                                        rq->next_class = &fair_sched_class
                                        resched_curr()

                                    rq_unlock(rq0)

                                    __sched_setscheduler(p)
                                      /* p is moved to SCHED_RR */
                                      task_rq_lock(p)
                                      sched_change_begin()

				      rq0->cfs.h_nr_queued--;
				      rq0->rt.rt_nr_running++;

                                      sched_change_end()
                                        /*
                                         * p->on_rq = 1 (ctx->queued)
                                         * but p is not rq->donor
                                         * (!ctx->running) hence
                                         * resched_curr() is and
                                         * rq->next_class upgrade is
                                         * skipped.
                                         */

                                       task_rq_unlock()

          raw_spin_rq_lock(rq0)

          /*
           * rq->nr_running = 1
           * rq->cfs.h_nr_queued = 0
           * rq->rt.rt_nr_running = 1
           * rq->next_class = &fair_sched_class
           */

           if (rq->cfs.h_nr_queued && ...)
             /* Above is false */

           if (rq_modified_above(this_rq, &fair_sched_class))
             /* Also false since rq->next_class is still fair */

      /*
       * sched_balance_newidle() is considered to
       * have failed to pull any fair tasks and no
       * other wakeups were detected.
       */
       return NULL; /* pick_task_fair() */

    pick_task_idle()
      return rq->idle;

    next = rq->idle;

    /* Preemption indicators are lost */
    clear_tsk_need_resched(prev);
    clear_preempt_need_resched();

    rq->curr = rq->idle;

  !!! rq->idle switches in with rq->running == 1 but !need_resched() !!!

In simple words, enqueue, followed by a class change of the newly queued
task goes unnoticed in rq->next_class indicator and
sched_balance_newidle() sees no fair task, nor any higher priority task
enqueued.

The above sequence will lead to CPU idling with a runnable task on the
CPU.

Call wakeup_preempt() for ctx->queued cases in sched_change_end() to
re-evaluate rq->next_class after class change (ENQUEUE_CLASS) and set
the NEED_RESCHED indicator accordingly.

Newidle balance will correctly see an enqueue of a higher priority
task if a queued task was upgraded when the rq_lock() was dropped and
will retry the pick.

Closes: https://lore.kernel.org/lkml/8fa7f795-518c-4507-b684-60b0c1cac2c5@paulmck-laptop/
Fixes: 704069649b5b ("sched/core: Rework sched_class::wakeup_preempt() and rq_modified_*()")
Reported-by: Paul E. McKenney <paulmck@kernel.org>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Phil Auld <pauld@redhat.com>
Link: https://patch.msgid.link/20261013152455.9039-1-kprateek.nayak@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c104562638e33..383ced4156e20 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -11323,17 +11323,16 @@ void sched_change_end(struct sched_change_ctx *ctx)
 		if (p->sched_class->switched_to)
 			p->sched_class->switched_to(rq, p);
 
+		/*
+		 * Check if the task can preempt the current in case the class
+		 * was upgraded. Note that none of the switch*_from() methods
+		 * know the new class and none of the switch*_to() methods know
+		 * the old class so we must resched here.
+		 */
+		if (ctx->queued)
+			wakeup_preempt(rq, p, 0);
+
 		if (ctx->running) {
-			/*
-			 * If this was a class promotion; let the old class
-			 * know it got preempted. Note that none of the
-			 * switch*_from() methods know the new class and none
-			 * of the switch*_to() methods know the old class.
-			 */
-			if (sched_class_above(p->sched_class, ctx->class)) {
-				rq->next_class->wakeup_preempt(rq, p, 0);
-				rq->next_class = p->sched_class;
-			}
 			/*
 			 * If this was a degradation in class; make sure to
 			 * reschedule.
-- 
2.53.0



