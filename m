Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D341917DE36;
	Mon, 23 Mar 2026 14:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275774; cv=none; b=JTiShN5hKCFA7w4lP1+lC8YsmFtWpFmSWheBO/cPPa3iuz81Dk/aPhgXgx68f39AeoBkbXFOy2GIGPohmFQRDNefu313YIzPRJowj6MlCeJ3TcQiC65RxuTqaHmvVl5LoWcvutKfZUnWE/dTyImxQ/YQJRSuzMDFBHBzuvTjtS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275774; c=relaxed/simple;
	bh=g3ggynvvNfijLK+PpLbJi66D4HHaXX2gRFRVQnSg/Vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kHXLBVdaxZJokcyMgHv8duibP00hY20fFgJ8Nn6N9P3rXcM1j+pVcO4zGfdS5vRjHeg5jOR2+FenhIim5pov3jCjMsGitijq++konlSXYOGAhoNcbpImVJ6RwH1w5+R4kXTUySZhMYlT89bkD2dB0wU4xcaXL6jaxNxtVcsnF3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R1reLUbQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R1reLUbQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34ABFC4CEF7;
	Mon, 23 Mar 2026 14:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275774;
	bh=g3ggynvvNfijLK+PpLbJi66D4HHaXX2gRFRVQnSg/Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R1reLUbQ+xTeXkICQP5zXE+k1nLEJI13oXAl0H1HxHwnUcnphTyzQh/ALO6d1zh58
	 Lq9JApusj8Ko7A/LsTgS/5eaJBpQOS4MYPozCreS+3n+VsaRQQ78EgBL0Z4G7hI0wG
	 d82ykixR9CgQGDuIt63oylUK1bNEHsVkv2nEyslo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 213/460] iio: imu: inv_icm42600: fix odr switch when turning buffer off
Date: Mon, 23 Mar 2026 14:43:29 +0100
Message-ID: <20260323134531.748164135@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

commit ffd32db8263d2d785a2c419486a450dc80693235 upstream.

ODR switch is done in 2 steps when FIFO is on : change the ODR register
value and acknowledge change when reading the FIFO ODR change flag.
When we are switching odr and turning buffer off just afterward, we are
losing the FIFO ODR change flag and ODR switch is blocked.

Fix the issue by force applying any waiting ODR change when turning
buffer off.

Fixes: ec74ae9fd37c ("iio: imu: inv_icm42600: add accurate timestamping")
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c
@@ -389,6 +389,8 @@ out_unlock:
 static int inv_icm42600_buffer_postdisable(struct iio_dev *indio_dev)
 {
 	struct inv_icm42600_state *st = iio_device_get_drvdata(indio_dev);
+	struct inv_icm42600_sensor_state *sensor_st = iio_priv(indio_dev);
+	struct inv_sensors_timestamp *ts = &sensor_st->ts;
 	struct device *dev = regmap_get_device(st->map);
 	unsigned int sensor;
 	unsigned int *watermark;
@@ -410,6 +412,8 @@ static int inv_icm42600_buffer_postdisab
 
 	mutex_lock(&st->lock);
 
+	inv_sensors_timestamp_apply_odr(ts, 0, 0, 0);
+
 	ret = inv_icm42600_buffer_set_fifo_en(st, st->fifo.en & ~sensor);
 	if (ret)
 		goto out_unlock;


