Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E7D1C0DE7;
	Mon,  1 Apr 2024 16:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990187; cv=none; b=COqs/fc4ROjYU3vFSHKN7Ayn0+bwFufcsyNWy7Kff0v4INQZ2++IEn4qaUjYujmvdeyOqaHgZN0vORin6os/5HcUIEBKAb3nWQLDOV8DeU6OJYYHGzePk4O6Kftv2gXcPS7dF4IMk8cfJbloSg08nO/n5uWpKO6VxcttGYjiyN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990187; c=relaxed/simple;
	bh=9g0mxyJehLODmxdyFRZk6pGsU6aVG3vaygXh0+Wnzw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DkOoEx93Zzi+rU4pjWc3POOajmnCoduHP4E5CTvOKABLRN2CmVmOKMeXLiRV+vIpJXdfNqw2IrQLHUlDpCsHGBgVCepEBcD8m3EEIA0G5lXjnefU5/zFU5/G4fLSHnB25sO0IJztawU3pvB8Axv86gMSAKpe+YFqfhDWxvBrOMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bo7ONUfX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bo7ONUfX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793A3C433F1;
	Mon,  1 Apr 2024 16:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990187;
	bh=9g0mxyJehLODmxdyFRZk6pGsU6aVG3vaygXh0+Wnzw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bo7ONUfXUfMQtrnEBLGBNtquERhN2o+m+RMAnNhydYd+HwE9hq53jSiloRQF0BRgr
	 74rhlZFOZsZnsfWnr05wJUGEhO7+yMKPeUpFKo6JtExJ1CiXxPvUSR8z6v6PDBdNzo
	 P+cXwWwhxi9W+7HQ7S8+9+ZdFlOeVkZ7GblZ54Cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 245/396] iio: imu: inv_mpu6050: fix frequency setting when chip is off
Date: Mon,  1 Apr 2024 17:44:54 +0200
Message-ID: <20240401152555.218313881@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/iio/imu/inv_mpu6050/inv_mpu_trigger.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_trigger.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_trigger.c
index 676704f9151f..e6e6e94452a3 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_trigger.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_trigger.c
@@ -111,6 +111,7 @@ int inv_mpu6050_prepare_fifo(struct inv_mpu6050_state *st, bool enable)
 	if (enable) {
 		/* reset timestamping */
 		inv_sensors_timestamp_reset(&st->timestamp);
+		inv_sensors_timestamp_apply_odr(&st->timestamp, 0, 0, 0);
 		/* reset FIFO */
 		d = st->chip_config.user_ctrl | INV_MPU6050_BIT_FIFO_RST;
 		ret = regmap_write(st->map, st->reg->user_ctrl, d);
@@ -184,6 +185,10 @@ static int inv_mpu6050_set_enable(struct iio_dev *indio_dev, bool enable)
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
-- 
2.44.0



