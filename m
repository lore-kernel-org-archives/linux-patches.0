Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4513B19BA;
	Sat, 17 Oct 2026 17:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259028; cv=none; b=GudDzMq0c6E2dFWdG4BTgpvOf7Xyv377ffcrOhOaeJSsNt0xQjZCcrO3mOdTeESOi3e6QQre3+f3f+9m0Ygh0mnbBEltHdZUGshazF6kr7JST/PO+CTjoN9U3/UyySkC8+woac1z5DlZ4aIzDUM8mOMBuoTK6wYPMBVL1dc3IPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259028; c=relaxed/simple;
	bh=WdGshordcFJJ7ZwHQZIdiTSybTjgwrx7r9T7BcUeGzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijVjQFaX6M8VFVDEdQHdmC4BTvKP1nGq7klwhMZa2sZbtLLY9GzuP/6R6FHSIOeRXopWROSbMyY6j89TGgvswi41mHkfKdduotZgOevscdnGmjQr0oxfZE6DtRV3TVwm8JAFph2KVtX/wSJXU9A0axvkwKej64hWUGGmrLp1/3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yeVHr+qw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yeVHr+qw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51171F000C4;
	Sat, 17 Oct 2026 17:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259027;
	bh=Tlpz+6OeeD3eQsMxBY/aDFllRgLiNHtI7zs/B6c74J4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yeVHr+qwTytpw4lzFenD/6kMWWpHmYMc8FBC+eUzxdD5LykkAYnQpU8xnnrK/CHMZ
	 xpOWdnDGCqucx48hsoFDNiPdcXXGxx8+RMFphV6nmxQaZy6zkXrOBhfYjupl3U7End
	 CobNG9eMRJMyZDYhM8DXoqf7vp3t7z3Ub9wSkT+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1078/1674] drm/amdgpu: Add wrapper for freeing vbios memory
Date: Sat, 17 Oct 2026 17:55:50 +0200
Message-ID: <20261017160458.793800706@linuxfoundation.org>
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
index 0d2f7be98dd44..84c0a051474f9 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -385,6 +385,7 @@ bool amdgpu_get_bios(struct amdgpu_device *adev);
 bool amdgpu_read_bios(struct amdgpu_device *adev);
 bool amdgpu_soc15_read_bios_from_rom(struct amdgpu_device *adev,
 				     u8 *bios, u32 length_bytes);
+void amdgpu_bios_release(struct amdgpu_device *adev);
 /*
  * Clocks
  */
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
index c907966a054c7..ad90b1dbdb905 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
@@ -84,6 +84,13 @@ static bool check_atom_bios(struct amdgpu_device *adev, size_t size)
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
@@ -120,7 +127,7 @@ static bool igp_read_bios_from_vram(struct amdgpu_device *adev)
 	iounmap(bios);
 
 	if (!check_atom_bios(adev, size)) {
-		kfree(adev->bios);
+		amdgpu_bios_release(adev);
 		return false;
 	}
 
@@ -148,7 +155,7 @@ bool amdgpu_read_bios(struct amdgpu_device *adev)
 	pci_unmap_rom(adev->pdev, bios);
 
 	if (!check_atom_bios(adev, size)) {
-		kfree(adev->bios);
+		amdgpu_bios_release(adev);
 		return false;
 	}
 
@@ -188,7 +195,7 @@ static bool amdgpu_read_bios_from_rom(struct amdgpu_device *adev)
 	amdgpu_asic_read_bios_from_rom(adev, adev->bios, len);
 
 	if (!check_atom_bios(adev, len)) {
-		kfree(adev->bios);
+		amdgpu_bios_release(adev);
 		return false;
 	}
 
@@ -224,7 +231,8 @@ static bool amdgpu_read_platform_bios(struct amdgpu_device *adev)
 
 	return true;
 free_bios:
-	kfree(adev->bios);
+	amdgpu_bios_release(adev);
+
 	return false;
 }
 
@@ -340,7 +348,7 @@ static bool amdgpu_atrm_get_bios(struct amdgpu_device *adev)
 	}
 
 	if (!check_atom_bios(adev, size)) {
-		kfree(adev->bios);
+		amdgpu_bios_release(adev);
 		return false;
 	}
 	adev->bios_size = size;
@@ -443,7 +451,7 @@ static bool amdgpu_acpi_vfct_bios(struct amdgpu_device *adev)
 					     GFP_KERNEL);
 
 			if (!check_atom_bios(adev, vhdr->ImageLength)) {
-				kfree(adev->bios);
+				amdgpu_bios_release(adev);
 				return false;
 			}
 			adev->bios_size = vhdr->ImageLength;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index ddce6df7eaf53..52eba24656c9d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4164,8 +4164,7 @@ void amdgpu_device_fini_sw(struct amdgpu_device *adev)
 	if (amdgpu_emu_mode != 1)
 		amdgpu_atombios_fini(adev);
 
-	kfree(adev->bios);
-	adev->bios = NULL;
+	amdgpu_bios_release(adev);
 
 	px = amdgpu_device_supports_px(adev_to_drm(adev));
 
-- 
2.53.0



