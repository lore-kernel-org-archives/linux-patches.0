Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDE213C9C4;
	Wed,  5 Feb 2025 13:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763591; cv=none; b=CidUGOihMPxxK6FWRJWolPCnAoZE7KOz1wox4qVRWlpgF5GeitHlEdRaYE0UaR/jMBaTj0gAO99CVtJh6WdDtwlHSQiJMO4UREwdF/aMptxpx0xxVPP5XUujAEzLQd/pSPzwHMIuUtlBTf/FGsiKgvgmXnV8EUN5+Mu6Wa5yqmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763591; c=relaxed/simple;
	bh=o/2EE1Rn0JwP48uaJfy1l+j6tbh4UZMD0WE0Q+/zYTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BvE4CYzK20C0MW99b27K/9bgoGKiZV+Ca4V08nl4bgveD8QTQHfhHzxGmACZLkDIsC83dvHACSGwbYavzsfp/JolMRKajqEKhyTyhBdDqCBdpzHxSD9XUFUfNL/ztHFnZj/+mfWthBr75jIjaELBForTzG9F/KnSZO5EGOhn4vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j89I+Ji/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j89I+Ji/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E542C4CED1;
	Wed,  5 Feb 2025 13:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763591;
	bh=o/2EE1Rn0JwP48uaJfy1l+j6tbh4UZMD0WE0Q+/zYTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j89I+Ji/sUjZAxBu0VvMYSJQzTJBLNvMa1Z9KZWVJ6EeM9+Bbe2BeU22eZP1yXj/4
	 i1dyh91HC6XUk08rHYtX501QkL7BmtfhFkFhvrQDzm1J+BNyYNNF0chNeNCqykxxto
	 hDNA9diSkIchyMP74OdcDf2boce0KzqIWcdnXlcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 034/590] sched: psi: pass enqueue/dequeue flags to psi callbacks directly
Date: Wed,  5 Feb 2025 14:36:29 +0100
Message-ID: <20250205134456.555943023@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Johannes Weiner <hannes@cmpxchg.org>

[ Upstream commit 1a6151017ee5a30cb2d959f110ab18fc49646467 ]

What psi needs to do on each enqueue and dequeue has gotten more
subtle, and the generic sched code trying to distill this into a bool
for the callbacks is awkward.

Pass the flags directly and let psi parse them. For that to work, the
#include "stats.h" (which has the psi callback implementations) needs
to be below the flag definitions in "sched.h". Move that section
further down, next to some of the other accounting stuff.

