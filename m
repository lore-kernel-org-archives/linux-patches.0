Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A57A324B1F;
	Wed,  8 Apr 2026 18:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672801; cv=none; b=cJoZP05mt9p8WakeKHiTjDo1+4rtOxcNpzvDafkPHuDj4iTK5qZsZa2UOtuScE3Rqau/Its8/TTRH7PW71WJ2AQHjzqmMW2PhEKWGOsaEFxRC6CEzRqsLYldrDwEpyiY8EclVveuZu+3fUVCN3OJK0N/ZdxW+C77XjgUSXbcAfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672801; c=relaxed/simple;
	bh=8geJV71/F2ev2mWNb2rvKtfF6XgYGVMVMdYFc39I2QY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIGUHEPzgrDE/M9nnFDH3KRgSa8vnSjBgFvB+P2rUwt5x7Evp9sWULnxguhMH3OUolBu5uHblYMeU43PmU69KuTPWoIMgNAoSRdd9nTzu+oQwTk5dDvXzjonRPyQH5XwNC4cVKzLG8iux4MqjIoDMO8F38oU03aKR+BI70gcvdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ljfKWO0u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ljfKWO0u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F64C19421;
	Wed,  8 Apr 2026 18:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672801;
	bh=8geJV71/F2ev2mWNb2rvKtfF6XgYGVMVMdYFc39I2QY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ljfKWO0uqnSHRHT5SJer+tckNIXLxNv62xu1lsNtPk8r8uLp11KtJpS73bB3/v8oa
	 s8SxWgWSFQxHPCh+lrwGkIRnErFavrbCRiqzl6EjQNeYVNxDkGtccRMXLGcSEM/yUA
	 5KkJ/+hBri0RJyQllIzver6YoVC7X2MYQP1OkZM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 148/160] iio: imu: inv_icm42600: fix odr switch when turning buffer off
Date: Wed,  8 Apr 2026 20:03:55 +0200
Message-ID: <20260408175918.718564392@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

[ Upstream commit ffd32db8263d2d785a2c419486a450dc80693235 ]

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
 drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c
@@ -378,6 +378,7 @@ out_unlock:
 static int inv_icm42600_buffer_postdisable(struct iio_dev *indio_dev)
 {
 	struct inv_icm42600_state *st = iio_device_get_drvdata(indio_dev);
+	struct inv_sensors_timestamp *ts = iio_priv(indio_dev);
 	struct device *dev = regmap_get_device(st->map);
 	unsigned int sensor;
 	unsigned int *watermark;
@@ -399,6 +400,8 @@ static int inv_icm42600_buffer_postdisab
 
 	mutex_lock(&st->lock);
 
+	inv_sensors_timestamp_apply_odr(ts, 0, 0, 0);
+
 	ret = inv_icm42600_buffer_set_fifo_en(st, st->fifo.en & ~sensor);
 	if (ret)
 		goto out_unlock;


