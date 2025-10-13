Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70AED3093AB;
	Mon, 13 Oct 2025 15:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368629; cv=none; b=jFPpvgUXgPV//0x4oscdqDLQzkq67Obf9N+oPMoEKjOMKm8ykAS67OhZeNPrQ/+RjUTXr4cb2a3IVnWnlERrWrGwlrytaU/mWViYd5kLu9S9WDHRfrk1z2xJSFgaX7SdrIkQVQh7mDAJbzlONprGle8xw6tGqmsSLpzASaimoVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368629; c=relaxed/simple;
	bh=7ul8iymBdpSJtfHZb2Z9KBfBvjIsrSDGEJHKt0nnfeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/SUT2lkfiOKu6BUSrc/MWj87jDZnMIrn/MujnChTu5YEZYDwwIprTMp8dJ+KNu4b0Q3/Ofnm7s8Tuyf2rQefIDU5FEGQbC/Qz4A3LMNxmp2JKwNx2Loqz3fPsmARbnvMiUcWIwZnkQtuSqipRJ8MPsVj6FA4CFPi4OLhZspdsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OJvjgGJp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OJvjgGJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC82C4CEE7;
	Mon, 13 Oct 2025 15:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368629;
	bh=7ul8iymBdpSJtfHZb2Z9KBfBvjIsrSDGEJHKt0nnfeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OJvjgGJpHJZB01J9xGs7LkOidSMzDZXQrjmVSoZvDu1D4bYFcHh9O/FMcqr9FyBnk
	 2uDQmJGzDjazlpfL6J++DtXQCXcLFrVkyT5YOB9C5wOwuRkByiU1QOiM7b3ts9/PZr
	 fyy4v3OzzGUiMXrKOt700FAXPUTVV6JYLV9yOFtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 228/262] ASoC: wcd934x: fix error handling in wcd934x_codec_parse_data()
Date: Mon, 13 Oct 2025 16:46:10 +0200
Message-ID: <20251013144334.453686754@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 4e65bda8273c938039403144730923e77916a3d7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wcd934x.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/wcd934x.c
+++ b/sound/soc/codecs/wcd934x.c
@@ -5845,6 +5845,13 @@ static const struct snd_soc_component_dr
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
@@ -5861,11 +5868,13 @@ static int wcd934x_codec_parse_data(stru
 		return dev_err_probe(dev, -EINVAL, "Unable to get SLIM Interface device\n");
 
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
@@ -5907,6 +5916,10 @@ static int wcd934x_codec_probe(struct pl
 	if (ret)
 		return ret;
 
+	ret = devm_add_action_or_reset(dev, wcd934x_put_device_action, &wcd->sidev->dev);
+	if (ret)
+		return ret;
+
 	/* set default rate 9P6MHz */
 	regmap_update_bits(wcd->regmap, WCD934X_CODEC_RPM_CLK_MCLK_CFG,
 			   WCD934X_CODEC_RPM_CLK_MCLK_CFG_MCLK_MASK,


