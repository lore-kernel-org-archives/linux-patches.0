Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B92F46D09D;
	Fri,  7 Aug 2026 15:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116437; cv=none; b=NGXWmLu5bQlLDlaIicM4dGwY+lZfzNQ1QbNR/h1d3UwGxVMF3O0+SEJSf6sBSwDMnmZpvT28Nu3odOcNC29NAqiPg0SC/cZcno570j+H9lhZwmGACrA1FK8N1uo1ZtCj5dmg8oHxJ8GDIikI9BC1xt8mniKL47TNYK/OYx2bMAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116437; c=relaxed/simple;
	bh=xesOovYoH9AcL3jml6PU/Iv8iM4J4HLfy7F8wwsfwP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JdbPB4OuiL9LIuhJCi9dpWw1gwsFV4A33JPAlDLnWmxcbA4CDzjRrM+gN3BFYwhGJqK0B/Sc73L/Jgzw02lIFv0qhfOPfNyUvktaqULw5K0Qt9AdaWJpeH2k/8OwwSX8s+ql4kiKrL96LHwmJk0kBVPPSwIqmnBK3z2hhmLwiS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DuacczoF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DuacczoF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B601F000E9;
	Fri,  7 Aug 2026 15:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116436;
	bh=gccDxA5P/pKnlYejy+F1JVSSz5Ioyhvm0AlhSh3UkU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DuacczoFl1ZQ7jMnkb6tR1aWlddFlrWJ2C9BTU6HSmAQhp+SnPlS55upH4+6mgnzd
	 TIjEokSs34vz+WanNw9PfAciPqKV8beq2ovTgl96vnMKCXtkORX/LWvWj2llWyDsxJ
	 PpGSBUATLCD19PoxmdzZoFpm7PD9RIU3zUAVqPgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 231/261] media: i2c: imx219: Calculate crop rectangle dynamically
Date: Fri,  7 Aug 2026 16:39:48 +0200
Message-ID: <20260807143420.359474620@linuxfoundation.org>
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

[ Upstream commit 0af46fbc333d1a52c72823d935590410357bab47 ]

Calculate the crop rectangle size and location dynamically when setting
the format, instead of storing it in the imx219_mode structure. This
removes duplicated information from the mode, to guarantee consistency.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Stable-dep-of: 2c4f1ba73543 ("media: imx219: Fix maximum frame length in lines")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx219.c |   45 +++++++++++++++------------------------------
 1 file changed, 15 insertions(+), 30 deletions(-)

--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -18,6 +18,7 @@
 #include <linux/delay.h>
 #include <linux/gpio/consumer.h>
 #include <linux/i2c.h>
+#include <linux/minmax.h>
 #include <linux/module.h>
 #include <linux/pm_runtime.h>
 #include <linux/regulator/consumer.h>
@@ -161,9 +162,6 @@ struct imx219_mode {
 	/* Frame height */
 	unsigned int height;
 
-	/* Analog crop rectangle. */
-	struct v4l2_rect crop;
-
 	/* V-timing */
 	unsigned int vts_def;
 
@@ -365,12 +363,6 @@ static const struct imx219_mode supporte
 		/* 8MPix 15fps mode */
 		.width = 3280,
 		.height = 2464,
-		.crop = {
-			.left = IMX219_PIXEL_ARRAY_LEFT,
-			.top = IMX219_PIXEL_ARRAY_TOP,
-			.width = 3280,
-			.height = 2464
-		},
 		.vts_def = 3526,
 		.reg_list = {
 			.num_of_regs = ARRAY_SIZE(mode_3280x2464_regs),
@@ -382,12 +374,6 @@ static const struct imx219_mode supporte
 		/* 1080P 30fps cropped */
 		.width = 1920,
 		.height = 1080,
-		.crop = {
-			.left = 688,
-			.top = 700,
-			.width = 1920,
-			.height = 1080
-		},
 		.vts_def = 1763,
 		.reg_list = {
 			.num_of_regs = ARRAY_SIZE(mode_1920_1080_regs),
@@ -399,12 +385,6 @@ static const struct imx219_mode supporte
 		/* 2x2 binned 30fps mode */
 		.width = 1640,
 		.height = 1232,
-		.crop = {
-			.left = IMX219_PIXEL_ARRAY_LEFT,
-			.top = IMX219_PIXEL_ARRAY_TOP,
-			.width = 3280,
-			.height = 2464
-		},
 		.vts_def = 1763,
 		.reg_list = {
 			.num_of_regs = ARRAY_SIZE(mode_1640_1232_regs),
@@ -416,12 +396,6 @@ static const struct imx219_mode supporte
 		/* 640x480 30fps mode */
 		.width = 640,
 		.height = 480,
-		.crop = {
-			.left = 1008,
-			.top = 760,
-			.width = 1280,
-			.height = 960
-		},
 		.vts_def = 1763,
 		.reg_list = {
 			.num_of_regs = ARRAY_SIZE(mode_640_480_regs),
@@ -966,6 +940,7 @@ static int imx219_set_pad_format(struct
 	int exposure_max, exposure_def, hblank;
 	struct v4l2_mbus_framefmt *format;
 	struct v4l2_rect *crop;
+	unsigned int bin_h, bin_v;
 
 	mode = v4l2_find_nearest_size(supported_modes,
 				      ARRAY_SIZE(supported_modes),
@@ -975,10 +950,20 @@ static int imx219_set_pad_format(struct
 	imx219_update_pad_format(imx219, mode, &fmt->format, fmt->format.code);
 
 	format = v4l2_subdev_get_pad_format(sd, sd_state, 0);
-	crop = v4l2_subdev_get_pad_crop(sd, sd_state, 0);
-
 	*format = fmt->format;
-	*crop = mode->crop;
+
+	/*
+	 * Use binning to maximize the crop rectangle size, and centre it in the
+	 * sensor.
+	 */
+	bin_h = min(IMX219_PIXEL_ARRAY_WIDTH / format->width, 2U);
+	bin_v = min(IMX219_PIXEL_ARRAY_HEIGHT / format->height, 2U);
+
+	crop = v4l2_subdev_get_pad_crop(sd, sd_state, 0);
+	crop->width = format->width * bin_h;
+	crop->height = format->height * bin_v;
+	crop->left = (IMX219_NATIVE_WIDTH - crop->width) / 2;
+	crop->top = (IMX219_NATIVE_HEIGHT - crop->height) / 2;
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
 		imx219->mode = mode;


