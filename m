Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9555C32F740;
	Wed,  3 Dec 2025 15:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777085; cv=none; b=BLKP3kRVqaKO7973TZfatsTNi1Zszba+xNB6lwxmWZbNx5Mft4LV8knBHGncngjrVmPm2xJqlMeeiYiO7e8lBX2TzZOvZhpobf47vBLO9NaYdbQdgAL+XpfOU+z9cUI7khWTbBKRnxsOjXsqqT4ijZAyHQ7UoM6UueHJYGNoMtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777085; c=relaxed/simple;
	bh=5dCtNvFhJx1E1oWOl+Cnw3bJZDV5vEJU4/K096+OpkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qCDQAmMn5jh5ggap+38q2sf+4TWOyvyGshzSXMclUu2pYUMjkfFR4AAa2/3eCZVFT/EUyiwCd1zOo1fukfgFnAGTvnmpW9To8366N2ZjuxaxdM8EvakUze0U5uxkwdGUYe26IRlD2bootBhVIbEfJ788GmJ6QvuUAq3y6olkQuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sctbwr1B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sctbwr1B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7FBC4CEF5;
	Wed,  3 Dec 2025 15:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777085;
	bh=5dCtNvFhJx1E1oWOl+Cnw3bJZDV5vEJU4/K096+OpkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sctbwr1B8cc9vQB6yr1uFB8kRaPk5ccAAyomwLGgA7dhP7n1ljCdZPRZGAEL6xVBp
	 KzWCQjdmiWZxe6FEtWzMDrt1+rMcgWFAzgoWVdXZ8yoH/mIu478XFgJyaLnBTLsCOl
	 bRnCrjekTZ4+1jorJwssqbpvjwe+Y3rPqXgw0J4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Tesi <mario.tesi@st.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 034/146] iio: st_lsm6dsx: Fixed calibrated timestamp calculation
Date: Wed,  3 Dec 2025 16:26:52 +0100
Message-ID: <20251203152347.722058052@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Tesi <martepisa@gmail.com>

[ Upstream commit 8abbf45fcda028c2c05ba38eb14ede9fa9e7341b ]

The calibrated timestamp is calculated from the nominal value using the
formula:
  ts_gain[ns] ≈ ts_sensitivity - (ts_trim_coeff * val) / 1000.

The values of ts_sensitivity and ts_trim_coeff are not the same for all
devices, so it is necessary to differentiate them based on the part name.
For the correct values please consult the relevant AN.

Fixes: cb3b6b8e1bc0 ("iio: imu: st_lsm6dsx: add odr calibration feature")
Signed-off-by: Mario Tesi <mario.tesi@st.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h      | 18 ++++++++++++++++++
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c | 19 ++++++++-----------
 2 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
index c225b246c8a55..f8486a1b02d07 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
@@ -192,6 +192,22 @@ struct st_lsm6dsx_fifo_ops {
  * @fifo_en: Hw timer FIFO enable register info (addr + mask).
  * @decimator: Hw timer FIFO decimator register info (addr + mask).
  * @freq_fine: Difference in % of ODR with respect to the typical.
+ * @ts_sensitivity: Nominal timestamp sensitivity.
+ * @ts_trim_coeff: Coefficient for calculating the calibrated timestamp gain.
+ *                 This coefficient comes into play when linearizing the formula
+ *                 used to calculate the calibrated timestamp (please see the
+ *                 relevant formula in the AN for the specific IMU).
+ *                 For example, in the case of LSM6DSO we have:
+ *
+ *                  1 / (1 + x) ~= 1 - x (Taylor’s Series)
+ *                  ttrim[s] = 1 / (40000 * (1 + 0.0015 * val)) (from AN5192)
+ *                  ttrim[ns] ~= 25000 - 37.5 * val
+ *                  ttrim[ns] ~= 25000 - (37500 * val) / 1000
+ *
+ *                  so, replacing ts_sensitivity = 25000 and
+ *                  ts_trim_coeff = 37500
+ *
+ *                  ttrim[ns] ~= ts_sensitivity - (ts_trim_coeff * val) / 1000
  */
 struct st_lsm6dsx_hw_ts_settings {
 	struct st_lsm6dsx_reg timer_en;
@@ -199,6 +215,8 @@ struct st_lsm6dsx_hw_ts_settings {
 	struct st_lsm6dsx_reg fifo_en;
 	struct st_lsm6dsx_reg decimator;
 	u8 freq_fine;
+	u16 ts_sensitivity;
+	u16 ts_trim_coeff;
 };
 
 /**
diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
index c65ad49829e7d..72d8af39a9535 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -94,8 +94,6 @@
 
 #define ST_LSM6DSX_REG_WHOAMI_ADDR		0x0f
 
-#define ST_LSM6DSX_TS_SENSITIVITY		25000UL /* 25us */
-
 static const struct iio_chan_spec st_lsm6dsx_acc_channels[] = {
 	ST_LSM6DSX_CHANNEL_ACC(IIO_ACCEL, 0x28, IIO_MOD_X, 0),
 	ST_LSM6DSX_CHANNEL_ACC(IIO_ACCEL, 0x2a, IIO_MOD_Y, 1),
@@ -983,6 +981,8 @@ static const struct st_lsm6dsx_settings st_lsm6dsx_sensor_settings[] = {
 				.mask = GENMASK(7, 6),
 			},
 			.freq_fine = 0x63,
+			.ts_sensitivity = 25000,
+			.ts_trim_coeff = 37500,
 		},
 		.shub_settings = {
 			.page_mux = {
@@ -1196,6 +1196,8 @@ static const struct st_lsm6dsx_settings st_lsm6dsx_sensor_settings[] = {
 				.mask = GENMASK(7, 6),
 			},
 			.freq_fine = 0x63,
+			.ts_sensitivity = 25000,
+			.ts_trim_coeff = 37500,
 		},
 		.event_settings = {
 			.enable_reg = {
@@ -1371,6 +1373,8 @@ static const struct st_lsm6dsx_settings st_lsm6dsx_sensor_settings[] = {
 				.mask = GENMASK(7, 6),
 			},
 			.freq_fine = 0x4f,
+			.ts_sensitivity = 21701,
+			.ts_trim_coeff = 28212,
 		},
 		.shub_settings = {
 			.page_mux = {
@@ -2248,20 +2252,13 @@ static int st_lsm6dsx_init_hw_timer(struct st_lsm6dsx_hw *hw)
 	}
 
 	/* calibrate timestamp sensitivity */
-	hw->ts_gain = ST_LSM6DSX_TS_SENSITIVITY;
+	hw->ts_gain = ts_settings->ts_sensitivity;
 	if (ts_settings->freq_fine) {
 		err = regmap_read(hw->regmap, ts_settings->freq_fine, &val);
 		if (err < 0)
 			return err;
 
-		/*
-		 * linearize the AN5192 formula:
-		 * 1 / (1 + x) ~= 1 - x (Taylor’s Series)
-		 * ttrim[s] = 1 / (40000 * (1 + 0.0015 * val))
-		 * ttrim[ns] ~= 25000 - 37.5 * val
-		 * ttrim[ns] ~= 25000 - (37500 * val) / 1000
-		 */
-		hw->ts_gain -= ((s8)val * 37500) / 1000;
+		hw->ts_gain -= ((s8)val * ts_settings->ts_trim_coeff) / 1000;
 	}
 
 	return 0;
-- 
2.51.0



