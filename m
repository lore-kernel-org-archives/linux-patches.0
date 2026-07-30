Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FADE1FE44A;
	Thu, 30 Jul 2026 14:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423243; cv=none; b=cp7DEriXlEXWV9fqOtBZNppqwyTO+yM/dqFgWKKBU/ALDhE+UnmMYQqIsxMtozpL44H7jdlzYtTYPr9zuZ894HhCCm46a0kWJSvLIrJGtFieMcbDvjc48tWBC8GrbzrrteyxuhyarNC1ERb+YV5CQAdov5Yb0vjYFOSylOjnhcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423243; c=relaxed/simple;
	bh=rGPiAUnZkSOpuiN6yRo0iC8ZAaHmkupD7rPtcS03FhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bq8sos+a7yjTJ7gLl7+55WqVz5rjoz/uJaOlojY3eEhfGy/JqDsEf+oDAjGmcW0vrWJnOkmrjfFJvZ2QvYJqNObHG9c64SBdrNsSuYFuwHF4mCotRvNqzAMi5DnCW2ELfcWpGaf8PIKrdb/B7LGfcuwnnqDjhZ5se/35N2m2y/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pc2DWuI2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pc2DWuI2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B691F000E9;
	Thu, 30 Jul 2026 14:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423242;
	bh=VXOPfkmXolg1iZEy6Fll9J4Gjhlrq0IXism8+Mb/d6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pc2DWuI2H0xxBmkE+aaRp8r+wzGaJS0wlUtvpR+Xxz7v1zDE/KigjU9nl9BOBHlAC
	 D0lg63Ut4N67y7Mzxpii87j2QoW6yBXLIkjDrUur4FLO1rbJcen+NDUvOT8s3wdPxy
	 N739SwnQkhp+gmz94v8XpB5QgQdPUVq1uclN4hZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 716/744] drm/amdgpu: fix aperture mapping leak
Date: Thu, 30 Jul 2026 16:16:29 +0200
Message-ID: <20260730141459.497777667@linuxfoundation.org>
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

From: Asad Kamal <asad.kamal@amd.com>

commit ea772a440d56b285f4d491affac50ecd41f6b402 upstream.

amdgpu_pci_remove() calls drm_dev_unplug() before invoking the driver
fini routines. This causes drm_dev_enter() in amdgpu_ttm_fini() to
always return false, so iounmap(aper_base_kaddr) never runs on normal
driver unload, leaving an orphaned entry in the x86 PAT interval tree.

On connected_to_cpu hardware, the aperture is mapped write-back (WB) via
ioremap_cache(). On reload, IP discovery calls memremap(..., MEMREMAP_WC)
over the same range. The WC vs WB conflict causes:

  ioremap error for 0x..., requested 0x1, got 0x0
  amdgpu: discovery failed: -2

Fix by switching to devres-managed mappings so cleanup is guaranteed
regardless of drm_dev_enter() state:

- connected_to_cpu path: devm_memremap(MEMREMAP_WB). For
  IORESOURCE_SYSTEM_RAM ranges this takes the try_ram_remap() shortcut,
  returning __va(offset) from the existing kernel direct map. No new
  ioremap VA or PAT entry is created, so there is nothing to orphan.

- dGPU path: devm_ioremap_wc() registers iounmap() as a devres action,
  guaranteeing cleanup at device_del() time.

Also remove iounmap(aper_base_kaddr) from amdgpu_device_unmap_mmio()
since the mapping is now devres-owned.

v2: Remove redundant x86_64 guard (Lijo)

Fixes: 9d0af8b4def0 ("drm/amdgpu: pre-map device buffer as cached for A+A config")
Signed-off-by: Asad Kamal <asad.kamal@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d871e99879cb5fd1fa798b006b4888887e63a17a)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    2 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c    |   36 ++++++++++++-----------------
 2 files changed, 16 insertions(+), 22 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4169,8 +4169,6 @@ static void amdgpu_device_unmap_mmio(str
 
 	iounmap(adev->rmmio);
 	adev->rmmio = NULL;
-	if (adev->mman.aper_base_kaddr)
-		iounmap(adev->mman.aper_base_kaddr);
 	adev->mman.aper_base_kaddr = NULL;
 
 	/* Memory manager related */
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -2121,18 +2121,23 @@ int amdgpu_ttm_init(struct amdgpu_device
 	/* Change the size here instead of the init above so only lpfn is affected */
 	amdgpu_ttm_set_buffer_funcs_status(adev, false);
 #ifdef CONFIG_64BIT
-#ifdef CONFIG_X86
-	if (adev->gmc.xgmi.connected_to_cpu)
-		adev->mman.aper_base_kaddr = ioremap_cache(adev->gmc.aper_base,
-				adev->gmc.visible_vram_size);
-
-	else if (adev->gmc.is_app_apu)
+	if (adev->gmc.xgmi.connected_to_cpu) {
+		void *kaddr = devm_memremap(adev->dev, adev->gmc.aper_base,
+					    adev->gmc.visible_vram_size,
+					    MEMREMAP_WB);
+		if (IS_ERR(kaddr))
+			return PTR_ERR(kaddr);
+		adev->mman.aper_base_kaddr = (__force void __iomem *)kaddr;
+	} else if (adev->gmc.is_app_apu) {
 		DRM_DEBUG_DRIVER(
 			"No need to ioremap when real vram size is 0\n");
-	else
-#endif
-		adev->mman.aper_base_kaddr = ioremap_wc(adev->gmc.aper_base,
-				adev->gmc.visible_vram_size);
+	} else {
+		adev->mman.aper_base_kaddr = devm_ioremap_wc(adev->dev,
+							     adev->gmc.aper_base,
+							     adev->gmc.visible_vram_size);
+		if (!adev->mman.aper_base_kaddr)
+			return -ENOMEM;
+	}
 #endif
 
 	amdgpu_ttm_init_vram_resv_regions(adev);
@@ -2249,8 +2254,6 @@ int amdgpu_ttm_init(struct amdgpu_device
  */
 void amdgpu_ttm_fini(struct amdgpu_device *adev)
 {
-	int idx;
-
 	if (!adev->mman.initialized)
 		return;
 
@@ -2273,14 +2276,7 @@ void amdgpu_ttm_fini(struct amdgpu_devic
 	amdgpu_ttm_unmark_vram_reserved(adev, AMDGPU_RESV_FW_VRAM_USAGE);
 	amdgpu_ttm_unmark_vram_reserved(adev, AMDGPU_RESV_DRV_VRAM_USAGE);
 
-	if (drm_dev_enter(adev_to_drm(adev), &idx)) {
-
-		if (adev->mman.aper_base_kaddr)
-			iounmap(adev->mman.aper_base_kaddr);
-		adev->mman.aper_base_kaddr = NULL;
-
-		drm_dev_exit(idx);
-	}
+	adev->mman.aper_base_kaddr = NULL;
 
 	if (!adev->gmc.is_app_apu)
 		amdgpu_vram_mgr_fini(adev);


