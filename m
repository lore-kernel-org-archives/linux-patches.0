Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07A83D994;
	Wed,  4 Feb 2026 15:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217922; cv=none; b=Edi6k9zZR4AL02WIsyb0MOQbDD3GDmabsYtkONT61GYah4/RBkf0W92RnczChwjMusGAuL0zX+vngs7dL8zVVJMUep4Ccx6no79AT+0CjPxH84ClKQkqmXYMw0UND7i3EA167fZ/qJVd79PUPfAzxlgLeyNudr+aHyrl9Yb3eRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217922; c=relaxed/simple;
	bh=JhUe1wP0CryQyI7VAjcNJETjTQ7Mh32h0Mc3l35HbJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOA6irdWidZCdJiP7yPkFAkr6rO2qHuRNw7ugyM9hgsoNAC82Bq8ttQ8GgzflI1e60RNqb7JMfL/PvPpYdHhrzJGqQSwanW9icTjmDL1uND4Jnr58n59prcnaDpXLBp2t6vyXcRVtZBUIzGLt5lNQjgtuorfN0VRl37u/0KZuVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=seoeyvqW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="seoeyvqW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F887C4CEF7;
	Wed,  4 Feb 2026 15:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217922;
	bh=JhUe1wP0CryQyI7VAjcNJETjTQ7Mh32h0Mc3l35HbJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=seoeyvqWkq57A3vsM7puucAi5NeknwuO2+cVjDTHzkqTGDxKzQvTPcL78K/BmEJcl
	 3mvThN9xLEnwXnetwjuAdqme4pupldutXnfqr/xKVg7DbE5luQQC3huC5Jk8ZPeC6k
	 KKt/vt1aLgu1RCsASvJiQaK4WQ1kMc8lRkKBA3s8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Lavra <flavra@baylibre.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 126/280] iio: imu: st_lsm6dsx: fix iio_chan_spec for sensors without event detection
Date: Wed,  4 Feb 2026 15:38:20 +0100
Message-ID: <20260204143914.170807701@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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
@@ -76,6 +76,13 @@ static const struct iio_chan_spec st_lsm
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
@@ -117,8 +124,8 @@ static const struct st_lsm6dsx_settings
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
@@ -1009,8 +1016,8 @@ static const struct st_lsm6dsx_settings
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


