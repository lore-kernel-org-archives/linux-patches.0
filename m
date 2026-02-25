Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3971D5ABA;
	Wed, 25 Feb 2026 01:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983033; cv=none; b=PWDOfiMQ/DeNJR+4/sm95ymXhfrc9pEIMBNsuFX+wOLTdBOT0YFtvjsIBuqraX8SeBp7G5NyduOZ/WsVdXZ5CJ6cL9Pdy8L/+kNNoB2K3oGw5gVZDDVof0LDxYE1aNzpwx/90lPvnDVZJv2Zl0fqYQ/9lclRxE9zmPm9wNFjGpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983033; c=relaxed/simple;
	bh=sqA2NPExujuLzNhF0HaxMtkiQCQb97tPiH9o6aQlr5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pNoeofIB1VUaJFEtRKSoqLmqAh02heSF746h/Gf5EXXeedlvyxRmvDoLZlNsIEG70oaHnwYaAl2cCDhqT/1rSJiSrYtV2UxAcl9Z7OGLwmeYZ5AXvu2SFtq7MXPEgsV8PYJoAJaFa7Z130V/wk1/WYR08QFtsoL7mNg2MsPMLkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AL7lfNNw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AL7lfNNw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C43C116D0;
	Wed, 25 Feb 2026 01:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983033;
	bh=sqA2NPExujuLzNhF0HaxMtkiQCQb97tPiH9o6aQlr5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AL7lfNNwD0GL85w0xnPbURkq39eu7nxBU9qkzeB9MQooHY6vBA5M4Rb3HSDMhrOiG
	 ySrbiwCAdd3jh3KnzFcKJlZ8rM3kVcoWJiOp+6mkEWUR/GEIhf1zfmm+pLzOXBZ78L
	 s12RCg54DKhijGnAr12rvuDe38KxnP/OGNTN0Hb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Price <steven.price@arm.com>,
	Chia-I Wu <olvaffe@gmail.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 198/781] drm/panthor: Make sure we resume the tick when new jobs are submitted
Date: Tue, 24 Feb 2026 17:15:07 -0800
Message-ID: <20260225012404.518872630@linuxfoundation.org>
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
index 484a58b419c08..f53fa51d51694 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -2659,14 +2659,33 @@ static void sync_upd_work(struct work_struct *work)
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
@@ -2711,13 +2730,7 @@ static void group_schedule_locked(struct panthor_group *group, u32 queue_mask)
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
@@ -3351,6 +3364,18 @@ queue_run_job(struct drm_sched_job *sched_job)
 	if (group->csg_id < 0) {
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



