Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640D5B67E;
	Wed,  8 Apr 2026 18:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672304; cv=none; b=Js2rvjnPcYqpNnnj4NWkE7InubpQuuBCXHw51R2OrYKyRNRIrpwMwR7Rs9r53MitWj85K+ISOED4gLpcZpBhKLFPTK4ksAXC5AvPmoPJ0fZKAoKAzRfuqy8beCGpaUQOXKfjquYauexTTcNT0oEW9bikLeQ8+2k9nnHJkPPFOWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672304; c=relaxed/simple;
	bh=m7gX5TpwNjzM9owcYuXhNRvc5jrSL/EN56yrIktUkiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M3BGZtylG/wcvDXDPHjvy/RPxVp2ixk8IYRUdAp2laWMUpj3e81dBoe4G22SZKfQ0psA22krUAO+WdK1MptFsEKsLU5sVGHZQwYD2BeHj4hQPU4rzlLuGwIPYrYb0xZNJ8URS5LrZlX3h0lqrNysIBemFjBIMNMwd4W3+7QgmmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PMwpH1WU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PMwpH1WU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE52C19421;
	Wed,  8 Apr 2026 18:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672304;
	bh=m7gX5TpwNjzM9owcYuXhNRvc5jrSL/EN56yrIktUkiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PMwpH1WUT9A2QCpU/U+IOsiC3mbuVz8CJ6CF2g87iEJyHjIxgD+TlEBRupxgu4FCv
	 qYSDtheMdeX9slYcFblcfC13x5t6jCivxuPo4PSPnnEDfaa0109DZXu6apnqesagUA
	 qMqk13VnBTzckUJHw0Pv3BMWm34dt+hiv6Q3Otvs=
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
Subject: [PATCH 6.1 225/312] iio: gyro: mpu3050: Move iio_device_register() to correct location
Date: Wed,  8 Apr 2026 20:02:22 +0200
Message-ID: <20260408175942.160134050@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1236,12 +1236,6 @@ int mpu3050_common_probe(struct device *
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
@@ -1264,9 +1258,20 @@ int mpu3050_common_probe(struct device *
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
@@ -1279,13 +1284,13 @@ void mpu3050_common_remove(struct device
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
 }
 


