Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281CA24E016;
	Tue, 29 Apr 2025 16:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945714; cv=none; b=uFlU5+rE/vPZ3XLZQ+GLl7nq8671Ej0Fl3F+KisExDmwjMmdm/FoLM4ujXCD27jAkIKija1HUzgrGXkhBXKQulBemt+WRE5ZDztOhld+UdSzyvur88K0MY2rkJksrwOPgpoEpUCV41PApjHXodL3S6PNNOauU3B454BLcbgCb4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945714; c=relaxed/simple;
	bh=oDcx7pHKE3MjyMkk53JsnajcaBtQu9AwbN8VImS155g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FboIxctnEOVkT0ZOH3kV4FucnsusS6NeQFIuoUD1T2w7a1NBO8mq/YV3zsYcux8XkJOwNPuzxmJ+hbU+x9OSXblWxiNbcGhrEKIh7JD92Td86owVq1y8ozlzuR4MYbLDpmxyMk5e0GY+xUXFKA+f5QhtwR3zJ1BC1QCwDdBPpRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DjzsuZCN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DjzsuZCN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D65CC4CEE3;
	Tue, 29 Apr 2025 16:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945714;
	bh=oDcx7pHKE3MjyMkk53JsnajcaBtQu9AwbN8VImS155g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DjzsuZCNaRO5uIb5DYpouWiypvYX1Y9Br5t/mClEFI6vcDTUGB9IUt+ew+iIQR0GF
	 QvLNUUGv64jd+WyCAAA7agPKec5/BW5U223r1TvhOpDeTF7cJCnBZsdukiypi1F/mk
	 tP0IEbabKrejtPxO1jwyAe1wMdNdlNr+rFwEXgwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	=?UTF-8?q?Andr=C3=A9=20Apitzsch?= <git@apitzsch.eu>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 010/311] media: i2c: imx214: Check number of lanes from device tree
Date: Tue, 29 Apr 2025 18:37:27 +0200
Message-ID: <20250429161121.455877344@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Apitzsch <git@apitzsch.eu>

[ Upstream commit 3d55f4eb03fce69f3a72615fe9c5ca171f7b846b ]

The imx214 camera is capable of either two-lane or four-lane operation.

Currently only the four-lane mode is supported, as proper pixel rates
and link frequences for the two-lane mode are unknown.

Acked-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: André Apitzsch <git@apitzsch.eu>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Stable-dep-of: acc294519f17 ("media: i2c: imx214: Fix link frequency validation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx214.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/imx214.c b/drivers/media/i2c/imx214.c
index 8bac5a1f1cb18..fdc2dfb4ebcdd 100644
--- a/drivers/media/i2c/imx214.c
+++ b/drivers/media/i2c/imx214.c
@@ -197,7 +197,6 @@ struct imx214 {
 
 /*From imx214_mode_tbls.h*/
 static const struct cci_reg_sequence mode_4096x2304[] = {
-	{ IMX214_REG_CSI_LANE_MODE, IMX214_CSI_4_LANE_MODE },
 	{ IMX214_REG_HDR_MODE, IMX214_HDR_MODE_OFF },
 	{ IMX214_REG_HDR_RES_REDUCTION, IMX214_HDR_RES_REDU_THROUGH },
 	{ IMX214_REG_EXPOSURE_RATIO, 1 },
@@ -271,7 +270,6 @@ static const struct cci_reg_sequence mode_4096x2304[] = {
 };
 
 static const struct cci_reg_sequence mode_1920x1080[] = {
-	{ IMX214_REG_CSI_LANE_MODE, IMX214_CSI_4_LANE_MODE },
 	{ IMX214_REG_HDR_MODE, IMX214_HDR_MODE_OFF },
 	{ IMX214_REG_HDR_RES_REDUCTION, IMX214_HDR_RES_REDU_THROUGH },
 	{ IMX214_REG_EXPOSURE_RATIO, 1 },
@@ -789,6 +787,13 @@ static int imx214_start_streaming(struct imx214 *imx214)
 		return ret;
 	}
 
+	ret = cci_write(imx214->regmap, IMX214_REG_CSI_LANE_MODE,
+			IMX214_CSI_4_LANE_MODE, NULL);
+	if (ret) {
+		dev_err(imx214->dev, "failed to configure lanes\n");
+		return ret;
+	}
+
 	state = v4l2_subdev_get_locked_active_state(&imx214->sd);
 	fmt = v4l2_subdev_state_get_format(state, 0);
 	mode = v4l2_find_nearest_size(imx214_modes, ARRAY_SIZE(imx214_modes),
@@ -953,6 +958,13 @@ static int imx214_parse_fwnode(struct device *dev)
 		goto done;
 	}
 
+	/* Check the number of MIPI CSI2 data lanes */
+	if (bus_cfg.bus.mipi_csi2.num_data_lanes != 4) {
+		ret = dev_err_probe(dev, -EINVAL,
+				    "only 4 data lanes are currently supported\n");
+		goto done;
+	}
+
 	for (i = 0; i < bus_cfg.nr_of_link_frequencies; i++)
 		if (bus_cfg.link_frequencies[i] == IMX214_DEFAULT_LINK_FREQ)
 			break;
-- 
2.39.5



