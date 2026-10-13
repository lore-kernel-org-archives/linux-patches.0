Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E314F4D0A;
	Tue, 13 Oct 2026 12:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893620; cv=none; b=RZ2SA0QJD8lrmNS0QQZqlVulvC4GCtKwhTSQkImjwj1OdQ5WZ5upR8sHwAaxbY/9B2KBSAeZxQDvWwQGMJ/MJsO86MGfoM0JOPKgr5M0MvIAjJFeJQvhgsZExikl9UXLIa01djkFOw+zFcDIE4X3+BFdtMYbTHf6sOkkyeTNwEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893620; c=relaxed/simple;
	bh=QkaMWHNsz67M0s2GfAwKSB9Q69xmGQkYhMw2HnD5EhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MM/0dKFudeQP9HoO85DUqsNTz9UjHG3nidJqWvlcS4NsKYvMDQXsi1VHusZWsF0YUXZ6d1WWAseVKDsy4tm83LfZrcIgzJjTRIAUNPQjfIP9kkT1lZYXefB+TjGyKhEUox4HEIPk6UTimlKzjchFsinXrtZS1RGCE/DKOANAYQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F9lsMnEA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F9lsMnEA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2A51F000FF;
	Tue, 13 Oct 2026 12:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893619;
	bh=LlqiEZGPN74nIMou87ce5nMJBe1r46RnvtcA2IoJtGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F9lsMnEA1m0EmlPAYMhp81zRCdaHsC5nalRy6pi8Tk9ys3XItTzlqDP5crUm1GU1b
	 tXpMPZfBgptjT5HBiKv9VtpwGxMsXh/3zjM59BIfIdu4+/n1W6vL0vuvmveenBayhE
	 A8FOg2HVHCsFZPjW7AKiDSL8AZ354LCoKxNn7qmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 285/621] drm/panthor: Always use the IRQ-safe variant when acquiring the fence lock
Date: Tue, 13 Oct 2026 13:34:40 +0200
Message-ID: <20261013112927.624517885@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit 778c57d624974e64535ef1c9d9b4d8e5066153f4 ]

Since dma_fence objects can be shared with other subsystems, they may be
accessed from hardirq context in those drivers, and we have to take
that into account by also using the IRQ-safe variant when acquiring
the lock.

While at it, switch to the guard model.

Fixes: de8548813824 ("drm/panthor: Add the scheduler logical block")
Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260625-panthor-signal-from-irq-v5-0-8836a74e0ef9@collabora.com?part=11
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260625-panthor-misc-fixes-v1-1-b67ed973fea6@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c | 34 ++++++++++++-------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index 85e24ca474484..4bd40bfb30316 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -1427,7 +1427,7 @@ cs_slot_process_fault_event_locked(struct panthor_device *ptdev,
 		u64 cs_extract = queue->iface.output->extract;
 		struct panthor_job *job;
 
-		spin_lock(&queue->fence_ctx.lock);
+		guard(spinlock_irqsave)(&queue->fence_ctx.lock);
 		list_for_each_entry(job, &queue->fence_ctx.in_flight_jobs, node) {
 			if (cs_extract >= job->ringbuf.end)
 				continue;
@@ -1437,7 +1437,6 @@ cs_slot_process_fault_event_locked(struct panthor_device *ptdev,
 
 			dma_fence_set_error(job->done_fence, -EINVAL);
 		}
-		spin_unlock(&queue->fence_ctx.lock);
 	}
 
 	if (group) {
@@ -2104,13 +2103,13 @@ group_term_post_processing(struct panthor_group *group)
 		if (!queue)
 			continue;
 
-		spin_lock(&queue->fence_ctx.lock);
-		list_for_each_entry_safe(job, tmp, &queue->fence_ctx.in_flight_jobs, node) {
-			list_move_tail(&job->node, &faulty_jobs);
-			dma_fence_set_error(job->done_fence, err);
-			dma_fence_signal_locked(job->done_fence);
+		scoped_guard(spinlock_irqsave, &queue->fence_ctx.lock) {
+			list_for_each_entry_safe(job, tmp, &queue->fence_ctx.in_flight_jobs, node) {
+				list_move_tail(&job->node, &faulty_jobs);
+				dma_fence_set_error(job->done_fence, err);
+				dma_fence_signal_locked(job->done_fence);
+			}
 		}
-		spin_unlock(&queue->fence_ctx.lock);
 
 		/* Manually update the syncobj seqno to unblock waiters. */
 		syncobj = group->syncobjs->kmap + (i * sizeof(*syncobj));
@@ -2991,15 +2990,15 @@ static void group_sync_upd_work(struct work_struct *work)
 
 		syncobj = group->syncobjs->kmap + (queue_idx * sizeof(*syncobj));
 
-		spin_lock(&queue->fence_ctx.lock);
-		list_for_each_entry_safe(job, job_tmp, &queue->fence_ctx.in_flight_jobs, node) {
-			if (syncobj->seqno < job->done_fence->seqno)
-				break;
+		scoped_guard(spinlock_irqsave, &queue->fence_ctx.lock) {
+			list_for_each_entry_safe(job, job_tmp, &queue->fence_ctx.in_flight_jobs, node) {
+				if (syncobj->seqno < job->done_fence->seqno)
+					break;
 
-			list_move_tail(&job->node, &done_jobs);
-			dma_fence_signal_locked(job->done_fence);
+				list_move_tail(&job->node, &done_jobs);
+				dma_fence_signal_locked(job->done_fence);
+			}
 		}
-		spin_unlock(&queue->fence_ctx.lock);
 	}
 	dma_fence_end_signalling(cookie);
 
@@ -3244,9 +3243,8 @@ queue_run_job(struct drm_sched_job *sched_job)
 	job->ringbuf.end = job->ringbuf.start + (instrs.count * sizeof(u64));
 
 	panthor_job_get(&job->base);
-	spin_lock(&queue->fence_ctx.lock);
-	list_add_tail(&job->node, &queue->fence_ctx.in_flight_jobs);
-	spin_unlock(&queue->fence_ctx.lock);
+	scoped_guard(spinlock_irqsave, &queue->fence_ctx.lock)
+		list_add_tail(&job->node, &queue->fence_ctx.in_flight_jobs);
 
 	/* Make sure the ring buffer is updated before the INSERT
 	 * register.
-- 
2.53.0



