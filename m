Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1487198A1B;
	Thu,  5 Sep 2024 09:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529596; cv=none; b=bLF7HRGZ/Q7EIBFNOXm8/F/rdZjUCTP7zItk7+bb9qMJBwuhasPEsFuALeXX8ru2GVp67pHpogWZ73IDrVjpjM8+q10G+M3VSzaSeuezp0cHunMRdaMIJ6Ir5l1RFFfGplDhsSPpb6AnkStOIMO8jlwjwxvGwBCwHgMAGODYtp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529596; c=relaxed/simple;
	bh=eqTFG9PaLqBDGRL8kJbchvSof+0DbPqE3vStkWAOFIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k//JSonPOivkse4jk/+G1uS8zzDskEF3sjd8JwI5UBGYAD19DReNg3yrQsLA1+OLtjiYQW1DMBpsAR99k2G2m68QU+ye/i+WnnKlR3xuUrv/HDn1aruelctLXIlHExwTdzECEkDuMQoOIfIDpyLoPStODubt7YyehNMsIbUxOZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OyEUv2yy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OyEUv2yy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1108AC4CEC3;
	Thu,  5 Sep 2024 09:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529596;
	bh=eqTFG9PaLqBDGRL8kJbchvSof+0DbPqE3vStkWAOFIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OyEUv2yyoNNvYdgCrfUGPJ4FYd+SC916yAsO4nLxzgfjttyKqaJ3yWhuMIsQxFIvl
	 xx5FHSc4X1tCixr0iY2cVzplyeORbcBCstOmWcsRAKRV2v0ttb4JkLg2pLXhXAuU3C
	 NnImilQbRgQ7PS6A+4Se75LBayDyse0tFvQoz2rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 083/184] drm/amdgpu/pm: Fix uninitialized variable warning for smu10
Date: Thu,  5 Sep 2024 11:39:56 +0200
Message-ID: <20240905093735.483131488@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Jun <Jun.Ma2@amd.com>

[ Upstream commit 336c8f558d596699d3d9814a45600139b2f23f27 ]

Check return value of smum_send_msg_to_smc to fix
uninitialized variable varning

Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c  | 21 +++++++++++++----
 .../drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c | 20 ++++++++++++----
 .../drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c | 23 ++++++++++++++-----
 3 files changed, 48 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c
index 0b181bc8931c..f62381b189ad 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c
@@ -1554,7 +1554,10 @@ static int smu10_set_fine_grain_clk_vol(struct pp_hwmgr *hwmgr,
 		}
 
 		if (input[0] == 0) {
-			smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetMinGfxclkFrequency, &min_freq);
+			ret = smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetMinGfxclkFrequency, &min_freq);
+			if (ret)
+				return ret;
+
 			if (input[1] < min_freq) {
 				pr_err("Fine grain setting minimum sclk (%ld) MHz is less than the minimum allowed (%d) MHz\n",
 					input[1], min_freq);
@@ -1562,7 +1565,10 @@ static int smu10_set_fine_grain_clk_vol(struct pp_hwmgr *hwmgr,
 			}
 			smu10_data->gfx_actual_soft_min_freq = input[1];
 		} else if (input[0] == 1) {
-			smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetMaxGfxclkFrequency, &max_freq);
+			ret = smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetMaxGfxclkFrequency, &max_freq);
+			if (ret)
+				return ret;
+
 			if (input[1] > max_freq) {
 				pr_err("Fine grain setting maximum sclk (%ld) MHz is greater than the maximum allowed (%d) MHz\n",
 					input[1], max_freq);
@@ -1577,10 +1583,15 @@ static int smu10_set_fine_grain_clk_vol(struct pp_hwmgr *hwmgr,
 			pr_err("Input parameter number not correct\n");
 			return -EINVAL;
 		}
-		smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetMinGfxclkFrequency, &min_freq);
-		smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetMaxGfxclkFrequency, &max_freq);
-
+		ret = smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetMinGfxclkFrequency, &min_freq);
+		if (ret)
+			return ret;
 		smu10_data->gfx_actual_soft_min_freq = min_freq;
