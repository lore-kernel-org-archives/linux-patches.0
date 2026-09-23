Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43304442397;
	Wed, 23 Sep 2026 14:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174100; cv=none; b=VHpksV22ZGbRTqXS5mWuoHoUW/fLJkUB1ykSC9PSLAC6aWeWerd1u6L1nMv4Krg4WrJZ3D6m1X59Ka4E8LBovD3dVGaDVltMZKlwATzZROEhHwQnxuOH59F41oQZcnleNkESdnMSCEhPy91eNMiSl5yAASHfuNxBIky25ez7HYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174100; c=relaxed/simple;
	bh=IzcYIBS6mdK7tXXmwtYF129un+uSC7dsKfXj8Mi28Rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4LBYs6+rS5EeF1PwP8KfCZ0K5FL+ZiIBySGEgn+PK7+//hcysm314DwOE3llk7SrRFDKBAvB2jIJ3NLEzK8JguS+UAUfsCd6UOdNjdsLP/M61l5oLW8FLkE9JszK7iOHLrPjXxSNZ5zyQa5Jc804hd/ps5KIBLWbvDelJOK92k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UIvRLrZC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UIvRLrZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944281F000FF;
	Wed, 23 Sep 2026 14:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174099;
	bh=i4eEHAJPAF2aAeOy7K3KsupswSysO4Qz6mt3m9Ar8Pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UIvRLrZC3SVNEa0/GVLLjX6orsGPXOyoGqgBTCoEvP/IkYPtQ4UHGetq+HjIRsmwu
	 3CB4GjkJGF4JK7c4Ks79AiO1I69APh6LrLP+lys3PfBzw3AVqEKxAvYKTQeWX1FuM7
	 N6akRX9TQQGHZ2fG09pd45/c+OTbkV2rSSRJU/x4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	chong li <chongli2@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 433/438] drm/amdgpu: reduce early full GPU access during SR-IOV init
Date: Wed, 23 Sep 2026 16:07:34 +0200
Message-ID: <20260923140656.155518583@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: chong li <chongli2@amd.com>

[ Upstream commit cba4928cdffaa0f9012acff0ec4f896320107077 ]

Allow early FB reads to fall back to BAR0 when the VRAM aperture is not ready.
This lets SR-IOV VFs consume host-provided init data before requesting full GPU access.

For ASICs that support request_init_data,
defer full GPU access until after non-GPU early init to shorten the full-access window.

Legacy ASICs(before NV12) do not send request_init_data;
the host dumps init data only during full GPU access,
so keep the original early full-access request path for them.

