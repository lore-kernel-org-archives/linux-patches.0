Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A3A268688;
	Tue, 21 Oct 2025 19:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076604; cv=none; b=XFMQnbdOhFZ3R3P8LhD8DmMw5w6wUOPJfNAsOXwrgc0S9dLjZPjJsX29bXHF7tK/jutCgV5qJOfJt0gIP1edJofOfXAbsnruoTQx1A/3pYLOferC7wzqw8arFO8mjPLhW4CjxZ1Yss1zooRmpCZqH21nKk09f/x7ahFyCP5Tazw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076604; c=relaxed/simple;
	bh=GcpWNeFivdp1eznU3eQz6nXCH0L01Vi0wx2yNHrIeIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pg1KWxY6vq3toPLIg/gRRIqyeK+Ls+/MZ70fZ1NXTdO7yfuNGRcrO9ISwM94FcBRsDZhvoewq3qNNCtEtQc+uISaCuVkI+Izt8uMSgZ0KmZjz3debb9JJ67yDm+8DHlOOddtH7TdxL/Uv53uYDJ30cDZoh9joXHXujcbw5XuvoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=imF1CDGQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="imF1CDGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A71C4CEF1;
	Tue, 21 Oct 2025 19:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076603;
	bh=GcpWNeFivdp1eznU3eQz6nXCH0L01Vi0wx2yNHrIeIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=imF1CDGQ0ICqRs+wPRA0GRZ3dW1GzchZ5JMwAevxj1mSKd8aBSMcKeu9aSHVBKWAL
	 oMjgbPufMwTBbH4WPpRbLphyk8JUfoFDeiFlQ7olE14ReXlgZaIKo3b99zq2dni9Ci
	 7sC9nd9TogEOoS+WseV391nuBxQCLmXzB25ngvVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/105] iio: imu: inv_icm42600: reorganize DMA aligned buffers in structure
Date: Tue, 21 Oct 2025 21:51:34 +0200
Message-ID: <20251021195023.668840108@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

[ Upstream commit 0c122c280e78150b0c666fb69db0000cdd1d7e0a ]

Move all DMA aligned buffers together at the end of the structure.

1. Timestamp anynomous structure is not used with DMA so it doesn't
belong after __aligned(IIO_DMA_MINALIGN).
2. struct inv_icm42600_fifo contains it's own __aligned(IIO_DMA_MINALIGN)
within it at the end so it should not be after __aligned(IIO_DMA_MINALIGN)
in the outer struct either.
3. Normally 1 would have been considered a bug, but because of the extra
alignment from 2, it actually was OK, but we shouldn't be relying on such
quirks.

Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Link: https://patch.msgid.link/20250630-losd-3-inv-icm42600-add-wom-support-v6-1-5bb0c84800d9@tdk.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 466f7a2fef2a ("iio: imu: inv_icm42600: Avoid configuring if already pm_runtime suspended")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600.h
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600.h
@@ -126,9 +126,9 @@ struct inv_icm42600_suspended {
  *  @suspended:		suspended sensors configuration.
  *  @indio_gyro:	gyroscope IIO device.
  *  @indio_accel:	accelerometer IIO device.
- *  @buffer:		data transfer buffer aligned for DMA.
- *  @fifo:		FIFO management structure.
  *  @timestamp:		interrupt timestamps.
+ *  @fifo:		FIFO management structure.
+ *  @buffer:		data transfer buffer aligned for DMA.
  */
 struct inv_icm42600_state {
 	struct mutex lock;
@@ -142,12 +142,12 @@ struct inv_icm42600_state {
 	struct inv_icm42600_suspended suspended;
 	struct iio_dev *indio_gyro;
 	struct iio_dev *indio_accel;
-	u8 buffer[2] __aligned(IIO_DMA_MINALIGN);
-	struct inv_icm42600_fifo fifo;
 	struct {
 		s64 gyro;
 		s64 accel;
 	} timestamp;
+	struct inv_icm42600_fifo fifo;
+	u8 buffer[2] __aligned(IIO_DMA_MINALIGN);
 };
 
 /* Virtual register addresses: @bank on MSB (4 upper bits), @address on LSB */


