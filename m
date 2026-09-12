Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67199416842;
	Sat, 12 Sep 2026 09:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205946; cv=none; b=nO+q22PoN2oZuKI02LbGGrkidg3mGZD6ka4Ts0nXVrU5zYK8pkUBEE4LXE0dP9lzU+9gPYwtmPMeKAePyKUktdPd6BFX725HdKNOYTDtKB3I5NMogg6khQ7BiRQojaHsF8vkayV40ZcaiyV+/H0upSnQ/29D8q4J7vcQQ5l0pqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205946; c=relaxed/simple;
	bh=ST10aWEeR7PZ61epcrQlinJZ+7kOTV/ncCgrY0K95YU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XC7SBKd+h0AKnQjjmfW+yV6MeW0yxwv43MgFOh5UrqDGWT/CZBYKMfCLZVOqKdji8KK7efXAQZ9cJ1cuhkwGtEk+xmEUVMIyCJyFVzGVYabYZDglWEMYuqxdsDD+/iIoENRDfwhuDgmT7gwJPhHgzb+5RzOGkJJALPsgoKInWz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hdC62I8R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hdC62I8R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394971F000FF;
	Sat, 12 Sep 2026 09:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205945;
	bh=M8XtLeu19Ug697aK71ZvtLNQkbmMdSBBzMpWOOKCULk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hdC62I8Rn8dEHgpTDQmaQ5pQo4hFvIEoB5BM8Ig+1SGTtyrbLx+gKmPDRBKvhrOyk
	 beGcVZ9KkPhMk9xBA0aVyKLOoIiBlv+z0VFURQGAkL9IcvINSWgf2X28r3iR5s7AVc
	 vRt8PVoOL6qCWl+JVHsn16Sgj6nOzFd8GIgLYq08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0106/1518] drm/v3d: Clear queue->active_job when v3d_fence_create() fails
Date: Sat, 12 Sep 2026 08:37:55 +0200
Message-ID: <20260912065625.877180160@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5bbf1b3e60ec3..9b98386965796 100644
--- a/drivers/gpu/drm/v3d/v3d_sched.c
+++ b/drivers/gpu/drm/v3d/v3d_sched.c
@@ -214,15 +214,11 @@ static struct dma_fence *v3d_bin_job_run(struct drm_sched_job *sched_job)
 	struct v3d_dev *v3d = job->base.v3d;
 	struct v3d_queue_state *queue = &v3d->queue[V3D_BIN];
 	struct drm_device *dev = &v3d->drm;
-	struct dma_fence *fence;
+	struct dma_fence *fence = NULL;
 	unsigned long irqflags;
 
-	if (unlikely(job->base.base.s_fence->finished.error)) {
-		spin_lock_irqsave(&queue->queue_lock, irqflags);
-		queue->active_job = NULL;
-		spin_unlock_irqrestore(&queue->queue_lock, irqflags);
-		return NULL;
-	}
+	if (unlikely(job->base.base.s_fence->finished.error))
+		goto out_clean_job;
 
 	/* Lock required around bin_job update vs
 	 * v3d_overflow_mem_work().
@@ -239,7 +235,7 @@ static struct dma_fence *v3d_bin_job_run(struct drm_sched_job *sched_job)
 
 	fence = v3d_fence_create(v3d, V3D_BIN);
 	if (IS_ERR(fence))
-		return NULL;
+		goto out_clean_job;
 
 	if (job->base.irq_fence)
 		dma_fence_put(job->base.irq_fence);
@@ -267,6 +263,12 @@ static struct dma_fence *v3d_bin_job_run(struct drm_sched_job *sched_job)
 	V3D_CORE_WRITE(0, V3D_CLE_CT0QEA, job->end);
 
 	return fence;
+
+out_clean_job:
+	spin_lock_irqsave(&queue->queue_lock, irqflags);
+	queue->active_job = NULL;
+	spin_unlock_irqrestore(&queue->queue_lock, irqflags);
+	return fence;
 }
 
 static struct dma_fence *v3d_render_job_run(struct drm_sched_job *sched_job)
@@ -274,12 +276,10 @@ static struct dma_fence *v3d_render_job_run(struct drm_sched_job *sched_job)
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
 
@@ -293,7 +293,7 @@ static struct dma_fence *v3d_render_job_run(struct drm_sched_job *sched_job)
 
 	fence = v3d_fence_create(v3d, V3D_RENDER);
 	if (IS_ERR(fence))
-		return NULL;
+		goto out_clean_job;
 
 	if (job->base.irq_fence)
 		dma_fence_put(job->base.irq_fence);
@@ -314,6 +314,10 @@ static struct dma_fence *v3d_render_job_run(struct drm_sched_job *sched_job)
 	V3D_CORE_WRITE(0, V3D_CLE_CT1QEA, job->end);
 
 	return fence;
+
+out_clean_job:
+	v3d->queue[V3D_RENDER].active_job = NULL;
+	return fence;
 }
 
 static struct dma_fence *
@@ -322,18 +326,16 @@ v3d_tfu_job_run(struct drm_sched_job *sched_job)
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
@@ -361,6 +363,10 @@ v3d_tfu_job_run(struct drm_sched_job *sched_job)
 	V3D_WRITE(V3D_TFU_ICFG(v3d->ver), job->args.icfg | V3D_TFU_ICFG_IOC);
 
 	return fence;
+
+out_clean_job:
+	v3d->queue[V3D_TFU].active_job = NULL;
+	return fence;
 }
 
 static struct dma_fence *
@@ -369,13 +375,11 @@ v3d_csd_job_run(struct drm_sched_job *sched_job)
 	struct v3d_csd_job *job = to_csd_job(sched_job);
 	struct v3d_dev *v3d = job->base.v3d;
 	struct drm_device *dev = &v3d->drm;
-	struct dma_fence *fence;
+	struct dma_fence *fence = NULL;
 	int i, csd_cfg0_reg;
 
-	if (unlikely(job->base.base.s_fence->finished.error)) {
-		v3d->queue[V3D_CSD].active_job = NULL;
-		return NULL;
-	}
+	if (unlikely(job->base.base.s_fence->finished.error))
+		goto out_clean_job;
 
 	/* The HW interprets a workgroup size of 0 as 65536; however, the
 	 * user-space driver exposes a maximum of 65535. Therefore, a 0 in
@@ -393,7 +397,7 @@ v3d_csd_job_run(struct drm_sched_job *sched_job)
 
 	fence = v3d_fence_create(v3d, V3D_CSD);
 	if (IS_ERR(fence))
-		return NULL;
+		goto out_clean_job;
 
 	if (job->base.irq_fence)
 		dma_fence_put(job->base.irq_fence);
@@ -420,6 +424,10 @@ v3d_csd_job_run(struct drm_sched_job *sched_job)
 	V3D_CORE_WRITE(0, csd_cfg0_reg, job->args.cfg[0]);
 
 	return fence;
+
+out_clean_job:
+	v3d->queue[V3D_CSD].active_job = NULL;
+	return fence;
 }
 
 static void
-- 
2.53.0



