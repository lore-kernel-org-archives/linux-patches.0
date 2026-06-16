Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288B9477982;
	Tue, 16 Jun 2026 17:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631989; cv=none; b=geDfCoRaZ8u5CBLckDK+br5aAVe7/M9YRBQGuFsnZaX0wnSvVvTURem2Ul3iwdpMtwpttv3tejq/sQVR/VPetheDPy3gpzDJp/tQsWw1GJLwCmNeVO4CHvJxDorV9jrIDgxY5g0y3+KmCvuuN4jx8PMhANqTcKO75acTTcTmSWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631989; c=relaxed/simple;
	bh=4qnHNHJtrkuQgoKHsQGaZRlNbCO1aMC/ovcKn7iTbrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGatrqcGN1MZeukT+V4T0mzIfZi9T2C24aggq8N/R0bmT2HrKgSCMoxivrpH/R35pLXsBmLjMCdXc4f1E1nMtZkYiFnYAXKy+94joHfX3f9FNiPHZ/DhpHuW2Z6/T7prZdySiTqpy5GlZQ7A7VXUuzVNSS0cAPV7hic1ELP2bMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZOV9kJF+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZOV9kJF+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3BDA1F000E9;
	Tue, 16 Jun 2026 17:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631983;
	bh=5yyC6QA5jVf++XKu40mxwzu78yz8z0QNQz97jN088hY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZOV9kJF+h7/F5aib4jDFmmanFsY1vP839/T1w8hjYoFBFhFpVnYHzCfivWaxZj3nY
	 kmdARwRFQF8IE0Oa3iBgDfaSRZfnNklkw7Q6vyIIj3MiwFFQZ+GvA/dhjNz4/4BHZP
	 R8dthGK/bkPNX/e6S/UyVXXc86XGfLdCIQiw6dno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 324/522] drm/amd/display: Clamp VBIOS HDMI retimer register count to array size
Date: Tue, 16 Jun 2026 20:27:51 +0530
Message-ID: <20260616145141.001615970@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2520,14 +2520,16 @@ static enum bp_result get_integrated_inf
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
@@ -2536,14 +2538,16 @@ static enum bp_result get_integrated_inf
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
@@ -2552,14 +2556,16 @@ static enum bp_result get_integrated_inf
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
@@ -2568,14 +2574,16 @@ static enum bp_result get_integrated_inf
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
@@ -2725,14 +2733,16 @@ static enum bp_result get_integrated_inf
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
@@ -2740,14 +2750,16 @@ static enum bp_result get_integrated_inf
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
@@ -2755,14 +2767,16 @@ static enum bp_result get_integrated_inf
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
@@ -2770,14 +2784,16 @@ static enum bp_result get_integrated_inf
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


