Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080EC381D1
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dV/sxHwK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8563FC433C8;
	Wed, 15 Nov 2023 20:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078425;
	bh=uSO4EaUmzxmE5vyeSfnZ2trWAa/NSyTQ3Ho9gigXEnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dV/sxHwKGb6WohLXb9hNp63+xwLnC/eqsnvFslsmKVR8//8PNLgnIABLSVptd+rPT
	 UxU6NByTF+RN12FUM2APISxWLlazR3063ObEHcUmhVY4TaSO+1PyRsRpgvSvknyBJf
	 XRu/lvW9C6Pp4iwdVjAUE0Zch+5Q3MInmza0GQfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 316/379] media: ov5640: Drop dead code using frame_interval
Date: Wed, 15 Nov 2023 14:26:31 -0500
Message-ID: <20231115192703.843051456@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacopo Mondi <jacopo.mondi@ideasonboard.com>

[ Upstream commit eeaa47d182fedfe68b8fd40ef3798761c8904791 ]

The ov5640_update_pixel_rate() function handles the parallel and MIPI
CSI-2 cases separately.

When running on a parallel setup the V4L2_CID_PIXEL_RATE value is
calculated at the beginning of the function using the values configured
with the frame_interval operations, and then the function immediately
returns.

The remaining of the function handles the MIPI CSI-2 configuration and
should not use the 'current_fr' and 'def_fps' fields as those are only
relevant for parallel mode.

Drop a small section of dead code that updates vblank using
frame_interval on a MIPI CSI-2 setup.

Signed-off-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Stable-dep-of: 8fc29e3c9f68 ("media: ov5640: fix vblank unchange issue when work at dvp mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5640.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 2ee832426736d..505dd7c10235e 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -2912,19 +2912,6 @@ static int ov5640_update_pixel_rate(struct ov5640_dev *sensor)
 				 hblank, hblank, 1, hblank);
 
 	vblank = timings->vblank_def;
-
-	if (sensor->current_fr != mode->def_fps) {
-		/*
-		 * Compute the vertical blanking according to the framerate
-		 * configured with s_frame_interval.
-		 */
-		int fie_num = sensor->frame_interval.numerator;
-		int fie_denom = sensor->frame_interval.denominator;
-
-		vblank = ((fie_num * pixel_rate / fie_denom) / timings->htot) -
-			mode->height;
-	}
-
 	__v4l2_ctrl_modify_range(sensor->ctrls.vblank, OV5640_MIN_VBLANK,
 				 OV5640_MAX_VTS - mode->height, 1, vblank);
 	__v4l2_ctrl_s_ctrl(sensor->ctrls.vblank, vblank);
-- 
2.42.0



