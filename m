Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157A331F9BC;
	Mon, 13 Apr 2026 17:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099628; cv=none; b=jmmHv1wn+SFjebaslwFVF4zdlpXWibWaWG/CAhKackP2WgEx0gwO/nfqIkRmBLajciaN5kXqMAcW1mCm+7YuVfgadIekdxwaciVlLBHDqa0w9tLlR+oZmeom84WUZ2JI/CI61BJDTQ+IhtuKAa+FjUx9Aj4ZlgeQ2Fw4ocj7a2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099628; c=relaxed/simple;
	bh=zfsrvGoNZ71KM8U8BLrDRkQB7TH+4fCR/CH5JwiTezc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=orjfJZokvDRgeDXQLFYuP41JP1JO1LS7UuXQVRSrPHx94jJjJ7+1Thjx8A7WdCp4k/EuPrsSf6dPS+gDwlZh8Sn7/YaiY3z0m56ULEtojd8ku7BoH9/UBQzTbVFFat3CL3vXxuKmfgDSZ5sChvBYAO2AQbZ7f3hBopQxo9+tqn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iM+vWDtB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iM+vWDtB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A235CC2BCAF;
	Mon, 13 Apr 2026 17:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099628;
	bh=zfsrvGoNZ71KM8U8BLrDRkQB7TH+4fCR/CH5JwiTezc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iM+vWDtBOLv2qtPtMQNsAVp+1ck2Go9OjKF7x2uaHSnSMeWaPICxkCO7wdcRrOiDT
	 oa29NePoNbi0hLysVzQlVQgf1jCLoRXNSjuc/QRdI3Lgpdqk0yC/jUqmF1OSc5QuRM
	 KK9P/GIhgpDuPRfXL8ghLgDqES6ct4Z7ZnEqJjIk=
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
Subject: [PATCH 5.10 386/491] iio: gyro: mpu3050: Fix out-of-sequence free_irq()
Date: Mon, 13 Apr 2026 18:00:31 +0200
Message-ID: <20260413155833.484238670@linuxfoundation.org>
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

commit d14116f6529fa085b1a1b1f224dc9604e4d2a29c upstream.

The triggered buffer is initialized before the IRQ is requested. The
removal path currently calls iio_triggered_buffer_cleanup() before
free_irq(). This violates the expected LIFO.

Place free_irq() in the correct location relative to
iio_triggered_buffer_cleanup().

Fixes: 3904b28efb2c7 ("iio: gyro: Add driver for the MPU-3050 gyroscope")
Suggested-by: Jonathan Cameron <jic23@kernel.org>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/gyro/mpu3050-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/gyro/mpu3050-core.c
+++ b/drivers/iio/gyro/mpu3050-core.c
@@ -1287,9 +1287,9 @@ int mpu3050_common_remove(struct device
 	pm_runtime_get_sync(dev);
 	pm_runtime_put_noidle(dev);
 	pm_runtime_disable(dev);
-	iio_triggered_buffer_cleanup(indio_dev);
 	if (mpu3050->irq)
 		free_irq(mpu3050->irq, mpu3050->trig);
+	iio_triggered_buffer_cleanup(indio_dev);
 	mpu3050_power_down(mpu3050);
 
 	return 0;


