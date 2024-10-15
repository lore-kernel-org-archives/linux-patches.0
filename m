Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7107C1E7669;
	Tue, 15 Oct 2024 12:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993980; cv=none; b=R8efxCzuxoSQGBQDXIV7DQt+SJB4XWZjlkTTXONvDRa/KEVi9elgd537SDm2ez8wGv4dZsD0N+llrZdI1hKzuOjBDMl+ej3U5DvP5qiyrHbCX9P7eZL6motMn2zC0xy9jTjtRsQsVO7bEAvziHq54JiIvPG0zSUAh5B1uFyIwgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993980; c=relaxed/simple;
	bh=V1O49nzr9aAcHHRZMCArq8HSSBn9t59P2Iq2Qw8KRr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RzuEDucnw2ylprpC75/Mcu0r91XgzZiY084G3eO6i0fvp5dtyWP6OKB3MIBcSDbbzd096C+awIiogJfz3uU/9Yj02HsmYUAYBv7U3FqJiAkUAbAXSgMtdoAV4g7TS9vLdDy43ZLU2PVVTQ2SI/q5CD/+95GRHGNe3JDMKDXmGb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IaCDf1k7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IaCDf1k7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BD5C4CEC6;
	Tue, 15 Oct 2024 12:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993980;
	bh=V1O49nzr9aAcHHRZMCArq8HSSBn9t59P2Iq2Qw8KRr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IaCDf1k7hkUjynpiKSd6Bq8Qi/TklQ7k2C3ZZ+0PHCosPo0HrGQe9SHlLPgHSa354
	 uqmPCzXX6WdvxQJoIr1hN+a09u8FBCluILWVRuH+5CtB8ASjpRYhtyvRfcfT5dfaWy
	 G86QxsTobSY7cyruw4XHvVQJ9seSovn06MiSeLxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Umang Jain <umang.jain@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 571/691] media: imx335: Fix reset-gpio handling
Date: Tue, 15 Oct 2024 13:28:39 +0200
Message-ID: <20241015112503.006703885@linuxfoundation.org>
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

From: Umang Jain <umang.jain@ideasonboard.com>

[ Upstream commit 99d30e2fdea4086be4e66e2deb10de854b547ab8 ]

Rectify the logical value of reset-gpio so that it is set to
0 (disabled) during power-on and to 1 (enabled) during power-off.

Set the reset-gpio to GPIO_OUT_HIGH at initialization time to make
sure it starts off in reset. Also drop the "Set XCLR" comment which
is not-so-informative.

The existing usage of imx335 had reset-gpios polarity inverted
(GPIO_ACTIVE_HIGH) in their device-tree sources. With this patch
included, those DTS will not be able to stream imx335 anymore. The
reset-gpio polarity will need to be rectified in the device-tree
sources as shown in [1] example, in order to get imx335 functional
again (as it remains in reset prior to this fix).

Cc: stable@vger.kernel.org
Fixes: 45d19b5fb9ae ("media: i2c: Add imx335 camera sensor driver")
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/linux-media/20240729110437.199428-1-umang.jain@ideasonboard.com/
Signed-off-by: Umang Jain <umang.jain@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx335.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/imx335.c b/drivers/media/i2c/imx335.c
index b5f912e0ee08e..2692547791f91 100644
--- a/drivers/media/i2c/imx335.c
+++ b/drivers/media/i2c/imx335.c
@@ -792,7 +792,7 @@ static int imx335_parse_hw_config(struct imx335 *imx335)
 
 	/* Request optional reset pin */
 	imx335->reset_gpio = devm_gpiod_get_optional(imx335->dev, "reset",
-						     GPIOD_OUT_LOW);
+						     GPIOD_OUT_HIGH);
 	if (IS_ERR(imx335->reset_gpio)) {
 		dev_err(imx335->dev, "failed to get reset gpio %ld",
 			PTR_ERR(imx335->reset_gpio));
@@ -898,8 +898,7 @@ static int imx335_power_on(struct device *dev)
 
 	usleep_range(500, 550); /* Tlow */
 
-	/* Set XCLR */
-	gpiod_set_value_cansleep(imx335->reset_gpio, 1);
+	gpiod_set_value_cansleep(imx335->reset_gpio, 0);
 
 	ret = clk_prepare_enable(imx335->inclk);
 	if (ret) {
@@ -912,7 +911,7 @@ static int imx335_power_on(struct device *dev)
 	return 0;
 
 error_reset:
-	gpiod_set_value_cansleep(imx335->reset_gpio, 0);
+	gpiod_set_value_cansleep(imx335->reset_gpio, 1);
 	regulator_bulk_disable(ARRAY_SIZE(imx335_supply_name), imx335->supplies);
 
 	return ret;
@@ -929,7 +928,7 @@ static int imx335_power_off(struct device *dev)
 	struct v4l2_subdev *sd = dev_get_drvdata(dev);
 	struct imx335 *imx335 = to_imx335(sd);
 
-	gpiod_set_value_cansleep(imx335->reset_gpio, 0);
+	gpiod_set_value_cansleep(imx335->reset_gpio, 1);
 	clk_disable_unprepare(imx335->inclk);
 	regulator_bulk_disable(ARRAY_SIZE(imx335_supply_name), imx335->supplies);
 
-- 
2.43.0



