Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9266618BBBB;
	Tue, 29 Apr 2025 17:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947585; cv=none; b=NCIjzAuOJJKIcaRB4SIy48MWKxlGdr7pXtOttrGKCzwCt7FQTJ06gfPQgqM6u5sKQN+//SKMoo92cU9VFIRb1F/ylQS58fKKLGAmKXj2KR7qY4CdHs/OX5HZGureyZpV1jDrp6zteTXva30qjRaJ52UP8dS0XGMKBAbwxC6cPI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947585; c=relaxed/simple;
	bh=PnA1hLunUNHvVIOIKJNSaaKBHjkI2SYxe/48frftqFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sGwotQM9cRJgNjiWGaWykF0iGZoU0qRMZgRIfoTPjh7Kqx6VkSFp5pZ4xbZEYG6EUZg85z97LlxeW9Lihifz/MruOgYY0TcP5zsdr+iG4VfhDidarQORst1x4t5aTzStden8TSgvnDcklUmiMBx+xgYHba5uaH4h6nabWe+n8Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P6NhfP3A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P6NhfP3A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A3AC4CEE3;
	Tue, 29 Apr 2025 17:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947585;
	bh=PnA1hLunUNHvVIOIKJNSaaKBHjkI2SYxe/48frftqFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P6NhfP3AZjGaVv6uj5z1hc3g3kDZtPS/Ajflr0QQ9dd1CCnIalkBfQXkQlfFTnqpT
	 ib5yQ5Bwo1XcnF/bUfa6rtZaqOviXIi2mYPFYWcs5PyppuhZFYbrOrqtqLCwx3XDKZ
	 zKInjT12MJmZsLeta69AtR5jpC7ZrszeDqH0JDDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	=?UTF-8?q?Andr=C3=A9=20Apitzsch?= <git@apitzsch.eu>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 013/280] media: i2c: imx214: Check number of lanes from device tree
Date: Tue, 29 Apr 2025 18:39:14 +0200
Message-ID: <20250429161115.626896590@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



