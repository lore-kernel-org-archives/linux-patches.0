Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D70438011;
	Fri,  9 Oct 2026 14:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556447; cv=none; b=agFKS3XFvbWvgxvxYP70Hc8TCT6lQ1oqE9VOq0qBQ1yJ9KBHo69oAGANF5+da1TrRQJzfEVdoNvDaQY7IkVUkIFuC6Z9q+3AcVrRiywh0XS7C/PaygU8Uk99fcue3+4ujTE4/lejVTdjlKiP3gToTUNZFpeh1krxgKLHqvLOxgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556447; c=relaxed/simple;
	bh=6YUJIRPZiBHOuh6G32ZF/QazW0oQOPCQsBKjBYDGqTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elwYGgv3nRiebdtmFPCYrm91/GKEiHUh2wNvOBhjdQ7exlacdGsjGNI/DcneXacFuuQ89EuXJBT8SnBZUgpWYYvuW6EgXZcbamGYeMM/bMpt68fxy3uDzS43o1jYwwfOyvT0pAkJi0tiB90DnIN5NspSABHPxRlsXxwK+eEE0kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b75pVIMe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b75pVIMe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B521F00893;
	Fri,  9 Oct 2026 14:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556444;
	bh=TgKXsRzZN7VJtRc5wl9e+If+KSDOL/5J55nk26NRzOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b75pVIMeBP2reqhM0YNxR4iNXodpha4jhc4L4Xw4u993GuFIRCPtShsSFoxbk4Ucd
	 ub2C5OnKyY9fnFPeWzJo9RH8MqGdk6FZl48jjeY1jonXCBNC+FUezMPYOio8t36Rr8
	 ARrxZarz9/29MAGEGCxoWTe2Z+wrcwsRJdaRWNCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willian Oliveira <williandossantosdeoliveira287@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 177/428] drm/amdgpu/gfx6: fix firmware leak on teardown
Date: Fri,  9 Oct 2026 16:08:34 +0200
Message-ID: <20261009140950.037780751@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

From: Willian Oliveira <williandossantosdeoliveira287@gmail.com>

commit cc172e177795c5f87bc2d71768d077e1c10633e8 upstream.

The firmware requested in gfx_v6_0_init_microcode() is not released
when the GFX block is torn down, leaking the firmware resources.

Add gfx_v6_0_free_microcode() and call it from gfx_v6_0_sw_fini()
to release the PFP, ME, CE and RLC firmware.

Signed-off-by: Willian Oliveira <williandossantosdeoliveira287@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 386e81346f95ab0be5a82c5535de932e7a456924)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
@@ -322,6 +322,14 @@ static const u32 verde_rlc_save_restore_
 	0x00000000
 };
 
+static void gfx_v6_0_free_microcode(struct amdgpu_device *adev)
+{
+	amdgpu_ucode_release(&adev->gfx.pfp_fw);
+	amdgpu_ucode_release(&adev->gfx.me_fw);
+	amdgpu_ucode_release(&adev->gfx.ce_fw);
+	amdgpu_ucode_release(&adev->gfx.rlc_fw);
+}
+
 static int gfx_v6_0_init_microcode(struct amdgpu_device *adev)
 {
 	const char *chip_name;
@@ -3187,6 +3195,7 @@ static int gfx_v6_0_sw_fini(struct amdgp
 		amdgpu_ring_fini(&adev->gfx.compute_ring[i]);
 
 	amdgpu_gfx_rlc_fini(adev);
+	gfx_v6_0_free_microcode(adev);
 
 	return 0;
 }


