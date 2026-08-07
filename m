Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEB0371D1F;
	Fri,  7 Aug 2026 15:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116435; cv=none; b=NDVkzZo/C7qnsGSNFl526O3UNcIoWV6bK0WLg5baAZp5otIA5Qs8eBWcUmCyfwhabPMcaRQRv35OML/8/Rppa8iwqzZ+qilThHUB9sEiByFHUMxcokckf7n3pcqx+jSUQvxGWxQBs1WBAHV7dPK106+MiGeJpwpm50w4/WvacBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116435; c=relaxed/simple;
	bh=PSU8SQfVoRe8eewXZ/fLgMv+CyjbjanzfUUjbWEGO8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXp/+MqTDOkEIICNtHyae1ulp4MoCcmNjB0wij9T9WY/4Z2rBBCxHhbaPX8BuDPb/fsUCwrr41dcXyz3qcadgJgf419hyfPTbJH2zcSDLhAzKHK5+k7qQ+WmKLmf4MB9sxb5Ky/6OtNGEQ/HHl/I1KPkaLLQOajkK6lcFvBYHSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qk0WDTWd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qk0WDTWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D404F1F000E9;
	Fri,  7 Aug 2026 15:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116433;
	bh=argWYgzz7dymdwiAx6hkmRQYp8Uzzmsr8IEH4iaorIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qk0WDTWdcl+SymawgdUUfIA5cC/39VwCYTy8JOqzCVVPlV87mR6PFiyPE0etQ92Uk
	 vhxkHNlY8pxLXCCYiND7K6Dw86K4kwbbSKFnzCPFP26oSF4iKIWPyTXK1/dpE2J+Gt
	 o+KYXuhWBBOGD91frbArMjsFv8PFnYgdY9FplkvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 230/261] media: i2c: imx219: Group functions by purpose
Date: Fri,  7 Aug 2026 16:39:47 +0200
Message-ID: <20260807143420.336437104@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit d03dfb7d4c5fae0d3f297536063e00ea2c1129d5 ]

Move functions around to group them by purpose, in order to improve
readability. No functional change is intended.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Stable-dep-of: 2c4f1ba73543 ("media: imx219: Fix maximum frame length in lines")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx219.c |  580 +++++++++++++++++++++++----------------------
 1 file changed, 298 insertions(+), 282 deletions(-)

--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -485,6 +485,10 @@ static u32 imx219_get_format_code(struct
 	return imx219_mbus_formats[i];
 }
 
+/* -----------------------------------------------------------------------------
+ * Controls
+ */
+
 static int imx219_set_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct imx219 *imx219 =
@@ -576,130 +580,135 @@ static const struct v4l2_ctrl_ops imx219
 	.s_ctrl = imx219_set_ctrl,
 };
 
-static void imx219_update_pad_format(struct imx219 *imx219,
-				     const struct imx219_mode *mode,
-				     struct v4l2_mbus_framefmt *fmt, u32 code)
+static unsigned long imx219_get_pixel_rate(struct imx219 *imx219)
 {
-	/* Bayer order varies with flips */
-	fmt->code = imx219_get_format_code(imx219, code);
-	fmt->width = mode->width;
-	fmt->height = mode->height;
-	fmt->field = V4L2_FIELD_NONE;
-	fmt->colorspace = V4L2_COLORSPACE_RAW;
-	fmt->quantization = V4L2_QUANTIZATION_FULL_RANGE;
-	fmt->xfer_func = V4L2_XFER_FUNC_NONE;
+	return (imx219->lanes == 2) ? IMX219_PIXEL_RATE : IMX219_PIXEL_RATE_4LANE;
 }
 
