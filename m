Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB5823EAA7;
	Fri, 17 Oct 2025 15:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716541; cv=none; b=PPsVcnWG0kjisB/4KW7Tr0jVfhDK7BxqSxPMftgBL3YHzL1nMeNCzeArMLjEqbxywsV+97MVc6KylPXVUq0HEymQQtdOLBV1Se2a3G+HxnQ8diRnkIp8S8gR2R8VzVY4mWV1PCanvej7rM22MIvCob9Jl1bHY6RR82KXjKVsSp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716541; c=relaxed/simple;
	bh=8qx6ypf5HtVMcrXAncRyMOgwyiGuQK+ck3M0geSkNIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XFO7nuPHdag/qssv8IRnfs1W4PkGWF8zDUfFn1E8g6xEK61h5W/iQdsF7g5ROYHq/hzvyfB+qnIf3Uc1BrFBgYQRz+tocJ0cBxOKczX3sFHL6QGxQ7i+gINqqXUZ0+1V7u0JqLMQKOzZFxwL+HoVw/u9Bqj8m9kP1Eavwpy9k8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fhvcjX5I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fhvcjX5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0EDC4CEE7;
	Fri, 17 Oct 2025 15:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716541;
	bh=8qx6ypf5HtVMcrXAncRyMOgwyiGuQK+ck3M0geSkNIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fhvcjX5Iq/pn+amx2AaMbnZytMDZj+8u34Z45GP7P0dUzkouWK3buI6fH6Scg9/o8
	 +m5DC9NO9ADwGJJBs9lvh1DYb0rTZz5N9BQTlvtPg7qpSm7hOu5TYKRcAMK811MPKA
	 +iQybp4PY32Yak2P5wjOXwFsiuCQuotmSvlILb6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 227/276] ASoC: wcd934x: fix error handling in wcd934x_codec_parse_data()
Date: Fri, 17 Oct 2025 16:55:20 +0200
Message-ID: <20251017145150.751464458@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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
@@ -5863,6 +5863,13 @@ static const struct snd_soc_component_dr
 	.set_jack = wcd934x_codec_set_jack,
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
@@ -5883,11 +5890,13 @@ static int wcd934x_codec_parse_data(stru
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
@@ -5931,6 +5940,10 @@ static int wcd934x_codec_probe(struct pl
 		return ret;
 	}
 
+	ret = devm_add_action_or_reset(dev, wcd934x_put_device_action, &wcd->sidev->dev);
+	if (ret)
+		return ret;
+
 	/* set default rate 9P6MHz */
 	regmap_update_bits(wcd->regmap, WCD934X_CODEC_RPM_CLK_MCLK_CFG,
 			   WCD934X_CODEC_RPM_CLK_MCLK_CFG_MCLK_MASK,


