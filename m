Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7D514AA9;
	Mon, 14 Oct 2024 15:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919554; cv=none; b=qzzWH86IC5Nix8rAQRNwma9GA1GF0GgPlrVyzk1VRhQevcNob+I2cDQEdusy3bKZqL1MnfG7kL7uStWLtRfdBl7wBSmuyk7EJi9eQR0TCenNOyCG+VQvr40XtE5ZemH/JoEirCXR6bIMBxpqgHU2/CKnI0Ued5zUbka/RuedOOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919554; c=relaxed/simple;
	bh=pbGmebGs2gwMPFHVmzrbdJ4i1lk6JFdOgy50yVAqdtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kMac34gc3PaG6f3Es10yncUw+8jdCB++RFh5Es5HkzrQ1wIpUm2pIgs0s0UVywbrR0W0N15aw2OrVpGuEYjSRomGg/VHc1TdWasr9dja7F1u9/CWPzOGMzX+Fe4s2hiNwhg42ge+fawyPDzmxDTpni6wwiL6As8t1LMGT0nPAy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B/xEDJsc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B/xEDJsc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED59DC4CECF;
	Mon, 14 Oct 2024 15:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919554;
	bh=pbGmebGs2gwMPFHVmzrbdJ4i1lk6JFdOgy50yVAqdtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B/xEDJscdogBKcZZTqVcOn3K2iq8KIha0IsST7HhGlfoqM6KjodP26jNeqj3bjCWu
	 wB0zlohIrM9fd8jAgj/PquZ+dCVHdgK/lnlYKGliEdKBnBK0/udapiufoBmylI10MX
	 /slPuh1mW7KuCUx5x6pI+JtH0MQgQojXpxl2p4W0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 640/798] media: i2c: imx335: Enable regulator supplies
Date: Mon, 14 Oct 2024 16:19:54 +0200
Message-ID: <20241014141243.184516899@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8e91767d61300..d173a456ea046 100644
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



