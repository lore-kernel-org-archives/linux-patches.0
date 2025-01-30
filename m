Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C281E522;
	Thu, 30 Jan 2025 14:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247098; cv=none; b=EPE3afEkI3Q+B6egbjU42W+UApfUwiKmqcT4UpcesBb50AtLCIwr1PK3RgtJVY1kJhbwXzucf+2aisKOgTazYDcjPxsAgQQ9hL9HPw+P9eTa9Ki+AtZSf1xbGD4cIi1CY4ICiNUQGUju8s1UdelfzEjBWBpT3+CfuRp5k4DTgRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247098; c=relaxed/simple;
	bh=mVpKx64Hv7VDivFnXEX4sujzREahTM6d4cd9OUeyt3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3GcILqcm9w/kin/HNQVXwmTzeZJvWS82kmdNplx1Vwz8C447EszBrIkKF/+4Driv7wbVhrx8Vbrnfwp4fkWgooMRcBih5EIleovAz+Q1ObIWJEfneNdWGIIQvk+25PgyGPT/J208cB7VBsB3qdc3H7sljGehMHwyVQu/ztpmj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S/4VQFHO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S/4VQFHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19F3C4CED2;
	Thu, 30 Jan 2025 14:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247098;
	bh=mVpKx64Hv7VDivFnXEX4sujzREahTM6d4cd9OUeyt3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S/4VQFHOfdeaqdziHe+w9Wp8wMvpTKGR44vZzfOZiy8i4MOOAknjtO2bVymszJWWl
	 Ro4QnfioWRygwUwXmxnsjnb4MLG5iR5BfeY+Ymp5KNG/KwgJjzO4ysv5o1Cl7x5nL2
	 F8z2Sg01F+Hxdk/rHR3z2X9AaS06TYQVXiJ2Yd7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Ravnborg <sam@ravnborg.org>,
	John Stultz <john.stultz@linaro.org>,
	Maxime Ripard <maxime@cerno.tech>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 064/133] drm/bridge: adv7533: Switch to devm MIPI-DSI helpers
Date: Thu, 30 Jan 2025 15:00:53 +0100
Message-ID: <20250130140145.095394956@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit ee9418808bcce77e2c31dbbfc58621ea99a05597 ]

Let's switch to the new devm MIPI-DSI function to register and attach
our secondary device. This also avoids leaking the device when we detach
the bridge.

Acked-by: Sam Ravnborg <sam@ravnborg.org>
Tested-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20211025151536.1048186-2-maxime@cerno.tech
Stable-dep-of: 81adbd3ff21c ("drm: adv7511: Fix use-after-free in adv7533_attach_dsi()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/adv7511/adv7511.h     |  1 -
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c |  2 --
 drivers/gpu/drm/bridge/adv7511/adv7533.c     | 20 ++++----------------
 3 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511.h b/drivers/gpu/drm/bridge/adv7511/adv7511.h
index e95abeb64b93..dcb792adc62c 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511.h
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511.h
@@ -399,7 +399,6 @@ enum drm_mode_status adv7533_mode_valid(struct adv7511 *adv,
 int adv7533_patch_registers(struct adv7511 *adv);
 int adv7533_patch_cec_registers(struct adv7511 *adv);
 int adv7533_attach_dsi(struct adv7511 *adv);
-void adv7533_detach_dsi(struct adv7511 *adv);
 int adv7533_parse_dt(struct device_node *np, struct adv7511 *adv);
 
 #ifdef CONFIG_DRM_I2C_ADV7511_AUDIO
diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
index 60400efe1dd3..42d93f314699 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
@@ -1339,8 +1339,6 @@ static int adv7511_remove(struct i2c_client *i2c)
 {
 	struct adv7511 *adv7511 = i2c_get_clientdata(i2c);
 
-	if (adv7511->type == ADV7533 || adv7511->type == ADV7535)
-		adv7533_detach_dsi(adv7511);
 	i2c_unregister_device(adv7511->i2c_cec);
 	clk_disable_unprepare(adv7511->cec_clk);
 
diff --git a/drivers/gpu/drm/bridge/adv7511/adv7533.c b/drivers/gpu/drm/bridge/adv7511/adv7533.c
index 2cade7ae0c0d..ec624b9d5077 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7533.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7533.c
@@ -151,11 +151,10 @@ int adv7533_attach_dsi(struct adv7511 *adv)
 		return -EPROBE_DEFER;
 	}
 
-	dsi = mipi_dsi_device_register_full(host, &info);
+	dsi = devm_mipi_dsi_device_register_full(dev, host, &info);
 	if (IS_ERR(dsi)) {
 		dev_err(dev, "failed to create dsi device\n");
-		ret = PTR_ERR(dsi);
-		goto err_dsi_device;
+		return PTR_ERR(dsi);
 	}
 
 	adv->dsi = dsi;
@@ -165,24 +164,13 @@ int adv7533_attach_dsi(struct adv7511 *adv)
 	dsi->mode_flags = MIPI_DSI_MODE_VIDEO | MIPI_DSI_MODE_VIDEO_SYNC_PULSE |
 			  MIPI_DSI_MODE_EOT_PACKET | MIPI_DSI_MODE_VIDEO_HSE;
 
-	ret = mipi_dsi_attach(dsi);
+	ret = devm_mipi_dsi_attach(dev, dsi);
 	if (ret < 0) {
 		dev_err(dev, "failed to attach dsi to host\n");
-		goto err_dsi_attach;
+		return ret;
 	}
 
 	return 0;
-
-err_dsi_attach:
-	mipi_dsi_device_unregister(dsi);
-err_dsi_device:
-	return ret;
-}
-
-void adv7533_detach_dsi(struct adv7511 *adv)
-{
-	mipi_dsi_detach(adv->dsi);
-	mipi_dsi_device_unregister(adv->dsi);
 }
 
 int adv7533_parse_dt(struct device_node *np, struct adv7511 *adv)
-- 
2.39.5



