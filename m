Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2710B1494DB;
	Thu,  5 Sep 2024 10:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530526; cv=none; b=BFgnZ2Tng9odG2TGC+JXn43ylD47RSEs6BBcyPRD9ACQYnCukFi5Cj/7UstN+DGXP/sPkU+owkYzcCqpsHSWPq4FmxkXwgDC/TVpYWNv63L0lb2FK7Q69Vvzp2GMywJaRHVyUV+24o5vOSX3v8xgS5/HC2ohhSmnt6213WvXMXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530526; c=relaxed/simple;
	bh=iPoUiCvBBu5xPK1+2R3BioIAkoxAc0ZnxM8sarLWFNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jzHpT0s1BKWBm9+eBoqsfk9P5POsgmdRo2BAteuFhMvw2+XRwVWZNdW+hcdNDanJqjbfKnI3a8RM5PGMHd9ztdY81bO8iaFpE8IBIv4vXGzNxwEcsLi6r+CSX6dFVhhPQc2ouaXeanHdS2lcLPFFqX01JzxQ32FfVLp39V9geZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SJUoyHgM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SJUoyHgM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3894C4CEC3;
	Thu,  5 Sep 2024 10:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530526;
	bh=iPoUiCvBBu5xPK1+2R3BioIAkoxAc0ZnxM8sarLWFNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJUoyHgMWE43lOGb8O+LGhkTFYpOffQdgptXE/308zpcQJWIT3KvnyChEqJjoLu0g
	 rxAq76XkHpgyGaVKkixw7zR3z6IqbKWINCZoaTnoFzPHVRODscGvvGdyC6M7fGSCQC
	 +o8q64KNGAnMoXoj8ILTmxWvTZYD+UYh6tnG9SA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 051/101] drm/amdgpu/pm: Fix uninitialized variable warning for smu10
Date: Thu,  5 Sep 2024 11:41:23 +0200
Message-ID: <20240905093718.134083475@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e4d524ae5a77..4f3488f4e0d0 100644
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
index 1069eaaae2f8..e4948a118475 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c
@@ -294,12 +294,12 @@ static int vega12_set_features_platform_caps(struct pp_hwmgr *hwmgr)
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
@@ -365,10 +365,16 @@ static void vega12_init_dpm_defaults(struct pp_hwmgr *hwmgr)
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
@@ -411,7 +417,11 @@ static int vega12_hwmgr_backend_init(struct pp_hwmgr *hwmgr)
 
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
index ff77a3683efd..7606db479bad 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c
@@ -329,12 +329,12 @@ static int vega20_set_features_platform_caps(struct pp_hwmgr *hwmgr)
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
@@ -405,10 +405,17 @@ static void vega20_init_dpm_defaults(struct pp_hwmgr *hwmgr)
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
@@ -428,6 +435,7 @@ static int vega20_hwmgr_backend_init(struct pp_hwmgr *hwmgr)
 {
 	struct vega20_hwmgr *data;
 	struct amdgpu_device *adev = hwmgr->adev;
+	int result;
 
 	data = kzalloc(sizeof(struct vega20_hwmgr), GFP_KERNEL);
 	if (data == NULL)
@@ -453,8 +461,11 @@ static int vega20_hwmgr_backend_init(struct pp_hwmgr *hwmgr)
 
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



