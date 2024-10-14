Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFF11AC45F;
	Mon, 14 Oct 2024 14:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917698; cv=none; b=ngcWvUmStdZiFs93FM3CGHM9WMGmkQa3+vKQyTHJ5FirPKn+4tWdv7RimbWct1Ibdu3dVku8LQplXyC27g58ew/ig5TnsCdMyIpl5NvewUxSjXR0ktIZPM/M8ZIFHqVdgzIJLJMS/39Npn/FDstMFwEpszeIZ/W6jNthz3YM1Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917698; c=relaxed/simple;
	bh=oJ8GYMiEJd3bL1ObGqNc/ORa/d7DnaX/T38z7XyRj/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u/Iljj6y2o50FleAESV20qW95P/V5NReU0vtbwahGcO1ZNJ4NiAlApSJOgAtpLNbAotlzBS89oMBJ9YmjH1Am76yYa8wkv1VJRa70smmKWfT1Gp2xExcRsi6HdOjte/aGHd4vtHnmkN6OdRw6tNNfmpo+FuT86D71HaBjBgpibQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a5o6DbN8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a5o6DbN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE931C4CEC3;
	Mon, 14 Oct 2024 14:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917698;
	bh=oJ8GYMiEJd3bL1ObGqNc/ORa/d7DnaX/T38z7XyRj/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a5o6DbN85GC2MwFqxbwYayXOPZGxDcOWJnLm+ni7XXmtBaPsJdI5nZ+2x4Fu6do0a
	 dT2hAT5GASYHvfpVscfdyWATQpNVQKDwZZDf5ORsGr/p5a+4HwcwKuuqMxYSqMYqse
	 Fz/wH/hiM80/kKtBI6tN3CtfBOWbWXG1lJInhB4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 107/798] drm/amdgpu: properly handle vbios fake edid sizing
Date: Mon, 14 Oct 2024 16:11:01 +0200
Message-ID: <20241014141222.131126358@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 18ae9433e463d..713b9796f0f9d 100644
--- a/drivers/gpu/drm/amd/amdgpu/atombios_encoders.c
+++ b/drivers/gpu/drm/amd/amdgpu/atombios_encoders.c
@@ -2066,26 +2066,29 @@ amdgpu_atombios_encoder_get_lcd_info(struct amdgpu_encoder *encoder)
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



