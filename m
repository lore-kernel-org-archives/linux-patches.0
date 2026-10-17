Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892923BAD9B;
	Sat, 17 Oct 2026 18:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260436; cv=none; b=MngslULz9t3FwpmUN8TfB3ASSu0K/zXsMIOB9e4kTpV89WhYKrb/nDHG5idmBaTnhLvvYBvjXa3tibNmLCgK3MhhYijPPI6UtUmtYJwQE1Gi0vGuga6H9HbDOnJfEULukZkb+jnK0yo9kHg40nUuMpNdkOl25d9uWRMXuxTZmUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260436; c=relaxed/simple;
	bh=i7dBzgc5GYl4kPflhSMLamhm4OohUxQZ08Y9yxuthtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eJ+4gVtRHsa/8dCDUcoCJO7NjFX7Fb+8EiUXnr6NFYyplYh12hx+E8IzjgcPtqOP7oVkqRlNb1MFZf/nB8FKyJIOrrDlMnENLRUGsMs39vyca+YUGYNXOwuhqjLYQnBgTG0LV3WuqgvuxPyPJRJHuLw2+rc12tlTiednPQRWZNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fXwNeN1M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fXwNeN1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F1B1F000C4;
	Sat, 17 Oct 2026 18:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260435;
	bh=Blp2sSAh9gtXFkeQsAc15NwhoHoiEQc+LURzUfwsQ7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fXwNeN1M8Xbc4uYqtAMC5xLQkmmXvWycOqJHtV7ub3H/6dki7GPEkGu0BxHLFfFfe
	 3xLSnYI9hIs7cx0DDdHbLHfpOcUSt/Rr2L/1qsFbJRVcHWIZnTI+4VkjibZObomyaV
	 mTIMY+wgZT+mDHpGiPYuQ2/UpMQTdnb04IHshutU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1503/1674] drm/v3d: Clear queue->active_job when v3d_fence_create() fails
Date: Sat, 17 Oct 2026 18:02:55 +0200
Message-ID: <20261017160509.714685209@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit 25a1669907512e927fab9ad4d4fb74ff57f63cd9 ]

The run_job() callbacks for BIN, RENDER, TFU and CSD assign the incoming
job to queue->active_job before calling v3d_fence_create(). If
v3d_fence_create() fails, the callback returns NULL without clearing
active_job, leaving a dangling pointer.

Create a failure path in all run_job() callbacks that clears the active
job before returning NULL. The BIN path takes queue->queue_lock around the
clear as it races against v3d_overflow_mem_work(); RENDER, TFU and CSD
paths have no concurrent reader, so the clear is lock-free.

Fixes: a783a09ee76d ("drm/v3d: Refactor job management.")
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Link: https://patch.msgid.link/20260604-v3d-sched-misc-fixes-v4-2-c068f5bf5ccf@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_sched.c | 60 +++++++++++++++++++--------------
 1 file changed, 34 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/v3d/v3d_sched.c b/drivers/gpu/drm/v3d/v3d_sched.c
index 1708d7cd2627a..8048910113303 100644
--- a/drivers/gpu/drm/v3d/v3d_sched.c
+++ b/drivers/gpu/drm/v3d/v3d_sched.c
@@ -77,15 +77,11 @@ static struct dma_fence *v3d_bin_job_run(struct drm_sched_job *sched_job)
 	struct v3d_bin_job *job = to_bin_job(sched_job);
 	struct v3d_dev *v3d = job->base.v3d;
 	struct drm_device *dev = &v3d->drm;
-	struct dma_fence *fence;
+	struct dma_fence *fence = NULL;
 	unsigned long irqflags;
 
