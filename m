Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CFF429CCF;
	Mon, 17 Aug 2026 14:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978247; cv=none; b=FQBLqX+A48VHUu7xcTRgLs58VQMiwB5/aFsySezeLpyFj5p/bK4puK1QhwAe/LNqgXLWfdMYnCSGLeCMCl1yY4Ybp+tmKzEigNMMAlHiDtmy/xdZMoZPXtKliyjHwt7QKVCT+fCzrtWUpksXlOTf3I4FkpeSUto1DmPRFuWxS3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978247; c=relaxed/simple;
	bh=Fr49/DkziPNjRtGWYqLYFttOoMfFthYO33ea8OnmLpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qN3uTShYu6znDHaCv4aDSYqMKxOLVhOVbyHtA9+iKbqdLvLs0hgLzguuIiwr13Fli8434NVJKl9BWGrG6Ist7csfw06hi/g0ZAtqXHWk4PttIOH57M4UEhk9IAicfo2Pj2TUuj/i3My3BVVzomxxO8Ea0Bg10uPwB8gLoZttm30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kdVPAjJJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kdVPAjJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA71C1F000E9;
	Mon, 17 Aug 2026 14:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978245;
	bh=Aiurg4wI1g/qFb58ho5lEkhHj9wVwvZBD+iVx58E8H0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kdVPAjJJV2WB6+GpcJUGn4IPH9gyNfvAIl5LvhrKP8tP2Baof2jnJ4Rf2prdDEqrU
	 /j841kNUloVHN0hDycjWLZQX4Im5FeJca8l8Z3ImwMkd/hS6s6jqPKsxmOoquElsEu
	 DfOYR+9lv/kw+z9ivaINNiADQJgvd8unG3BgJPUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuansheng Mao <yuansheng.mao@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 151/181] Revert "drm/amdgpu: fix aperture mapping leak"
Date: Mon, 17 Aug 2026 15:34:05 +0200
Message-ID: <20260817132541.634578478@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4635,6 +4635,8 @@ static void amdgpu_device_unmap_mmio(str
 
 	iounmap(adev->rmmio);
 	adev->rmmio = NULL;
+	if (adev->mman.aper_base_kaddr)
+		iounmap(adev->mman.aper_base_kaddr);
 	adev->mman.aper_base_kaddr = NULL;
 
 	/* Memory manager related */
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -1909,23 +1909,17 @@ int amdgpu_ttm_init(struct amdgpu_device
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
@@ -2072,6 +2066,8 @@ int amdgpu_ttm_init(struct amdgpu_device
  */
 void amdgpu_ttm_fini(struct amdgpu_device *adev)
 {
+	int idx;
+
 	if (!adev->mman.initialized)
 		return;
 
@@ -2094,7 +2090,14 @@ void amdgpu_ttm_fini(struct amdgpu_devic
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
 
 	amdgpu_vram_mgr_fini(adev);
 	amdgpu_gtt_mgr_fini(adev);


