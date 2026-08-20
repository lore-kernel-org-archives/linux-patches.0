Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4412A38236C;
	Thu, 20 Aug 2026 15:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239395; cv=none; b=Ejk8rEYaWQdpeqTQERDcyQB9K0V87NO8n0JVkWkE39DI1yhAYuYfWjcqz2q03yt4Wy5KrmVtw3w9I4UQ3KE12lPlxNbrP3mPzx2i2748dOIKQdtAt7VWmPRG6A6PuFZoY33WloD0Kcr9jOec5dsWAffB8pX+f3fhzBhkQDBASXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239395; c=relaxed/simple;
	bh=VFhQAH101fw+DaWBqBwwqc+v/sHxVWcOzkD20Do2T6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TgiJAKoVsJRpCVUsAIWH2kRRCMu+mA7re69L92RQYWSK8o+XDbL+4NYCby5LYXbJrpbOZ91AOGDZ8qfK7pSJ0u7pZGkHVzE6/wAqcQtcZtZZfs/SdAB26dKI3GIQHMaDekHg9mj2KfLVegXTSy2nrO7esgAut+S1mkEHQ0sYhdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n1NxXhS7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n1NxXhS7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE371F00A3A;
	Thu, 20 Aug 2026 15:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239394;
	bh=fURcTnC2C9o+w20Qa9788WMv81msOQVk2WY6lAUc2CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n1NxXhS7i0c9BHQgwZniPDt+lIeUlpKvt5PCz1qp+KvO4nOVzGzCWbgXGX1Adm17y
	 Z51TuBjVKKUomMdAivxAzqNgQgLJ+lCl7AKQP5RNw8n5VnIh1ymFaxsHUPb0nifHlG
	 ubOndRbpqAx4d9lxPpl4IJ3z5XVIbvMLDXzZmIEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 034/220] drm/amdgpu: fix aperture iounmap skipped on device removal
Date: Thu, 20 Aug 2026 16:53:44 +0200
Message-ID: <20260820145224.526598449@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

commit f9e5f51549000e2665e3b5e02ff876b9e09cfe95 upstream.

amdgpu_pci_remove() calls drm_dev_unplug() before invoking the fini
routines. After drm_dev_unplug() the drm_dev_enter() guard in
amdgpu_ttm_fini() always returns false, so iounmap() for
aper_base_kaddr is silently skipped. On connected_to_cpu hardware
ioremap_cache() maps the aperture as WB; when iounmap() is skipped the
stale WB PAT entry persists. On reload IP discovery's
memremap(MEMREMAP_WC) on the same aperture range hits a WB/WC conflict,
producing an ioremap error and failing re-probe.

Remove the drm_dev_enter() guard and call iounmap() unconditionally.
The aperture mapping is plain MMIO and does not require device-presence
protection. Surprise-removal cleanup of aper_base_kaddr is already
handled unconditionally by amdgpu_device_unmap_mmio().

Fixes: 62d5f9f7110a ("drm/amdgpu: Unmap MMIO mappings when device is not unplugged")
Signed-off-by: Asad Kamal <asad.kamal@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit fb3f68af9f6fce9343a2bd13b4d68a1c02d283df)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -2066,8 +2066,6 @@ int amdgpu_ttm_init(struct amdgpu_device
  */
 void amdgpu_ttm_fini(struct amdgpu_device *adev)
 {
-	int idx;
-
 	if (!adev->mman.initialized)
 		return;
 
@@ -2090,13 +2088,9 @@ void amdgpu_ttm_fini(struct amdgpu_devic
 	amdgpu_ttm_fw_reserve_vram_fini(adev);
 	amdgpu_ttm_drv_reserve_vram_fini(adev);
 
-	if (drm_dev_enter(adev_to_drm(adev), &idx)) {
-
-		if (adev->mman.aper_base_kaddr)
-			iounmap(adev->mman.aper_base_kaddr);
+	if (adev->mman.aper_base_kaddr) {
+		iounmap(adev->mman.aper_base_kaddr);
 		adev->mman.aper_base_kaddr = NULL;
-
-		drm_dev_exit(idx);
 	}
 
 	amdgpu_vram_mgr_fini(adev);


