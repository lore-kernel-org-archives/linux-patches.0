Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD554657EA;
	Tue, 16 Jun 2026 16:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626241; cv=none; b=TciKLBRm/0rGFBW2c45ee2cMrSyqDBrtXo1WhdZ9hkGNUyqUTvTr5QyK97T3RZoCWBQz4wCtSAlro+U23AY4zQ9INAtbMeUrasx8g6IQqKdYj09OtpXWNYRjO7pifzUTJXby+ft3LaG7DjFy2LLTkaRMJYAAx8qsK4AYWLcbz68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626241; c=relaxed/simple;
	bh=Dewr3eXEdcb5NeVhCM+8O/Fmtm6RMkChwoPoAK1Ye6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b82pADmYFNf9fkp2WBUcw9DLaSFaI0p4Fp7GsJxElYId3z3thk4IE0Ug0v1D2RgVpMsP7y60CNOsXJ7IlLa6W9DMgdqBta1ovVrZdlJ6BwYe6E9+wgqko61VZDHdUZ6fgQ5dsYvlZYqk1foH6mj5Abys88+Q3l/IjOmJBKlepno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OmjRcNWu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OmjRcNWu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874D81F000E9;
	Tue, 16 Jun 2026 16:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626240;
	bh=sS8TEhh4RsxoJj3Z8Chs4cSQYXIycI6miOwpRW/iKVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OmjRcNWuCo4+ZkZGCSYH1v4dPeV+nPQoNe+j/MrVZXJUpRjAJjnMe5dFwW+EoCOmE
	 +LcT8ftQdTMRGpF+/TnHcLktB5Vo/eDW9Quk4fHo8mAx82OvWW5n9BdU8/hSpdbQ2Y
	 i+VRC0AW3BgnvGkxuF967DKi1gMUElJ753RBm5Xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 291/325] drm/amdgpu: fix waiting for all submissions for userptrs
Date: Tue, 16 Jun 2026 20:31:27 +0530
Message-ID: <20260616145113.306581199@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

commit 58bafc666c484b21839a2d27e923ae1b2727a1df upstream.

Wait for all submissions when userptrs need to be invalidated by the MMU
notifier, not just the one the userptr was involved into.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Tested-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 91250893cbaa25c86872deca95a540d08de1f91e)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c
@@ -69,6 +69,7 @@ static bool amdgpu_hmm_invalidate_gfx(st
 {
 	struct amdgpu_bo *bo = container_of(mni, struct amdgpu_bo, notifier);
 	struct amdgpu_device *adev = amdgpu_ttm_adev(bo->tbo.bdev);
+	struct amdgpu_bo *vm_root = bo->vm_bo->vm->root.bo;
 	long r;
 
 	if (!mmu_notifier_range_blockable(range))
@@ -79,8 +80,9 @@ static bool amdgpu_hmm_invalidate_gfx(st
 	mmu_interval_set_seq(mni, cur_seq);
 
 	amdgpu_vm_bo_invalidate(bo, false);
-	r = dma_resv_wait_timeout(bo->tbo.base.resv, DMA_RESV_USAGE_BOOKKEEP,
-				  false, MAX_SCHEDULE_TIMEOUT);
+	r = dma_resv_wait_timeout(vm_root->tbo.base.resv,
+				  DMA_RESV_USAGE_BOOKKEEP, false,
+				  MAX_SCHEDULE_TIMEOUT);
 	mutex_unlock(&adev->notifier_lock);
 	if (r <= 0)
 		DRM_ERROR("(%ld) failed to wait for user bo\n", r);


