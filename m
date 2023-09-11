Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866DD11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:56:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A774C433C8;
	Mon, 11 Sep 2023 14:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444186;
	bh=GMyMSiYAhZCnWJYzDEDz4xPvzhG+mqSSRkV5Bw+uyJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dFsK7d+70LSbiAfM+5dDS/s5qzolAPf+uJu98f6F0mkCi8RKwWa3k7muxY98vbvu9
	 1yFBIi3uVholgMyli7OFX+cWhlnwbi97wS7Qdql5+9YssOMRxXrX4NRvin6OsLivO0
	 SW4rOSyleJtO2n/TqG0nAgeUrxnbzwX5bOj8WP6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Alexandre Mergnat <amergnat@baylibre.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 612/737] thermal/drivers/mediatek/lvts_thermal: Honor sensors in immediate mode
Date: Mon, 11 Sep 2023 15:47:51 +0200
Message-ID: <20230911134707.627458069@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 64de162e34e4cb2982a1d96e492f018026a61c1d ]

Each controller can be configured to operate on immediate or filtered
mode. On filtered mode, the sensors are enabled by setting the
corresponding bits in MONCTL0, while on immediate mode, by setting
MSRCTL1.

Previously, the code would set MSRCTL1 for all four sensors when
configured to immediate mode, but given that the controller might not
have all four sensors connected, this would cause interrupts to trigger
for non-existent sensors. Fix this by handling the MSRCTL1 register
analogously to the MONCTL0: only enable the sensors that were declared.

Fixes: f5f633b18234 ("thermal/drivers/mediatek: Add the Low Voltage Thermal Sensor driver")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Tested-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: Alexandre Mergnat <amergnat@baylibre.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20230706153823.201943-3-nfraprado@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/mediatek/lvts_thermal.c | 57 ++++++++++++++-----------
 1 file changed, 33 insertions(+), 24 deletions(-)

diff --git a/drivers/thermal/mediatek/lvts_thermal.c b/drivers/thermal/mediatek/lvts_thermal.c
index 56b24c5b645f3..64748153d181e 100644
--- a/drivers/thermal/mediatek/lvts_thermal.c
+++ b/drivers/thermal/mediatek/lvts_thermal.c
@@ -894,24 +894,6 @@ static int lvts_ctrl_configure(struct device *dev, struct lvts_ctrl *lvts_ctrl)
 			LVTS_HW_FILTER << 3 | LVTS_HW_FILTER;
 	writel(value, LVTS_MSRCTL0(lvts_ctrl->base));
 
-	/*
-	 * LVTS_MSRCTL1 : Measurement control
-	 *
-	 * Bits:
-	 *
-	 * 9: Ignore MSRCTL0 config and do immediate measurement on sensor3
-	 * 6: Ignore MSRCTL0 config and do immediate measurement on sensor2
-	 * 5: Ignore MSRCTL0 config and do immediate measurement on sensor1
-	 * 4: Ignore MSRCTL0 config and do immediate measurement on sensor0
-	 *
-	 * That configuration will ignore the filtering and the delays
-	 * introduced below in MONCTL1 and MONCTL2
-	 */
-	if (lvts_ctrl->mode == LVTS_MSR_IMMEDIATE_MODE) {
-		value = BIT(9) | BIT(6) | BIT(5) | BIT(4);
-		writel(value, LVTS_MSRCTL1(lvts_ctrl->base));
-	}
-
 	/*
 	 * LVTS_MONCTL1 : Period unit and group interval configuration
 	 *
@@ -977,6 +959,15 @@ static int lvts_ctrl_start(struct device *dev, struct lvts_ctrl *lvts_ctrl)
 	struct thermal_zone_device *tz;
 	u32 sensor_map = 0;
 	int i;
+	/*
+	 * Bitmaps to enable each sensor on immediate and filtered modes, as
+	 * described in MSRCTL1 and MONCTL0 registers below, respectively.
+	 */
+	u32 sensor_imm_bitmap[] = { BIT(4), BIT(5), BIT(6), BIT(9) };
+	u32 sensor_filt_bitmap[] = { BIT(0), BIT(1), BIT(2), BIT(3) };
+
+	u32 *sensor_bitmap = lvts_ctrl->mode == LVTS_MSR_IMMEDIATE_MODE ?
+			     sensor_imm_bitmap : sensor_filt_bitmap;
 
 	for (i = 0; i < lvts_ctrl->num_lvts_sensor; i++) {
 
@@ -1012,20 +1003,38 @@ static int lvts_ctrl_start(struct device *dev, struct lvts_ctrl *lvts_ctrl)
 		 * map, so we can enable the temperature monitoring in
 		 * the hardware thermal controller.
 		 */
-		sensor_map |= BIT(i);
+		sensor_map |= sensor_bitmap[i];
 	}
 
 	/*
-	 * Bits:
-	 *      9: Single point access flow
-	 *    0-3: Enable sensing point 0-3
-	 *
 	 * The initialization of the thermal zones give us
 	 * which sensor point to enable. If any thermal zone
 	 * was not described in the device tree, it won't be
 	 * enabled here in the sensor map.
 	 */
-	writel(sensor_map | BIT(9), LVTS_MONCTL0(lvts_ctrl->base));
+	if (lvts_ctrl->mode == LVTS_MSR_IMMEDIATE_MODE) {
+		/*
+		 * LVTS_MSRCTL1 : Measurement control
+		 *
+		 * Bits:
+		 *
+		 * 9: Ignore MSRCTL0 config and do immediate measurement on sensor3
+		 * 6: Ignore MSRCTL0 config and do immediate measurement on sensor2
+		 * 5: Ignore MSRCTL0 config and do immediate measurement on sensor1
+		 * 4: Ignore MSRCTL0 config and do immediate measurement on sensor0
+		 *
+		 * That configuration will ignore the filtering and the delays
+		 * introduced in MONCTL1 and MONCTL2
+		 */
+		writel(sensor_map, LVTS_MSRCTL1(lvts_ctrl->base));
+	} else {
+		/*
+		 * Bits:
+		 *      9: Single point access flow
+		 *    0-3: Enable sensing point 0-3
+		 */
+		writel(sensor_map | BIT(9), LVTS_MONCTL0(lvts_ctrl->base));
+	}
 
 	return 0;
 }
-- 
2.40.1