+
+		ret = smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetMaxGfxclkFrequency, &max_freq);
+		if (ret)
+			return ret;
+
 		smu10_data->gfx_actual_soft_max_freq = max_freq;
 	} else if (type == PP_OD_COMMIT_DPM_TABLE) {
 		if (size != 0) {
diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c
index c223e3a6bfca..10fd4e9f016c 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c
@@ -293,12 +293,12 @@ static int vega12_set_features_platform_caps(struct pp_hwmgr *hwmgr)
 	return 0;
 }
 
-static void vega12_init_dpm_defaults(struct pp_hwmgr *hwmgr)
+static int vega12_init_dpm_defaults(struct pp_hwmgr *hwmgr)
 {
 	struct vega12_hwmgr *data = (struct vega12_hwmgr *)(hwmgr->backend);
 	struct amdgpu_device *adev = hwmgr->adev;
 	uint32_t top32, bottom32;
-	int i;
+	int i, ret;
 
 	data->smu_features[GNLD_DPM_PREFETCHER].smu_feature_id =
 			FEATURE_DPM_PREFETCHER_BIT;
@@ -364,10 +364,16 @@ static void vega12_init_dpm_defaults(struct pp_hwmgr *hwmgr)
 	}
 
 	/* Get the SN to turn into a Unique ID */
-	smum_send_msg_to_smc(hwmgr, PPSMC_MSG_ReadSerialNumTop32, &top32);
-	smum_send_msg_to_smc(hwmgr, PPSMC_MSG_ReadSerialNumBottom32, &bottom32);
+	ret = smum_send_msg_to_smc(hwmgr, PPSMC_MSG_ReadSerialNumTop32, &top32);
+	if (ret)
+		return ret;
+	ret = smum_send_msg_to_smc(hwmgr, PPSMC_MSG_ReadSerialNumBottom32, &bottom32);
+	if (ret)
+		return ret;
 
 	adev->unique_id = ((uint64_t)bottom32 << 32) | top32;
+
+	return 0;
 }
 
 static int vega12_set_private_data_based_on_pptable(struct pp_hwmgr *hwmgr)
@@ -410,7 +416,11 @@ static int vega12_hwmgr_backend_init(struct pp_hwmgr *hwmgr)
 
 	vega12_set_features_platform_caps(hwmgr);
 
-	vega12_init_dpm_defaults(hwmgr);
+	result = vega12_init_dpm_defaults(hwmgr);
+	if (result) {
+		pr_err("%s failed\n", __func__);
+		return result;
+	}
 
 	/* Parse pptable data read from VBIOS */
 	vega12_set_private_data_based_on_pptable(hwmgr);
diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c
index f9efb0bad807..bf1b829f9d68 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c
@@ -328,12 +328,12 @@ static int vega20_set_features_platform_caps(struct pp_hwmgr *hwmgr)
 	return 0;
 }
 
-static void vega20_init_dpm_defaults(struct pp_hwmgr *hwmgr)
+static int vega20_init_dpm_defaults(struct pp_hwmgr *hwmgr)
 {
 	struct vega20_hwmgr *data = (struct vega20_hwmgr *)(hwmgr->backend);
 	struct amdgpu_device *adev = hwmgr->adev;
 	uint32_t top32, bottom32;
-	int i;
+	int i, ret;
 
 	data->smu_features[GNLD_DPM_PREFETCHER].smu_feature_id =
 			FEATURE_DPM_PREFETCHER_BIT;
@@ -404,10 +404,17 @@ static void vega20_init_dpm_defaults(struct pp_hwmgr *hwmgr)
 	}
 
 	/* Get the SN to turn into a Unique ID */
-	smum_send_msg_to_smc(hwmgr, PPSMC_MSG_ReadSerialNumTop32, &top32);
-	smum_send_msg_to_smc(hwmgr, PPSMC_MSG_ReadSerialNumBottom32, &bottom32);
+	ret = smum_send_msg_to_smc(hwmgr, PPSMC_MSG_ReadSerialNumTop32, &top32);
+	if (ret)
+		return ret;
+
+	ret = smum_send_msg_to_smc(hwmgr, PPSMC_MSG_ReadSerialNumBottom32, &bottom32);
+	if (ret)
+		return ret;
 
 	adev->unique_id = ((uint64_t)bottom32 << 32) | top32;
+
+	return 0;
 }
 
 static int vega20_set_private_data_based_on_pptable(struct pp_hwmgr *hwmgr)
@@ -427,6 +434,7 @@ static int vega20_hwmgr_backend_init(struct pp_hwmgr *hwmgr)
 {
 	struct vega20_hwmgr *data;
 	struct amdgpu_device *adev = hwmgr->adev;
+	int result;
 
 	data = kzalloc(sizeof(struct vega20_hwmgr), GFP_KERNEL);
 	if (data == NULL)
@@ -452,8 +460,11 @@ static int vega20_hwmgr_backend_init(struct pp_hwmgr *hwmgr)
 
 	vega20_set_features_platform_caps(hwmgr);
 
-	vega20_init_dpm_defaults(hwmgr);
-
+	result = vega20_init_dpm_defaults(hwmgr);
+	if (result) {
+		pr_err("%s failed\n", __func__);
+		return result;
+	}
 	/* Parse pptable data read from VBIOS */
 	vega20_set_private_data_based_on_pptable(hwmgr);
 
-- 
2.43.0