-static int imx219_init_cfg(struct v4l2_subdev *sd,
-			   struct v4l2_subdev_state *state)
+/* Initialize control handlers */
+static int imx219_init_controls(struct imx219 *imx219)
 {
-	struct imx219 *imx219 = to_imx219(sd);
-	struct v4l2_mbus_framefmt *format;
-	struct v4l2_rect *crop;
-
-	/* Initialize the format. */
-	format = v4l2_subdev_get_pad_format(sd, state, 0);
-	imx219_update_pad_format(imx219, &supported_modes[0], format,
-				 MEDIA_BUS_FMT_SRGGB10_1X10);
-
-	/* Initialize the crop rectangle. */
-	crop = v4l2_subdev_get_pad_crop(sd, state, 0);
-	crop->top = IMX219_PIXEL_ARRAY_TOP;
-	crop->left = IMX219_PIXEL_ARRAY_LEFT;
-	crop->width = IMX219_PIXEL_ARRAY_WIDTH;
-	crop->height = IMX219_PIXEL_ARRAY_HEIGHT;
+	struct i2c_client *client = v4l2_get_subdevdata(&imx219->sd);
+	const struct imx219_mode *mode = &supported_modes[0];
+	struct v4l2_ctrl_handler *ctrl_hdlr;
+	struct v4l2_fwnode_device_properties props;
+	int exposure_max, exposure_def, hblank;
+	int i, ret;
 
-	return 0;
-}
+	ctrl_hdlr = &imx219->ctrl_handler;
+	ret = v4l2_ctrl_handler_init(ctrl_hdlr, 12);
+	if (ret)
+		return ret;
 
-static int imx219_enum_mbus_code(struct v4l2_subdev *sd,
-				 struct v4l2_subdev_state *sd_state,
-				 struct v4l2_subdev_mbus_code_enum *code)
-{
-	struct imx219 *imx219 = to_imx219(sd);
+	/* By default, PIXEL_RATE is read only */
+	imx219->pixel_rate = v4l2_ctrl_new_std(ctrl_hdlr, &imx219_ctrl_ops,
+					       V4L2_CID_PIXEL_RATE,
+					       imx219_get_pixel_rate(imx219),
+					       imx219_get_pixel_rate(imx219), 1,
+					       imx219_get_pixel_rate(imx219));
 
-	if (code->index >= (ARRAY_SIZE(imx219_mbus_formats) / 4))
-		return -EINVAL;
+	imx219->link_freq =
+		v4l2_ctrl_new_int_menu(ctrl_hdlr, &imx219_ctrl_ops,
+				       V4L2_CID_LINK_FREQ,
+				       ARRAY_SIZE(imx219_link_freq_menu) - 1, 0,
+				       (imx219->lanes == 2) ? imx219_link_freq_menu :
+				       imx219_link_freq_4lane_menu);
+	if (imx219->link_freq)
+		imx219->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
 
-	code->code = imx219_get_format_code(imx219, imx219_mbus_formats[code->index * 4]);
+	/* Initial vblank/hblank/exposure parameters based on current mode */
+	imx219->vblank = v4l2_ctrl_new_std(ctrl_hdlr, &imx219_ctrl_ops,
+					   V4L2_CID_VBLANK, IMX219_VBLANK_MIN,
+					   IMX219_VTS_MAX - mode->height, 1,
+					   mode->vts_def - mode->height);
+	hblank = IMX219_PPL_DEFAULT - mode->width;
+	imx219->hblank = v4l2_ctrl_new_std(ctrl_hdlr, &imx219_ctrl_ops,
+					   V4L2_CID_HBLANK, hblank, hblank,
+					   1, hblank);
+	if (imx219->hblank)
+		imx219->hblank->flags |= V4L2_CTRL_FLAG_READ_ONLY;
+	exposure_max = mode->vts_def - 4;
+	exposure_def = (exposure_max < IMX219_EXPOSURE_DEFAULT) ?
+		exposure_max : IMX219_EXPOSURE_DEFAULT;
+	imx219->exposure = v4l2_ctrl_new_std(ctrl_hdlr, &imx219_ctrl_ops,
+					     V4L2_CID_EXPOSURE,
+					     IMX219_EXPOSURE_MIN, exposure_max,
+					     IMX219_EXPOSURE_STEP,
+					     exposure_def);
 
-	return 0;
-}
+	v4l2_ctrl_new_std(ctrl_hdlr, &imx219_ctrl_ops, V4L2_CID_ANALOGUE_GAIN,
+			  IMX219_ANA_GAIN_MIN, IMX219_ANA_GAIN_MAX,
+			  IMX219_ANA_GAIN_STEP, IMX219_ANA_GAIN_DEFAULT);
 
