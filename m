Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521EA11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC452C433C7;
	Mon, 11 Sep 2023 14:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443964;
	bh=TIYCGYWcAS/YBETAIAbpHFWqr4h2kk+uYUKoVVAswXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ufF9jkeRa7oQQDtehBvZz9ZfOGThL1OZf5FRvHj0zVx5HjBxUQuS89Ft05C6M/TgP
	 4dmHgw9GUQKHaAQr41voWM8VbEb3Gw8Chz5J/DXKHRAzwuRN7tIBbjsNtjxeEN3hkE
	 HqGJo3u1sE/Gzu/A1fv3chbWNmolLne6AX0GLH8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Marek Vasut <marex@denx.de>,
	Jai Luthra <j-luthra@ti.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 563/737] media: ov5640: Fix initial RESETB state and annotate timings
Date: Mon, 11 Sep 2023 15:47:02 +0200
Message-ID: <20230911134706.277713112@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit a210df337c5f5c2cd82f36c9dbb154ec63365c80 ]

The initial state of RESETB input signal of OV5640 should be
asserted, i.e. the sensor should be in reset. This is not the
case, make it so.

Since the subsequent assertion of RESETB signal is no longer
necessary and the timing of the power sequencing could be
slightly adjusted, add annotations to the delays which match
OV5640 datasheet rev. 2.03, both:
  figure 2-3 power up timing with internal DVDD
  figure 2-4 power up timing with external DVDD source

The 5..10ms delay between PWDN assertion and RESETB assertion
is not even documented in the power sequencing diagram, and
with this reset fix, it is no longer even necessary.

Fixes: 19a81c1426c1 ("[media] add Omnivision OV5640 sensor driver")
Reported-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Tested-by: Jai Luthra <j-luthra@ti.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5640.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 74cfe2d373577..bf50705ad6d36 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -2452,16 +2452,13 @@ static void ov5640_power(struct ov5640_dev *sensor, bool enable)
 static void ov5640_powerup_sequence(struct ov5640_dev *sensor)
 {
 	if (sensor->pwdn_gpio) {
-		gpiod_set_value_cansleep(sensor->reset_gpio, 0);
+		gpiod_set_value_cansleep(sensor->reset_gpio, 1);
 
 		/* camera power cycle */
 		ov5640_power(sensor, false);
-		usleep_range(5000, 10000);
+		usleep_range(5000, 10000);	/* t2 */
 		ov5640_power(sensor, true);
-		usleep_range(5000, 10000);
-
-		gpiod_set_value_cansleep(sensor->reset_gpio, 1);
-		usleep_range(1000, 2000);
+		usleep_range(1000, 2000);	/* t3 */
 
 		gpiod_set_value_cansleep(sensor->reset_gpio, 0);
 	} else {
@@ -2469,7 +2466,7 @@ static void ov5640_powerup_sequence(struct ov5640_dev *sensor)
 		ov5640_write_reg(sensor, OV5640_REG_SYS_CTRL0,
 				 OV5640_REG_SYS_CTRL0_SW_RST);
 	}
-	usleep_range(20000, 25000);
+	usleep_range(20000, 25000);	/* t4 */
 
 	/*
 	 * software standby: allows registers programming;
-- 
2.40.1



