Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A40944BCB8;
	Tue, 16 Jun 2026 16:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626288; cv=none; b=lAgQYF2xG+cXkaqYJZim7DWnN80dtLAzgmdzhiyLcREMbU2g6vtvu/RT5++Lp8ixLZQLe7YgodO/DFg6JVU+v3e4OuzBW5iQFp9I4hcjj/lE7nl224PHGcq0EYUUCV1Pqxlb+KFCSMPsprmeYmXtslXWX3lJ1x/2DsAJ8EkQJM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626288; c=relaxed/simple;
	bh=cixAM1oG7fxpcCBUzRwzMrlO6kbW2kXVK/+DJ5qRr1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5im0DNYL4LFD4bxg2nwYgIX91YvSNqC1NJQDOtB8BffI44hJDRhG9mtElI4hyY8TSMdPMMgF/MeoB96KQWZes8+LfkoNF3f5n8bxbIY15y58M+3GVgWvQ9x6iKxsN3Ht2xF4H1R/ssFUGz7LGueh13WPbKDcx9pOvEO2LdayIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lFuSsxGp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lFuSsxGp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6011A1F000E9;
	Tue, 16 Jun 2026 16:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626287;
	bh=ev6yvBzr3CD/5a2OqLJ+yU1OTLE9tIZLbB70wEkaZPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lFuSsxGpa35I4DpC+oEQIY9ybbM54jbJeQYkSLvC3eYTuF+JeH1eqwk+yqtoXO+Ce
	 FW4WRnPoMcCxWwud9OSM2GKKwOhPZxt62r3hIunwyvQGxcJXrj32Ck4iU3Aub9M//l
	 Rx4sB8NIRYGguTOZxWJJxcp2HE8x/2wgO3L75hNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 299/325] drm/amd/display: Clamp VBIOS HDMI retimer register count to array size
Date: Tue, 16 Jun 2026 20:31:35 +0530
Message-ID: <20260616145113.812136654@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Wentland <harry.wentland@amd.com>

commit fb0707ce00eef4e2d60c3020e1c0432739703e4a upstream.

[Why & How]
The VBIOS integrated info tables (v1_11 and v2_1) contain HdmiRegNum and
Hdmi6GRegNum fields that are used as loop bounds when copying retimer I2C
register settings into fixed-size arrays (dp*_ext_hdmi_reg_settings[9]
and dp*_ext_hdmi_6g_reg_settings[3]). These u8 fields are not validated
before use, so a malformed VBIOS can specify values up to 255, causing an
out-of-bounds heap write during driver probe.

Clamp each register count to the destination array size using min_t()
before the copy loops, in both get_integrated_info_v11() and
get_integrated_info_v2_1().

Assisted-by: GitHub Copilot:claude-opus-4.6
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5a7f0ef90195940c54b0f5bb85b87da55f038c69)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c |   48 ++++++++++++++-------
 1 file changed, 32 insertions(+), 16 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
@@ -2602,14 +2602,16 @@ static enum bp_result get_integrated_inf
 	info_v11->extdispconninfo.checksum;
 
 	info->dp0_ext_hdmi_slv_addr = info_v11->dp0_retimer_set.HdmiSlvAddr;
-	info->dp0_ext_hdmi_reg_num = info_v11->dp0_retimer_set.HdmiRegNum;
+	info->dp0_ext_hdmi_reg_num = min_t(u8, info_v11->dp0_retimer_set.HdmiRegNum,
+					    ARRAY_SIZE(info->dp0_ext_hdmi_reg_settings));
 	for (i = 0; i < info->dp0_ext_hdmi_reg_num; i++) {
 		info->dp0_ext_hdmi_reg_settings[i].i2c_reg_index =
 				info_v11->dp0_retimer_set.HdmiRegSetting[i].ucI2cRegIndex;
 		info->dp0_ext_hdmi_reg_settings[i].i2c_reg_val =
 				info_v11->dp0_retimer_set.HdmiRegSetting[i].ucI2cRegVal;
 	}