-static int imx219_enum_frame_size(struct v4l2_subdev *sd,
-				  struct v4l2_subdev_state *sd_state,
-				  struct v4l2_subdev_frame_size_enum *fse)
-{
-	struct imx219 *imx219 = to_imx219(sd);
-	u32 code;
+	v4l2_ctrl_new_std(ctrl_hdlr, &imx219_ctrl_ops, V4L2_CID_DIGITAL_GAIN,
+			  IMX219_DGTL_GAIN_MIN, IMX219_DGTL_GAIN_MAX,
+			  IMX219_DGTL_GAIN_STEP, IMX219_DGTL_GAIN_DEFAULT);
 
-	if (fse->index >= ARRAY_SIZE(supported_modes))
-		return -EINVAL;
+	imx219->hflip = v4l2_ctrl_new_std(ctrl_hdlr, &imx219_ctrl_ops,
+					  V4L2_CID_HFLIP, 0, 1, 1, 0);
+	if (imx219->hflip)
+		imx219->hflip->flags |= V4L2_CTRL_FLAG_MODIFY_LAYOUT;
 
-	code = imx219_get_format_code(imx219, fse->code);
-	if (fse->code != code)
-		return -EINVAL;
+	imx219->vflip = v4l2_ctrl_new_std(ctrl_hdlr, &imx219_ctrl_ops,
+					  V4L2_CID_VFLIP, 0, 1, 1, 0);
+	if (imx219->vflip)
+		imx219->vflip->flags |= V4L2_CTRL_FLAG_MODIFY_LAYOUT;
 
-	fse->min_width = supported_modes[fse->index].width;
-	fse->max_width = fse->min_width;
-	fse->min_height = supported_modes[fse->index].height;
-	fse->max_height = fse->min_height;
+	v4l2_ctrl_new_std_menu_items(ctrl_hdlr, &imx219_ctrl_ops,
+				     V4L2_CID_TEST_PATTERN,
+				     ARRAY_SIZE(imx219_test_pattern_menu) - 1,
+				     0, 0, imx219_test_pattern_menu);
+	for (i = 0; i < 4; i++) {
+		/*
+		 * The assumption is that
+		 * V4L2_CID_TEST_PATTERN_GREENR == V4L2_CID_TEST_PATTERN_RED + 1
+		 * V4L2_CID_TEST_PATTERN_BLUE   == V4L2_CID_TEST_PATTERN_RED + 2
+		 * V4L2_CID_TEST_PATTERN_GREENB == V4L2_CID_TEST_PATTERN_RED + 3
+		 */
+		v4l2_ctrl_new_std(ctrl_hdlr, &imx219_ctrl_ops,
+				  V4L2_CID_TEST_PATTERN_RED + i,
+				  IMX219_TESTP_COLOUR_MIN,
+				  IMX219_TESTP_COLOUR_MAX,
+				  IMX219_TESTP_COLOUR_STEP,
+				  IMX219_TESTP_COLOUR_MAX);
+		/* The "Solid color" pattern is white by default */
+	}
 
-	return 0;
-}
+	if (ctrl_hdlr->error) {
+		ret = ctrl_hdlr->error;
+		dev_err(&client->dev, "%s control init failed (%d)\n",
+			__func__, ret);
+		goto error;
+	}
 
