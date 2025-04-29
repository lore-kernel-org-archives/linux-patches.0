Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F465241667;
	Tue, 29 Apr 2025 16:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945705; cv=none; b=FjQ5B3J1Kp9kPW9Qj0RlDbbplHy6/AEWHRm+Jefo43S2Dh37krJk4OplIVmX/ziWdCAP908QccahHMQt2UTus69m5PH7eOg6A5P/TXb4wW3H/7j7DcavJcAwrYUK/T6hIXffjdUbEbbkijISZ8wovjWCgcSJ3bk6sKBAQfXyptc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945705; c=relaxed/simple;
	bh=nc+U1MkrdW6xYO8jKbtDXs+7FWx3IFruThIfgfVVB6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cWQ500fucXU8KNhlfO5PY+ur9a1Eu03tH9xmpAnvcxkg2uz/4r4rDS5kQhLdptqMFtivA90YgvLYQGdyU02hsPV0n+bIjQKFJdnYkRv9sQn2tCDu4Co5L/9pNQjYoNQSkOqcu8wYF6Zoi4RdHJ8Ne58ratY2csHOlxKR7zeUGvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I1OaSv5Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I1OaSv5Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DCD4C4CEE3;
	Tue, 29 Apr 2025 16:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945704;
	bh=nc+U1MkrdW6xYO8jKbtDXs+7FWx3IFruThIfgfVVB6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I1OaSv5ZtQa/SQWw+e3E/YKM3OgTDR1sjeOWYEJhges41Z6xwBCLkK7+NV7nRJIha
	 Y3pQdaL9CHbOw/Zg571U+ytR9SSiBHROLOie4KvJvyDhkueQ2VT5oXsK8QIEYkMS9v
	 S+EJrm9ovrjPLbbfMgvHDAFtmKALJ65054x9+CWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	=?UTF-8?q?Andr=C3=A9=20Apitzsch?= <git@apitzsch.eu>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 007/311] media: i2c: imx214: Simplify with dev_err_probe()
Date: Tue, 29 Apr 2025 18:37:24 +0200
Message-ID: <20250429161121.332632155@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



