Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2383533B6C4;
	Sat, 30 May 2026 17:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161953; cv=none; b=f7LNavWiNB1FGf50zha0I3ttD96pnd1yWFg+x5qQy3V5cKnH+2nWr2QU+L4TqaE0/y/2XwbC2+kQ5R1J2A1SeinPSrGaVp59sQdm5aGfvUO1cmJvXnZxEBu6FLLwtJLZLeZjkEAA6rIySI5P5L88+afNd0d2stY6XW6sj6t7zlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161953; c=relaxed/simple;
	bh=hZwTuflw3WD6kU/xXv9ZkmY00poHFeQPM6x806CEbRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fLDKPDWy8DUFuL69J3Sbgw+bMni8Qh9qF2h4D9K1g2pSO/oBXqmYM52e5tXMf5n+gxFL5LkjtWelCVvW7dAeHOC9yAGOe8V9xiqiK+UXSLdj1oi7itmkbCAAHDDudIwz7ikBXkJVNOr//eNmMPcnHWjOsaANyyo2fYPi+cuC79I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tw7PzEB1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tw7PzEB1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CF51F00893;
	Sat, 30 May 2026 17:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161952;
	bh=2D3gQCKRQjwSyA7WJhBQEr4an1X+Eet4YmUTf/2wmMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tw7PzEB1ehlgOkfxCHAhQfSGDJga8Dhjf1cPBtoPRBmXNjOtwxcjO8cUhqiR0l0KX
	 7IPQWCe1d64q0qw1A0IYSbhAW27Q1VEn/A/LKWjNOHLRUZJ56DO9cJSS7v+NYhp98h
	 0LY0JXCSiGPBE/cvA127j9ePNqj642kI6rnW8Grc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 777/969] drm/amd/display: Read EDID from VBIOS embedded panel info
Date: Sat, 30 May 2026 18:05:01 +0200
Message-ID: <20260530160322.046472555@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 9ea16f64189bf7b6ba50fc7f0325b3c1f836d105 ]

Some board manufacturers hardcode the EDID for the embedded
panel in the VBIOS. This EDID should be used when the panel
doesn't have a DDC.

For reference, see the legacy non-DC display code:
amdgpu_atombios_encoder_get_lcd_info()

This is necessary to support embedded connectors without DDC.

Fixes: 4562236b3bc0 ("drm/amd/dc: Add dc display driver (v2)")
Link: https://gitlab.freedesktop.org/drm/amd/-/work_items/5192
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit eb105e63b474c11ef6a84a1c6b18100d851ff364)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/bios/bios_parser.c | 62 +++++++++++++++++++
 .../display/include/grph_object_ctrl_defs.h   |  4 ++
 2 files changed, 66 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/bios/bios_parser.c b/drivers/gpu/drm/amd/display/dc/bios/bios_parser.c
index 0f686e363d308..d8982aca8ef68 100644
--- a/drivers/gpu/drm/amd/display/dc/bios/bios_parser.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/bios_parser.c
@@ -1215,6 +1215,60 @@ static enum bp_result bios_parser_get_embedded_panel_info(
 	return BP_RESULT_FAILURE;
 }
 
