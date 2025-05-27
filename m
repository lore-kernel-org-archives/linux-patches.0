Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D922CCC0;
	Tue, 27 May 2025 16:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364817; cv=none; b=AxJdRdqGlH7gjHjnIkSbkKeHQqDzKCFj211/429qDWqw0kXRZP8BHVABlhjMSb7iGH85eCvtdpbDOxyCZ2rCEeXpHW2N2bH3MS25KzLd594xqOKNtahsHiqC6jGdc9jccZ8l+NXSLo7/uOyOAVEUmEB64EE0a2rj/XBlcFEpk6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364817; c=relaxed/simple;
	bh=XZ31ssUsN68JUYaI1OYgpo4Cl5G4b2SKgJEShnNlkiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IvhE0b/ngn79Knv0BptksfdwByF4F0cDBncrYoO2T6T0wVFumIdBtxKwMXzn5HDivEBlRPu1E/a4gizJFQNnpEroFmz62vUHvrws1Hp+ul8ROV8qNCrQa7cPTrfIGriBQvQRxYWDmsMJYurGVWzIAjk3cukfFBCqkpX4xxvv5oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jFzhoydq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jFzhoydq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECCADC4CEE9;
	Tue, 27 May 2025 16:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364817;
	bh=XZ31ssUsN68JUYaI1OYgpo4Cl5G4b2SKgJEShnNlkiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFzhoydqnACUCiB588kjZt+yV/jvYnjuWNmUkEsaBfMiB3thBdiZQLQofpVDXbgHO
	 gV9MOUuNoi2qW+LV0fA+Kbg3dBoNcqmFPWV6UVtO0mAHsTG/AR0tFKe2crkgmo5cPq
	 uNQ8v42fydO6x2fOg670JFgFoOI1M1YZ4cYUq+pI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 174/626] phy: rockchip: usbdp: Only verify link rates/lanes/voltage when the corresponding set flags are set
Date: Tue, 27 May 2025 18:21:07 +0200
Message-ID: <20250527162452.085420887@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Yan <andy.yan@rock-chips.com>

[ Upstream commit 969a38be437b68dc9e12e3c3f08911c9f9c8be73 ]

According documentation of phy_configure_opts_dp, at the configure
stage, link rates should only be verify/configure when set_rate
flag is set, the same applies to lanes and voltage.

So do it as the documentation says.
Because voltage setting depends on the lanes, link rates set
previously, so record the link rates and lanes at it's verify stage.

Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
Link: https://lore.kernel.org/r/20250312080041.524546-1-andyshrk@163.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-usbdp.c | 87 ++++++++++++++---------
 1 file changed, 53 insertions(+), 34 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-usbdp.c b/drivers/phy/rockchip/phy-rockchip-usbdp.c
index f5c6d264d89ed..d2021f7941e3e 100644
--- a/drivers/phy/rockchip/phy-rockchip-usbdp.c
+++ b/drivers/phy/rockchip/phy-rockchip-usbdp.c
@@ -187,6 +187,8 @@ struct rk_udphy {
 	u32 dp_aux_din_sel;
 	bool dp_sink_hpd_sel;
 	bool dp_sink_hpd_cfg;
+	unsigned int link_rate;
+	unsigned int lanes;
 	u8 bw;
 	int id;
 
@@ -1102,15 +1104,19 @@ static int rk_udphy_dp_phy_power_off(struct phy *phy)
 	return 0;
 }
 
