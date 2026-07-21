Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B33175A81;
	Tue, 21 Jul 2026 23:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674826; cv=none; b=WrJ13iklB7vzFS1aoSvKacx5HnrNh7bAIH7wGWAIKKrsys0Hej054+Hj6O9YjRsrF5wqsPIOR5sAFgBHzODBWvWlNHvg4rv6NuqdVYX1IuBYJ5jlgrIbN3pMz7+TDf8c+q8yXmozDG0XokFkePutzVFdyiYTLRC2/C8C5jzn3SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674826; c=relaxed/simple;
	bh=pLAXrkaWnYuDvSEDypOzYVCVe5k9NXM/u+/lq6r1J80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CBiiC1+7QPl5iih0gMhjR9nnZQBI6V49g1e5tAPDJR4plplUax5VoMR3Ilmf4WQMAa5Pa3+nLPv9hT3cj1WwxdgoXZWntyq6vTVMYwYaWaxTNYRBqS7+4AyA2fKATuqSSSFvBySJt/88+s3dTEQKVoq3NLX9nbi8IjTB9uMFf8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kQWL7y0c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kQWL7y0c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369FE1F000E9;
	Tue, 21 Jul 2026 23:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674825;
	bh=2bY0u3L6daykRvkB6aRSCA6sPZo3cL/3tA7k4xihTng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kQWL7y0cWlRW7ZQ/ZTyHoEFj3Bx77E0QxDeVFtNpFfSU8d+JnQ8Z3u1vmaAAZKwyH
	 ej+ndihwte9/ReduTTgj+CND9/P0fr/e1Eqd4vL0q2YNNu44QeHBVG4KohlezjNol7
	 tLJanHF4JIcNdfIfJsx3C4J2k3vFa12Leu/dxjM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 688/699] iio: imu: inv_mpu6050: fix frequency setting when chip is off
Date: Tue, 21 Jul 2026 17:27:27 +0200
Message-ID: <20260721152411.292472261@linuxfoundation.org>
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
@@ -112,6 +112,7 @@ int inv_mpu6050_prepare_fifo(struct inv_
 	if (enable) {
 		/* reset timestamping */
 		inv_sensors_timestamp_reset(&st->timestamp);
+		inv_sensors_timestamp_apply_odr(&st->timestamp, 0, 0, 0);
 		/* reset FIFO */
 		d = st->chip_config.user_ctrl | INV_MPU6050_BIT_FIFO_RST;
 		ret = regmap_write(st->map, st->reg->user_ctrl, d);
@@ -187,6 +188,10 @@ static int inv_mpu6050_set_enable(struct
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


