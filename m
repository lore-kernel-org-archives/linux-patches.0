Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC05E2D7393;
	Thu, 30 Jul 2026 14:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423248; cv=none; b=exe0B+nQVb8nd0wNj+8SML8AghhrSXgpppP+cxu7RtwlD9LMcRrlKLWgrAXqZuV7tkHpcXMWD0AsT7A0crqawuvnJVzA9xIIE3lk/+gnXP2HDiNpJ5m/bBtlxvG+dvZW1KbyoHHyXoT9EYArcEFwYsw6YHICfvlZ4Pif8TIguHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423248; c=relaxed/simple;
	bh=jw3//rAriPhPsGYVWF34RV5EslE1HaunwIJZMBoDtGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i6hBudsA+VsSmYoey1TmLy8z9Ol170umhHMr4cTydIcFrSWzT/yhN2tnEEGOArcnmY6Mi6io6LMfHYMeY1ayU/5bNORux6/Nj467VDAwHC5e3AB3y82eZXBNRNUIt80VDGQnScRc8pziEc78VdaysHJhqdRanzRkhB32iyZGnsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lvm1XoRg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lvm1XoRg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E9D1F000E9;
	Thu, 30 Jul 2026 14:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423247;
	bh=cFNiTSEbwMmsc3srhDs9GlTnIEonLFkPyzgzDOQMtUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lvm1XoRgbIj4hKK2uftmDn+SKE3xmODyNPLFVIPiY69RxOyutHap0nO4aGhqyCI/x
	 fEVyzFJZPerzdVo2m4XwExOZzmTX4oLKkHqzThYsSp9YSCz8tzHnqQ/MBsv5hVybFg
	 c0uTMHSpmmQkyPpd/n+m2CmMvzbFt23wwYRKuMGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 718/744] drm/amdgpu: fix check in amdgpu_hmm_invalidate_gfx
Date: Thu, 30 Jul 2026 16:16:31 +0200
Message-ID: <20260730141459.539720740@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -535,6 +535,7 @@ int amdgpu_gem_userptr_ioctl(struct drm_
 	bo = gem_to_amdgpu_bo(gobj);
 	bo->preferred_domains = AMDGPU_GEM_DOMAIN_GTT;
 	bo->allowed_domains = AMDGPU_GEM_DOMAIN_GTT;
+	bo->parent = amdgpu_bo_ref(fpriv->vm.root.bo);
 	r = amdgpu_ttm_tt_set_userptr(&bo->tbo, args->addr, args->flags);
 	if (r)
 		goto release_object;
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c
@@ -67,7 +67,6 @@ static bool amdgpu_hmm_invalidate_gfx(st
 {
 	struct amdgpu_bo *bo = container_of(mni, struct amdgpu_bo, notifier);
 	struct amdgpu_device *adev = amdgpu_ttm_adev(bo->tbo.bdev);
-	struct amdgpu_bo *vm_root = bo->vm_bo->vm->root.bo;
 	long r;
 
 	if (!mmu_notifier_range_blockable(range))
@@ -78,7 +77,7 @@ static bool amdgpu_hmm_invalidate_gfx(st
 	mmu_interval_set_seq(mni, cur_seq);
 
 	amdgpu_vm_bo_invalidate(bo, false);
-	r = dma_resv_wait_timeout(vm_root->tbo.base.resv,
+	r = dma_resv_wait_timeout(bo->parent->tbo.base.resv,
 				  DMA_RESV_USAGE_BOOKKEEP, false,
 				  MAX_SCHEDULE_TIMEOUT);
 	mutex_unlock(&adev->notifier_lock);


