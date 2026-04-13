Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E44131E857;
	Mon, 13 Apr 2026 16:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099571; cv=none; b=J6ZNCxPdslwYlZhfl6xvyB1TFmSjwIBPXaivVZLmCTI9MwHbz/aD1qRd2F4a07EKdRuf6ckPA28ZgvBJ16A7oAq+sn7BmQtpJlAtAH4ojKOzgTdlRJFqbqdkObA3zObW+csXS54QDyKOVxqc0OeyXiqcNV4UvfaOQdSA6hyGTiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099571; c=relaxed/simple;
	bh=FiY1f6Lnx7wz0X2xHOSfMSoyrfoGFwtoZzEtfBpjLcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PifVZahO3HAOMchVhM5uQOUE/oA96tlhqE7HPy2TADQp+srj5k152uB/rgkCGfLJwX/2U2QenL9B+l8sgDbRg+EDJUnU2WptFESi02QWXn9sH+klVY8l31XauGqcgbLLF6318+KxixFUDheBNr5KQzVg/lTuL+QFpvObjhUWzog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZXZX4Wqa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZXZX4Wqa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9683C2BCB0;
	Mon, 13 Apr 2026 16:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099571;
	bh=FiY1f6Lnx7wz0X2xHOSfMSoyrfoGFwtoZzEtfBpjLcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZXZX4WqaWetaPrm7LRw5CJLJmlBuH30dizmjNIpzr0GmJwhKkEVf6c0iGzF1EbauD
	 Ujgwu3EfevQnPeRN9ObUTxOonzbO3z8Wg3VDkWpYUS4ZiezURl3r3dzWxHeLsFaB2I
	 rDB6xltw1A85tg/U+O8xHM2loxQlW3VYKtTAelpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 384/491] iio: gyro: mpu3050: Fix irq resource leak
Date: Mon, 13 Apr 2026 18:00:29 +0200
Message-ID: <20260413155833.409281996@linuxfoundation.org>
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

commit 4216db1043a3be72ef9c2b7b9f393d7fa72496e6 upstream.

The interrupt handler is setup but only a few lines down if
iio_trigger_register() fails the function returns without properly
releasing the handler.

Add cleanup goto to resolve resource leak.

Detected by Smatch:
drivers/iio/gyro/mpu3050-core.c:1128 mpu3050_trigger_probe() warn:
'irq' from request_threaded_irq() not released on lines: 1124.

Fixes: 3904b28efb2c7 ("iio: gyro: Add driver for the MPU-3050 gyroscope")
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/gyro/mpu3050-core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/iio/gyro/mpu3050-core.c
+++ b/drivers/iio/gyro/mpu3050-core.c
@@ -1137,11 +1137,16 @@ static int mpu3050_trigger_probe(struct
 
 	ret = iio_trigger_register(mpu3050->trig);
 	if (ret)
-		return ret;
+		goto err_iio_trigger;
 
 	indio_dev->trig = iio_trigger_get(mpu3050->trig);
 
 	return 0;
+
+err_iio_trigger:
+	free_irq(mpu3050->irq, mpu3050->trig);
+
+	return ret;
 }
 
 int mpu3050_common_probe(struct device *dev,


