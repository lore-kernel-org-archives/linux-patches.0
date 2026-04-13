Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380AD349AEC;
	Mon, 13 Apr 2026 17:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099661; cv=none; b=mXpup7fEyz9qnvshkWDyJu6TUVx/x51gXBdV9mG2zcukVmHXJ0PbN+nTBNbAx6ETRxUGdhYPU04BnY/vx5dy99gfpgQJELsJhuaQVtL4uC5yhbOS9N8XjUezlUmMSvbjdsvE9/fi8qXezQOzraDmUdY3mRBbsWTva6a5a1o53Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099661; c=relaxed/simple;
	bh=x5+7SXOGswhPogzrZzLOwzbYaj1/9eOsM4U8ZQPVdUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JhHqB0ybbCmv1Igjg52VAw2KZc4fGWJtfqhfxe+vrneM6+72a3ZQPHiGGBjATNPjDaVNoXmHd9raBqt+Ex2/y/0RJe52oeLfFTxGkDxbvjGtxj/LozWLMfFVtZmvIuVMWQi55qEXMaW9pi683Vf/inxxw8vPHqZkKMA5HA/pM04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BpqMIFyq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BpqMIFyq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DC1C2BCB3;
	Mon, 13 Apr 2026 17:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099661;
	bh=x5+7SXOGswhPogzrZzLOwzbYaj1/9eOsM4U8ZQPVdUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BpqMIFyqG3ZJuF7kXzMIiuFMjpPEjCi6k+j4aTyx3CHbmv/vQn/ZGEWiuwVsoDLBw
	 ut2UdhJi6+gIyvYD77DcshpqiZ5iuu9989H6qni1Qaid2TpJfOvfLxrYmyrBlKYvwx
	 LIadcPm4x1cCFRR77cKDKT4QtqFkNxGQOfRtSLBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 383/491] iio: gyro: mpu3050: Fix incorrect free_irq() variable
Date: Mon, 13 Apr 2026 18:00:28 +0200
Message-ID: <20260413155833.372201331@linuxfoundation.org>
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
@@ -1278,7 +1278,7 @@ int mpu3050_common_remove(struct device
 	pm_runtime_disable(dev);
 	iio_triggered_buffer_cleanup(indio_dev);
 	if (mpu3050->irq)
-		free_irq(mpu3050->irq, mpu3050);
+		free_irq(mpu3050->irq, mpu3050->trig);
 	iio_device_unregister(indio_dev);
 	mpu3050_power_down(mpu3050);
 


