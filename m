Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6885019DFAB;
	Wed,  4 Feb 2026 15:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217224; cv=none; b=bfLGBTIkC8GOTHYilaDyaZHEfyd7acb0LAjYggsJVBjVRxFZ3sMPB8U4kVQwPgLUmVnqTPy8pyaaAKuyrj9JklqFVaRL03gbnSj/E1VlwFUbZO29CU7YRJdZDIgBJga0i85hW7cpRuM1W1iBAjg6GyUA8RUptZjHGiiNDn1vF7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217224; c=relaxed/simple;
	bh=Zd81Z3dEdXHZkMQnZUW3i1OHPleCd7KlK+lA/kd5IEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4f61rGNYYVC8dMcgdMY1WDo6GNcTZNItLVUwrdPlWzYnuTrMwxi57RbMFzPCX3uVmnhih0bJ2zHLD5SzZ05+yY+VAlcSiOQQ9DxuhTUxQqIuR6OLGlZyinhFsHj1vfCaPg42CbM2ms48m2V75u8cm9rOMBE9z5mveOfAj3TM3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vvd/XAzb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vvd/XAzb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E444AC116C6;
	Wed,  4 Feb 2026 15:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217224;
	bh=Zd81Z3dEdXHZkMQnZUW3i1OHPleCd7KlK+lA/kd5IEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vvd/XAzbjJzw/FwhxCtaM+j/fsp10X2M1NCo4WM3jSiNlRc6ilyPSvMrdIHpAs8YS
	 ucmZH/1yRD7svFDd94DXnQavzVA3QNe2feW/8UM6t4p2R0hiXmbwRTAVoetAbKIhB+
	 6zm90869LN4PVxXJJMFUSQvt0KxZYAOn1bIr5398=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 159/206] iio: adc: exynos_adc: fix OF populate on driver rebind
Date: Wed,  4 Feb 2026 15:39:50 +0100
Message-ID: <20260204143903.930128291@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit ea6b4feba85e996e840e0b661bc42793df6eb701 ]

Since commit c6e126de43e7 ("of: Keep track of populated platform
devices") child devices will not be created by of_platform_populate()
if the devices had previously been deregistered individually so that the
OF_POPULATED flag is still set in the corresponding OF nodes.

Switch to using of_platform_depopulate() instead of open coding so that
the child devices are created if the driver is rebound.

Fixes: c6e126de43e7 ("of: Keep track of populated platform devices")
Cc: stable@vger.kernel.org	# 3.16
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/exynos_adc.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -721,14 +721,7 @@ static const struct iio_chan_spec exynos
 	ADC_CHANNEL(9, "adc9"),
 };
 
-static int exynos_adc_remove_devices(struct device *dev, void *c)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-
-	platform_device_unregister(pdev);
 
-	return 0;
-}
 
 static int exynos_adc_ts_open(struct input_dev *dev)
 {
@@ -929,8 +922,7 @@ static int exynos_adc_probe(struct platf
 	return 0;
 
 err_of_populate:
-	device_for_each_child(&indio_dev->dev, NULL,
-				exynos_adc_remove_devices);
+	of_platform_depopulate(&indio_dev->dev);
 	if (has_ts) {
 		input_unregister_device(info->input);
 		free_irq(info->tsirq, info);
@@ -959,8 +951,7 @@ static int exynos_adc_remove(struct plat
 		free_irq(info->tsirq, info);
 		input_unregister_device(info->input);
 	}
-	device_for_each_child(&indio_dev->dev, NULL,
-				exynos_adc_remove_devices);
+	of_platform_depopulate(&indio_dev->dev);
 	iio_device_unregister(indio_dev);
 	free_irq(info->irq, info);
 	if (info->data->exit_hw)


