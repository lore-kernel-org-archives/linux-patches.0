Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A946339EF01;
	Sat, 17 Oct 2026 17:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259022; cv=none; b=rhtO05u8fB/xQaX8ZIyxbLBgCLkk+VCvXYWXd48bRckWN63J3AajqKOEjPDZ8gBdXm+ogO5stHxjtRej0/5vDhhUilSolFBoZHsruHv6A5CJGSWSO3w7HowRXGoJiCrMwUlYUtkSPfWByoj9aDWI8Tk5+HV87gDW9Mt65f5ge7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259022; c=relaxed/simple;
	bh=UIXui2zLgiC3rXIo30MEZ/EODel5bNegrgZceJcxwm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TrbIZtpfffa095GUGTX1YL6HmnmT560OIe0sD1x55BD1B/QQsYGpZ1o/pCZmbylQxnXk9thii1v/KKXlXkKBaHLFgkWGOYoKfAYP8bIsrQ0S4yVWeIE1UiOvArEqtn9c5VhtrDp4f54UUAIWI/2VHJ3d8ALGPYlh7SvD5/7nKiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nUk8fWvI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nUk8fWvI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B60C1F000C4;
	Sat, 17 Oct 2026 17:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259021;
	bh=YoONrcCF1WZK4VX3wP1/l6m7UkO7T3tZCO9NfPfRgpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nUk8fWvIlha2bckEWB1akf8U40ODkFusQ7DKE3WLgE1erS4gr5cod7XgJS9F19Ktk
	 RG/1+YTkeohhHyrfM1JHS2EeG6IzH/6Ya6wSU0n13kZA+ZjxxBFDzrtSHX/tzXucyM
	 N7rCnvtWiObjCQR+QDpeNl8FJ6sQO+8eHfshpNZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1077/1674] drm/amdgpu: Use dbg level for VBIOS check messages
Date: Sat, 17 Oct 2026 17:55:49 +0200
Message-ID: <20261017160458.768416813@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 367787653bc08..c907966a054c7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
@@ -47,35 +47,37 @@
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
 
@@ -117,7 +119,7 @@ static bool igp_read_bios_from_vram(struct amdgpu_device *adev)
 	memcpy_fromio(adev->bios, bios, size);
 	iounmap(bios);
 
-	if (!check_atom_bios(adev->bios, size)) {
+	if (!check_atom_bios(adev, size)) {
 		kfree(adev->bios);
 		return false;
 	}
@@ -145,7 +147,7 @@ bool amdgpu_read_bios(struct amdgpu_device *adev)
 	memcpy_fromio(adev->bios, bios, size);
 	pci_unmap_rom(adev->pdev, bios);
 
-	if (!check_atom_bios(adev->bios, size)) {
+	if (!check_atom_bios(adev, size)) {
 		kfree(adev->bios);
 		return false;
 	}
@@ -185,7 +187,7 @@ static bool amdgpu_read_bios_from_rom(struct amdgpu_device *adev)
 	/* read complete BIOS */
 	amdgpu_asic_read_bios_from_rom(adev, adev->bios, len);
 
-	if (!check_atom_bios(adev->bios, len)) {
+	if (!check_atom_bios(adev, len)) {
 		kfree(adev->bios);
 		return false;
 	}
@@ -215,7 +217,7 @@ static bool amdgpu_read_platform_bios(struct amdgpu_device *adev)
 	memcpy_fromio(adev->bios, bios, romlen);
 	iounmap(bios);
 
-	if (!check_atom_bios(adev->bios, romlen))
+	if (!check_atom_bios(adev, romlen))
 		goto free_bios;
 
 	adev->bios_size = romlen;
@@ -337,7 +339,7 @@ static bool amdgpu_atrm_get_bios(struct amdgpu_device *adev)
 			break;
 	}
 
-	if (!check_atom_bios(adev->bios, size)) {
+	if (!check_atom_bios(adev, size)) {
 		kfree(adev->bios);
 		return false;
 	}
@@ -440,7 +442,7 @@ static bool amdgpu_acpi_vfct_bios(struct amdgpu_device *adev)
 					     vhdr->ImageLength,
 					     GFP_KERNEL);
 
-			if (!check_atom_bios(adev->bios, vhdr->ImageLength)) {
+			if (!check_atom_bios(adev, vhdr->ImageLength)) {
 				kfree(adev->bios);
 				return false;
 			}
-- 
2.53.0



