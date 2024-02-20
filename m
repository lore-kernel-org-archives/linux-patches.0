Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9149A14F9C8;
	Tue, 20 Feb 2024 21:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464865; cv=none; b=MofyoMitVbts11DKQl0g/XsYjjMalKKA3YwEmi3GHTCsjibJ4gGzRCpnBduJXLd0XdtYJelJU4/HcCRUi0X6vTaYiTa05NQUc3PqWr3FITuthXQNI8vniUg+Jwo7YYHIciuEjKKw9g1CtDoJdXQebvJcAQr5uQJWxnIsqzi73iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464865; c=relaxed/simple;
	bh=id+9RHehqOrebtxxQ5TqbbmiC7Xi3/Z54HdfwsLnEMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WiRg8niUcnWUipTnnqclEPFr07RWMfqn7gr2ZmiiaH4HtPlzNlB7WEvEvHevSCMnc9WL/QfqqGavhgt9huiABRD67VGWrGCKOupUvqT7i2f4yJNiNziY5iqhNI2HgY52o2ukv65uZ94WHHL1G+gsIho5QibxPTBnivtzspCY7zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rei9jdh1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rei9jdh1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26E5C433F1;
	Tue, 20 Feb 2024 21:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464865;
	bh=id+9RHehqOrebtxxQ5TqbbmiC7Xi3/Z54HdfwsLnEMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rei9jdh1TBuGEk6vlZH/ks0MxHETBj3zruOsZxGrBdOAlXZPf7M9OjxwpiUkBisDY
	 0qCXezQEhPgopY3D2W10ozJKZ51CGJE2xd6kM7LYIEpq9+buAf+B/BrcKhMJSZVL7G
	 18jvufKHIoLjLONukffRNHn8Yit9Zx5162Fld5cU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>
Subject: [PATCH 6.7 131/309] Revert "drm/msm/gpu: Push gpu lock down past runpm"
Date: Tue, 20 Feb 2024 21:54:50 +0100
Message-ID: <20240220205637.248153675@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robdclark@chromium.org>

commit 917e9b7c2350e3e53162fcf5035e5f2d68e2cbed upstream.

This reverts commit abe2023b4cea192ab266b351fd38dc9dbd846df0.

Changing the locking order means that scheduler/msm_job_run() can race
with the recovery kthread worker, with the result that the GPU gets an
extra runpm get when we are trying to power it off.  Leaving the GPU in
an unrecovered state.

I'll need to come up with a different scheme for appeasing lockdep.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Patchwork: https://patchwork.freedesktop.org/patch/573835/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/msm_gpu.c        |   11 +++++------
 drivers/gpu/drm/msm/msm_ringbuffer.c |    7 +++++--
 2 files changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -749,12 +749,14 @@ void msm_gpu_submit(struct msm_gpu *gpu,
 	struct msm_ringbuffer *ring = submit->ring;
 	unsigned long flags;
 
-	pm_runtime_get_sync(&gpu->pdev->dev);
+	WARN_ON(!mutex_is_locked(&gpu->lock));
 
-	mutex_lock(&gpu->lock);
+	pm_runtime_get_sync(&gpu->pdev->dev);
 
 	msm_gpu_hw_init(gpu);
 
+	submit->seqno = submit->hw_fence->seqno;
+
 	update_sw_cntrs(gpu);
 
 	/*
@@ -779,11 +781,8 @@ void msm_gpu_submit(struct msm_gpu *gpu,
 	gpu->funcs->submit(gpu, submit);
 	gpu->cur_ctx_seqno = submit->queue->ctx->seqno;
 
-	hangcheck_timer_reset(gpu);
-
-	mutex_unlock(&gpu->lock);
-
 	pm_runtime_put(&gpu->pdev->dev);
+	hangcheck_timer_reset(gpu);
 }
 
 /*
--- a/drivers/gpu/drm/msm/msm_ringbuffer.c
+++ b/drivers/gpu/drm/msm/msm_ringbuffer.c
@@ -21,8 +21,6 @@ static struct dma_fence *msm_job_run(str
 
 	msm_fence_init(submit->hw_fence, fctx);
 
-	submit->seqno = submit->hw_fence->seqno;
-
 	mutex_lock(&priv->lru.lock);
 
 	for (i = 0; i < submit->nr_bos; i++) {
@@ -34,8 +32,13 @@ static struct dma_fence *msm_job_run(str
 
 	mutex_unlock(&priv->lru.lock);
 
+	/* TODO move submit path over to using a per-ring lock.. */
+	mutex_lock(&gpu->lock);
+
 	msm_gpu_submit(gpu, submit);
 
+	mutex_unlock(&gpu->lock);
+
 	return dma_fence_get(submit->hw_fence);
 }
 


