Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474E71509BF;
	Tue, 20 Feb 2024 21:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463778; cv=none; b=WIbjrVba0m3XmmWHJCtne8onzyHADvqYsryamEPv7aOIDpwfzPz0GsnBGX2Xk4n5w/zj6zQdqNRoSC4xsdpzobJrPkBgWekdD/mRWx4TrJBEO57gSKG3t/ty1wEQ5PZLU6I1pLY7qnWYmgKTe2uFIrCj3d5itNSzPzZWJrLACWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463778; c=relaxed/simple;
	bh=qNJmCwp/EN8GzomrMAVJR6g13zAUBduIfQMTHi3mUs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uL4sF+JHqXFsf8gSey5kPjDF0cwcSc58029Onn3G4Q8JdK/WNhkTHjb+dbAljgAvyVJf2tgUnwgYDAfsgdHlyTartoRWcmZ3R9NhNtH89vY+wa7XlY+vZPd9PH0rpP6ewnnwt48LSpI9+gyeWV3SKOx+sq3PKVdUteOkggpGhcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IJymjOP6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IJymjOP6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999C7C433F1;
	Tue, 20 Feb 2024 21:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463778;
	bh=qNJmCwp/EN8GzomrMAVJR6g13zAUBduIfQMTHi3mUs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IJymjOP6jn1umsa1egsdzJuByBWkvi2INgqpNMmmzov/+ntPFqt4chXo7nRD3L5xs
	 JE/sn7UPB7PQYQJvE+P9Fe7c+UIQGbotv1AGCj9zxhIimNffgt/2GPBSl7AmlwhS8i
	 w3HeqJOFlEtise5jBlBmexp8RNEhc9VQvnX9h5+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>
Subject: [PATCH 6.6 120/331] Revert "drm/msm/gpu: Push gpu lock down past runpm"
Date: Tue, 20 Feb 2024 21:53:56 +0100
Message-ID: <20240220205641.380046803@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


