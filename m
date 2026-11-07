Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062824;
	b=KOcglPS79Hc04Pkc0x6hWpCJQoQ27fmwSZXMwYTOxh31X+5g2Ory2nwf+Nzr5lu39uRy
	 7mwrPMBMFXNvkYKWQDSqMqc6LzhzV5yJndgYu2ZIzN06wQN5tDQNgV0C+sRWdxJsHs+kI
	 bmGsGrzOVU2C/TZ4anRYj0H5CXe5ZEqCVhkcL00XlTw73xY4+elWK1tVBvH1ZOVDrn8vp
	 BazTXF0P7rHeeKJjLjDL1FurEeB6VL6PLo3wieGCwyKxIJQG3gV3sHTkXyTyE7FlCpnHe
	 Cts2Wy3lKQyhmMqwcEmHnegimuN95v/TlCWZ8qm2lJiWAwwTl9FmUc2GgxhZ3BfrZXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062824;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NacYEVmPDzOFCtoK934aQwejytr3fTmf2dc3HJOJPSs=;
	b=BpY4hML7pJboDXz+OIwp/qoeBIkWMj2bmm7eqlDuHsEGl8BiNV08oZRmGbA+1UAsR/z2
	 brz4PbrdLD8SOMQZsKNWmfFrG+SqRgcRhiv0KG3kC0GdqG5h/TErctUkF6YGFLgjO+Y2y
	 VgQjbLoJHAoIbIQkGJJtZTH4z3YOOVo2ItCwYwactKGfumdMIKOe5MHPnSRyTZlVsENjd
	 +xtzjrRhyjoPLZa8KVnOAhs0ubsxgpf4uoV4b1pnitEfLz4zoisunoYJIJ8TdEYU3Kxgy
	 lJXIuTQb+EZdW2rcofC+NhPeQpgXBY+3eBltF4X2EGoIr/xww0DVGfhI51uVT68v5QA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JLT7k1H5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137D2606A334;
	Sat,  7 Nov 2026 14:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JLT7k1H5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C981F0089F;
	Sat,  7 Nov 2026 14:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062823;
	bh=NacYEVmPDzOFCtoK934aQwejytr3fTmf2dc3HJOJPSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JLT7k1H551N+QxKT+nAF7PL5AamQphYKuMbsjV0tbRVc5YAj7NSyKOQeIaMwJhxvA
	 E2xKL+0OoZaPHCkDTWxfwzGFUQIUhhaz1xRkeaRRrBx0Hd8dNYd4j3007TtmQupUoD
	 S8SINKPM6UCtCmYWK0hg1oASPRRwSv1q4dtU2yzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 120/869] iio: imu: inv_icm42600: fix odr change not caught in certain cases
Date: Sat,  7 Nov 2026 08:46:42 -0500
Message-ID: <20261107134856.595327765@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

[ Upstream commit f670d4d3477386d62017936f0121909f93ac17f8 ]

When using both accel and gyro with different frequencies, the ODR
change flag in the FIFO header can be sometime in a packet with
invalid data. Since we are ignoring these packets, we miss the ODR
change and any further change are blocked until sensor is turned off.

Fix this by moving the packet data validity check after the ODR change
flag check.

Fixes: ec74ae9fd37c ("iio: imu: inv_icm42600: add accurate timestamping")
Cc: stable@vger.kernel.org
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c | 8 ++++----
 drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c  | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c b/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
index 96a6213770d41..d19ff0e76c668 100644
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
@@ -1225,15 +1225,15 @@ int inv_icm42600_accel_parse_fifo(struct iio_dev *indio_dev)
 		if (size <= 0)
 			return size;
 
-		/* skip packet if no accel data or data is invalid */
-		if (accel == NULL || !inv_icm42600_fifo_is_data_valid(accel))
-			continue;
-
 		/* update odr */
 		if (odr & INV_ICM42600_SENSOR_ACCEL)
 			inv_sensors_timestamp_apply_odr(ts, st->fifo.period,
 							st->fifo.nb.total, no);
 
+		/* skip packet if no accel data or data is invalid */
+		if (accel == NULL || !inv_icm42600_fifo_is_data_valid(accel))
+			continue;
+
 		memcpy(&buffer.accel, accel, sizeof(buffer.accel));
 		/* convert 8 bits FIFO temperature in high resolution format */
 		buffer.temp = temp ? (*temp * 64) : 0;
diff --git a/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c b/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
index a18dcac939298..194838d88284c 100644
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
@@ -806,15 +806,15 @@ int inv_icm42600_gyro_parse_fifo(struct iio_dev *indio_dev)
 		if (size <= 0)
 			return size;
 
-		/* skip packet if no gyro data or data is invalid */
-		if (gyro == NULL || !inv_icm42600_fifo_is_data_valid(gyro))
-			continue;
-
 		/* update odr */
 		if (odr & INV_ICM42600_SENSOR_GYRO)
 			inv_sensors_timestamp_apply_odr(ts, st->fifo.period,
 							st->fifo.nb.total, no);
 
+		/* skip packet if no gyro data or data is invalid */
+		if (gyro == NULL || !inv_icm42600_fifo_is_data_valid(gyro))
+			continue;
+
 		memcpy(&buffer.gyro, gyro, sizeof(buffer.gyro));
 		/* convert 8 bits FIFO temperature in high resolution format */
 		buffer.temp = temp ? (*temp * 64) : 0;
-- 
2.53.0



