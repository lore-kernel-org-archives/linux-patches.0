Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B538820
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:53:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D7AC433D2;
	Fri, 10 Mar 2023 14:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460036;
	bh=6+blHOAYs5Wq2l2G/0aPiwl5zxSLAmqtX5CkhSmpcmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YNiQpYyPn0Qvre+xJ7yHihWbtCG857vx85UUUC0Grk7DQx5zWgS1QWSPcC7X+fGDa
	 E55fBiTYWy6EAAv43l6aaq20amfPVJAcVSFE/kscf+8xtSUVK/B2dD58irspzj+nve
	 TWtcrcL3GbfhfNSjPA4aIvUu03eDEm6dAzvZ7aNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 201/529] drm/amdgpu: fix enum odm_combine_mode mismatch
Date: Fri, 10 Mar 2023 14:35:44 +0100
Message-Id: <20230310133814.315901655@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 087bad7eb1f6945f8232f132953ecc2bda8bd38d ]

A conversion from 'bool' to 'enum odm_combine_mode' was incomplete,
and gcc warns about this with many instances of

display/dc/dml/dcn20/display_mode_vba_20.c:3899:44: warning: implicit conversion from 'enum <anonymous>' to 'enum
odm_combine_mode' [-Wenum-conversion]
 3899 |     locals->ODMCombineEnablePerState[i][k] = false;

Change the ones that we get a warning for, using the same numerical
values to leave the behavior unchanged.

Fixes: 5fc11598166d ("drm/amd/display: expand dml structs")
Link: https://lore.kernel.org/all/20201026210039.3884312-3-arnd@kernel.org/
Link: https://lore.kernel.org/all/20210927100659.1431744-1-arnd@kernel.org/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/dml/dcn20/display_mode_vba_20.c   |  8 ++++----
 .../amd/display/dc/dml/dcn20/display_mode_vba_20v2.c | 10 +++++-----
 .../amd/display/dc/dml/dcn21/display_mode_vba_21.c   | 12 ++++++------
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20.c b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20.c
index b3f0476899d32..14e7a59a9cd13 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20.c
@@ -3897,14 +3897,14 @@ void dml20_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 					mode_lib->vba.PlaneRequiredDISPCLKWithODMCombine = mode_lib->vba.PixelClock[k] / 2
 							* (1 + mode_lib->vba.DISPCLKDPPCLKDSCCLKDownSpreading / 100.0);
 
-				locals->ODMCombineEnablePerState[i][k] = false;
+				locals->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_disabled;
 				mode_lib->vba.PlaneRequiredDISPCLK = mode_lib->vba.PlaneRequiredDISPCLKWithoutODMCombine;
 				if (mode_lib->vba.ODMCapability) {
 					if (locals->PlaneRequiredDISPCLKWithoutODMCombine > mode_lib->vba.MaxDispclkRoundedDownToDFSGranularity) {
-						locals->ODMCombineEnablePerState[i][k] = true;
+						locals->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_2to1;
 						mode_lib->vba.PlaneRequiredDISPCLK = mode_lib->vba.PlaneRequiredDISPCLKWithODMCombine;
 					} else if (locals->HActive[k] > DCN20_MAX_420_IMAGE_WIDTH && locals->OutputFormat[k] == dm_420) {
-						locals->ODMCombineEnablePerState[i][k] = true;
+						locals->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_2to1;
 						mode_lib->vba.PlaneRequiredDISPCLK = mode_lib->vba.PlaneRequiredDISPCLKWithODMCombine;
 					}
 				}
