Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5F22C11CA;
	Thu, 15 Jan 2026 17:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497336; cv=none; b=ekf0hpZSmFr4gIYSs7E33SAbAeL/ROHWvlk24TgDuw2bs2v2lgpc/SFVtP/PT/B600PaiTEGTk/jPTu6vpa7bELFQbRC30WXQdxI/uWWz7W5uwPeOjGiDcLfZd/gwE9DEU2BNqXafkvMQgXPCxXblVyHp8t2YCDtyMFS/V3G3tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497336; c=relaxed/simple;
	bh=JcvPa/RGsY4/FICFrUXK4j2fC4xamleF+VwU3DbyTGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MhSBvjD663AGd9tFBY8nhK3A7ymmIiBoqJf5Szirva6ZQQNIknKILSzt1YrB6BlU8o6kGedefZ0TE5QERTbFGTBD8le3VJudwIejNLNtfz1ri/Xbrwa5sgMgkJY9KVN+t6xcO6bwVplyy8hFHCb8TyzpR662UA5dZhIBkcKPKK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BbmldvkR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BbmldvkR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2A4C116D0;
	Thu, 15 Jan 2026 17:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497335;
	bh=JcvPa/RGsY4/FICFrUXK4j2fC4xamleF+VwU3DbyTGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BbmldvkRkVXkFtV7o/8Ebx6BZsPjdMrQPdfDD46pto/dIuubSJFfBwZfM3SdN9JoU
	 vCiq+WNEzDOOfx3gFbR4UZ/BJZsNNUGYwgXEA2RAFOKrnkj1KQDeMj3lE1Hrk6hTlt
	 YK7cU6GwIMIxdmJzj5ZPVGbGuTNyseG6RDoHZb3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 045/554] iio: imu: st_lsm6dsx: introduce st_lsm6dsx_device_set_enable routine
Date: Thu, 15 Jan 2026 17:41:51 +0100
Message-ID: <20260115164247.877976354@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit cd83c5c10036a2a156d725725daf3409832c8a24 ]

Introduce st_lsm6dsx_device_set_enable utility routine and remove
duplicated code used to enable/disable sensors

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://lore.kernel.org/r/e3fbe5d4a3bed41130908669f745f78c8505cf47.1665399959.git.lorenzo@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: c6d702f2b771 ("iio: imu: st_lsm6dsx: Fix measurement unit for odr struct member")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h        | 11 +++++++++++
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c | 14 +++-----------
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c   | 14 ++------------
 3 files changed, 16 insertions(+), 23 deletions(-)

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
index 72abb5c62e4a9..6a6e963fe9731 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
@@ -505,6 +505,17 @@ st_lsm6dsx_get_mount_matrix(const struct iio_dev *iio_dev,
 	return &hw->orientation;
 }
 
+static inline int
+st_lsm6dsx_device_set_enable(struct st_lsm6dsx_sensor *sensor, bool enable)
+{
+	if (sensor->id == ST_LSM6DSX_ID_EXT0 ||
+	    sensor->id == ST_LSM6DSX_ID_EXT1 ||
+	    sensor->id == ST_LSM6DSX_ID_EXT2)
+		return st_lsm6dsx_shub_set_enable(sensor, enable);
+
+	return st_lsm6dsx_sensor_set_enable(sensor, enable);
+}
+
 static const
 struct iio_chan_spec_ext_info __maybe_unused st_lsm6dsx_accel_ext_info[] = {
 	IIO_MOUNT_MATRIX(IIO_SHARED_BY_ALL, st_lsm6dsx_get_mount_matrix),
diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
index e78b699a044ed..9ebaf73561336 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
@@ -678,17 +678,9 @@ int st_lsm6dsx_update_fifo(struct st_lsm6dsx_sensor *sensor, bool enable)
 			goto out;
 	}
 
-	if (sensor->id == ST_LSM6DSX_ID_EXT0 ||
-	    sensor->id == ST_LSM6DSX_ID_EXT1 ||
-	    sensor->id == ST_LSM6DSX_ID_EXT2) {
-		err = st_lsm6dsx_shub_set_enable(sensor, enable);
-		if (err < 0)
-			goto out;
-	} else {
-		err = st_lsm6dsx_sensor_set_enable(sensor, enable);
-		if (err < 0)
-			goto out;
-	}
+	err = st_lsm6dsx_device_set_enable(sensor, enable);
+	if (err < 0)
+		goto out;
 
 	err = st_lsm6dsx_set_fifo_odr(sensor, enable);
 	if (err < 0)
diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
index a778aceba3b10..dd674f3119ad2 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -2304,12 +2304,7 @@ static int __maybe_unused st_lsm6dsx_suspend(struct device *dev)
 			continue;
 		}
 
-		if (sensor->id == ST_LSM6DSX_ID_EXT0 ||
-		    sensor->id == ST_LSM6DSX_ID_EXT1 ||
-		    sensor->id == ST_LSM6DSX_ID_EXT2)
-			err = st_lsm6dsx_shub_set_enable(sensor, false);
-		else
-			err = st_lsm6dsx_sensor_set_enable(sensor, false);
+		err = st_lsm6dsx_device_set_enable(sensor, false);
 		if (err < 0)
 			return err;
 
@@ -2340,12 +2335,7 @@ static int __maybe_unused st_lsm6dsx_resume(struct device *dev)
 		if (!(hw->suspend_mask & BIT(sensor->id)))
 			continue;
 
-		if (sensor->id == ST_LSM6DSX_ID_EXT0 ||
-		    sensor->id == ST_LSM6DSX_ID_EXT1 ||
-		    sensor->id == ST_LSM6DSX_ID_EXT2)
-			err = st_lsm6dsx_shub_set_enable(sensor, true);
-		else
-			err = st_lsm6dsx_sensor_set_enable(sensor, true);
+		err = st_lsm6dsx_device_set_enable(sensor, true);
 		if (err < 0)
 			return err;
 
-- 
2.51.0



