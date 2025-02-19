Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479101DE2B5;
	Wed, 19 Feb 2025 09:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956038; cv=none; b=ToVsaNDnPkoDGj50jYnG+9Og/chkO3wDdd29GEVYqNCiwGJ1REgfhvJKgokw2gEb+FHAZM/HNseCdD+VWGThDhkLYmNXeV0r6HEE5Ga2V/k+eh5ctqdz+BtbNNY2wZt/mi4sC7/b1ROJd8KmWSxG/l7ERnKTQFqK0AM2xjUHR18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956038; c=relaxed/simple;
	bh=dqbkujlWZRARCyDKy/OjyiTsjOQwSvwx0oGA3X2XLvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z1ROyn0f2eKBu1OZ4w7+TGbn7jVIbFZLgGVXmkOLulC/8rRgQ6rhZ+0Tkx5kk1SLBWDXTP1WQielkv/kQEqtMRltW97oYQGI582ehi6N7SmyCyul+Exq1gudE4EwXzq2jsuiRIGeO12sGVRQAYgKNx01Dd73yKgyvfBQcJx6xds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o7oXdTJR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o7oXdTJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C703CC4CED1;
	Wed, 19 Feb 2025 09:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956038;
	bh=dqbkujlWZRARCyDKy/OjyiTsjOQwSvwx0oGA3X2XLvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o7oXdTJRrqBI2rSbyUsYo3EkOFvVHwr4cov/YBdgJxbasOgQJrvvYdpd8bxDelWCd
	 wS3+UFQeEGNCwRty2PTU+Rjsfc3LQsaqOkFl+RPkWoa7mj3FFYOK9STnYJAsaiWM3H
	 6ITC+aOqsARikK47d9YQZ3DNSwPsYGPX+AqFdyxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengming Zhou <zhouchengming@bytedance.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/578] sched/psi: Use task->psi_flags to clear in CPU migration
Date: Wed, 19 Feb 2025 09:20:17 +0100
Message-ID: <20250219082653.414945585@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e87a68b136da9..6c82d71fab113 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -888,9 +888,6 @@ struct task_struct {
 	unsigned			sched_reset_on_fork:1;
 	unsigned			sched_contributes_to_load:1;
 	unsigned			sched_migrated:1;
-#ifdef CONFIG_PSI
-	unsigned			sched_psi_wake_requeue:1;
-#endif
 
 	/* Force alignment to the next boundary: */
 	unsigned			:0;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 54af671e8d510..f54d2da2f9a67 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2049,7 +2049,7 @@ static inline void enqueue_task(struct rq *rq, struct task_struct *p, int flags)
 
 	if (!(flags & ENQUEUE_RESTORE)) {
 		sched_info_enqueue(rq, p);
-		psi_enqueue(p, flags & ENQUEUE_WAKEUP);
+		psi_enqueue(p, (flags & ENQUEUE_WAKEUP) && !(flags & ENQUEUE_MIGRATED));
 	}
 
 	uclamp_rq_inc(rq, p);
diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
index b49a96fad1d2f..b02dfc3229510 100644
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -132,11 +132,9 @@ static inline void psi_enqueue(struct task_struct *p, bool wakeup)
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
@@ -147,8 +145,6 @@ static inline void psi_enqueue(struct task_struct *p, bool wakeup)
 
 static inline void psi_dequeue(struct task_struct *p, bool sleep)
 {
-	int clear = TSK_RUNNING;
-
 	if (static_branch_likely(&psi_disabled))
 		return;
 
@@ -161,10 +157,7 @@ static inline void psi_dequeue(struct task_struct *p, bool sleep)
 	if (sleep)
 		return;
 
-	if (p->in_memstall)
-		clear |= (TSK_MEMSTALL | TSK_MEMSTALL_RUNNING);
-
-	psi_task_change(p, clear, 0);
+	psi_task_change(p, p->psi_flags, 0);
 }
 
 static inline void psi_ttwu_dequeue(struct task_struct *p)
@@ -176,19 +169,12 @@ static inline void psi_ttwu_dequeue(struct task_struct *p)
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



