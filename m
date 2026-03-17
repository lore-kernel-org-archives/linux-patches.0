Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AFC29D26C;
	Tue, 17 Mar 2026 17:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766958; cv=none; b=FL/M+N0NDI9G1bcCiyc+I8dhv+DhyskM2ezMp//0PC/bieNgYT8cxowRv2yM55j4sR/3itqNMHp2q7IpOTOWTI//poXQWGW9hOfrCUVmt85kH3iUwkXxJ71v/gwuXRUk/fTo0IIuXhVQ5uBMyJBpN+tm8uyu7rAFPXpAAvZDtHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766958; c=relaxed/simple;
	bh=UlTuts0CMaxx8GzByYTF85MO11xJz0I94h887xj6DtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=acCLWk7LE238tDRsfiBRQP++o++YJ3O5kv5Xe2qbivrJV+1qRIanMoZgNQdCJO9zGpA6wEMKCYvKGgc95iUTeDwQyPfNpkq90/O33ASRyJIFlJmnAa1HXd7eeku4sBqHfU8EvhB0ItHj8zBb4gyCPB3cV8MXLrWiO65iBMojOZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ScEan8Xo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ScEan8Xo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9BDBC4CEF7;
	Tue, 17 Mar 2026 17:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766958;
	bh=UlTuts0CMaxx8GzByYTF85MO11xJz0I94h887xj6DtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ScEan8XotISgyfMpNHFuvuL3qcFPgK+nXfhmpEdMuv/gW3iAuwB021wQi+0ehhlxl
	 oE0GfDrbr1V1P+lDA0tbNRG33xD89PyNdO6FqDV6vqmqc5i78Mp3ENaENm7bvfoR+4
	 VI3OGVFnISCcr43ySJHQsyVzdb9LA3skoBOizpnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.19 360/378] iio: imu: inv_icm42600: fix odr switch to the same value
Date: Tue, 17 Mar 2026 17:35:17 +0100
Message-ID: <20260317163020.224562824@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

commit c9f3a593137d862d424130343e77d4b5260a4f5a upstream.

ODR switch is done in 2 steps when FIFO is on : change the ODR register
value and acknowledge change when reading the FIFO ODR change flag.
When we are switching to the same odr value, we end up waiting for a
FIFO ODR flag that is never happening.

Fix the issue by doing nothing and exiting properly when we are
switching to the same ODR value.

Fixes: ec74ae9fd37c ("iio: imu: inv_icm42600: add accurate timestamping")
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c |    2 ++
 drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c  |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
@@ -651,6 +651,8 @@ static int inv_icm42600_accel_write_odr(
 		return -EINVAL;
 
 	conf.odr = inv_icm42600_accel_odr_conv[idx / 2];
+	if (conf.odr == st->conf.accel.odr)
+		return 0;
 
 	pm_runtime_get_sync(dev);
 	mutex_lock(&st->lock);
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
@@ -358,6 +358,8 @@ static int inv_icm42600_gyro_write_odr(s
 		return -EINVAL;
 
 	conf.odr = inv_icm42600_gyro_odr_conv[idx / 2];
+	if (conf.odr == st->conf.gyro.odr)
+		return 0;
 
 	pm_runtime_get_sync(dev);
 	mutex_lock(&st->lock);


