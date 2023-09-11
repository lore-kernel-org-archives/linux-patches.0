Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18CA61170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7F6C433C7;
	Mon, 11 Sep 2023 14:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442016;
	bh=5FkymuVd601f5pxD1FxsHB3dtRHVkH1yBrLfUCo4s/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lTpINjYe7JYPKgRLImr87ZFBaVwTsZewECA5/k2T8S6AfRrbHZp3usuARinWf0pJv
	 e/gUBuGWCwc9zNuIFciQ8NuFVOPH7gsK/Vgfk6os0yDXdlG0X7HY8qHCfHENDDdD2W
	 kR61MKQjldcjj0QXmoFKEWWMp8d69rAu+W50l40c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Alexandre Mergnat <amergnat@baylibre.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 609/739] thermal/drivers/mediatek/lvts_thermal: Manage threshold between sensors
Date: Mon, 11 Sep 2023 15:46:48 +0200
Message-ID: <20230911134708.107901812@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 2bba1acf7a4cbe62abbb4c686e0414209ec5943b ]

Each LVTS thermal controller can have up to four sensors, each capable
of triggering its own interrupt when its measured temperature crosses
the configured threshold. The threshold for each sensor is handled
separately by the thermal framework, since each one is registered with
its own thermal zone and trips. However, the temperature thresholds are
configured on the controller, and therefore are shared between all
sensors on that controller.

When the temperature measured by the sensors is different enough to
cause the thermal framework to configure different thresholds for each
one, interrupts start triggering on sensors outside the last threshold
configured.

To address the issue, track the thresholds required by each sensor and
only actually set the highest one in the hardware, and disable
interrupts for all sensors outside the current configured range.

Fixes: f5f633b18234 ("thermal/drivers/mediatek: Add the Low Voltage Thermal Sensor driver")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: Alexandre Mergnat <amergnat@baylibre.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20230706153823.201943-7-nfraprado@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/mediatek/lvts_thermal.c | 69 +++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/drivers/thermal/mediatek/lvts_thermal.c b/drivers/thermal/mediatek/lvts_thermal.c
index 064269667fb89..b0d71b74a928e 100644
--- a/drivers/thermal/mediatek/lvts_thermal.c
+++ b/drivers/thermal/mediatek/lvts_thermal.c
@@ -67,6 +67,11 @@
 #define LVTS_CALSCALE_CONF			0x300
 #define LVTS_MONINT_CONF			0x8300318C
 
+#define LVTS_MONINT_OFFSET_SENSOR0		0xC
+#define LVTS_MONINT_OFFSET_SENSOR1		0x180
+#define LVTS_MONINT_OFFSET_SENSOR2		0x3000
+#define LVTS_MONINT_OFFSET_SENSOR3		0x3000000
+
 #define LVTS_INT_SENSOR0			0x0009001F
 #define LVTS_INT_SENSOR1			0x001203E0
 #define LVTS_INT_SENSOR2			0x00247C00
@@ -112,6 +117,8 @@ struct lvts_sensor {
 	void __iomem *base;
 	int id;
 	int dt_id;
+	int low_thresh;
+	int high_thresh;
 };
 
 struct lvts_ctrl {
@@ -121,6 +128,8 @@ struct lvts_ctrl {
 	int num_lvts_sensor;
 	int mode;
 	void __iomem *base;
+	int low_thresh;
+	int high_thresh;
 };
 
 struct lvts_domain {
@@ -292,12 +301,66 @@ static int lvts_get_temp(struct thermal_zone_device *tz, int *temp)
 	return 0;
 }
 
+static void lvts_update_irq_mask(struct lvts_ctrl *lvts_ctrl)
+{
+	u32 masks[] = {
+		LVTS_MONINT_OFFSET_SENSOR0,
+		LVTS_MONINT_OFFSET_SENSOR1,
+		LVTS_MONINT_OFFSET_SENSOR2,
+		LVTS_MONINT_OFFSET_SENSOR3,
+	};
+	u32 value = 0;
+	int i;
+
+	value = readl(LVTS_MONINT(lvts_ctrl->base));
+
+	for (i = 0; i < ARRAY_SIZE(masks); i++) {
+		if (lvts_ctrl->sensors[i].high_thresh == lvts_ctrl->high_thresh
+		    && lvts_ctrl->sensors[i].low_thresh == lvts_ctrl->low_thresh)
+			value |= masks[i];
+		else
+			value &= ~masks[i];
+	}
+
+	writel(value, LVTS_MONINT(lvts_ctrl->base));
+}
+
+static bool lvts_should_update_thresh(struct lvts_ctrl *lvts_ctrl, int high)
+{
+	int i;
+
+	if (high > lvts_ctrl->high_thresh)
+		return true;
+
+	for (i = 0; i < lvts_ctrl->num_lvts_sensor; i++)
+		if (lvts_ctrl->sensors[i].high_thresh == lvts_ctrl->high_thresh
+		    && lvts_ctrl->sensors[i].low_thresh == lvts_ctrl->low_thresh)
+			return false;
+
+	return true;
+}
+
 static int lvts_set_trips(struct thermal_zone_device *tz, int low, int high)
 {
 	struct lvts_sensor *lvts_sensor = thermal_zone_device_priv(tz);
+	struct lvts_ctrl *lvts_ctrl = container_of(lvts_sensor, struct lvts_ctrl, sensors[lvts_sensor->id]);
 	void __iomem *base = lvts_sensor->base;
 	u32 raw_low = lvts_temp_to_raw(low != -INT_MAX ? low : LVTS_MINIMUM_THRESHOLD);
 	u32 raw_high = lvts_temp_to_raw(high);
+	bool should_update_thresh;
+
+	lvts_sensor->low_thresh = low;
+	lvts_sensor->high_thresh = high;
+
+	should_update_thresh = lvts_should_update_thresh(lvts_ctrl, high);
+	if (should_update_thresh) {
+		lvts_ctrl->high_thresh = high;
+		lvts_ctrl->low_thresh = low;
+	}
+	lvts_update_irq_mask(lvts_ctrl);
+
+	if (!should_update_thresh)
+		return 0;
 
 	/*
 	 * Low offset temperature threshold
@@ -521,6 +584,9 @@ static int lvts_sensor_init(struct device *dev, struct lvts_ctrl *lvts_ctrl,
 		 */
 		lvts_sensor[i].msr = lvts_ctrl_data->mode == LVTS_MSR_IMMEDIATE_MODE ?
 			imm_regs[i] : msr_regs[i];
+
+		lvts_sensor[i].low_thresh = INT_MIN;
+		lvts_sensor[i].high_thresh = INT_MIN;
 	};
 
 	lvts_ctrl->num_lvts_sensor = lvts_ctrl_data->num_lvts_sensor;
@@ -688,6 +754,9 @@ static int lvts_ctrl_init(struct device *dev, struct lvts_domain *lvts_td,
 		 */
 		lvts_ctrl[i].hw_tshut_raw_temp =
 			lvts_temp_to_raw(lvts_data->lvts_ctrl[i].hw_tshut_temp);
+
+		lvts_ctrl[i].low_thresh = INT_MIN;
+		lvts_ctrl[i].high_thresh = INT_MIN;
 	}
 
 	/*
-- 
2.40.1



