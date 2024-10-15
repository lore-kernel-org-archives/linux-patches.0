Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5211EABAB;
	Tue, 15 Oct 2024 12:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993977; cv=none; b=j1ENnZ07Muop4FxK3bmUqRjZE/soF6kZvYAqLg+c93MttEc30QVmcdInMBl1l7NOjnrxi5DUbSScm8YHJRCF/igSY3Onh9x0e8lEjhtBc7WKtSCt+LO65v0IrCKvHPpVuFoBBViAxDj7VdR2FHNrj+Pd+wf8X89fFD5fNo07BVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993977; c=relaxed/simple;
	bh=RFGBZufIsIXXF2/CJmlRdgp1tpbHLSHIVMi3v42nYgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJDKYd+klRCLrvO4J43LbFylFN67gQLzBCcnhKHLuAO8dnsGpb0YpyW3ZZA0j37g4o4i2bkzDCXXL1xA2gRjCp5EePHKrdsYIca7XGtIKQiKIIlSS2cjCIk/p5wzreEmwJE7PDRjQcO8f0hGfYz+EvyH6pvSQtTCgewAd5qPWFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YWZiUAr4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YWZiUAr4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA840C4CEC6;
	Tue, 15 Oct 2024 12:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993977;
	bh=RFGBZufIsIXXF2/CJmlRdgp1tpbHLSHIVMi3v42nYgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YWZiUAr45N45M5uDjxXMICBluzl+etSm9S1UEJsaqsgEQCRitn7mrxwz92/6FowlK
	 /akMYeL7afcq/ChISWYJtZoYkEViz6Gfv7X5o8WzdhzH6LnWOelmcuKacWUIKfbxYQ
	 GCY1lh2xnTO9NQQPn/Nnw28GMdozb9Jn9Srhh07E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 570/691] media: i2c: imx335: Enable regulator supplies
Date: Tue, 15 Oct 2024 13:28:38 +0200
Message-ID: <20241015112502.967067604@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kieran Bingham <kieran.bingham@ideasonboard.com>

[ Upstream commit fea91ee73b7cd19f08017221923d789f984abc54 ]

Provide support for enabling and disabling regulator supplies to control
power to the camera sensor.

While updating the power on function, document that a sleep is
represented as 'T4' in the datasheet power on sequence.

Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Stable-dep-of: 99d30e2fdea4 ("media: imx335: Fix reset-gpio handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx335.c | 36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/imx335.c b/drivers/media/i2c/imx335.c
index 780eb68b1894c..b5f912e0ee08e 100644
--- a/drivers/media/i2c/imx335.c
+++ b/drivers/media/i2c/imx335.c
@@ -75,6 +75,12 @@ struct imx335_reg_list {
 	const struct imx335_reg *regs;
 };
 
+static const char * const imx335_supply_name[] = {
+	"avdd", /* Analog (2.9V) supply */
+	"ovdd", /* Digital I/O (1.8V) supply */
+	"dvdd", /* Digital Core (1.2V) supply */
+};
+
 /**
  * struct imx335_mode - imx335 sensor mode structure
  * @width: Frame width
@@ -108,6 +114,7 @@ struct imx335_mode {
  * @sd: V4L2 sub-device
  * @pad: Media pad. Only one pad supported
  * @reset_gpio: Sensor reset gpio
+ * @supplies: Regulator supplies to handle power control
  * @inclk: Sensor input clock
  * @ctrl_handler: V4L2 control handler
  * @link_freq_ctrl: Pointer to link frequency control
@@ -127,6 +134,8 @@ struct imx335 {
 	struct v4l2_subdev sd;
 	struct media_pad pad;
 	struct gpio_desc *reset_gpio;
+	struct regulator_bulk_data supplies[ARRAY_SIZE(imx335_supply_name)];
+
 	struct clk *inclk;
 	struct v4l2_ctrl_handler ctrl_handler;
 	struct v4l2_ctrl *link_freq_ctrl;
@@ -790,6 +799,17 @@ static int imx335_parse_hw_config(struct imx335 *imx335)
 		return PTR_ERR(imx335->reset_gpio);
 	}
 
+	for (i = 0; i < ARRAY_SIZE(imx335_supply_name); i++)
+		imx335->supplies[i].supply = imx335_supply_name[i];
+
+	ret = devm_regulator_bulk_get(imx335->dev,
+				      ARRAY_SIZE(imx335_supply_name),
+				      imx335->supplies);
+	if (ret) {
+		dev_err(imx335->dev, "Failed to get regulators\n");
+		return ret;
+	}
+
 	/* Get sensor input clock */
 	imx335->inclk = devm_clk_get(imx335->dev, NULL);
 	if (IS_ERR(imx335->inclk)) {
@@ -868,6 +888,17 @@ static int imx335_power_on(struct device *dev)
 	struct imx335 *imx335 = to_imx335(sd);
 	int ret;
 
+	ret = regulator_bulk_enable(ARRAY_SIZE(imx335_supply_name),
+				    imx335->supplies);
+	if (ret) {
+		dev_err(dev, "%s: failed to enable regulators\n",
+			__func__);
+		return ret;
+	}
+
+	usleep_range(500, 550); /* Tlow */
+
+	/* Set XCLR */
 	gpiod_set_value_cansleep(imx335->reset_gpio, 1);
 
 	ret = clk_prepare_enable(imx335->inclk);
@@ -876,12 +907,13 @@ static int imx335_power_on(struct device *dev)
 		goto error_reset;
 	}
 
-	usleep_range(20, 22);
+	usleep_range(20, 22); /* T4 */
 
 	return 0;
 
 error_reset:
 	gpiod_set_value_cansleep(imx335->reset_gpio, 0);
+	regulator_bulk_disable(ARRAY_SIZE(imx335_supply_name), imx335->supplies);
 
 	return ret;
 }
@@ -898,8 +930,8 @@ static int imx335_power_off(struct device *dev)
 	struct imx335 *imx335 = to_imx335(sd);
 
 	gpiod_set_value_cansleep(imx335->reset_gpio, 0);
-
 	clk_disable_unprepare(imx335->inclk);
+	regulator_bulk_disable(ARRAY_SIZE(imx335_supply_name), imx335->supplies);
 
 	return 0;
 }
-- 
2.43.0