-	info->dp0_ext_hdmi_6g_reg_num = info_v11->dp0_retimer_set.Hdmi6GRegNum;
+	info->dp0_ext_hdmi_6g_reg_num = min_t(u8, info_v11->dp0_retimer_set.Hdmi6GRegNum,
+					       ARRAY_SIZE(info->dp0_ext_hdmi_6g_reg_settings));
 	for (i = 0; i < info->dp0_ext_hdmi_6g_reg_num; i++) {
 		info->dp0_ext_hdmi_6g_reg_settings[i].i2c_reg_index =
 				info_v11->dp0_retimer_set.Hdmi6GhzRegSetting[i].ucI2cRegIndex;
@@ -2618,14 +2620,16 @@ static enum bp_result get_integrated_inf
 	}
 
 	info->dp1_ext_hdmi_slv_addr = info_v11->dp1_retimer_set.HdmiSlvAddr;
-	info->dp1_ext_hdmi_reg_num = info_v11->dp1_retimer_set.HdmiRegNum;
+	info->dp1_ext_hdmi_reg_num = min_t(u8, info_v11->dp1_retimer_set.HdmiRegNum,
+					    ARRAY_SIZE(info->dp1_ext_hdmi_reg_settings));
 	for (i = 0; i < info->dp1_ext_hdmi_reg_num; i++) {
 		info->dp1_ext_hdmi_reg_settings[i].i2c_reg_index =
 				info_v11->dp1_retimer_set.HdmiRegSetting[i].ucI2cRegIndex;
 		info->dp1_ext_hdmi_reg_settings[i].i2c_reg_val =
 				info_v11->dp1_retimer_set.HdmiRegSetting[i].ucI2cRegVal;
 	}
-	info->dp1_ext_hdmi_6g_reg_num = info_v11->dp1_retimer_set.Hdmi6GRegNum;
+	info->dp1_ext_hdmi_6g_reg_num = min_t(u8, info_v11->dp1_retimer_set.Hdmi6GRegNum,
+					       ARRAY_SIZE(info->dp1_ext_hdmi_6g_reg_settings));
 	for (i = 0; i < info->dp1_ext_hdmi_6g_reg_num; i++) {
 		info->dp1_ext_hdmi_6g_reg_settings[i].i2c_reg_index =
 				info_v11->dp1_retimer_set.Hdmi6GhzRegSetting[i].ucI2cRegIndex;
@@ -2634,14 +2638,16 @@ static enum bp_result get_integrated_inf
 	}
 
 	info->dp2_ext_hdmi_slv_addr = info_v11->dp2_retimer_set.HdmiSlvAddr;
-	info->dp2_ext_hdmi_reg_num = info_v11->dp2_retimer_set.HdmiRegNum;
+	info->dp2_ext_hdmi_reg_num = min_t(u8, info_v11->dp2_retimer_set.HdmiRegNum,
+					    ARRAY_SIZE(info->dp2_ext_hdmi_reg_settings));
 	for (i = 0; i < info->dp2_ext_hdmi_reg_num; i++) {
 		info->dp2_ext_hdmi_reg_settings[i].i2c_reg_index =
 				info_v11->dp2_retimer_set.HdmiRegSetting[i].ucI2cRegIndex;
 		info->dp2_ext_hdmi_reg_settings[i].i2c_reg_val =
 				info_v11->dp2_retimer_set.HdmiRegSetting[i].ucI2cRegVal;
 	}
-	info->dp2_ext_hdmi_6g_reg_num = info_v11->dp2_retimer_set.Hdmi6GRegNum;
+	info->dp2_ext_hdmi_6g_reg_num = min_t(u8, info_v11->dp2_retimer_set.Hdmi6GRegNum,
+					       ARRAY_SIZE(info->dp2_ext_hdmi_6g_reg_settings));
 	for (i = 0; i < info->dp2_ext_hdmi_6g_reg_num; i++) {
 		info->dp2_ext_hdmi_6g_reg_settings[i].i2c_reg_index =
 				info_v11->dp2_retimer_set.Hdmi6GhzRegSetting[i].ucI2cRegIndex;
@@ -2650,14 +2656,16 @@ static enum bp_result get_integrated_inf
 	}
 
 	info->dp3_ext_hdmi_slv_addr = info_v11->dp3_retimer_set.HdmiSlvAddr;
