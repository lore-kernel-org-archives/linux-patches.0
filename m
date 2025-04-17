Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA401EB1BF;
	Thu, 17 Apr 2025 18:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913169; cv=none; b=s60gLbzy4D+9i1661BtPaG199MKgSz5BMoimRMN07zafOgceaP2PXipSRuEIQst87cO1Lh8FjurzgoOH4y3EAQpQgJ/HdVfsNtfRPui+fiG4aVdh4NKU2iNjBnGRppaqx2NbWfsXziW4WUyD8Hi0W90I+Gk4ZcZmupOj3FuRkG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913169; c=relaxed/simple;
	bh=YcsqoRSnTEhw2rN+5s6Yyh8Fgd28m2cv+HRQPbQZOP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dqeu/G6KDHJ7feBOsMWpgDxFIG79lbbkAGm3TjSr8Z6eCv+kV0xFW5TxaLR1ZfnVJj25sjxYUyXbx1VzQhLj3n0M3dZ3R3eHcb7SGgglZofft+uW6HysCvboEk6mVLXdG3ZW4JYOJlgIAVrNWtM8htLbPG7oi4uzsA5eOUe5060=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EIjnLcDG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EIjnLcDG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF4CC4CEE4;
	Thu, 17 Apr 2025 18:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913169;
	bh=YcsqoRSnTEhw2rN+5s6Yyh8Fgd28m2cv+HRQPbQZOP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EIjnLcDGBt04AF23T65b8/qB5fMHEmQgSr7T1C5/DI/ZM0IN2iXVa23gMkM+jy/dO
	 IgMQHtx7QRxFRPza5RuTxDTPcpQm5hYtmjXYN4FZRen9qRh0fKuZGv1B0o0liKuHhd
	 7W6+kMbj8RhFe+vlRFgZwrXdQF+GTXbvIO4yuODU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peyton Howe <peyton.howe@bellsouth.net>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.14 249/449] media: imx219: Adjust PLL settings based on the number of MIPI lanes
Date: Thu, 17 Apr 2025 19:48:57 +0200
Message-ID: <20250417175128.017801961@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

commit 591a07588c03437dbcc3addfff07675de95a461e upstream.

Commit ceddfd4493b3 ("media: i2c: imx219: Support four-lane operation")
added support for device tree to allow configuration of the sensor to
use 4 lanes with a link frequency of 363MHz, and amended the advertised
pixel rate to 280.8MPix/s.

However it didn't change any of the PLL settings, so actually it would
have been running overclocked in the MIPI block, and with the frame
rate and exposure calculations being wrong as the pixel rate was
unchanged.

The pixel rate and link frequency advertised were taken from the "Clock
Setting Example" section of the datasheet. However those are based on an
external clock of 12MHz, and are unachievable with a clock of 24MHz - it
seems PREPLLCLK_VT_DIV and PREPLLCK_OP_DIV can ONLY be set via the
automatic configuration documented in "9-1-2 EXCK_FREQ setting depend on
INCK frequency", not by writing the registers.
The closest we can get with a 24MHz clock is 281.6MPix/s and 364MHz.

Dropping all support for the 363MHz link frequency would cause problems
for existing users, so allow it, but log a warning that the requested
value is being changed to the supported one.

Fixes: ceddfd4493b3 ("media: i2c: imx219: Support four-lane operation")
Cc: stable@vger.kernel.org
Co-developed-by: Peyton Howe <peyton.howe@bellsouth.net>
Signed-off-by: Peyton Howe <peyton.howe@bellsouth.net>
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx219.c |   93 +++++++++++++++++++++++++++++++++------------
 1 file changed, 69 insertions(+), 24 deletions(-)

--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -133,10 +133,11 @@
 
 /* Pixel rate is fixed for all the modes */
 #define IMX219_PIXEL_RATE		182400000
