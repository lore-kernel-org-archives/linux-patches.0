Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AA62E92BC;
	Wed,  4 Feb 2026 14:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216678; cv=none; b=uNk3o8kvibLeJHvv8zH1CvXlJRcYDGIap6Xbz4/BlD4jD4cRlighDvBfaKRuL+4k2DrbOPJAgTut6daDqgLlD4mf6+JsYLns2eLCxihm7mUp+uzrvuGJ0X+5vl9DOibZ58e+YqFwjCh5p+6ZXP2ndo0cPQ91lEdekIpx4ZfGT7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216678; c=relaxed/simple;
	bh=fJpO8OhbQU402wqOy4xCJQM8o3sDApFj1QKgfO6tMBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XTIR4lGl/KCVrmEnIFOfHblp+JLkn3742A0TE+t1V81LZHn+8RRfmyWiOLPMZ+H6rcHAPNHxLNch1ZcYc3CEPgPvthNDvaVq1KRsKevggrt8OoFlRNUM9QPbiUVjIaEHGzokshhmJ0w7I366ptnwAmp+RRih+KBQrepaG19ZQpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dMYmKo/n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dMYmKo/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E86AC4CEF7;
	Wed,  4 Feb 2026 14:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216678;
	bh=fJpO8OhbQU402wqOy4xCJQM8o3sDApFj1QKgfO6tMBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dMYmKo/nV31k1r2PJtg1MqXdfOresnBMHeSqufqgRW9stGyO/wx+9cXo/QHF0sYMj
	 7l+JH2LgFmpKiLPSVN74dH68tU/ykMP93E8f8OYDsfhiXXSY09YMBJ19IefgSjZDkj
	 sDvimzmBQnhOLFyJeav7+naxitrPDIiRpFhf5d6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 160/161] drm/imx: imx-tve: move initialization into probe
Date: Wed,  4 Feb 2026 15:40:23 +0100
Message-ID: <20260204143857.506620515@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Zabel <p.zabel@pengutronix.de>

[ Upstream commit a91cfaf6e6503150ed1ef08454f2c03e1f95a4ec ]

Parts of the initialization that do not require the drm device can be
done once during probe instead of possibly multiple times during bind.
The bind function only creates the encoder.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Stable-dep-of: e535c23513c6 ("drm/imx/tve: fix probe device leak")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/imx/imx-tve.c |   42 +++++++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

--- a/drivers/gpu/drm/imx/imx-tve.c
+++ b/drivers/gpu/drm/imx/imx-tve.c
@@ -439,6 +439,9 @@ static int imx_tve_register(struct drm_d
 	encoder_type = tve->mode == TVE_MODE_VGA ?
 				DRM_MODE_ENCODER_DAC : DRM_MODE_ENCODER_TVDAC;
 
+	memset(connector, 0, sizeof(*connector));
+	memset(encoder, 0, sizeof(*encoder));
+
 	ret = imx_drm_encoder_parse_of(drm, encoder, tve->dev->of_node);
 	if (ret)
 		return ret;
@@ -504,8 +507,19 @@ static int of_get_tve_mode(struct device
 
 static int imx_tve_bind(struct device *dev, struct device *master, void *data)
 {
-	struct platform_device *pdev = to_platform_device(dev);
 	struct drm_device *drm = data;
+	struct imx_tve *tve = dev_get_drvdata(dev);
+
+	return imx_tve_register(drm, tve);
+}
+
+static const struct component_ops imx_tve_ops = {
+	.bind	= imx_tve_bind,
+};
+
+static int imx_tve_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
 	struct device_node *np = dev->of_node;
 	struct device_node *ddc_node;
 	struct imx_tve *tve;
@@ -515,8 +529,9 @@ static int imx_tve_bind(struct device *d
 	int irq;
 	int ret;
 
-	tve = dev_get_drvdata(dev);
-	memset(tve, 0, sizeof(*tve));
+	tve = devm_kzalloc(dev, sizeof(*tve), GFP_KERNEL);
+	if (!tve)
+		return -ENOMEM;
 
 	tve->dev = dev;
 
@@ -623,28 +638,9 @@ static int imx_tve_bind(struct device *d
 	if (ret)
 		return ret;
 
-	ret = imx_tve_register(drm, tve);
-	if (ret)
-		return ret;
-
-	return 0;
-}
-
-static const struct component_ops imx_tve_ops = {
-	.bind	= imx_tve_bind,
-};
-
-static int imx_tve_probe(struct platform_device *pdev)
-{
-	struct imx_tve *tve;
-
-	tve = devm_kzalloc(&pdev->dev, sizeof(*tve), GFP_KERNEL);
-	if (!tve)
-		return -ENOMEM;
-
 	platform_set_drvdata(pdev, tve);
 
-	return component_add(&pdev->dev, &imx_tve_ops);
+	return component_add(dev, &imx_tve_ops);
 }
 
 static int imx_tve_remove(struct platform_device *pdev)