-	if (unlikely(job->base.base.s_fence->finished.error)) {
-		spin_lock_irqsave(&v3d->job_lock, irqflags);
-		v3d->queue[V3D_BIN].active_job = NULL;
-		spin_unlock_irqrestore(&v3d->job_lock, irqflags);
-		return NULL;
-	}
+	if (unlikely(job->base.base.s_fence->finished.error))
+		goto out_clean_job;
 
 	/* Lock required around bin_job update vs
 	 * v3d_overflow_mem_work().
@@ -102,7 +98,7 @@ static struct dma_fence *v3d_bin_job_run(struct drm_sched_job *sched_job)
 
 	fence = v3d_fence_create(v3d, V3D_BIN);
 	if (IS_ERR(fence))
-		return NULL;
+		goto out_clean_job;
 
 	if (job->base.irq_fence)
 		dma_fence_put(job->base.irq_fence);
@@ -129,6 +125,12 @@ static struct dma_fence *v3d_bin_job_run(struct drm_sched_job *sched_job)
 	V3D_CORE_WRITE(0, V3D_CLE_CT0QEA, job->end);
 
 	return fence;
+
+out_clean_job:
+	spin_lock_irqsave(&v3d->job_lock, irqflags);
+	v3d->queue[V3D_BIN].active_job = NULL;
+	spin_unlock_irqrestore(&v3d->job_lock, irqflags);
+	return fence;
 }
 
 static struct dma_fence *v3d_render_job_run(struct drm_sched_job *sched_job)
@@ -136,12 +138,10 @@ static struct dma_fence *v3d_render_job_run(struct drm_sched_job *sched_job)
 	struct v3d_render_job *job = to_render_job(sched_job);
 	struct v3d_dev *v3d = job->base.v3d;
 	struct drm_device *dev = &v3d->drm;
-	struct dma_fence *fence;
+	struct dma_fence *fence = NULL;
 
-	if (unlikely(job->base.base.s_fence->finished.error)) {
-		v3d->queue[V3D_RENDER].active_job = NULL;
-		return NULL;
-	}
+	if (unlikely(job->base.base.s_fence->finished.error))
+		goto out_clean_job;
 
 	v3d->queue[V3D_RENDER].active_job = &job->base;
 
@@ -155,7 +155,7 @@ static struct dma_fence *v3d_render_job_run(struct drm_sched_job *sched_job)
 
 	fence = v3d_fence_create(v3d, V3D_RENDER);
 	if (IS_ERR(fence))
-		return NULL;
+		goto out_clean_job;
 
 	if (job->base.irq_fence)
 		dma_fence_put(job->base.irq_fence);
@@ -175,6 +175,10 @@ static struct dma_fence *v3d_render_job_run(struct drm_sched_job *sched_job)
 	V3D_CORE_WRITE(0, V3D_CLE_CT1QEA, job->end);
 
 	return fence;
+
+out_clean_job:
+	v3d->queue[V3D_RENDER].active_job = NULL;
+	return fence;
 }
 
 static struct dma_fence *
@@ -183,18 +187,16 @@ v3d_tfu_job_run(struct drm_sched_job *sched_job)
 	struct v3d_tfu_job *job = to_tfu_job(sched_job);
 	struct v3d_dev *v3d = job->base.v3d;
 	struct drm_device *dev = &v3d->drm;
-	struct dma_fence *fence;
+	struct dma_fence *fence = NULL;
 
-	if (unlikely(job->base.base.s_fence->finished.error)) {
-		v3d->queue[V3D_TFU].active_job = NULL;
-		return NULL;
-	}
+	if (unlikely(job->base.base.s_fence->finished.error))
+		goto out_clean_job;
 
 	v3d->queue[V3D_TFU].active_job = &job->base;
 
 	fence = v3d_fence_create(v3d, V3D_TFU);
 	if (IS_ERR(fence))
-		return NULL;
+		goto out_clean_job;
 
 	if (job->base.irq_fence)
 		dma_fence_put(job->base.irq_fence);
@@ -218,6 +220,10 @@ v3d_tfu_job_run(struct drm_sched_job *sched_job)
 	V3D_WRITE(V3D_TFU_ICFG, job->args.icfg | V3D_TFU_ICFG_IOC);
 
 	return fence;
+
+out_clean_job:
+	v3d->queue[V3D_TFU].active_job = NULL;
+	return fence;
 }
 
 static struct dma_fence *
@@ -226,13 +232,11 @@ v3d_csd_job_run(struct drm_sched_job *sched_job)
 	struct v3d_csd_job *job = to_csd_job(sched_job);
 	struct v3d_dev *v3d = job->base.v3d;
 	struct drm_device *dev = &v3d->drm;
-	struct dma_fence *fence;
+	struct dma_fence *fence = NULL;
 	int i;
 
-	if (unlikely(job->base.base.s_fence->finished.error)) {
-		v3d->queue[V3D_CSD].active_job = NULL;
-		return NULL;
-	}
+	if (unlikely(job->base.base.s_fence->finished.error))
+		goto out_clean_job;
 
 	/* The HW interprets a workgroup size of 0 as 65536; however, the
 	 * user-space driver exposes a maximum of 65535. Therefore, a 0 in
@@ -250,7 +254,7 @@ v3d_csd_job_run(struct drm_sched_job *sched_job)
 
 	fence = v3d_fence_create(v3d, V3D_CSD);
 	if (IS_ERR(fence))
-		return NULL;
+		goto out_clean_job;
 
 	if (job->base.irq_fence)
 		dma_fence_put(job->base.irq_fence);
@@ -266,6 +270,10 @@ v3d_csd_job_run(struct drm_sched_job *sched_job)
 	V3D_CORE_WRITE(0, V3D_CSD_QUEUED_CFG0, job->args.cfg[0]);
 
 	return fence;
+
+out_clean_job:
+	v3d->queue[V3D_CSD].active_job = NULL;
+	return fence;
 }
 
 static struct dma_fence *
-- 
2.53.0



