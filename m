Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1E630B50F;
	Mon, 13 Apr 2026 16:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097576; cv=none; b=iqRziEe0L7GcaC/8sH0V+c/k2+wAH98rmoxtN5dUQovnIMkNx5bqyWuqiIrcIVtJFvVCGX3N6tEVzTZ10e28LN9EUVfd1PwjCXhxOQQqzY40QarZd6///infCTutPGha4j9x/upbNd+OOmj8YpHIdLrRvqjntvTlakj9L3ddE1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097576; c=relaxed/simple;
	bh=LvwynEWwVDJF9zM4SUtxayaoqm9qTRurCJBRy1XdB4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fj75Tzl6seqvlgbcezZdt7uBns3hs65wVXwyK4xa5giZwpLIpw/UVMFrC6KsUjveZ+HAgSGKW7VLI1ItAg74kwCRv23u+Uo8HEfbiNSigZ9LlFN/xSwt/gBZLXVL25RcvHgHBWtPLp4My2a/UX18ryxxAYsOjjwt+gnXJEQlsgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bfx4MYJG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bfx4MYJG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34050C2BCB3;
	Mon, 13 Apr 2026 16:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097576;
	bh=LvwynEWwVDJF9zM4SUtxayaoqm9qTRurCJBRy1XdB4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bfx4MYJGqwPe4e9pDZJqJW+HNy4o662Z0Ia/0BLaA4fj0MAvF5Tj6s7v6MRX1Qe5E
	 HYHswXSjxcW4ktwzumbYc8oroFsR/uXogqfE8+cLMcnaiW1FWThy5jWiCjUYNNrT4u
	 0ATeU3QzKOOc+LPac6U3tLNWCkNvKIBXKRR1KDP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 189/570] iio: imu: inv_icm42600: fix odr switch to the same value
Date: Mon, 13 Apr 2026 17:55:20 +0200
Message-ID: <20260413155837.539015639@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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


