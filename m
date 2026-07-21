Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1833B9930;
	Tue, 21 Jul 2026 21:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670477; cv=none; b=tXOCmSyTmQo2mQYIFTZvNUc2Z1c2zvT+wMBU1Q8PhMnN4on8ZDlQUI2qvFitLSBqC8M8iaGk+2EnDUCSGHGmBYWny1Gh2O2IXAl6dBzGvW7lJDW8pL2vck5/f3vfewKyawSjJv84CGyjVWUmgxDAXJMNL2vhd6SjpGYKeswqfq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670477; c=relaxed/simple;
	bh=nF/j/h1pT0fxC465zMKd5MpFEocLGJ8jYwtILbaCzC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p1fIbkahlB9MOAsAp0Tr8E7UZyRDOpb/OV4x04CEI22faL/onhdPIOU8RmZLcfTsQc95+3UsGc6a+vj/yVxEEHEJmSOmG9kyJYKtkE8dx1uvEzmZa911a7Z74glNheoeoBU00wQnVjkEjqgkyx3olA+O9ifuPJksdLQTOVlTdTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a4cIuEiG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a4cIuEiG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3DF1F000E9;
	Tue, 21 Jul 2026 21:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670476;
	bh=Yb9MFo29hMbD8Xi9UJJrKWnjlyZ3uDfH0mFDOowUBHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a4cIuEiGG9iUTqr7j0+5Pc0cBPLJsQRFMIraQkYrZO4LsSr2CmdDnAl8xcyyWtciX
	 9k4ghVTF9EZJZaDQN5BcNrQnA36b65A8Ez1ZG77It7mh4/SNmqTwnynbbaYfivHYw7
	 GojEJ2k2qI5otnu8TifpylSFBYUVFEVY0pIzoREA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0948/1067] iio: imu: inv_icm42600: stabilized timestamp in interrupt
Date: Tue, 21 Jul 2026 17:25:49 +0200
Message-ID: <20260721152445.745310549@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

[ Upstream commit d7bd473632d07f8a54655c270c0940cc3671c548 ]

Use IRQF_ONESHOT flag to ensure the timestamp is not updated in the
hard handler during the thread handler. And compute and use the
effective watermark value that correspond to this first timestamp.

This way we can ensure the timestamp is always corresponding to the
value used by the timestamping mechanism. Otherwise, it is possible
that between FIFO count read and FIFO processing the timestamp is
overwritten in the hard handler.

Fixes: ec74ae9fd37c ("iio: imu: inv_icm42600: add accurate timestamping")
Cc: stable@vger.kernel.org
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Link: https://lore.kernel.org/r/20240529154717.651863-1-inv.git-commit@tdk.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: affe3f077d7a ("iio: imu: inv_icm42600: fix timestamping by limiting FIFO reading")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c |   19 +++++++++++++++++--
 drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.h |    2 ++
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c   |    1 +
 3 files changed, 20 insertions(+), 2 deletions(-)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c
@@ -222,10 +222,15 @@ int inv_icm42600_buffer_update_watermark
 	latency_accel = period_accel * wm_accel;
 
 	/* 0 value for watermark means that the sensor is turned off */
+	if (wm_gyro == 0 && wm_accel == 0)
+		return 0;
+
 	if (latency_gyro == 0) {
 		watermark = wm_accel;
+		st->fifo.watermark.eff_accel = wm_accel;
 	} else if (latency_accel == 0) {
 		watermark = wm_gyro;
+		st->fifo.watermark.eff_gyro = wm_gyro;
 	} else {
 		/* compute the smallest latency that is a multiple of both */
 		if (latency_gyro <= latency_accel)
@@ -241,6 +246,13 @@ int inv_icm42600_buffer_update_watermark
 		watermark = latency / period;
 		if (watermark < 1)
 			watermark = 1;
+		/* update effective watermark */
+		st->fifo.watermark.eff_gyro = latency / period_gyro;
+		if (st->fifo.watermark.eff_gyro < 1)
+			st->fifo.watermark.eff_gyro = 1;
+		st->fifo.watermark.eff_accel = latency / period_accel;
+		if (st->fifo.watermark.eff_accel < 1)
+			st->fifo.watermark.eff_accel = 1;
 	}
 
 	/* compute watermark value in bytes */
@@ -517,7 +529,7 @@ int inv_icm42600_buffer_fifo_parse(struc
 	/* handle gyroscope timestamp and FIFO data parsing */
 	if (st->fifo.nb.gyro > 0) {
 		ts = iio_priv(st->indio_gyro);
-		inv_sensors_timestamp_interrupt(ts, st->fifo.nb.gyro,
+		inv_sensors_timestamp_interrupt(ts, st->fifo.watermark.eff_gyro,
 						st->timestamp.gyro);
 		ret = inv_icm42600_gyro_parse_fifo(st->indio_gyro);
 		if (ret)
@@ -527,7 +539,7 @@ int inv_icm42600_buffer_fifo_parse(struc
 	/* handle accelerometer timestamp and FIFO data parsing */
 	if (st->fifo.nb.accel > 0) {
 		ts = iio_priv(st->indio_accel);
-		inv_sensors_timestamp_interrupt(ts, st->fifo.nb.accel,
+		inv_sensors_timestamp_interrupt(ts, st->fifo.watermark.eff_accel,
 						st->timestamp.accel);
 		ret = inv_icm42600_accel_parse_fifo(st->indio_accel);
 		if (ret)
@@ -578,6 +590,9 @@ int inv_icm42600_buffer_init(struct inv_
 	unsigned int val;
 	int ret;
 
+	st->fifo.watermark.eff_gyro = 1;
+	st->fifo.watermark.eff_accel = 1;
+
 	/*
 	 * Default FIFO configuration (bits 7 to 5)
 	 * - use invalid value
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.h
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.h
@@ -32,6 +32,8 @@ struct inv_icm42600_fifo {
 	struct {
 		unsigned int gyro;
 		unsigned int accel;
+		unsigned int eff_gyro;
+		unsigned int eff_accel;
 	} watermark;
 	size_t count;
 	struct {
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
@@ -518,6 +518,7 @@ static int inv_icm42600_irq_init(struct
 	if (ret)
 		return ret;
 
+	irq_type |= IRQF_ONESHOT;
 	return devm_request_threaded_irq(dev, irq, inv_icm42600_irq_timestamp,
 					 inv_icm42600_irq_handler, irq_type,
 					 "inv_icm42600", st);


