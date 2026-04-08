Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DE937F01B;
	Wed,  8 Apr 2026 18:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672214; cv=none; b=A3YsqqTgwnUDmhLLghsX/uDExwQxsJ1wHX2Db3HlWo54hrUoTwLdnH63VMrZGm6bE3UtGgqwwYTAlGL09zTpeMbnjV2YtaQIqODC4Gx9VQwBPf/ieWCBRNnF3X9rxTtaYkc7ksxGo4sR8H0x3bDn/6mQHfRqHSqQGd/6Awuw1Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672214; c=relaxed/simple;
	bh=qeAk/PUrlojqxR+bBXUvAMmDrxsDzl9u9WnPz59oGtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=minMvQuow3WWOSJR0YAYpAlSHJ720QXaoSaxCwSR/bs6V2TbGgX62Ni0J/6EvZjQ6DoQZTzh6C216t8lLxWBEqn0VOEAtjDUOhtFklBlujoSdD6w3Vl5/GNBtJf58CsYXNrJryrnSoa0AQc9epi8/7vJ6LQyBvrju72RF7IST1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XfUSuMKt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XfUSuMKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63677C19421;
	Wed,  8 Apr 2026 18:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672213;
	bh=qeAk/PUrlojqxR+bBXUvAMmDrxsDzl9u9WnPz59oGtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XfUSuMKtgrjJCwFHIWQncBlLkb73Jk5vOJWoEeCaGZ8hZA5Un1dKPSTYvZ1CeJBkc
	 OzLaeTY9sb9eTxk9Qdc2QozlmKSZNLxCYsqcmxWpGHApeXq24o9Yb5CplT4g3JipsT
	 OOg7vMgf81o9U3ypFCPFHieeJN6fVtiLYErD/5vI=
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
Subject: [PATCH 6.1 226/312] iio: gyro: mpu3050: Fix out-of-sequence free_irq()
Date: Wed,  8 Apr 2026 20:02:23 +0200
Message-ID: <20260408175942.197418911@linuxfoundation.org>
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
@@ -1288,9 +1288,9 @@ void mpu3050_common_remove(struct device
 	pm_runtime_get_sync(dev);
 	pm_runtime_put_noidle(dev);
 	pm_runtime_disable(dev);
-	iio_triggered_buffer_cleanup(indio_dev);
 	if (mpu3050->irq)
 		free_irq(mpu3050->irq, mpu3050->trig);
+	iio_triggered_buffer_cleanup(indio_dev);
 	mpu3050_power_down(mpu3050);
 }
 


