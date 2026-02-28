Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FB03314C3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301185; cv=none; b=cPlIl9JPabSQ+9nftMJ6zVqCmPYHPbeDc4QISAfMGYkHRQiZJcdEUDtacChN/U+MGxzLoozXqIE2exWKiQUI0Lam/zIzyDizR9lA5oSxYY+DcdEMnIL0XpM69UVAN3XLYGm+Xs39zX7IeYcisjcJeQJDGEEeCsgz03kEJl55HeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301185; c=relaxed/simple;
	bh=f1c3761UCRyf4cWsV3oJHwqJWcKxzIdOUIZpC3Sf0GI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WeiGbusZ7VS8W+DrW1T7AdSgzx5RbMQ4X26BPCSAJtFxsALdgdemJVTmm6ynrDLOKSolD+Kb7g5W1UCVXdJ3l8dmIzALCUHHzP9keXj+we/qbQ9fD+W1ceBXS8EiB8vuIT5Iwku+DHC7UfPrbd1QU07CPk+wLRz4NxkuPgMeSko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TOsV5FXO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TOsV5FXO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132E2C19423;
	Sat, 28 Feb 2026 17:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301185;
	bh=f1c3761UCRyf4cWsV3oJHwqJWcKxzIdOUIZpC3Sf0GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TOsV5FXONvWckDvHq1ajAVwEYcMHkbe79XgMo4CnvG/hJi5Jr/+SOiHuzdKbuVHT0
	 qZyx05MOEdnpUkmufU7P7N1VDs23FhFfFGsW709jtYuRRwCZcDse6nX7lh0wKtZgf8
	 pZ6usCN9voN/03BsJ/eDAvUSYW/DXOYqL7tKAIYhwvlTF93dd246QqTXAo2osbKQ3e
	 nUKsi5m9VqlpiXTXLUeS5MQYzXQB8mT2QorHqzh7lq8zhah+tfgbltRTjh/NJ+HIKl
	 7H+Oun5CFRupfX8CWpuXbabeJX7Cz0SRpma4NBfrg1K52gtsfmvCcF4J+74eixp1e2
	 J0w9aKHG3q5rA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 355/752] iio: Use IRQF_NO_THREAD
Date: Sat, 28 Feb 2026 12:41:06 -0500
Message-ID: <20260228174750.1542406-355-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 04d390af97f2c28166f7ddfe1a6bda622e3a4766 ]

The interrupt handler iio_trigger_generic_data_rdy_poll() will invoke
other interrupt handler and this supposed to happen from within the
hardirq.

Use IRQF_NO_THREAD to forbid forced-threading.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/bma180.c        | 5 +++--
 drivers/iio/adc/ad7766.c          | 2 +-
 drivers/iio/gyro/itg3200_buffer.c | 8 +++-----
 drivers/iio/light/si1145.c        | 2 +-
 4 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/iio/accel/bma180.c b/drivers/iio/accel/bma180.c
index 8925f5279e627..7bc6761f51354 100644
--- a/drivers/iio/accel/bma180.c
+++ b/drivers/iio/accel/bma180.c
@@ -986,8 +986,9 @@ static int bma180_probe(struct i2c_client *client)
 		}
 
 		ret = devm_request_irq(dev, client->irq,
-			iio_trigger_generic_data_rdy_poll, IRQF_TRIGGER_RISING,
-			"bma180_event", data->trig);
+				       iio_trigger_generic_data_rdy_poll,
+				       IRQF_TRIGGER_RISING | IRQF_NO_THREAD,
+				       "bma180_event", data->trig);
 		if (ret) {
 			dev_err(dev, "unable to request IRQ\n");
 			goto err_trigger_free;
diff --git a/drivers/iio/adc/ad7766.c b/drivers/iio/adc/ad7766.c
index 4d570383ef025..1e6bfe8765ab3 100644
--- a/drivers/iio/adc/ad7766.c
+++ b/drivers/iio/adc/ad7766.c
@@ -261,7 +261,7 @@ static int ad7766_probe(struct spi_device *spi)
 		 * don't enable the interrupt to avoid extra load on the system
 		 */
 		ret = devm_request_irq(&spi->dev, spi->irq, ad7766_irq,
-				       IRQF_TRIGGER_FALLING | IRQF_NO_AUTOEN,
+				       IRQF_TRIGGER_FALLING | IRQF_NO_AUTOEN | IRQF_NO_THREAD,
 				       dev_name(&spi->dev),
 				       ad7766->trig);
 		if (ret < 0)
diff --git a/drivers/iio/gyro/itg3200_buffer.c b/drivers/iio/gyro/itg3200_buffer.c
index a624400a239cb..cf97adfa97274 100644
--- a/drivers/iio/gyro/itg3200_buffer.c
+++ b/drivers/iio/gyro/itg3200_buffer.c
@@ -118,11 +118,9 @@ int itg3200_probe_trigger(struct iio_dev *indio_dev)
 	if (!st->trig)
 		return -ENOMEM;
 
-	ret = request_irq(st->i2c->irq,
-			  &iio_trigger_generic_data_rdy_poll,
-			  IRQF_TRIGGER_RISING,
-			  "itg3200_data_rdy",
-			  st->trig);
+	ret = request_irq(st->i2c->irq, &iio_trigger_generic_data_rdy_poll,
+			  IRQF_TRIGGER_RISING | IRQF_NO_THREAD,
+			  "itg3200_data_rdy", st->trig);
 	if (ret)
 		goto error_free_trig;
 
diff --git a/drivers/iio/light/si1145.c b/drivers/iio/light/si1145.c
index f8eb251eca8dc..ef0abc4499b74 100644
--- a/drivers/iio/light/si1145.c
+++ b/drivers/iio/light/si1145.c
@@ -1248,7 +1248,7 @@ static int si1145_probe_trigger(struct iio_dev *indio_dev)
 
 	ret = devm_request_irq(&client->dev, client->irq,
 			  iio_trigger_generic_data_rdy_poll,
-			  IRQF_TRIGGER_FALLING,
+			  IRQF_TRIGGER_FALLING | IRQF_NO_THREAD,
 			  "si1145_irq",
 			  trig);
 	if (ret < 0) {
-- 
2.51.0

