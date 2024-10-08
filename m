Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531FD1C9B99;
	Tue,  8 Oct 2024 13:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392593; cv=none; b=AmRg+TgYluOoLXzH0TuWDPcMDXZG18JvyRfxczjF+wazgQxOengv6q+btun5rW7XQ0yG7X7zRFbF57ZeCGXpC/0zkIe6hffwQm0gfotfHebMkFftuOrG3Z05nMVi0QabK1zi82bPHI9AB+tXIKexz5Ytm+9dcV11f6/aSJmYMbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392593; c=relaxed/simple;
	bh=hjG3JYp/sr90MIYA4T1MyxqmY/Xxc+d8FFC+XbQM2YY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cySHjat24iOj8CM/PIZ3cB75zehzFqg2pEVuuAP+TbasqE2OD/ba2oH6EdZYOgjnKcrFL+05nQkjBDhsAQveX33H6vv9nq7vxGzjPK4BQtlCfTKJyMnZPbO0BSrgPoKuwQLf6IfmQrj4hhOWSF81+3NWIonhAOqlkdjyNrXWGUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NQbQm47C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NQbQm47C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A71C4CED1;
	Tue,  8 Oct 2024 13:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392593;
	bh=hjG3JYp/sr90MIYA4T1MyxqmY/Xxc+d8FFC+XbQM2YY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NQbQm47CjcJdz7OVlDHnDKd0pl7ESmfUv5uSMqwJPqxlgzExTKIjvakjbS8J1pc1M
	 RMOp9kTA/GIV4UqlT0xlEs7qjeuFgdItz3o2cK4HR3wTaVye05BPBbd4JiwPrJmVP5
	 EvdB4Kop20SxMth9sRQuqT03KNc6vlBBOhIfDnxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Umang Jain <umang.jain@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.11 444/558] media: imx335: Fix reset-gpio handling
Date: Tue,  8 Oct 2024 14:07:54 +0200
Message-ID: <20241008115719.737025535@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Umang Jain <umang.jain@ideasonboard.com>

commit 99d30e2fdea4086be4e66e2deb10de854b547ab8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx335.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/media/i2c/imx335.c
+++ b/drivers/media/i2c/imx335.c
@@ -997,7 +997,7 @@ static int imx335_parse_hw_config(struct
 
 	/* Request optional reset pin */
 	imx335->reset_gpio = devm_gpiod_get_optional(imx335->dev, "reset",
-						     GPIOD_OUT_LOW);
+						     GPIOD_OUT_HIGH);
 	if (IS_ERR(imx335->reset_gpio)) {
 		dev_err(imx335->dev, "failed to get reset gpio %ld\n",
 			PTR_ERR(imx335->reset_gpio));
@@ -1110,8 +1110,7 @@ static int imx335_power_on(struct device
 
 	usleep_range(500, 550); /* Tlow */
 
-	/* Set XCLR */
-	gpiod_set_value_cansleep(imx335->reset_gpio, 1);
+	gpiod_set_value_cansleep(imx335->reset_gpio, 0);
 
 	ret = clk_prepare_enable(imx335->inclk);
 	if (ret) {
@@ -1124,7 +1123,7 @@ static int imx335_power_on(struct device
 	return 0;
 
 error_reset:
-	gpiod_set_value_cansleep(imx335->reset_gpio, 0);
+	gpiod_set_value_cansleep(imx335->reset_gpio, 1);
 	regulator_bulk_disable(ARRAY_SIZE(imx335_supply_name), imx335->supplies);
 
 	return ret;
@@ -1141,7 +1140,7 @@ static int imx335_power_off(struct devic
 	struct v4l2_subdev *sd = dev_get_drvdata(dev);
 	struct imx335 *imx335 = to_imx335(sd);
 
-	gpiod_set_value_cansleep(imx335->reset_gpio, 0);
+	gpiod_set_value_cansleep(imx335->reset_gpio, 1);
 	clk_disable_unprepare(imx335->inclk);
 	regulator_bulk_disable(ARRAY_SIZE(imx335_supply_name), imx335->supplies);
 


