Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC91168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:27:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4BEC4339B;
	Mon,  8 May 2023 10:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541644;
	bh=TvUAxuWbao7k+bB6sKnmccFmKkfMmiDkF6W9Fq77OFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aUtQB72Z5ktUeqvB8SkxZtoPoUdVj4icYKaFG6JN9fKOLvBY7gfJhIEc/qky2gqE8
	 hEsL94fG2e+gwPK4FMoGjmKG/FtCOVSSTjLVW5fElypZJvAMo7T2sv3+5zUpDRshrk
	 orqulcO/iX656yNT4o2JzFUBgRc64gy+8IhQuxvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Foss <rfoss@kernel.org>,
	Adam Ford <aford173@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 181/663] drm/bridge: adv7533: Fix adv7533_mode_valid for adv7533 and adv7535
Date: Mon,  8 May 2023 11:40:07 +0200
Message-Id: <20230508094434.319677369@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Adam Ford <aford173@gmail.com>

[ Upstream commit ee0285e13455fdbce5de315bdbe91b5f198a2a06 ]

When dynamically switching lanes was removed, the intent of the code
was to check to make sure that higher speed items used 4 lanes, but
it had the unintended consequence of removing the slower speeds for
4-lane users.

This attempts to remedy this by doing a check to see that the
max frequency doesn't exceed the chip limit, and a second
check to make sure that the max bit-rate doesn't exceed the
number of lanes * max bit rate / lane.

Fixes: 9a0cdcd6649b ("drm/bridge: adv7533: remove dynamic lane switching from adv7533 bridge")
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230319125524.58803-1-aford173@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/adv7511/adv7533.c | 25 +++++++++++-------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/bridge/adv7511/adv7533.c b/drivers/gpu/drm/bridge/adv7511/adv7533.c
index fdfeadcefe805..7e3e56441aedc 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7533.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7533.c
@@ -103,22 +103,19 @@ void adv7533_dsi_power_off(struct adv7511 *adv)
 enum drm_mode_status adv7533_mode_valid(struct adv7511 *adv,
 					const struct drm_display_mode *mode)
 {
-	int lanes;
+	unsigned long max_lane_freq;
 	struct mipi_dsi_device *dsi = adv->dsi;
+	u8 bpp = mipi_dsi_pixel_format_to_bpp(dsi->format);
 
-	if (mode->clock > 80000)
-		lanes = 4;
-	else
-		lanes = 3;
-
-	/*
-	 * TODO: add support for dynamic switching of lanes
-	 * by using the bridge pre_enable() op . Till then filter
-	 * out the modes which shall need different number of lanes
-	 * than what was configured in the device tree.
-	 */
-	if (lanes != dsi->lanes)
-		return MODE_BAD;
+	/* Check max clock for either 7533 or 7535 */
+	if (mode->clock > (adv->type == ADV7533 ? 80000 : 148500))
+		return MODE_CLOCK_HIGH;
+
+	/* Check max clock for each lane */
+	max_lane_freq = (adv->type == ADV7533 ? 800000 : 891000);
+
+	if (mode->clock * bpp > max_lane_freq * adv->num_dsi_lanes)
+		return MODE_CLOCK_HIGH;
 
 	return MODE_OK;
 }
-- 
2.39.2