-	info->dp3_ext_hdmi_reg_num = info_v11->dp3_retimer_set.HdmiRegNum;
+	info->dp3_ext_hdmi_reg_num = min_t(u8, info_v11->dp3_retimer_set.HdmiRegNum,
+					    ARRAY_SIZE(info->dp3_ext_hdmi_reg_settings));
 	for (i = 0; i < info->dp3_ext_hdmi_reg_num; i++) {
 		info->dp3_ext_hdmi_reg_settings[i].i2c_reg_index =
 				info_v11->dp3_retimer_set.HdmiRegSetting[i].ucI2cRegIndex;
 		info->dp3_ext_hdmi_reg_settings[i].i2c_reg_val =
 				info_v11->dp3_retimer_set.HdmiRegSetting[i].ucI2cRegVal;
 	}
-	info->dp3_ext_hdmi_6g_reg_num = info_v11->dp3_retimer_set.Hdmi6GRegNum;
+	info->dp3_ext_hdmi_6g_reg_num = min_t(u8, info_v11->dp3_retimer_set.Hdmi6GRegNum,
+					       ARRAY_SIZE(info->dp3_ext_hdmi_6g_reg_settings));
 	for (i = 0; i < info->dp3_ext_hdmi_6g_reg_num; i++) {
 		info->dp3_ext_hdmi_6g_reg_settings[i].i2c_reg_index =
 				info_v11->dp3_retimer_set.Hdmi6GhzRegSetting[i].ucI2cRegIndex;
@@ -2807,14 +2815,16 @@ static enum bp_result get_integrated_inf
 	info->ext_disp_conn_info.checksum =
 		info_v2_1->extdispconninfo.checksum;
 	info->dp0_ext_hdmi_slv_addr = info_v2_1->dp0_retimer_set.HdmiSlvAddr;
-	info->dp0_ext_hdmi_reg_num = info_v2_1->dp0_retimer_set.HdmiRegNum;
+	info->dp0_ext_hdmi_reg_num = min_t(u8, info_v2_1->dp0_retimer_set.HdmiRegNum,
+					    ARRAY_SIZE(info->dp0_ext_hdmi_reg_settings));
 	for (i = 0; i < info->dp0_ext_hdmi_reg_num; i++) {
 		info->dp0_ext_hdmi_reg_settings[i].i2c_reg_index =
 				info_v2_1->dp0_retimer_set.HdmiRegSetting[i].ucI2cRegIndex;
 		info->dp0_ext_hdmi_reg_settings[i].i2c_reg_val =
 				info_v2_1->dp0_retimer_set.HdmiRegSetting[i].ucI2cRegVal;
 	}
-	info->dp0_ext_hdmi_6g_reg_num = info_v2_1->dp0_retimer_set.Hdmi6GRegNum;
+	info->dp0_ext_hdmi_6g_reg_num = min_t(u8, info_v2_1->dp0_retimer_set.Hdmi6GRegNum,
+					       ARRAY_SIZE(info->dp0_ext_hdmi_6g_reg_settings));
 	for (i = 0; i < info->dp0_ext_hdmi_6g_reg_num; i++) {
 		info->dp0_ext_hdmi_6g_reg_settings[i].i2c_reg_index =
 				info_v2_1->dp0_retimer_set.Hdmi6GhzRegSetting[i].ucI2cRegIndex;
@@ -2822,14 +2832,16 @@ static enum bp_result get_integrated_inf
 				info_v2_1->dp0_retimer_set.Hdmi6GhzRegSetting[i].ucI2cRegVal;
 	}
 	info->dp1_ext_hdmi_slv_addr = info_v2_1->dp1_retimer_set.HdmiSlvAddr;
-	info->dp1_ext_hdmi_reg_num = info_v2_1->dp1_retimer_set.HdmiRegNum;
+	info->dp1_ext_hdmi_reg_num = min_t(u8, info_v2_1->dp1_retimer_set.HdmiRegNum,
+					    ARRAY_SIZE(info->dp1_ext_hdmi_reg_settings));
 	for (i = 0; i < info->dp1_ext_hdmi_reg_num; i++) {
 		info->dp1_ext_hdmi_reg_settings[i].i2c_reg_index =
 				info_v2_1->dp1_retimer_set.HdmiRegSetting[i].ucI2cRegIndex;
 		info->dp1_ext_hdmi_reg_settings[i].i2c_reg_val =
 				info_v2_1->dp1_retimer_set.HdmiRegSetting[i].ucI2cRegVal;
 	}
-	info->dp1_ext_hdmi_6g_reg_num = info_v2_1->dp1_retimer_set.Hdmi6GRegNum;
+	info->dp1_ext_hdmi_6g_reg_num = min_t(u8, info_v2_1->dp1_retimer_set.Hdmi6GRegNum,
+					       ARRAY_SIZE(info->dp1_ext_hdmi_6g_reg_settings));
 	for (i = 0; i < info->dp1_ext_hdmi_6g_reg_num; i++) {
 		info->dp1_ext_hdmi_6g_reg_settings[i].i2c_reg_index =
 				info_v2_1->dp1_retimer_set.Hdmi6GhzRegSetting[i].ucI2cRegIndex;
@@ -2837,14 +2849,16 @@ static enum bp_result get_integrated_inf
 				info_v2_1->dp1_retimer_set.Hdmi6GhzRegSetting[i].ucI2cRegVal;
 	}
 	info->dp2_ext_hdmi_slv_addr = info_v2_1->dp2_retimer_set.HdmiSlvAddr;
-	info->dp2_ext_hdmi_reg_num = info_v2_1->dp2_retimer_set.HdmiRegNum;
+	info->dp2_ext_hdmi_reg_num = min_t(u8, info_v2_1->dp2_retimer_set.HdmiRegNum,
+					    ARRAY_SIZE(info->dp2_ext_hdmi_reg_settings));
 	for (i = 0; i < info->dp2_ext_hdmi_reg_num; i++) {
 		info->dp2_ext_hdmi_reg_settings[i].i2c_reg_index =
 				info_v2_1->dp2_retimer_set.HdmiRegSetting[i].ucI2cRegIndex;
 		info->dp2_ext_hdmi_reg_settings[i].i2c_reg_val =
 				info_v2_1->dp2_retimer_set.HdmiRegSetting[i].ucI2cRegVal;
 	}
-	info->dp2_ext_hdmi_6g_reg_num = info_v2_1->dp2_retimer_set.Hdmi6GRegNum;
+	info->dp2_ext_hdmi_6g_reg_num = min_t(u8, info_v2_1->dp2_retimer_set.Hdmi6GRegNum,
+					       ARRAY_SIZE(info->dp2_ext_hdmi_6g_reg_settings));
 	for (i = 0; i < info->dp2_ext_hdmi_6g_reg_num; i++) {
 		info->dp2_ext_hdmi_6g_reg_settings[i].i2c_reg_index =
 				info_v2_1->dp2_retimer_set.Hdmi6GhzRegSetting[i].ucI2cRegIndex;
@@ -2852,14 +2866,16 @@ static enum bp_result get_integrated_inf
 				info_v2_1->dp2_retimer_set.Hdmi6GhzRegSetting[i].ucI2cRegVal;
 	}
 	info->dp3_ext_hdmi_slv_addr = info_v2_1->dp3_retimer_set.HdmiSlvAddr;
-	info->dp3_ext_hdmi_reg_num = info_v2_1->dp3_retimer_set.HdmiRegNum;
+	info->dp3_ext_hdmi_reg_num = min_t(u8, info_v2_1->dp3_retimer_set.HdmiRegNum,
+					    ARRAY_SIZE(info->dp3_ext_hdmi_reg_settings));
 	for (i = 0; i < info->dp3_ext_hdmi_reg_num; i++) {
 		info->dp3_ext_hdmi_reg_settings[i].i2c_reg_index =
 				info_v2_1->dp3_retimer_set.HdmiRegSetting[i].ucI2cRegIndex;
 		info->dp3_ext_hdmi_reg_settings[i].i2c_reg_val =
 				info_v2_1->dp3_retimer_set.HdmiRegSetting[i].ucI2cRegVal;
 	}
-	info->dp3_ext_hdmi_6g_reg_num = info_v2_1->dp3_retimer_set.Hdmi6GRegNum;
+	info->dp3_ext_hdmi_6g_reg_num = min_t(u8, info_v2_1->dp3_retimer_set.Hdmi6GRegNum,
+					       ARRAY_SIZE(info->dp3_ext_hdmi_6g_reg_settings));
 	for (i = 0; i < info->dp3_ext_hdmi_6g_reg_num; i++) {
 		info->dp3_ext_hdmi_6g_reg_settings[i].i2c_reg_index =
 				info_v2_1->dp3_retimer_set.Hdmi6GhzRegSetting[i].ucI2cRegIndex;


