Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9209421ABDB;
	Tue, 29 Apr 2025 17:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947577; cv=none; b=sDTkzO/tzEq5KG/l2oOcD/dk4FtT0VVbgYwuN89jrQuvoE0hWt3y6wegSXQ3/3VgyY5ubJt0l2id+sUOMKvx7yYtb8eZMa8qmHo21OcBV5i1fh6rc5dPcHoedWKeu5FQLPOF4zbXPDNvBCmuvdmw6HJBBh9DvPawDDNHQjyUQq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947577; c=relaxed/simple;
	bh=ePNTgeyqfjbOFsaiJWfrtpY8Dm7VNxsBeQhK3hCTb3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UcnvMnop+8AauBrNOwK8VTC/4vHBi50YRqmB1wVm4zCd9MEx/aq/5kGascsYsw3zlpQXV6nE+6t48nNqh85ilZo1J/v9jjBFazpu4n7j9IvhPXmBObZxS+ntykidlK+t9ongTrayy/ur8ydgFHozrMMcqJk11zlD+liUKtjFg+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A2vA4E44; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A2vA4E44"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC0AC4CEE3;
	Tue, 29 Apr 2025 17:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947577;
	bh=ePNTgeyqfjbOFsaiJWfrtpY8Dm7VNxsBeQhK3hCTb3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A2vA4E44VKb7LPYN6a1n1rUoiAT1E29kKbZnkmjSe66qDiCag5ajA2qoB4Jf76MEW
	 j6AJg04vOp2vQY2UcyL81lRfdlZAlsSHjGp/xBb02k8l5Z9ef8fouo2+MnPvXISCvi
	 jW7h/iVNxzA/V252JEwEdp5z5DT1KqPeyCKHgrXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	=?UTF-8?q?Andr=C3=A9=20Apitzsch?= <git@apitzsch.eu>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 010/280] media: i2c: imx214: Simplify with dev_err_probe()
Date: Tue, 29 Apr 2025 18:39:11 +0200
Message-ID: <20250429161115.499792387@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Apitzsch <git@apitzsch.eu>

[ Upstream commit 5d6dc133e6e4053b4b92a15a2e1b99d54b3f8adb ]

Error handling in probe() can be a bit simpler with dev_err_probe().

Acked-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: André Apitzsch <git@apitzsch.eu>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Stable-dep-of: acc294519f17 ("media: i2c: imx214: Fix link frequency validation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx214.c | 54 +++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 30 deletions(-)

diff --git a/drivers/media/i2c/imx214.c b/drivers/media/i2c/imx214.c
index af6a3859c3f13..db6cdc3b65e37 100644
--- a/drivers/media/i2c/imx214.c
+++ b/drivers/media/i2c/imx214.c
@@ -933,14 +933,12 @@ static int imx214_parse_fwnode(struct device *dev)
 	int ret;
 
 	endpoint = fwnode_graph_get_next_endpoint(dev_fwnode(dev), NULL);
-	if (!endpoint) {
-		dev_err(dev, "endpoint node not found\n");
-		return -EINVAL;
-	}
+	if (!endpoint)
+		return dev_err_probe(dev, -EINVAL, "endpoint node not found\n");
 
 	ret = v4l2_fwnode_endpoint_alloc_parse(endpoint, &bus_cfg);
 	if (ret) {
-		dev_err(dev, "parsing endpoint node failed\n");
+		dev_err_probe(dev, ret, "parsing endpoint node failed\n");
 		goto done;
 	}
 
@@ -949,8 +947,9 @@ static int imx214_parse_fwnode(struct device *dev)
 			break;
 
 	if (i == bus_cfg.nr_of_link_frequencies) {
-		dev_err(dev, "link-frequencies %d not supported, Please review your DT\n",
-			IMX214_DEFAULT_LINK_FREQ);
+		dev_err_probe(dev, -EINVAL,
+			      "link-frequencies %d not supported, Please review your DT\n",
+			      IMX214_DEFAULT_LINK_FREQ);
 		ret = -EINVAL;
 		goto done;
 	}
@@ -978,34 +977,28 @@ static int imx214_probe(struct i2c_client *client)
 	imx214->dev = dev;
 
 	imx214->xclk = devm_clk_get(dev, NULL);
-	if (IS_ERR(imx214->xclk)) {
-		dev_err(dev, "could not get xclk");
-		return PTR_ERR(imx214->xclk);
-	}
+	if (IS_ERR(imx214->xclk))
+		return dev_err_probe(dev, PTR_ERR(imx214->xclk),
+				     "failed to get xclk\n");
 
 	ret = clk_set_rate(imx214->xclk, IMX214_DEFAULT_CLK_FREQ);
-	if (ret) {
-		dev_err(dev, "could not set xclk frequency\n");
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(dev, ret,
+				     "failed to set xclk frequency\n");
 
 	ret = imx214_get_regulators(dev, imx214);
-	if (ret < 0) {
-		dev_err(dev, "cannot get regulators\n");
-		return ret;
-	}
+	if (ret < 0)
+		return dev_err_probe(dev, ret, "failed to get regulators\n");
 
 	imx214->enable_gpio = devm_gpiod_get(dev, "enable", GPIOD_OUT_LOW);
-	if (IS_ERR(imx214->enable_gpio)) {
-		dev_err(dev, "cannot get enable gpio\n");
-		return PTR_ERR(imx214->enable_gpio);
-	}
+	if (IS_ERR(imx214->enable_gpio))
+		return dev_err_probe(dev, PTR_ERR(imx214->enable_gpio),
+				     "failed to get enable gpio\n");
 
 	imx214->regmap = devm_regmap_init_i2c(client, &sensor_regmap_config);
-	if (IS_ERR(imx214->regmap)) {
-		dev_err(dev, "regmap init failed\n");
-		return PTR_ERR(imx214->regmap);
-	}
+	if (IS_ERR(imx214->regmap))
+		return dev_err_probe(dev, PTR_ERR(imx214->regmap),
+				     "regmap init failed\n");
 
 	v4l2_i2c_subdev_init(&imx214->sd, client, &imx214_subdev_ops);
 	imx214->sd.internal_ops = &imx214_internal_ops;
@@ -1027,14 +1020,14 @@ static int imx214_probe(struct i2c_client *client)
 
 	ret = media_entity_pads_init(&imx214->sd.entity, 1, &imx214->pad);
 	if (ret < 0) {
-		dev_err(dev, "could not register media entity\n");
+		dev_err_probe(dev, ret, "failed to init entity pads\n");
 		goto free_ctrl;
 	}
 
 	imx214->sd.state_lock = imx214->ctrls.lock;
 	ret = v4l2_subdev_init_finalize(&imx214->sd);
 	if (ret < 0) {
-		dev_err(dev, "subdev init error: %d\n", ret);
+		dev_err_probe(dev, ret, "subdev init error\n");
 		goto free_entity;
 	}
 
@@ -1043,7 +1036,8 @@ static int imx214_probe(struct i2c_client *client)
 
 	ret = v4l2_async_register_subdev_sensor(&imx214->sd);
 	if (ret < 0) {
-		dev_err(dev, "could not register v4l2 device\n");
+		dev_err_probe(dev, ret,
+			      "failed to register sensor sub-device\n");
 		goto error_subdev_cleanup;
 	}
 
-- 
2.39.5



