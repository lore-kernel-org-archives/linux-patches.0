Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BEBC471432;
	Tue, 21 Jul 2026 21:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667810; cv=none; b=jZ76cyW07kqqmyPCn4XAHQCQNk+nc51ecTGIgINpfGoOyWYEd3fZhMllhV5GElk7o37z+a1DCB01dy9rlUPaQKAtqsg9WpGRXVAbSHY+iaZy0Q7qed6ecSLZvkPz19Ay31zJESfDnQuzceDInhO5kfPxiy5NVzValDIPjaGub5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667810; c=relaxed/simple;
	bh=VDx7r5obNS/6xmqwB+zxrE9GMlFiWNtliSktKe1fkzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KWZxCRvZOfD6W42QAJZNuBDlMNlVD9T14+ZU6br/mI1kTFgP1rlF+gVU6hFVh/Ka3nAARxqEYN+5gLcOWtPD4pGZV7XvLRQaEqy1nNI0a4R6RQ7Xh2YTy8QaEBULFrfdSO8nCdhESxtVEsfQ+lP9kJRvdsyvFbCIqK0WUNHzh74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XaUwnOnM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XaUwnOnM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C911F000E9;
	Tue, 21 Jul 2026 21:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667806;
	bh=1Rqw+fShSLGDWjusk6xfFDXS7HPjS/1NiXSVGGQkLVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XaUwnOnMF1U2wQsR83jrhn7t36xAKzLII7qX5wMljWF6L1hs9gb6OBCH+1F1gnpSA
	 mL9QHQClFyZ+7TsgCOV1gps5aiWfOYDLxVxMQosuq9uQcLt8XmqXy9RfyWqTshRRdP
	 DXV9B/ls/7ZlxZKj9A+ycl4Wn9FQRrlganKPhF7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1158/1266] iio: invensense: fix timestamp glitches when switching frequency
Date: Tue, 21 Jul 2026 17:26:35 +0200
Message-ID: <20260721152507.697621265@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

[ Upstream commit bf8367b00c33c64a9391c262bb2e11d274c9f2a4 ]

When a sensor is running and there is a FIFO frequency change due to
another sensor turned on/off, there are glitches on timestamp. Fix that
by using only interrupt timestamp when there is the corresponding sensor
data in the FIFO.

Delete FIFO period handling and simplify internal functions.

Update integration inside inv_mpu6050 and inv_icm42600 drivers.

Fixes: 0ecc363ccea7 ("iio: make invensense timestamp module generic")
Cc: Stable@vger.kernel.org
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Link: https://lore.kernel.org/r/20240426094835.138389-1-inv.git-commit@tdk.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: affe3f077d7a ("iio: imu: inv_icm42600: fix timestamping by limiting FIFO reading")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/common/inv_sensors/inv_sensors_timestamp.c |   24 +++++++----------
 drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c     |   20 +++++---------
 drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c             |    2 -
 include/linux/iio/common/inv_sensors_timestamp.h       |    3 --
 4 files changed, 21 insertions(+), 28 deletions(-)

--- a/drivers/iio/common/inv_sensors/inv_sensors_timestamp.c
+++ b/drivers/iio/common/inv_sensors/inv_sensors_timestamp.c
@@ -78,13 +78,13 @@ int inv_sensors_timestamp_update_odr(str
 }
 EXPORT_SYMBOL_NS_GPL(inv_sensors_timestamp_update_odr, IIO_INV_SENSORS_TIMESTAMP);
 
