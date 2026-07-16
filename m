Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33EB829D265;
	Thu, 16 Jul 2026 14:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210496; cv=none; b=UjUeeQw6tE4anwDDyokiVhiCrIeX/TBy13137S9GYRWCPZ7Nn4MB4CGa04MFasEcg0IWWP4rzkUk7NlMZtSdT79FxNrMkYjoRU8NhTiPjSadY+2FB4JagFIvZUojch74INuDKoLh9B2m7u/jAtRg6/rnp5wv1/3bpNjiaP+nG1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210496; c=relaxed/simple;
	bh=4o09KVJ+UOEHbnz9MiElRvAwxpcxBjKp1NpB3mnu4bI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5Mpm9n1+t80KZ0SFMM4Yxz4kHEAffKavLWhwWaZO1E6iIkfX/mz7jUDRrECutFLohMkM+hb2sqGc5TxDh2R1u7z+ODRZLrGSx9V0qFXEYtCK8JAzDcrkFmyTkp+Isn+gWvPR4QmY+y6wPxkQeiuzo3JK2/6UBuKqAyycyrXcTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VILgio8S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VILgio8S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990311F000E9;
	Thu, 16 Jul 2026 14:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210495;
	bh=w+3Q5gTtRUi0zmq8RoUWpeNhh9RcuFL3fnThM0pvj/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VILgio8SeyCxfj5H5T4m3QgvHWkH04IhxcHMyvLA1YFE3icSC2L3WhaVCS2ga5YJ+
	 gxAZY+CnpWyDKqIyRSE3JcVUgC8KHYQtyOpImEGNpUSqfNNNdup41QolPIM83CqCNK
	 4NNnDuzWLUQXdjl7TZiW7nVGRTztqWWcK38toO68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 069/480] iio: imu: inv_icm42600: fix timestamp clock period by using lower value
Date: Thu, 16 Jul 2026 15:26:56 +0200
Message-ID: <20260716133046.203466988@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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
@@ -1170,10 +1170,10 @@ struct iio_dev *inv_icm42600_accel_init(
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
@@ -755,10 +755,10 @@ struct iio_dev *inv_icm42600_gyro_init(s
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


