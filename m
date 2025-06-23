Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E421E480;
	Mon, 23 Jun 2025 13:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685539; cv=none; b=IlKkQZ/ObCHoaNKAJQKwtagEwdzaOHFilXsmWm07MCfIafrSdMzxmzWdBTf+qjhcElDt6IAZp7qj25NkQRAVTXHrgiJw+rvbjJxDstnO90+8WMA+ALu0xDDxPbveTIIXO6MMnvgOh+J6aun2YcYxPrdQ6AOomXK1lrcH7Cd6cmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685539; c=relaxed/simple;
	bh=N1HaJDRkGZOJd7PHCUbNq+VyY0flax8KM6b0/+7GN1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WODj+9veXA3Fh3JTW90e1BxM1Mqx7o8aNOTPAyG/Ncm6CfCFvlb84A7lu1A4+9W1zi4jiWle5kx4pnV0eYlV3ZHvsWkIc4FPoLLQBmPQ4RI1CVogztk4nbccREM6S6uZkm9M1/5i9f/hK5tMCNG76F3ZhnotHNSppZCkxaFTemQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EV3uUzps; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EV3uUzps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E828FC4CEEA;
	Mon, 23 Jun 2025 13:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685539;
	bh=N1HaJDRkGZOJd7PHCUbNq+VyY0flax8KM6b0/+7GN1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EV3uUzpsGzweI8JHI2VnBfIJZBtQOTVmVu8TVDPS+osNjdOZYhYK65Kx2fRgWx8xD
	 FSsQGprK/ozb1Vew0uytIFIhc5VFBeUAQKHV703h0hYTugFa5YKU+ZW0aryb9qDsVH
	 9a5lG7C3HW93PA+biW3kaUoU0w53M8uUSqut11sM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlene Liu <charlene.liu@amd.com>,
	Yihan Zhu <Yihan.Zhu@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Mark Broadworth <mark.broadworth@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 242/592] drm/amd/display: DCN32 null data check
Date: Mon, 23 Jun 2025 15:03:20 +0200
Message-ID: <20250623130706.046939195@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yihan Zhu <Yihan.Zhu@amd.com>

[ Upstream commit c9646e5a7e01c3ede286ec5edd4fcb2e1e80261d ]

[WHY & HOW]
Avoid null curve data structure used in the cm block for the potential issue.

Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Signed-off-by: Yihan Zhu <Yihan.Zhu@amd.com>
Signed-off-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/mpc/dcn32/dcn32_mpc.c  | 380 +++++++++---------
 1 file changed, 192 insertions(+), 188 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/mpc/dcn32/dcn32_mpc.c b/drivers/gpu/drm/amd/display/dc/mpc/dcn32/dcn32_mpc.c
