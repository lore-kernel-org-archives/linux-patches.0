Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDE5324B16;
	Mon, 23 Mar 2026 14:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275771; cv=none; b=ahM2LOn3SKR3TTzGy5se1pxdYg2812gs/MJK+vnPB1xIr8v8GYKbYtRzHKIjbOrZDQ7+6l2kxC66tBng1O7kU4a4yDsED/+c5RMJqa/TIsN6V84vDt54aK8wgWsSs+UP1QeSFPxS9N43+QBe6vjBFgItRW9l60NuuGjTfLnMYLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275771; c=relaxed/simple;
	bh=iJIZ5T6KgtWpFygaC8EW5VLooi/0h2afS6CyGZCOZsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iMuWhuY+fm0JR19DpMPUWyak7CQ0uvfEagFQgVzKpHVmpcGsztuAlB1O3hyK10nuwD66JCNuRgVGzRxkCwvjEqxnrpkXIx5gcoxZGW8hVtJMxdUHLfrpH8wPCQuEOcuKV+UeJ0Z9yjSlFomIPp2zD+yDD7oGiSUMUc9HSemnw6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AyR5/yvK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AyR5/yvK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA16C4CEF7;
	Mon, 23 Mar 2026 14:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275771;
	bh=iJIZ5T6KgtWpFygaC8EW5VLooi/0h2afS6CyGZCOZsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AyR5/yvKwYLnFtX2PALooSxeQPgx72lbSFbmIIXMIyxImaq98GZzAFqqELztDCkNV
	 4D0PuSfKP2OFgIVo5/a8cWtGtLwJq6mZEwuJbWHIXzCs0dVdf9tuNvOo5zh4AFiL7P
	 CjQBKDH4nJ9jFQtPWSMOLIprx9F1ZfbdMOZFQ4HY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 212/460] iio: imu: inv_icm42600: fix odr switch to the same value
Date: Mon, 23 Mar 2026 14:43:28 +0100
Message-ID: <20260323134531.723725901@linuxfoundation.org>
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
@@ -454,6 +454,8 @@ static int inv_icm42600_accel_write_odr(
 		return -EINVAL;
 
 	conf.odr = inv_icm42600_accel_odr_conv[idx / 2];
+	if (conf.odr == st->conf.accel.odr)
+		return 0;
 
 	pm_runtime_get_sync(dev);
 	mutex_lock(&st->lock);
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
@@ -361,6 +361,8 @@ static int inv_icm42600_gyro_write_odr(s
 		return -EINVAL;
 
 	conf.odr = inv_icm42600_gyro_odr_conv[idx / 2];
+	if (conf.odr == st->conf.gyro.odr)
+		return 0;
 
 	pm_runtime_get_sync(dev);
 	mutex_lock(&st->lock);


