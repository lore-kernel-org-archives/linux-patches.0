Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9F7432E65;
	Thu, 30 Jul 2026 14:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421508; cv=none; b=dpSEuKm1fGv0g70ZWQhqzBPYdT7psBC81tJEdSqgzVcW9B3petqY5QgohJ6jQoKNoVfSonDFP7CrinklTd5eYz6aKkChtuZsqCwzaUxs8iPNj5nf+mGxjkRiBn53OKdt04zztb0HOeCCpszOhJ6WkfEp+JUdqUwkUQUktY4zafs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421508; c=relaxed/simple;
	bh=0z5DSwtS75vQsOYzjoIGuX2o/A5bqk0Ona7wdtMmBow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZnW7PsH4OfSZeUZcbwsUWdHMCp+FNm9gn3y08JHRYnVZnEQ9nWYnFTV1DtLzlSMVEoR18gqppS/QddmT3SWXzVra8Vrb0YnTynWaq/ymrwnR5SrI8DU0nGnEzoGg6vmC+7Le6RA3f31+Pev53J9YgE/8ttjjmoq+9mtRJ+b4sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UcOu216k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UcOu216k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BCC61F000E9;
	Thu, 30 Jul 2026 14:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421507;
	bh=fKV7QqStWvIEyBDHsAp9zw+O92AG4A6KMF0EGM7Hr9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UcOu216kucSISZyRwn/RMLmfsXgq6BhYYwgr6UrjvfoPH9qDc8WJ833OuO31declH
	 L5Ig8KHRKgKefAE0FNfeTis0NojMCtW6gs4DGxfiH4ByHLChtnveG+yXi3BNE7Z7bT
	 tRtO/AV3KHhUv8cWY5IqCvngX8BmOUJZLDpP40qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 082/744] sched_ext: Enable tick for finite slices on nohz_full
Date: Thu, 30 Jul 2026 16:05:55 +0200
Message-ID: <20260730141446.014254586@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Righi <arighi@nvidia.com>

[ Upstream commit 4ec10f38ff901dc10503d57cbdcf941248419ac1 ]

set_next_task_scx() updates the tick dependency before __schedule()
updates rq->curr. When switching from a non-EXT task, such as idle, to
an EXT task with a finite slice, sched_update_tick_dependency() checks
the outgoing task and can allow the tick to remain stopped.

The dependency can also be lost without a slice-type transition. After a
finite-slice task leaves the CPU idle, the enqueue path can clear the
dependency against the idle rq->curr. SCX_RQ_CAN_STOP_TICK still records
a finite slice, so another finite task skips the transition block and
can run without the ticks needed to expire its slice.

The reverse mismatch can also happen when the last finite-slice EXT task
is dequeued: sub_nr_running() updates the dependency before rq->curr
changes, so the outgoing task state can keep the dependency set after
the CPU goes idle.

Fix this by unconditionally enabling the scheduler tick whenever a
finite-slice EXT task is selected on a nohz_full CPU. Moreover, when the
last runnable EXT task leaves, ignore the outgoing EXT slice state so
the generic scheduler can correctly re-evaluate and clear the tick
dependency.

Fixes: 22a920209ab6 ("sched_ext: Implement tickless support")
Signed-off-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c | 47 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 35 insertions(+), 12 deletions(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index 5f1accb092e30b..432c4c68a2c010 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -2985,24 +2985,38 @@ static void set_next_task_scx(struct rq *rq, struct task_struct *p, bool first)
 
 	/*
 	 * @p is getting newly scheduled or got kicked after someone updated its
-	 * slice. Refresh whether tick can be stopped. See scx_can_stop_tick().
+	 * slice. Update SCX_RQ_CAN_STOP_TICK to reflect whether the tick can be
+	 * stopped. See scx_can_stop_tick().
+	 *
+	 * Moreover, refresh the load_avgs just when transitioning in and out of
+	 * nohz. In the future, we might want to add a mechanism to update
+	 * load_avgs periodically on tick-stopped CPUs.
 	 */
-	if ((p->scx.slice == SCX_SLICE_INF) !=
-	    (bool)(rq->scx.flags & SCX_RQ_CAN_STOP_TICK)) {
-		if (p->scx.slice == SCX_SLICE_INF)
+	if (p->scx.slice == SCX_SLICE_INF) {
+		if (!(rq->scx.flags & SCX_RQ_CAN_STOP_TICK)) {
+			/*
+			 * Bypass mode always assigns finite slices, so @p
+			 * can't have an infinite slice while bypassing.
+			 * Therefore, sched_update_tick_dependency() can safely
+			 * evaluate the outgoing task.
+			 */
 			rq->scx.flags |= SCX_RQ_CAN_STOP_TICK;
-		else
-			rq->scx.flags &= ~SCX_RQ_CAN_STOP_TICK;
+			sched_update_tick_dependency(rq);
 
-		sched_update_tick_dependency(rq);
+			update_other_load_avgs(rq);
+		}
+	} else {
+		if (rq->scx.flags & SCX_RQ_CAN_STOP_TICK) {
+			rq->scx.flags &= ~SCX_RQ_CAN_STOP_TICK;
+			update_other_load_avgs(rq);
+		}
 
 		/*
-		 * For now, let's refresh the load_avgs just when transitioning
-		 * in and out of nohz. In the future, we might want to add a
-		 * mechanism which calls the following periodically on
-		 * tick-stopped CPUs.
+		 * @rq still references the outgoing scheduling context. A finite
+		 * slice is sufficient by itself to require the tick.
 		 */
-		update_other_load_avgs(rq);
+		if (tick_nohz_full_cpu(cpu_of(rq)))
+			tick_nohz_dep_set_cpu(cpu_of(rq), TICK_DEP_BIT_SCHED);
 	}
 }
 
@@ -4296,6 +4310,15 @@ bool scx_can_stop_tick(struct rq *rq)
 	if (p->sched_class != &ext_sched_class)
 		return true;
 
+	/*
+	 * @rq->curr may still reference an outgoing EXT task after it has been
+	 * dequeued. If no EXT tasks are accounted on @rq, ignore its stale
+	 * slice state. If another task is dispatched from a DSQ,
+	 * set_next_task_scx() will update the dependency for the incoming task.
+	 */
+	if (!rq->scx.nr_running)
+		return true;
+
 	if (scx_bypassing(sch, cpu_of(rq)))
 		return false;
 
-- 
2.53.0



