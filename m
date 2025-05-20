Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE0F1A08DF;
	Tue, 20 May 2025 14:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750559; cv=none; b=JTiGRoGWOum7TiuHQ74kOrlz/rwu7tZsFyg0smNeDCmsRuhCRCwKHDDqDhXzMcLVPHCliqPNeW6qR8wERIQQcAXS1Y0oHPKRMjH0cJuIXVbJEVmfxnG3SMrn/ITtymHwtwx5Mk1pKvEPnW+gOX25cKEdArKAdmDCCzggqaZIoZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750559; c=relaxed/simple;
	bh=xMLYj0o4f+dpedmnMi1rdm+0koh+BX1nabav4SSn0cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WUNCpZSOij4ZARLv6oACwmZ6MI9zj+NtyDpw2SmFF9epChIifDEWP2fw32sdYj3qXCmxgIQckCBET8tHhOM1FYVV6dupm++1epNDwPnsuXiKFnT0fSESvq10ojcua5Mw44RTfMrujAyNpWSQHCeAZFGAbvZmBYF3FIJKpeWKR9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zGkPl9uv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zGkPl9uv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F0FC4CEE9;
	Tue, 20 May 2025 14:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750559;
	bh=xMLYj0o4f+dpedmnMi1rdm+0koh+BX1nabav4SSn0cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zGkPl9uvCnITnQQoOwzTQWcG0ftHlOFdH+ZbYUr9xTE1FnUq3InPaKDuxIwKZkwlA
	 74ugYyL7TnbkYXk1BS6ER9DpAPZyRy3D7PNxIJPplxseOTUdb5LdSs8CuTzdCWVq8j
	 Df32PO/74vXKDCxWueJAbvbqBLhQoZ8xyz/dIa/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Stols <gstols@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 017/145] iio: adc: ad7606: move the software mode configuration
Date: Tue, 20 May 2025 15:49:47 +0200
Message-ID: <20250520125811.228953296@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guillaume Stols <gstols@baylibre.com>

[ Upstream commit f2a62931b39478c98f977caf299df5bc072f38e0 ]

This is a preparation for the intoduction of the sofware functions in
the iio backend version of the driver.
The software mode configuration must be executed once the channels are
configured, and the number of channels is known. This is not the case
before iio-backend's configuration is called, and iio backend version of
the driver does not have a timestamp channel.
Also the sw_mode_config callback is configured during the iio-backend
configuration.
For clarity purpose, I moved the entire block instead of just the
concerned function calls.

Signed-off-by: Guillaume Stols <gstols@baylibre.com>
Link: https://patch.msgid.link/20250210-wip-bl-ad7606_add_backend_sw_mode-v4-2-160df18b1da7@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 5257d80e22bf ("iio: adc: ad7606: check for NULL before calling sw_mode_config()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7606.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/iio/adc/ad7606.c b/drivers/iio/adc/ad7606.c
index d39354afd5394..376c808df11c7 100644
--- a/drivers/iio/adc/ad7606.c
+++ b/drivers/iio/adc/ad7606.c
@@ -1246,17 +1246,6 @@ int ad7606_probe(struct device *dev, int irq, void __iomem *base_address,
 			return -ERESTARTSYS;
 	}
 
-	st->write_scale = ad7606_write_scale_hw;
-	st->write_os = ad7606_write_os_hw;
-
-	ret = ad7606_sw_mode_setup(indio_dev);
-	if (ret)
-		return ret;
-
-	ret = ad7606_chan_scales_setup(indio_dev);
-	if (ret)
-		return ret;
-
 	/* If convst pin is not defined, setup PWM. */
 	if (!st->gpio_convst) {
 		st->cnvst_pwm = devm_pwm_get(dev, NULL);
@@ -1334,6 +1323,17 @@ int ad7606_probe(struct device *dev, int irq, void __iomem *base_address,
 			return ret;
 	}
 
+	st->write_scale = ad7606_write_scale_hw;
+	st->write_os = ad7606_write_os_hw;
+
+	ret = ad7606_sw_mode_setup(indio_dev);
+	if (ret)
+		return ret;
+
+	ret = ad7606_chan_scales_setup(indio_dev);
+	if (ret)
+		return ret;
+
 	return devm_iio_device_register(dev, indio_dev);
 }
 EXPORT_SYMBOL_NS_GPL(ad7606_probe, "IIO_AD7606");
-- 
2.39.5



