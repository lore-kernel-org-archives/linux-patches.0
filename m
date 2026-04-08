Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB283D648A;
	Wed,  8 Apr 2026 18:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674783; cv=none; b=J1cXHDfk7PNoAMukeSBi0qWm3oKt7onMnXxYgxxXwM8WWUaSy5XUwU5XrVAP/efDQBHEHfz8Z7WJO3LX229aPMJvxIqyinzYz8gR4O4YGDGcgtHvTs9Sn+lPS9WVPZpNE1P9LK1n8CUUwM6yp+NwaR30hkcOtCj+tTdF+Rczmfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674783; c=relaxed/simple;
	bh=NRU9B18qaH7tdoiyL/MN2X42iKMXNy0ZSWAtfI2F01U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o0fykZt7t3gGqxQIdNMYZzlxWKDY4TytH9iwWURFYnoaQZe6XADthxEVMtlkc0h0t+cHnorMUu8NjpZRjFyvV4+wt2Zew8yFgcWO/zVQ2Kchb00Oh107j/IAyarYNS1JsmFuCyI+poTsfJ4dkj2ECkii60VnzxIf758SWdwK+h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IjzuVcDo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IjzuVcDo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49A9C19421;
	Wed,  8 Apr 2026 18:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674783;
	bh=NRU9B18qaH7tdoiyL/MN2X42iKMXNy0ZSWAtfI2F01U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IjzuVcDo2gOACU5S+GI0gov4V25o0PEqg3GFGKKCxxzNbWIVzDIyiTMsyXKcXnqbo
	 Xx8wyZr1JOMttij3gC4gk/L6UL7tV0MfrjJs3bNCAdLfjTwC+q8dmsm62KzIwuDitq
	 AQbrXeiP4rUC9Wo4vXbxvX4xhFJn/5KOMTbvWqWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.19 231/311] iio: gyro: mpu3050: Fix incorrect free_irq() variable
Date: Wed,  8 Apr 2026 20:03:51 +0200
Message-ID: <20260408175948.022743055@linuxfoundation.org>
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

From: Ethan Tidmore <ethantidmore06@gmail.com>

commit edb11a1aef4011a4b7b22cc3c3396c6fe371f4a6 upstream.

The handler for the IRQ part of this driver is mpu3050->trig but,
in the teardown free_irq() is called with handler mpu3050.

Use correct IRQ handler when calling free_irq().

Fixes: 3904b28efb2c7 ("iio: gyro: Add driver for the MPU-3050 gyroscope")
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
@@ -1269,7 +1269,7 @@ void mpu3050_common_remove(struct device
 	pm_runtime_disable(dev);
 	iio_triggered_buffer_cleanup(indio_dev);
 	if (mpu3050->irq)
-		free_irq(mpu3050->irq, mpu3050);
+		free_irq(mpu3050->irq, mpu3050->trig);
 	iio_device_unregister(indio_dev);
 	mpu3050_power_down(mpu3050);
 }


