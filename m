Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC545336E;
	Tue,  3 Dec 2024 15:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240675; cv=none; b=UIIryEUHS8SasofOU3Ky56LOxhg89hupLmfDMH8QLhBSL5by48i1KxTqYVpVzFF+TdDKpuIIJXK36yxJ+52HO8wy11oaPBVPfnwcDOziclfJCVusWj8aUG6CS4L8ucNcLdGOYd7Xp+q9A+//Ms5Fg5e4A9LymwX3YjGjSO8igXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240675; c=relaxed/simple;
	bh=deZX9hh8IHP8deIWwhRjXRAJeEeTae8kvKNtPsQdfdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hNv6dwPauRB//7iOQ5BmshNZBTCPvB9DH0h1aGCHY7sWyJuTK5aFQsUfQYqQKrzSqtbHClymh2uj8GWYZNuzFQ5rtG8okVYaNYHVKYbQpYf0fCMMy+nc8GKXXdqvqu67pcQOHUkEltjF/ORHkU0OMPVOH4q0kCn7MtAU2lkT+u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rn/NGo4m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rn/NGo4m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F142BC4CECF;
	Tue,  3 Dec 2024 15:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240675;
	bh=deZX9hh8IHP8deIWwhRjXRAJeEeTae8kvKNtPsQdfdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rn/NGo4mcbhz7yqP512QURYx1UptntnMEdU4U3OtUpa8jsPG5y+p6D20iUExu8ygp
	 lFppbeuWpBXzxXpfqkD1GkmuC+K7Ui6Q4HQEiIwsX3CTE7XmY9FoZcFC2n4IV7WtnJ
	 6fnTwFTxNpqcXzTETFrKo+N3oIv8XcYfckNUKGag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Chris Healy <cphealy@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 202/826] drm/imx: ldb: switch to drm_panel_bridge
Date: Tue,  3 Dec 2024 15:38:49 +0100
Message-ID: <20241203144751.626154844@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 5c5843b20bbb1e4b4de2359573c20e416b41cb48 ]

Defer panel handling to drm_panel_bridge, unifying codepaths for the
panel and bridge cases. The MFD_SYSCON symbol is moved to select to
prevent Kconfig symbol loops.

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Tested-by: Chris Healy <cphealy@gmail.com>
Tested-by: Philipp Zabel <p.zabel@pengutronix.de> # on imx6q-nitrogen6x
Link: https://patchwork.freedesktop.org/patch/msgid/20240602-drm-imx-cleanup-v3-7-e549e2a43100@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Stable-dep-of: f673055a4678 ("drm/imx: Add missing DRM_BRIDGE_CONNECTOR dependency")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/ipuv3/Kconfig   |  6 ++--
 drivers/gpu/drm/imx/ipuv3/imx-ldb.c | 44 +++++++++--------------------
 2 files changed, 18 insertions(+), 32 deletions(-)

diff --git a/drivers/gpu/drm/imx/ipuv3/Kconfig b/drivers/gpu/drm/imx/ipuv3/Kconfig
index bacf0655ebaf3..6abcf9c833d44 100644
--- a/drivers/gpu/drm/imx/ipuv3/Kconfig
+++ b/drivers/gpu/drm/imx/ipuv3/Kconfig
@@ -26,9 +26,11 @@ config DRM_IMX_TVE
 
 config DRM_IMX_LDB
 	tristate "Support for LVDS displays"
-	depends on DRM_IMX && MFD_SYSCON
+	depends on DRM_IMX
 	depends on COMMON_CLK
-	select DRM_PANEL
+	select MFD_SYSCON
+	select DRM_BRIDGE
+	select DRM_PANEL_BRIDGE
 	help
 	  Choose this to enable the internal LVDS Display Bridge (LDB)
 	  found on i.MX53 and i.MX6 processors.
diff --git a/drivers/gpu/drm/imx/ipuv3/imx-ldb.c b/drivers/gpu/drm/imx/ipuv3/imx-ldb.c
index 3f669604377e7..bc7ad96971308 100644
--- a/drivers/gpu/drm/imx/ipuv3/imx-ldb.c
+++ b/drivers/gpu/drm/imx/ipuv3/imx-ldb.c
@@ -27,7 +27,6 @@
 #include <drm/drm_bridge.h>
 #include <drm/drm_managed.h>
 #include <drm/drm_of.h>
