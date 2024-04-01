Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E489D1CA8F;
	Mon,  1 Apr 2024 16:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988786; cv=none; b=ecFp07gtKb5wzaH9wvOYUNiru4/jm3lfPxTA7ULNkCN3cUCep1uzHdNV2qVViqWWhnh4XFMAqm9mBLtgtu0Ke842jQu0InPLUZ3GXueEWuCILo1t7ugeBk4pBElUS4Ac7YaSWHKyY5GJosMg2EGmdnPytYW1CL9c12j5iNzDY3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988786; c=relaxed/simple;
	bh=cpJXSiUsIY/R2hVoEqpJ/VmE0XUNnSYjDc18q708BeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bABRTQYueN32dLOYzQ1gYhSwOt6W5dddAr3jsd7hClYWh1qJu1Mj5owZjKCMdNA0ReeU0sqXbSEj7ltMKqfYLu2YtJPZwCvedzGixxXKlzWd7BjCcNfu/2Bq29yZMqjyk2msiFMA6JqxWIdgQbBXfxWmPr/2tbBdiArKsX+NE6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G8D4eQX+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G8D4eQX+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53FD7C433F1;
	Mon,  1 Apr 2024 16:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988785;
	bh=cpJXSiUsIY/R2hVoEqpJ/VmE0XUNnSYjDc18q708BeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G8D4eQX+f1CMlbUvXX90d7jwv14b/D3JsHbBNZ62y/X+XvpzTxRNL1Xoxq6FaACZv
	 B+lyLG9k752qTIU27JMrkkpNUjIrnZ3jnhZVhnpaYJycRiGQzXLPMsPtu9ZbesKSDN
	 9nbhrGLfVnowisgfiyOE4YCfu32lR7oM+hDJPCCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.7 286/432] iio: imu: inv_mpu6050: fix frequency setting when chip is off
Date: Mon,  1 Apr 2024 17:44:33 +0200
Message-ID: <20240401152601.702757492@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

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


