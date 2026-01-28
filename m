Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECFC2DE1E4;
	Wed, 28 Jan 2026 15:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614757; cv=none; b=V89ZDKCwU4EbgBCoqMAheuc8oasN3yovMmbDEXwgDC/C2mvE++w4v5b7iXEm3DBojV4lsKeYHt/qPQYbA5T7bLApyG7B0TdMIrb0kU/vwOVlwwHrhzoITnTM0ak9+M2SrOTcUe8PnR+M9T7WmrSrlUBW9AwPQ4ZOygmfTJxcmG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614757; c=relaxed/simple;
	bh=7StxKRwwJgDmfX3uNum2BW9KF1IDAG1zSn5euXBKmO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bRca0VssHYZWEc2ID89jVatkAMJvqNr5vVPyVo64/sIjDwoCIXbGCpftbYNlh2F5Yk4atrarEjvhE2Ft5ECqZoIAZPvziTTHTFYXJhAe9wc0Hpe5ZTdxJMKS2rW9Vm7nH+X5MGHDGjmrPZD2HwsNt1pPgXo3lUlrrjLH/Xzc/xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GqsVJO+a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GqsVJO+a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3CD4C4CEF1;
	Wed, 28 Jan 2026 15:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614757;
	bh=7StxKRwwJgDmfX3uNum2BW9KF1IDAG1zSn5euXBKmO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GqsVJO+aGxBI+K95tZgm0ULcIhGAz8mdHOyPyBOOwG3SprneV50AmtvZiHr2nXC+I
	 PhesJRJFYxICO+06zURCPSMSbpIaJEyY92rHL4lXxivIiAxwCyzmsC2YcnqWZWd80m
	 b4U7Fw7QWnK9DDDq42Ux2S8CSO/UzVWAUuyR13eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 232/254] iio: adc: exynos_adc: fix OF populate on driver rebind
Date: Wed, 28 Jan 2026 16:23:28 +0100
Message-ID: <20260128145353.137607277@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


