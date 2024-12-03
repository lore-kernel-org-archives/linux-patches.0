Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8972E5336E;
	Tue,  3 Dec 2024 15:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240824; cv=none; b=KTyAzb2JDoaA3LK12Nhoi3R6InnHyJxu9ZX5TOenlPUoVJ4ur2s+leanHZgbM6Rw/LNfwgWto362UM0O+qnxqKS3/AkO6r5kcllMGHIzleGPlUICJFEO2Q8NenShIlqMsqV1DyZ8tdiNIE3Wve7XhQm/I32wokpPiaE7JkaNUPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240824; c=relaxed/simple;
	bh=U+900Lb/rZ+4XicT2WXBgAePZO4xN+MOdHnXrICZm/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZrbwAKA5ux1Ej29YisYR0WCpfSCxdaaQdj8Sd9xwOK0svEDNNUQhDuaMZgKOh78zAw//JocvIjmnYn+5FECBByfB7UvCDw5je5x3NkIpw0uP2JUtroPoleXi5wYgXqrFcdH/zEPD78pte7IpUR8drOhHXqgok/J3au63Z1HIaCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j/X5E9kG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j/X5E9kG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF27FC4CECF;
	Tue,  3 Dec 2024 15:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240824;
	bh=U+900Lb/rZ+4XicT2WXBgAePZO4xN+MOdHnXrICZm/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j/X5E9kGqRujo7T4W3YNboa3VwbRtxHfY/P3VZjfV35r/Lh0naNkBHe63hEOx58i4
	 60J0W8uAcmKop4O551L/oeELacr9UV0TppIuInh+kOZSU6k+HsraVosTMunKUi7o/F
	 OYJK5767eMSRKeaonDsPfIT6Ea2LfT4xrZdfckKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Chris Healy <cphealy@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 203/826] drm/imx: parallel-display: switch to drm_panel_bridge
Date: Tue,  3 Dec 2024 15:38:50 +0100
Message-ID: <20241203144751.666134965@linuxfoundation.org>
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

[ Upstream commit 5f6e56d3319d2fd20d4c81b4f0212f4d09d7c1f1 ]

Defer panel handling to drm_panel_bridge, unifying codepaths for the
panel and bridge cases.

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Tested-by: Chris Healy <cphealy@gmail.com>
Tested-by: Philipp Zabel <p.zabel@pengutronix.de> # on imx6q-nitrogen6x
Link: https://patchwork.freedesktop.org/patch/msgid/20240602-drm-imx-cleanup-v3-8-e549e2a43100@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Stable-dep-of: f673055a4678 ("drm/imx: Add missing DRM_BRIDGE_CONNECTOR dependency")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/ipuv3/Kconfig            |  3 +-
 drivers/gpu/drm/imx/ipuv3/parallel-display.c | 36 +++++---------------
 2 files changed, 10 insertions(+), 29 deletions(-)

diff --git a/drivers/gpu/drm/imx/ipuv3/Kconfig b/drivers/gpu/drm/imx/ipuv3/Kconfig
index 6abcf9c833d44..f083d313d1d3a 100644
--- a/drivers/gpu/drm/imx/ipuv3/Kconfig
+++ b/drivers/gpu/drm/imx/ipuv3/Kconfig
@@ -11,8 +11,9 @@ config DRM_IMX
 
 config DRM_IMX_PARALLEL_DISPLAY
 	tristate "Support for parallel displays"
-	select DRM_PANEL
 	depends on DRM_IMX
+	select DRM_BRIDGE
+	select DRM_PANEL_BRIDGE
 	select VIDEOMODE_HELPERS
 
 config DRM_IMX_TVE
diff --git a/drivers/gpu/drm/imx/ipuv3/parallel-display.c b/drivers/gpu/drm/imx/ipuv3/parallel-display.c
index 4d17fb96e77c5..9ac2a94fa62be 100644
--- a/drivers/gpu/drm/imx/ipuv3/parallel-display.c
+++ b/drivers/gpu/drm/imx/ipuv3/parallel-display.c
@@ -18,7 +18,6 @@
 #include <drm/drm_bridge.h>
 #include <drm/drm_managed.h>
 #include <drm/drm_of.h>
-#include <drm/drm_panel.h>
 #include <drm/drm_probe_helper.h>
 #include <drm/drm_simple_kms_helper.h>
 
@@ -36,7 +35,6 @@ struct imx_parallel_display {
 	u32 bus_format;
 	u32 bus_flags;
 	struct drm_display_mode mode;
-	struct drm_panel *panel;
 	struct drm_bridge *next_bridge;
 };
 
@@ -56,10 +54,6 @@ static int imx_pd_connector_get_modes(struct drm_connector *connector)
 	struct device_node *np = imxpd->dev->of_node;
 	int num_modes;
 
-	num_modes = drm_panel_get_modes(imxpd->panel, connector);
-	if (num_modes > 0)
-		return num_modes;
-
 	if (np) {
 		struct drm_display_mode *mode = drm_mode_create(connector->dev);
 		int ret;
@@ -84,22 +78,6 @@ static int imx_pd_connector_get_modes(struct drm_connector *connector)
 	return num_modes;
 }
 
-static void imx_pd_bridge_enable(struct drm_bridge *bridge)
-{
-	struct imx_parallel_display *imxpd = bridge_to_imxpd(bridge);
-
-	drm_panel_prepare(imxpd->panel);
-	drm_panel_enable(imxpd->panel);
-}
-
-static void imx_pd_bridge_disable(struct drm_bridge *bridge)
-{
-	struct imx_parallel_display *imxpd = bridge_to_imxpd(bridge);
-
-	drm_panel_disable(imxpd->panel);
-	drm_panel_unprepare(imxpd->panel);
-}
-
 static const u32 imx_pd_bus_fmts[] = {
 	MEDIA_BUS_FMT_RGB888_1X24,
 	MEDIA_BUS_FMT_BGR888_1X24,
@@ -237,8 +215,6 @@ static const struct drm_connector_helper_funcs imx_pd_connector_helper_funcs = {
 };
 
 static const struct drm_bridge_funcs imx_pd_bridge_funcs = {
-	.enable = imx_pd_bridge_enable,
-	.disable = imx_pd_bridge_disable,
 	.atomic_reset = drm_atomic_helper_bridge_reset,
 	.atomic_duplicate_state = drm_atomic_helper_bridge_duplicate_state,
 	.atomic_destroy_state = drm_atomic_helper_bridge_destroy_state,
@@ -315,10 +291,14 @@ static int imx_pd_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	/* port@1 is the output port */
-	ret = drm_of_find_panel_or_bridge(np, 1, 0, &imxpd->panel,
-					  &imxpd->next_bridge);
-	if (ret && ret != -ENODEV)
-		return ret;
+	imxpd->next_bridge = devm_drm_of_get_bridge(dev, np, 1, 0);
+	if (IS_ERR(imxpd->next_bridge)) {
+		ret = PTR_ERR(imxpd->next_bridge);
+		if (ret != -ENODEV)
+			return ret;
+
+		imxpd->next_bridge = NULL;
+	}
 
 	ret = of_property_read_string(np, "interface-pix-fmt", &fmt);
 	if (!ret) {
-- 
2.43.0