-#define IMX219_PIXEL_RATE_4LANE		280800000
+#define IMX219_PIXEL_RATE_4LANE		281600000
 
 #define IMX219_DEFAULT_LINK_FREQ	456000000
-#define IMX219_DEFAULT_LINK_FREQ_4LANE	363000000
+#define IMX219_DEFAULT_LINK_FREQ_4LANE_UNSUPPORTED	363000000
+#define IMX219_DEFAULT_LINK_FREQ_4LANE	364000000
 
 /* IMX219 native and active pixel array size. */
 #define IMX219_NATIVE_WIDTH		3296U
@@ -168,15 +169,6 @@ static const struct cci_reg_sequence imx
 	{ CCI_REG8(0x30eb), 0x05 },
 	{ CCI_REG8(0x30eb), 0x09 },
 
-	/* PLL Clock Table */
-	{ IMX219_REG_VTPXCK_DIV, 5 },
-	{ IMX219_REG_VTSYCK_DIV, 1 },
-	{ IMX219_REG_PREPLLCK_VT_DIV, 3 },	/* 0x03 = AUTO set */
-	{ IMX219_REG_PREPLLCK_OP_DIV, 3 },	/* 0x03 = AUTO set */
-	{ IMX219_REG_PLL_VT_MPY, 57 },
-	{ IMX219_REG_OPSYCK_DIV, 1 },
-	{ IMX219_REG_PLL_OP_MPY, 114 },
-
 	/* Undocumented registers */
 	{ CCI_REG8(0x455e), 0x00 },
 	{ CCI_REG8(0x471e), 0x4b },
@@ -201,12 +193,45 @@ static const struct cci_reg_sequence imx
 	{ IMX219_REG_EXCK_FREQ, IMX219_EXCK_FREQ(IMX219_XCLK_FREQ / 1000000) },
 };
 