-static int rk_udphy_dp_phy_verify_link_rate(unsigned int link_rate)
+/*
+ * Verify link rate
+ */
+static int rk_udphy_dp_phy_verify_link_rate(struct rk_udphy *udphy,
+					    struct phy_configure_opts_dp *dp)
 {
-	switch (link_rate) {
+	switch (dp->link_rate) {
 	case 1620:
 	case 2700:
 	case 5400:
 	case 8100:
+		udphy->link_rate = dp->link_rate;
 		break;
-
 	default:
 		return -EINVAL;
 	}
@@ -1118,45 +1124,44 @@ static int rk_udphy_dp_phy_verify_link_rate(unsigned int link_rate)
 	return 0;
 }
 
-static int rk_udphy_dp_phy_verify_config(struct rk_udphy *udphy,
-					 struct phy_configure_opts_dp *dp)
+static int rk_udphy_dp_phy_verify_lanes(struct rk_udphy *udphy,
+					struct phy_configure_opts_dp *dp)
 {
-	int i, ret;
-
-	/* If changing link rate was required, verify it's supported. */
-	ret = rk_udphy_dp_phy_verify_link_rate(dp->link_rate);
-	if (ret)
-		return ret;
-
-	/* Verify lane count. */
 	switch (dp->lanes) {
 	case 1:
 	case 2:
 	case 4:
 		/* valid lane count. */
+		udphy->lanes = dp->lanes;
 		break;
 
 	default:
 		return -EINVAL;
 	}
 
-	/*
-	 * If changing voltages is required, check swing and pre-emphasis
-	 * levels, per-lane.
-	 */
-	if (dp->set_voltages) {
-		/* Lane count verified previously. */
-		for (i = 0; i < dp->lanes; i++) {
-			if (dp->voltage[i] > 3 || dp->pre[i] > 3)
-				return -EINVAL;
+	return 0;
+}
 
-			/*
-			 * Sum of voltage swing and pre-emphasis levels cannot
-			 * exceed 3.
-			 */
-			if (dp->voltage[i] + dp->pre[i] > 3)
-				return -EINVAL;
-		}
+/*
+ * If changing voltages is required, check swing and pre-emphasis
+ * levels, per-lane.
+ */
+static int rk_udphy_dp_phy_verify_voltages(struct rk_udphy *udphy,
+					   struct phy_configure_opts_dp *dp)
+{
+	int i;
+
+	/* Lane count verified previously. */
+	for (i = 0; i < udphy->lanes; i++) {
+		if (dp->voltage[i] > 3 || dp->pre[i] > 3)
+			return -EINVAL;
+
+		/*
+		 * Sum of voltage swing and pre-emphasis levels cannot
+		 * exceed 3.
+		 */
+		if (dp->voltage[i] + dp->pre[i] > 3)
+			return -EINVAL;
 	}
 
 	return 0;
@@ -1196,9 +1201,23 @@ static int rk_udphy_dp_phy_configure(struct phy *phy,
 	u32 i, val, lane;
 	int ret;
 
-	ret = rk_udphy_dp_phy_verify_config(udphy, dp);
-	if (ret)
-		return ret;
+	if (dp->set_rate) {
+		ret = rk_udphy_dp_phy_verify_link_rate(udphy, dp);
+		if (ret)
+			return ret;
+	}
+
+	if (dp->set_lanes) {
+		ret = rk_udphy_dp_phy_verify_lanes(udphy, dp);
+		if (ret)
+			return ret;
+	}
+
+	if (dp->set_voltages) {
+		ret = rk_udphy_dp_phy_verify_voltages(udphy, dp);
+		if (ret)
+			return ret;
+	}
 
 	if (dp->set_rate) {
 		regmap_update_bits(udphy->pma_regmap, CMN_DP_RSTN_OFFSET,
@@ -1243,9 +1262,9 @@ static int rk_udphy_dp_phy_configure(struct phy *phy,
 	}
 
 	if (dp->set_voltages) {
-		for (i = 0; i < dp->lanes; i++) {
+		for (i = 0; i < udphy->lanes; i++) {
 			lane = udphy->dp_lane_sel[i];
-			switch (dp->link_rate) {
+			switch (udphy->link_rate) {
 			case 1620:
 			case 2700:
 				regmap_update_bits(udphy->pma_regmap,
-- 
2.39.5



