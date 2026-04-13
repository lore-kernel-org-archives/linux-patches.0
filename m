Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49E8280CFB;
	Mon, 13 Apr 2026 16:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098274; cv=none; b=QvBKXiDQlyhyV8EsDgmrgxMcyRyMQIJYNDhrvFY/F184+v2cyiU8R6JcOEHtPTziY6NlJFSahWKNYSaN7yEgjM7vRgWgBAglrjSlSG/Usmeu8MjycYtEPE6TvIWh9ExWV7R6nPU43r94vfwg6xhVU/i2gCEC211mSnPclwz+/vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098274; c=relaxed/simple;
	bh=DqHbg3hogHNKf0Mqkay4iAI2q1ykPcJNxIbvOO3DQsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pbXoHp97OwbFkdsw4rOEmysOjw/7WTOP7tZ8dPuHzooHYwjBJp23dp4MlEO3ISKXjVkkQHwlsNgWa6Mco4X/rTeW+PVjgBg8PQkghg11D5HSiPkQBmM0n+fwrjfq4dDXQ7aTNtOlOku1koICe/PJP0MQO10mf1xUnBnqemY7Rqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m9vgSVJ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m9vgSVJ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B6CC2BCAF;
	Mon, 13 Apr 2026 16:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098274;
	bh=DqHbg3hogHNKf0Mqkay4iAI2q1ykPcJNxIbvOO3DQsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m9vgSVJ2IbJSljkYUXvzZPEivnlEwERf9ZI6llpIYgO35WdNskxdQpehHHKP5LPaP
	 DE9ap1STt2NQ1pCCBdXMpn+GVyH1EJjHufDEXDm+RCDV5TS634R/42t3VeOeCxdN1h
	 UC7KJIqWBkuejrJmiYO/+4YDZvDpbd68CZC0F2h4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Lavra <flavra@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 461/570] iio: imu: st_lsm6dsx: Set FIFO ODR for accelerometer and gyroscope only
Date: Mon, 13 Apr 2026 17:59:52 +0200
Message-ID: <20260413155847.740040696@linuxfoundation.org>
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

From: Francesco Lavra <flavra@baylibre.com>

commit 630748afa7030b272b7bee5df857e7bcf132ed51 upstream.

The st_lsm6dsx_set_fifo_odr() function, which is called when enabling and
disabling the hardware FIFO, checks the contents of the hw->settings->batch
array at index sensor->id, and then sets the current ODR value in sensor
registers that depend on whether the register address is set in the above
array element. This logic is valid for internal sensors only, i.e. the
accelerometer and gyroscope; however, since commit c91c1c844ebd ("iio: imu:
st_lsm6dsx: add i2c embedded controller support"), this function is called
also when configuring the hardware FIFO for external sensors (i.e. sensors
accessed through the sensor hub functionality), which can result in
unrelated device registers being written.

Add a check to the beginning of st_lsm6dsx_set_fifo_odr() so that it does
not touch any registers unless it is called for internal sensors.

Fixes: c91c1c844ebd ("iio: imu: st_lsm6dsx: add i2c embedded controller support")
Signed-off-by: Francesco Lavra <flavra@baylibre.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
@@ -201,6 +201,10 @@ static int st_lsm6dsx_set_fifo_odr(struc
 	const struct st_lsm6dsx_reg *batch_reg;
 	u8 data;
 
+	/* Only internal sensors have a FIFO ODR configuration register. */
+	if (sensor->id >= ARRAY_SIZE(hw->settings->batch))
+		return 0;
+
 	batch_reg = &hw->settings->batch[sensor->id];
 	if (batch_reg->addr) {
 		int val;


