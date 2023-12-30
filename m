Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280F88486;
	Sat, 30 Dec 2023 12:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EDficBku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51F6C433C8;
	Sat, 30 Dec 2023 12:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937865;
	bh=8g1oG2qAlwuVCBjzdjw0nNzfml/oUtKf17VNEbkazgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EDficBkuxwPscesPh3+qY/wOSugXm5W7HbMrgFz+fsfRDaaaxKcbes8RxDN8TSzwZ
	 DR/jsNQY3WvLYyTSsUoWl+wMrsem2sBRX8VWOFMvxYf1wuSabjMu/MNaB6mewlbUwT
	 cyIJNNiYmUsMevF7t2VJzLN7HuQg421cIIsz4aVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wadim Egorov <w.egorov@phytec.de>,
	Bhavya Kapoor <b-kapoor@ti.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 093/156] iio: adc: ti_am335x_adc: Fix return value check of tiadc_request_dma()
Date: Sat, 30 Dec 2023 11:59:07 +0000
Message-ID: <20231230115815.400584291@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Wadim Egorov <w.egorov@phytec.de>

commit 60576e84c187043cef11f11d015249e71151d35a upstream.

Fix wrong handling of a DMA request where the probing only failed
if -EPROPE_DEFER was returned. Instead, let us fail if a non -ENODEV
value is returned. This makes DMAs explicitly optional. Even if the
DMA request is unsuccessfully, the ADC can still work properly.
We do also handle the defer probe case by making use of dev_err_probe().

Fixes: f438b9da75eb ("drivers: iio: ti_am335x_adc: add dma support")
Signed-off-by: Wadim Egorov <w.egorov@phytec.de>
Reviewed-by: Bhavya Kapoor <b-kapoor@ti.com>
Link: https://lore.kernel.org/r/20230925134427.214556-1-w.egorov@phytec.de
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti_am335x_adc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -670,8 +670,10 @@ static int tiadc_probe(struct platform_d
 	platform_set_drvdata(pdev, indio_dev);
 
 	err = tiadc_request_dma(pdev, adc_dev);
-	if (err && err == -EPROBE_DEFER)
+	if (err && err != -ENODEV) {
+		dev_err_probe(&pdev->dev, err, "DMA request failed\n");
 		goto err_dma;
+	}
 
 	return 0;
 


