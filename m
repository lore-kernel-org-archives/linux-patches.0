Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F6A308F05;
	Wed, 28 Jan 2026 15:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615675; cv=none; b=eoy/LPZKar+PME4rOPzm4B//pk5vnqWz52wWOt+pYlVTKYGIxNZkjelYOOGEPGQHifpslIsOfHRAuS/ca8li6oemBISNMOJ2/VXYk4S0/mX6uUeEuhshjb6zB/EGlbzinKnWDaZBJAciqHk9BKF0qkBQNpjmOt1/B10CBqkzybg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615675; c=relaxed/simple;
	bh=dH5NnyYW8wR4yjR0ukefFXNu4eyT0IwQ9ugWLGoBqX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cp47o9pCQC98sZuLn0fX1nPppNXs/UN8WiCjT0uo5sX+TUrc6g2IACQFQtkOk7ouszM2xX8Bo+7yH4CfBjayEhDSD0ddLkyQAfsZj3I6A+gwro8zGAfHg4EUOHm3zqGT1ompEIkVAjFr72Rdf1Hnqew2mKCsyi8DcSxfdAJPdtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HmVWzKZY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HmVWzKZY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D804C4CEF1;
	Wed, 28 Jan 2026 15:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615675;
	bh=dH5NnyYW8wR4yjR0ukefFXNu4eyT0IwQ9ugWLGoBqX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HmVWzKZYIfayLdn9cPQpKL5AinOLX7e+xa4YCR7pX1eqV5n8uvG6/oWpGS/jyGkaC
	 Bh+8qpoavcgBg5MSj/BiQIo/Tmrr4b2oCuTh2HQ9FevjjVqtNVZXylX8WDOpaI0k0B
	 F9xEDnT0MKNL91XqAawGmdgGePhQCK9/LMLgouPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Lavra <flavra@baylibre.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 081/227] iio: imu: st_lsm6dsx: fix iio_chan_spec for sensors without event detection
Date: Wed, 28 Jan 2026 16:22:06 +0100
Message-ID: <20260128145347.257610336@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Lavra <flavra@baylibre.com>

commit c34e2e2d67b3bb8d5a6d09b0d6dac845cdd13fb3 upstream.

The st_lsm6dsx_acc_channels array of struct iio_chan_spec has a non-NULL
event_spec field, indicating support for IIO events. However, event
detection is not supported for all sensors, and if userspace tries to
configure accelerometer wakeup events on a sensor device that does not
support them (e.g. LSM6DS0), st_lsm6dsx_write_event() dereferences a NULL
pointer when trying to write to the wakeup register.
Define an additional struct iio_chan_spec array whose members have a NULL
event_spec field, and use this array instead of st_lsm6dsx_acc_channels for
sensors without event detection capability.

Fixes: b5969abfa8b8 ("iio: imu: st_lsm6dsx: add motion events")
Signed-off-by: Francesco Lavra <flavra@baylibre.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -101,6 +101,13 @@ static const struct iio_chan_spec st_lsm
 	IIO_CHAN_SOFT_TIMESTAMP(3),
 };
 
+static const struct iio_chan_spec st_lsm6ds0_acc_channels[] = {
+	ST_LSM6DSX_CHANNEL(IIO_ACCEL, 0x28, IIO_MOD_X, 0),
+	ST_LSM6DSX_CHANNEL(IIO_ACCEL, 0x2a, IIO_MOD_Y, 1),
+	ST_LSM6DSX_CHANNEL(IIO_ACCEL, 0x2c, IIO_MOD_Z, 2),
+	IIO_CHAN_SOFT_TIMESTAMP(3),
+};
+
 static const struct iio_chan_spec st_lsm6dsx_gyro_channels[] = {
 	ST_LSM6DSX_CHANNEL(IIO_ANGL_VEL, 0x22, IIO_MOD_X, 0),
 	ST_LSM6DSX_CHANNEL(IIO_ANGL_VEL, 0x24, IIO_MOD_Y, 1),
@@ -142,8 +149,8 @@ static const struct st_lsm6dsx_settings
 		},
 		.channels = {
 			[ST_LSM6DSX_ID_ACC] = {
-				.chan = st_lsm6dsx_acc_channels,
-				.len = ARRAY_SIZE(st_lsm6dsx_acc_channels),
+				.chan = st_lsm6ds0_acc_channels,
+				.len = ARRAY_SIZE(st_lsm6ds0_acc_channels),
 			},
 			[ST_LSM6DSX_ID_GYRO] = {
 				.chan = st_lsm6ds0_gyro_channels,
@@ -1449,8 +1456,8 @@ static const struct st_lsm6dsx_settings
 		},
 		.channels = {
 			[ST_LSM6DSX_ID_ACC] = {
-				.chan = st_lsm6dsx_acc_channels,
-				.len = ARRAY_SIZE(st_lsm6dsx_acc_channels),
+				.chan = st_lsm6ds0_acc_channels,
+				.len = ARRAY_SIZE(st_lsm6ds0_acc_channels),
 			},
 			[ST_LSM6DSX_ID_GYRO] = {
 				.chan = st_lsm6dsx_gyro_channels,


