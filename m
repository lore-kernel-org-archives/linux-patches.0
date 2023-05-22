Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61684171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:38:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD76BC433D2;
	Mon, 22 May 2023 19:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784331;
	bh=920YigxSQgSTO68+ysIQyVPKijg5L+xR+QycO5SWmPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w4H1/uRFqlUjkaaXKjsrcmWXOIogER0EWbWG6rI7Kd8EvCrpuiHc6n5sIlVtE+RV/
	 k+WujMEgG947wHJ6lfa5N7yDjHydONoMcVMd9bTX7iPnfbVydZ0SwdGLvuXxK8p9ty
	 r0IC5S+n4yAANLdhr6ZbWVpDRgEXIqvJ9iu3eJOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
	Qingqing Zhuo <qingqing.zhuo@amd.com>,
	Paul Hsieh <Paul.Hsieh@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 047/364] drm/amd/display: Correct DML calculation to align HW formula
Date: Mon, 22 May 2023 20:05:52 +0100
Message-Id: <20230522190413.996865227@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paul Hsieh <Paul.Hsieh@amd.com>

[ Upstream commit 26a9f53198c955b15161da48cdb51041a38d5325 ]

[Why]
In 2560x1440@240p eDP panel, some use cases will enable MPC
combine with RGB MPO then underflow happened. This case is
not allowed from HW formula. 

[How]
Correct eDP, DP and DP2 output bpp calculation to align HW
formula.

Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Paul Hsieh <Paul.Hsieh@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dc/dml/dcn31/display_mode_vba_31.c        | 298 ++++++++++++------
 .../dc/dml/dcn314/display_mode_vba_314.c      | 298 ++++++++++++------
 2 files changed, 392 insertions(+), 204 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn31/display_mode_vba_31.c b/drivers/gpu/drm/amd/display/dc/dml/dcn31/display_mode_vba_31.c
index 2b57f5b2362a4..536a636245950 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn31/display_mode_vba_31.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn31/display_mode_vba_31.c
@@ -4307,11 +4307,11 @@ void dml31_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 							v->AudioSampleRate[k],
 							v->AudioSampleLayout[k],
 							v->ODMCombineEnablePerState[i][k]);
