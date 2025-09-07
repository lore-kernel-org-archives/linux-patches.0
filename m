Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448CC1E1C1A;
	Sun,  7 Sep 2025 20:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276705; cv=none; b=FW1OyYodkkGm20Qp4AvfESUnpu3OkPvo1Kqkv82fi6sqcz0zVvqks4MGW6OWt6pWoOQItTw3HBsq9tuthAjm/Kn3BxFruKP6U5a8gyDgJQ4ZFf7huHN9Yj9hVlb5R1kxeaTfwCG0u8G6XH/7vngYeLmOgaPx5/45H0Flwp8GyCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276705; c=relaxed/simple;
	bh=GQu+FB8PpBkMxKOIl55FelIO10YZKdJ57y1XXuNmmXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dztMi0ucFoAnBekjSBpvvmAHACBMushYMnc2ygynhPh1bpGfLLkYHgJMjC6BTBEgZsM+rGFTfHaYaqBKYozmqcuAFGySfTuF4uZoEMefcl51HU9SKYZZTKc/kO22Kn0TBBi+MFmddrm4fPn9KYF8KfgtLBzjxUW3q1QLzIicVSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OyjL71qt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OyjL71qt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0BBC4CEF0;
	Sun,  7 Sep 2025 20:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276705;
	bh=GQu+FB8PpBkMxKOIl55FelIO10YZKdJ57y1XXuNmmXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OyjL71qtW3bOQnr6SDTwg1pU1i5ATfrF3BSW1bhns1W8/MeZRxcyJG59rZSSi8ROs
	 wjODl5i4V22uGxguZGa6qM0WGNt6ZmqavLrxmX3Fo8P1Z8BVQ6LQN7QNuNm+MF1xsF
	 25QpXc6M1GaB7e9vP8IZGrsBKHJDHvSsYTGCt9pU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 083/121] iio: imu: inv_mpu6050: align buffer for timestamp
Date: Sun,  7 Sep 2025 21:58:39 +0200
Message-ID: <20250907195611.968063933@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit 1d2d8524eaffc4d9a116213520d2c650e07c9cc6 ]

Align the buffer used with iio_push_to_buffers_with_timestamp() to
ensure the s64 timestamp is aligned to 8 bytes.

Fixes: 0829edc43e0a ("iio: imu: inv_mpu6050: read the full fifo when processing data")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250417-iio-more-timestamp-alignment-v1-7-eafac1e22318@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c
@@ -52,7 +52,7 @@ irqreturn_t inv_mpu6050_read_fifo(int ir
 	u16 fifo_count;
 	u32 fifo_period;
 	s64 timestamp;
-	u8 data[INV_MPU6050_OUTPUT_DATA_SIZE];
+	u8 data[INV_MPU6050_OUTPUT_DATA_SIZE] __aligned(8);
 	int int_status;
 	size_t i, nb;
 