-static int imx219_set_pad_format(struct v4l2_subdev *sd,
-				 struct v4l2_subdev_state *sd_state,
-				 struct v4l2_subdev_format *fmt)
-{
-	struct imx219 *imx219 = to_imx219(sd);
-	const struct imx219_mode *mode;
-	int exposure_max, exposure_def, hblank;
-	struct v4l2_mbus_framefmt *format;
-	struct v4l2_rect *crop;
+	ret = v4l2_fwnode_device_parse(&client->dev, &props);
+	if (ret)
+		goto error;
 
-	mode = v4l2_find_nearest_size(supported_modes,
-				      ARRAY_SIZE(supported_modes),
-				      width, height,
-				      fmt->format.width, fmt->format.height);
+	ret = v4l2_ctrl_new_fwnode_properties(ctrl_hdlr, &imx219_ctrl_ops,
+					      &props);
+	if (ret)
+		goto error;
 
-	imx219_update_pad_format(imx219, mode, &fmt->format, fmt->format.code);
+	imx219->sd.ctrl_handler = ctrl_hdlr;
 
-	format = v4l2_subdev_get_pad_format(sd, sd_state, 0);
-	crop = v4l2_subdev_get_pad_crop(sd, sd_state, 0);
+	return 0;
 
-	*format = fmt->format;
-	*crop = mode->crop;
+error:
+	v4l2_ctrl_handler_free(ctrl_hdlr);
 
-	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
-		imx219->mode = mode;
-		/* Update limits and set FPS to default */
-		__v4l2_ctrl_modify_range(imx219->vblank, IMX219_VBLANK_MIN,
-					 IMX219_VTS_MAX - mode->height, 1,
-					 mode->vts_def - mode->height);
-		__v4l2_ctrl_s_ctrl(imx219->vblank,
-				   mode->vts_def - mode->height);
-		/* Update max exposure while meeting expected vblanking */
-		exposure_max = mode->vts_def - 4;
-		exposure_def = (exposure_max < IMX219_EXPOSURE_DEFAULT) ?
-			exposure_max : IMX219_EXPOSURE_DEFAULT;
-		__v4l2_ctrl_modify_range(imx219->exposure,
-					 imx219->exposure->minimum,
-					 exposure_max, imx219->exposure->step,
-					 exposure_def);
-		/*
-		 * Currently PPL is fixed to IMX219_PPL_DEFAULT, so hblank
-		 * depends on mode->width only, and is not changeble in any
-		 * way other than changing the mode.
-		 */
-		hblank = IMX219_PPL_DEFAULT - mode->width;
-		__v4l2_ctrl_modify_range(imx219->hblank, hblank, hblank, 1,
-					 hblank);
-	}
+	return ret;
+}
 
-	return 0;
+static void imx219_free_controls(struct imx219 *imx219)
+{
+	v4l2_ctrl_handler_free(imx219->sd.ctrl_handler);
 }
 
