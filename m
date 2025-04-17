Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBD5259C8D;
	Thu, 17 Apr 2025 18:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912930; cv=none; b=JQpaII66E+9AodfPhAXKNxYsxARiyKWMjPoIKS/De8FSifutuE1DM9keRDc0jCtcfEp1kR56L6U0SrAjvQ3DQ04bOlJAjC9x+zn5TTpUQxKrN+XMaTPh1mn7PLzum4W3YVxW1jlQYP7mHyGbGLNQWZETXLDZELcGEh4E2E8Hqto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912930; c=relaxed/simple;
	bh=Q8gQWDbDig+u5ZFNLchSS9XOq1BTt/H0bZTtfiMgQnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CtjuolE8Ut2u1FgfsKURp7M9G2ziMDuJTYES/OeuBBkpdL5/HUfzDXcoML3f0QqilIEnuceZQgq6em5lsspSub7sbiXWS4wl6yzxreaTImJQig1nRdbSq+5HSyOHUHTUYJDUj0kzdFx0xyKy6S9dBlI5XfXznYY5TEj7EyF24q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Exg7lTAA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Exg7lTAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E687C4CEE7;
	Thu, 17 Apr 2025 18:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912930;
	bh=Q8gQWDbDig+u5ZFNLchSS9XOq1BTt/H0bZTtfiMgQnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Exg7lTAAEYGBj1P9OuCP8IcdEJU9W6NTd+BbFrfK0u7RngQ/WT6J8sacYWVs2v+uA
	 jBTGD3QqQkwRydK5S/9WWv5XKJ9gya3OJM7cF2QArbtSkJm66JEb5c9GtdfuXc01Zi
	 wCA2opHpIL9pbqYe6RN4/6HrIZa2/ING55ma+vu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Louis Chauvet <louis.chauvet@bootlin.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 172/449] drm/rockchip: stop passing non struct drm_device to drm_err() and friends
Date: Thu, 17 Apr 2025 19:47:40 +0200
Message-ID: <20250417175124.907500178@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit abeef1f9eaf9301cc98a6841dab5f72de5c95360 ]

The expectation is that the struct drm_device based logging helpers get
passed an actual struct drm_device pointer rather than some random
struct pointer where you can dereference the ->dev member.

Convert drm_err(hdmi, ...) to dev_err(hdmi->dev, ...). This matches
current usage, but drops "[drm] *ERROR*" prefix from logging.

Reviewed-by: Simona Vetter <simona.vetter@ffwll.ch>
Reviewed-by: Louis Chauvet <louis.chauvet@bootlin.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/f42da4c9943a2f2a9de4272b7849e72236d4c3f9.1737644530.git.jani.nikula@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c    | 16 ++++++++--------
 drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c | 16 ++++++++--------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c b/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
index e7a6669c46b07..f737e7d46e667 100644
--- a/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
@@ -203,7 +203,7 @@ static int rockchip_hdmi_parse_dt(struct rockchip_hdmi *hdmi)
 
 	hdmi->regmap = syscon_regmap_lookup_by_phandle(np, "rockchip,grf");
 	if (IS_ERR(hdmi->regmap)) {
-		drm_err(hdmi, "Unable to get rockchip,grf\n");
+		dev_err(hdmi->dev, "Unable to get rockchip,grf\n");
 		return PTR_ERR(hdmi->regmap);
 	}
 
@@ -214,7 +214,7 @@ static int rockchip_hdmi_parse_dt(struct rockchip_hdmi *hdmi)
 	if (IS_ERR(hdmi->ref_clk)) {
 		ret = PTR_ERR(hdmi->ref_clk);
 		if (ret != -EPROBE_DEFER)
-			drm_err(hdmi, "failed to get reference clock\n");
+			dev_err(hdmi->dev, "failed to get reference clock\n");
 		return ret;
 	}
 
@@ -222,7 +222,7 @@ static int rockchip_hdmi_parse_dt(struct rockchip_hdmi *hdmi)
 	if (IS_ERR(hdmi->grf_clk)) {
 		ret = PTR_ERR(hdmi->grf_clk);
 		if (ret != -EPROBE_DEFER)
-			drm_err(hdmi, "failed to get grf clock\n");
+			dev_err(hdmi->dev, "failed to get grf clock\n");
 		return ret;
 	}
 
@@ -302,16 +302,16 @@ static void dw_hdmi_rockchip_encoder_enable(struct drm_encoder *encoder)
 
 	ret = clk_prepare_enable(hdmi->grf_clk);
 	if (ret < 0) {
-		drm_err(hdmi, "failed to enable grfclk %d\n", ret);
+		dev_err(hdmi->dev, "failed to enable grfclk %d\n", ret);
 		return;
 	}
 
 	ret = regmap_write(hdmi->regmap, hdmi->chip_data->lcdsel_grf_reg, val);
 	if (ret != 0)
