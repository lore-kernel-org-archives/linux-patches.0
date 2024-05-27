Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686E417E90E;
	Mon, 27 May 2024 19:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837192; cv=none; b=AMPwxN3S2ot7D6pD8vfoMmURUvYglbbDlliwv0O2YK/yxhmwOaxoo/nhAXAL4/2V71/u7iZbZjZnchLqDCj1lKMuQ36bcgQ0uqhuRObFHazVycr/S9wdGcfndsCsFPpi6osOkodH+oSnjZLrLbymRfCOSHGrwWguWVmSuBU+DmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837192; c=relaxed/simple;
	bh=fRGzh667BiUYsByclKuLOZQCchpCqB0aFA1B4fxT0u8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IhQjHEhtcF0bRDIaVNs2byRCv454YZDr6wA4ML7M19qmL61RXzFXz9MNlzC5yzqNfzstpp4FTNjD/rPZg5yo7nUrgJikMMo5k7oWJ7F06lb8QgCzIMpBV2D4rwejr1qBv/tJegXQVdB/HNa3xWVRktZmEbK0Xm0YeH+8zlejVMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1i7TdDB9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1i7TdDB9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3840C2BBFC;
	Mon, 27 May 2024 19:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837192;
	bh=fRGzh667BiUYsByclKuLOZQCchpCqB0aFA1B4fxT0u8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1i7TdDB9eZuhULAbgSthHezTi+Hs9F/TQ+CEcOGACBr5uBWJAufEsPLUW0Jvxfdp4
	 Ln1+cYZ6vv08zi/NwyMsIVYLeyabrJ9a3O+ghM9NjACtVoEBNE0thMxEkegDrcqCh7
	 XMRceK0Yh6SMwc+/5SjZKk4jO7p38j7LgORvf39E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Kuogee Hsieh <quic_khsieh@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 318/427] drm/msm/dp: allow voltage swing / pre emphasis of 3
Date: Mon, 27 May 2024 20:56:05 +0200
Message-ID: <20240527185631.429292721@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 22578178e5dd6d3aa4490879df8b6c2977d980be ]

Both dp_link_adjust_levels() and dp_ctrl_update_vx_px() limit swing and
pre-emphasis to 2, while the real maximum value for the sum of the
voltage swing and pre-emphasis is 3. Fix the DP code to remove this
limitation.

Fixes: c943b4948b58 ("drm/msm/dp: add displayPort driver support")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Tested-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/577006/
Link: https://lore.kernel.org/r/20240203-dp-swing-3-v1-1-6545e1706196@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_ctrl.c |  6 +++---
 drivers/gpu/drm/msm/dp/dp_link.c | 22 +++++++++++-----------
 drivers/gpu/drm/msm/dp/dp_link.h | 14 +-------------
 3 files changed, 15 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
index c4dda1faef677..112c7e54fc7a6 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1052,14 +1052,14 @@ static int dp_ctrl_update_vx_px(struct dp_ctrl_private *ctrl)
 	if (ret)
 		return ret;
 
