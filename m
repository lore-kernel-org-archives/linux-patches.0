Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABC640FDAE;
	Wed,  4 Feb 2026 14:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216706; cv=none; b=mOc7A3RlEk8Bm0pr0MNkTid+iWT1kZy8LrolLgJYouhJHgXXhHnvkitvM7Ews6aXro5f3AW2bAFHP+BHcexzMgkSxFSNalBl57f26yLSwMuYY7U5BLmfy+oDN3eppILUHpQP5hz4ngtfcGvEPmXP4MH9BlFaNVNvV6iiF/AkqSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216706; c=relaxed/simple;
	bh=8m7GuHDMpbGjehG3ps+dL6yG55CTW5bM9RT0yq4aElo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCKx+h9WKOwxshqDyi3S/cntWybY2Zq8xtBBa5XX9BYf8H0pU+lpQVGcEXe8zO3NcmXGoZABB61WmjNTC7sGvmZi3AIVdpRCsJt04SGSWV5d+n7trjnKH+JPaQXdSEd1TIDW6gxnGYLQK37Ign5+C4Qk5oFSBotsTN3anfEn5GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ogWu4ntr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ogWu4ntr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC7EC4CEF7;
	Wed,  4 Feb 2026 14:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216706;
	bh=8m7GuHDMpbGjehG3ps+dL6yG55CTW5bM9RT0yq4aElo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ogWu4ntrnStERoyqn0Qex7dFLUwk99KAINjHTHwVj0323F+FvhAh4tmRgBtoTryQa
	 yIEQzfXnke6ADwegBGaQag2oI2yHB7cpBmHy/dSRgmJ61nqJC1HRMICR65dK7TOVGQ
	 zVChRIIO7LTkI2SJUkQlMaleMDE2fNAklMNUUzfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 143/161] iio: adc: exynos_adc: fix OF populate on driver rebind
Date: Wed,  4 Feb 2026 15:40:06 +0100
Message-ID: <20260204143856.892888522@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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
@@ -718,14 +718,7 @@ static const struct iio_chan_spec exynos
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
@@ -924,8 +917,7 @@ static int exynos_adc_probe(struct platf
 	return 0;
 
 err_of_populate:
-	device_for_each_child(&indio_dev->dev, NULL,
-				exynos_adc_remove_devices);
+	of_platform_depopulate(&indio_dev->dev);
 	if (has_ts) {
 		input_unregister_device(info->input);
 		free_irq(info->tsirq, info);
@@ -954,8 +946,7 @@ static int exynos_adc_remove(struct plat
 		free_irq(info->tsirq, info);
 		input_unregister_device(info->input);
 	}
-	device_for_each_child(&indio_dev->dev, NULL,
-				exynos_adc_remove_devices);
+	of_platform_depopulate(&indio_dev->dev);
 	iio_device_unregister(indio_dev);
 	free_irq(info->irq, info);
 	if (info->data->exit_hw)


