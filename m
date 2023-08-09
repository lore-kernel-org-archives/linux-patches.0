Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01206174CA
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77BCAC433C9;
	Wed,  9 Aug 2023 10:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578624;
	bh=Ma0v6Fzyz6uYKqGPDdR4wHjrl0VDC09imx4S4yHjzOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G01mDfQSwg3JPLnkxDrKkB+CIOGqIH4c7kTP3r1a4R4DAwsjZZjbx9ndMbb03YNNh
	 xGzmbM3e03dEIwVrarnXhMa5T1y81sIGbvAOz8hKLAsZhcfeW3Tr+TifQXn04EMW5n
	 gSvJ3LggeO2DpBQRdrQ0tvaz1u92gCbFtt5nXqZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Le Ma <le.ma@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 126/127] drm/amdgpu: Use apt name for FW reserved region
Date: Wed,  9 Aug 2023 12:41:53 +0200
Message-ID: <20230809103640.765148012@linuxfoundation.org>
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

From: Lijo Lazar <lijo.lazar@amd.com>

commit db3b5cb64a9ca301d14ed027e470834316720e42 upstream

Use the generic term fw_reserved_memory for FW reserve region. This
region may also hold discovery TMR in addition to other reserve
regions. This region size could be larger than discovery tmr size, hence
don't change the discovery tmr size based on this.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Le Ma <le.ma@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ This change fixes reading IP discovery from debugfs.
  It needed to be hand modified because:
  * GC 9.4.3 support isn't introduced in older kernels until
    228ce176434b ("drm/amdgpu: Handle VRAM dependencies on GFXIP9.4.3")
  * It also changed because of 58ab2c08d708 (drm/amdgpu: use VRAM|GTT
    for a bunch of kernel allocations) not being present.
  Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2748 ]
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c |   33 ++++++++++++++++++--------------
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h |    3 +-
 2 files changed, 21 insertions(+), 15 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -1625,14 +1625,15 @@ static int amdgpu_ttm_training_reserve_v
 	return 0;
 }
 
-static void amdgpu_ttm_training_data_block_init(struct amdgpu_device *adev)
+static void amdgpu_ttm_training_data_block_init(struct amdgpu_device *adev,
+						uint32_t reserve_size)
 {
 	struct psp_memory_training_context *ctx = &adev->psp.mem_train_ctx;
 
 	memset(ctx, 0, sizeof(*ctx));
 
 	ctx->c2p_train_data_offset =
-		ALIGN((adev->gmc.mc_vram_size - adev->mman.discovery_tmr_size - SZ_1M), SZ_1M);
+		ALIGN((adev->gmc.mc_vram_size - reserve_size - SZ_1M), SZ_1M);
 	ctx->p2c_train_data_offset =
 		(adev->gmc.mc_vram_size - GDDR6_MEM_TRAINING_OFFSET);
 	ctx->train_data_size =
@@ -1650,9 +1651,10 @@ static void amdgpu_ttm_training_data_blo
  */
 static int amdgpu_ttm_reserve_tmr(struct amdgpu_device *adev)
 {
-	int ret;
 	struct psp_memory_training_context *ctx = &adev->psp.mem_train_ctx;
 	bool mem_train_support = false;
+	uint32_t reserve_size = 0;
+	int ret;
 
 	if (!amdgpu_sriov_vf(adev)) {
 		if (amdgpu_atomfirmware_mem_training_supported(adev))
@@ -1668,14 +1670,15 @@ static int amdgpu_ttm_reserve_tmr(struct
 	 * Otherwise, fallback to legacy approach to check and reserve tmr block for ip
 	 * discovery data and G6 memory training data respectively
 	 */
-	adev->mman.discovery_tmr_size =
-		amdgpu_atomfirmware_get_fw_reserved_fb_size(adev);
-	if (!adev->mman.discovery_tmr_size)
-		adev->mman.discovery_tmr_size = DISCOVERY_TMR_OFFSET;
+	if (adev->bios)
+		reserve_size =
+			amdgpu_atomfirmware_get_fw_reserved_fb_size(adev);
+	if (!reserve_size)
+		reserve_size = DISCOVERY_TMR_OFFSET;
 
 	if (mem_train_support) {
 		/* reserve vram for mem train according to TMR location */
-		amdgpu_ttm_training_data_block_init(adev);
+		amdgpu_ttm_training_data_block_init(adev, reserve_size);
 		ret = amdgpu_bo_create_kernel_at(adev,
 					 ctx->c2p_train_data_offset,
 					 ctx->train_data_size,
@@ -1690,13 +1693,14 @@ static int amdgpu_ttm_reserve_tmr(struct
 	}
 
 	ret = amdgpu_bo_create_kernel_at(adev,
-				adev->gmc.real_vram_size - adev->mman.discovery_tmr_size,
-				adev->mman.discovery_tmr_size,
-				&adev->mman.discovery_memory,
+				adev->gmc.real_vram_size - reserve_size,
+				reserve_size,
+				&adev->mman.fw_reserved_memory,
 				NULL);
 	if (ret) {
 		DRM_ERROR("alloc tmr failed(%d)!\n", ret);
-		amdgpu_bo_free_kernel(&adev->mman.discovery_memory, NULL, NULL);
+		amdgpu_bo_free_kernel(&adev->mman.fw_reserved_memory,
+				      NULL, NULL);
 		return ret;
 	}
 
@@ -1890,8 +1894,9 @@ void amdgpu_ttm_fini(struct amdgpu_devic
 	/* return the stolen vga memory back to VRAM */
 	amdgpu_bo_free_kernel(&adev->mman.stolen_vga_memory, NULL, NULL);
 	amdgpu_bo_free_kernel(&adev->mman.stolen_extended_memory, NULL, NULL);
-	/* return the IP Discovery TMR memory back to VRAM */
-	amdgpu_bo_free_kernel(&adev->mman.discovery_memory, NULL, NULL);
+	/* return the FW reserved memory back to VRAM */
+	amdgpu_bo_free_kernel(&adev->mman.fw_reserved_memory, NULL,
+			      NULL);
 	if (adev->mman.stolen_reserved_size)
 		amdgpu_bo_free_kernel(&adev->mman.stolen_reserved_memory,
 				      NULL, NULL);
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h
@@ -78,7 +78,8 @@ struct amdgpu_mman {
 	/* discovery */
 	uint8_t				*discovery_bin;
 	uint32_t			discovery_tmr_size;
-	struct amdgpu_bo		*discovery_memory;
+	/* fw reserved memory */
+	struct amdgpu_bo		*fw_reserved_memory;
 
 	/* firmware VRAM reservation */
 	u64		fw_vram_usage_start_offset;


