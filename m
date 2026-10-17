Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA843C1D78;
	Sat, 17 Oct 2026 17:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257473; cv=none; b=nrQLkAB420kxt3FwDhi4sowmH+mMFwlJiVCqe6wKQr5c1kfNFMPW6NLYiMs/L3FM5IsIPXciCU0/7ApPo9mtWS3nzwUQS7FKoytCiU3tvXznxBWTDRTNu6/bqiMGz4kRPj5iVDNyJf75EAItw8fA8iVfv8b1bo0NsxyF2Pyy2Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257473; c=relaxed/simple;
	bh=Q45ZwxHcjvEuJI/NPWjtAHIFB6wudyd3Ohepy8JTmxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vE/6mHGsfVOzIbLT2HmyJfV6tqmwB6H+bpa4ddAyWILrTJge1rqx73wyAuyPNEEt9q62OaiYEb2JdkNyvuUfAf5FTRHx8P74j8sZfbXmnCc5N+WWNHm6IhQgu2mpGTy+DH9BO7XZd6nKE02JxvLi4YSKw5PQGA8LAMjKy9Tp98o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N3WbcfSy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N3WbcfSy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 963B11F000C4;
	Sat, 17 Oct 2026 17:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257472;
	bh=tXmOKo3NOCQg0S1vLy3egAyFP8HSNomHYkRhNFgzbis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N3WbcfSyw6jkpqoxauuz9W7kSvz+rXPDh4UwIzVtQg0nwWNPmc2toGoKaF5nNZP43
	 4ih7Nr0BQNl5dUE3VRk1ARAJ4Or6OKAv4CPzAueopJm9lS2ocBTgPD7p4UxVF8R3/m
	 fbtJ/c4nvnKSjgWAwtmom74piu2/jMdcU3mJ9vUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ayhan=20=C3=87i=C3=A7ek?= <ayhancicek@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 0528/1674] drm/amdgpu: make Mac FB workaround generic
Date: Sat, 17 Oct 2026 17:46:40 +0200
Message-ID: <20261017160444.655991610@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -728,20 +728,17 @@ void amdgpu_gmc_get_vbios_allocations(st
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


