Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23AF5377A89;
	Thu, 20 Aug 2026 15:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238114; cv=none; b=UGaRIUHDm7/06kW4xYHFOtgQu02GBE0DBzhPStotblnBjjhohEbVZ8DziNijtImNX4hcTLU7JYYQllYcFhXNghiLeIKQkkv3Y/RPXIs/tyr1O9htSMijElgQ240U6gzzrWC1iUSh43NkMFh1iDeH18wOsTT/Qz/pDefmbDqgcKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238114; c=relaxed/simple;
	bh=Rxa7iDe6PBeC8tj/Y0FBgllvGPlK7oufjPZ1ZNvLJDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tEONjuSK8pqpDCMc21oIinJ1ulRTJil50fXezxkZQ4cmfgS5JmH1NSRqhs6uAzqFPk6ARohaf8e6Dc3AF2+hS5He7OkQDJVhfbvBCYAse38PDQbrqoeXPfAxMWSmVmoDAWo9cg7cbaPXLXTSx0XaPsWtquBN21AIrlPkCC6+vnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CRxjAktG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CRxjAktG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6DA1F000E9;
	Thu, 20 Aug 2026 15:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238112;
	bh=aIQkqGQrT3kMR3bLbWRB57Is/b2wT2nzDfok34vBoSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CRxjAktGc+cXrRjJp5vlJvz3zh6dHe+SFEivN6qqnxILM/ZIoh5nca/RV0zt5DEt4
	 Pa3P0sVdlg17M4VI80y51Fp/nYfUjZBFofjOjTvZ4Igwe1Y9OGr8e7BzpZNn9wZNwt
	 +uQhH5odUsfau4tTfczZhxS0M/Iy36aZfurQ0lIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 036/228] drm/amdgpu: fix aperture iounmap skipped on device removal
Date: Thu, 20 Aug 2026 16:52:58 +0200
Message-ID: <20260820145245.561243525@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2260,8 +2260,6 @@ int amdgpu_ttm_init(struct amdgpu_device
  */
 void amdgpu_ttm_fini(struct amdgpu_device *adev)
 {
-	int idx;
-
 	if (!adev->mman.initialized)
 		return;
 
@@ -2284,13 +2282,9 @@ void amdgpu_ttm_fini(struct amdgpu_devic
 	amdgpu_ttm_unmark_vram_reserved(adev, AMDGPU_RESV_FW_VRAM_USAGE);
 	amdgpu_ttm_unmark_vram_reserved(adev, AMDGPU_RESV_DRV_VRAM_USAGE);
 
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
 
 	if (!adev->gmc.is_app_apu)


