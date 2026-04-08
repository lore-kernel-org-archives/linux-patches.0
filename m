Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082FE3D75C9;
	Wed,  8 Apr 2026 18:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674518; cv=none; b=N+b1gy7rXX7eaf2Wt+lWT57+q2FqLvjt4zFf3uyjXdJ7u7AeEXC+ZpGgTi/uMLjF1yA/ugPTPz4SxhOopFQTJyjTOo/40pnhDcVzFoTw3IX82SscHPVKTZv7WbdBFMVyoNjyg6XeiH/br4+Dn2YK5ZMLfYhgaAcOtZwyA3HO+oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674518; c=relaxed/simple;
	bh=pH0D8DMMrjDbG76v059w04Ow6JuYtS3RrYsolSoioWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJ8FsKAm+w+sjSDR9J+sq+US2aF4zlI8MvRxXNoLoRmOaRvF3cDYs9gikVaZ86Y5dx7RzK6o0M+3Rz8HBAM5Gsm6z2zisaAIe+LLASVk6sj7Gb9U1LadinKYnzirIH2r72jDry5kKJwmbvIsHWEuV32W9wpo+cXICDBl7N24iLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z9e+hInu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z9e+hInu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8967AC19421;
	Wed,  8 Apr 2026 18:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674517;
	bh=pH0D8DMMrjDbG76v059w04Ow6JuYtS3RrYsolSoioWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z9e+hInu3uI6PpF8Ws2Cpy9OGKteDLqzgvXYEGeLv3DCYOlay3BwWoTQEBZ7TriPD
	 OY0v/uUhkDxq1hRDOgWc3lrm7Nxjuc15oaHzC6K+Htt66WzcFDKKU6C34NnHkRVM56
	 DmDMIfcRtOMYea1FiIciicnEQ6z/rPYwzLgA/VJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 128/311] iio: imu: bno055: fix BNO055_SCAN_CH_COUNT off by one
Date: Wed,  8 Apr 2026 20:02:08 +0200
Message-ID: <20260408175944.196374508@linuxfoundation.org>
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

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit 773ef9f95385bae52dcb7fd129fefba3a71a04db ]

Fix an off-by-one error in the BNO055_SCAN_CH_COUNT macro. The count
is derived by taking the difference of the last and first register
addresses, dividing by the size of each channel (2 bytes). It needs to
also add 1 to account for the fact that the count is inclusive of both
the first and last channels.

Thanks to the aligned_s64 timestamp field, there was already extra
padding in the buffer, so there were no runtime issues caused by this
bug.

Fixes: 4aefe1c2bd0c ("iio: imu: add Bosch Sensortec BNO055 core driver")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/bno055/bno055.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/imu/bno055/bno055.c b/drivers/iio/imu/bno055/bno055.c
index 303bc308f80a8..c96fec2ebb3e7 100644
--- a/drivers/iio/imu/bno055/bno055.c
+++ b/drivers/iio/imu/bno055/bno055.c
@@ -64,7 +64,7 @@
 #define BNO055_GRAVITY_DATA_X_LSB_REG	0x2E
 #define BNO055_GRAVITY_DATA_Y_LSB_REG	0x30
 #define BNO055_GRAVITY_DATA_Z_LSB_REG	0x32
-#define BNO055_SCAN_CH_COUNT ((BNO055_GRAVITY_DATA_Z_LSB_REG - BNO055_ACC_DATA_X_LSB_REG) / 2)
+#define BNO055_SCAN_CH_COUNT ((BNO055_GRAVITY_DATA_Z_LSB_REG - BNO055_ACC_DATA_X_LSB_REG) / 2 + 1)
 #define BNO055_TEMP_REG			0x34
 #define BNO055_CALIB_STAT_REG		0x35
 #define BNO055_CALIB_STAT_MAGN_SHIFT 0
-- 
2.53.0



