Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D88375AC8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301734; cv=none; b=SWYb5fqthgJRsBttTI6ksA1SbZO2VvrY/31ucc9cP4u0MTkLlujyf6F5vwWF53MjVlLb0XBjaOoephfjPRCJ2qjyjFvWqajWNtKD2NWhnpaOmKWg0j61HBTunFSqfUWXzJyHOtL7qvfY5o5b2aSKac3+ul1MQuBc5TsLQilKgBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301734; c=relaxed/simple;
	bh=K5DiuZsv4IUNm+apO3Ubr+ANYjFiZhbryPVWeSG/2yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aLo0gEwcSDx6AbC+CwwcV8PlGzVWdU9HIPXh3Yfjx81DrLSLwaGZxuTJ5xcF5LXh5e35sQ1YCxu2++yRGuEOanL4hiFHFxSK+bfSC0Rl63XKSgp6sVLK28IUn35BistIZVgQlaB9UXDZdgbXerXH+E6MsQ3k38fwQXt0QPNGGHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bxLJDRdM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bxLJDRdM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B04C116D0;
	Sat, 28 Feb 2026 18:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301734;
	bh=K5DiuZsv4IUNm+apO3Ubr+ANYjFiZhbryPVWeSG/2yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bxLJDRdMuEDGFe5Wr626/6cWLeGxjJsKU+GFaaOtXx4G3ZPUcD3NK1oS9iqXhZi2l
	 Kg1U3bu08U7nNqiJD1RmSik3d4e0lGDtjcRjFKLJYmoaD1UBOwTxXPMfNYNjiC06gT
	 2ASKrwfue8b0vy8InR1TihyfyNQ+PRVwV6H5aO2lQG/0k0pu5XovS8bXWoTnIM3p55
	 EMMf9awWNs31omEbVe9IqFyc1xuC7lhjGRoyK+rlE+0bT1IgxrpBsMCpTY7SzbiF2E
	 KbH4zLrHWZzBjkbRGmMwemuIR9hZwxsjxeTwkcPzr5RCBqzpZXBfQ4TrFJzNVcsb1n
	 Etogjy7Z7pnpQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Chia-I Wu <olvaffe@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 133/385] drm/panthor: Make sure we resume the tick when new jobs are submitted
Date: Sat, 28 Feb 2026 12:55:55 -0500
Message-ID: <20260228180011.1568201-133-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit 99820b4b7e50d9651f01d2d55b6b9ba92dcc5b99 ]

If the group is already assigned a slot but was idle before this job
submission, we need to make sure the priority rotation happens in the
future. Extract the existing logic living in group_schedule_locked()
and call this new sched_resume_tick() helper from the "group is
assigned a slot" path.

v2:
- Add R-b

v3:
- Re-use queue_mask to clear the bit
- Collect R-b

Fixes: de8548813824 ("drm/panthor: Add the scheduler logical block")
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Chia-I Wu <olvaffe@gmail.com>
Link: https://patch.msgid.link/20251128094839.3856402-8-boris.brezillon@collabora.com
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c | 43 +++++++++++++++++++------
 1 file changed, 34 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index 6be977e69b192..9124df017a1a4 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -2514,14 +2514,33 @@ static void sync_upd_work(struct work_struct *work)
 		sched_queue_delayed_work(sched, tick, 0);
 }
 
+static void sched_resume_tick(struct panthor_device *ptdev)
+{
+	struct panthor_scheduler *sched = ptdev->scheduler;
+	u64 delay_jiffies, now;
+
+	drm_WARN_ON(&ptdev->base, sched->resched_target != U64_MAX);
+
+	/* Scheduler tick was off, recalculate the resched_target based on the
+	 * last tick event, and queue the scheduler work.
+	 */
+	now = get_jiffies_64();
+	sched->resched_target = sched->last_tick + sched->tick_period;
+	if (sched->used_csg_slot_count == sched->csg_slot_count &&
+	    time_before64(now, sched->resched_target))
+		delay_jiffies = min_t(unsigned long, sched->resched_target - now, ULONG_MAX);
+	else
+		delay_jiffies = 0;
+
+	sched_queue_delayed_work(sched, tick, delay_jiffies);
+}
+
 static void group_schedule_locked(struct panthor_group *group, u32 queue_mask)
 {
 	struct panthor_device *ptdev = group->ptdev;
 	struct panthor_scheduler *sched = ptdev->scheduler;
 	struct list_head *queue = &sched->groups.runnable[group->priority];
-	u64 delay_jiffies = 0;
 	bool was_idle;
-	u64 now;
 
 	if (!group_can_run(group))
 		return;
@@ -2566,13 +2585,7 @@ static void group_schedule_locked(struct panthor_group *group, u32 queue_mask)
 	/* Scheduler tick was off, recalculate the resched_target based on the
 	 * last tick event, and queue the scheduler work.
 	 */
-	now = get_jiffies_64();
-	sched->resched_target = sched->last_tick + sched->tick_period;
-	if (sched->used_csg_slot_count == sched->csg_slot_count &&
-	    time_before64(now, sched->resched_target))
-		delay_jiffies = min_t(unsigned long, sched->resched_target - now, ULONG_MAX);
-
-	sched_queue_delayed_work(sched, tick, delay_jiffies);
+	sched_resume_tick(ptdev);
 }
 
 static void queue_stop(struct panthor_queue *queue,
@@ -3129,6 +3142,18 @@ queue_run_job(struct drm_sched_job *sched_job)
 
 		group_schedule_locked(group, BIT(job->queue_idx));
 	} else {
+		u32 queue_mask = BIT(job->queue_idx);
+		bool resume_tick = group_is_idle(group) &&
+				   (group->idle_queues & queue_mask) &&
+				   !(group->blocked_queues & queue_mask) &&
+				   sched->resched_target == U64_MAX;
+
+		/* We just added something to the queue, so it's no longer idle. */
+		group->idle_queues &= ~queue_mask;
+
+		if (resume_tick)
+			sched_resume_tick(ptdev);
+
 		gpu_write(ptdev, CSF_DOORBELL(queue->doorbell_id), 1);
 		if (!sched->pm.has_ref &&
 		    !(group->blocked_queues & BIT(job->queue_idx))) {
-- 
2.51.0

