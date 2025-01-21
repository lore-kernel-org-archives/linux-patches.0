Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F891F542D;
	Tue, 21 Jan 2025 18:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482721; cv=none; b=gW4SlVoJGQHnlNNdDW5+N4qBv5PG7hC9hFy3McVQixTXnUTr/Uz8yVWUTy4fZH/6jpDF/heAwD2SuBSjFAPGee+CbLOnmUkfJZlx2chQlGPbHHcQN+WqZ/hAoBg5A1dyMyczh9NThtI/+2Kcz/tKBoE7EertmYTZFViLuroP8bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482721; c=relaxed/simple;
	bh=MVsIaCQQlU9L7Eia0JhFELRFq3PsoYe1eB1vi9xlj1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mzpHSzJaaVObGjspmO2E16AvGcotZ/fGu251mAVghsCGtGLO4kMARy9BFzPHMB+BtrOW1EINzgtKiwJhSfhaoSLIaRWdjTSqdvd41bBYfFQlQikNOzObrKFQFzwkJcPOdcp4CPprI5GX6uDyXaYs+MOstWDVpFmK+TR2UiDaGfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AdZCUCc9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AdZCUCc9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA7FC4CEDF;
	Tue, 21 Jan 2025 18:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482721;
	bh=MVsIaCQQlU9L7Eia0JhFELRFq3PsoYe1eB1vi9xlj1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AdZCUCc9D+djwK2i5iaTbvOUK06awvvd6DSHISHSk1MBk+ZPFVIyl5bnlvL6dSsHG
	 wuHAEpq1GP1PW/qlrskIvYWAswvllPRUISuJrcBd9/nU72VJ93OvjUP0d8Dsi8qH7u
	 QqrkfLum3FYw3wa6aN4i5GYkpqkJ49uPRB8gKQqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 50/64] iio: imu: inv_icm42600: fix timestamps after suspend if sensor is on
Date: Tue, 21 Jan 2025 18:52:49 +0100
Message-ID: <20250121174523.458725953@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit 65a60a590142c54a3f3be11ff162db2d5b0e1e06 upstream.

Currently suspending while sensors are one will result in timestamping
continuing without gap at resume. It can work with monotonic clock but
not with other clocks. Fix that by resetting timestamping.

Fixes: ec74ae9fd37c ("iio: imu: inv_icm42600: add accurate timestamping")
Cc: stable@vger.kernel.org
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Link: https://patch.msgid.link/20241113-inv_icm42600-fix-timestamps-after-suspend-v1-1-dfc77c394173@tdk.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
@@ -720,6 +720,8 @@ out_unlock:
 static int __maybe_unused inv_icm42600_resume(struct device *dev)
 {
 	struct inv_icm42600_state *st = dev_get_drvdata(dev);
+	struct inv_icm42600_timestamp *gyro_ts = iio_priv(st->indio_gyro);
+	struct inv_icm42600_timestamp *accel_ts = iio_priv(st->indio_accel);
 	int ret;
 
 	mutex_lock(&st->lock);
@@ -740,9 +742,12 @@ static int __maybe_unused inv_icm42600_r
 		goto out_unlock;
 
 	/* restore FIFO data streaming */
-	if (st->fifo.on)
+	if (st->fifo.on) {
+		inv_icm42600_timestamp_reset(gyro_ts);
+		inv_icm42600_timestamp_reset(accel_ts);
 		ret = regmap_write(st->map, INV_ICM42600_REG_FIFO_CONFIG,
 				   INV_ICM42600_FIFO_CONFIG_STREAM);
+	}
 
 out_unlock:
 	mutex_unlock(&st->lock);