-static bool inv_validate_period(struct inv_sensors_timestamp *ts, uint32_t period, uint32_t mult)
+static bool inv_validate_period(struct inv_sensors_timestamp *ts, uint32_t period)
 {
 	uint32_t period_min, period_max;
 
 	/* check that period is acceptable */
-	period_min = ts->min_period * mult;
-	period_max = ts->max_period * mult;
+	period_min = ts->min_period * ts->mult;
+	period_max = ts->max_period * ts->mult;
 	if (period > period_min && period < period_max)
 		return true;
 	else
@@ -92,15 +92,15 @@ static bool inv_validate_period(struct i
 }
 
 static bool inv_update_chip_period(struct inv_sensors_timestamp *ts,
-				    uint32_t mult, uint32_t period)
+				   uint32_t period)
 {
 	uint32_t new_chip_period;
 
-	if (!inv_validate_period(ts, period, mult))
+	if (!inv_validate_period(ts, period))
 		return false;
 
 	/* update chip internal period estimation */
-	new_chip_period = period / mult;
+	new_chip_period = period / ts->mult;
 	inv_update_acc(&ts->chip_period, new_chip_period);
 	ts->period = ts->mult * ts->chip_period.val;
 
@@ -133,16 +133,14 @@ static void inv_align_timestamp_it(struc
 }
 
 void inv_sensors_timestamp_interrupt(struct inv_sensors_timestamp *ts,
-				      uint32_t fifo_period, size_t fifo_nb,
-				      size_t sensor_nb, int64_t timestamp)
+				     size_t sample_nb, int64_t timestamp)
 {
 	struct inv_sensors_timestamp_interval *it;
 	int64_t delta, interval;
-	const uint32_t fifo_mult = fifo_period / ts->chip.clock_period;
 	uint32_t period;
 	bool valid = false;
 
-	if (fifo_nb == 0)
+	if (sample_nb == 0)
 		return;
 
 	/* update interrupt timestamp and compute chip and sensor periods */
@@ -152,14 +150,14 @@ void inv_sensors_timestamp_interrupt(str
 	delta = it->up - it->lo;
 	if (it->lo != 0) {
 		/* compute period: delta time divided by number of samples */
-		period = div_s64(delta, fifo_nb);
-		valid = inv_update_chip_period(ts, fifo_mult, period);
+		period = div_s64(delta, sample_nb);
+		valid = inv_update_chip_period(ts, period);
 	}
 
 	/* no previous data, compute theoritical value from interrupt */
 	if (ts->timestamp == 0) {
 		/* elapsed time: sensor period * sensor samples number */
-		interval = (int64_t)ts->period * (int64_t)sensor_nb;
+		interval = (int64_t)ts->period * (int64_t)sample_nb;
 		ts->timestamp = it->up - interval;
 		return;
 	}
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c
@@ -515,20 +515,20 @@ int inv_icm42600_buffer_fifo_parse(struc
 		return 0;
 
 	/* handle gyroscope timestamp and FIFO data parsing */
-	ts = iio_priv(st->indio_gyro);
-	inv_sensors_timestamp_interrupt(ts, st->fifo.period, st->fifo.nb.total,
-					st->fifo.nb.gyro, st->timestamp.gyro);
 	if (st->fifo.nb.gyro > 0) {
+		ts = iio_priv(st->indio_gyro);
+		inv_sensors_timestamp_interrupt(ts, st->fifo.nb.gyro,
+						st->timestamp.gyro);
 		ret = inv_icm42600_gyro_parse_fifo(st->indio_gyro);
 		if (ret)
 			return ret;
 	}
 
 	/* handle accelerometer timestamp and FIFO data parsing */
-	ts = iio_priv(st->indio_accel);
-	inv_sensors_timestamp_interrupt(ts, st->fifo.period, st->fifo.nb.total,
-					st->fifo.nb.accel, st->timestamp.accel);
 	if (st->fifo.nb.accel > 0) {
+		ts = iio_priv(st->indio_accel);
+		inv_sensors_timestamp_interrupt(ts, st->fifo.nb.accel,
+						st->timestamp.accel);
 		ret = inv_icm42600_accel_parse_fifo(st->indio_accel);
 		if (ret)
 			return ret;
@@ -556,9 +556,7 @@ int inv_icm42600_buffer_hwfifo_flush(str
 
 	if (st->fifo.nb.gyro > 0) {
 		ts = iio_priv(st->indio_gyro);
-		inv_sensors_timestamp_interrupt(ts, st->fifo.period,
-						st->fifo.nb.total, st->fifo.nb.gyro,
-						gyro_ts);
+		inv_sensors_timestamp_interrupt(ts, st->fifo.nb.gyro, gyro_ts);
 		ret = inv_icm42600_gyro_parse_fifo(st->indio_gyro);
 		if (ret)
 			return ret;
@@ -566,9 +564,7 @@ int inv_icm42600_buffer_hwfifo_flush(str
 
 	if (st->fifo.nb.accel > 0) {
 		ts = iio_priv(st->indio_accel);
-		inv_sensors_timestamp_interrupt(ts, st->fifo.period,
-						st->fifo.nb.total, st->fifo.nb.accel,
-						accel_ts);
+		inv_sensors_timestamp_interrupt(ts, st->fifo.nb.accel, accel_ts);
 		ret = inv_icm42600_accel_parse_fifo(st->indio_accel);
 		if (ret)
 			return ret;
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c
@@ -113,7 +113,7 @@ irqreturn_t inv_mpu6050_read_fifo(int ir
 		goto end_session;
 	/* Each FIFO data contains all sensors, so same number for FIFO and sensor data */
 	fifo_period = NSEC_PER_SEC / INV_MPU6050_DIVIDER_TO_FIFO_RATE(st->chip_config.divider);
-	inv_sensors_timestamp_interrupt(&st->timestamp, fifo_period, nb, nb, pf->timestamp);
+	inv_sensors_timestamp_interrupt(&st->timestamp, nb, pf->timestamp);
 	inv_sensors_timestamp_apply_odr(&st->timestamp, fifo_period, nb, 0);
 
 	/* clear internal data buffer for avoiding kernel data leak */
--- a/include/linux/iio/common/inv_sensors_timestamp.h
+++ b/include/linux/iio/common/inv_sensors_timestamp.h
@@ -71,8 +71,7 @@ int inv_sensors_timestamp_update_odr(str
 				     uint32_t period, bool fifo);
 
 void inv_sensors_timestamp_interrupt(struct inv_sensors_timestamp *ts,
-				     uint32_t fifo_period, size_t fifo_nb,
-				     size_t sensor_nb, int64_t timestamp);
+				     size_t sample_nb, int64_t timestamp);
 
 static inline int64_t inv_sensors_timestamp_pop(struct inv_sensors_timestamp *ts)
 {