+static const struct cci_reg_sequence imx219_2lane_regs[] = {
+	/* PLL Clock Table */
+	{ IMX219_REG_VTPXCK_DIV, 5 },
+	{ IMX219_REG_VTSYCK_DIV, 1 },
+	{ IMX219_REG_PREPLLCK_VT_DIV, 3 },	/* 0x03 = AUTO set */
+	{ IMX219_REG_PREPLLCK_OP_DIV, 3 },	/* 0x03 = AUTO set */
+	{ IMX219_REG_PLL_VT_MPY, 57 },
+	{ IMX219_REG_OPSYCK_DIV, 1 },
+	{ IMX219_REG_PLL_OP_MPY, 114 },
+
+	/* 2-Lane CSI Mode */
+	{ IMX219_REG_CSI_LANE_MODE, IMX219_CSI_2_LANE_MODE },
+};
+
+static const struct cci_reg_sequence imx219_4lane_regs[] = {
+	/* PLL Clock Table */
+	{ IMX219_REG_VTPXCK_DIV, 5 },
+	{ IMX219_REG_VTSYCK_DIV, 1 },
+	{ IMX219_REG_PREPLLCK_VT_DIV, 3 },	/* 0x03 = AUTO set */
+	{ IMX219_REG_PREPLLCK_OP_DIV, 3 },	/* 0x03 = AUTO set */
+	{ IMX219_REG_PLL_VT_MPY, 88 },
+	{ IMX219_REG_OPSYCK_DIV, 1 },
+	{ IMX219_REG_PLL_OP_MPY, 91 },
+
+	/* 4-Lane CSI Mode */
+	{ IMX219_REG_CSI_LANE_MODE, IMX219_CSI_4_LANE_MODE },
+};
+
 static const s64 imx219_link_freq_menu[] = {
 	IMX219_DEFAULT_LINK_FREQ,
 };
 
 static const s64 imx219_link_freq_4lane_menu[] = {
 	IMX219_DEFAULT_LINK_FREQ_4LANE,
+	/*
+	 * This will never be advertised to userspace, but will be used for
+	 * v4l2_link_freq_to_bitmap
+	 */
+	IMX219_DEFAULT_LINK_FREQ_4LANE_UNSUPPORTED,
 };
 
 static const char * const imx219_test_pattern_menu[] = {
@@ -662,9 +687,11 @@ static int imx219_set_framefmt(struct im
 
 static int imx219_configure_lanes(struct imx219 *imx219)
 {
-	return cci_write(imx219->regmap, IMX219_REG_CSI_LANE_MODE,
-			 imx219->lanes == 2 ? IMX219_CSI_2_LANE_MODE :
-			 IMX219_CSI_4_LANE_MODE, NULL);
+	/* Write the appropriate PLL settings for the number of MIPI lanes */
+	return cci_multi_reg_write(imx219->regmap,
+				  imx219->lanes == 2 ? imx219_2lane_regs : imx219_4lane_regs,
+				  imx219->lanes == 2 ? ARRAY_SIZE(imx219_2lane_regs) :
+				  ARRAY_SIZE(imx219_4lane_regs), NULL);
 };
 
 static int imx219_start_streaming(struct imx219 *imx219,
@@ -1035,6 +1062,7 @@ static int imx219_check_hwcfg(struct dev
 	struct v4l2_fwnode_endpoint ep_cfg = {
 		.bus_type = V4L2_MBUS_CSI2_DPHY
 	};
+	unsigned long link_freq_bitmap;
 	int ret = -EINVAL;
 
 	endpoint = fwnode_graph_get_next_endpoint(dev_fwnode(dev), NULL);
@@ -1056,23 +1084,40 @@ static int imx219_check_hwcfg(struct dev
 	imx219->lanes = ep_cfg.bus.mipi_csi2.num_data_lanes;
 
 	/* Check the link frequency set in device tree */
-	if (!ep_cfg.nr_of_link_frequencies) {
-		dev_err_probe(dev, -EINVAL,
-			      "link-frequency property not found in DT\n");
-		goto error_out;
+	switch (imx219->lanes) {
+	case 2:
+		ret = v4l2_link_freq_to_bitmap(dev,
+					       ep_cfg.link_frequencies,
+					       ep_cfg.nr_of_link_frequencies,
+					       imx219_link_freq_menu,
+					       ARRAY_SIZE(imx219_link_freq_menu),
+					       &link_freq_bitmap);
+		break;
+	case 4:
+		ret = v4l2_link_freq_to_bitmap(dev,
+					       ep_cfg.link_frequencies,
+					       ep_cfg.nr_of_link_frequencies,
+					       imx219_link_freq_4lane_menu,
+					       ARRAY_SIZE(imx219_link_freq_4lane_menu),
+					       &link_freq_bitmap);
+
+		if (!ret && (link_freq_bitmap & BIT(1))) {
+			dev_warn(dev, "Link frequency of %d not supported, but has been incorrectly advertised previously\n",
+				 IMX219_DEFAULT_LINK_FREQ_4LANE_UNSUPPORTED);
+			dev_warn(dev, "Using link frequency of %d\n",
+				 IMX219_DEFAULT_LINK_FREQ_4LANE);
+			link_freq_bitmap |= BIT(0);
+		}
+		break;
 	}
 
-	if (ep_cfg.nr_of_link_frequencies != 1 ||
-	   (ep_cfg.link_frequencies[0] != ((imx219->lanes == 2) ?
-	    IMX219_DEFAULT_LINK_FREQ : IMX219_DEFAULT_LINK_FREQ_4LANE))) {
+	if (ret || !(link_freq_bitmap & BIT(0))) {
+		ret = -EINVAL;
 		dev_err_probe(dev, -EINVAL,
 			      "Link frequency not supported: %lld\n",
 			      ep_cfg.link_frequencies[0]);
-		goto error_out;
 	}
 
-	ret = 0;
-
 error_out:
 	v4l2_fwnode_endpoint_free(&ep_cfg);
 	fwnode_handle_put(endpoint);


