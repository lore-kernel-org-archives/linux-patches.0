Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7194312EBEA;
	Tue, 25 Jun 2024 09:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308686; cv=none; b=UfkyS2XAO5Q1v7qarJBIuk4CPo6ymd7HObBp2XavqlFzaL4FnwRnJ/e2149+6P58ipjnEk0A3qI75Z0bUiGqPwFnU2LhgS7hAYpa4IHFcUVxaGEklDhXHt+fHXqE+aJTZ4uQAKFEWKhhe9FDNtlDqssq1/JcgX0zqDLRNUGLFrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308686; c=relaxed/simple;
	bh=jLRQTfmswNbcRwuaRkwRhtssa8XU9OyOGX+InD4QzI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NnhYn/KdaHvZR+jRyr43Hqzxl5agHYKvql4Qi4AV5mQzLQ3+bImmp/4wrjK1Ku/aFuYKsAg1bjyWtLQm+tIwl6cb8RQNbFXobYk+sb0gCcG39+Q91dCeoQhuTnT+J2OzElHUFeWw/vVEywQtGAtMy2VBP3Ot+0SGr6hHiGVbnjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jb9+x+gY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jb9+x+gY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE3F2C32781;
	Tue, 25 Jun 2024 09:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308686;
	bh=jLRQTfmswNbcRwuaRkwRhtssa8XU9OyOGX+InD4QzI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jb9+x+gY0SUtutkDVLyLlZZyX8vykqqzO1+0y9Ex9vVrikLNwbzt2hlfZw7/V1gf0
	 l66PcjhPKxVe2FF0LWa+Z+MV76fYS5besV8ZyjEeaF2a6IWJsv6p8HfysuqeXlpszl
	 AERQNKwBulQK7Ci1TmmCz72+ec6TWPiKibtZkBFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.9 206/250] drm/amdgpu: fix locking scope when flushing tlb
Date: Tue, 25 Jun 2024 11:32:44 +0200
Message-ID: <20240625085555.961474015@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunxiang Li <Yunxiang.Li@amd.com>

commit 84801d4f1e4fbd2c44dddecaec9099bdff100a42 upstream.

Which method is used to flush tlb does not depend on whether a reset is
in progress or not. We should skip flush altogether if the GPU will get
reset. So put both path under reset_domain read lock.

Signed-off-by: Yunxiang Li <Yunxiang.Li@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
CC: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c |   70 ++++++++++++++++----------------
 1 file changed, 36 insertions(+), 34 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -684,12 +684,17 @@ int amdgpu_gmc_flush_gpu_tlb_pasid(struc
 	struct amdgpu_ring *ring = &adev->gfx.kiq[inst].ring;
 	struct amdgpu_kiq *kiq = &adev->gfx.kiq[inst];
 	unsigned int ndw;
-	signed long r;
+	int r;
 	uint32_t seq;
 
-	if (!adev->gmc.flush_pasid_uses_kiq || !ring->sched.ready ||
-	    !down_read_trylock(&adev->reset_domain->sem)) {
+	/*
+	 * A GPU reset should flush all TLBs anyway, so no need to do
+	 * this while one is ongoing.
+	 */
+	if (!down_read_trylock(&adev->reset_domain->sem))
+		return 0;
 
+	if (!adev->gmc.flush_pasid_uses_kiq || !ring->sched.ready) {
 		if (adev->gmc.flush_tlb_needs_extra_type_2)
 			adev->gmc.gmc_funcs->flush_gpu_tlb_pasid(adev, pasid,
 								 2, all_hub,
@@ -703,43 +708,40 @@ int amdgpu_gmc_flush_gpu_tlb_pasid(struc
 		adev->gmc.gmc_funcs->flush_gpu_tlb_pasid(adev, pasid,
 							 flush_type, all_hub,
 							 inst);
-		return 0;
-	}
+		r = 0;
+	} else {
+		/* 2 dwords flush + 8 dwords fence */
+		ndw = kiq->pmf->invalidate_tlbs_size + 8;
 
-	/* 2 dwords flush + 8 dwords fence */
-	ndw = kiq->pmf->invalidate_tlbs_size + 8;
+		if (adev->gmc.flush_tlb_needs_extra_type_2)
+			ndw += kiq->pmf->invalidate_tlbs_size;
 
-	if (adev->gmc.flush_tlb_needs_extra_type_2)
-		ndw += kiq->pmf->invalidate_tlbs_size;
+		if (adev->gmc.flush_tlb_needs_extra_type_0)
+			ndw += kiq->pmf->invalidate_tlbs_size;
 
-	if (adev->gmc.flush_tlb_needs_extra_type_0)
-		ndw += kiq->pmf->invalidate_tlbs_size;
+		spin_lock(&adev->gfx.kiq[inst].ring_lock);
+		amdgpu_ring_alloc(ring, ndw);
+		if (adev->gmc.flush_tlb_needs_extra_type_2)
+			kiq->pmf->kiq_invalidate_tlbs(ring, pasid, 2, all_hub);
 
-	spin_lock(&adev->gfx.kiq[inst].ring_lock);
-	amdgpu_ring_alloc(ring, ndw);
-	if (adev->gmc.flush_tlb_needs_extra_type_2)
-		kiq->pmf->kiq_invalidate_tlbs(ring, pasid, 2, all_hub);
-
-	if (flush_type == 2 && adev->gmc.flush_tlb_needs_extra_type_0)
-		kiq->pmf->kiq_invalidate_tlbs(ring, pasid, 0, all_hub);
-
-	kiq->pmf->kiq_invalidate_tlbs(ring, pasid, flush_type, all_hub);
-	r = amdgpu_fence_emit_polling(ring, &seq, MAX_KIQ_REG_WAIT);
-	if (r) {
-		amdgpu_ring_undo(ring);
-		spin_unlock(&adev->gfx.kiq[inst].ring_lock);
-		goto error_unlock_reset;
-	}
+		if (flush_type == 2 && adev->gmc.flush_tlb_needs_extra_type_0)
+			kiq->pmf->kiq_invalidate_tlbs(ring, pasid, 0, all_hub);
 
-	amdgpu_ring_commit(ring);
-	spin_unlock(&adev->gfx.kiq[inst].ring_lock);
-	r = amdgpu_fence_wait_polling(ring, seq, usec_timeout);
-	if (r < 1) {
-		dev_err(adev->dev, "wait for kiq fence error: %ld.\n", r);
-		r = -ETIME;
-		goto error_unlock_reset;
+		kiq->pmf->kiq_invalidate_tlbs(ring, pasid, flush_type, all_hub);
+		r = amdgpu_fence_emit_polling(ring, &seq, MAX_KIQ_REG_WAIT);
+		if (r) {
+			amdgpu_ring_undo(ring);
+			spin_unlock(&adev->gfx.kiq[inst].ring_lock);
+			goto error_unlock_reset;
+		}
+
+		amdgpu_ring_commit(ring);
+		spin_unlock(&adev->gfx.kiq[inst].ring_lock);
+		if (amdgpu_fence_wait_polling(ring, seq, usec_timeout) < 1) {
+			dev_err(adev->dev, "timeout waiting for kiq fence\n");
+			r = -ETIME;
+		}
 	}
-	r = 0;
 
 error_unlock_reset:
 	up_read(&adev->reset_domain->sem);


