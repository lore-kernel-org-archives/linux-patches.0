Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FAA746F
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:29:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158E7C433C7;
	Sun, 17 Sep 2023 20:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982557;
	bh=sKM/uEihpZnQz0+zOetcoYErvj9UbyGztOeewFMgiVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tYJMv0agDxOvrNRWxc//1Tatquj0t/roIj+FkS72M/izrpQbztu/7KXZ+xlUd53R5
	 qqPkUvQNGSB3QmLdylbNjhxiyOvQ4SIuuXMzo4aNNr11NwLkyu8zLy/g8+SChF2nCf
	 xs4ufNmuLGkZRfAfFZEYXUvlCzI2l4ELEWRnTAYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rui Miguel Silva <rmfrfs@gmail.com>,
	Daniel Scally <dan.scally@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 286/511] media: ov2680: Add ov2680_fill_format() helper function
Date: Sun, 17 Sep 2023 21:11:53 +0200
Message-ID: <20230917191120.751718643@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 6d6849b2203f3244b575ba01d3e41ee19aa2cadf ]

Add a ov2680_fill_format() helper function and use this everywhere were
a v4l2_mbus_framefmt struct needs to be filled in so that the driver always
fills it consistently.

This is a preparation patch for fixing ov2680_set_fmt()
which == V4L2_SUBDEV_FORMAT_TRY calls not properly filling in
the passed in v4l2_mbus_framefmt struct.

Note that for ov2680_init_cfg() this now simply always fills
the try_fmt struct of the passed in sd_state. This is correct because
ov2680_init_cfg() is never called with a NULL sd_state so the old
sd_state check is not necessary.

Fixes: 3ee47cad3e69 ("media: ov2680: Add Omnivision OV2680 sensor driver")
Acked-by: Rui Miguel Silva <rmfrfs@gmail.com>
Reviewed-by: Daniel Scally <dan.scally@ideasonboard.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov2680.c | 49 +++++++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 22 deletions(-)

diff --git a/drivers/media/i2c/ov2680.c b/drivers/media/i2c/ov2680.c
index b594943d38862..ec3972409f653 100644
--- a/drivers/media/i2c/ov2680.c
+++ b/drivers/media/i2c/ov2680.c
@@ -54,6 +54,9 @@
 #define OV2680_WIDTH_MAX		1600
 #define OV2680_HEIGHT_MAX		1200
 
+#define OV2680_DEFAULT_WIDTH			800
+#define OV2680_DEFAULT_HEIGHT			600
+
 enum ov2680_mode_id {
 	OV2680_MODE_QUXGA_800_600,
 	OV2680_MODE_720P_1280_720,
@@ -315,7 +318,8 @@ static void ov2680_power_down(struct ov2680_dev *sensor)
 	usleep_range(5000, 10000);
 }
 
-static void ov2680_set_bayer_order(struct ov2680_dev *sensor)
+static void ov2680_set_bayer_order(struct ov2680_dev *sensor,
+				   struct v4l2_mbus_framefmt *fmt)
 {
 	int hv_flip = 0;
 
@@ -325,7 +329,19 @@ static void ov2680_set_bayer_order(struct ov2680_dev *sensor)
 	if (sensor->ctrls.hflip && sensor->ctrls.hflip->val)
 		hv_flip += 2;
 
-	sensor->fmt.code = ov2680_hv_flip_bayer_order[hv_flip];
+	fmt->code = ov2680_hv_flip_bayer_order[hv_flip];
+}
+
+static void ov2680_fill_format(struct ov2680_dev *sensor,
+			       struct v4l2_mbus_framefmt *fmt,
+			       unsigned int width, unsigned int height)
+{
+	memset(fmt, 0, sizeof(*fmt));
+	fmt->width = width;
+	fmt->height = height;
+	fmt->field = V4L2_FIELD_NONE;
+	fmt->colorspace = V4L2_COLORSPACE_SRGB;
+	ov2680_set_bayer_order(sensor, fmt);
 }
 
 static int ov2680_set_vflip(struct ov2680_dev *sensor, s32 val)
@@ -340,7 +356,7 @@ static int ov2680_set_vflip(struct ov2680_dev *sensor, s32 val)
 	if (ret < 0)
 		return ret;
 
-	ov2680_set_bayer_order(sensor);
+	ov2680_set_bayer_order(sensor, &sensor->fmt);
 	return 0;
 }
 
@@ -356,7 +372,7 @@ static int ov2680_set_hflip(struct ov2680_dev *sensor, s32 val)
 	if (ret < 0)
 		return ret;
 
-	ov2680_set_bayer_order(sensor);
+	ov2680_set_bayer_order(sensor, &sensor->fmt);
 	return 0;
 }
 
@@ -614,10 +630,7 @@ static int ov2680_set_fmt(struct v4l2_subdev *sd,
 		goto unlock;
 	}
 
-	fmt->width = mode->width;
-	fmt->height = mode->height;
-	fmt->code = sensor->fmt.code;
-	fmt->colorspace = sensor->fmt.colorspace;
+	ov2680_fill_format(sensor, fmt, mode->width, mode->height);
 
 	sensor->current_mode = mode;
 	sensor->fmt = format->format;
@@ -632,16 +645,11 @@ static int ov2680_set_fmt(struct v4l2_subdev *sd,
 static int ov2680_init_cfg(struct v4l2_subdev *sd,
 			   struct v4l2_subdev_state *sd_state)
 {
-	struct v4l2_subdev_format fmt = {
-		.which = sd_state ? V4L2_SUBDEV_FORMAT_TRY
-		: V4L2_SUBDEV_FORMAT_ACTIVE,
-		.format = {
-			.width = 800,
-			.height = 600,
-		}
-	};
+	struct ov2680_dev *sensor = to_ov2680_dev(sd);
 
-	return ov2680_set_fmt(sd, sd_state, &fmt);
+	ov2680_fill_format(sensor, &sd_state->pads[0].try_fmt,
+			   OV2680_DEFAULT_WIDTH, OV2680_DEFAULT_HEIGHT);
+	return 0;
 }
 
 static int ov2680_enum_frame_size(struct v4l2_subdev *sd,
@@ -740,11 +748,8 @@ static int ov2680_mode_init(struct ov2680_dev *sensor)
 	const struct ov2680_mode_info *init_mode;
 
 	/* set initial mode */
-	sensor->fmt.code = MEDIA_BUS_FMT_SBGGR10_1X10;
-	sensor->fmt.width = 800;
-	sensor->fmt.height = 600;
-	sensor->fmt.field = V4L2_FIELD_NONE;
-	sensor->fmt.colorspace = V4L2_COLORSPACE_SRGB;
+	ov2680_fill_format(sensor, &sensor->fmt,
+			   OV2680_DEFAULT_WIDTH, OV2680_DEFAULT_HEIGHT);
 
 	sensor->frame_interval.denominator = OV2680_FRAME_RATE;
 	sensor->frame_interval.numerator = 1;
-- 
2.40.1



