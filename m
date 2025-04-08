Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13FC026A1CD;
	Tue,  8 Apr 2025 12:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113901; cv=none; b=EeKbV0PZDUAJ+7gyd+vtrOnEbLF/5mRHnZxlkU1mjRtyTdXPzdaQpP1h03TUtA4P/xM8EmTtQ2HZkXFWB5T5ZuYyKXLwh+TZI/8GfI89rR+/kc04EIFLolvpM5WZ6ufJYyLWbhfshvX2mtRN8Xj9hAJj+qDFG2LbXQjUNVXa3Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113901; c=relaxed/simple;
	bh=J27pTe35tdPFqzqzRlSSwAbJMoI0bPQO6q92vSleTw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i5tkHFhGIggWwl3ASts5hJH27VIwnfl7Ds28FI+pAHkLYxnOirJeh0HE8WF8Xunog6ylyddeam++3Fa23lBv1H7tKI7r7sHgXA3QLVfYQTo0kF7RlQKgyEed8xTiqP+5iYYSUzxiG0ull0j1r2jqkBF+LVI/egYb9/L2ma5J7Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d+1WoSU2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d+1WoSU2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 393D6C4CEEA;
	Tue,  8 Apr 2025 12:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113900;
	bh=J27pTe35tdPFqzqzRlSSwAbJMoI0bPQO6q92vSleTw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d+1WoSU2zEtyZmrwIrSPFI+JGbUSBNr1HA/6eBjiRBc+uTSIkxek5+kY8TeXfu0MO
	 o3VQTshTtqWzhTJHbukyOiyPTJ6nUWc7TpqMb0huj+YeXchmj+ivNqVFj700PkpTu/
	 csnuMD7PrvQpYGGCRzXTyCc/pDmyzdJd69kyO9Mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iago Toral Quiroga <itoral@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>
Subject: [PATCH 5.4 061/154] drm/v3d: Dont run jobs that have errors flagged in its fence
Date: Tue,  8 Apr 2025 12:50:02 +0200
Message-ID: <20250408104817.246156753@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -188,11 +188,15 @@ v3d_tfu_job_run(struct drm_sched_job *sc
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
@@ -226,6 +230,9 @@ v3d_csd_job_run(struct drm_sched_job *sc
 	struct dma_fence *fence;
 	int i;
 
+	if (unlikely(job->base.base.s_fence->finished.error))
+		return NULL;
+
 	v3d->csd_job = job;
 
 	v3d_invalidate_caches(v3d);


