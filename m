Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590568;
	b=e8ZdWJYjleHHcYUVpycdSDdmYNAa3iXsO493arVGyQbZzm3bBeAgcDha98sKCcAHiTAb
	 aWGSzvIldOavgzTFTN9MC8c2M4uJLqXLlL56ONxDqkshZiOc1oLIAzg7Amb9xY0/lGPng
	 V0hqvXKycTwtrwzdsQVoEUTqlwV4eLjV4XMxqejLeJH5ZQdVBX2g3KcjhJ2bhveWuwYiW
	 +0ZgJLKSrioy3Uay5edlBSUmqwV4er89qVYPPxNlM6gUP6HafQjV1RIOIkvLw0fUQ+ONf
	 XRigB7Xw1ehhSTMxVjEhBHLDLZTIziPRlvAOZyi9if/FJc5goq8CUwuqc6wPY2o4oaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590568;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l6E6cHTB5BUn+eKqZfrpiVEZe/ctTb0ZhfjJjV7W+qU=;
	b=2vGcRkBJiAys777J9tSU77Ibyi3j1WBBUdQpzbyFtqGkhHCwouvNBvA4OldmGCapxAil
	 Q1QW7hA6CvwnR/QPHXUlp3ge6cjFOpY7EQ75hyQA4wmVKNfEqmq6UHEVB4oCHWMowr6GR
	 IDkuu9+VS/XKHTwb+fNh3FCk+7WsuJsVtSaBOG80o3E1ytpq5gPRdODSFcJiBIVZXFsMa
	 ZdsrrF1nXW8+ygZnga2s4JSFUpaFERpzCJ0S2QZEpxixtfAaHUh15aYM8qUHkblK96/k/
	 QIR62Te5qIO4inZutP7DxhQWD5i2v9l244TjjxhQX/7fzBdkh8GZyUAHMwH5exVb04w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sI3YncdU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2020A606BD06;
	Fri, 13 Nov 2026 17:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sI3YncdU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F351F000C4;
	Fri, 13 Nov 2026 17:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590568;
	bh=l6E6cHTB5BUn+eKqZfrpiVEZe/ctTb0ZhfjJjV7W+qU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sI3YncdUwsEsBKVulWz3p180GmNrciXQUaY1zqyj9Q2u2BuFTHYza2iJXp3ZMoFFG
	 0oxgXDIGBFomJ9bkB7FipESQneFaAndyOXa+kxI7q+3n7+3OQbmbKvDlUF4HvArUvH
	 iQeL2HqWeGSXeDvJ9KHrHicymCW1F+hlgozpO22Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 501/686] media: imx219: Account for rate_factor in control steps
Date: Fri, 13 Nov 2026 10:50:34 -0500
Message-ID: <20261113153837.890145139@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 57043aef0a04bd96d97881422590e71c1e4c45b1 ]

The controls that are divided by the rate_factor before writing them to
the registers have the step of the value of the rate_factor. Take this
into account when the control's range is modified. The controls are
created in a configuration where rate_factor is always 1, hence there's no
need to change the code adding new controls.

Fixes: f513997119f4 ("media: i2c: imx219: Scale the pixel rate for analog binning")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx219.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/imx219.c b/drivers/media/i2c/imx219.c
index 87c4d8942135c..e399a87f99266 100644
--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -326,13 +326,13 @@ static const struct imx219_mode supported_modes[] = {
 		/* 2x2 binned 60fps mode */
 		.width = 1640,
 		.height = 1232,
-		.fll_def = 1707,
+		.fll_def = 1706,
 	},
 	{
 		/* 640x480 60fps mode */
 		.width = 640,
 		.height = 480,
-		.fll_def = 1707,
+		.fll_def = 1706,
 	},
 };
 
@@ -469,8 +469,7 @@ static int imx219_set_ctrl(struct v4l2_ctrl *ctrl)
 		ret = __v4l2_ctrl_modify_range(imx219->exposure,
 					       imx219->exposure->minimum,
 					       exposure_max,
-					       imx219->exposure->step,
-					       exposure_def);
+					       rate_factor, exposure_def);
 		if (ret)
 			return ret;
 
@@ -904,7 +903,8 @@ static int imx219_set_pad_format(struct v4l2_subdev *sd,
 
 		/* Update limits and set FPS to default */
 		ret = __v4l2_ctrl_modify_range(imx219->vblank, IMX219_VBLANK_MIN,
-					       IMX219_FLL_MAX - mode->height, 1,
+					       IMX219_FLL_MAX - mode->height,
+					       rate_factor,
 					       mode->fll_def - mode->height);
 		if (ret)
 			return ret;
@@ -922,8 +922,7 @@ static int imx219_set_pad_format(struct v4l2_subdev *sd,
 		ret = __v4l2_ctrl_modify_range(imx219->exposure,
 					       imx219->exposure->minimum,
 					       exposure_max,
-					       imx219->exposure->step,
-					       exposure_def);
+					       rate_factor, exposure_def);
 		if (ret)
 			return ret;
 
@@ -956,8 +955,7 @@ static int imx219_set_pad_format(struct v4l2_subdev *sd,
 			return ret;
 
 		/* Scale the pixel rate based on the mode specific factor */
-		pixel_rate = imx219_get_pixel_rate(imx219) *
-			     imx219_get_rate_factor(state);
+		pixel_rate = imx219_get_pixel_rate(imx219) * rate_factor;
 		ret = __v4l2_ctrl_modify_range(imx219->pixel_rate, pixel_rate,
 					       pixel_rate, 1, pixel_rate);
 		if (ret)
-- 
2.53.0



