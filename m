Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A90288C22;
	Wed, 28 Jan 2026 15:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615418; cv=none; b=Ju873JVVQLOealQ/0Tt3LcEGqNPqdHqa7q6oFam2zKvnhA6KLcVf7CtDFejFELewqlj72xxx5kxYf3s63T8ygeUV5BK0ARN9ZjmZ9T/z24i250MRJvv8ilGb0oRLO6YhQ9avV01WAVh2QTErJHzRdnfiqUS2TJVDElY5o5rJr2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615418; c=relaxed/simple;
	bh=SSFAXm3+tsyLDsmv5IoNkCtzXpwgkt/h5lRKINbtZWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AtRj17SawtOKvRaIpFjYHnjZEmpxDSamxN3ncmcnCtRu3/LZXW7//LeYCd7zRba/DCny8BnElrTSujcQsg1LbYQQb4SicHlkpkRuDILxoTq6Bth/zE7s7OwRby5lTOb0BvR7nFgwz3At+9lVmhkKWfnksXS0gIZQGi9vEUY/wLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cLT+vNC8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cLT+vNC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71091C4CEF1;
	Wed, 28 Jan 2026 15:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615417;
	bh=SSFAXm3+tsyLDsmv5IoNkCtzXpwgkt/h5lRKINbtZWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cLT+vNC8ejYna9OZ9xk2HM2jbg4N8tTtYTFer/mFoKhBPfljBM/MUm/bph2r0QeTD
	 EJhMktjZP3EXRkgXzVSV8VXkGfg5y0aVE/yUFoEBO89ItvXplGgL3O4lVn3DH9zETq
	 QQ3iJ+bbB56s2hi9aVe6bpNVmzfIlJkoKfDFFskg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 155/169] iio: adc: exynos_adc: fix OF populate on driver rebind
Date: Wed, 28 Jan 2026 16:23:58 +0100
Message-ID: <20260128145339.587938147@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -959,8 +951,7 @@ static void exynos_adc_remove(struct pla
 		free_irq(info->tsirq, info);
 		input_unregister_device(info->input);
 	}
-	device_for_each_child(&indio_dev->dev, NULL,
-				exynos_adc_remove_devices);
+	of_platform_depopulate(&indio_dev->dev);
 	iio_device_unregister(indio_dev);
 	free_irq(info->irq, info);
 	if (info->data->exit_hw)