+static enum bp_result get_embedded_panel_extra_info(
+	struct bios_parser *bp,
+	struct embedded_panel_info *info,
+	const uint32_t table_offset)
+{
+	uint8_t *record = bios_get_image(&bp->base, table_offset, 1);
+	ATOM_PANEL_RESOLUTION_PATCH_RECORD *panel_res_record;
+	ATOM_FAKE_EDID_PATCH_RECORD *fake_edid_record;
+
+	while (*record != ATOM_RECORD_END_TYPE) {
+		switch (*record) {
+		case LCD_MODE_PATCH_RECORD_MODE_TYPE:
+			record += sizeof(ATOM_PATCH_RECORD_MODE);
+			break;
+		case LCD_RTS_RECORD_TYPE:
+			record += sizeof(ATOM_LCD_RTS_RECORD);
+			break;
+		case LCD_CAP_RECORD_TYPE:
+			record += sizeof(ATOM_LCD_MODE_CONTROL_CAP);
+			break;
+		case LCD_FAKE_EDID_PATCH_RECORD_TYPE:
+			fake_edid_record = (ATOM_FAKE_EDID_PATCH_RECORD *)record;
+			if (fake_edid_record->ucFakeEDIDLength) {
+				if (fake_edid_record->ucFakeEDIDLength == 128)
+					info->fake_edid_size =
+						fake_edid_record->ucFakeEDIDLength;
+				else
+					info->fake_edid_size =
+						fake_edid_record->ucFakeEDIDLength * 128;
+
+				info->fake_edid = fake_edid_record->ucFakeEDIDString;
+
+				record += struct_size(fake_edid_record,
+						      ucFakeEDIDString,
+						      info->fake_edid_size);
+			} else {
+				/* empty fake edid record must be 3 bytes long */
+				record += sizeof(ATOM_FAKE_EDID_PATCH_RECORD) + 1;
+			}
+			break;
+		case LCD_PANEL_RESOLUTION_RECORD_TYPE:
+			panel_res_record = (ATOM_PANEL_RESOLUTION_PATCH_RECORD *)record;
+			info->panel_width_mm = panel_res_record->usHSize;
+			info->panel_height_mm = panel_res_record->usVSize;
+			record += sizeof(ATOM_PANEL_RESOLUTION_PATCH_RECORD);
+			break;
+		default:
+			return BP_RESULT_BADBIOSTABLE;
+		}
+	}
+
+	return BP_RESULT_OK;
+}
+
 static enum bp_result get_embedded_panel_info_v1_2(
 	struct bios_parser *bp,
 	struct embedded_panel_info *info)
@@ -1331,6 +1385,10 @@ static enum bp_result get_embedded_panel_info_v1_2(
 	if (ATOM_PANEL_MISC_API_ENABLED & lvds->ucLVDS_Misc)
 		info->lcd_timing.misc_info.API_ENABLED = true;
 
+	if (lvds->usExtInfoTableOffset)
+		return get_embedded_panel_extra_info(bp, info,
+			le16_to_cpu(lvds->usExtInfoTableOffset) + DATA_TABLES(LCD_Info));
+
 	return BP_RESULT_OK;
 }
 
@@ -1456,6 +1514,10 @@ static enum bp_result get_embedded_panel_info_v1_3(
 			(uint32_t) (ATOM_PANEL_MISC_V13_GREY_LEVEL &
 				lvds->ucLCD_Misc) >> ATOM_PANEL_MISC_V13_GREY_LEVEL_SHIFT;
 
+	if (lvds->usExtInfoTableOffset)
+		return get_embedded_panel_extra_info(bp, info,
+			le16_to_cpu(lvds->usExtInfoTableOffset) + DATA_TABLES(LCD_Info));
+
 	return BP_RESULT_OK;
 }
 
diff --git a/drivers/gpu/drm/amd/display/include/grph_object_ctrl_defs.h b/drivers/gpu/drm/amd/display/include/grph_object_ctrl_defs.h
index 813463ffe15c5..8e776c90d21bf 100644
--- a/drivers/gpu/drm/amd/display/include/grph_object_ctrl_defs.h
+++ b/drivers/gpu/drm/amd/display/include/grph_object_ctrl_defs.h
@@ -153,6 +153,10 @@ struct embedded_panel_info {
 	uint32_t drr_enabled;
 	uint32_t min_drr_refresh_rate;
 	bool realtek_eDPToLVDS;
+	uint16_t panel_width_mm;
+	uint16_t panel_height_mm;
+	uint16_t fake_edid_size;
+	const uint8_t *fake_edid;
 };
 
 struct dc_firmware_info {
-- 
2.53.0



