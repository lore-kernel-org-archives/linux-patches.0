Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDE7248BA1;
	Wed, 15 Jan 2025 10:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937717; cv=none; b=i1Uo+9N69THr10cwmyr+iJvWLASwmTJq4wFwz60eeb4R0iGUmv0CIRoOwX9xXbQL0qKJofXaVkd92HoVel0YO1saaaaehEIAtufiy2HeGsdDAnQqT+3O4KG5f24Oppq19tw9C5GXFtobEEkjdRSqdHhZXAK8oNLQLckXwkTbV8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937717; c=relaxed/simple;
	bh=Jjuvu2NqGnTLsW/HlYntY8KQ050oK9OQv0IudhnTa0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNjqGyB6/NRmH/XQNf7JAJsJSOPi5Ic0xSB52L8zplRGd3G3JLTxjkcJ1m2HqstIQDYqSGY+KbKSAt0sLHPua8R3P5+stLfINbTm25b23a+dhb9oZk8DUxarE2y4xa/4E8dIUNC1Iu0YBz1uirvsnoCe0avjBdFmnzpPWWkBJoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z6lFLc3P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z6lFLc3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A939C4CEE2;
	Wed, 15 Jan 2025 10:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937717;
	bh=Jjuvu2NqGnTLsW/HlYntY8KQ050oK9OQv0IudhnTa0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z6lFLc3P49CU5Jy8rZ0/LsXBaLkU2yYhOwVchb+SjMb3Dt6V59DTbAWKY09rXGTOQ
	 zI2YiGYtVpVV/VYRzbyZqFzHvU0JZVsik+VPDBOAg3hO4gnd9Q97A9gP53v2ZuQ6Xi
	 6PU8YfThmLkwRRrG/I71x3CdQWm2HQXeNnrDwSRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liankun Yang <liankun.yang@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 30/92] drm/mediatek: Fix mode valid issue for dp
Date: Wed, 15 Jan 2025 11:36:48 +0100
Message-ID: <20250115103548.727942246@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liankun Yang <liankun.yang@mediatek.com>

[ Upstream commit 0d68b55887cedc7487036ed34cb4c2097c4228f1 ]

Fix dp mode valid issue to avoid abnormal display of limit state.

After DP passes link training, it can express the lane count of the
current link status is good. Calculate the maximum bandwidth supported
by DP using the current lane count.

The color format will select the best one based on the bandwidth
requirements of the current timing mode. If the current timing mode
uses RGB and meets the DP link bandwidth requirements, RGB will be used.

If the timing mode uses RGB but does not meet the DP link bandwidthi
requirements, it will continue to check whether YUV422 meets
the DP link bandwidth.

FEC overhead is approximately 2.4% from DP 1.4a spec 2.2.1.4.2.
The down-spread amplitude shall either be disabled (0.0%) or up
to 0.5% from 1.4a 3.5.2.6. Add up to approximately 3% total overhead.

Because rate is already divided by 10,
mode->clock does not need to be multiplied by 10.

Fixes: f70ac097a2cf ("drm/mediatek: Add MT8195 Embedded DisplayPort driver")
Signed-off-by: Liankun Yang <liankun.yang@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20241025083036.8829-3-liankun.yang@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dp.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_dp.c b/drivers/gpu/drm/mediatek/mtk_dp.c
index 04e3f72fa232..09a496588b50 100644
--- a/drivers/gpu/drm/mediatek/mtk_dp.c
+++ b/drivers/gpu/drm/mediatek/mtk_dp.c
@@ -2277,12 +2277,19 @@ mtk_dp_bridge_mode_valid(struct drm_bridge *bridge,
 {
 	struct mtk_dp *mtk_dp = mtk_dp_from_bridge(bridge);
 	u32 bpp = info->color_formats & DRM_COLOR_FORMAT_YCBCR422 ? 16 : 24;
-	u32 rate = min_t(u32, drm_dp_max_link_rate(mtk_dp->rx_cap) *
-			      drm_dp_max_lane_count(mtk_dp->rx_cap),
-			 drm_dp_bw_code_to_link_rate(mtk_dp->max_linkrate) *
-			 mtk_dp->max_lanes);
+	u32 lane_count_min = mtk_dp->train_info.lane_count;
+	u32 rate = drm_dp_bw_code_to_link_rate(mtk_dp->train_info.link_rate) *
+		   lane_count_min;
 
-	if (rate < mode->clock * bpp / 8)
+	/*
+	 *FEC overhead is approximately 2.4% from DP 1.4a spec 2.2.1.4.2.
+	 *The down-spread amplitude shall either be disabled (0.0%) or up
+	 *to 0.5% from 1.4a 3.5.2.6. Add up to approximately 3% total overhead.
+	 *
+	 *Because rate is already divided by 10,
+	 *mode->clock does not need to be multiplied by 10
+	 */
+	if ((rate * 97 / 100) < (mode->clock * bpp / 8))
 		return MODE_CLOCK_HIGH;
 
 	return MODE_OK;
@@ -2323,10 +2330,9 @@ static u32 *mtk_dp_bridge_atomic_get_input_bus_fmts(struct drm_bridge *bridge,
 	struct drm_display_mode *mode = &crtc_state->adjusted_mode;
 	struct drm_display_info *display_info =
 		&conn_state->connector->display_info;
-	u32 rate = min_t(u32, drm_dp_max_link_rate(mtk_dp->rx_cap) *
-			      drm_dp_max_lane_count(mtk_dp->rx_cap),
-			 drm_dp_bw_code_to_link_rate(mtk_dp->max_linkrate) *
-			 mtk_dp->max_lanes);
+	u32 lane_count_min = mtk_dp->train_info.lane_count;
+	u32 rate = drm_dp_bw_code_to_link_rate(mtk_dp->train_info.link_rate) *
+		   lane_count_min;
 
 	*num_input_fmts = 0;
 
@@ -2335,8 +2341,8 @@ static u32 *mtk_dp_bridge_atomic_get_input_bus_fmts(struct drm_bridge *bridge,
 	 * datarate of YUV422 and sink device supports YUV422, we output YUV422
 	 * format. Use this condition, we can support more resolution.
 	 */
-	if ((rate < (mode->clock * 24 / 8)) &&
-	    (rate > (mode->clock * 16 / 8)) &&
+	if (((rate * 97 / 100) < (mode->clock * 24 / 8)) &&
+	    ((rate * 97 / 100) > (mode->clock * 16 / 8)) &&
 	    (display_info->color_formats & DRM_COLOR_FORMAT_YCBCR422)) {
 		input_fmts = kcalloc(1, sizeof(*input_fmts), GFP_KERNEL);
 		if (!input_fmts)
-- 
2.39.5



