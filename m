Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A481DF246;
	Thu, 17 Apr 2025 18:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915067; cv=none; b=ZDswPP3Exh/hft0UT97EcZoM4b6m8fIvyLSE6IwhERVcotWer769lprLKg3T5T3GPeOPK/UBi+26lW2MGGdtwiXT2V7pNx/9Q6eFA0ZcYlwU4iBW3PD2+F/uNpCIZiE/NXX5kii3Vv116miAYw/VYb4z/yBLRlNI0rh1n9fQfk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915067; c=relaxed/simple;
	bh=ERsrcrVIZizj36XnMz4nR0qnR4Ew4BLqHGuWq5TD0kA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=exwVMiwdei6JVwHgv85QJdvyt3WpuAfrQO018UnYNJlVva27nLAqRB4irmvk8NRtBttQQ+VtLigeJ60d96TNJ3JI+SlVKW/qL9rZJWt3SoRWIsZ5kYuZqMBZHgAWFJUW7K+yBmjdboPuV4Iy/It6iQ+/2wxCglArW3yButYUASE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b8Z4x7hm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b8Z4x7hm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F21C4CEE4;
	Thu, 17 Apr 2025 18:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915067;
	bh=ERsrcrVIZizj36XnMz4nR0qnR4Ew4BLqHGuWq5TD0kA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b8Z4x7hmGQ0nBVzEIt0LPz+EI3Gjfw9gMLXiaa2F5mETbzfIv+R6GVEiSMnT7p0M2
	 RfNm0ZccqsASLFBOOeXVO5zWuau7ElIC2ghgt4+HW0/X9Xsn12FTn9KopoHixVkvqx
	 5xSmabsmBb8Xou7auY0dXPdKy/CT66a9DGFQm/Uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 6.13 403/414] thermal/drivers/mediatek/lvts: Disable Stage 3 thermal threshold
Date: Thu, 17 Apr 2025 19:52:41 +0200
Message-ID: <20250417175127.688815108@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

commit c612cbcdf603aefb3358b2e3964dcd5aa3f827a0 upstream.

The Stage 3 thermal threshold is currently configured during
the controller initialization to 105 Celsius. From the kernel
perspective, this configuration is harmful because:
* The stage 3 interrupt that gets triggered when the threshold is
  crossed is not handled in any way by the IRQ handler, it just gets
  cleared. Besides, the temperature used for stage 3 comes from the
  sensors, and the critical thermal trip points described in the
  Devicetree will already cause a shutdown when crossed (at a lower
  temperature, of 100 Celsius, for all SoCs currently using this
  driver).
* The only effect of crossing the stage 3 threshold that has been
  observed is that it causes the machine to no longer be able to enter
  suspend. Even if that was a result of a momentary glitch in the
  temperature reading of a sensor (as has been observed on the
  MT8192-based Chromebooks).

For those reasons, disable the Stage 3 thermal threshold configuration.

Cc: stable@vger.kernel.org
Reported-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Closes: https://lore.kernel.org/all/20241108-lvts-v1-1-eee339c6ca20@chromium.org/
Fixes: f5f633b18234 ("thermal/drivers/mediatek: Add the Low Voltage Thermal Sensor driver")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://lore.kernel.org/r/20250113-mt8192-lvts-filtered-suspend-fix-v2-2-07a25200c7c6@collabora.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/mediatek/lvts_thermal.c |   16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

--- a/drivers/thermal/mediatek/lvts_thermal.c
+++ b/drivers/thermal/mediatek/lvts_thermal.c
@@ -65,7 +65,7 @@
 #define LVTS_HW_FILTER				0x0
 #define LVTS_TSSEL_CONF				0x13121110
 #define LVTS_CALSCALE_CONF			0x300
-#define LVTS_MONINT_CONF			0x8300318C
+#define LVTS_MONINT_CONF			0x0300318C
 
 #define LVTS_MONINT_OFFSET_SENSOR0		0xC
 #define LVTS_MONINT_OFFSET_SENSOR1		0x180
@@ -91,8 +91,6 @@
 #define LVTS_MSR_READ_TIMEOUT_US	400
 #define LVTS_MSR_READ_WAIT_US		(LVTS_MSR_READ_TIMEOUT_US / 2)
 
-#define LVTS_HW_TSHUT_TEMP		105000
-
 #define LVTS_MINIMUM_THRESHOLD		20000
 
 static int golden_temp = LVTS_GOLDEN_TEMP_DEFAULT;
@@ -145,7 +143,6 @@ struct lvts_ctrl {
 	struct lvts_sensor sensors[LVTS_SENSOR_MAX];
 	const struct lvts_data *lvts_data;
 	u32 calibration[LVTS_SENSOR_MAX];
-	u32 hw_tshut_raw_temp;
 	u8 valid_sensor_mask;
 	int mode;
 	void __iomem *base;
@@ -837,14 +834,6 @@ static int lvts_ctrl_init(struct device
 		 */
 		lvts_ctrl[i].mode = lvts_data->lvts_ctrl[i].mode;
 
-		/*
-		 * The temperature to raw temperature must be done
-		 * after initializing the calibration.
-		 */
-		lvts_ctrl[i].hw_tshut_raw_temp =
-			lvts_temp_to_raw(LVTS_HW_TSHUT_TEMP,
-					 lvts_data->temp_factor);
-
 		lvts_ctrl[i].low_thresh = INT_MIN;
 		lvts_ctrl[i].high_thresh = INT_MIN;
 	}
@@ -919,7 +908,6 @@ static int lvts_irq_init(struct lvts_ctr
 	 *         10 : Selected sensor with bits 19-18
 	 *         11 : Reserved
 	 */
-	writel(BIT(16), LVTS_PROTCTL(lvts_ctrl->base));
 
 	/*
 	 * LVTS_PROTTA : Stage 1 temperature threshold
@@ -932,8 +920,8 @@ static int lvts_irq_init(struct lvts_ctr
 	 *
 	 * writel(0x0, LVTS_PROTTA(lvts_ctrl->base));
 	 * writel(0x0, LVTS_PROTTB(lvts_ctrl->base));
+	 * writel(0x0, LVTS_PROTTC(lvts_ctrl->base));
 	 */
-	writel(lvts_ctrl->hw_tshut_raw_temp, LVTS_PROTTC(lvts_ctrl->base));
 
 	/*
 	 * LVTS_MONINT : Interrupt configuration register


