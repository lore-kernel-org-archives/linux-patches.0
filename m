Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599AC1DDC22;
	Thu, 30 Jan 2025 14:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247139; cv=none; b=TbLIj8MzGhks1WZocVV+Z1j6JUFRpADGdDQKrEv6lh1+MhP2ptMhdq6IcV6bxAW6NDvYihBectJZGonNLi1HRJAwWSPMr1Yv2Esapu1e1NpvTQdC/5StXdRXfRKquWvPWP1YqUDLM9AmA7oFzvEToNulM5HCXct/jv5QVjnmE/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247139; c=relaxed/simple;
	bh=gnYVEr3j0/EWfU38nlkvHhImvbpiHcpZTLx7PsNIUgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOf7fCIJpNm2gzFXThGbpRNEW7OgWe7ViRP2BOmIfgDL2bvL0O2KCVBqHeJUEwYLidf5CP2jxG1BQ7iJuN6g5MVxaGAGMV2wzqGnrG3tXtbEGwGlpEx9jDniovuu3f7kjHj93Bpa0pc0nesTS1VA/4nMv79aVoMHr8BidRm1B4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1yakQjRX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1yakQjRX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24B5C4CED2;
	Thu, 30 Jan 2025 14:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247139;
	bh=gnYVEr3j0/EWfU38nlkvHhImvbpiHcpZTLx7PsNIUgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1yakQjRXu6ubOp8p4CZkrQJ5sw3drqbLP7yEmLYmtkYAcJOAMQIzYPbOPgiEDKcC6
	 snvwjf3kdztU33BRD9H6r/tA6rmOU3A3yfoQ7EDEzaErDymJr6XsB6pTFg6NrsWN/R
	 mvFnbZLEbLWhobfcDnqsQphN6tOozEaylkE3GTVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/133] drm: bridge: adv7511: use dev_err_probe in probe function
Date: Thu, 30 Jan 2025 15:00:55 +0100
Message-ID: <20250130140145.174016696@linuxfoundation.org>
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

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

[ Upstream commit 2a865248399a13bb2b2bcc50297069a7521de258 ]

adv7511 probe may need to be attempted multiple times before no
-EPROBE_DEFER is returned. Currently, every such probe results in
an error message:

[    4.534229] adv7511 1-003d: failed to find dsi host
[    4.580288] adv7511 1-003d: failed to find dsi host

This is misleading, as there is no error and probe deferral is normal
behavior. Fix this by using dev_err_probe that will suppress
-EPROBE_DEFER errors. While at it, we touch all dev_err in the probe
path. This makes the code more concise and included the error code
everywhere to aid user in debugging.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20221026125246.3188260-1-a.fatoum@pengutronix.de
Stable-dep-of: 81adbd3ff21c ("drm: adv7511: Fix use-after-free in adv7533_attach_dsi()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c |  6 ++----
 drivers/gpu/drm/bridge/adv7511/adv7533.c     | 20 ++++++++------------
 2 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
index 9e8f45fa5c5e..9255bce51753 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
@@ -1220,10 +1220,8 @@ static int adv7511_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 		return ret;
 
 	ret = adv7511_init_regulators(adv7511);
-	if (ret) {
-		dev_err(dev, "failed to init regulators\n");
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(dev, ret, "failed to init regulators\n");
 
 	/*
 	 * The power down GPIO is optional. If present, toggle it from active to
diff --git a/drivers/gpu/drm/bridge/adv7511/adv7533.c b/drivers/gpu/drm/bridge/adv7511/adv7533.c
index ec624b9d5077..f8d5fa6652af 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7533.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7533.c
@@ -146,16 +146,14 @@ int adv7533_attach_dsi(struct adv7511 *adv)
 						 };
 
 	host = of_find_mipi_dsi_host_by_node(adv->host_node);
-	if (!host) {
-		dev_err(dev, "failed to find dsi host\n");
-		return -EPROBE_DEFER;
-	}
+	if (!host)
+		return dev_err_probe(dev, -EPROBE_DEFER,
+				     "failed to find dsi host\n");
 
 	dsi = devm_mipi_dsi_device_register_full(dev, host, &info);
-	if (IS_ERR(dsi)) {
-		dev_err(dev, "failed to create dsi device\n");
-		return PTR_ERR(dsi);
-	}
+	if (IS_ERR(dsi))
+		return dev_err_probe(dev, PTR_ERR(dsi),
+				     "failed to create dsi device\n");
 
 	adv->dsi = dsi;
 
@@ -165,10 +163,8 @@ int adv7533_attach_dsi(struct adv7511 *adv)
 			  MIPI_DSI_MODE_EOT_PACKET | MIPI_DSI_MODE_VIDEO_HSE;
 
 	ret = devm_mipi_dsi_attach(dev, dsi);
-	if (ret < 0) {
-		dev_err(dev, "failed to attach dsi to host\n");
-		return ret;
-	}
+	if (ret < 0)
+		return dev_err_probe(dev, ret, "failed to attach dsi to host\n");
 
 	return 0;
 }
-- 
2.39.5



