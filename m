Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421C73A382D;
	Sat, 17 Oct 2026 16:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254437; cv=none; b=eog1uXAmTjvbN7VH8HwwBJWV2YB/0NdZKa8cFRmoZlPMRvFWWJwL6U5PobYfLq6BxBIDo6i/qgF8LOH32aSxGjXpa8NRYr3LaEWSSZGGlPRtP27uC+F0yEGhPvWmNCPcdKYEgfFKR5ckvDcCHnB7B26vvBc5xPN8bM1cs1USMGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254437; c=relaxed/simple;
	bh=6AAhTvQbXqguql+UfEwgPG93qSR47GBZSZOO4u6dID8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LfE64xb9gC6NBPbGzqBWBVQw8k6JIpzYUQsGkGinjoi2H856s8P9tww06AB+QN2uxhKQJYW9JdeXBgcUurfcwHbt3iBMu2R2YcUhEM8QffrYJeIR0RFf9TJ0wN+sMHRwMOxdJRXcI43kGw4Uf9yzw4veE5CWJGm8eVs5VCy7xyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wwr/yELA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wwr/yELA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E47A1F000C4;
	Sat, 17 Oct 2026 16:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254436;
	bh=osRXMPeJQotnXSPGW7U6UHExnPHznk3EskEeV94GO90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wwr/yELApoN9kyYguUbpnIlEHPsa8kKeinFaVOD5aScXKdICRuRBXOeiIPYmend5T
	 SkoxtSArae8alB9Lv6ydO9aFiXOZgvk8Q8eZmQeUc4U96qT7JONA+BiV3J0uyfUXJi
	 CMV/kA6IyB0L0kl31nxUe7MfmWMapKgL5WUKzzYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 446/869] drm/panthor: Always use the IRQ-safe variant when acquiring the fence lock
Date: Sat, 17 Oct 2026 17:54:47 +0200
Message-ID: <20261017160048.580456364@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c1fc52f1ee426..95649ea56ba88 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -1389,7 +1389,7 @@ cs_slot_process_fault_event_locked(struct panthor_device *ptdev,
 		u64 cs_extract = queue->iface.output->extract;
 		struct panthor_job *job;
 
-		spin_lock(&queue->fence_ctx.lock);
+		guard(spinlock_irqsave)(&queue->fence_ctx.lock);
 		list_for_each_entry(job, &queue->fence_ctx.in_flight_jobs, node) {
 			if (cs_extract >= job->ringbuf.end)
 				continue;
@@ -1399,7 +1399,6 @@ cs_slot_process_fault_event_locked(struct panthor_device *ptdev,
 
 			dma_fence_set_error(job->done_fence, -EINVAL);
 		}
-		spin_unlock(&queue->fence_ctx.lock);
 	}
 
 	drm_warn(&ptdev->base,
@@ -2057,13 +2056,13 @@ group_term_post_processing(struct panthor_group *group)
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
@@ -2902,15 +2901,15 @@ static void group_sync_upd_work(struct work_struct *work)
 
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
 
@@ -3153,9 +3152,8 @@ queue_run_job(struct drm_sched_job *sched_job)
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