@@ -3957,7 +3957,7 @@ void dml20_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 				locals->RequiredDISPCLK[i][j] = 0.0;
 				locals->DISPCLK_DPPCLK_Support[i][j] = true;
 				for (k = 0; k <= mode_lib->vba.NumberOfActivePlanes - 1; k++) {
-					locals->ODMCombineEnablePerState[i][k] = false;
+					locals->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_disabled;
 					if (locals->SwathWidthYSingleDPP[k] <= locals->MaximumSwathWidth[k]) {
 						locals->NoOfDPP[i][j][k] = 1;
 						locals->RequiredDPPCLK[i][j][k] = locals->MinDPPCLKUsingSingleDPP[k]
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20v2.c b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20v2.c
index 1bcda7eba4a6f..ee1c80366bd65 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20v2.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20v2.c
@@ -3974,17 +3974,17 @@ void dml20v2_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode
 					mode_lib->vba.PlaneRequiredDISPCLKWithODMCombine = mode_lib->vba.PixelClock[k] / 2
 							* (1 + mode_lib->vba.DISPCLKDPPCLKDSCCLKDownSpreading / 100.0);
 
-				locals->ODMCombineEnablePerState[i][k] = false;
+				locals->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_disabled;
 				mode_lib->vba.PlaneRequiredDISPCLK = mode_lib->vba.PlaneRequiredDISPCLKWithoutODMCombine;
 				if (mode_lib->vba.ODMCapability) {
 					if (locals->PlaneRequiredDISPCLKWithoutODMCombine > MaxMaxDispclkRoundedDown) {
-						locals->ODMCombineEnablePerState[i][k] = true;
+						locals->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_2to1;
 						mode_lib->vba.PlaneRequiredDISPCLK = mode_lib->vba.PlaneRequiredDISPCLKWithODMCombine;
 					} else if (locals->DSCEnabled[k] && (locals->HActive[k] > DCN20_MAX_DSC_IMAGE_WIDTH)) {
-						locals->ODMCombineEnablePerState[i][k] = true;
+						locals->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_2to1;
 						mode_lib->vba.PlaneRequiredDISPCLK = mode_lib->vba.PlaneRequiredDISPCLKWithODMCombine;
 					} else if (locals->HActive[k] > DCN20_MAX_420_IMAGE_WIDTH && locals->OutputFormat[k] == dm_420) {
-						locals->ODMCombineEnablePerState[i][k] = true;
+						locals->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_2to1;
 						mode_lib->vba.PlaneRequiredDISPCLK = mode_lib->vba.PlaneRequiredDISPCLKWithODMCombine;
 					}
 				}
@@ -4037,7 +4037,7 @@ void dml20v2_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode
 				locals->RequiredDISPCLK[i][j] = 0.0;
 				locals->DISPCLK_DPPCLK_Support[i][j] = true;
 				for (k = 0; k <= mode_lib->vba.NumberOfActivePlanes - 1; k++) {
-					locals->ODMCombineEnablePerState[i][k] = false;
+					locals->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_disabled;
 					if (locals->SwathWidthYSingleDPP[k] <= locals->MaximumSwathWidth[k]) {
 						locals->NoOfDPP[i][j][k] = 1;
 						locals->RequiredDPPCLK[i][j][k] = locals->MinDPPCLKUsingSingleDPP[k]
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_mode_vba_21.c b/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_mode_vba_21.c
index c09bca3350687..25693e62db805 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_mode_vba_21.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_mode_vba_21.c
@@ -3975,17 +3975,17 @@ void dml21_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 					mode_lib->vba.PlaneRequiredDISPCLKWithODMCombine = mode_lib->vba.PixelClock[k] / 2
 							* (1 + mode_lib->vba.DISPCLKDPPCLKDSCCLKDownSpreading / 100.0);
 
-				locals->ODMCombineEnablePerState[i][k] = false;
+				locals->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_disabled;
 				mode_lib->vba.PlaneRequiredDISPCLK = mode_lib->vba.PlaneRequiredDISPCLKWithoutODMCombine;
 				if (mode_lib->vba.ODMCapability) {
 					if (locals->PlaneRequiredDISPCLKWithoutODMCombine > MaxMaxDispclkRoundedDown) {
-						locals->ODMCombineEnablePerState[i][k] = true;
+						locals->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_2to1;
 						mode_lib->vba.PlaneRequiredDISPCLK = mode_lib->vba.PlaneRequiredDISPCLKWithODMCombine;
 					} else if (locals->DSCEnabled[k] && (locals->HActive[k] > DCN21_MAX_DSC_IMAGE_WIDTH)) {
-						locals->ODMCombineEnablePerState[i][k] = true;
+						locals->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_2to1;
 						mode_lib->vba.PlaneRequiredDISPCLK = mode_lib->vba.PlaneRequiredDISPCLKWithODMCombine;
 					} else if (locals->HActive[k] > DCN21_MAX_420_IMAGE_WIDTH && locals->OutputFormat[k] == dm_420) {
-						locals->ODMCombineEnablePerState[i][k] = true;
+						locals->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_2to1;
 						mode_lib->vba.PlaneRequiredDISPCLK = mode_lib->vba.PlaneRequiredDISPCLKWithODMCombine;
 					}
 				}
@@ -4038,7 +4038,7 @@ void dml21_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 				locals->RequiredDISPCLK[i][j] = 0.0;
 				locals->DISPCLK_DPPCLK_Support[i][j] = true;
 				for (k = 0; k <= mode_lib->vba.NumberOfActivePlanes - 1; k++) {
-					locals->ODMCombineEnablePerState[i][k] = false;
+					locals->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_disabled;
 					if (locals->SwathWidthYSingleDPP[k] <= locals->MaximumSwathWidth[k]) {
 						locals->NoOfDPP[i][j][k] = 1;
 						locals->RequiredDPPCLK[i][j][k] = locals->MinDPPCLKUsingSingleDPP[k]
@@ -5213,7 +5213,7 @@ void dml21_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 			mode_lib->vba.ODMCombineEnabled[k] =
 					locals->ODMCombineEnablePerState[mode_lib->vba.VoltageLevel][k];
 		} else {
-			mode_lib->vba.ODMCombineEnabled[k] = false;
+			mode_lib->vba.ODMCombineEnabled[k] = dm_odm_combine_mode_disabled;
 		}
 		mode_lib->vba.DSCEnabled[k] =
 				locals->RequiresDSC[mode_lib->vba.VoltageLevel][k];
-- 
2.39.2



