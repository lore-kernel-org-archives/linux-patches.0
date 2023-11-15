Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6203A8E5
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="txxUTZ5O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3F3C433C9;
	Wed, 15 Nov 2023 19:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076953;
	bh=quQ2Q/xgtfoefHT6Xv3kg+gjfaHuhZDhElNSw93cnxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=txxUTZ5OBz5/6mouot8IG1zjhod4S85EGELIETv7/q7xegRYf+ntcTK61iLc74dlx
	 lEoVix73WY0Gwz6aWaFMODHoZPV5+e+1nNsek1cFwoxXSyQCmO8ynlcOkM/wGDjav+
	 GHwjZOab3xKFyYq9G2RKFWEBGVNl84VvvHYu1MpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Guoniu.zhou" <guoniu.zhou@nxp.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 474/550] media: ov5640: fix vblank unchange issue when work at dvp mode
Date: Wed, 15 Nov 2023 14:17:38 -0500
Message-ID: <20231115191633.725257748@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guoniu.zhou <guoniu.zhou@nxp.com>

[ Upstream commit 8fc29e3c9f682d4ad9b0764d44ecc6c19b000051 ]

The value of V4L2_CID_VBLANK control is initialized to default vblank
value of 640x480 when driver probe. When OV5640 work at DVP mode, the
control value won't update and lead to sensor can't output data if the
resolution remain the same as last time since incorrect total vertical
size. So update it when there is a new value applied.

Fixes: bce93b827de6 ("media: ov5640: Add VBLANK control")
Signed-off-by: Guoniu.zhou <guoniu.zhou@nxp.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5640.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 8b7ff2f3bdda7..7c041dafff2b1 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -2850,12 +2850,22 @@ static int ov5640_try_fmt_internal(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static void __v4l2_ctrl_vblank_update(struct ov5640_dev *sensor, u32 vblank)
+{
+	const struct ov5640_mode_info *mode = sensor->current_mode;
+
+	__v4l2_ctrl_modify_range(sensor->ctrls.vblank, OV5640_MIN_VBLANK,
+				 OV5640_MAX_VTS - mode->height, 1, vblank);
+
+	__v4l2_ctrl_s_ctrl(sensor->ctrls.vblank, vblank);
+}
+
 static int ov5640_update_pixel_rate(struct ov5640_dev *sensor)
 {
 	const struct ov5640_mode_info *mode = sensor->current_mode;
 	enum ov5640_pixel_rate_id pixel_rate_id = mode->pixel_rate;
 	struct v4l2_mbus_framefmt *fmt = &sensor->fmt;
-	const struct ov5640_timings *timings;
+	const struct ov5640_timings *timings = ov5640_timings(sensor, mode);
 	s32 exposure_val, exposure_max;
 	unsigned int hblank;
 	unsigned int i = 0;
@@ -2874,6 +2884,8 @@ static int ov5640_update_pixel_rate(struct ov5640_dev *sensor)
 		__v4l2_ctrl_s_ctrl_int64(sensor->ctrls.pixel_rate,
 					 ov5640_calc_pixel_rate(sensor));
 
+		__v4l2_ctrl_vblank_update(sensor, timings->vblank_def);
+
 		return 0;
 	}
 
@@ -2916,15 +2928,12 @@ static int ov5640_update_pixel_rate(struct ov5640_dev *sensor)
 	__v4l2_ctrl_s_ctrl_int64(sensor->ctrls.pixel_rate, pixel_rate);
 	__v4l2_ctrl_s_ctrl(sensor->ctrls.link_freq, i);
 
-	timings = ov5640_timings(sensor, mode);
 	hblank = timings->htot - mode->width;
 	__v4l2_ctrl_modify_range(sensor->ctrls.hblank,
 				 hblank, hblank, 1, hblank);
 
 	vblank = timings->vblank_def;
-	__v4l2_ctrl_modify_range(sensor->ctrls.vblank, OV5640_MIN_VBLANK,
-				 OV5640_MAX_VTS - mode->height, 1, vblank);
-	__v4l2_ctrl_s_ctrl(sensor->ctrls.vblank, vblank);
+	__v4l2_ctrl_vblank_update(sensor, vblank);
 
 	exposure_max = timings->crop.height + vblank - 4;
 	exposure_val = clamp_t(s32, sensor->ctrls.exposure->val,
-- 
2.42.0



