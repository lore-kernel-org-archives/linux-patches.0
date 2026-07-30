Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945BC446831;
	Thu, 30 Jul 2026 15:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425003; cv=none; b=D/p/AktdJx+lhl76j/X1EiaSu5yYv0rvxhOA73taReBPFsGhMZug2lmxmMQ/SDY5duJfggab3NO+E49mpF2/2kG+Myj8gbCOjnCDX1ayFy6yEyi7yD93ggEUccNL2AblKlCgauWQepgGbUvSIUjN+XB6cjdW6BWO8mK5DOfMZx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425003; c=relaxed/simple;
	bh=I6lMLiF8aTd3I96K2UnaFLFOB3mhz9jshZs+MqkIM7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cQuMRBjiirjcE1tBhytobMl3hpaqeDRzxIHgDsSI+UijQIjn4NRuz/QN46hkBSJW/QmI/dEYX0e2odFqk7ox2qO/npRayN20vXMtpjjyJHUgpS2c7DwRLbbhHQ67B8drIoQZ90m+M79Sk0t5rfd0Zpm0YyHRBl3V9K/CexzgPo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RIX2BS0d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RIX2BS0d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A731F000E9;
	Thu, 30 Jul 2026 15:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425002;
	bh=6VGNe7Asr7J3p4FaZAQgyTF+r4jnY3WKuX9kPxylM8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RIX2BS0dlFxTL3Ath1GgfyivuVpJyv118qEMXX3zbS9kb86Ku9O7xBdB7Mtw8UaCD
	 yE85uQGfAdHnnHB5Xx0387JYaBrLSYbvMNc4TVKh7SN9lYvYT/STR28ybOq2YtuteP
	 cqRTKeIZt3b+LOG+0chLCxwHHI+66ox1opsN+XkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 590/675] drm/amdgpu: fix check in amdgpu_hmm_invalidate_gfx
Date: Thu, 30 Jul 2026 16:15:20 +0200
Message-ID: <20260730141457.663223753@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Christian König <christian.koenig@amd.com>

commit 52f650963d8825e97a0ccdd2b616f8a01d9d3d38 upstream.

For a short moment during alloc/free the userptr BO is not part of his VM,
so bo->vm_bo can be NULL.

Keep a reference to the VM root PD as parent of the userptr BO so that
we can always use that to wait for all submissions of the VM instead of
only the one involving the userptr BO.

Signed-off-by: Christian König <christian.koenig@amd.com>
Fixes: 91250893cbaa ("drm/amdgpu: fix waiting for all submissions for userptrs")
Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/5399
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 631849ff5d603841e74f19f4a5e30fe1f7d7cf30)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c |    1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c |    3 +--
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -523,6 +523,7 @@ int amdgpu_gem_userptr_ioctl(struct drm_
 	bo = gem_to_amdgpu_bo(gobj);
 	bo->preferred_domains = AMDGPU_GEM_DOMAIN_GTT;
 	bo->allowed_domains = AMDGPU_GEM_DOMAIN_GTT;
+	bo->parent = amdgpu_bo_ref(fpriv->vm.root.bo);
 	r = amdgpu_ttm_tt_set_userptr(&bo->tbo, args->addr, args->flags);
 	if (r)
 		goto release_object;
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c
@@ -69,7 +69,6 @@ static bool amdgpu_hmm_invalidate_gfx(st
 {
 	struct amdgpu_bo *bo = container_of(mni, struct amdgpu_bo, notifier);
 	struct amdgpu_device *adev = amdgpu_ttm_adev(bo->tbo.bdev);
-	struct amdgpu_bo *vm_root = bo->vm_bo->vm->root.bo;
 	long r;
 
 	if (!mmu_notifier_range_blockable(range))
@@ -80,7 +79,7 @@ static bool amdgpu_hmm_invalidate_gfx(st
 	mmu_interval_set_seq(mni, cur_seq);
 
 	amdgpu_vm_bo_invalidate(bo, false);
-	r = dma_resv_wait_timeout(vm_root->tbo.base.resv,
+	r = dma_resv_wait_timeout(bo->parent->tbo.base.resv,
 				  DMA_RESV_USAGE_BOOKKEEP, false,
 				  MAX_SCHEDULE_TIMEOUT);
 	mutex_unlock(&adev->notifier_lock);


