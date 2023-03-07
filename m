Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB130BA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:38:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5178BC433EF;
	Tue,  7 Mar 2023 17:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210699;
	bh=ymLtC62DHR4njtCXvOI1cjH7nnpc35uC9aPj7HANB4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ek3wj3lgyf4ZmWjwjrdIev3cGea8gehtprRz/Gg3xE9h1LHBWYaRGnycZrwn9wZVW
	 unigS1FsvAtQI5wFQ1SiDRiHwwNpGpD6elWHVi/XNpr7yU+KtzOFnKqLMv8ANBPi+A
	 qlNEUylPTuFombMAR81JGTRzD0iST+/vIM7qhpJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nishanth Menon <nm@ti.com>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Jai Luthra <j-luthra@ti.com>,
	Jacopo Mondi <jacopo.mondi@ideasonaboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0595/1001] media: ov5640: Fix soft reset sequence and timings
Date: Tue,  7 Mar 2023 17:56:07 +0100
Message-Id: <20230307170047.323888350@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jai Luthra <j-luthra@ti.com>

[ Upstream commit decea0a98b7ac04536c7d659f74783e8d67a06c0 ]

Move the register-based reset out of the init_setting[] and into the
powerup_sequence function. The sensor is power cycled and reset using
the gpio pins so the soft reset is not always necessary.

This also ensures that soft reset honors the timing sequence
from the datasheet [1].

[1] https://cdn.sparkfun.com/datasheets/Sensors/LightImaging/OV5640_datasheet.pdf

Fixes: 19a81c1426c1 ("[media] add Omnivision OV5640 sensor driver")
Reported-by: Nishanth Menon <nm@ti.com>
Suggested-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Jai Luthra <j-luthra@ti.com>
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonaboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5640.c | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index e0f908af581b8..75dada60298b5 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -50,6 +50,7 @@
 #define OV5640_REG_SYS_CTRL0		0x3008
 #define OV5640_REG_SYS_CTRL0_SW_PWDN	0x42
 #define OV5640_REG_SYS_CTRL0_SW_PWUP	0x02
+#define OV5640_REG_SYS_CTRL0_SW_RST	0x82
 #define OV5640_REG_CHIP_ID		0x300a
 #define OV5640_REG_IO_MIPI_CTRL00	0x300e
 #define OV5640_REG_PAD_OUTPUT_ENABLE01	0x3017
@@ -532,7 +533,7 @@ static const struct v4l2_mbus_framefmt ov5640_default_fmt = {
 };
 
 static const struct reg_value ov5640_init_setting[] = {
-	{0x3103, 0x11, 0, 0}, {0x3008, 0x82, 0, 5}, {0x3008, 0x42, 0, 0},
+	{0x3103, 0x11, 0, 0},
 	{0x3103, 0x03, 0, 0}, {0x3630, 0x36, 0, 0},
 	{0x3631, 0x0e, 0, 0}, {0x3632, 0xe2, 0, 0}, {0x3633, 0x12, 0, 0},
 	{0x3621, 0xe0, 0, 0}, {0x3704, 0xa0, 0, 0}, {0x3703, 0x5a, 0, 0},
@@ -2429,19 +2430,32 @@ static void ov5640_reset(struct ov5640_dev *sensor)
 	if (!sensor->reset_gpio)
 		return;
 
-	gpiod_set_value_cansleep(sensor->reset_gpio, 0);
+	if (sensor->pwdn_gpio) {
+		gpiod_set_value_cansleep(sensor->reset_gpio, 0);
 
-	/* camera power cycle */
-	ov5640_power(sensor, false);
-	usleep_range(5000, 10000);
-	ov5640_power(sensor, true);
-	usleep_range(5000, 10000);
+		/* camera power cycle */
+		ov5640_power(sensor, false);
+		usleep_range(5000, 10000);
+		ov5640_power(sensor, true);
+		usleep_range(5000, 10000);
 
-	gpiod_set_value_cansleep(sensor->reset_gpio, 1);
-	usleep_range(1000, 2000);
+		gpiod_set_value_cansleep(sensor->reset_gpio, 1);
+		usleep_range(1000, 2000);
 
-	gpiod_set_value_cansleep(sensor->reset_gpio, 0);
+		gpiod_set_value_cansleep(sensor->reset_gpio, 0);
+	} else {
+		/* software reset */
+		ov5640_write_reg(sensor, OV5640_REG_SYS_CTRL0,
+				 OV5640_REG_SYS_CTRL0_SW_RST);
+	}
 	usleep_range(20000, 25000);
+
+	/*
+	 * software standby: allows registers programming;
+	 * exit at restore_mode() for CSI, s_stream(1) for DVP
+	 */
+	ov5640_write_reg(sensor, OV5640_REG_SYS_CTRL0,
+			 OV5640_REG_SYS_CTRL0_SW_PWDN);
 }
 
 static int ov5640_set_power_on(struct ov5640_dev *sensor)
-- 
2.39.2