+/* -----------------------------------------------------------------------------
+ * Subdev operations
+ */
+
 static int imx219_set_framefmt(struct imx219 *imx219,
 			       const struct v4l2_mbus_framefmt *format)
 {
@@ -748,37 +757,6 @@ static int imx219_set_binning(struct imx
 	return -EINVAL;
 }
 
-static int imx219_get_selection(struct v4l2_subdev *sd,
-				struct v4l2_subdev_state *sd_state,
-				struct v4l2_subdev_selection *sel)
-{
-	switch (sel->target) {
-	case V4L2_SEL_TGT_CROP: {
-		sel->r = *v4l2_subdev_get_pad_crop(sd, sd_state, 0);
-		return 0;
-	}
-
-	case V4L2_SEL_TGT_NATIVE_SIZE:
-		sel->r.top = 0;
-		sel->r.left = 0;
-		sel->r.width = IMX219_NATIVE_WIDTH;
-		sel->r.height = IMX219_NATIVE_HEIGHT;
-
-		return 0;
-
-	case V4L2_SEL_TGT_CROP_DEFAULT:
-	case V4L2_SEL_TGT_CROP_BOUNDS:
-		sel->r.top = IMX219_PIXEL_ARRAY_TOP;
-		sel->r.left = IMX219_PIXEL_ARRAY_LEFT;
-		sel->r.width = IMX219_PIXEL_ARRAY_WIDTH;
-		sel->r.height = IMX219_PIXEL_ARRAY_HEIGHT;
-
-		return 0;
-	}
-
-	return -EINVAL;
-}
-
 static int imx219_configure_lanes(struct imx219 *imx219)
 {
 	return cci_write(imx219->regmap, IMX219_REG_CSI_LANE_MODE,
@@ -907,6 +885,190 @@ unlock:
 }
 
 /* Power/clock management functions */
+static void imx219_update_pad_format(struct imx219 *imx219,
+				     const struct imx219_mode *mode,
+				     struct v4l2_mbus_framefmt *fmt, u32 code)
+{
+	/* Bayer order varies with flips */
+	fmt->code = imx219_get_format_code(imx219, code);
+	fmt->width = mode->width;
+	fmt->height = mode->height;
+	fmt->field = V4L2_FIELD_NONE;
+	fmt->colorspace = V4L2_COLORSPACE_RAW;
+	fmt->quantization = V4L2_QUANTIZATION_FULL_RANGE;
+	fmt->xfer_func = V4L2_XFER_FUNC_NONE;
+}
+
+static int imx219_init_cfg(struct v4l2_subdev *sd,
+			   struct v4l2_subdev_state *state)
+{
+	struct imx219 *imx219 = to_imx219(sd);
+	struct v4l2_mbus_framefmt *format;
+	struct v4l2_rect *crop;
+
+	/* Initialize the format. */
+	format = v4l2_subdev_get_pad_format(sd, state, 0);
+	imx219_update_pad_format(imx219, &supported_modes[0], format,
+				 MEDIA_BUS_FMT_SRGGB10_1X10);
+
+	/* Initialize the crop rectangle. */
+	crop = v4l2_subdev_get_pad_crop(sd, state, 0);
+	crop->top = IMX219_PIXEL_ARRAY_TOP;
+	crop->left = IMX219_PIXEL_ARRAY_LEFT;
+	crop->width = IMX219_PIXEL_ARRAY_WIDTH;
+	crop->height = IMX219_PIXEL_ARRAY_HEIGHT;
+
+	return 0;
+}
+
+static int imx219_enum_mbus_code(struct v4l2_subdev *sd,
+				 struct v4l2_subdev_state *sd_state,
+				 struct v4l2_subdev_mbus_code_enum *code)
+{
+	struct imx219 *imx219 = to_imx219(sd);
+
+	if (code->index >= (ARRAY_SIZE(imx219_mbus_formats) / 4))
+		return -EINVAL;
+
+	code->code = imx219_get_format_code(imx219, imx219_mbus_formats[code->index * 4]);
+
+	return 0;
+}
+
+static int imx219_enum_frame_size(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_state *sd_state,
+				  struct v4l2_subdev_frame_size_enum *fse)
+{
+	struct imx219 *imx219 = to_imx219(sd);
+	u32 code;
+
+	if (fse->index >= ARRAY_SIZE(supported_modes))
+		return -EINVAL;
+
+	code = imx219_get_format_code(imx219, fse->code);
+	if (fse->code != code)
+		return -EINVAL;
+
+	fse->min_width = supported_modes[fse->index].width;
+	fse->max_width = fse->min_width;
+	fse->min_height = supported_modes[fse->index].height;
+	fse->max_height = fse->min_height;
+
+	return 0;
+}
+
+static int imx219_set_pad_format(struct v4l2_subdev *sd,
+				 struct v4l2_subdev_state *sd_state,
+				 struct v4l2_subdev_format *fmt)
+{
+	struct imx219 *imx219 = to_imx219(sd);
+	const struct imx219_mode *mode;
+	int exposure_max, exposure_def, hblank;
+	struct v4l2_mbus_framefmt *format;
+	struct v4l2_rect *crop;
+
+	mode = v4l2_find_nearest_size(supported_modes,
+				      ARRAY_SIZE(supported_modes),
+				      width, height,
+				      fmt->format.width, fmt->format.height);
+
+	imx219_update_pad_format(imx219, mode, &fmt->format, fmt->format.code);
+
+	format = v4l2_subdev_get_pad_format(sd, sd_state, 0);
+	crop = v4l2_subdev_get_pad_crop(sd, sd_state, 0);
+
+	*format = fmt->format;
+	*crop = mode->crop;
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+		imx219->mode = mode;
+		/* Update limits and set FPS to default */
+		__v4l2_ctrl_modify_range(imx219->vblank, IMX219_VBLANK_MIN,
+					 IMX219_VTS_MAX - mode->height, 1,
+					 mode->vts_def - mode->height);
+		__v4l2_ctrl_s_ctrl(imx219->vblank,
+				   mode->vts_def - mode->height);
+		/* Update max exposure while meeting expected vblanking */
+		exposure_max = mode->vts_def - 4;
+		exposure_def = (exposure_max < IMX219_EXPOSURE_DEFAULT) ?
+			exposure_max : IMX219_EXPOSURE_DEFAULT;
+		__v4l2_ctrl_modify_range(imx219->exposure,
+					 imx219->exposure->minimum,
+					 exposure_max, imx219->exposure->step,
+					 exposure_def);
+		/*
+		 * Currently PPL is fixed to IMX219_PPL_DEFAULT, so hblank
+		 * depends on mode->width only, and is not changeble in any
+		 * way other than changing the mode.
+		 */
+		hblank = IMX219_PPL_DEFAULT - mode->width;
+		__v4l2_ctrl_modify_range(imx219->hblank, hblank, hblank, 1,
+					 hblank);
+	}
+
+	return 0;
+}
+
+static int imx219_get_selection(struct v4l2_subdev *sd,
+				struct v4l2_subdev_state *sd_state,
+				struct v4l2_subdev_selection *sel)
+{
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP: {
+		sel->r = *v4l2_subdev_get_pad_crop(sd, sd_state, 0);
+		return 0;
+	}
+
+	case V4L2_SEL_TGT_NATIVE_SIZE:
+		sel->r.top = 0;
+		sel->r.left = 0;
+		sel->r.width = IMX219_NATIVE_WIDTH;
+		sel->r.height = IMX219_NATIVE_HEIGHT;
+
+		return 0;
+
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+		sel->r.top = IMX219_PIXEL_ARRAY_TOP;
+		sel->r.left = IMX219_PIXEL_ARRAY_LEFT;
+		sel->r.width = IMX219_PIXEL_ARRAY_WIDTH;
+		sel->r.height = IMX219_PIXEL_ARRAY_HEIGHT;
+
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static const struct v4l2_subdev_core_ops imx219_core_ops = {
+	.subscribe_event = v4l2_ctrl_subdev_subscribe_event,
+	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
+};
+
+static const struct v4l2_subdev_video_ops imx219_video_ops = {
+	.s_stream = imx219_set_stream,
+};
+
+static const struct v4l2_subdev_pad_ops imx219_pad_ops = {
+	.init_cfg = imx219_init_cfg,
+	.enum_mbus_code = imx219_enum_mbus_code,
+	.get_fmt = v4l2_subdev_get_fmt,
+	.set_fmt = imx219_set_pad_format,
+	.get_selection = imx219_get_selection,
+	.enum_frame_size = imx219_enum_frame_size,
+};
+
+static const struct v4l2_subdev_ops imx219_subdev_ops = {
+	.core = &imx219_core_ops,
+	.video = &imx219_video_ops,
+	.pad = &imx219_pad_ops,
+};
+
+
+/* -----------------------------------------------------------------------------
+ * Power management
+ */
+
 static int imx219_power_on(struct device *dev)
 {
 	struct v4l2_subdev *sd = dev_get_drvdata(dev);
@@ -987,6 +1149,10 @@ error:
 	return ret;
 }
 
+/* -----------------------------------------------------------------------------
+ * Probe & remove
+ */
+
 static int imx219_get_regulators(struct imx219 *imx219)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&imx219->sd);
@@ -1023,156 +1189,6 @@ static int imx219_identify_module(struct
 	return 0;
 }
 
-static const struct v4l2_subdev_core_ops imx219_core_ops = {
-	.subscribe_event = v4l2_ctrl_subdev_subscribe_event,
-	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
-};
-
-static const struct v4l2_subdev_video_ops imx219_video_ops = {
-	.s_stream = imx219_set_stream,
-};
-
-static const struct v4l2_subdev_pad_ops imx219_pad_ops = {
-	.init_cfg = imx219_init_cfg,
-	.enum_mbus_code = imx219_enum_mbus_code,
-	.get_fmt = v4l2_subdev_get_fmt,
-	.set_fmt = imx219_set_pad_format,
-	.get_selection = imx219_get_selection,
-	.enum_frame_size = imx219_enum_frame_size,
-};
-
-static const struct v4l2_subdev_ops imx219_subdev_ops = {
-	.core = &imx219_core_ops,
-	.video = &imx219_video_ops,
-	.pad = &imx219_pad_ops,
-};
-
-
-static unsigned long imx219_get_pixel_rate(struct imx219 *imx219)
-{
-	return (imx219->lanes == 2) ? IMX219_PIXEL_RATE : IMX219_PIXEL_RATE_4LANE;
-}
-
-/* Initialize control handlers */
-static int imx219_init_controls(struct imx219 *imx219)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(&imx219->sd);
-	const struct imx219_mode *mode = &supported_modes[0];
-	struct v4l2_ctrl_handler *ctrl_hdlr;
-	struct v4l2_fwnode_device_properties props;
-	int exposure_max, exposure_def, hblank;
-	int i, ret;
-
-	ctrl_hdlr = &imx219->ctrl_handler;
-	ret = v4l2_ctrl_handler_init(ctrl_hdlr, 12);
-	if (ret)
-		return ret;
-
-	/* By default, PIXEL_RATE is read only */
-	imx219->pixel_rate = v4l2_ctrl_new_std(ctrl_hdlr, &imx219_ctrl_ops,
-					       V4L2_CID_PIXEL_RATE,
-					       imx219_get_pixel_rate(imx219),
-					       imx219_get_pixel_rate(imx219), 1,
-					       imx219_get_pixel_rate(imx219));
-
-	imx219->link_freq =
-		v4l2_ctrl_new_int_menu(ctrl_hdlr, &imx219_ctrl_ops,
-				       V4L2_CID_LINK_FREQ,
-				       ARRAY_SIZE(imx219_link_freq_menu) - 1, 0,
-				       (imx219->lanes == 2) ? imx219_link_freq_menu :
-				       imx219_link_freq_4lane_menu);
-	if (imx219->link_freq)
-		imx219->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
-
-	/* Initial vblank/hblank/exposure parameters based on current mode */
-	imx219->vblank = v4l2_ctrl_new_std(ctrl_hdlr, &imx219_ctrl_ops,
-					   V4L2_CID_VBLANK, IMX219_VBLANK_MIN,
-					   IMX219_VTS_MAX - mode->height, 1,
-					   mode->vts_def - mode->height);
-	hblank = IMX219_PPL_DEFAULT - mode->width;
-	imx219->hblank = v4l2_ctrl_new_std(ctrl_hdlr, &imx219_ctrl_ops,
-					   V4L2_CID_HBLANK, hblank, hblank,
-					   1, hblank);
-	if (imx219->hblank)
-		imx219->hblank->flags |= V4L2_CTRL_FLAG_READ_ONLY;
-	exposure_max = mode->vts_def - 4;
-	exposure_def = (exposure_max < IMX219_EXPOSURE_DEFAULT) ?
-		exposure_max : IMX219_EXPOSURE_DEFAULT;
-	imx219->exposure = v4l2_ctrl_new_std(ctrl_hdlr, &imx219_ctrl_ops,
-					     V4L2_CID_EXPOSURE,
-					     IMX219_EXPOSURE_MIN, exposure_max,
-					     IMX219_EXPOSURE_STEP,
-					     exposure_def);
-
-	v4l2_ctrl_new_std(ctrl_hdlr, &imx219_ctrl_ops, V4L2_CID_ANALOGUE_GAIN,
-			  IMX219_ANA_GAIN_MIN, IMX219_ANA_GAIN_MAX,
-			  IMX219_ANA_GAIN_STEP, IMX219_ANA_GAIN_DEFAULT);
-
-	v4l2_ctrl_new_std(ctrl_hdlr, &imx219_ctrl_ops, V4L2_CID_DIGITAL_GAIN,
-			  IMX219_DGTL_GAIN_MIN, IMX219_DGTL_GAIN_MAX,
-			  IMX219_DGTL_GAIN_STEP, IMX219_DGTL_GAIN_DEFAULT);
-
-	imx219->hflip = v4l2_ctrl_new_std(ctrl_hdlr, &imx219_ctrl_ops,
-					  V4L2_CID_HFLIP, 0, 1, 1, 0);
-	if (imx219->hflip)
-		imx219->hflip->flags |= V4L2_CTRL_FLAG_MODIFY_LAYOUT;
-
-	imx219->vflip = v4l2_ctrl_new_std(ctrl_hdlr, &imx219_ctrl_ops,
-					  V4L2_CID_VFLIP, 0, 1, 1, 0);
-	if (imx219->vflip)
-		imx219->vflip->flags |= V4L2_CTRL_FLAG_MODIFY_LAYOUT;
-
-	v4l2_ctrl_new_std_menu_items(ctrl_hdlr, &imx219_ctrl_ops,
-				     V4L2_CID_TEST_PATTERN,
-				     ARRAY_SIZE(imx219_test_pattern_menu) - 1,
-				     0, 0, imx219_test_pattern_menu);
-	for (i = 0; i < 4; i++) {
-		/*
-		 * The assumption is that
-		 * V4L2_CID_TEST_PATTERN_GREENR == V4L2_CID_TEST_PATTERN_RED + 1
-		 * V4L2_CID_TEST_PATTERN_BLUE   == V4L2_CID_TEST_PATTERN_RED + 2
-		 * V4L2_CID_TEST_PATTERN_GREENB == V4L2_CID_TEST_PATTERN_RED + 3
-		 */
-		v4l2_ctrl_new_std(ctrl_hdlr, &imx219_ctrl_ops,
-				  V4L2_CID_TEST_PATTERN_RED + i,
-				  IMX219_TESTP_COLOUR_MIN,
-				  IMX219_TESTP_COLOUR_MAX,
-				  IMX219_TESTP_COLOUR_STEP,
-				  IMX219_TESTP_COLOUR_MAX);
-		/* The "Solid color" pattern is white by default */
-	}
-
-	if (ctrl_hdlr->error) {
-		ret = ctrl_hdlr->error;
-		dev_err(&client->dev, "%s control init failed (%d)\n",
-			__func__, ret);
-		goto error;
-	}
-
-	ret = v4l2_fwnode_device_parse(&client->dev, &props);
-	if (ret)
-		goto error;
-
-	ret = v4l2_ctrl_new_fwnode_properties(ctrl_hdlr, &imx219_ctrl_ops,
-					      &props);
-	if (ret)
-		goto error;
-
-	imx219->sd.ctrl_handler = ctrl_hdlr;
-
-	return 0;
-
-error:
-	v4l2_ctrl_handler_free(ctrl_hdlr);
-
-	return ret;
-}
-
-static void imx219_free_controls(struct imx219 *imx219)
-{
-	v4l2_ctrl_handler_free(imx219->sd.ctrl_handler);
-}
-
 static int imx219_check_hwcfg(struct device *dev, struct imx219 *imx219)
 {
 	struct fwnode_handle *endpoint;