-				} else if (v->Output[k] == dm_dp || v->Output[k] == dm_edp) {
+				} else if (v->Output[k] == dm_dp || v->Output[k] == dm_edp || v->Output[k] == dm_dp2p0) {
 					if (v->DSCEnable[k] == true) {
 						v->RequiresDSC[i][k] = true;
 						v->LinkDSCEnable = true;
-						if (v->Output[k] == dm_dp) {
+						if (v->Output[k] == dm_dp || v->Output[k] == dm_dp2p0) {
 							v->RequiresFEC[i][k] = true;
 						} else {
 							v->RequiresFEC[i][k] = false;
@@ -4319,107 +4319,201 @@ void dml31_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 					} else {
 						v->RequiresDSC[i][k] = false;
 						v->LinkDSCEnable = false;
-						v->RequiresFEC[i][k] = false;
-					}
-
-					v->Outbpp = BPP_INVALID;
-					if (v->PHYCLKPerState[i] >= 270.0) {
-						v->Outbpp = TruncToValidBPP(
-								(1.0 - v->Downspreading / 100.0) * 2700,
-								v->OutputLinkDPLanes[k],
-								v->HTotal[k],
-								v->HActive[k],
-								v->PixelClockBackEnd[k],
-								v->ForcedOutputLinkBPP[k],
-								v->LinkDSCEnable,
-								v->Output[k],
-								v->OutputFormat[k],
-								v->DSCInputBitPerComponent[k],
-								v->NumberOfDSCSlices[k],
-								v->AudioSampleRate[k],
-								v->AudioSampleLayout[k],
-								v->ODMCombineEnablePerState[i][k]);
-						v->OutputBppPerState[i][k] = v->Outbpp;
-						// TODO: Need some other way to handle this nonsense
-						// v->OutputTypeAndRatePerState[i][k] = v->Output[k] & " HBR"
-					}
-					if (v->Outbpp == BPP_INVALID && v->PHYCLKPerState[i] >= 540.0) {
-						v->Outbpp = TruncToValidBPP(
-								(1.0 - v->Downspreading / 100.0) * 5400,
-								v->OutputLinkDPLanes[k],
-								v->HTotal[k],
-								v->HActive[k],
-								v->PixelClockBackEnd[k],
-								v->ForcedOutputLinkBPP[k],
-								v->LinkDSCEnable,
-								v->Output[k],
-								v->OutputFormat[k],
-								v->DSCInputBitPerComponent[k],
-								v->NumberOfDSCSlices[k],
-								v->AudioSampleRate[k],
-								v->AudioSampleLayout[k],
-								v->ODMCombineEnablePerState[i][k]);
-						v->OutputBppPerState[i][k] = v->Outbpp;
-						// TODO: Need some other way to handle this nonsense
-						// v->OutputTypeAndRatePerState[i][k] = v->Output[k] & " HBR2"
-					}
-					if (v->Outbpp == BPP_INVALID && v->PHYCLKPerState[i] >= 810.0) {
-						v->Outbpp = TruncToValidBPP(
-								(1.0 - v->Downspreading / 100.0) * 8100,
-								v->OutputLinkDPLanes[k],
-								v->HTotal[k],
-								v->HActive[k],
-								v->PixelClockBackEnd[k],
-								v->ForcedOutputLinkBPP[k],
-								v->LinkDSCEnable,
-								v->Output[k],
-								v->OutputFormat[k],
-								v->DSCInputBitPerComponent[k],
-								v->NumberOfDSCSlices[k],
-								v->AudioSampleRate[k],
-								v->AudioSampleLayout[k],
-								v->ODMCombineEnablePerState[i][k]);
-						v->OutputBppPerState[i][k] = v->Outbpp;
-						// TODO: Need some other way to handle this nonsense
-						// v->OutputTypeAndRatePerState[i][k] = v->Output[k] & " HBR3"
-					}
-					if (v->Outbpp == BPP_INVALID && v->PHYCLKD18PerState[i] >= 10000.0 / 18) {
-						v->Outbpp = TruncToValidBPP(
-								(1.0 - v->Downspreading / 100.0) * 10000,
-								4,
-								v->HTotal[k],
-								v->HActive[k],
-								v->PixelClockBackEnd[k],
-								v->ForcedOutputLinkBPP[k],
-								v->LinkDSCEnable,
-								v->Output[k],
-								v->OutputFormat[k],
-								v->DSCInputBitPerComponent[k],
-								v->NumberOfDSCSlices[k],
-								v->AudioSampleRate[k],
-								v->AudioSampleLayout[k],
-								v->ODMCombineEnablePerState[i][k]);
-						v->OutputBppPerState[i][k] = v->Outbpp;
-						//v->OutputTypeAndRatePerState[i][k] = v->Output[k] & "10x4";
+						if (v->Output[k] == dm_dp2p0) {
+							v->RequiresFEC[i][k] = true;
+						} else {
+							v->RequiresFEC[i][k] = false;
+						}
 					}
-					if (v->Outbpp == BPP_INVALID && v->PHYCLKD18PerState[i] >= 12000.0 / 18) {
-						v->Outbpp = TruncToValidBPP(
-								12000,
-								4,
-								v->HTotal[k],
-								v->HActive[k],
-								v->PixelClockBackEnd[k],
-								v->ForcedOutputLinkBPP[k],
-								v->LinkDSCEnable,
-								v->Output[k],
-								v->OutputFormat[k],
-								v->DSCInputBitPerComponent[k],
-								v->NumberOfDSCSlices[k],
-								v->AudioSampleRate[k],
-								v->AudioSampleLayout[k],
-								v->ODMCombineEnablePerState[i][k]);
-						v->OutputBppPerState[i][k] = v->Outbpp;
-						//v->OutputTypeAndRatePerState[i][k] = v->Output[k] & "12x4";
+					if (v->Output[k] == dm_dp2p0) {
+						v->Outbpp = BPP_INVALID;
+						if ((v->OutputLinkDPRate[k] == dm_dp_rate_na || v->OutputLinkDPRate[k] == dm_dp_rate_uhbr10) &&
+							v->PHYCLKD18PerState[k] >= 10000.0 / 18.0) {
+							v->Outbpp = TruncToValidBPP(
+									(1.0 - v->Downspreading / 100.0) * 10000,
+									v->OutputLinkDPLanes[k],
+									v->HTotal[k],
+									v->HActive[k],
+									v->PixelClockBackEnd[k],
+									v->ForcedOutputLinkBPP[k],
+									v->LinkDSCEnable,
+									v->Output[k],
+									v->OutputFormat[k],
+									v->DSCInputBitPerComponent[k],
+									v->NumberOfDSCSlices[k],
+									v->AudioSampleRate[k],
+									v->AudioSampleLayout[k],
+									v->ODMCombineEnablePerState[i][k]);
+							if (v->Outbpp == BPP_INVALID && v->PHYCLKD18PerState[k] < 13500.0 / 18.0 &&
+								v->DSCEnable[k] == true && v->ForcedOutputLinkBPP[k] == 0) {
+								v->RequiresDSC[i][k] = true;
+								v->LinkDSCEnable = true;
+								v->Outbpp = TruncToValidBPP(
+										(1.0 - v->Downspreading / 100.0) * 10000,
+										v->OutputLinkDPLanes[k],
+										v->HTotal[k],
+										v->HActive[k],
+										v->PixelClockBackEnd[k],
+										v->ForcedOutputLinkBPP[k],
+										v->LinkDSCEnable,
+										v->Output[k],
+										v->OutputFormat[k],
+										v->DSCInputBitPerComponent[k],
+										v->NumberOfDSCSlices[k],
+										v->AudioSampleRate[k],
+										v->AudioSampleLayout[k],
+										v->ODMCombineEnablePerState[i][k]);
+							}
+							v->OutputBppPerState[i][k] = v->Outbpp;
+							// TODO: Need some other way to handle this nonsense
+							// v->OutputTypeAndRatePerState[i][k] = v->Output[k] & " UHBR10"
+						}
+						if (v->Outbpp == BPP_INVALID &&
+							(v->OutputLinkDPRate[k] == dm_dp_rate_na || v->OutputLinkDPRate[k] == dm_dp_rate_uhbr13p5) &&
+							v->PHYCLKD18PerState[k] >= 13500.0 / 18.0) {
+							v->Outbpp = TruncToValidBPP(
+									(1.0 - v->Downspreading / 100.0) * 13500,
+									v->OutputLinkDPLanes[k],
+									v->HTotal[k],
+									v->HActive[k],
+									v->PixelClockBackEnd[k],
+									v->ForcedOutputLinkBPP[k],
+									v->LinkDSCEnable,
+									v->Output[k],
+									v->OutputFormat[k],
+									v->DSCInputBitPerComponent[k],
+									v->NumberOfDSCSlices[k],
+									v->AudioSampleRate[k],
+									v->AudioSampleLayout[k],
+									v->ODMCombineEnablePerState[i][k]);
+							if (v->Outbpp == BPP_INVALID && v->PHYCLKD18PerState[k] < 20000.0 / 18.0 &&
+								v->DSCEnable[k] == true && v->ForcedOutputLinkBPP[k] == 0) {
+								v->RequiresDSC[i][k] = true;
+								v->LinkDSCEnable = true;
+								v->Outbpp = TruncToValidBPP(
+										(1.0 - v->Downspreading / 100.0) * 13500,
+										v->OutputLinkDPLanes[k],
+										v->HTotal[k],
+										v->HActive[k],
+										v->PixelClockBackEnd[k],
+										v->ForcedOutputLinkBPP[k],
+										v->LinkDSCEnable,
+										v->Output[k],
+										v->OutputFormat[k],
+										v->DSCInputBitPerComponent[k],
+										v->NumberOfDSCSlices[k],
+										v->AudioSampleRate[k],
+										v->AudioSampleLayout[k],
+										v->ODMCombineEnablePerState[i][k]);
+							}
+							v->OutputBppPerState[i][k] = v->Outbpp;
+							// TODO: Need some other way to handle this nonsense
+							// v->OutputTypeAndRatePerState[i][k] = v->Output[k] & " UHBR13p5"
+						}
+						if (v->Outbpp == BPP_INVALID &&
+							(v->OutputLinkDPRate[k] == dm_dp_rate_na || v->OutputLinkDPRate[k] == dm_dp_rate_uhbr20) &&
+							v->PHYCLKD18PerState[k] >= 20000.0 / 18.0) {
+							v->Outbpp = TruncToValidBPP(
+									(1.0 - v->Downspreading / 100.0) * 20000,
+									v->OutputLinkDPLanes[k],
+									v->HTotal[k],
+									v->HActive[k],
+									v->PixelClockBackEnd[k],
+									v->ForcedOutputLinkBPP[k],
+									v->LinkDSCEnable,
+									v->Output[k],
+									v->OutputFormat[k],
+									v->DSCInputBitPerComponent[k],
+									v->NumberOfDSCSlices[k],
+									v->AudioSampleRate[k],
+									v->AudioSampleLayout[k],
+									v->ODMCombineEnablePerState[i][k]);
+							if (v->Outbpp == BPP_INVALID && v->DSCEnable[k] == true &&
+								v->ForcedOutputLinkBPP[k] == 0) {
+								v->RequiresDSC[i][k] = true;
+								v->LinkDSCEnable = true;
+								v->Outbpp = TruncToValidBPP(
+										(1.0 - v->Downspreading / 100.0) * 20000,
+										v->OutputLinkDPLanes[k],
+										v->HTotal[k],
+										v->HActive[k],
+										v->PixelClockBackEnd[k],
+										v->ForcedOutputLinkBPP[k],
+										v->LinkDSCEnable,
+										v->Output[k],
+										v->OutputFormat[k],
+										v->DSCInputBitPerComponent[k],
+										v->NumberOfDSCSlices[k],
+										v->AudioSampleRate[k],
+										v->AudioSampleLayout[k],
+										v->ODMCombineEnablePerState[i][k]);
+							}
+							v->OutputBppPerState[i][k] = v->Outbpp;
+							// TODO: Need some other way to handle this nonsense
+							// v->OutputTypeAndRatePerState[i][k] = v->Output[k] & " UHBR20"
+						}
+					} else {
+						v->Outbpp = BPP_INVALID;
+						if (v->PHYCLKPerState[i] >= 270.0) {
+							v->Outbpp = TruncToValidBPP(
+									(1.0 - v->Downspreading / 100.0) * 2700,
+									v->OutputLinkDPLanes[k],
+									v->HTotal[k],
+									v->HActive[k],
+									v->PixelClockBackEnd[k],
+									v->ForcedOutputLinkBPP[k],
+									v->LinkDSCEnable,
+									v->Output[k],
+									v->OutputFormat[k],
+									v->DSCInputBitPerComponent[k],
+									v->NumberOfDSCSlices[k],
+									v->AudioSampleRate[k],
+									v->AudioSampleLayout[k],
+									v->ODMCombineEnablePerState[i][k]);
+							v->OutputBppPerState[i][k] = v->Outbpp;
+							// TODO: Need some other way to handle this nonsense
+							// v->OutputTypeAndRatePerState[i][k] = v->Output[k] & " HBR"
+						}
+						if (v->Outbpp == BPP_INVALID && v->PHYCLKPerState[i] >= 540.0) {
+							v->Outbpp = TruncToValidBPP(
+									(1.0 - v->Downspreading / 100.0) * 5400,
+									v->OutputLinkDPLanes[k],
+									v->HTotal[k],
+									v->HActive[k],
+									v->PixelClockBackEnd[k],
+									v->ForcedOutputLinkBPP[k],
+									v->LinkDSCEnable,
+									v->Output[k],
+									v->OutputFormat[k],
+									v->DSCInputBitPerComponent[k],
+									v->NumberOfDSCSlices[k],
+									v->AudioSampleRate[k],
+									v->AudioSampleLayout[k],
+									v->ODMCombineEnablePerState[i][k]);
+							v->OutputBppPerState[i][k] = v->Outbpp;
+							// TODO: Need some other way to handle this nonsense
+							// v->OutputTypeAndRatePerState[i][k] = v->Output[k] & " HBR2"
+						}
+						if (v->Outbpp == BPP_INVALID && v->PHYCLKPerState[i] >= 810.0) {
+							v->Outbpp = TruncToValidBPP(
+									(1.0 - v->Downspreading / 100.0) * 8100,
+									v->OutputLinkDPLanes[k],
+									v->HTotal[k],
+									v->HActive[k],
+									v->PixelClockBackEnd[k],
+									v->ForcedOutputLinkBPP[k],
+									v->LinkDSCEnable,
+									v->Output[k],
+									v->OutputFormat[k],
+									v->DSCInputBitPerComponent[k],
+									v->NumberOfDSCSlices[k],
+									v->AudioSampleRate[k],
+									v->AudioSampleLayout[k],
+									v->ODMCombineEnablePerState[i][k]);
+							v->OutputBppPerState[i][k] = v->Outbpp;
+							// TODO: Need some other way to handle this nonsense
+							// v->OutputTypeAndRatePerState[i][k] = v->Output[k] & " HBR3"
+						}
 					}
 				}
 			} else {
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn314/display_mode_vba_314.c b/drivers/gpu/drm/amd/display/dc/dml/dcn314/display_mode_vba_314.c
index 461ab6d2030e2..daf3193701909 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn314/display_mode_vba_314.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn314/display_mode_vba_314.c
@@ -4405,11 +4405,11 @@ void dml314_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_
 							v->AudioSampleRate[k],
 							v->AudioSampleLayout[k],
 							v->ODMCombineEnablePerState[i][k]);
-				} else if (v->Output[k] == dm_dp || v->Output[k] == dm_edp) {
+				} else if (v->Output[k] == dm_dp || v->Output[k] == dm_edp || v->Output[k] == dm_dp2p0) {
 					if (v->DSCEnable[k] == true) {
 						v->RequiresDSC[i][k] = true;
 						v->LinkDSCEnable = true;
-						if (v->Output[k] == dm_dp) {
+						if (v->Output[k] == dm_dp || v->Output[k] == dm_dp2p0) {
 							v->RequiresFEC[i][k] = true;
 						} else {
 							v->RequiresFEC[i][k] = false;
@@ -4417,107 +4417,201 @@ void dml314_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_
 					} else {
 						v->RequiresDSC[i][k] = false;
 						v->LinkDSCEnable = false;
-						v->RequiresFEC[i][k] = false;
-					}
-
-					v->Outbpp = BPP_INVALID;
-					if (v->PHYCLKPerState[i] >= 270.0) {
-						v->Outbpp = TruncToValidBPP(
-								(1.0 - v->Downspreading / 100.0) * 2700,
-								v->OutputLinkDPLanes[k],
-								v->HTotal[k],
-								v->HActive[k],
-								v->PixelClockBackEnd[k],
-								v->ForcedOutputLinkBPP[k],
-								v->LinkDSCEnable,
-								v->Output[k],
-								v->OutputFormat[k],
-								v->DSCInputBitPerComponent[k],
-								v->NumberOfDSCSlices[k],
-								v->AudioSampleRate[k],
-								v->AudioSampleLayout[k],
-								v->ODMCombineEnablePerState[i][k]);
-						v->OutputBppPerState[i][k] = v->Outbpp;
-						// TODO: Need some other way to handle this nonsense
-						// v->OutputTypeAndRatePerState[i][k] = v->Output[k] & " HBR"
-					}
-					if (v->Outbpp == BPP_INVALID && v->PHYCLKPerState[i] >= 540.0) {
-						v->Outbpp = TruncToValidBPP(
-								(1.0 - v->Downspreading / 100.0) * 5400,
-								v->OutputLinkDPLanes[k],
-								v->HTotal[k],
-								v->HActive[k],
-								v->PixelClockBackEnd[k],
-								v->ForcedOutputLinkBPP[k],
-								v->LinkDSCEnable,
-								v->Output[k],
-								v->OutputFormat[k],
-								v->DSCInputBitPerComponent[k],
-								v->NumberOfDSCSlices[k],
-								v->AudioSampleRate[k],
-								v->AudioSampleLayout[k],
-								v->ODMCombineEnablePerState[i][k]);
-						v->OutputBppPerState[i][k] = v->Outbpp;
-						// TODO: Need some other way to handle this nonsense
-						// v->OutputTypeAndRatePerState[i][k] = v->Output[k] & " HBR2"
-					}
-					if (v->Outbpp == BPP_INVALID && v->PHYCLKPerState[i] >= 810.0) {
-						v->Outbpp = TruncToValidBPP(
-								(1.0 - v->Downspreading / 100.0) * 8100,
-								v->OutputLinkDPLanes[k],
-								v->HTotal[k],
-								v->HActive[k],
-								v->PixelClockBackEnd[k],
-								v->ForcedOutputLinkBPP[k],
-								v->LinkDSCEnable,
-								v->Output[k],
-								v->OutputFormat[k],
-								v->DSCInputBitPerComponent[k],
-								v->NumberOfDSCSlices[k],
-								v->AudioSampleRate[k],
-								v->AudioSampleLayout[k],
-								v->ODMCombineEnablePerState[i][k]);
-						v->OutputBppPerState[i][k] = v->Outbpp;
-						// TODO: Need some other way to handle this nonsense
-						// v->OutputTypeAndRatePerState[i][k] = v->Output[k] & " HBR3"
-					}
-					if (v->Outbpp == BPP_INVALID && v->PHYCLKD18PerState[i] >= 10000.0 / 18) {
-						v->Outbpp = TruncToValidBPP(
-								(1.0 - v->Downspreading / 100.0) * 10000,
-								4,
-								v->HTotal[k],
-								v->HActive[k],
-								v->PixelClockBackEnd[k],
-								v->ForcedOutputLinkBPP[k],
-								v->LinkDSCEnable,
-								v->Output[k],
-								v->OutputFormat[k],
-								v->DSCInputBitPerComponent[k],
-								v->NumberOfDSCSlices[k],
-								v->AudioSampleRate[k],
-								v->AudioSampleLayout[k],
-								v->ODMCombineEnablePerState[i][k]);
-						v->OutputBppPerState[i][k] = v->Outbpp;
-						//v->OutputTypeAndRatePerState[i][k] = v->Output[k] & "10x4";
+						if (v->Output[k] == dm_dp2p0) {
+							v->RequiresFEC[i][k] = true;
+						} else {
+							v->RequiresFEC[i][k] = false;
+						}
 					}
-					if (v->Outbpp == BPP_INVALID && v->PHYCLKD18PerState[i] >= 12000.0 / 18) {
-						v->Outbpp = TruncToValidBPP(
-								12000,
-								4,
-								v->HTotal[k],
-								v->HActive[k],
-								v->PixelClockBackEnd[k],
-								v->ForcedOutputLinkBPP[k],
-								v->LinkDSCEnable,
-								v->Output[k],
-								v->OutputFormat[k],
-								v->DSCInputBitPerComponent[k],
-								v->NumberOfDSCSlices[k],
-								v->AudioSampleRate[k],
-								v->AudioSampleLayout[k],
-								v->ODMCombineEnablePerState[i][k]);
-						v->OutputBppPerState[i][k] = v->Outbpp;
-						//v->OutputTypeAndRatePerState[i][k] = v->Output[k] & "12x4";
+					if (v->Output[k] == dm_dp2p0) {
+						v->Outbpp = BPP_INVALID;
+						if ((v->OutputLinkDPRate[k] == dm_dp_rate_na || v->OutputLinkDPRate[k] == dm_dp_rate_uhbr10) &&
+							v->PHYCLKD18PerState[k] >= 10000.0 / 18.0) {
+							v->Outbpp = TruncToValidBPP(
+									(1.0 - v->Downspreading / 100.0) * 10000,
+									v->OutputLinkDPLanes[k],
+									v->HTotal[k],
+									v->HActive[k],
+									v->PixelClockBackEnd[k],
+									v->ForcedOutputLinkBPP[k],
+									v->LinkDSCEnable,
+									v->Output[k],
+									v->OutputFormat[k],
+									v->DSCInputBitPerComponent[k],
+									v->NumberOfDSCSlices[k],
+									v->AudioSampleRate[k],
+									v->AudioSampleLayout[k],
+									v->ODMCombineEnablePerState[i][k]);
+							if (v->Outbpp == BPP_INVALID && v->PHYCLKD18PerState[k] < 13500.0 / 18.0 &&
+								v->DSCEnable[k] == true && v->ForcedOutputLinkBPP[k] == 0) {
+								v->RequiresDSC[i][k] = true;
+								v->LinkDSCEnable = true;
+								v->Outbpp = TruncToValidBPP(
+										(1.0 - v->Downspreading / 100.0) * 10000,
+										v->OutputLinkDPLanes[k],
+										v->HTotal[k],
+										v->HActive[k],
+										v->PixelClockBackEnd[k],
+										v->ForcedOutputLinkBPP[k],
+										v->LinkDSCEnable,
+										v->Output[k],
+										v->OutputFormat[k],
+										v->DSCInputBitPerComponent[k],
+										v->NumberOfDSCSlices[k],
+										v->AudioSampleRate[k],
+										v->AudioSampleLayout[k],
+										v->ODMCombineEnablePerState[i][k]);
+							}
+							v->OutputBppPerState[i][k] = v->Outbpp;
+							// TODO: Need some other way to handle this nonsense
+							// v->OutputTypeAndRatePerState[i][k] = v->Output[k] & " UHBR10"
+						}
+						if (v->Outbpp == BPP_INVALID &&
+							(v->OutputLinkDPRate[k] == dm_dp_rate_na || v->OutputLinkDPRate[k] == dm_dp_rate_uhbr13p5) &&
+							v->PHYCLKD18PerState[k] >= 13500.0 / 18.0) {
+							v->Outbpp = TruncToValidBPP(
+									(1.0 - v->Downspreading / 100.0) * 13500,
+									v->OutputLinkDPLanes[k],
+									v->HTotal[k],
+									v->HActive[k],
+									v->PixelClockBackEnd[k],
+									v->ForcedOutputLinkBPP[k],
+									v->LinkDSCEnable,
+									v->Output[k],
+									v->OutputFormat[k],
+									v->DSCInputBitPerComponent[k],
+									v->NumberOfDSCSlices[k],
+									v->AudioSampleRate[k],
+									v->AudioSampleLayout[k],
+									v->ODMCombineEnablePerState[i][k]);
+							if (v->Outbpp == BPP_INVALID && v->PHYCLKD18PerState[k] < 20000.0 / 18.0 &&
+								v->DSCEnable[k] == true && v->ForcedOutputLinkBPP[k] == 0) {
+								v->RequiresDSC[i][k] = true;
+								v->LinkDSCEnable = true;
+								v->Outbpp = TruncToValidBPP(
+										(1.0 - v->Downspreading / 100.0) * 13500,
+										v->OutputLinkDPLanes[k],
+										v->HTotal[k],
+										v->HActive[k],
+										v->PixelClockBackEnd[k],
+										v->ForcedOutputLinkBPP[k],
+										v->LinkDSCEnable,
+										v->Output[k],
+										v->OutputFormat[k],
+										v->DSCInputBitPerComponent[k],
+										v->NumberOfDSCSlices[k],
+										v->AudioSampleRate[k],
+										v->AudioSampleLayout[k],
+										v->ODMCombineEnablePerState[i][k]);
+							}
+							v->OutputBppPerState[i][k] = v->Outbpp;
+							// TODO: Need some other way to handle this nonsense
+							// v->OutputTypeAndRatePerState[i][k] = v->Output[k] & " UHBR13p5"
+						}
+						if (v->Outbpp == BPP_INVALID &&
+							(v->OutputLinkDPRate[k] == dm_dp_rate_na || v->OutputLinkDPRate[k] == dm_dp_rate_uhbr20) &&
+							v->PHYCLKD18PerState[k] >= 20000.0 / 18.0) {
+							v->Outbpp = TruncToValidBPP(
+									(1.0 - v->Downspreading / 100.0) * 20000,
+									v->OutputLinkDPLanes[k],
+									v->HTotal[k],
+									v->HActive[k],
+									v->PixelClockBackEnd[k],
+									v->ForcedOutputLinkBPP[k],
+									v->LinkDSCEnable,
+									v->Output[k],
+									v->OutputFormat[k],
+									v->DSCInputBitPerComponent[k],
+									v->NumberOfDSCSlices[k],
+									v->AudioSampleRate[k],
+									v->AudioSampleLayout[k],
+									v->ODMCombineEnablePerState[i][k]);
+							if (v->Outbpp == BPP_INVALID && v->DSCEnable[k] == true &&
+								v->ForcedOutputLinkBPP[k] == 0) {
+								v->RequiresDSC[i][k] = true;
+								v->LinkDSCEnable = true;
+								v->Outbpp = TruncToValidBPP(
+										(1.0 - v->Downspreading / 100.0) * 20000,
+										v->OutputLinkDPLanes[k],
+										v->HTotal[k],
+										v->HActive[k],
+										v->PixelClockBackEnd[k],
+										v->ForcedOutputLinkBPP[k],
+										v->LinkDSCEnable,
+										v->Output[k],
+										v->OutputFormat[k],
+										v->DSCInputBitPerComponent[k],
+										v->NumberOfDSCSlices[k],
+										v->AudioSampleRate[k],
+										v->AudioSampleLayout[k],
+										v->ODMCombineEnablePerState[i][k]);
+							}
+							v->OutputBppPerState[i][k] = v->Outbpp;
+							// TODO: Need some other way to handle this nonsense
+							// v->OutputTypeAndRatePerState[i][k] = v->Output[k] & " UHBR20"
+						}
+					} else {
+						v->Outbpp = BPP_INVALID;
+						if (v->PHYCLKPerState[i] >= 270.0) {
+							v->Outbpp = TruncToValidBPP(
+									(1.0 - v->Downspreading / 100.0) * 2700,
+									v->OutputLinkDPLanes[k],
+									v->HTotal[k],
+									v->HActive[k],
+									v->PixelClockBackEnd[k],
+									v->ForcedOutputLinkBPP[k],
+									v->LinkDSCEnable,
+									v->Output[k],
+									v->OutputFormat[k],
+									v->DSCInputBitPerComponent[k],
+									v->NumberOfDSCSlices[k],
+									v->AudioSampleRate[k],
+									v->AudioSampleLayout[k],
+									v->ODMCombineEnablePerState[i][k]);
+							v->OutputBppPerState[i][k] = v->Outbpp;
+							// TODO: Need some other way to handle this nonsense
+							// v->OutputTypeAndRatePerState[i][k] = v->Output[k] & " HBR"
+						}
+						if (v->Outbpp == BPP_INVALID && v->PHYCLKPerState[i] >= 540.0) {
+							v->Outbpp = TruncToValidBPP(
+									(1.0 - v->Downspreading / 100.0) * 5400,
+									v->OutputLinkDPLanes[k],
+									v->HTotal[k],
+									v->HActive[k],
+									v->PixelClockBackEnd[k],
+									v->ForcedOutputLinkBPP[k],
+									v->LinkDSCEnable,
+									v->Output[k],
+									v->OutputFormat[k],
+									v->DSCInputBitPerComponent[k],
+									v->NumberOfDSCSlices[k],
+									v->AudioSampleRate[k],
+									v->AudioSampleLayout[k],
+									v->ODMCombineEnablePerState[i][k]);
+							v->OutputBppPerState[i][k] = v->Outbpp;
+							// TODO: Need some other way to handle this nonsense
+							// v->OutputTypeAndRatePerState[i][k] = v->Output[k] & " HBR2"
+						}
+						if (v->Outbpp == BPP_INVALID && v->PHYCLKPerState[i] >= 810.0) {
+							v->Outbpp = TruncToValidBPP(
+									(1.0 - v->Downspreading / 100.0) * 8100,
+									v->OutputLinkDPLanes[k],
+									v->HTotal[k],
+									v->HActive[k],
+									v->PixelClockBackEnd[k],
+									v->ForcedOutputLinkBPP[k],
+									v->LinkDSCEnable,
+									v->Output[k],
+									v->OutputFormat[k],
+									v->DSCInputBitPerComponent[k],
+									v->NumberOfDSCSlices[k],
+									v->AudioSampleRate[k],
+									v->AudioSampleLayout[k],
+									v->ODMCombineEnablePerState[i][k]);
+							v->OutputBppPerState[i][k] = v->Outbpp;
+							// TODO: Need some other way to handle this nonsense
+							// v->OutputTypeAndRatePerState[i][k] = v->Output[k] & " HBR3"
+						}
 					}
 				}
 			} else {
-- 
2.39.2



