Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A4C45BD7A;
	Tue, 16 Jun 2026 15:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624475; cv=none; b=Xy8BL2MtC9fNRkWh2IISHbiLTag16zChcc90vI67T1AYVvPvf0NmzYXJUAHsCoq1bF7muyAuVZjJ+fOWUeLEz6CA/+2nlbMX1WqCjk5xbF1Rpg9f9hYaX50QZ+UMzIOg992jBn2qwxqFnnUi7Y9OM12kji8oNiquzLwc4bi76ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624475; c=relaxed/simple;
	bh=1dgz3Fz98OOUsPfhDciDVW41/tpNRX94224Kiftbcu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LZ8AXSOV5URzofG5Tp4kxiD1lqTaw0uJSWj53GEQTtgCA8b5HWjbVxZ5wSUJi2m/7zE9ngQpMz4+n4hWt5uNtcQt+2eU6jjp68E2p3EEwh7DUuEVLcDnF3sGxTYnE3zy2/5VPR2WDHJmGir0P2c8jtJ8ML4BIkme+t4bCWdVSLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0tCi5g3X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0tCi5g3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13E61F000E9;
	Tue, 16 Jun 2026 15:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624473;
	bh=kNllvMs1944lbzJIZGH4Xoh1rakIVSMt0Z30gelStqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0tCi5g3Xyu2ysZteQGzLtdcIVedOfaSl+JIhjgiFElOZAerQOW3NmR8y+r2Bprcqu
	 Vg9VheSF29vbCKWw/JCkEtqAF8A6DiuNU1rwPlZtZzKGXGHxZkUzCg5pMkpLchj86T
	 6qbanhq13T9UZ9TQTx8wjm/U0IbXF+wJzhyHTXMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.0 344/378] drm/amdgpu: fix waiting for all submissions for userptrs
Date: Tue, 16 Jun 2026 20:29:35 +0530
Message-ID: <20260616145128.286671055@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -67,6 +67,7 @@ static bool amdgpu_hmm_invalidate_gfx(st
 {
 	struct amdgpu_bo *bo = container_of(mni, struct amdgpu_bo, notifier);
 	struct amdgpu_device *adev = amdgpu_ttm_adev(bo->tbo.bdev);
+	struct amdgpu_bo *vm_root = bo->vm_bo->vm->root.bo;
 	long r;
 
 	if (!mmu_notifier_range_blockable(range))
@@ -77,8 +78,9 @@ static bool amdgpu_hmm_invalidate_gfx(st
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


