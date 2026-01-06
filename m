Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1783644C6;
	Tue,  6 Jan 2026 17:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721981; cv=none; b=JaqFccrBkoh63ZxI9CDo7iubP7t4QQyPpOkIGfL4L2aD7KshDM4rW0pMUPw3hCBb0OiB8xLCWkNDFCSNrgozTSmXd+8wdgvvMCXiHBad0O8DDbZ5QyEIlhBgjb7nYpj/E/hIXG6CqIOitRIjpL5PNjM/3mcmydjfvBFtnCq6I5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721981; c=relaxed/simple;
	bh=ADcnMSTJrPNPHujjBsuRalkCVYN94H/ElPsV4Kg85lM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sWEy0lOr/YUBQwbJXBjxoqcwRZ0VqdW7cOp7zJ9bIiQ7aW0RuRgSb1aGyksbu699nb2QxgSs/UJ8yX129vrCpsLLtfG77aizceBDXDjIYkZQ/sFg3sRE+IvIjraU3kGcRmYhOcsF6x1C0S0EFV06uOfVITomKm5tO+sSqoyv3+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hOqbfi9O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hOqbfi9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E07EFC19424;
	Tue,  6 Jan 2026 17:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721981;
	bh=ADcnMSTJrPNPHujjBsuRalkCVYN94H/ElPsV4Kg85lM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hOqbfi9ORDNT0zcA3FP5+VhH85UMBfzH4mRfdleLV8PDEta09PkFu1jegs/qcS957
	 Km3GoeCyF2/JyeGDwu+eR5dEqCExS4Ip4UVVcJfsBnpHQ7q2Zxtun3qlxSqY74lBst
	 wXfUS7uAmshXEE+Gz131vFiN3UT3XhL3PxA/Gd9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	David Heidelberg <david@ixit.cz>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 097/312] ASoC: codecs: wcd937x: Fix error handling in wcd937x codec driver
Date: Tue,  6 Jan 2026 18:02:51 +0100
Message-ID: <20260106170551.349625202@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Ma Ke <make24@iscas.ac.cn>

commit 578ccfe344c5f421c2c6343b872995b397ffd3ff upstream.

In wcd937x_bind(), the driver calls of_sdw_find_device_by_node() to
obtain references to RX and TX SoundWire devices, which increment the
device reference counts. However, the corresponding put_device() are
missing in both the error paths and the normal unbind path in
wcd937x_unbind().

Add proper error handling with put_device() calls in all error paths
of wcd937x_bind() and ensure devices are released in wcd937x_unbind().

Found by code review.

Cc: stable@vger.kernel.org
Fixes: 772ed12bd04e ("ASoC: codecs: wcdxxxx: use of_sdw_find_device_by_node helper")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Reviewed-by: David Heidelberg <david@ixit.cz>
Link: https://patch.msgid.link/20251116061623.11830-1-make24@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wcd937x.c |   43 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 9 deletions(-)

--- a/sound/soc/codecs/wcd937x.c
+++ b/sound/soc/codecs/wcd937x.c
@@ -2748,7 +2748,8 @@ static int wcd937x_bind(struct device *d
 	wcd937x->rxdev = of_sdw_find_device_by_node(wcd937x->rxnode);
 	if (!wcd937x->rxdev) {
 		dev_err(dev, "could not find slave with matching of node\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_component_unbind;
 	}
 
 	wcd937x->sdw_priv[AIF1_PB] = dev_get_drvdata(wcd937x->rxdev);
@@ -2757,7 +2758,8 @@ static int wcd937x_bind(struct device *d
 	wcd937x->txdev = of_sdw_find_device_by_node(wcd937x->txnode);
 	if (!wcd937x->txdev) {
 		dev_err(dev, "could not find txslave with matching of node\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_put_rxdev;
 	}
 
 	wcd937x->sdw_priv[AIF1_CAP] = dev_get_drvdata(wcd937x->txdev);
@@ -2765,7 +2767,8 @@ static int wcd937x_bind(struct device *d
 	wcd937x->tx_sdw_dev = dev_to_sdw_dev(wcd937x->txdev);
 	if (!wcd937x->tx_sdw_dev) {
 		dev_err(dev, "could not get txslave with matching of dev\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_put_txdev;
 	}
 
 	/*
@@ -2775,31 +2778,35 @@ static int wcd937x_bind(struct device *d
 	if (!device_link_add(wcd937x->rxdev, wcd937x->txdev,
 			     DL_FLAG_STATELESS | DL_FLAG_PM_RUNTIME)) {
 		dev_err(dev, "Could not devlink TX and RX\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_put_txdev;
 	}
 
 	if (!device_link_add(dev, wcd937x->txdev,
 			     DL_FLAG_STATELESS | DL_FLAG_PM_RUNTIME)) {
 		dev_err(dev, "Could not devlink WCD and TX\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_remove_link1;
 	}
 
 	if (!device_link_add(dev, wcd937x->rxdev,
 			     DL_FLAG_STATELESS | DL_FLAG_PM_RUNTIME)) {
 		dev_err(dev, "Could not devlink WCD and RX\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_remove_link2;
 	}
 
 	wcd937x->regmap = wcd937x->sdw_priv[AIF1_CAP]->regmap;
 	if (!wcd937x->regmap) {
 		dev_err(dev, "could not get TX device regmap\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_remove_link3;
 	}
 
 	ret = wcd937x_irq_init(wcd937x, dev);
 	if (ret) {
 		dev_err(dev, "IRQ init failed: %d\n", ret);
-		return ret;
+		goto err_remove_link3;
 	}
 
 	wcd937x->sdw_priv[AIF1_PB]->slave_irq = wcd937x->virq;
@@ -2809,9 +2816,25 @@ static int wcd937x_bind(struct device *d
 
 	ret = snd_soc_register_component(dev, &soc_codec_dev_wcd937x,
 					 wcd937x_dais, ARRAY_SIZE(wcd937x_dais));
-	if (ret)
+	if (ret) {
 		dev_err(dev, "Codec registration failed\n");
+		goto err_remove_link3;
+	}
+
+	return ret;
 
+err_remove_link3:
+	device_link_remove(dev, wcd937x->rxdev);
+err_remove_link2:
+	device_link_remove(dev, wcd937x->txdev);
+err_remove_link1:
+	device_link_remove(wcd937x->rxdev, wcd937x->txdev);
+err_put_txdev:
+	put_device(wcd937x->txdev);
+err_put_rxdev:
+	put_device(wcd937x->rxdev);
+err_component_unbind:
+	component_unbind_all(dev, wcd937x);
 	return ret;
 }
 
@@ -2825,6 +2848,8 @@ static void wcd937x_unbind(struct device
 	device_link_remove(wcd937x->rxdev, wcd937x->txdev);
 	component_unbind_all(dev, wcd937x);
 	mutex_destroy(&wcd937x->micb_lock);
+	put_device(wcd937x->txdev);
+	put_device(wcd937x->rxdev);
 }
 
 static const struct component_master_ops wcd937x_comp_ops = {


