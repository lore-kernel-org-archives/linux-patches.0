Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBA8357A20;
	Wed,  8 Apr 2026 18:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674778; cv=none; b=DgS0Sbx+qpX4CpC6oMz0BvyLiKQrpBZI/9wiXHXLWgXrAilgjFYh6SUKd6R+RJAGWTZCAi2zEnoos5Chj3/y7N4kCTYbmHIReg9DqBBk3A8QrsK2Czl0Sk484cPN1dJqO3cnEwREob74wu/NTS5G8Z5tfe5uWiySBMHFQQ5xOpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674778; c=relaxed/simple;
	bh=vtGKXDeD5WZmN34FIhDqisAW/VCA6x0MzlbIPT872xE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uVPWP2J7iWATqX6zZG3/SrG0zN4S8jqjytgqFcGW866vUkl/rWruDngaad71TpiP/VO2DSj5SiH5tDuXSiFId6XBxvwkRSEKrFlYqc5zcSTiGbNIdepAu1FogDcBckkKIhFNiEZndt9vPCiShRBl1jzfP+c8bWugzoH0Ru/8/eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cpV9gQga; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cpV9gQga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960C6C19421;
	Wed,  8 Apr 2026 18:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674777;
	bh=vtGKXDeD5WZmN34FIhDqisAW/VCA6x0MzlbIPT872xE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cpV9gQgay4zEHAlAlu2M0Cd/6IkAZ66Qss1Bi0zXMaTBWrBvyGH4R+IfeaHG7EOj2
	 RWivDY/T/vyCqJyyVTZNIx2JTzqT1Rxgxgp8otSaf4z1e5GUOdVftxXxLOZQ6PUDP/
	 a8DFKv/OGvGM3oMQJ/WN84BmiAU2yG0kkXhZ5dhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Lavra <flavra@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.19 229/311] iio: imu: st_lsm6dsx: Set FIFO ODR for accelerometer and gyroscope only
Date: Wed,  8 Apr 2026 20:03:49 +0200
Message-ID: <20260408175947.949453487@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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
@@ -225,6 +225,10 @@ static int st_lsm6dsx_set_fifo_odr(struc
 	const struct st_lsm6dsx_reg *batch_reg;
 	u8 data;
 
+	/* Only internal sensors have a FIFO ODR configuration register. */
+	if (sensor->id >= ARRAY_SIZE(hw->settings->batch))
+		return 0;
+
 	batch_reg = &hw->settings->batch[sensor->id];
 	if (batch_reg->addr) {
 		int val;


