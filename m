Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C83280CFB;
	Mon, 13 Apr 2026 16:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098277; cv=none; b=l+lf0kbcQVQmerkHhHHbTDjLm2ggZtzFyN54oHLtqkgneTE3RImOFXQsT/uufZISMW2CZNB+6+k7aXYo41vytgxhbwXSmbGvlPET9rQSkHk+okqZCgMxmwAHmpDMHxfjEOxIl3UyPnToEbNmDjwwexUJDZnrXxIqWtaH8MOrAJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098277; c=relaxed/simple;
	bh=2j6dpI2Mbw9wnyttVPQqwZL5/uMmdzADQHpDqouLlbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WSt999CpVL92lrC3f8m9HiPkLG43Id7SLcGFTU4/AZhWRTk+AKDWZAloaUzrGLxtfUSjRR3xrqY6y37UHmOfGAfIjk7CoxdqXQBKlLwPftnjw1FR9JfdN+TD6kWs3LXNi63D4PHLeZs4+DWkkvVcN+fmCMkDChQADurjH69a/tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SoFrQGnF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SoFrQGnF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEEB4C2BCAF;
	Mon, 13 Apr 2026 16:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098277;
	bh=2j6dpI2Mbw9wnyttVPQqwZL5/uMmdzADQHpDqouLlbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SoFrQGnF35eZchLK8p4BknGbfIOUQIF9oj/pce0FuzyF6+C9Evk6Z8fUW6LtVMQcZ
	 xT5j0zlUFBFzleqvhnXViianBcjnYjhXNqcsBn9UridVck4Dl7WD1Mw+ZPhMN7rrhy
	 LsQCvXf6qrvkj0r/2eaBWhvZW0EUGMp7uYSxi91w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 462/570] iio: gyro: mpu3050: Fix incorrect free_irq() variable
Date: Mon, 13 Apr 2026 17:59:53 +0200
Message-ID: <20260413155847.777056942@linuxfoundation.org>
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
@@ -1282,7 +1282,7 @@ int mpu3050_common_remove(struct device
 	pm_runtime_disable(dev);
 	iio_triggered_buffer_cleanup(indio_dev);
 	if (mpu3050->irq)
-		free_irq(mpu3050->irq, mpu3050);
+		free_irq(mpu3050->irq, mpu3050->trig);
 	iio_device_unregister(indio_dev);
 	mpu3050_power_down(mpu3050);
 