-		drm_err(hdmi, "Could not write to GRF: %d\n", ret);
+		dev_err(hdmi->dev, "Could not write to GRF: %d\n", ret);
 
 	clk_disable_unprepare(hdmi->grf_clk);
-	drm_dbg(hdmi, "vop %s output to hdmi\n", ret ? "LIT" : "BIG");
+	dev_dbg(hdmi->dev, "vop %s output to hdmi\n", ret ? "LIT" : "BIG");
 }
 
 static int
@@ -574,7 +574,7 @@ static int dw_hdmi_rockchip_bind(struct device *dev, struct device *master,
 	ret = rockchip_hdmi_parse_dt(hdmi);
 	if (ret) {
 		if (ret != -EPROBE_DEFER)
-			drm_err(hdmi, "Unable to parse OF data\n");
+			dev_err(hdmi->dev, "Unable to parse OF data\n");
 		return ret;
 	}
 
@@ -582,7 +582,7 @@ static int dw_hdmi_rockchip_bind(struct device *dev, struct device *master,
 	if (IS_ERR(hdmi->phy)) {
 		ret = PTR_ERR(hdmi->phy);
 		if (ret != -EPROBE_DEFER)
-			drm_err(hdmi, "failed to get phy\n");
+			dev_err(hdmi->dev, "failed to get phy\n");
 		return ret;
 	}
 
diff --git a/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c b/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c
index cebd72bf1ef25..6bbc84c5d716d 100644
--- a/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c
@@ -170,7 +170,7 @@ static void dw_hdmi_qp_rk3588_hpd_work(struct work_struct *work)
 	if (drm) {
 		changed = drm_helper_hpd_irq_event(drm);
 		if (changed)
-			drm_dbg(hdmi, "connector status changed\n");
+			dev_dbg(hdmi->dev, "connector status changed\n");
 	}
 }
 
@@ -287,7 +287,7 @@ static int dw_hdmi_qp_rockchip_bind(struct device *dev, struct device *master,
 		}
 	}
 	if (hdmi->port_id < 0) {
-		drm_err(hdmi, "Failed to match HDMI port ID\n");
+		dev_err(hdmi->dev, "Failed to match HDMI port ID\n");
 		return hdmi->port_id;
 	}
 
@@ -311,20 +311,20 @@ static int dw_hdmi_qp_rockchip_bind(struct device *dev, struct device *master,
 	hdmi->regmap = syscon_regmap_lookup_by_phandle(dev->of_node,
 						       "rockchip,grf");
 	if (IS_ERR(hdmi->regmap)) {
-		drm_err(hdmi, "Unable to get rockchip,grf\n");
+		dev_err(hdmi->dev, "Unable to get rockchip,grf\n");
 		return PTR_ERR(hdmi->regmap);
 	}
 
 	hdmi->vo_regmap = syscon_regmap_lookup_by_phandle(dev->of_node,
 							  "rockchip,vo-grf");
 	if (IS_ERR(hdmi->vo_regmap)) {
-		drm_err(hdmi, "Unable to get rockchip,vo-grf\n");
+		dev_err(hdmi->dev, "Unable to get rockchip,vo-grf\n");
 		return PTR_ERR(hdmi->vo_regmap);
 	}
 
 	ret = devm_clk_bulk_get_all_enabled(hdmi->dev, &clks);
 	if (ret < 0) {
-		drm_err(hdmi, "Failed to get clocks: %d\n", ret);
+		dev_err(hdmi->dev, "Failed to get clocks: %d\n", ret);
 		return ret;
 	}
 
@@ -332,7 +332,7 @@ static int dw_hdmi_qp_rockchip_bind(struct device *dev, struct device *master,
 						    GPIOD_OUT_HIGH);
 	if (IS_ERR(hdmi->enable_gpio)) {
 		ret = PTR_ERR(hdmi->enable_gpio);
-		drm_err(hdmi, "Failed to request enable GPIO: %d\n", ret);
+		dev_err(hdmi->dev, "Failed to request enable GPIO: %d\n", ret);
 		return ret;
 	}
 
@@ -340,7 +340,7 @@ static int dw_hdmi_qp_rockchip_bind(struct device *dev, struct device *master,
 	if (IS_ERR(hdmi->phy)) {
 		ret = PTR_ERR(hdmi->phy);
 		if (ret != -EPROBE_DEFER)
-			drm_err(hdmi, "failed to get phy: %d\n", ret);
+			dev_err(hdmi->dev, "failed to get phy: %d\n", ret);
 		return ret;
 	}
 
@@ -403,7 +403,7 @@ static int dw_hdmi_qp_rockchip_bind(struct device *dev, struct device *master,
 	connector = drm_bridge_connector_init(drm, encoder);
 	if (IS_ERR(connector)) {
 		ret = PTR_ERR(connector);
-		drm_err(hdmi, "failed to init bridge connector: %d\n", ret);
+		dev_err(hdmi->dev, "failed to init bridge connector: %d\n", ret);
 		return ret;
 	}
 
-- 
2.39.5



