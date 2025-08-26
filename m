Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BAAC2BE058;
	Tue, 26 Aug 2025 14:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217960; cv=none; b=axcYtxnz3EyUwn2ewnWFiD5p2Ej2jrRKqqfW6VZhrJfk0hJniKPYDJykruzLzPuYU+qSMvi0lXSG51aFTLVGPsEzfcQSShY//W8mZrMmYhTJ+uH5WgWb1y7x9ubjA3qaRQ6NFgGEa7UM32SNSyHCvEnaWBqpIo5G5dIA4Zwitx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217960; c=relaxed/simple;
	bh=xD3sYGgVXv6xX8jsr3c6aG5LBy9B3bx1mYrsVGrk934=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XPzvee7xfi4m9tccRdx4gjF0Uno//2o/zbKnaotNn1S133w7yQ8CJJrqcXLwlmjfx/l1j72HJsVywsrWOFUloKGwI+le3Xuyb7aCD7osbLnG4TwDVfTM5SrYFqPUOlQBA7TdqLtDZ1Vl6dngXwmQp+d1ZgzD7OmutzSH4lsRxeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AnycQqzC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AnycQqzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26FEC4CEF1;
	Tue, 26 Aug 2025 14:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217960;
	bh=xD3sYGgVXv6xX8jsr3c6aG5LBy9B3bx1mYrsVGrk934=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AnycQqzCf6iGNMOETin096oMKTfm6pTLpBF7TYJDkA43cBZ3V+vF/g1al6KqNvmTa
	 KPu3QZ6SQH2mvi8ZMA7HbrMWGoeCON6D86MpeocmEFN4jMah0vfZUnqthQUUbjxBj0
	 fRfv5XhqDswaKazlF9fquNXliTziW2H2/V106lPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 309/523] media: tc358743: Return an appropriate colorspace from tc358743_set_fmt
Date: Tue, 26 Aug 2025 13:08:39 +0200
Message-ID: <20250826110932.082770389@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 377cc006a364dfdab2f3f221cfad63a9265200b8 ]

When calling tc358743_set_fmt, the code was calling tc358743_get_fmt
to choose a valid format. However that sets the colorspace
based on information read back from the chip, not the colour
format requested.

The result was that if you called try or set format for UYVY
when the current format was RGB3 then you would get told SRGB,
and try RGB3 when current was UYVY and you would get told
SMPTE170M.

The value programmed in the VI_REP register for the colorspace
is always set by this driver, therefore there is no need to read
back the value, and never set to REC709.
Return the colorspace based on the format set/tried instead.

Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/tc358743.c | 44 ++++++++++++++----------------------
 1 file changed, 17 insertions(+), 27 deletions(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index ab180ae4837a..3649c02d611e 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1686,12 +1686,23 @@ static int tc358743_enum_mbus_code(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static u32 tc358743_g_colorspace(u32 code)
+{
+	switch (code) {
+	case MEDIA_BUS_FMT_RGB888_1X24:
+		return V4L2_COLORSPACE_SRGB;
+	case MEDIA_BUS_FMT_UYVY8_1X16:
+		return V4L2_COLORSPACE_SMPTE170M;
+	default:
+		return 0;
+	}
+}
+
 static int tc358743_get_fmt(struct v4l2_subdev *sd,
 		struct v4l2_subdev_pad_config *cfg,
 		struct v4l2_subdev_format *format)
 {
 	struct tc358743_state *state = to_state(sd);
-	u8 vi_rep = i2c_rd8(sd, VI_REP);
 
 	if (format->pad != 0)
 		return -EINVAL;
@@ -1701,23 +1712,7 @@ static int tc358743_get_fmt(struct v4l2_subdev *sd,
 	format->format.height = state->timings.bt.height;
 	format->format.field = V4L2_FIELD_NONE;
 
-	switch (vi_rep & MASK_VOUT_COLOR_SEL) {
-	case MASK_VOUT_COLOR_RGB_FULL:
-	case MASK_VOUT_COLOR_RGB_LIMITED:
-		format->format.colorspace = V4L2_COLORSPACE_SRGB;
-		break;
-	case MASK_VOUT_COLOR_601_YCBCR_LIMITED:
-	case MASK_VOUT_COLOR_601_YCBCR_FULL:
-		format->format.colorspace = V4L2_COLORSPACE_SMPTE170M;
-		break;
-	case MASK_VOUT_COLOR_709_YCBCR_FULL:
-	case MASK_VOUT_COLOR_709_YCBCR_LIMITED:
-		format->format.colorspace = V4L2_COLORSPACE_REC709;
-		break;
-	default:
-		format->format.colorspace = 0;
-		break;
-	}
+	format->format.colorspace = tc358743_g_colorspace(format->format.code);
 
 	return 0;
 }
@@ -1731,19 +1726,14 @@ static int tc358743_set_fmt(struct v4l2_subdev *sd,
 	u32 code = format->format.code; /* is overwritten by get_fmt */
 	int ret = tc358743_get_fmt(sd, cfg, format);
 
-	format->format.code = code;
+	if (code == MEDIA_BUS_FMT_RGB888_1X24 ||
+	    code == MEDIA_BUS_FMT_UYVY8_1X16)
+		format->format.code = code;
+	format->format.colorspace = tc358743_g_colorspace(format->format.code);
 
 	if (ret)
 		return ret;
 
-	switch (code) {
-	case MEDIA_BUS_FMT_RGB888_1X24:
-	case MEDIA_BUS_FMT_UYVY8_1X16:
-		break;
-	default:
-		return -EINVAL;
-	}
-
 	if (format->which == V4L2_SUBDEV_FORMAT_TRY)
 		return 0;
 
-- 
2.39.5



