Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3D92C026C;
	Sat, 17 Oct 2026 16:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254374; cv=none; b=cZzSyilcEqvlJjuDC53V3jZI/4Serq/nIlNGqxibbYegnBGhRlrSua4Er5Zv5qGNmHSRwyqt2KS13hnTh0lNG2PZ7oWTrH9lQ5aF/3OuZkmdlQjg4AavfY0+AVg7Ob70hIOgtJHgpXdVWl6aS/m3mehzs0aCohEqlx4iaMVIKbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254374; c=relaxed/simple;
	bh=94OT/SxDV6rBnUARbUXTfNVje26wH8MKTwhydCO7NDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOBiMLN1yWKZp9y6H9YKlA0psJ38UMcoiYWpvBUeWn+UG6VsZlwMThRGxwobObcUimZgoAwMkev3Is7hQQDPXwawN+BJi3a55F+CRUFr7+azOnWcrSymZbd6oqfBgtPV99H7zp8CzVYhVN9GqY60eN+mF0d0vwM7R4SkZ1k+cSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F8pzRDzS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F8pzRDzS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D158E1F000C4;
	Sat, 17 Oct 2026 16:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254373;
	bh=z91phwrRWWMb41u6LzE7UWOuRruedmbS9r88sunoFII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F8pzRDzSDKN06ys2EG+3lAC0tjw8Z3HBdYyvvg0RoU+Yzr52TwdHjx/DfGLvm5M8l
	 fyWGHZbSnhakaG8l3tX2EdlqfNpW+qsTbdbICK58g+z03adIE4eKfNWMnFdqPTIfa9
	 zXBeA7GdUtsm5wWqB1qxd/OCgYWgvuJPpkhLkulw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 383/869] drm/amdgpu: Add wrapper for freeing vbios memory
Date: Sat, 17 Oct 2026 17:53:44 +0200
Message-ID: <20261017160046.931570056@linuxfoundation.org>
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

[ Upstream commit e986e89659e18ba986db044df58f165042817dc3 ]

Use bios_release wrapper to release memory allocated for vbios image and
reset the variables.

v2:
	Use the same wrapper for clean up in sw_fini (Alex Deucher)

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 65bff2661760 ("drm/amdgpu: Release VFCT ACPI table reference")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h        |  1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c   | 20 ++++++++++++++------
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |  3 +--
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
index b667da0ec68a3..06b80396c6c96 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -409,6 +409,7 @@ bool amdgpu_get_bios(struct amdgpu_device *adev);
 bool amdgpu_read_bios(struct amdgpu_device *adev);
 bool amdgpu_soc15_read_bios_from_rom(struct amdgpu_device *adev,
 				     u8 *bios, u32 length_bytes);
+void amdgpu_bios_release(struct amdgpu_device *adev);
 /*
  * Clocks
  */
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
index 53641234b9cf8..58a23bd19bf5d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
@@ -85,6 +85,13 @@ static bool check_atom_bios(struct amdgpu_device *adev, size_t size)
 	return false;
 }
 
+void amdgpu_bios_release(struct amdgpu_device *adev)
+{
+	kfree(adev->bios);
+	adev->bios = NULL;
+	adev->bios_size = 0;
+}
+
 /* If you boot an IGP board with a discrete card as the primary,
  * the IGP rom is not accessible via the rom bar as the IGP rom is
  * part of the system bios.  On boot, the system bios puts a
@@ -122,7 +129,7 @@ static bool amdgpu_read_bios_from_vram(struct amdgpu_device *adev)
 	iounmap(bios);
 
 	if (!check_atom_bios(adev, size)) {
-		kfree(adev->bios);
+		amdgpu_bios_release(adev);
 		return false;
 	}
 
@@ -150,7 +157,7 @@ bool amdgpu_read_bios(struct amdgpu_device *adev)
 	pci_unmap_rom(adev->pdev, bios);
 
 	if (!check_atom_bios(adev, size)) {
-		kfree(adev->bios);
+		amdgpu_bios_release(adev);
 		return false;
 	}
 
@@ -190,7 +197,7 @@ static bool amdgpu_read_bios_from_rom(struct amdgpu_device *adev)
 	amdgpu_asic_read_bios_from_rom(adev, adev->bios, len);
 
 	if (!check_atom_bios(adev, len)) {
-		kfree(adev->bios);
+		amdgpu_bios_release(adev);
 		return false;
 	}
 
@@ -226,7 +233,8 @@ static bool amdgpu_read_platform_bios(struct amdgpu_device *adev)
 
 	return true;
 free_bios:
-	kfree(adev->bios);
+	amdgpu_bios_release(adev);
+
 	return false;
 }
 
@@ -328,7 +336,7 @@ static bool amdgpu_atrm_get_bios(struct amdgpu_device *adev)
 	}
 
 	if (!check_atom_bios(adev, size)) {
-		kfree(adev->bios);
+		amdgpu_bios_release(adev);
 		return false;
 	}
 	adev->bios_size = size;
@@ -428,7 +436,7 @@ static bool amdgpu_acpi_vfct_bios(struct amdgpu_device *adev)
 					     GFP_KERNEL);
 
 			if (!check_atom_bios(adev, vhdr->ImageLength)) {
-				kfree(adev->bios);
+				amdgpu_bios_release(adev);
 				return false;
 			}
 			adev->bios_size = vhdr->ImageLength;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index cd05ddacd8116..3e74e8dc2e186 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4793,8 +4793,7 @@ void amdgpu_device_fini_sw(struct amdgpu_device *adev)
 	if (amdgpu_emu_mode != 1)
 		amdgpu_atombios_fini(adev);
 
-	kfree(adev->bios);
-	adev->bios = NULL;
+	amdgpu_bios_release(adev);
 
 	kfree(adev->fru_info);
 	adev->fru_info = NULL;
-- 
2.53.0



