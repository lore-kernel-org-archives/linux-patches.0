Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8943905EB;
	Sat, 17 Oct 2026 16:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254356; cv=none; b=GsvMNW2OtWGrs32lOhrg9eIUdEgrfCVm1KPUyGO+tA+EDx0xid2UcuDxKm+gBqCDNPeRiK8yr0S/4/3FQEl1ypgHu9VcepqAxoaZNOim6amHALkQY8oI6nvNbCvBEUtrwhPncdyoIaKOkx+eWwMgFny3U7EJisZCkjIMusjwZJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254356; c=relaxed/simple;
	bh=j3EPuKE5dMQFypeao3fad91yaiJ9BM+Ghj+SLzLcsi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MpAWAfghWIHmTlXL1D+GNXTF6e8NM1h+wQFh1rV5KfFfPEim2WmVwB/wmyNHftaK2NexOcHFWKevmEAXQqVHt5y5mLzfn/rUsuDIK+X35CXVhBbCyJ9HMjXHq9j6Boefhr+WHFl5zGjLf/2i/pWQryXNhHRoE2Keqx0TvWpuoLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OZUHitjC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OZUHitjC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 530621F000C4;
	Sat, 17 Oct 2026 16:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254354;
	bh=tCYtPKzTGGHojQJ7jDsbNbTPX/jibzB7gTZ22PhX89o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OZUHitjCYJ5zvE7Kghb/5q3uq+NtuJKdLtJLAFwKn37RXB1GShI/AbwxwO6ItGO5A
	 JEBcqP+/LJ2yOgtDkqSRz4nDNw5qhZ9YffH8kuPkesDMD/yLUEqOsUsPW/8W8WsZko
	 6Q0BMOV4n+4TwqPAK7/ghO/WthJ4zwC3lYkrOdts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 382/869] drm/amdgpu: Use dbg level for VBIOS check messages
Date: Sat, 17 Oct 2026 17:53:43 +0200
Message-ID: <20261017160046.907911724@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 635c659fceed82f934623188471ff604e098aab7 ]

Driver has different ways to fetch VBIOS. If one of the methods doesn't
find an authentic one, it will show misleading info messages eventhough
a subsequent method finds a valid VBIOS. Keep the message level at debug
and add device context.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 65bff2661760 ("drm/amdgpu: Release VFCT ACPI table reference")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c | 26 +++++++++++++-----------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
index e665430898244..53641234b9cf8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
@@ -48,35 +48,37 @@
 /* Check if current bios is an ATOM BIOS.
  * Return true if it is ATOM BIOS. Otherwise, return false.
  */
-static bool check_atom_bios(uint8_t *bios, size_t size)
+static bool check_atom_bios(struct amdgpu_device *adev, size_t size)
 {
 	uint16_t tmp, bios_header_start;
+	uint8_t *bios = adev->bios;
 
 	if (!bios || size < 0x49) {
-		DRM_INFO("vbios mem is null or mem size is wrong\n");
+		dev_dbg(adev->dev, "VBIOS mem is null or mem size is wrong\n");
 		return false;
 	}
 
 	if (!AMD_IS_VALID_VBIOS(bios)) {
-		DRM_INFO("BIOS signature incorrect %x %x\n", bios[0], bios[1]);
+		dev_dbg(adev->dev, "VBIOS signature incorrect %x %x\n", bios[0],
+			bios[1]);
 		return false;
 	}
 
 	bios_header_start = bios[0x48] | (bios[0x49] << 8);
 	if (!bios_header_start) {
-		DRM_INFO("Can't locate bios header\n");
+		dev_dbg(adev->dev, "Can't locate VBIOS header\n");
 		return false;
 	}
 
 	tmp = bios_header_start + 4;
 	if (size < tmp) {
-		DRM_INFO("BIOS header is broken\n");
+		dev_dbg(adev->dev, "VBIOS header is broken\n");
 		return false;
 	}
 
 	if (!memcmp(bios + tmp, "ATOM", 4) ||
 	    !memcmp(bios + tmp, "MOTA", 4)) {
-		DRM_DEBUG("ATOMBIOS detected\n");
+		dev_dbg(adev->dev, "ATOMBIOS detected\n");
 		return true;
 	}
 
@@ -119,7 +121,7 @@ static bool amdgpu_read_bios_from_vram(struct amdgpu_device *adev)
 	memcpy_fromio(adev->bios, bios, size);
 	iounmap(bios);
 
-	if (!check_atom_bios(adev->bios, size)) {
+	if (!check_atom_bios(adev, size)) {
 		kfree(adev->bios);
 		return false;
 	}
@@ -147,7 +149,7 @@ bool amdgpu_read_bios(struct amdgpu_device *adev)
 	memcpy_fromio(adev->bios, bios, size);
 	pci_unmap_rom(adev->pdev, bios);
 
-	if (!check_atom_bios(adev->bios, size)) {
+	if (!check_atom_bios(adev, size)) {
 		kfree(adev->bios);
 		return false;
 	}
@@ -187,7 +189,7 @@ static bool amdgpu_read_bios_from_rom(struct amdgpu_device *adev)
 	/* read complete BIOS */
 	amdgpu_asic_read_bios_from_rom(adev, adev->bios, len);
 
-	if (!check_atom_bios(adev->bios, len)) {
+	if (!check_atom_bios(adev, len)) {
 		kfree(adev->bios);
 		return false;
 	}
@@ -217,7 +219,7 @@ static bool amdgpu_read_platform_bios(struct amdgpu_device *adev)
 	memcpy_fromio(adev->bios, bios, romlen);
 	iounmap(bios);
 
-	if (!check_atom_bios(adev->bios, romlen))
+	if (!check_atom_bios(adev, romlen))
 		goto free_bios;
 
 	adev->bios_size = romlen;
@@ -325,7 +327,7 @@ static bool amdgpu_atrm_get_bios(struct amdgpu_device *adev)
 			break;
 	}
 
-	if (!check_atom_bios(adev->bios, size)) {
+	if (!check_atom_bios(adev, size)) {
 		kfree(adev->bios);
 		return false;
 	}
@@ -425,7 +427,7 @@ static bool amdgpu_acpi_vfct_bios(struct amdgpu_device *adev)
 					     vhdr->ImageLength,
 					     GFP_KERNEL);
 
-			if (!check_atom_bios(adev->bios, vhdr->ImageLength)) {
+			if (!check_atom_bios(adev, vhdr->ImageLength)) {
 				kfree(adev->bios);
 				return false;
 			}
-- 
2.53.0



