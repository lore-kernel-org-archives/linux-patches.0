Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDDB3C1081;
	Tue, 21 Jul 2026 21:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670797; cv=none; b=DcexnMcLFsKOC2u0avsC0dZ60ncKJCNK8Avz8Smwcqa1ce8MH25fYo5Db1EzP1scl/U33AT7N5zv2H4a1SbJOaxqLhNwCB6yUniUeIfC/RLklKszCkh+8icc+M9BWEnm/KEux0yBmZ8qxNsI7xbtOs+bMuUmoX0d4y2CKqFNDXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670797; c=relaxed/simple;
	bh=8sLYXyVxXrQEaKXV6UYbZy18I6CvtFOpyZ44AB+fGIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfcWxOk7ir/R8umWklupQwrXfvS+vx7rU6vb8J7LmaO3g1podYUmGFHbKoWvCNks+FJtAA+j37HgeCp8ALqxhSsFpXbYcYBSXgoX+xxZ3B3AMRHPBriumpjRAsCDbTMXel6EZIfY1dHNk5l/BtoS72LN/5L+BDWFcSTnxn4U1hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=seB0SFfF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="seB0SFfF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494D41F000E9;
	Tue, 21 Jul 2026 21:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670796;
	bh=K2SlSThwlLPz7e9uAG5zYYV1fKR9m6c7iGygYJY4Zec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=seB0SFfFKF+Y3wtfzy+RsZTdm0QYIWT7S4AyAUf0ngSBWb8nd2I5+37MKKfKVq9vN
	 ck4FiHaH+BVDUPm3YrtDsiGslwKQTjpBx7nJtQB483CBdL3BCi4bJd2ay0uQzvjfvq
	 r6Ii4ge4mMA2wUmA9ZUftH4LIEjwTXU+caCg/eTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.1 1066/1067] iio: imu: inv_icm42600: fix timestamp clock period by using lower value
Date: Tue, 21 Jul 2026 17:27:47 +0200
Message-ID: <20260721152448.432741277@linuxfoundation.org>
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
@@ -720,10 +720,10 @@ struct iio_dev *inv_icm42600_accel_init(
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
@@ -731,10 +731,10 @@ struct iio_dev *inv_icm42600_gyro_init(s
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


