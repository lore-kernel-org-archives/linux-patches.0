Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554C929D26C;
	Tue, 17 Mar 2026 17:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766962; cv=none; b=k4YmxM/qSSHIRuW5iPRZtC6ZLr/k2b+L8ColDBBXVFiBp3QDfXhhue+pn8xCS34fpuj78g5zRit5WdtngoJjBnATyenHRdeuBAA6ZJP8tI46wRsMvyh0YDFXqEs77JwK4YAh3dP0z+QjD0j1idcbGNkGhAmcx72Tp4K5p7nte8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766962; c=relaxed/simple;
	bh=nIQLSZ0nAC7PJwEYWbcnfVZQU5gOwieS6vPyH8YpAgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDS7YFVs2Ctht4QwIqp9MsjzE3OjIWxnlVkmvh8nRac+xIZHSm/4f7TujVQBT841S+yNcziUTpcw9Aaf867jHIDjrGfbm5a7rYOrlXBi+DzCVd2xR+YQD1LJWF9h7o4Xg/PsjV5Y7+ZrYbK+MOlFDAsMGN0wMf2vdsg4F/yMHiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lNRFuYYG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lNRFuYYG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C411C4CEF7;
	Tue, 17 Mar 2026 17:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766962;
	bh=nIQLSZ0nAC7PJwEYWbcnfVZQU5gOwieS6vPyH8YpAgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lNRFuYYG53GMgLvt/SPbCn8YZZ+smUAGNgy7OFjkzDgYKm0jWhV4Sts2ETS+L9Pwj
	 DYNGhP0F1YCEz4xGcbAfJEf0Ujz7pVst6Slj61cznS7U6n+gieAqSE880J8/qsf/gE
	 IqkkBycQ2si/jxyewIcRKrgEK4v9JtDpzUw0/0M0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.19 361/378] iio: imu: inv_icm42600: fix odr switch when turning buffer off
Date: Tue, 17 Mar 2026 17:35:18 +0100
Message-ID: <20260317163020.261538156@linuxfoundation.org>
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
@@ -371,6 +371,8 @@ static int inv_icm42600_buffer_predisabl
 static int inv_icm42600_buffer_postdisable(struct iio_dev *indio_dev)
 {
 	struct inv_icm42600_state *st = iio_device_get_drvdata(indio_dev);
+	struct inv_icm42600_sensor_state *sensor_st = iio_priv(indio_dev);
+	struct inv_sensors_timestamp *ts = &sensor_st->ts;
 	struct device *dev = regmap_get_device(st->map);
 	unsigned int sensor;
 	unsigned int *watermark;
@@ -392,6 +394,8 @@ static int inv_icm42600_buffer_postdisab
 
 	mutex_lock(&st->lock);
 
+	inv_sensors_timestamp_apply_odr(ts, 0, 0, 0);
+
 	ret = inv_icm42600_buffer_set_fifo_en(st, st->fifo.en & ~sensor);
 	if (ret)
 		goto out_unlock;


