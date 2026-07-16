Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5765A42378D;
	Thu, 16 Jul 2026 14:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211846; cv=none; b=rm1V5GGMU0NmErcxpmahckAKQ1HCfLq38PpmjA8HPSPKjEYqeyk+V8jVNfeJiePjXTP2D+yC28198fxIW9tKF/T2xyLgJQFI82Z3OIzsIQ1/NXUspXiFPe2s6/0TICQLYb+Lxw7Fsc884lyI7GEpOEmZ7JrXAIUtiRE+jeD+q70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211846; c=relaxed/simple;
	bh=VIHTjlerasqDyHgC06s/8Ur7507ghciAMJ5W20tYZdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ctznD0X5XicKl+1vwoK1qZ1gdci6/sNQMNvB1thkGZrE22O43wTlIKW7NaXh0t52HDb/wOBuj4p21roSqJowBOA2KPyVyq43iiyTVi3AgQmjlBZwIuFFxevsUF6LizbEf5Kg9/okocoYKq4wOZsRckMVqFuflWBvqE8CsZOC2SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QBIAeCDH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QBIAeCDH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC06C1F000E9;
	Thu, 16 Jul 2026 14:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211845;
	bh=MVF5kI+v99XFHAea4fxIBadusvD/84Zd5+BUIKuuhEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QBIAeCDHilGebp8cHQlaH8B/fOvEbGh6f8YAVtJZwRyxQ67IFn93TEOvBm6tyM3ZL
	 vkQtgQuI5swRIrfWdDgAye9rwgk0QbI9exuVeIDF4KTY35t+zGYZj8zObd68ckAGGc
	 MZ2KVo5xzXF1i8ZihxKXSrczNtyqCz7n+PPYWOjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.12 058/349] iio: imu: inv_icm42600: fix timestamp clock period by using lower value
Date: Thu, 16 Jul 2026 15:29:52 +0200
Message-ID: <20260716133034.624232031@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

commit 8b0b864c11a2e2ada470f9d5010e1c2bf1eceef2 upstream.

Clock period value is used for computing periods of sampling. There is
no need for it to be higher than the maximum odr, otherwise we are
losing precision in the computation for nothing.

Switch clock period value to maximum odr period (8kHz).

Fixes: 0ecc363ccea7 ("iio: make invensense timestamp module generic")
Cc: stable@vger.kernel.org
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c |    4 ++--
 drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c  |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
@@ -868,10 +868,10 @@ struct iio_dev *inv_icm42600_accel_init(
 	accel_st->filter = INV_ICM42600_FILTER_AVG_16X;
 
 	/*
-	 * clock period is 32kHz (31250ns)
+	 * clock period is 8kHz (125000ns)
 	 * jitter is +/- 2% (20 per mille)
 	 */
-	ts_chip.clock_period = 31250;
+	ts_chip.clock_period = 125000;
 	ts_chip.jitter = 20;
 	ts_chip.init_period = inv_icm42600_odr_to_period(st->conf.accel.odr);
 	inv_sensors_timestamp_init(&accel_st->ts, &ts_chip);
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
@@ -771,10 +771,10 @@ struct iio_dev *inv_icm42600_gyro_init(s
 	}
 
 	/*
-	 * clock period is 32kHz (31250ns)
+	 * clock period is 8kHz (125000ns)
 	 * jitter is +/- 2% (20 per mille)
 	 */
-	ts_chip.clock_period = 31250;
+	ts_chip.clock_period = 125000;
 	ts_chip.jitter = 20;
 	ts_chip.init_period = inv_icm42600_odr_to_period(st->conf.accel.odr);
 	inv_sensors_timestamp_init(&gyro_st->ts, &ts_chip);