This also puts the ENQUEUE_SAVE/RESTORE branch behind the psi jump
label, slightly reducing overhead when PSI=y but runtime disabled.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20241014144358.GB1021@cmpxchg.org
Stable-dep-of: 7d9da040575b ("psi: Fix race when task wakes up before psi_sched_switch() adjusts flags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c  | 12 +++++-----
 kernel/sched/sched.h | 56 ++++++++++++++++++++++----------------------
 kernel/sched/stats.h | 29 +++++++++++++++--------
 3 files changed, 53 insertions(+), 44 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d794d9bb429fd..c1d2d46feec50 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2024,10 +2024,10 @@ void enqueue_task(struct rq *rq, struct task_struct *p, int flags)
 	 */
 	uclamp_rq_inc(rq, p);
 
-	if (!(flags & ENQUEUE_RESTORE)) {
+	psi_enqueue(p, flags);
+
+	if (!(flags & ENQUEUE_RESTORE))
 		sched_info_enqueue(rq, p);
-		psi_enqueue(p, flags & ENQUEUE_MIGRATED);
-	}
 
 	if (sched_core_enabled(rq))
 		sched_core_enqueue(rq, p);
@@ -2044,10 +2044,10 @@ inline bool dequeue_task(struct rq *rq, struct task_struct *p, int flags)
 	if (!(flags & DEQUEUE_NOCLOCK))
 		update_rq_clock(rq);
 
-	if (!(flags & DEQUEUE_SAVE)) {
+	if (!(flags & DEQUEUE_SAVE))
 		sched_info_dequeue(rq, p);
-		psi_dequeue(p, !(flags & DEQUEUE_SLEEP));
-	}
+
+	psi_dequeue(p, flags);
 
 	/*
 	 * Must be before ->dequeue_task() because ->dequeue_task() can 'fail'
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index f2ef520513c4a..5426969cf478a 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2095,34 +2095,6 @@ static inline const struct cpumask *task_user_cpus(struct task_struct *p)
 
 #endif /* CONFIG_SMP */
 
-#include "stats.h"
-
-#if defined(CONFIG_SCHED_CORE) && defined(CONFIG_SCHEDSTATS)
-
-extern void __sched_core_account_forceidle(struct rq *rq);
-
-static inline void sched_core_account_forceidle(struct rq *rq)
-{
-	if (schedstat_enabled())
-		__sched_core_account_forceidle(rq);
-}
-
-extern void __sched_core_tick(struct rq *rq);
-
-static inline void sched_core_tick(struct rq *rq)
-{
-	if (sched_core_enabled(rq) && schedstat_enabled())
-		__sched_core_tick(rq);
-}
-
-#else /* !(CONFIG_SCHED_CORE && CONFIG_SCHEDSTATS): */
-
-static inline void sched_core_account_forceidle(struct rq *rq) { }
-
-static inline void sched_core_tick(struct rq *rq) { }
-
-#endif /* !(CONFIG_SCHED_CORE && CONFIG_SCHEDSTATS) */
-
 #ifdef CONFIG_CGROUP_SCHED
 
 /*
@@ -3209,6 +3181,34 @@ extern void nohz_run_idle_balance(int cpu);
 static inline void nohz_run_idle_balance(int cpu) { }
 #endif
 
+#include "stats.h"
+
+#if defined(CONFIG_SCHED_CORE) && defined(CONFIG_SCHEDSTATS)
+
+extern void __sched_core_account_forceidle(struct rq *rq);
+
+static inline void sched_core_account_forceidle(struct rq *rq)
+{
+	if (schedstat_enabled())
+		__sched_core_account_forceidle(rq);
+}
+
+extern void __sched_core_tick(struct rq *rq);
+
+static inline void sched_core_tick(struct rq *rq)
+{
+	if (sched_core_enabled(rq) && schedstat_enabled())
+		__sched_core_tick(rq);
+}
+
+#else /* !(CONFIG_SCHED_CORE && CONFIG_SCHEDSTATS): */
+
+static inline void sched_core_account_forceidle(struct rq *rq) { }
+
+static inline void sched_core_tick(struct rq *rq) { }
+
+#endif /* !(CONFIG_SCHED_CORE && CONFIG_SCHEDSTATS) */
+
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 
 struct irqtime {
diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
index 767e098a3bd13..8ee0add5a48a8 100644
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -127,21 +127,25 @@ static inline void psi_account_irqtime(struct rq *rq, struct task_struct *curr,
  * go through migration requeues. In this case, *sleeping* states need
  * to be transferred.
  */
-static inline void psi_enqueue(struct task_struct *p, bool migrate)
+static inline void psi_enqueue(struct task_struct *p, int flags)
 {
 	int clear = 0, set = 0;
 
 	if (static_branch_likely(&psi_disabled))
 		return;
 
+	/* Same runqueue, nothing changed for psi */
+	if (flags & ENQUEUE_RESTORE)
+		return;
+
 	if (p->se.sched_delayed) {
 		/* CPU migration of "sleeping" task */
-		SCHED_WARN_ON(!migrate);
+		SCHED_WARN_ON(!(flags & ENQUEUE_MIGRATED));
 		if (p->in_memstall)
 			set |= TSK_MEMSTALL;
 		if (p->in_iowait)
 			set |= TSK_IOWAIT;
-	} else if (migrate) {
+	} else if (flags & ENQUEUE_MIGRATED) {
 		/* CPU migration of runnable task */
 		set = TSK_RUNNING;
 		if (p->in_memstall)
@@ -158,17 +162,14 @@ static inline void psi_enqueue(struct task_struct *p, bool migrate)
 	psi_task_change(p, clear, set);
 }
 
-static inline void psi_dequeue(struct task_struct *p, bool migrate)
+static inline void psi_dequeue(struct task_struct *p, int flags)
 {
 	if (static_branch_likely(&psi_disabled))
 		return;
 
-	/*
-	 * When migrating a task to another CPU, clear all psi
-	 * state. The enqueue callback above will work it out.
-	 */
-	if (migrate)
-		psi_task_change(p, p->psi_flags, 0);
+	/* Same runqueue, nothing changed for psi */
+	if (flags & DEQUEUE_SAVE)
+		return;
 
 	/*
 	 * A voluntary sleep is a dequeue followed by a task switch. To
@@ -176,6 +177,14 @@ static inline void psi_dequeue(struct task_struct *p, bool migrate)
 	 * TSK_RUNNING and TSK_IOWAIT for us when it moves TSK_ONCPU.
 	 * Do nothing here.
 	 */
+	if (flags & DEQUEUE_SLEEP)
+		return;
+
+	/*
+	 * When migrating a task to another CPU, clear all psi
+	 * state. The enqueue callback above will work it out.
+	 */
+	psi_task_change(p, p->psi_flags, 0);
 }
 
 static inline void psi_ttwu_dequeue(struct task_struct *p)
-- 
2.39.5



