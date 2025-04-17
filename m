Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F76185920;
	Thu, 17 Apr 2025 18:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915711; cv=none; b=lNy/PMkQdTDxuayMAcHqtkD929ZdUcfRrt9bt7vf/99PRtGffukevX/EbqHtTRyGnhOm8l7KgL/KF4GQOtgLB3lv4T1x+H3mHPy+FipF/iI6c54HyAdSWB4PSL4AVH09hJLCRWoqps1COnYSz60nhOZRZMRTX7OAu/cpy2omr+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915711; c=relaxed/simple;
	bh=ABUO/B9UuZ+1Hcm2SN03Q5l1l+ze7jLlsEimZukeOJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4a0ptIbF957/BFc3g0Dk1iDmlxz5BIzwgwHuLXYZY6vnCpJvF7z83gq0aJLLzlBEFCzTAKG0rvXgf4o7s+RhXTpv+00zmSLCKQrh5wVl1NunePmHGYNIeKgE90H/KG0eZODvfB9HRyPFyEnLP8t/pZJ0zbbM1TdajaYAlAyr9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ke8OlzDp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ke8OlzDp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E25C4CEE4;
	Thu, 17 Apr 2025 18:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915711;
	bh=ABUO/B9UuZ+1Hcm2SN03Q5l1l+ze7jLlsEimZukeOJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ke8OlzDpPxLyFM1V3mOoUXwQssqkgN4zdD9blZpqLiLYvLtnUbTzrW1rtkJyyPK9M
	 eC8pWMkDsI/KThuc850o46IObRlPlFZnig9b6cW2evF2/u9RLpT2Yi4dVhTL3BFM4e
	 Xk2K3KHkE68+j7I0XDRIdSgOM1BR9qFtCFdp2N6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peyton Howe <peyton.howe@bellsouth.net>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 215/393] media: imx219: Adjust PLL settings based on the number of MIPI lanes
Date: Thu, 17 Apr 2025 19:50:24 +0200
Message-ID: <20250417175116.231509361@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -134,10 +134,11 @@
 
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
@@ -169,15 +170,6 @@ static const struct cci_reg_sequence imx
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
@@ -202,12 +194,45 @@ static const struct cci_reg_sequence imx
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
@@ -663,9 +688,11 @@ static int imx219_set_framefmt(struct im
 
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
@@ -1042,6 +1069,7 @@ static int imx219_check_hwcfg(struct dev
 	struct v4l2_fwnode_endpoint ep_cfg = {
 		.bus_type = V4L2_MBUS_CSI2_DPHY
 	};
+	unsigned long link_freq_bitmap;
 	int ret = -EINVAL;
 
 	endpoint = fwnode_graph_get_next_endpoint(dev_fwnode(dev), NULL);
@@ -1063,23 +1091,40 @@ static int imx219_check_hwcfg(struct dev
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


