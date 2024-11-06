Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2091DF24A;
	Wed,  6 Nov 2024 12:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895053; cv=none; b=BIO5SYbJ6FwYtzXVeZmhUmABE3WOiknm4lemxUj8yJNCWVssNcosbzKWccOf4J0W9bqkFl4Vbzg/VOps2di+ChMO04nhH3PiA4R3vSXLp9wlPkDeHcqzUiv1Vxq5g1qfKtnBkVOaC/SQJJ1hHksdQgzE7oqehpmT4Bfi+yh81Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895053; c=relaxed/simple;
	bh=8P9/0hM8fz8HmQnfrlWrT1T9ccHEHpQMLKpEyTxE/eQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bccBm8OYuCpzXU3+f4H+OkJXU2O3bxyaBwkD2yN9lwwsMwjSfNR0AnvVYwbXWcAZ8cC9cQd4ycmHstdkzGXxcfTFfBUX2Ylq8NDhuvuOkFXitHd+NKb5SUHmfetQIipLAjOhhnYShNe81sCSEmGwjqT2+7/YAJvABpUABcvfMMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0cPUpjjY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0cPUpjjY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E5DC4CECD;
	Wed,  6 Nov 2024 12:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895053;
	bh=8P9/0hM8fz8HmQnfrlWrT1T9ccHEHpQMLKpEyTxE/eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0cPUpjjYCpcVHlCkv+xg8bszMhNYjx8Q4MNE+FjQHUNbPd4Cz+NbItMhrOr03YltZ
	 AVCvMd5hUey03wmnQbeKpPpHCbM0Sv+pbO28ORRcJpVP9AcIFVS529zcaDXR367A/n
	 VJFLTCZ7iMDTmj/awlQMiKaOak4zHQumxzUOOa50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 053/350] drm/amdgpu: properly handle vbios fake edid sizing
Date: Wed,  6 Nov 2024 12:59:41 +0100
Message-ID: <20241106120322.201641845@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
User-Agent: quilt/0.67
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 8155566a26b8d6c1dd914f06a0c652e4e2f2adf1 ]

The comment in the vbios structure says:
// = 128 means EDID length is 128 bytes, otherwise the EDID length = ucFakeEDIDLength*128

This fake edid struct has not been used in a long time, so I'm
not sure if there were actually any boards out there with a non-128 byte
EDID, but align the code with the comment.

Reviewed-by: Thomas Weißschuh <linux@weissschuh.net>
Reported-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lists.freedesktop.org/archives/amd-gfx/2024-June/109964.html
Fixes: d38ceaf99ed0 ("drm/amdgpu: add core driver (v4)")
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/amdgpu/atombios_encoders.c    | 29 ++++++++++---------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/atombios_encoders.c b/drivers/gpu/drm/amd/amdgpu/atombios_encoders.c
index 9de266a1bfbe0..251975697d69d 100644
--- a/drivers/gpu/drm/amd/amdgpu/atombios_encoders.c
+++ b/drivers/gpu/drm/amd/amdgpu/atombios_encoders.c
@@ -2095,26 +2095,29 @@ amdgpu_atombios_encoder_get_lcd_info(struct amdgpu_encoder *encoder)
 					fake_edid_record = (ATOM_FAKE_EDID_PATCH_RECORD *)record;
 					if (fake_edid_record->ucFakeEDIDLength) {
 						struct edid *edid;
-						int edid_size =
-							max((int)EDID_LENGTH, (int)fake_edid_record->ucFakeEDIDLength);
-						edid = kmalloc(edid_size, GFP_KERNEL);
+						int edid_size;
+
+						if (fake_edid_record->ucFakeEDIDLength == 128)
+							edid_size = fake_edid_record->ucFakeEDIDLength;
+						else
+							edid_size = fake_edid_record->ucFakeEDIDLength * 128;
+						edid = kmemdup(&fake_edid_record->ucFakeEDIDString[0],
+							       edid_size, GFP_KERNEL);
 						if (edid) {
-							memcpy((u8 *)edid, (u8 *)&fake_edid_record->ucFakeEDIDString[0],
-							       fake_edid_record->ucFakeEDIDLength);
-
 							if (drm_edid_is_valid(edid)) {
 								adev->mode_info.bios_hardcoded_edid = edid;
 								adev->mode_info.bios_hardcoded_edid_size = edid_size;
-							} else
+							} else {
 								kfree(edid);
+							}
 						}
+						record += struct_size(fake_edid_record,
+								      ucFakeEDIDString,
+								      edid_size);
+					} else {
+						/* empty fake edid record must be 3 bytes long */
+						record += sizeof(ATOM_FAKE_EDID_PATCH_RECORD) + 1;
 					}
-					record += fake_edid_record->ucFakeEDIDLength ?
-						  struct_size(fake_edid_record,
-							      ucFakeEDIDString,
-							      fake_edid_record->ucFakeEDIDLength) :
-						  /* empty fake edid record must be 3 bytes long */
-						  sizeof(ATOM_FAKE_EDID_PATCH_RECORD) + 1;
 					break;
 				case LCD_PANEL_RESOLUTION_RECORD_TYPE:
 					panel_res_record = (ATOM_PANEL_RESOLUTION_PATCH_RECORD *)record;
-- 
2.43.0



