Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D326174CA
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6661C433C8;
	Wed,  9 Aug 2023 10:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578622;
	bh=w83JBWnLbCdEyXcGMhBuD7QPY5MpWujUSQxL4zK+sJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dWbBd0QbSSWH7wUxIUUvziyL0pLjGZkHqreuK3ci9EMkJnsuRd+rpjYgpWllX3pNk
	 30sKGKTictHpc26ojYVjAhWKf6EG6CROLYnutXx0UJc3vNLKYzdNSg6YDYG3K/Iq2w
	 w7An3pBR/VR+BlbmCNZLKptCP6pZWAodj62eJo0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <Alexander.Deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	AMD Graphics <amd-gfx@lists.freedesktop.org>,
	Luben Tuikov <luben.tuikov@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 125/127] drm/amdgpu: Remove unnecessary domain argument
Date: Wed,  9 Aug 2023 12:41:52 +0200
Message-ID: <20230809103640.735137300@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.615294317@linuxfoundation.org>
References: <20230809103636.615294317@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luben Tuikov <luben.tuikov@amd.com>

commit 3273f11675ef11959d25a56df3279f712bcd41b7 upstream

Remove the "domain" argument to amdgpu_bo_create_kernel_at() since this
function takes an "offset" argument which is the offset off of VRAM, and as
such allocation always takes place in VRAM. Thus, the "domain" argument is
unnecessary.

Cc: Alex Deucher <Alexander.Deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: AMD Graphics <amd-gfx@lists.freedesktop.org>
Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c |   10 +++++-----
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.h |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c    |    7 -------
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c   |    1 -
 4 files changed, 6 insertions(+), 14 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -347,17 +347,16 @@ int amdgpu_bo_create_kernel(struct amdgp
  * @adev: amdgpu device object
  * @offset: offset of the BO
  * @size: size of the BO
- * @domain: where to place it
  * @bo_ptr:  used to initialize BOs in structures
  * @cpu_addr: optional CPU address mapping
  *
- * Creates a kernel BO at a specific offset in the address space of the domain.
+ * Creates a kernel BO at a specific offset in VRAM.
  *
  * Returns:
  * 0 on success, negative error code otherwise.
  */
 int amdgpu_bo_create_kernel_at(struct amdgpu_device *adev,
-			       uint64_t offset, uint64_t size, uint32_t domain,
+			       uint64_t offset, uint64_t size,
 			       struct amdgpu_bo **bo_ptr, void **cpu_addr)
 {
 	struct ttm_operation_ctx ctx = { false, false };
@@ -367,8 +366,9 @@ int amdgpu_bo_create_kernel_at(struct am
 	offset &= PAGE_MASK;
 	size = ALIGN(size, PAGE_SIZE);
 
-	r = amdgpu_bo_create_reserved(adev, size, PAGE_SIZE, domain, bo_ptr,
-				      NULL, cpu_addr);
+	r = amdgpu_bo_create_reserved(adev, size, PAGE_SIZE,
+				      AMDGPU_GEM_DOMAIN_VRAM, bo_ptr, NULL,
+				      cpu_addr);
 	if (r)
 		return r;
 
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.h
@@ -284,7 +284,7 @@ int amdgpu_bo_create_kernel(struct amdgp
 			    u32 domain, struct amdgpu_bo **bo_ptr,
 			    u64 *gpu_addr, void **cpu_addr);
 int amdgpu_bo_create_kernel_at(struct amdgpu_device *adev,
-			       uint64_t offset, uint64_t size, uint32_t domain,
+			       uint64_t offset, uint64_t size,
 			       struct amdgpu_bo **bo_ptr, void **cpu_addr);
 int amdgpu_bo_create_user(struct amdgpu_device *adev,
 			  struct amdgpu_bo_param *bp,
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -1575,7 +1575,6 @@ static int amdgpu_ttm_fw_reserve_vram_in
 	return amdgpu_bo_create_kernel_at(adev,
 					  adev->mman.fw_vram_usage_start_offset,
 					  adev->mman.fw_vram_usage_size,
-					  AMDGPU_GEM_DOMAIN_VRAM,
 					  &adev->mman.fw_vram_usage_reserved_bo,
 					  &adev->mman.fw_vram_usage_va);
 }
@@ -1600,7 +1599,6 @@ static int amdgpu_ttm_drv_reserve_vram_i
 	return amdgpu_bo_create_kernel_at(adev,
 					  adev->mman.drv_vram_usage_start_offset,
 					  adev->mman.drv_vram_usage_size,
-					  AMDGPU_GEM_DOMAIN_VRAM,
 					  &adev->mman.drv_vram_usage_reserved_bo,
 					  NULL);
 }
@@ -1681,7 +1679,6 @@ static int amdgpu_ttm_reserve_tmr(struct
 		ret = amdgpu_bo_create_kernel_at(adev,
 					 ctx->c2p_train_data_offset,
 					 ctx->train_data_size,
-					 AMDGPU_GEM_DOMAIN_VRAM,
 					 &ctx->c2p_bo,
 					 NULL);
 		if (ret) {
@@ -1695,7 +1692,6 @@ static int amdgpu_ttm_reserve_tmr(struct
 	ret = amdgpu_bo_create_kernel_at(adev,
 				adev->gmc.real_vram_size - adev->mman.discovery_tmr_size,
 				adev->mman.discovery_tmr_size,
-				AMDGPU_GEM_DOMAIN_VRAM,
 				&adev->mman.discovery_memory,
 				NULL);
 	if (ret) {
@@ -1796,21 +1792,18 @@ int amdgpu_ttm_init(struct amdgpu_device
 	 * avoid display artifacts while transitioning between pre-OS
 	 * and driver.  */
 	r = amdgpu_bo_create_kernel_at(adev, 0, adev->mman.stolen_vga_size,
-				       AMDGPU_GEM_DOMAIN_VRAM,
 				       &adev->mman.stolen_vga_memory,
 				       NULL);
 	if (r)
 		return r;
 	r = amdgpu_bo_create_kernel_at(adev, adev->mman.stolen_vga_size,
 				       adev->mman.stolen_extended_size,
-				       AMDGPU_GEM_DOMAIN_VRAM,
 				       &adev->mman.stolen_extended_memory,
 				       NULL);
 	if (r)
 		return r;
 	r = amdgpu_bo_create_kernel_at(adev, adev->mman.stolen_reserved_offset,
 				       adev->mman.stolen_reserved_size,
-				       AMDGPU_GEM_DOMAIN_VRAM,
 				       &adev->mman.stolen_reserved_memory,
 				       NULL);
 	if (r)
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
@@ -391,7 +391,6 @@ static void amdgpu_virt_ras_reserve_bps(
 		 */
 		if (amdgpu_bo_create_kernel_at(adev, bp << AMDGPU_GPU_PAGE_SHIFT,
 					       AMDGPU_GPU_PAGE_SIZE,
-					       AMDGPU_GEM_DOMAIN_VRAM,
 					       &bo, NULL))
 			DRM_DEBUG("RAS WARN: reserve vram for retired page %llx fail\n", bp);
 


