Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC11227EBD;
	Tue,  8 Apr 2025 11:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112514; cv=none; b=AZCU63wOfUGaVF6l2tl26NdplTJFmysRt5f68w79DvhBUc+SM8bfLgNX/Z7oEaXN+7i0zDzg+rh8/2CdqfYkgY4bwjmQBVRiybBuUs20r7fJa/zKH0A9+C3QX2SHOomtzk1HKkK3FNK5iF6p1XF6Awso4EpbKeadJBHk0+V3i6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112514; c=relaxed/simple;
	bh=m4KqytdaOC5p5qOkvtLRVQxQPQ5XP0IYABzrX9G9iA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qvKj39Lw87flzMCyRTlY1vxN6vKzFjU4t10kosix/0Y9nbayR4hKteCmDQmzH3FmAYkoV+8eI+Rc585fE64aGXwL9LJsgc8bEext/JD/adrXOk9Mv9chMw0KFpymKzGV+kpaYQZin8tyui0YMXIIDTbYzeJ7VjWU89PMU2yPwgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=muqMfMMb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="muqMfMMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677C2C4CEE5;
	Tue,  8 Apr 2025 11:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112513;
	bh=m4KqytdaOC5p5qOkvtLRVQxQPQ5XP0IYABzrX9G9iA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=muqMfMMbWfA3howdHG0ve0e38/4u3bUm7T8m/JkNR4/mqy5bZeuzza+RCDlJdCVe/
	 0q7ntEU3OqaH5/3GIgZcQHSwj2Xi5Xzbe42irf88RHCPXFn8pehTQBLkKyjSHKZouK
	 WWP241Z0g0jOpwDq7tZHK1Bdy9euZaZDEqQQfh9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iago Toral Quiroga <itoral@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>
Subject: [PATCH 5.15 097/279] drm/v3d: Dont run jobs that have errors flagged in its fence
Date: Tue,  8 Apr 2025 12:48:00 +0200
Message-ID: <20250408104828.971227479@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

commit 80cbee810e4e13cdbd3ae9654e9ecddf17f3e828 upstream.

The V3D driver still relies on `drm_sched_increase_karma()` and
`drm_sched_resubmit_jobs()` for resubmissions when a timeout occurs.
The function `drm_sched_increase_karma()` marks the job as guilty, while
`drm_sched_resubmit_jobs()` sets an error (-ECANCELED) in the DMA fence of
that guilty job.

Because of this, we must check whether the job’s DMA fence has been
flagged with an error before executing the job. Otherwise, the same guilty
job may be resubmitted indefinitely, causing repeated GPU resets.

This patch adds a check for an error on the job's fence to prevent running
a guilty job that was previously flagged when the GPU timed out.

Note that the CPU and CACHE_CLEAN queues do not require this check, as
their jobs are executed synchronously once the DRM scheduler starts them.

Cc: stable@vger.kernel.org
Fixes: d223f98f0209 ("drm/v3d: Add support for compute shader dispatch.")
Fixes: 1584f16ca96e ("drm/v3d: Add support for submitting jobs to the TFU.")
Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250313-v3d-gpu-reset-fixes-v4-1-c1e780d8e096@igalia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/v3d/v3d_sched.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/v3d/v3d_sched.c
+++ b/drivers/gpu/drm/v3d/v3d_sched.c
@@ -202,11 +202,15 @@ v3d_tfu_job_run(struct drm_sched_job *sc
 	struct drm_device *dev = &v3d->drm;
 	struct dma_fence *fence;
 
+	if (unlikely(job->base.base.s_fence->finished.error))
+		return NULL;
+
+	v3d->tfu_job = job;
+
 	fence = v3d_fence_create(v3d, V3D_TFU);
 	if (IS_ERR(fence))
 		return NULL;
 
-	v3d->tfu_job = job;
 	if (job->base.irq_fence)
 		dma_fence_put(job->base.irq_fence);
 	job->base.irq_fence = dma_fence_get(fence);
@@ -240,6 +244,9 @@ v3d_csd_job_run(struct drm_sched_job *sc
 	struct dma_fence *fence;
 	int i;
 
+	if (unlikely(job->base.base.s_fence->finished.error))
+		return NULL;
+
 	v3d->csd_job = job;
 
 	v3d_invalidate_caches(v3d);


