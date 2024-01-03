Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5441BDFB;
	Wed,  3 Jan 2024 17:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fdFELuMZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E30C433C9;
	Wed,  3 Jan 2024 17:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301887;
	bh=MXTGB5m5O+esJpPsT4TR5umedLG9waKmlg843CgExqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fdFELuMZ+5dUb3wgU5IfSrE4/56TYlqlVDjrmziewFScHqOCKVc3+kLnTMMTPRI9f
	 2jA4067tG8Q0yqI4apf+PjqGfdNedDIq0B/rLY1+/WSqb4zom1HrV6NfFGelcLkdZw
	 2Ad7PC5IEQ0yq3Ns2F8i6spR39KdDc3UL0H5omf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 28/75] iio: imu: inv_mpu6050: fix an error code problem in inv_mpu6050_read_raw
Date: Wed,  3 Jan 2024 17:55:09 +0100
Message-ID: <20240103164847.419851960@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164842.953224409@linuxfoundation.org>
References: <20240103164842.953224409@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit c3df0e29fb7788c4b3ddf37d5ed87dda2b822943 ]

inv_mpu6050_sensor_show() can return -EINVAL or IIO_VAL_INT. Return the
true value rather than only return IIO_VAL_INT.

Fixes: d5098447147c ("iio: imu: mpu6050: add calibration offset support")
Signed-off-by: Su Hui <suhui@nfschina.com>
Link: https://lore.kernel.org/r/20231030020218.65728-1-suhui@nfschina.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
index ae391ec4a7275..533c71a0dd01a 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
@@ -707,13 +707,13 @@ inv_mpu6050_read_raw(struct iio_dev *indio_dev,
 			ret = inv_mpu6050_sensor_show(st, st->reg->gyro_offset,
 						chan->channel2, val);
 			mutex_unlock(&st->lock);
-			return IIO_VAL_INT;
+			return ret;
 		case IIO_ACCEL:
 			mutex_lock(&st->lock);
 			ret = inv_mpu6050_sensor_show(st, st->reg->accl_offset,
 						chan->channel2, val);
 			mutex_unlock(&st->lock);
-			return IIO_VAL_INT;
+			return ret;
 
 		default:
 			return -EINVAL;
-- 
2.43.0



