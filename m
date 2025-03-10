Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075D91C4A24;
	Mon, 10 Mar 2025 17:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628729; cv=none; b=T5B+jm1CvOftdA5faZJzPDmipHzlOy82zwXwz/ZH7CPl0SB6x+v3M63o32IgTASzWEoKGERHgUXwRF1q0W7rWfFt4NVtRxWKB9aPx933kztnY2EeyK/RwXNSAlADyWSwNffAvPIvpQWbJaGDTniYSPENg9tW+iEVnSbf0yOI6Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628729; c=relaxed/simple;
	bh=xFMygZirvcL2aS8XNTxvjqQiJ4U67FP7ji1hzAAsb4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SqSEWSZquNb6YGcg0Ec5CFX1dN2zW2zn1CvYlvPEpRn4x1+xBLlY+lLjqKM4DOFiI1WzUIOmXtD2pyJgtwcgK3mVnuNTvwfYcgPpoUxKK/pLxm4sBDPNeY/hykakl14Fz26gmuduGu0YSoD4rZFbp9dx+wykKYT6JdmDeiMQwrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TJXFbg6S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TJXFbg6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C512C4CEE5;
	Mon, 10 Mar 2025 17:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628728;
	bh=xFMygZirvcL2aS8XNTxvjqQiJ4U67FP7ji1hzAAsb4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TJXFbg6S5wAoRYUOLimJ+jPFr0QrVhcOhnfDB9OfwgECSVbfMuyiQi/P6W28TMR8H
	 q4qLnPWtldekfpYxWFP/9oksTZ2YuyFxjcTelCRIo8W9b1Lq2zz4bwBMiUKSdS4chq
	 NW5I9ykOvu9oXRw/YaeW7OWHIE2DtQ5i4zTk3GoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengming Zhou <zhouchengming@bytedance.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 017/620] sched/psi: Use task->psi_flags to clear in CPU migration
Date: Mon, 10 Mar 2025 17:57:43 +0100
Message-ID: <20250310170546.257580776@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengming Zhou <zhouchengming@bytedance.com>

[ Upstream commit 52b33d87b9197c51e8ffdc61873739d90dd0a16f ]

The commit d583d360a620 ("psi: Fix psi state corruption when schedule()
races with cgroup move") fixed a race problem by making cgroup_move_task()
use task->psi_flags instead of looking at the scheduler state.

We can extend task->psi_flags usage to CPU migration, which should be
a minor optimization for performance and code simplicity.

Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Link: https://lore.kernel.org/r/20220926081931.45420-1-zhouchengming@bytedance.com
Stable-dep-of: a430d99e3490 ("sched/fair: Fix value reported by hot tasks pulled in /proc/schedstat")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched.h |  3 ---
 kernel/sched/core.c   |  2 +-
 kernel/sched/stats.h  | 22 ++++------------------
 3 files changed, 5 insertions(+), 22 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9b3cfe685cb45..875f3d317b9c8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -874,9 +874,6 @@ struct task_struct {
 	unsigned			sched_reset_on_fork:1;
 	unsigned			sched_contributes_to_load:1;
 	unsigned			sched_migrated:1;
-#ifdef CONFIG_PSI
-	unsigned			sched_psi_wake_requeue:1;
-#endif
 
 	/* Force alignment to the next boundary: */
 	unsigned			:0;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ed92b75f7e024..fee8e2a7c7530 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1967,7 +1967,7 @@ static inline void enqueue_task(struct rq *rq, struct task_struct *p, int flags)
 
 	if (!(flags & ENQUEUE_RESTORE)) {
 		sched_info_enqueue(rq, p);
-		psi_enqueue(p, flags & ENQUEUE_WAKEUP);
+		psi_enqueue(p, (flags & ENQUEUE_WAKEUP) && !(flags & ENQUEUE_MIGRATED));
 	}
 
 	uclamp_rq_inc(rq, p);
diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
index 975703572bc0d..cee3100c74cd5 100644
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -91,11 +91,9 @@ static inline void psi_enqueue(struct task_struct *p, bool wakeup)
 	if (p->in_memstall)
 		set |= TSK_MEMSTALL_RUNNING;
 
-	if (!wakeup || p->sched_psi_wake_requeue) {
+	if (!wakeup) {
 		if (p->in_memstall)
 			set |= TSK_MEMSTALL;
-		if (p->sched_psi_wake_requeue)
-			p->sched_psi_wake_requeue = 0;
 	} else {
 		if (p->in_iowait)
 			clear |= TSK_IOWAIT;
@@ -106,8 +104,6 @@ static inline void psi_enqueue(struct task_struct *p, bool wakeup)
 
 static inline void psi_dequeue(struct task_struct *p, bool sleep)
 {
-	int clear = TSK_RUNNING;
-
 	if (static_branch_likely(&psi_disabled))
 		return;
 
@@ -120,10 +116,7 @@ static inline void psi_dequeue(struct task_struct *p, bool sleep)
 	if (sleep)
 		return;
 
-	if (p->in_memstall)
-		clear |= (TSK_MEMSTALL | TSK_MEMSTALL_RUNNING);
-
-	psi_task_change(p, clear, 0);
+	psi_task_change(p, p->psi_flags, 0);
 }
 
 static inline void psi_ttwu_dequeue(struct task_struct *p)
@@ -135,19 +128,12 @@ static inline void psi_ttwu_dequeue(struct task_struct *p)
 	 * deregister its sleep-persistent psi states from the old
 	 * queue, and let psi_enqueue() know it has to requeue.
 	 */
-	if (unlikely(p->in_iowait || p->in_memstall)) {
+	if (unlikely(p->psi_flags)) {
 		struct rq_flags rf;
 		struct rq *rq;
-		int clear = 0;
-
-		if (p->in_iowait)
-			clear |= TSK_IOWAIT;
-		if (p->in_memstall)
-			clear |= TSK_MEMSTALL;
 
 		rq = __task_rq_lock(p, &rf);
-		psi_task_change(p, clear, 0);
-		p->sched_psi_wake_requeue = 1;
+		psi_task_change(p, p->psi_flags, 0);
 		__task_rq_unlock(rq, &rf);
 	}
 }
-- 
2.39.5



