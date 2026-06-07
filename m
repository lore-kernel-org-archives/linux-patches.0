Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3D92E3AF1;
	Sun,  7 Jun 2026 10:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829693; cv=none; b=roBIBuYsVAkjlfbXP84ogYIXb3zQ+wUVmUMCshsc/mZO1XlLGkiX8TLSyBcjnR9LwPzOZ1uR+VZnt0IupaoY3I7SbZNA998Nbn0KHfqwydCxd5H8GQHVpBIRzD/XRweTEXTJ0U4eulMjnGHPR49tIhOz31PYWoWmWDop5doYwBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829693; c=relaxed/simple;
	bh=OFKTwsu4CHn6OcwYCzVp+20D2A8H188dWHzaYhymSVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A2TC1t48VBGwAn0s9RcdxA15eBn/EkC78RNvmAX7sl2G6BQPYJiYo38BBrL5U4ZTM60LU0CuZAkX/YEfazJS10bE/7n8BHm4Cw+kUi4b84DvQOdKXNw7rVfTZ+QdNG+dwfgYrscY5OEpiDCn0sgz7DHCAprseYg9uB2OeWf8/WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DnWcgzKk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DnWcgzKk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1FC1F00893;
	Sun,  7 Jun 2026 10:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829692;
	bh=5fSG4T46aGGIbtVTWx7N8GEh/EeyHLZaulPiOxJcbgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DnWcgzKkJiRFYf8dIbcgzAdhZF3I+IEm0+qUgWqJQBxCO98nheH3AvjmIYirJs/QN
	 MtWoeU8c097YCb6EkCc0UGiZ5WWZXTh7Uz+n34/1wcmTgRYhorg0wy87sbAM3ynbF5
	 BbI9ADMgubHhjg5yvAgQiRzktp8hJpdK2OT3hvXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 271/315] drm/amdgpu: fix calling VM invalidation in amdgpu_hmm_invalidate_gfx
Date: Sun,  7 Jun 2026 12:00:58 +0200
Message-ID: <20260607095737.517833520@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

commit 1c824497d8acd3187d585d6187cedc1897dcc871 upstream.

Otherwise we don't invalidate page tables on next CS.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Tested-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit b6444d1bcbc34f6f2a31a3aab3059be082f3683e)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c |    1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c  |    7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c
@@ -78,6 +78,7 @@ static bool amdgpu_hmm_invalidate_gfx(st
 
 	mmu_interval_set_seq(mni, cur_seq);
 
+	amdgpu_vm_bo_invalidate(bo, false);
 	r = dma_resv_wait_timeout(bo->tbo.base.resv, DMA_RESV_USAGE_BOOKKEEP,
 				  false, MAX_SCHEDULE_TIMEOUT);
 	mutex_unlock(&adev->notifier_lock);
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -1610,6 +1610,7 @@ int amdgpu_vm_handle_moved(struct amdgpu
 {
 	struct amdgpu_bo_va *bo_va;
 	struct dma_resv *resv;
+	struct amdgpu_bo *bo;
 	bool clear, unlock;
 	int r;
 
@@ -1629,11 +1630,13 @@ int amdgpu_vm_handle_moved(struct amdgpu
 	while (!list_empty(&vm->invalidated)) {
 		bo_va = list_first_entry(&vm->invalidated, struct amdgpu_bo_va,
 					 base.vm_status);
-		resv = bo_va->base.bo->tbo.base.resv;
+		bo = bo_va->base.bo;
+		resv = bo->tbo.base.resv;
 		spin_unlock(&vm->status_lock);
 
 		/* Try to reserve the BO to avoid clearing its ptes */
-		if (!adev->debug_vm && dma_resv_trylock(resv)) {
+		if (!adev->debug_vm && !amdgpu_ttm_tt_get_usermm(bo->tbo.ttm) &&
+		    dma_resv_trylock(resv)) {
 			clear = false;
 			unlock = true;
 		/* The caller is already holding the reservation lock */


