Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D758A403AFB;
	Tue, 21 Jul 2026 17:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655809; cv=none; b=UOK3ZbuxPUvCm0nPJ4gkBbZrjHaboz+MiUpKjLddKDNcOvsD8UA3kW2lJM2d3e47Z15v2Htr+rJx0c00jAl3hBUqjGHm5aMlOsncMQjQ806SUynGJiL/zxoGAPwNDPR9A1ee6gJn/pXxYtBZorumBK2okybvb9siBWWNCF69oZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655809; c=relaxed/simple;
	bh=TgYRk8F8H6/9VOEACpGdmDfu288nb4Ib+oqHZ35xnww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwed/uGdzW964Bn82/qXpIekfL5SLrXmqOGJ3dpzNBA0Q0Ps9e/mN6XH31avRP7bZytnxRZA5VOnDOPt8QRlEgA/Djv6e163nD2EPhhY55MDgsFp12m79WpkF3HjS1GYsXQ2OWQM44BRXoG2+Ew+8sTvcqzycCIe1UWp1O7J/58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LprfG9B0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LprfG9B0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 419E01F000E9;
	Tue, 21 Jul 2026 17:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655807;
	bh=A6NQBYPvKgUMBQStkCT+Gou3l3gMXRoMIL8atm8eciI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LprfG9B06Z4DYxIDNixjK0HDC3nQdK+jYqMF7F4DVVSRZuf9JlEUUomMB72sQrsiN
	 qnXuZVsRB6c5L6YbNa1gavBBt8iBMIVYoGQDxiQd+kkKSq2mgBe/jndYJXx1Wvy/3o
	 +DD3ULTXMhG83x6TWKno/qUZH0103eGTh/qq4D7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin He <helin52@huawei.com>,
	Yongbang Shi <shiyongbang@huawei.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0142/1611] drm/hisilicon/hibmc: move display contrl config to hibmc_probe()
Date: Tue, 21 Jul 2026 17:04:18 +0200
Message-ID: <20260721152518.069245937@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin He <helin52@huawei.com>

[ Upstream commit de2a56c71f9b223922ea8fe0192d3c1fa2954608 ]

If there's no VGA output, this encoder modeset won't be called, which
will cause displaying data from GPU being cut off. It's actually a
common display config for DP and VGA, so move the vdac encoder modeset
to driver load stage.

Removed invalid bit configurations from `hibmc_display_ctrl`

Fixes: 5294967f4ae4 ("drm/hisilicon/hibmc: Add support for VDAC")
Signed-off-by: Lin He <helin52@huawei.com>
Signed-off-by: Yongbang Shi <shiyongbang@huawei.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/20260509032302.2057227-4-shiyongbang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c   | 11 ++++++++++
 .../gpu/drm/hisilicon/hibmc/hibmc_drm_vdac.c  | 22 -------------------
 2 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c
index 481e5e62c30bf1..99b36de1fe1370 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c
+++ b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c
@@ -215,6 +215,15 @@ void hibmc_set_current_gate(struct hibmc_drm_private *priv, unsigned int gate)
 	writel(gate, mmio + gate_reg);
 }
 
+static void hibmc_display_ctrl(struct hibmc_drm_private *priv)
+{
+	u32 reg;
+
+	reg = readl(priv->mmio + HIBMC_DISPLAY_CONTROL_HISILE);
+	reg |= HIBMC_DISPLAY_CONTROL_PANELDATE(1);
+	writel(reg, priv->mmio + HIBMC_DISPLAY_CONTROL_HISILE);
+}
+
 static void hibmc_hw_config(struct hibmc_drm_private *priv)
 {
 	u32 reg;
@@ -246,6 +255,8 @@ static void hibmc_hw_config(struct hibmc_drm_private *priv)
 	reg |= HIBMC_MSCCTL_LOCALMEM_RESET(1);
 
 	writel(reg, priv->mmio + HIBMC_MISC_CTRL);
+
+	hibmc_display_ctrl(priv);
 }
 
 static int hibmc_hw_map(struct hibmc_drm_private *priv)
diff --git a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_vdac.c b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_vdac.c
index 2fcfa3246fd124..b9bd6d33fb0f7b 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_vdac.c
+++ b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_vdac.c
@@ -88,26 +88,6 @@ static const struct drm_connector_funcs hibmc_connector_funcs = {
 	.atomic_destroy_state = drm_atomic_helper_connector_destroy_state,
 };
 
-static void hibmc_encoder_mode_set(struct drm_encoder *encoder,
-				   struct drm_display_mode *mode,
-				   struct drm_display_mode *adj_mode)
-{
-	u32 reg;
-	struct drm_device *dev = encoder->dev;
-	struct hibmc_drm_private *priv = to_hibmc_drm_private(dev);
-
-	reg = readl(priv->mmio + HIBMC_DISPLAY_CONTROL_HISILE);
-	reg |= HIBMC_DISPLAY_CONTROL_FPVDDEN(1);
-	reg |= HIBMC_DISPLAY_CONTROL_PANELDATE(1);
-	reg |= HIBMC_DISPLAY_CONTROL_FPEN(1);
-	reg |= HIBMC_DISPLAY_CONTROL_VBIASEN(1);
-	writel(reg, priv->mmio + HIBMC_DISPLAY_CONTROL_HISILE);
-}
-
-static const struct drm_encoder_helper_funcs hibmc_encoder_helper_funcs = {
-	.mode_set = hibmc_encoder_mode_set,
-};
-
 int hibmc_vdac_init(struct hibmc_drm_private *priv)
 {
 	struct drm_device *dev = &priv->dev;
@@ -130,8 +110,6 @@ int hibmc_vdac_init(struct hibmc_drm_private *priv)
 		goto err;
 	}
 
-	drm_encoder_helper_add(encoder, &hibmc_encoder_helper_funcs);
-
 	ret = drm_connector_init_with_ddc(dev, connector,
 					  &hibmc_connector_funcs,
 					  DRM_MODE_CONNECTOR_VGA,
-- 
2.53.0



