Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939F544AB6E;
	Tue, 21 Jul 2026 21:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670779; cv=none; b=e2qUgXX1vGNnkRgHZz/84yf7goMVfKcQVDQEsACjHKlfjKSftuZXqnwGypuoIyXXdSVqR4uezSChOyG3UOwNMlcShQWanlbrwN2apRKidTT6cTBJLKjAXrHZQYvGUFmxeLVlS8Ig59Txe1yWg6daRLXxeSubPBLDUBFj9g2fN5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670779; c=relaxed/simple;
	bh=1nGx7n1MSlC+NIA4RE8k9y9bpjdj6yGO8ZQoT0yxTKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NylqmOWLEDHqYh+lgOdZ9WV1I6jozxubpFQwgndb3TfSAgzoctBJQgIPxbQLL71UzRd22vAt+wHtI/qVrOXb3jA5VtCPl6XBwPeqp00TlwMduozpaIsKP4JddpbfsyW+le77f6JBfRexT2EDtRfzXa2+WI2jQCcMZdxLPhW42A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s0TSi2mr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s0TSi2mr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9181F000E9;
	Tue, 21 Jul 2026 21:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670778;
	bh=WHPZxT7xt0y261R8IcAGSFnwk6j0iM6sWIRLca0c7rY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s0TSi2mrAz0rVPtE6pfonLbNvTB7zrjBojya5lVkHSOBOgEhB63YgPUtLpEc8vMu9
	 9YmeeIP5JbtgQDv3hK03aVFHbTnb9r6Qr9Ps7PFS3G85drHPKBzeiBqBwuQMg4zCfd
	 i9CE+hSuYBqRhrmU9yBsKzkBCQ1syzS7htvi70Jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 1060/1067] iio: imu: inv_mpu6050: fix frequency setting when chip is off
Date: Tue, 21 Jul 2026 17:27:41 +0200
Message-ID: <20260721152448.298309052@linuxfoundation.org>
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

commit daec424cc57b33a28f8621eb7ac85f8bd327bd6b upstream.

Track correctly FIFO state and apply ODR change before starting
the chip. Without the fix, you cannot change ODR more than 1 time
when data buffering is off. This restriction on a single pending ODR
change should only apply when the FIFO is on.

Fixes: 111e1abd0045 ("iio: imu: inv_mpu6050: use the common inv_sensors timestamp module")
Cc: stable@vger.kernel.org
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Link: https://lore.kernel.org/r/20240219154741.90601-1-inv.git-commit@tdk.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_mpu6050/inv_mpu_trigger.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_trigger.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_trigger.c
@@ -111,6 +111,7 @@ int inv_mpu6050_prepare_fifo(struct inv_
 	if (enable) {
 		/* reset timestamping */
 		inv_sensors_timestamp_reset(&st->timestamp);
+		inv_sensors_timestamp_apply_odr(&st->timestamp, 0, 0, 0);
 		/* reset FIFO */
 		d = st->chip_config.user_ctrl | INV_MPU6050_BIT_FIFO_RST;
 		ret = regmap_write(st->map, st->reg->user_ctrl, d);
@@ -184,6 +185,10 @@ static int inv_mpu6050_set_enable(struct
 		if (result)
 			goto error_power_off;
 	} else {
+		st->chip_config.gyro_fifo_enable = 0;
+		st->chip_config.accl_fifo_enable = 0;
+		st->chip_config.temp_fifo_enable = 0;
+		st->chip_config.magn_fifo_enable = 0;
 		result = inv_mpu6050_prepare_fifo(st, false);
 		if (result)
 			goto error_power_off;