index a0e9e9f0441a4..b4cea2b8cb2a8 100644
--- a/drivers/gpu/drm/amd/display/dc/mpc/dcn32/dcn32_mpc.c
+++ b/drivers/gpu/drm/amd/display/dc/mpc/dcn32/dcn32_mpc.c
@@ -370,275 +370,279 @@ void mpc32_program_shaper_luta_settings(
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION_END_BASE_B, params->corner_points[1].red.custom_float_y);
 
 	curve = params->arr_curve_points;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_0_1[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
-
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_2_3[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
-
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_4_5[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
-
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_6_7[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
-
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_8_9[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
-
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_10_11[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
-
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_12_13[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
-
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_14_15[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
-
-
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_16_17[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
-
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_18_19[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
-
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_20_21[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
-
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_22_23[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
-
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_24_25[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
-
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_26_27[mpcc_id], 0,
+	if (curve) {
+		REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_0_1[mpcc_id], 0,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
 
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_28_29[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
-
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_30_31[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
-
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_32_33[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
-}
-
-
-void mpc32_program_shaper_lutb_settings(
-		struct mpc *mpc,
-		const struct pwl_params *params,
-		uint32_t mpcc_id)
-{
-	const struct gamma_curve *curve;
-	struct dcn30_mpc *mpc30 = TO_DCN30_MPC(mpc);
-
-	REG_SET_2(MPCC_MCM_SHAPER_RAMB_START_CNTL_B[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION_START_B, params->corner_points[0].blue.custom_float_x,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION_START_SEGMENT_B, 0);
-	REG_SET_2(MPCC_MCM_SHAPER_RAMB_START_CNTL_G[mpcc_id], 0,
-			MPCC_MCM_SHAPER_RAMA_EXP_REGION_START_B, params->corner_points[0].green.custom_float_x,
-			MPCC_MCM_SHAPER_RAMA_EXP_REGION_START_SEGMENT_B, 0);
-	REG_SET_2(MPCC_MCM_SHAPER_RAMB_START_CNTL_R[mpcc_id], 0,
-			MPCC_MCM_SHAPER_RAMA_EXP_REGION_START_B, params->corner_points[0].red.custom_float_x,
-			MPCC_MCM_SHAPER_RAMA_EXP_REGION_START_SEGMENT_B, 0);
-
-	REG_SET_2(MPCC_MCM_SHAPER_RAMB_END_CNTL_B[mpcc_id], 0,
-			MPCC_MCM_SHAPER_RAMA_EXP_REGION_END_B, params->corner_points[1].blue.custom_float_x,
-			MPCC_MCM_SHAPER_RAMA_EXP_REGION_END_BASE_B, params->corner_points[1].blue.custom_float_y);
-	REG_SET_2(MPCC_MCM_SHAPER_RAMB_END_CNTL_G[mpcc_id], 0,
-			MPCC_MCM_SHAPER_RAMA_EXP_REGION_END_B, params->corner_points[1].green.custom_float_x,
-			MPCC_MCM_SHAPER_RAMA_EXP_REGION_END_BASE_B, params->corner_points[1].green.custom_float_y);
-	REG_SET_2(MPCC_MCM_SHAPER_RAMB_END_CNTL_R[mpcc_id], 0,
-			MPCC_MCM_SHAPER_RAMA_EXP_REGION_END_B, params->corner_points[1].red.custom_float_x,
-			MPCC_MCM_SHAPER_RAMA_EXP_REGION_END_BASE_B, params->corner_points[1].red.custom_float_y);
-
-	curve = params->arr_curve_points;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_0_1[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
-
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_2_3[mpcc_id], 0,
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_2_3[mpcc_id], 0,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
 
-
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_4_5[mpcc_id], 0,
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_4_5[mpcc_id], 0,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
 
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_6_7[mpcc_id], 0,
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_6_7[mpcc_id], 0,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
 
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_8_9[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_8_9[mpcc_id], 0,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
 
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_10_11[mpcc_id], 0,
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_10_11[mpcc_id], 0,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
 
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_12_13[mpcc_id], 0,
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_12_13[mpcc_id], 0,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
 
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_14_15[mpcc_id], 0,
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_14_15[mpcc_id], 0,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
 
 
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_16_17[mpcc_id], 0,
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_16_17[mpcc_id], 0,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
 
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_18_19[mpcc_id], 0,
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_18_19[mpcc_id], 0,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
 
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_20_21[mpcc_id], 0,
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_20_21[mpcc_id], 0,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
 
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_22_23[mpcc_id], 0,
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_22_23[mpcc_id], 0,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
 
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_24_25[mpcc_id], 0,
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_24_25[mpcc_id], 0,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
 
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_26_27[mpcc_id], 0,
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_26_27[mpcc_id], 0,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_28_29[mpcc_id], 0,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
 
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_28_29[mpcc_id], 0,
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_30_31[mpcc_id], 0,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
 
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_30_31[mpcc_id], 0,
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_32_33[mpcc_id], 0,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+	}
+}
+
+
+void mpc32_program_shaper_lutb_settings(
+		struct mpc *mpc,
+		const struct pwl_params *params,
+		uint32_t mpcc_id)
+{
+	const struct gamma_curve *curve;
+	struct dcn30_mpc *mpc30 = TO_DCN30_MPC(mpc);
+
+	REG_SET_2(MPCC_MCM_SHAPER_RAMB_START_CNTL_B[mpcc_id], 0,
+		MPCC_MCM_SHAPER_RAMA_EXP_REGION_START_B, params->corner_points[0].blue.custom_float_x,
+		MPCC_MCM_SHAPER_RAMA_EXP_REGION_START_SEGMENT_B, 0);
+	REG_SET_2(MPCC_MCM_SHAPER_RAMB_START_CNTL_G[mpcc_id], 0,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION_START_B, params->corner_points[0].green.custom_float_x,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION_START_SEGMENT_B, 0);
+	REG_SET_2(MPCC_MCM_SHAPER_RAMB_START_CNTL_R[mpcc_id], 0,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION_START_B, params->corner_points[0].red.custom_float_x,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION_START_SEGMENT_B, 0);
 
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_32_33[mpcc_id], 0,
+	REG_SET_2(MPCC_MCM_SHAPER_RAMB_END_CNTL_B[mpcc_id], 0,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION_END_B, params->corner_points[1].blue.custom_float_x,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION_END_BASE_B, params->corner_points[1].blue.custom_float_y);
+	REG_SET_2(MPCC_MCM_SHAPER_RAMB_END_CNTL_G[mpcc_id], 0,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION_END_B, params->corner_points[1].green.custom_float_x,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION_END_BASE_B, params->corner_points[1].green.custom_float_y);
+	REG_SET_2(MPCC_MCM_SHAPER_RAMB_END_CNTL_R[mpcc_id], 0,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION_END_B, params->corner_points[1].red.custom_float_x,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION_END_BASE_B, params->corner_points[1].red.custom_float_y);
+
+	curve = params->arr_curve_points;
+	if (curve) {
+		REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_0_1[mpcc_id], 0,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_2_3[mpcc_id], 0,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+
+
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_4_5[mpcc_id], 0,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_6_7[mpcc_id], 0,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_8_9[mpcc_id], 0,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_10_11[mpcc_id], 0,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_12_13[mpcc_id], 0,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_14_15[mpcc_id], 0,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+
+
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_16_17[mpcc_id], 0,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_18_19[mpcc_id], 0,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_20_21[mpcc_id], 0,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_22_23[mpcc_id], 0,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_24_25[mpcc_id], 0,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_26_27[mpcc_id], 0,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_28_29[mpcc_id], 0,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_30_31[mpcc_id], 0,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_32_33[mpcc_id], 0,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+	}
 }
 
 
-- 
2.39.5



