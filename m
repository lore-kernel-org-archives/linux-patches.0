Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B1F330B01;
	Mon, 13 Apr 2026 16:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099599; cv=none; b=opGJ4wOXgQPl3L2InyEXcU0Yr3D4CjKawXBbTj40fe8vs/XLexBOaGvvSKVuOpwPrRcNPr5nYI/GmBeSKHLa+KwIGv9ybf5Xo6ZyiK5GNFK+oNYrUHvn2UZmxqpBw+WgheLBHF43bZ0H/wR0QgYw7qGqjZqNpzDh5dKNkx00NDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099599; c=relaxed/simple;
	bh=7dhFDNb866NW0IqUmXCPi0VDlO0QoZIqJfJujCxYe6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NApg1RsgKDHjNdJniboJlu8rBK1LIku2nAK5jtFri3hVhsnwRyfN5ekCNauj4soos74fAqYBgQtQyx2SluQYQsvRY7gqk4COm5tG8kOJYayjshO34lg5Awvavt/zJTmvsXr6j3xoU6mPaRtc2askX+afDlYR/Xal7vey6mO0sG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MAIlwsGM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MAIlwsGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05148C2BCB3;
	Mon, 13 Apr 2026 16:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099599;
	bh=7dhFDNb866NW0IqUmXCPi0VDlO0QoZIqJfJujCxYe6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MAIlwsGMwoDUZOzeI85vcU3xq2pymLypVcJGsS5h9mk/jU4derWhSpi8OVVMQQ1Xf
	 ZlmuLdtNjXrkdZlIuaWdq58egL0fd8QZCnPqURu3KBCw1dTKr/7uPiMzhUgIXgf+k9
	 mULqjgv415yeQ/PZUjRctrgkgDSq8iZgZAws2tcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <jic23@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 385/491] iio: gyro: mpu3050: Move iio_device_register() to correct location
Date: Mon, 13 Apr 2026 18:00:30 +0200
Message-ID: <20260413155833.446738709@linuxfoundation.org>
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

From: Ethan Tidmore <ethantidmore06@gmail.com>

commit 4c05799449108fb0e0a6bd30e65fffc71e60db4d upstream.

iio_device_register() should be at the end of the probe function to
prevent race conditions.

Place iio_device_register() at the end of the probe function and place
iio_device_unregister() accordingly.

Fixes: 3904b28efb2c7 ("iio: gyro: Add driver for the MPU-3050 gyroscope")
Suggested-by: Jonathan Cameron <jic23@kernel.org>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/gyro/mpu3050-core.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/drivers/iio/gyro/mpu3050-core.c
+++ b/drivers/iio/gyro/mpu3050-core.c
@@ -1234,12 +1234,6 @@ int mpu3050_common_probe(struct device *
 		goto err_power_down;
 	}
 
-	ret = iio_device_register(indio_dev);
-	if (ret) {
-		dev_err(dev, "device register failed\n");
-		goto err_cleanup_buffer;
-	}
-
 	dev_set_drvdata(dev, indio_dev);
 
 	/* Check if we have an assigned IRQ to use as trigger */
@@ -1262,9 +1256,20 @@ int mpu3050_common_probe(struct device *
 	pm_runtime_use_autosuspend(dev);
 	pm_runtime_put(dev);
 
+	ret = iio_device_register(indio_dev);
+	if (ret) {
+		dev_err(dev, "device register failed\n");
+		goto err_iio_device_register;
+	}
+
 	return 0;
 
-err_cleanup_buffer:
+err_iio_device_register:
+	pm_runtime_get_sync(dev);
+	pm_runtime_put_noidle(dev);
+	pm_runtime_disable(dev);
+	if (irq)
+		free_irq(mpu3050->irq, mpu3050->trig);
 	iio_triggered_buffer_cleanup(indio_dev);
 err_power_down:
 	mpu3050_power_down(mpu3050);
@@ -1278,13 +1283,13 @@ int mpu3050_common_remove(struct device
 	struct iio_dev *indio_dev = dev_get_drvdata(dev);
 	struct mpu3050 *mpu3050 = iio_priv(indio_dev);
 
+	iio_device_unregister(indio_dev);
 	pm_runtime_get_sync(dev);
 	pm_runtime_put_noidle(dev);
 	pm_runtime_disable(dev);
 	iio_triggered_buffer_cleanup(indio_dev);
 	if (mpu3050->irq)
 		free_irq(mpu3050->irq, mpu3050->trig);
-	iio_device_unregister(indio_dev);
 	mpu3050_power_down(mpu3050);
 
 	return 0;


