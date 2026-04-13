Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99ECC327BEC;
	Mon, 13 Apr 2026 16:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099550; cv=none; b=YH4BFPSer3QnWEjzfCCS1lnKF0HcWMpOw0Jt+o7rJZ/yz0y8RApfP8sz+gJ4RUV7e2PLtHSAp3cvdxY3bA2Vk5wZPULC9TOEv5zaXQ+nw8OrM0BAGplfb1q/J9mzDSoB34/fhew9zgodpo4vmME+N9W2D2DNT3xtHB8pMv80QTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099550; c=relaxed/simple;
	bh=JU1F+aGs7c0Jk4YRyHx8sGY77Z3G2Kjb6lK87OeLulI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KrHCYtp3c+cBmlHNjrBgoaI1tM3UIfqunVhj9KLoBEr0V98V45kIxiDfOUVvtD73gR2Hfl7+0j4GfHaWY5aEehUBGHow9o5I9z2ciHc9MfNT+EEZc6jtX+C4uF20d0AdYuiHAFy0oZFAC5qo6xNedcM6lF1tsyX+UkIrVsaQcnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fh/GWA5b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fh/GWA5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30968C2BCAF;
	Mon, 13 Apr 2026 16:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099550;
	bh=JU1F+aGs7c0Jk4YRyHx8sGY77Z3G2Kjb6lK87OeLulI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fh/GWA5brPzzmVyHH/AlGNOHiX+YJz4yvrcgZcDVYKS7m9DfthPHlv725e9aNkKnf
	 pFc184gEvESvyN1L6rnKgJuhGRZQz6JvD/tonL7kv56cXJDRjFjNcVeXUG+lwQ5CFO
	 vtyPC2iP+WD6H0xKQvMXz5WQigF5VNBUc1KalYnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Lavra <flavra@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 382/491] iio: imu: st_lsm6dsx: Set FIFO ODR for accelerometer and gyroscope only
Date: Mon, 13 Apr 2026 18:00:27 +0200
Message-ID: <20260413155833.334604050@linuxfoundation.org>
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