-	if (voltage_swing_level >= DP_TRAIN_VOLTAGE_SWING_MAX) {
+	if (voltage_swing_level >= DP_TRAIN_LEVEL_MAX) {
 		drm_dbg_dp(ctrl->drm_dev,
 				"max. voltage swing level reached %d\n",
 				voltage_swing_level);
 		max_level_reached |= DP_TRAIN_MAX_SWING_REACHED;
 	}
 
-	if (pre_emphasis_level >= DP_TRAIN_PRE_EMPHASIS_MAX) {
+	if (pre_emphasis_level >= DP_TRAIN_LEVEL_MAX) {
 		drm_dbg_dp(ctrl->drm_dev,
 				"max. pre-emphasis level reached %d\n",
 				pre_emphasis_level);
@@ -1150,7 +1150,7 @@ static int dp_ctrl_link_train_1(struct dp_ctrl_private *ctrl,
 		}
 
 		if (ctrl->link->phy_params.v_level >=
-			DP_TRAIN_VOLTAGE_SWING_MAX) {
+			DP_TRAIN_LEVEL_MAX) {
 			DRM_ERROR_RATELIMITED("max v_level reached\n");
 			return -EAGAIN;
 		}
diff --git a/drivers/gpu/drm/msm/dp/dp_link.c b/drivers/gpu/drm/msm/dp/dp_link.c
index 49dfac1fd1ef2..ea911d9244be7 100644
--- a/drivers/gpu/drm/msm/dp/dp_link.c
+++ b/drivers/gpu/drm/msm/dp/dp_link.c
@@ -1109,6 +1109,7 @@ int dp_link_get_colorimetry_config(struct dp_link *dp_link)
 int dp_link_adjust_levels(struct dp_link *dp_link, u8 *link_status)
 {
 	int i;
+	u8 max_p_level;
 	int v_max = 0, p_max = 0;
 	struct dp_link_private *link;
 
@@ -1140,30 +1141,29 @@ int dp_link_adjust_levels(struct dp_link *dp_link, u8 *link_status)
 	 * Adjust the voltage swing and pre-emphasis level combination to within
 	 * the allowable range.
 	 */
-	if (dp_link->phy_params.v_level > DP_TRAIN_VOLTAGE_SWING_MAX) {
+	if (dp_link->phy_params.v_level > DP_TRAIN_LEVEL_MAX) {
 		drm_dbg_dp(link->drm_dev,
 			"Requested vSwingLevel=%d, change to %d\n",
 			dp_link->phy_params.v_level,
-			DP_TRAIN_VOLTAGE_SWING_MAX);
-		dp_link->phy_params.v_level = DP_TRAIN_VOLTAGE_SWING_MAX;
+			DP_TRAIN_LEVEL_MAX);
+		dp_link->phy_params.v_level = DP_TRAIN_LEVEL_MAX;
 	}
 
-	if (dp_link->phy_params.p_level > DP_TRAIN_PRE_EMPHASIS_MAX) {
+	if (dp_link->phy_params.p_level > DP_TRAIN_LEVEL_MAX) {
 		drm_dbg_dp(link->drm_dev,
 			"Requested preEmphasisLevel=%d, change to %d\n",
 			dp_link->phy_params.p_level,
-			DP_TRAIN_PRE_EMPHASIS_MAX);
-		dp_link->phy_params.p_level = DP_TRAIN_PRE_EMPHASIS_MAX;
+			DP_TRAIN_LEVEL_MAX);
+		dp_link->phy_params.p_level = DP_TRAIN_LEVEL_MAX;
 	}
 
-	if ((dp_link->phy_params.p_level > DP_TRAIN_PRE_EMPHASIS_LVL_1)
-		&& (dp_link->phy_params.v_level ==
-			DP_TRAIN_VOLTAGE_SWING_LVL_2)) {
+	max_p_level = DP_TRAIN_LEVEL_MAX - dp_link->phy_params.v_level;
+	if (dp_link->phy_params.p_level > max_p_level) {
 		drm_dbg_dp(link->drm_dev,
 			"Requested preEmphasisLevel=%d, change to %d\n",
 			dp_link->phy_params.p_level,
-			DP_TRAIN_PRE_EMPHASIS_LVL_1);
-		dp_link->phy_params.p_level = DP_TRAIN_PRE_EMPHASIS_LVL_1;
+			max_p_level);
+		dp_link->phy_params.p_level = max_p_level;
 	}
 
 	drm_dbg_dp(link->drm_dev, "adjusted: v_level=%d, p_level=%d\n",
diff --git a/drivers/gpu/drm/msm/dp/dp_link.h b/drivers/gpu/drm/msm/dp/dp_link.h
index 83da170bc56bf..42aed9c90b732 100644
--- a/drivers/gpu/drm/msm/dp/dp_link.h
+++ b/drivers/gpu/drm/msm/dp/dp_link.h
@@ -19,19 +19,7 @@ struct dp_link_info {
 	unsigned long capabilities;
 };
 
-enum dp_link_voltage_level {
-	DP_TRAIN_VOLTAGE_SWING_LVL_0	= 0,
-	DP_TRAIN_VOLTAGE_SWING_LVL_1	= 1,
-	DP_TRAIN_VOLTAGE_SWING_LVL_2	= 2,
-	DP_TRAIN_VOLTAGE_SWING_MAX	= DP_TRAIN_VOLTAGE_SWING_LVL_2,
-};
-
-enum dp_link_preemaphasis_level {
-	DP_TRAIN_PRE_EMPHASIS_LVL_0	= 0,
-	DP_TRAIN_PRE_EMPHASIS_LVL_1	= 1,
-	DP_TRAIN_PRE_EMPHASIS_LVL_2	= 2,
-	DP_TRAIN_PRE_EMPHASIS_MAX	= DP_TRAIN_PRE_EMPHASIS_LVL_2,
-};
+#define DP_TRAIN_LEVEL_MAX	3
 
 struct dp_link_test_video {
 	u32 test_video_pattern;
-- 
2.43.0



