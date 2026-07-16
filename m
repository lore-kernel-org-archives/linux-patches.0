Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6E741F5EC;
	Thu, 16 Jul 2026 13:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209104; cv=none; b=f+f0fGsFX9oPU90aflWdGzg2CJQSoiQ4S4BIi99i65BbphzLFIBkhK6k8SX1ibYo4ugJhs0dZFVtzTGyZg4QrvZ3VKrb2vscj4LDsHKU8apRzuln4KMl2+DarZ+4U0O8qF2I4WKzzlEIcamEyRjH1asDS9oy5KgtwDrx6Txcw2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209104; c=relaxed/simple;
	bh=BkKw2ljzdg4YHnmXKAKc7IMxymUOj9bBM4cW4L/rbx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lN7jbtjkShrZ//ey352ct44Dqog1OSOlo+Dgnfjeo8WPPm8YMJ4pDK2AwOnGRW8n6xM+/n7zQL9lZCtr//kS0nv3tok2ZobP4jEV+e+B7Van4ZVRNsJY0qFHuM/MNzbL2w9+EmNyuNbhXo/F4oz5K5eWvZa6ZVlR+mONlGv2VgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qaOaRGrT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qaOaRGrT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710BD1F000E9;
	Thu, 16 Jul 2026 13:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209102;
	bh=XFDvw+sntT0E90oyesR7VCMo1fQ4Nm4+JU0WBNVD0ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qaOaRGrTwL1IfaEZ/ranxCxfaUWmqSPy3dmH2ktGztqGWPfAU7QimvirDj7Z+xoze
	 fyPc90VrtaStje1cNGMGWkt7jpmRJ2F1b+mNjKS0x3uvffstCNa1KjzymiIcqvQx1N
	 5XuMNHUNJNS9hf4LtqKif5E9sfWNRt+1zvrgVoxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 057/518] iio: imu: inv_icm42600: fix timestamp clock period by using lower value
Date: Thu, 16 Jul 2026 15:25:25 +0200
Message-ID: <20260716133049.033546475@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


