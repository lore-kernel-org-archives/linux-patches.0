Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0193ACA5D;
	Tue, 21 Jul 2026 23:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674832; cv=none; b=BT7v00NUV40jGQqWol67GpvvaYuBLQGudlqUk+kG2xV+zn+HHwTU0FN84GntppsFXekZMLdeW94By4AUSykZjNEt/MkcUX56VKru9DLCyLknBWar/g/3mL7OlH0ZH87MLSKI9voXbQg9G+kxfKW/vJJAgEjRYHJcYauXitRLutM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674832; c=relaxed/simple;
	bh=DBz4sO4sY19vSQ6YplNKueE/jH9xOHlT7jS/ErpCW8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qy5mTrvI1d3d2xSmgPOKFnLvdCQmComtxpKJun6wI6ErvIkyrv+kjTFRxnZI0OwcNfDjs9Bco52DyHnOxFPPCZytkcOw73cTYJsyZcaWCtKAgJAQs5t2sVWSVhbvzX5N1fbKw3hS8xr2YbGfy2W0KjgBfAfj58KrgZv94YFs5SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EZtEgDjr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EZtEgDjr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C9D91F000E9;
	Tue, 21 Jul 2026 23:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674831;
	bh=8TjRC/uXXKrJDQLHnPZXSkQyJAjwjWAtnpYyIKpBM3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EZtEgDjrzvbCyCfpgaivi/0mmqDwI0I9TohFJOJo7cb7xAeN2BMsmrJ/wCXpDqxHs
	 4lc99N8KALci4bWkQBQ8a/1Wp15NtTX86MqIdVzGAGTPfygFFOLk8/ewj6ZKgcp38G
	 FNcvm+o0n01dadTvQP1JfLijBGcjsY6QNerKMpnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 5.10 690/699] iio: imu: inv_icm42600: fix timestamp clock period by using lower value
Date: Tue, 21 Jul 2026 17:27:29 +0200
Message-ID: <20260721152411.338912450@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -725,10 +725,10 @@ struct iio_dev *inv_icm42600_accel_init(
 		return ERR_PTR(-ENOMEM);
 
 	/*
-	 * clock period is 32kHz (31250ns)
+	 * clock period is 8kHz (125000ns)
 	 * jitter is +/- 2% (20 per mille)
 	 */
-	ts_chip.clock_period = 31250;
+	ts_chip.clock_period = 125000;
 	ts_chip.jitter = 20;
 	ts_chip.init_period = inv_icm42600_odr_to_period(st->conf.accel.odr);
 	ts = iio_priv(indio_dev);
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
@@ -736,10 +736,10 @@ struct iio_dev *inv_icm42600_gyro_init(s
 		return ERR_PTR(-ENOMEM);
 
 	/*
-	 * clock period is 32kHz (31250ns)
+	 * clock period is 8kHz (125000ns)
 	 * jitter is +/- 2% (20 per mille)
 	 */
-	ts_chip.clock_period = 31250;
+	ts_chip.clock_period = 125000;
 	ts_chip.jitter = 20;
 	ts_chip.init_period = inv_icm42600_odr_to_period(st->conf.accel.odr);
 	ts = iio_priv(indio_dev);


