Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA0B1F7596;
	Tue, 21 Jan 2025 18:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737483101; cv=none; b=pd6pMAAMYVqscbJiOy1asdj0mNUghytGHzKGgnoENv+l8WT9dfgRMA4RSDN3tPrGwxNeN74oxSNaNC4fQ1ONPDAUVmflo/lkOAg4gbzpnL28WPGBHeINLDvLwf0EzlpxHDIyUaqpOKDSMSxB2ozm77huNUJp13hIGHPvPwv9JPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737483101; c=relaxed/simple;
	bh=1NQ0HmQUIUAK5UA2V8Aigz0v34vSBNwhj3xnBZd4of4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZujpMQS6a5KhDL/xLc5mCfmdu3Cpn6mEfsf9H2TReq+xRsqhrwoBpfnwE4eTq8R0TJ81HglJIi97g8NhUF3MRSZMPI+p5FJy1xFe59O/4mlvvMk67SyzHR9uUO5B2USCYfE1XO0RRAphjfSInKXusSpNUrkHMaNfk1vfOKE+LhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBt7iG2w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBt7iG2w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DCF3C4CEDF;
	Tue, 21 Jan 2025 18:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737483101;
	bh=1NQ0HmQUIUAK5UA2V8Aigz0v34vSBNwhj3xnBZd4of4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kBt7iG2wKH7fNXquhVHb55nJZGTVdzd9UtBZMnut2izy78HSms4YvFLTL923siUSG
	 /fiokkeEMTSI3adpVkIaSUtXA4uQfo6bhSIbMeEVUtbafWXHaigYB9pTPWxXqMRAWG
	 dWe8hwJd+IgcgjTWAmxcsTSDUdVe/GZtrPIzUEu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 117/127] iio: imu: inv_icm42600: fix timestamps after suspend if sensor is on
Date: Tue, 21 Jan 2025 18:53:09 +0100
Message-ID: <20250121174534.153924239@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