Signed-off-by: chong li <chongli2@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 04de4007d323 ("drm/amdgpu: Fix GPU PCIe link capability reporting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |   88 +++++++++++++++++++++++++++--
 drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c      |    7 +-
 2 files changed, 88 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -750,6 +750,64 @@ void amdgpu_device_mm_access(struct amdg
 	drm_dev_exit(idx);
 }
 
+#ifdef CONFIG_64BIT
+/*
+ * During early SR-IOV VF init, host-provided init data can live in FB before
+ * the normal VRAM aperture mapping is ready.  Use a temporary BAR0 mapping for
+ * reads only, and verify it matches the VRAM aperture when aperture information
+ * is already available.
+ */
+static int amdgpu_device_read_fb_via_bar0(struct amdgpu_device *adev,
+					  u64 offset, void *buf, size_t size)
+{
+	resource_size_t aper_base, aper_size, bar_start, bar_size, map_base;
+	void __iomem *vram;
+	size_t map_offset, map_size;
+	unsigned long flags;
+	u64 end;
+
+	if (!buf || !size)
+		return -EINVAL;
+
+	flags = pci_resource_flags(adev->pdev, 0);
+	if ((flags & IORESOURCE_UNSET) || !(flags & IORESOURCE_MEM))
+		return -EINVAL;
+
+	bar_start = pci_resource_start(adev->pdev, 0);
+	bar_size = pci_resource_len(adev->pdev, 0);
+	if (!bar_size)
+		return -ENODEV;
+
+	aper_base = adev->gmc.aper_base;
+	aper_size = adev->gmc.visible_vram_size ? adev->gmc.visible_vram_size :
+						  adev->gmc.aper_size;
+
+	if (aper_base || aper_size) {
+		if (aper_base != bar_start || aper_size > bar_size)
+			return -EINVAL;
+	} else {
+		aper_base = bar_start;
+		aper_size = bar_size;
+	}
+
+	if (check_add_overflow(offset, size, &end) || end > aper_size)
+		return -EINVAL;
+
+	map_offset = offset_in_page(offset);
+	map_base = aper_base + (offset & PAGE_MASK);
+	map_size = PAGE_ALIGN(map_offset + size);
+
+	vram = ioremap_wc(map_base, map_size);
+	if (!vram)
+		return -ENOMEM;
+
+	memcpy_fromio(buf, (u8 __iomem *)vram + map_offset, size);
+	iounmap(vram);
+
+	return 0;
+}
+#endif
+
 /**
  * amdgpu_device_aper_access - access vram by vram aperture
  *
@@ -769,8 +827,12 @@ size_t amdgpu_device_aper_access(struct
 	size_t count = 0;
 	uint64_t last;
 
-	if (!adev->mman.aper_base_kaddr)
+	if (!adev->mman.aper_base_kaddr) {
+		/* Writes still require the regular aperture/MM path. */
+		if (!write && !amdgpu_device_read_fb_via_bar0(adev, pos, buf, size))
+			return size;
 		return 0;
+	}
 
 	last = min(pos + size, adev->gmc.visible_vram_size);
 	if (last > pos) {
@@ -2011,16 +2073,25 @@ static int amdgpu_device_ip_early_init(s
 {
 	struct amdgpu_ip_block *ip_block;
 	struct pci_dev *parent;
-	bool total, skip_bios;
+	bool total, skip_bios, early_full_gpu_access = false;
 	uint32_t bios_flags;
 	int i, r;
 
 	amdgpu_device_enable_virtual_display(adev);
 
 	if (amdgpu_sriov_vf(adev)) {
-		r = amdgpu_virt_request_full_gpu(adev, true);
-		if (r)
-			return r;
+		/*
+		 * Legacy hosts do not provide init data before early init, so
+		 * keep the original early full GPU access request for them.  Newer
+		 * hosts publish the init data through VF FB, which lets us defer
+		 * full GPU access until after non-GPU early init work is done.
+		 */
+		early_full_gpu_access = (adev->virt.req_init_data_ver == 0);
+		if (early_full_gpu_access) {
+			r = amdgpu_virt_request_full_gpu(adev, true);
+			if (r)
+				return r;
+		}
 
 		r = amdgpu_virt_init_critical_region(adev);
 		if (r)
@@ -2183,6 +2254,13 @@ static int amdgpu_device_ip_early_init(s
 	if (!total)
 		return -ENODEV;
 
+	/* Request full GPU access only for the remaining SR-IOV init work. */
+	if (amdgpu_sriov_vf(adev) && !early_full_gpu_access) {
+		r = amdgpu_virt_request_full_gpu(adev, true);
+		if (r)
+			return r;
+	}
+
 	if (adev->gmc.xgmi.supported)
 		amdgpu_xgmi_early_init(adev);
 
--- a/drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c
+++ b/drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c
@@ -185,8 +185,11 @@ static int xgpu_ai_send_access_requests(
 	} else if (req == IDH_REQ_GPU_INIT_DATA){
 		/* Dummy REQ_GPU_INIT_DATA handling */
 		r = xgpu_ai_poll_msg(adev, IDH_REQ_GPU_INIT_DATA_READY);
-		/* version set to 0 since dummy */
-		adev->virt.req_init_data_ver = 0;	
+		/*
+		 * AI uses the GPU_CRIT_REGION_V1 layout in practice, so fix the
+		 * dummy version value to match the actual init-data format.
+		 */
+		adev->virt.req_init_data_ver = GPU_CRIT_REGION_V1;
 	}
 
 	return 0;


