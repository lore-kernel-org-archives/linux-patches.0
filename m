Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C0C30C360;
	Mon, 13 Apr 2026 16:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098282; cv=none; b=r1irKn3CiEM8vA7a1F6JA1BBdwjZ1zPGqoc/XOMB5dmnaSsqiTixcC3qbiDqTZF5u7AED2yA1M+HRa/kEjW0CfHJP89ew4HlUTAJWOKycmQoxbaUivmCUn0dDFRkT38G7QrQ5mfXiy4DjFdwuwOPMFUVZiY15WdsaD9q1/81Cs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098282; c=relaxed/simple;
	bh=4okYdYoFegQOZoyq/oWFH3jZoITFdH2y07dBNwSY6b8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJdXxp4lIOZVLpTnfCdXRSSV1iUhPbyskvmIdbPybF6U0XNFlKMGilVl4rpLFKbvbagQth48z8efA9pP41TQbkSfMt2vD8YwHN9iTUOYC1QQsweHE47+9YH2AV7JfE2YBYBi/VUhSdGFK/Ja14hba9hBwIv/hdPE+/kWvrsGrIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=drPVFTSd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="drPVFTSd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F87BC2BCAF;
	Mon, 13 Apr 2026 16:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098282;
	bh=4okYdYoFegQOZoyq/oWFH3jZoITFdH2y07dBNwSY6b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=drPVFTSdAy9aSb7A0wY4h7AerWke5Ht8S4sVuuiBDdanKtjS3jFQZWeaNjiYNa0ho
	 dA3nyhqQSW1vGKVkwV3ehB9GnyRTZwWuhlFmegWa6nT/oCDrL+/b3Obugfw3qUDDZH
	 Ev8hP8dEh61VyJ4ds6YMWaXvG9lywwd6mojliQqs=
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
Subject: [PATCH 5.15 464/570] iio: gyro: mpu3050: Move iio_device_register() to correct location
Date: Mon, 13 Apr 2026 17:59:55 +0200
Message-ID: <20260413155847.850596975@linuxfoundation.org>
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
@@ -1238,12 +1238,6 @@ int mpu3050_common_probe(struct device *
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
@@ -1266,9 +1260,20 @@ int mpu3050_common_probe(struct device *
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
@@ -1282,13 +1287,13 @@ int mpu3050_common_remove(struct device
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


