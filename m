Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DC44369A;
	Wed, 25 Feb 2026 01:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982950; cv=none; b=FpzlpXvHIPF6HZO/XLxcwYIq03fndiLYJ6wHkps+BCBGb/05FwZvmNUPhRKmzlwdba9/0gf1nRrJRPMrk5/Y28hBOoNalQp0cu4uxL/HVtAEjJOJcIV1GHcHZjGRRFmvRUNr3/QvljWTWKpB/t0YoGg+2jWu5yjyiUwoNa4MQIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982950; c=relaxed/simple;
	bh=SO860REjyj45wxn2TOCw9+fh8rakmekf+JSmd5OES00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+Gu6oFQkMxzxxY8nPePJaFqhdkkU+4k4ijSJSMaod+B1i8v+tUASWVa29Dqq19wfvkNLNYOj71oO55/+6GrVcG8SbJrkDpxagB1dwd0+RABY3HpP6y3xT14Y1aKZ9gxko23vA+KGBlRw8H5Bb6ziueh4j898Do5GLxxc1A4DP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ufC9mZ4D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ufC9mZ4D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B80C116D0;
	Wed, 25 Feb 2026 01:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982950;
	bh=SO860REjyj45wxn2TOCw9+fh8rakmekf+JSmd5OES00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ufC9mZ4DcL4ZukE+3hEjiySSG+LDzgZZc9GbieCqwTGfkXJ0mjq7iFiDZuSoSfHvL
	 ceURGeFXH2HumTXdjwLqt0uThy1UWkSyZwSc3KxFGawJc3+tJsiakZwvBoJZ/a77sq
	 NmlBNenadTAmabmyQkcr158rbdF9M+B7FtC5GpeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zicheng Qu <quzicheng@huawei.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 129/781] sched: Re-evaluate scheduling when migrating queued tasks out of throttled cgroups
Date: Tue, 24 Feb 2026 17:13:58 -0800
Message-ID: <20260225012402.836131185@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zicheng Qu <quzicheng@huawei.com>

[ Upstream commit e34881c84c255bc300f24d9fe685324be20da3d1 ]

Consider the following sequence on a CPU configured with nohz_full:

1) A task P runs in cgroup A, and cgroup A becomes throttled due to CFS
   bandwidth control. The gse (cgroup A) where the task P attached is
dequeued and the CPU switches to idle.

2) Before cgroup A is unthrottled, task P is migrated from cgroup A to
   another cgroup B (not throttled).

   During sched_move_task(), the task P is observed as queued but not
running, and therefore no resched_curr() is triggered.

3) Since the CPU is nohz_full, it remains in do_idle() waiting for an
   explicit scheduling event, i.e., resched_curr().

4) For kernel <= 5.10: Later, cgroup A is unthrottled. However, the task
   P has already been migrated out of cgroup A, so unthrottle_cfs_rq()
may observe load_weight == 0 and return early without resched_curr()
called. For kernel >= 6.6: The unthrottling path normally triggers
`resched_curr()` almost cases even when no runnable tasks remain in the
unthrottled cgroup, preventing the idle stall described above. However,
if cgroup A is removed before it gets unthrottled, the unthrottling path
for cgroup A is never executed. In a result, no `resched_curr()` can be
called.

5) At this point, the task P is runnable in cgroup B (not throttled), but
the CPU remains in do_idle() with no pending reschedule point. The
system stays in this state until an unrelated event (e.g. a new task
wakeup or any cases) that can trigger a resched_curr() breaks the
nohz_full idle state, and then the task P finally gets scheduled.

The root cause is that sched_move_task() may classify the task as only
queued, not running, and therefore fails to trigger a resched_curr(),
while the later unthrottling path no longer has visibility of the
migrated task.

Preserve the existing behavior for running tasks by issuing
resched_curr(), and explicitly invoke check_preempt_curr() for tasks
that were queued at the time of migration. This ensures that runnable
tasks are reconsidered for scheduling even when nohz_full suppresses
periodic ticks.

Fixes: 29f59db3a74b ("sched: group-scheduler core")
Signed-off-by: Zicheng Qu <quzicheng@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: K Prateek Nayak <kprateek.nayak@amd.com>
Reviewed-by: Aaron Lu <ziqianlu@bytedance.com>
Tested-by: Aaron Lu <ziqianlu@bytedance.com>
Link: https://patch.msgid.link/20260130083438.1122457-1-quzicheng@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c3b6e123fa00e..dbf4e32a063f7 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -9115,6 +9115,7 @@ void sched_move_task(struct task_struct *tsk, bool for_autogroup)
 {
 	unsigned int queue_flags = DEQUEUE_SAVE | DEQUEUE_MOVE;
 	bool resched = false;
+	bool queued = false;
 	struct rq *rq;
 
 	CLASS(task_rq_lock, rq_guard)(tsk);
@@ -9126,10 +9127,13 @@ void sched_move_task(struct task_struct *tsk, bool for_autogroup)
 			scx_cgroup_move_task(tsk);
 		if (scope->running)
 			resched = true;
+		queued = scope->queued;
 	}
 
 	if (resched)
 		resched_curr(rq);
+	else if (queued)
+		wakeup_preempt(rq, tsk, 0);
 
 	__balance_callbacks(rq, &rq_guard.rf);
 }
-- 
2.51.0



