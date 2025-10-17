Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B203432E152;
	Fri, 17 Oct 2025 15:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713354; cv=none; b=N9X0U8ZYeg3w7G48ZwBxvKZBSUsO5zlPCqMTOBAD57DrI1St3F5Y6Zk5P/h6j2fzS/cPaP6F/yljGJmQp7cxgHfFSvjUg4PDGe58teiPIqNIm2ErIcllktvnA0nPEw08/OOP1aBhXRem5U7kaX9YCR5Z/J0DcTowWZ5T/EG+Zso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713354; c=relaxed/simple;
	bh=43ZwOiEDigqrLYW0kvBPYns961Lhlc9eVMMgUrHEMTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=csl6Dh0QZxTsnJPWX9Ll146x4476H15R7R0930GetIX13bKNwzhDNlSt3BQQXQNy1+DI7IYED1jLuAm3OKFo3MP5wFrP76RSiJJ2RCBUajbXDsHMbFCoPJwIxg6noz4TUsor/NCULDhXTmh6YIQm+fYawX5O+KsNsYm6v/Mw8c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ajo/hapA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ajo/hapA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D9ECC4CEE7;
	Fri, 17 Oct 2025 15:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713354;
	bh=43ZwOiEDigqrLYW0kvBPYns961Lhlc9eVMMgUrHEMTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ajo/hapABpXIozr6KNDPCNSirJdafuEMYOwzjZF3Mz8gx7m90PBDBNOAVZ82Y8F+y
	 FMFCeqEVgGkML6/JqfzynVwXXjCfx1/rQtq7olu/ZBDKECqRFEEJqPxKLCRuos5S1w
	 JE8IxwBLlvAFKcI4zL4x2uQJFH7pBCVjH360AWBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 137/168] ASoC: wcd934x: fix error handling in wcd934x_codec_parse_data()
Date: Fri, 17 Oct 2025 16:53:36 +0200
Message-ID: <20251017145134.074232828@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

[ Upstream commit 4e65bda8273c938039403144730923e77916a3d7 ]

wcd934x_codec_parse_data() contains a device reference count leak in
of_slim_get_device() where device_find_child() increases the reference
count of the device but this reference is not properly decreased in
the success path. Add put_device() in wcd934x_codec_parse_data() and
add devm_add_action_or_reset() in the probe function, which ensures
that the reference count of the device is correctly managed.

Memory leak in regmap_init_slimbus() as the allocated regmap is not
released when the device is removed. Using devm_regmap_init_slimbus()
instead of regmap_init_slimbus() to ensure automatic regmap cleanup on
device removal.

Calling path: of_slim_get_device() -> of_find_slim_device() ->
device_find_child(). As comment of device_find_child() says, 'NOTE:
you will need to drop the reference with put_device() after use.'.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: a61f3b4f476e ("ASoC: wcd934x: add support to wcd9340/wcd9341 codec")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://patch.msgid.link/20250923065212.26660-1-make24@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wcd934x.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/wcd934x.c
+++ b/sound/soc/codecs/wcd934x.c
@@ -5862,6 +5862,13 @@ static const struct snd_soc_component_dr
 	.endianness = 1,
 };
 
+static void wcd934x_put_device_action(void *data)
+{
+	struct device *dev = data;
+
+	put_device(dev);
+}
+
 static int wcd934x_codec_parse_data(struct wcd934x_codec *wcd)
 {
 	struct device *dev = &wcd->sdev->dev;
@@ -5882,11 +5889,13 @@ static int wcd934x_codec_parse_data(stru
 	}
 
 	slim_get_logical_addr(wcd->sidev);
-	wcd->if_regmap = regmap_init_slimbus(wcd->sidev,
+	wcd->if_regmap = devm_regmap_init_slimbus(wcd->sidev,
 				  &wcd934x_ifc_regmap_config);
-	if (IS_ERR(wcd->if_regmap))
+	if (IS_ERR(wcd->if_regmap)) {
+		put_device(&wcd->sidev->dev);
 		return dev_err_probe(dev, PTR_ERR(wcd->if_regmap),
 				     "Failed to allocate ifc register map\n");
+	}
 
 	of_property_read_u32(dev->parent->of_node, "qcom,dmic-sample-rate",
 			     &wcd->dmic_sample_rate);
@@ -5930,6 +5939,10 @@ static int wcd934x_codec_probe(struct pl
 		return ret;
 	}
 
+	ret = devm_add_action_or_reset(dev, wcd934x_put_device_action, &wcd->sidev->dev);
+	if (ret)
+		return ret;
+
 	/* set default rate 9P6MHz */
 	regmap_update_bits(wcd->regmap, WCD934X_CODEC_RPM_CLK_MCLK_CFG,
 			   WCD934X_CODEC_RPM_CLK_MCLK_CFG_MCLK_MASK,


