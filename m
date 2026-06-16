Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E295D3BFE5A;
	Tue, 16 Jun 2026 18:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634322; cv=none; b=ZNnayPX3mediUyjn5nwe43tI8SjAND0+3J+ON2cli52wE7epdX1h/YcQiTa7TR5L/D4DYYx+foM/+hllzTjDJhaDC5523mUBjnP3AO5PClgFq4nuLHeTFrtOBuHzG4/Z4sLOI8wc/3dtpBADgY2RdTHEthFLp1hrGA8uqKlgjtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634322; c=relaxed/simple;
	bh=6y9Cu9A6xT9I7Hl45tGtUWol4l9zvafP8wD//ec+cHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GJ8hatwFg+Ue3+EnxOrLzRT/TeHYSfYnPdlkgZIRmUI9YAtOOGuRKDBmTmhVy6ggtWam5BFi11wtrZtNxwgiRdzQO3biF6BkOLMtpsrGKgo8W4yLsvLb3Tm6SKy4eyWUczNqVrgatYWRh/ubxsbSAROPTOKe99lkCIHRTaxpOW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PRvyNg5s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PRvyNg5s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94BB1F000E9;
	Tue, 16 Jun 2026 18:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634320;
	bh=fs60vhUaxI8TYxD+/Cce4056rrzxWef5WoPGC0n1bCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PRvyNg5svRUPv+XJdt6NzouQhWbyC2v0rkYWwItQdR1dbjIC2IF+/VnR+SJPfjZIN
	 3uZkMfdmpRHpQZqmngrvX6UHjUYL8RbjVtUPw5ktaVmuLNF+f8W+rC4gMVQs9BrCLn
	 JIcI1wI6kXmCybMELHGuIjatBXyPJRVsZESHYJO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 243/411] drm/amd/display: Clamp VBIOS HDMI retimer register count to array size
Date: Tue, 16 Jun 2026 20:28:01 +0530
Message-ID: <20260616145113.847619166@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1858,14 +1858,16 @@ static enum bp_result get_integrated_inf
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
@@ -1874,14 +1876,16 @@ static enum bp_result get_integrated_inf
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
@@ -1890,14 +1894,16 @@ static enum bp_result get_integrated_inf
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
@@ -1906,14 +1912,16 @@ static enum bp_result get_integrated_inf
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
@@ -2061,14 +2069,16 @@ static enum bp_result get_integrated_inf
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
@@ -2076,14 +2086,16 @@ static enum bp_result get_integrated_inf
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
@@ -2091,14 +2103,16 @@ static enum bp_result get_integrated_inf
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
@@ -2106,14 +2120,16 @@ static enum bp_result get_integrated_inf
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


