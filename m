Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F7C47CC83;
	Sat, 28 Feb 2026 17:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301329; cv=none; b=UkBRZUoWk9JclNJ+UmX9mT+LeDG2u0BxojdatHoWQXG2r5YZl283R0FNQZZTo1wuKLbqNpajDQqLQKQ9AmxWHJnCn9QK7BbUzv4jK0G+NS9X5wPEavcGCAlu3Qabv2/62YzIyOerHZ2irb45S7IqtoAIO+lS3GbOimVkgJozVj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301329; c=relaxed/simple;
	bh=IeEKI5M4X0R0nj1w52Z4QhE2K1LzmG7yNEma1ec3+jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZnU7/jdYjIE31aTt9SieZdaBH9xdrvZP/KcuZ4VTM3jAExNdGScztH+iVMR1pi/eHe+Uik1NnTIMSb1pyVmqvIFELoduiGP1zbClFjVIx4ezwM8bAa8HTqGmLcpnq2YC9ZWxPnBbsN6gpvv37+hdaLIMfj/DQvTaFQPpblUdRgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E8vxKzSm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E8vxKzSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B26C116D0;
	Sat, 28 Feb 2026 17:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301329;
	bh=IeEKI5M4X0R0nj1w52Z4QhE2K1LzmG7yNEma1ec3+jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E8vxKzSmzkKJ6z2yp/rgCXfoxgmCz/QsYRF2ZQSkLLBsMYEsUPZ8hHrfMN9tNCo/v
	 0w/g2DP7jPefo6jcGomHkO/UEimlSivNmuxpp2y0w13XRbljs0ZAQGBbvqQjiQSWIw
	 ohoe8BBjQfX5RhPAVi5jqW8+escXmP8smBAF2rd/8V5/hvpOMat4Of8dDx/hKnR0xw
	 k5Bv5Ew+K28Cf7se3Wf2EPhB+vHIimZAwKMD7Jt/2ylzWbP4dHAStTi0WM7ZPp+qi1
	 RpgR9WSoRO7ZFFm5RcjykzB/hRTvzI4Ddis1r2yz4BywE41yq8MSvJKZIaGpb7D4xP
	 AlT7HTkqi86qg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Hans de Goede <hansg@kernel.org>,
	stable@vger.kernel.org,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 516/752] media: i2c: ov01a10: Fix the horizontal flip control
Date: Sat, 28 Feb 2026 12:43:47 -0500
Message-ID: <20260228174750.1542406-516-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hansg@kernel.org>

[ Upstream commit ada20c3db0db4f2834d9515f6105111871f04a4d ]

During sensor calibration I noticed that with the hflip control set
to false/disabled the image was mirrored.

So it seems that the horizontal flip control is inverted and needs to
be set to 1 to not flip (just like the similar problem recently fixed
on the ov08x40 sensor).

Invert the hflip control to fix the sensor mirroring by default.

As the comment above the newly added OV01A10_MEDIA_BUS_FMT define explains
the control being inverted also means that the native Bayer-order of
the sensor actually is GBRG not BGGR, but so as to not break userspace
the Bayer-order is kept at BGGR.

Fixes: 0827b58dabff ("media: i2c: add ov01a10 image sensor driver")
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hansg@kernel.org>
Tested-by: Mehdi Djait <mehdi.djait@linux.intel.com> # Dell XPS 9315
Reviewed-by: Mehdi Djait <mehdi.djait@linux.intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov01a10.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/ov01a10.c b/drivers/media/i2c/ov01a10.c
index 141cb6f75b555..e5df01f979781 100644
--- a/drivers/media/i2c/ov01a10.c
+++ b/drivers/media/i2c/ov01a10.c
@@ -75,6 +75,15 @@
 #define OV01A10_REG_X_WIN		0x3811
 #define OV01A10_REG_Y_WIN		0x3813
 
+/*
+ * The native ov01a10 bayer-pattern is GBRG, but there was a driver bug enabling
+ * hflip/mirroring by default resulting in BGGR. Because of this bug Intel's
+ * proprietary IPU6 userspace stack expects BGGR. So we report BGGR to not break
+ * userspace and fix things up by shifting the crop window-x coordinate by 1
+ * when hflip is *disabled*.
+ */
+#define OV01A10_MEDIA_BUS_FMT		MEDIA_BUS_FMT_SBGGR10_1X10
+
 struct ov01a10_reg {
 	u16 address;
 	u8 val;
@@ -185,14 +194,14 @@ static const struct ov01a10_reg sensor_1280x800_setting[] = {
 	{0x380e, 0x03},
 	{0x380f, 0x80},
 	{0x3810, 0x00},
-	{0x3811, 0x08},
+	{0x3811, 0x09},
 	{0x3812, 0x00},
 	{0x3813, 0x08},
 	{0x3814, 0x01},
 	{0x3815, 0x01},
 	{0x3816, 0x01},
 	{0x3817, 0x01},
-	{0x3820, 0xa0},
+	{0x3820, 0xa8},
 	{0x3822, 0x13},
 	{0x3832, 0x28},
 	{0x3833, 0x10},
@@ -411,7 +420,7 @@ static int ov01a10_set_hflip(struct ov01a10 *ov01a10, u32 hflip)
 	int ret;
 	u32 val, offset;
 
-	offset = hflip ? 0x9 : 0x8;
+	offset = hflip ? 0x8 : 0x9;
 	ret = ov01a10_write_reg(ov01a10, OV01A10_REG_X_WIN, 1, offset);
 	if (ret)
 		return ret;
@@ -420,8 +429,8 @@ static int ov01a10_set_hflip(struct ov01a10 *ov01a10, u32 hflip)
 	if (ret)
 		return ret;
 
-	val = hflip ? val | FIELD_PREP(OV01A10_HFLIP_MASK, 0x1) :
-		val & ~OV01A10_HFLIP_MASK;
+	val = hflip ? val & ~OV01A10_HFLIP_MASK :
+		      val | FIELD_PREP(OV01A10_HFLIP_MASK, 0x1);
 
 	return ov01a10_write_reg(ov01a10, OV01A10_REG_FORMAT1, 1, val);
 }
@@ -610,7 +619,7 @@ static void ov01a10_update_pad_format(const struct ov01a10_mode *mode,
 {
 	fmt->width = mode->width;
 	fmt->height = mode->height;
-	fmt->code = MEDIA_BUS_FMT_SBGGR10_1X10;
+	fmt->code = OV01A10_MEDIA_BUS_FMT;
 	fmt->field = V4L2_FIELD_NONE;
 	fmt->colorspace = V4L2_COLORSPACE_RAW;
 }
@@ -751,7 +760,7 @@ static int ov01a10_enum_mbus_code(struct v4l2_subdev *sd,
 	if (code->index > 0)
 		return -EINVAL;
 
-	code->code = MEDIA_BUS_FMT_SBGGR10_1X10;
+	code->code = OV01A10_MEDIA_BUS_FMT;
 
 	return 0;
 }
@@ -761,7 +770,7 @@ static int ov01a10_enum_frame_size(struct v4l2_subdev *sd,
 				   struct v4l2_subdev_frame_size_enum *fse)
 {
 	if (fse->index >= ARRAY_SIZE(supported_modes) ||
-	    fse->code != MEDIA_BUS_FMT_SBGGR10_1X10)
+	    fse->code != OV01A10_MEDIA_BUS_FMT)
 		return -EINVAL;
 
 	fse->min_width = supported_modes[fse->index].width;
-- 
2.51.0

