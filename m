Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E181E43C7DA;
	Tue, 21 Jul 2026 22:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671402; cv=none; b=eh0U+0CAXefHD5Ybd62k8E1YpoIxD28QZmrKHN3/PloiaovpQ9NkuvltGTaLtN7uNQ69Kqft+Gz3wFGfkHzlr0g/FG7LdEba9dlhSJDTqzjq+FfqvVDVcc44WhrVAfL69xOxRQFrwWRJwyRuklOna4+UV4ZuynaeIZzbUJmSKqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671402; c=relaxed/simple;
	bh=m3FBAHa0lCmsRfGKDKV7qw2TKdCWGxX8RL/U/69KCTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8IP9hffa3kMb9jdxBwxY/GvwNeNeiQRLZdS1qc8qiLzDPYk8WaYdSsYjnsmq5BLVe4xkeIKV5GCp01gUvCv2TBzbdZgO82dKL3E+atpu32i35j5V3uD++D/r/IXCeW8mnPd1CO6vc7inHnSdjfknL3vMdkIQjllVALUOYbR87A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T5Z9GSP4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T5Z9GSP4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538C81F000E9;
	Tue, 21 Jul 2026 22:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671400;
	bh=Wx22s+9+oQkr1mGlEIhu3Qqin2TJBFUO4VSPxCB3ySc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T5Z9GSP4Smy3NBZ38B9RHIrOf9NVbjujGKvCEDmOi97M3MOP4WpJLBTZ+HsbowcB2
	 3Y+1mI6py6kpw7Y+qmxQfVYxcnaPkTnynix/fhg/MwyzjTdyy5x0BrCMvsYOvU8woY
	 tBS1kmJ8pOM58wgfSkIw14YLu7k9whR70+4AFUCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin He <helin52@huawei.com>,
	Yongbang Shi <shiyongbang@huawei.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 233/843] drm/hisilicon/hibmc: move display contrl config to hibmc_probe()
Date: Tue, 21 Jul 2026 17:17:48 +0200
Message-ID: <20260721152411.258085922@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7d0edecfc49553..6fbf35cf1fe6b0 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c
+++ b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c
@@ -174,6 +174,15 @@ void hibmc_set_current_gate(struct hibmc_drm_private *priv, unsigned int gate)
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
@@ -205,6 +214,8 @@ static void hibmc_hw_config(struct hibmc_drm_private *priv)
 	reg |= HIBMC_MSCCTL_LOCALMEM_RESET(1);
 
 	writel(reg, priv->mmio + HIBMC_MISC_CTRL);
+
+	hibmc_display_ctrl(priv);
 }
 
 static int hibmc_hw_map(struct hibmc_drm_private *priv)
diff --git a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_vdac.c b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_vdac.c
index c228091fb0e6a4..532f5a0fcfcc70 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_vdac.c
+++ b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_vdac.c
@@ -64,26 +64,6 @@ static const struct drm_connector_funcs hibmc_connector_funcs = {
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
@@ -106,8 +86,6 @@ int hibmc_vdac_init(struct hibmc_drm_private *priv)
 		return ret;
 	}
 
-	drm_encoder_helper_add(encoder, &hibmc_encoder_helper_funcs);
-
 	ret = drm_connector_init_with_ddc(dev, connector,
 					  &hibmc_connector_funcs,
 					  DRM_MODE_CONNECTOR_VGA,
-- 
2.53.0



