Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BE531328E;
	Mon, 13 Apr 2026 16:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098908; cv=none; b=shAZN62empRMh4QChuoQpmCIVAChKYxIWueHvjuaXpJERGqTus3bxa62o/UyNYT+78XIL2sQEKqZwtDf73n1Cy+6z5WDFdYIYBvnbKgH/Td905bkGOwflvijKF+G2QP9x4jvZUgknCRxlhkUvRXnuztEiCzHrqK+md+ZwCACC8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098908; c=relaxed/simple;
	bh=23SQOBCrQB7j8U9IJED3fOmV0hGKwLxh9gpI9RkzFPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZL82k7GgAO3GeGijW5+EIuPi8vv4B2xqk0FxuRFXMQ9IJ/vvv24QungJRLnykXNNf1sc33ytvoz/BxiaktCcntMKY4bnNyDWvgBvTpublRTUiWRY3YAERRnCNjihXd/OrCGqvYw0aCKd+Buat7L+thiXQz5e3wm7qe0lygECqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nzw9stdg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nzw9stdg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1DA2C2BCAF;
	Mon, 13 Apr 2026 16:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098908;
	bh=23SQOBCrQB7j8U9IJED3fOmV0hGKwLxh9gpI9RkzFPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nzw9stdgOG39a9OFWn95vflTfUV0Txu589L/P/J1QJTzm9aoMHZEg4YVIjZbNWgRW
	 sniLSmeBEo4YKuVJ13NpXTmTNSY5XEvrunSy3jK5cIAVt6fSnvUU5NlH0j0QYvb8L/
	 6hiLs3Oy+LvzwIKWpbCO6E4mNmcn7RIs1jFB6JPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 134/491] iio: imu: inv_icm42600: fix odr switch to the same value
Date: Mon, 13 Apr 2026 17:56:19 +0200
Message-ID: <20260413155824.057611929@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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
@@ -322,6 +322,8 @@ static int inv_icm42600_accel_write_odr(
 		return -EINVAL;
 
 	conf.odr = inv_icm42600_accel_odr_conv[idx / 2];
+	if (conf.odr == st->conf.accel.odr)
+		return 0;
 
 	pm_runtime_get_sync(dev);
 	mutex_lock(&st->lock);
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
@@ -334,6 +334,8 @@ static int inv_icm42600_gyro_write_odr(s
 		return -EINVAL;
 
 	conf.odr = inv_icm42600_gyro_odr_conv[idx / 2];
+	if (conf.odr == st->conf.gyro.odr)
+		return 0;
 
 	pm_runtime_get_sync(dev);
 	mutex_lock(&st->lock);