-#include <drm/drm_panel.h>
 #include <drm/drm_print.h>
 #include <drm/drm_probe_helper.h>
 #include <drm/drm_simple_kms_helper.h>
@@ -64,8 +63,6 @@ struct imx_ldb;
 struct imx_ldb_channel {
 	struct imx_ldb *ldb;
 
-	/* Defines what is connected to the ldb, only one at a time */
-	struct drm_panel *panel;
 	struct drm_bridge *bridge;
 
 	struct device_node *child;
@@ -135,10 +132,6 @@ static int imx_ldb_connector_get_modes(struct drm_connector *connector)
 	struct imx_ldb_channel *imx_ldb_ch = con_to_imx_ldb_ch(connector);
 	int num_modes;
 
-	num_modes = drm_panel_get_modes(imx_ldb_ch->panel, connector);
-	if (num_modes > 0)
-		return num_modes;
-
 	if (imx_ldb_ch->mode_valid) {
 		struct drm_display_mode *mode;
 
@@ -193,8 +186,6 @@ static void imx_ldb_encoder_enable(struct drm_encoder *encoder)
 		return;
 	}
 
-	drm_panel_prepare(imx_ldb_ch->panel);
-
 	if (dual) {
 		clk_set_parent(ldb->clk_sel[mux], ldb->clk[0]);
 		clk_set_parent(ldb->clk_sel[mux], ldb->clk[1]);
@@ -233,8 +224,6 @@ static void imx_ldb_encoder_enable(struct drm_encoder *encoder)
 	}
 
 	regmap_write(ldb->regmap, IOMUXC_GPR2, ldb->ldb_ctrl);
-
-	drm_panel_enable(imx_ldb_ch->panel);
 }
 
 static void
@@ -311,8 +300,6 @@ static void imx_ldb_encoder_disable(struct drm_encoder *encoder)
 	int dual = ldb->ldb_ctrl & LDB_SPLIT_MODE_EN;
 	int mux, ret;
 
-	drm_panel_disable(imx_ldb_ch->panel);
-
 	if (imx_ldb_ch == &ldb->channel[0] || dual)
 		ldb->ldb_ctrl &= ~LDB_CH0_MODE_EN_MASK;
 	if (imx_ldb_ch == &ldb->channel[1] || dual)
@@ -346,8 +333,6 @@ static void imx_ldb_encoder_disable(struct drm_encoder *encoder)
 		dev_err(ldb->dev,
 			"unable to set di%d parent clock to original parent\n",
 			mux);
-
-	drm_panel_unprepare(imx_ldb_ch->panel);
 }
 
 static int imx_ldb_encoder_atomic_check(struct drm_encoder *encoder,
@@ -640,13 +625,15 @@ static int imx_ldb_probe(struct platform_device *pdev)
 		 * The output port is port@4 with an external 4-port mux or
 		 * port@2 with the internal 2-port mux.
 		 */
-		ret = drm_of_find_panel_or_bridge(child,
-						  imx_ldb->lvds_mux ? 4 : 2, 0,
-						  &channel->panel, &channel->bridge);
-		if (ret && ret != -ENODEV)
-			goto free_child;
+		channel->bridge = devm_drm_of_get_bridge(dev, child,
+						imx_ldb->lvds_mux ? 4 : 2, 0);
+		if (IS_ERR(channel->bridge)) {
+			ret = PTR_ERR(channel->bridge);
+			if (ret != -ENODEV)
+				goto free_child;
+
+			channel->bridge = NULL;
 
-		if (!channel->bridge && !channel->panel) {
 			ret = of_get_drm_display_mode(child,
 						      &channel->mode,
 						      &channel->bus_flags,
@@ -658,15 +645,12 @@ static int imx_ldb_probe(struct platform_device *pdev)
 		}
 
 		bus_format = of_get_bus_format(dev, child);
-		if (bus_format == -EINVAL) {
-			/*
-			 * If no bus format was specified in the device tree,
-			 * we can still get it from the connected panel later.
-			 */
-			if (channel->panel && channel->panel->funcs &&
-			    channel->panel->funcs->get_modes)
-				bus_format = 0;
-		}
+		/*
+		 * If no bus format was specified in the device tree,
+		 * we can still get it from the connected panel later.
+		 */
+		if (bus_format == -EINVAL && channel->bridge)
+			bus_format = 0;
 		if (bus_format < 0) {
 			dev_err(dev, "could not determine data mapping: %d\n",
 				bus_format);
-- 
2.43.0



