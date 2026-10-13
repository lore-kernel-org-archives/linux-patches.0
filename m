Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AAFF4F3937;
	Tue, 13 Oct 2026 11:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892339; cv=none; b=QG5V7vVr37DlglxAkFT1E/p1Sfdq7YhgHm8qxb1yYfzyllFeU8ck0U45SNAQOtXguL3cDg9RvnWidboMCI1dOs1O8XykMlqVFX69x8/m/47s6HEk67WNE0eKThuv4XIO3LHVpVysEajaMZHLm/R+YbuM3biO0iMWfsPyaKyURT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892339; c=relaxed/simple;
	bh=UgsgKVhxJiJKaZmPCczgd6nX+Z4eo8uktpcBQ68T4Q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CDM0hYib5Ob9UgMXRvbEx/YkMSaUd3ci8tf+jz2ZDPj3bKRj1RxuhoO2MDhJrdxs+gOk9V967EDrADkQkjwuIrCotC1kS35GdGURk2pwAEUNcFqdfGF6oERXl87fLoIVGqavlASTNaXXT0F96mh8Ejy3TDVu0a/jX7+/935Kfn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I4VNbPkN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I4VNbPkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80E11F00893;
	Tue, 13 Oct 2026 11:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892338;
	bh=EmeS/2Bn/5/M2JwYn9/e8ZHaNFOljDD33z9mFuQZ0dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I4VNbPkN1lt01mjRu7uXGBLXkiqCAhkVIXAb6Y92F1TvsoM/ltD6us3t/zlZIaF2R
	 o+mRQ7f5zOMR4FNnjuFTmWqzlHbZqku0zbxK4y8DMnG3GBEF2g6MhSpenjDKwG87af
	 PI+O3FZnECZxS/vJQN1obJ6T8CirtJoAoxjQj/jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ayhan=20=C3=87i=C3=A7ek?= <ayhancicek@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 141/281] drm/amdgpu: make Mac FB workaround generic
Date: Tue, 13 Oct 2026 13:37:37 +0200
Message-ID: <20261013112858.579887026@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit c7f44ec5c4ec760e74351f1843dcb8322f67cbf6 upstream.

Rather than adding a case of every chip where this is seen
just check if the FB is at 0 and the ssid is apple.  This
should cover all chips which fall into this case.

Tested-by: Ayhan Çiçek <ayhancicek@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c54e4d10507722398dc90cf3c532e50b86cf425a)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -1089,20 +1089,17 @@ void amdgpu_gmc_init_vga_resv_regions(st
 	case CHIP_RENOIR:
 		adev->mman.keep_stolen_vga_memory = true;
 		break;
-	case CHIP_POLARIS10:
-	case CHIP_POLARIS11:
-	case CHIP_POLARIS12:
-		/* MacBookPros with switchable graphics put VRAM at 0 when
-		 * the iGPU is enabled which results in cursor issues if
-		 * the cursor ends up at 0.  Reserve vram at 0 in that case.
-		 */
-		if (adev->gmc.vram_start == 0)
-			adev->mman.keep_stolen_vga_memory = true;
-		break;
 	default:
 		adev->mman.keep_stolen_vga_memory = false;
 		break;
 	}
+	/* MacBookPros with switchable graphics put VRAM at 0 when
+	 * the iGPU is enabled which results in cursor issues if
+	 * the cursor ends up at 0.  Reserve vram at 0 in that case.
+	 */
+	if ((adev->pdev->subsystem_vendor == PCI_VENDOR_ID_APPLE) &&
+	    (adev->gmc.vram_start == 0))
+		adev->mman.keep_stolen_vga_memory = true;
 
 	if (amdgpu_sriov_vf(adev) ||
 	    !amdgpu_device_has_display_hardware(adev)) {


