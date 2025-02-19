Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95AC1F583C;
	Wed, 19 Feb 2025 08:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954779; cv=none; b=nOkGfUb35EvYunpXZbjXIYJ+iiQUavlpyDsETtsbDjbYwYWQxma8p1M4JKSm8vmKuUrqn61l1okYQMbrftuz6U+BRTyxvyp08JGSXLDHwBsPElA7HDyslQKF3s9iTU4agaU3tiVA+l1LGaameb2NBQwU6KKyaJD+8Vh6S7e5mhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954779; c=relaxed/simple;
	bh=xEvpxIdaaEm4KcFNw0unh37XKRFGTq6d/C7BzUavG8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rDbsxzdZ/PgAwV7ffFKnplg9ivx081kEt5AzRI69Jauu8wis0/J8J0NiZuxwn2YInqnklIGnrOC54xH9U2cc1kmx71rSaH3DrfCE/9pVjkY9kupDVwDNWoj3DUacce7ZAw5WB84qvzmyD/SHNEpVxwwePguslx0ipMHUON6/I+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sMhKJ4r7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sMhKJ4r7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58204C4CEE6;
	Wed, 19 Feb 2025 08:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954779;
	bh=xEvpxIdaaEm4KcFNw0unh37XKRFGTq6d/C7BzUavG8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sMhKJ4r7EdMwUECvwBOZlLIXPHVBvmi4sg4V9skeyIb26xcon0U1wlnTNP+hYHci3
	 +8pbFUoh5RQ042KrNttBrLccLIihD/0fuzjBQLznJPqYyyPULvqfdiuWkY7FdUNMLq
	 slQCJ8+HlfOekhfYcI7fpnE6OdjqEgzJakeJ2ItA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 034/230] sched_ext: Fix lock imbalance in dispatch_to_local_dsq()
Date: Wed, 19 Feb 2025 09:25:51 +0100
Message-ID: <20250219082603.045274488@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

From: Andrea Righi <arighi@nvidia.com>

[ Upstream commit 1626e5ef0b00386a4fd083fa7c46c8edbd75f9b4 ]

While performing the rq locking dance in dispatch_to_local_dsq(), we may
trigger the following lock imbalance condition, in particular when
multiple tasks are rapidly changing CPU affinity (i.e., running a
`stress-ng --race-sched 0`):

[   13.413579] =====================================
[   13.413660] WARNING: bad unlock balance detected!
[   13.413729] 6.13.0-virtme #15 Not tainted
[   13.413792] -------------------------------------
[   13.413859] kworker/1:1/80 is trying to release lock (&rq->__lock) at:
[   13.413954] [<ffffffff873c6c48>] dispatch_to_local_dsq+0x108/0x1a0
[   13.414111] but there are no more locks to release!
[   13.414176]
[   13.414176] other info that might help us debug this:
[   13.414258] 1 lock held by kworker/1:1/80:
[   13.414318]  #0: ffff8b66feb41698 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x20/0x90
[   13.414612]
[   13.414612] stack backtrace:
[   13.415255] CPU: 1 UID: 0 PID: 80 Comm: kworker/1:1 Not tainted 6.13.0-virtme #15
[   13.415505] Workqueue:  0x0 (events)
[   13.415567] Sched_ext: dsp_local_on (enabled+all), task: runnable_at=-2ms
[   13.415570] Call Trace:
[   13.415700]  <TASK>
[   13.415744]  dump_stack_lvl+0x78/0xe0
[   13.415806]  ? dispatch_to_local_dsq+0x108/0x1a0
[   13.415884]  print_unlock_imbalance_bug+0x11b/0x130
[   13.415965]  ? dispatch_to_local_dsq+0x108/0x1a0
[   13.416226]  lock_release+0x231/0x2c0
[   13.416326]  _raw_spin_unlock+0x1b/0x40
[   13.416422]  dispatch_to_local_dsq+0x108/0x1a0
[   13.416554]  flush_dispatch_buf+0x199/0x1d0
[   13.416652]  balance_one+0x194/0x370
[   13.416751]  balance_scx+0x61/0x1e0
[   13.416848]  prev_balance+0x43/0xb0
[   13.416947]  __pick_next_task+0x6b/0x1b0
[   13.417052]  __schedule+0x20d/0x1740

This happens because dispatch_to_local_dsq() is racing with
dispatch_dequeue() and, when the latter wins, we incorrectly assume that
the task has been moved to dst_rq.

Fix by properly tracking the currently locked rq.

Fixes: 4d3ca89bdd31 ("sched_ext: Refactor consume_remote_task()")
Signed-off-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index 4c4681cb9337b..45e7461fd4c94 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -2458,6 +2458,9 @@ static void dispatch_to_local_dsq(struct rq *rq, struct scx_dispatch_q *dst_dsq,
 {
 	struct rq *src_rq = task_rq(p);
 	struct rq *dst_rq = container_of(dst_dsq, struct rq, scx.local_dsq);
+#ifdef CONFIG_SMP
+	struct rq *locked_rq = rq;
+#endif
 
 	/*
 	 * We're synchronized against dequeue through DISPATCHING. As @p can't
@@ -2494,8 +2497,9 @@ static void dispatch_to_local_dsq(struct rq *rq, struct scx_dispatch_q *dst_dsq,
 	atomic_long_set_release(&p->scx.ops_state, SCX_OPSS_NONE);
 
 	/* switch to @src_rq lock */
-	if (rq != src_rq) {
-		raw_spin_rq_unlock(rq);
+	if (locked_rq != src_rq) {
+		raw_spin_rq_unlock(locked_rq);
+		locked_rq = src_rq;
 		raw_spin_rq_lock(src_rq);
 	}
 
@@ -2513,6 +2517,8 @@ static void dispatch_to_local_dsq(struct rq *rq, struct scx_dispatch_q *dst_dsq,
 		} else {
 			move_remote_task_to_local_dsq(p, enq_flags,
 						      src_rq, dst_rq);
+			/* task has been moved to dst_rq, which is now locked */
+			locked_rq = dst_rq;
 		}
 
 		/* if the destination CPU is idle, wake it up */
@@ -2521,8 +2527,8 @@ static void dispatch_to_local_dsq(struct rq *rq, struct scx_dispatch_q *dst_dsq,
 	}
 
 	/* switch back to @rq lock */
-	if (rq != dst_rq) {
-		raw_spin_rq_unlock(dst_rq);
+	if (locked_rq != rq) {
+		raw_spin_rq_unlock(locked_rq);
 		raw_spin_rq_lock(rq);
 	}
 #else	/* CONFIG_SMP */
-- 
2.39.5



