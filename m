Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3859223C7B;
	Thu, 12 Dec 2024 15:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018629; cv=none; b=sKLnKdF1bfM+ZkVljcaAz12QqnEgDpbUaPzjTLLkik+4eAkdv4gemNUcKIjF0auJrF1NVttVURnJWy5YtbfWtZFeXS7i/pufSZHUBqXIInPnXTmiCMYV7w74YgoJMZItUsSXewh+7nuiHvta6b1cqKWIFGde+hCCS29tj/hWh30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018629; c=relaxed/simple;
	bh=Hj9MusyfVGx8OVuJj7ZRwNgag3YFeInTMWRS/8uLbp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZdteST6wR/ZVwrn55eAvMkdz+gQ6G1yl266lSNi2PxiOvJ7x8H9tilO91sVx8omRvuyli7uV0cgKR7gnDFnZhjyEJCuMJkDAjvfXAJ0qpsioaFjEqeB/YjkaBW9N6SGT8gVZhFHJ+5C6Cq47bb0Cprh0fBT3haGWwfZY3JkD7/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xAeZ3Agv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xAeZ3Agv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA31C4CED0;
	Thu, 12 Dec 2024 15:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018629;
	bh=Hj9MusyfVGx8OVuJj7ZRwNgag3YFeInTMWRS/8uLbp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xAeZ3AgvX1mbk9m5tGU+Ikp9esYNQg2ZEuRAX8lMthwKlriPWGb4X9Xgh5d9kXfkJ
	 uv6DKKgQdqiNrfCA0DEN7f2iI0/FfD1PcdOwsvhxmeBjFPAferkwzj841epnP/q/tT
	 NHei/rLuT5P2GLC/oTcnBZimvQRVAWph1WrmIP+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 344/356] iio: invensense: fix multiple odr switch when FIFO is off
Date: Thu, 12 Dec 2024 16:01:03 +0100
Message-ID: <20241212144258.159244390@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

commit ef5f5e7b6f73f79538892a8be3a3bee2342acc9f upstream.

When multiple ODR switch happens during FIFO off, the change could
not be taken into account if you get back to previous FIFO on value.
For example, if you run sensor buffer at 50Hz, stop, change to
200Hz, then back to 50Hz and restart buffer, data will be timestamped
at 200Hz. This due to testing against mult and not new_mult.

To prevent this, let's just run apply_odr automatically when FIFO is
off. It will also simplify driver code.

Update inv_mpu6050 and inv_icm42600 to delete now useless apply_odr.

Fixes: 95444b9eeb8c ("iio: invensense: fix odr switching to same value")
Cc: stable@vger.kernel.org
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Link: https://patch.msgid.link/20241021-invn-inv-sensors-timestamp-fix-switch-fifo-off-v2-1-39ffd43edcc4@tdk.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/common/inv_sensors/inv_sensors_timestamp.c |    4 ++++
 drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c      |    2 --
 drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c       |    2 --
 drivers/iio/imu/inv_mpu6050/inv_mpu_trigger.c          |    1 -
 4 files changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/iio/common/inv_sensors/inv_sensors_timestamp.c
+++ b/drivers/iio/common/inv_sensors/inv_sensors_timestamp.c
@@ -70,6 +70,10 @@ int inv_sensors_timestamp_update_odr(str
 	if (mult != ts->mult)
 		ts->new_mult = mult;
 
+	/* When FIFO is off, directly apply the new ODR */
+	if (!fifo)
+		inv_sensors_timestamp_apply_odr(ts, 0, 0, 0);
+
 	return 0;
 }
 EXPORT_SYMBOL_NS_GPL(inv_sensors_timestamp_update_odr, IIO_INV_SENSORS_TIMESTAMP);
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
@@ -99,7 +99,6 @@ static int inv_icm42600_accel_update_sca
 					       const unsigned long *scan_mask)
 {
 	struct inv_icm42600_state *st = iio_device_get_drvdata(indio_dev);
-	struct inv_sensors_timestamp *ts = iio_priv(indio_dev);
 	struct inv_icm42600_sensor_conf conf = INV_ICM42600_SENSOR_CONF_INIT;
 	unsigned int fifo_en = 0;
 	unsigned int sleep_temp = 0;
@@ -127,7 +126,6 @@ static int inv_icm42600_accel_update_sca
 	}
 
 	/* update data FIFO write */
-	inv_sensors_timestamp_apply_odr(ts, 0, 0, 0);
 	ret = inv_icm42600_buffer_set_fifo_en(st, fifo_en | st->fifo.en);
 
 out_unlock:
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
@@ -99,7 +99,6 @@ static int inv_icm42600_gyro_update_scan
 					      const unsigned long *scan_mask)
 {
 	struct inv_icm42600_state *st = iio_device_get_drvdata(indio_dev);
-	struct inv_sensors_timestamp *ts = iio_priv(indio_dev);
 	struct inv_icm42600_sensor_conf conf = INV_ICM42600_SENSOR_CONF_INIT;
 	unsigned int fifo_en = 0;
 	unsigned int sleep_gyro = 0;
@@ -127,7 +126,6 @@ static int inv_icm42600_gyro_update_scan
 	}
 
 	/* update data FIFO write */
-	inv_sensors_timestamp_apply_odr(ts, 0, 0, 0);
 	ret = inv_icm42600_buffer_set_fifo_en(st, fifo_en | st->fifo.en);
 
 out_unlock:
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_trigger.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_trigger.c
@@ -111,7 +111,6 @@ int inv_mpu6050_prepare_fifo(struct inv_
 	if (enable) {
 		/* reset timestamping */
 		inv_sensors_timestamp_reset(&st->timestamp);
-		inv_sensors_timestamp_apply_odr(&st->timestamp, 0, 0, 0);
 		/* reset FIFO */
 		d = st->chip_config.user_ctrl | INV_MPU6050_BIT_FIFO_RST;
 		ret = regmap_write(st->map, st->reg->user_ctrl, d);


