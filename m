Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BC1398F8F;
	Wed,  3 Dec 2025 16:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781117; cv=none; b=ezgw2hrCJ05KwKzrjerqcqQixrvs0dHDsasWUOk5kOX66GmoaiE2ZLm14PEvmBCPRWdTFeINAtAFadvJRE43NH+b+6fZazn075o+u9bbalPGc8Mi8fkFwxJRErUEwmkiyOg63OSZgzEAgkcXgzxLcHcFvLQN5lLCoc1IADAINlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781117; c=relaxed/simple;
	bh=VryIaiU4V0fvhmisUtSgQ27c1ZKzA4XCJenAKDA01Dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nene5ELMnvdTQIKPRaqkY/GK8ONPWI9AGz+pfKFyz7KZPu81UosN34tX4ob3KSKBtevOeRbe1Y8C6Rz2h6UQF9wC9NeKveq102RM9iLhO/W0HNFwc0plAEp+vduietQkmsAFzrC6rwvELxgynsaAfaZisTOAV0Wy4B8NsU7sbUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EsX2C3Bq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EsX2C3Bq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA3BC4CEF5;
	Wed,  3 Dec 2025 16:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781115;
	bh=VryIaiU4V0fvhmisUtSgQ27c1ZKzA4XCJenAKDA01Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EsX2C3Bq61uNsOV2EoMNcv9kOi/wW47IBHoX6tNyOz4YDc+QJyTp8N+Mm+0esv+J8
	 fj2hPgaq6t4cZ/aSZWOCLkK9tU/393cFvWoMdlEIH2gEX0Jl8OI+/JtIHWTAWTGjGF
	 eM4iMGGt4lmdiJpmt9xFM0JUJuQPYreYeNiMzeFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Tesi <mario.tesi@st.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 21/93] iio: st_lsm6dsx: Fixed calibrated timestamp calculation
Date: Wed,  3 Dec 2025 16:29:14 +0100
Message-ID: <20251203152337.296222759@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c19237717e812..0f347684f6fc9 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
@@ -190,6 +190,22 @@ struct st_lsm6dsx_fifo_ops {
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
@@ -197,6 +213,8 @@ struct st_lsm6dsx_hw_ts_settings {
 	struct st_lsm6dsx_reg fifo_en;
 	struct st_lsm6dsx_reg decimator;
 	u8 freq_fine;
+	u16 ts_sensitivity;
+	u16 ts_trim_coeff;
 };
 
 /**
diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
index b6e6b1df8a618..6e42e0c659e0c 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -77,8 +77,6 @@
 
 #define ST_LSM6DSX_REG_WHOAMI_ADDR		0x0f
 
-#define ST_LSM6DSX_TS_SENSITIVITY		25000UL /* 25us */
-
 static const struct iio_chan_spec st_lsm6dsx_acc_channels[] = {
 	ST_LSM6DSX_CHANNEL_ACC(IIO_ACCEL, 0x28, IIO_MOD_X, 0),
 	ST_LSM6DSX_CHANNEL_ACC(IIO_ACCEL, 0x2a, IIO_MOD_Y, 1),
@@ -962,6 +960,8 @@ static const struct st_lsm6dsx_settings st_lsm6dsx_sensor_settings[] = {
 				.mask = GENMASK(7, 6),
 			},
 			.freq_fine = 0x63,
+			.ts_sensitivity = 25000,
+			.ts_trim_coeff = 37500,
 		},
 		.shub_settings = {
 			.page_mux = {
@@ -1175,6 +1175,8 @@ static const struct st_lsm6dsx_settings st_lsm6dsx_sensor_settings[] = {
 				.mask = GENMASK(7, 6),
 			},
 			.freq_fine = 0x63,
+			.ts_sensitivity = 25000,
+			.ts_trim_coeff = 37500,
 		},
 		.event_settings = {
 			.enable_reg = {
@@ -1350,6 +1352,8 @@ static const struct st_lsm6dsx_settings st_lsm6dsx_sensor_settings[] = {
 				.mask = GENMASK(7, 6),
 			},
 			.freq_fine = 0x4f,
+			.ts_sensitivity = 21701,
+			.ts_trim_coeff = 28212,
 		},
 		.shub_settings = {
 			.page_mux = {
@@ -2243,20 +2247,13 @@ static int st_lsm6dsx_init_hw_timer(struct st_lsm6dsx_hw *hw)
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



