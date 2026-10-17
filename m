Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481783B7B98;
	Sat, 17 Oct 2026 17:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256447; cv=none; b=MaGC8DTLlEN68mC/W+daThFAqr8vHCvob6T/N94kdb155x49jSXmK969IvLTZAjhv7QFDk0/c3yYHfhyNMHOAy4jwCBIQc1Nh30/TOShSkzbAkIUSE67kFh7owSMJTHYf7ls5rFeGADOF5eFWjPAaq6rOvrz+9wSL8SfOpkOGgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256447; c=relaxed/simple;
	bh=AIKKHzfv5WWMou3a2wpFYE0z+o+3Fqd6/osrOYBaLAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2Q7G8qLCIGJQY9ExoqE2eMUPPFvyht/JZXh9TGc2K59d338OiVf/upezJ/654zH8mcyAuql0XHrYtF/9nU4hvJB8jicd1RhxAMdpCSrFndO1mzgz7PxDWAq+mdDHv1gjiDbdx7m9dzPRYhKCa0lwmWMZVyksjv1igWEOY3AZHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qMc367A/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qMc367A/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CFF51F000C4;
	Sat, 17 Oct 2026 17:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256446;
	bh=gDc7S0cuQouaiAJtej1OGxqykVBh97sejqMK/0txziY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qMc367A/Tp9qAH0J2tBytrV0nRcfiufU6394TROyRq98BMUJiUkzf8RZoEZanFvvH
	 si2q4uJN5ulMKShISmnb2TZTlP+zrPA8pii8hUSaDUF0r4BXgHVT2+eTqHKFt5NYC0
	 MFh+dJ2LmcSskcyDN/lQQ0FmAtELNtZrEDDTQFoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willian Oliveira <williandossantosdeoliveira287@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 0238/1674] drm/amdgpu/gfx6: fix firmware leak on teardown
Date: Sat, 17 Oct 2026 17:41:50 +0200
Message-ID: <20261017160437.243166115@linuxfoundation.org>
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
@@ -308,6 +308,14 @@ static const u32 verde_rlc_save_restore_
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
@@ -3185,6 +3193,7 @@ static int gfx_v6_0_sw_fini(void *handle
 		amdgpu_ring_fini(&adev->gfx.compute_ring[i]);
 
 	amdgpu_gfx_rlc_fini(adev);
+	gfx_v6_0_free_microcode(adev);
 
 	return 0;
 }


