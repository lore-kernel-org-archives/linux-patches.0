Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D274441041;
	Mon, 17 Aug 2026 14:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975234; cv=none; b=CM8h8UzVcbbboQ2Nrqn3RxtAMUhvpYtxL4ENl4dgEGCT5DQGGtVp1UnQoxKY2Gx3IMtPsrYAv1Md+wlhafVth4mV9b7jRb0sl4EBJLMLUCtLZPAZfixdd7u4QoBvbUP17JZhcuebxCYv4TJyv9iVTEd3FKrWpfBZUspDW619xuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975234; c=relaxed/simple;
	bh=VoXL3rMEKFn8l8zb2V3LCYLVwbhoEgjRGXGa06XZmo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZXlSlPA+Ph9USuWZmRmim27pNC/FCKGjy9vmve0ANf3MGnOrNNOKct6o6aBfBkFtMm0KflWd8PJcd/6eK3Dc3t+D5/JNRwFSpV2WS7jV5+TWtTUYmprPj23OF7HDdFbdLWYw5f6/6y6Qe7l0p55d7ae1UPQ1xMQNNmzshlm7Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=15j4i39O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="15j4i39O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72BD1F000E9;
	Mon, 17 Aug 2026 14:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975233;
	bh=ul4JDWK7dXppz5ebK4+tBjUvn8DvSOY8Sk6eft9XAaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=15j4i39OVMVpgCt8z/6InNQFkPb6K13dqeb03KzOoHWtTOfdb2ga1w5X3EiTRq2AW
	 4y/LUui8w+fBw05BnSjEE88tScsN3k9pG5GDb/RThobB4uIyDyv9pmVyfeqZcUhNEj
	 1uOp0s734Gila1wfXZWk+cxN1t8BcIY77ejLCdIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuansheng Mao <yuansheng.mao@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 209/250] Revert "drm/amdgpu: fix aperture mapping leak"
Date: Mon, 17 Aug 2026 15:32:50 +0200
Message-ID: <20260817132545.097257661@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asad Kamal <asad.kamal@amd.com>

commit b96c529cd2551b78316a4afa3237b2ed96ba03c8 upstream.

devres teardown is LIFO. The aperture devres node was registered after
the DRM device node, so devres_release_all() unmaps the aperture before
the DRM device release callback fires amdgpu_device_fini_sw(). IP
sw_fini callbacks (e.g. vcn_v4_0_sw_fini) write to fw_shared through a
pointer derived from aper_base_kaddr, causing a kernel page fault on
probe failure / rollback:

  BUG: unable to handle page fault ... PMD 0
  RIP: vcn_v4_0_sw_fini+0x7b/0x170 [amdgpu]
  Call Trace:
    amdgpu_device_fini_sw
    amdgpu_driver_release_kms
    devm_drm_dev_init_release
    devres_release_all

This reverts commit d871e99879cb5fd1fa798b006b4888887e63a17a.

Fixes: d871e99879cb ("drm/amdgpu: fix aperture mapping leak")
Reported-by: Yuansheng Mao <yuansheng.mao@amd.com>
Signed-off-by: Asad Kamal <asad.kamal@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 336e0cd576817ac64a4b394ca2b3680029f3e37f)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c    |   35 +++++++++++++++--------------
 2 files changed, 21 insertions(+), 16 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4946,6 +4946,8 @@ static void amdgpu_device_unmap_mmio(str
 
 	iounmap(adev->rmmio);
 	adev->rmmio = NULL;
+	if (adev->mman.aper_base_kaddr)
+		iounmap(adev->mman.aper_base_kaddr);
 	adev->mman.aper_base_kaddr = NULL;
 
 	/* Memory manager related */
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -1980,23 +1980,17 @@ int amdgpu_ttm_init(struct amdgpu_device
 	/* Change the size here instead of the init above so only lpfn is affected */
 	amdgpu_ttm_set_buffer_funcs_status(adev, false);
 #ifdef CONFIG_64BIT
-	if (adev->gmc.xgmi.connected_to_cpu) {
-		void *kaddr = devm_memremap(adev->dev, adev->gmc.aper_base,
-					    adev->gmc.visible_vram_size,
-					    MEMREMAP_WB);
-		if (IS_ERR(kaddr))
-			return PTR_ERR(kaddr);
-		adev->mman.aper_base_kaddr = (__force void __iomem *)kaddr;
-	} else if (adev->gmc.is_app_apu) {
+#ifdef CONFIG_X86
+	if (adev->gmc.xgmi.connected_to_cpu)
+		adev->mman.aper_base_kaddr = ioremap_cache(adev->gmc.aper_base,
+				adev->gmc.visible_vram_size);
+	else if (adev->gmc.is_app_apu)
 		DRM_DEBUG_DRIVER(
 			"No need to ioremap when real vram size is 0\n");
-	} else {
-		adev->mman.aper_base_kaddr = devm_ioremap_wc(adev->dev,
-							     adev->gmc.aper_base,
-							     adev->gmc.visible_vram_size);
-		if (!adev->mman.aper_base_kaddr)
-			return -ENOMEM;
-	}
+	else
+#endif
+		adev->mman.aper_base_kaddr = ioremap_wc(adev->gmc.aper_base,
+				adev->gmc.visible_vram_size);
 #endif
 
 	/*
@@ -2169,6 +2163,8 @@ int amdgpu_ttm_init(struct amdgpu_device
  */
 void amdgpu_ttm_fini(struct amdgpu_device *adev)
 {
+	int idx;
+
 	if (!adev->mman.initialized)
 		return;
 
@@ -2195,7 +2191,14 @@ void amdgpu_ttm_fini(struct amdgpu_devic
 	amdgpu_ttm_fw_reserve_vram_fini(adev);
 	amdgpu_ttm_drv_reserve_vram_fini(adev);
 
-	adev->mman.aper_base_kaddr = NULL;
+	if (drm_dev_enter(adev_to_drm(adev), &idx)) {
+
+		if (adev->mman.aper_base_kaddr)
+			iounmap(adev->mman.aper_base_kaddr);
+		adev->mman.aper_base_kaddr = NULL;
+
+		drm_dev_exit(idx);
+	}
 
 	if (!adev->gmc.is_app_apu)
 		amdgpu_vram_mgr_fini(adev);


