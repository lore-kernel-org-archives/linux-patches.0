Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69259208C0
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dtQZaDU/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89CBC433C7;
	Mon,  6 Nov 2023 13:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277489;
	bh=MmF0wkC/sQP9pfDnMQJV4qDoSmukMSDLfMy9gmMwWjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dtQZaDU/hWtztAMM3kOstBtR4kWoLG2T7G0FIr/Gu9TVPynZt/aYek0UDjepoZiBd
	 GzGaMsRxpBwCwhBXj9x2jj70aLAR2pih9kN2oRH4+9ELA4ige7J9YKohZaXEnwelJp
	 wT/wB8UG/FYkpYUkkJuLCdhWzdCeSpkPoS6eKfsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bgolaszewski@baylibre.com>,
	Anand Ashok Dumbre <anandash@xilinx.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 40/95] iio: adc: xilinx: use helper variable for &pdev->dev
Date: Mon,  6 Nov 2023 14:04:08 +0100
Message-ID: <20231106130306.181058291@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130304.678610325@linuxfoundation.org>
References: <20231106130304.678610325@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

[ Upstream commit 9d8fd2a06a2bcce8eada1bad26cbe0fbfc27cdf4 ]

It's more elegant to use a helper local variable to store the address
of the underlying struct device than to dereference pdev everywhere.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Tested-by: Anand Ashok Dumbre <anandash@xilinx.com>
Reviewed-by: Anand Ashok Dumbre <anandash@xilinx.com>
Link: https://lore.kernel.org/r/20201130142759.28216-2-brgl@bgdev.pl
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 8d6b3ea4d9ea ("iio: adc: xilinx-xadc: Don't clobber preset voltage/temperature thresholds")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/xilinx-xadc-core.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/iio/adc/xilinx-xadc-core.c b/drivers/iio/adc/xilinx-xadc-core.c
index f93c34fe58731..8494eb424b331 100644
--- a/drivers/iio/adc/xilinx-xadc-core.c
+++ b/drivers/iio/adc/xilinx-xadc-core.c
@@ -1186,6 +1186,7 @@ static int xadc_parse_dt(struct iio_dev *indio_dev, struct device_node *np,
 
 static int xadc_probe(struct platform_device *pdev)
 {
+	struct device *dev = &pdev->dev;
 	const struct of_device_id *id;
 	struct iio_dev *indio_dev;
 	unsigned int bipolar_mask;
@@ -1195,10 +1196,10 @@ static int xadc_probe(struct platform_device *pdev)
 	int irq;
 	int i;
 
-	if (!pdev->dev.of_node)
+	if (!dev->of_node)
 		return -ENODEV;
 
-	id = of_match_node(xadc_of_match_table, pdev->dev.of_node);
+	id = of_match_node(xadc_of_match_table, dev->of_node);
 	if (!id)
 		return -EINVAL;
 
@@ -1206,7 +1207,7 @@ static int xadc_probe(struct platform_device *pdev)
 	if (irq <= 0)
 		return -ENXIO;
 
-	indio_dev = devm_iio_device_alloc(&pdev->dev, sizeof(*xadc));
+	indio_dev = devm_iio_device_alloc(dev, sizeof(*xadc));
 	if (!indio_dev)
 		return -ENOMEM;
 
@@ -1226,7 +1227,7 @@ static int xadc_probe(struct platform_device *pdev)
 	indio_dev->modes = INDIO_DIRECT_MODE;
 	indio_dev->info = &xadc_info;
 
-	ret = xadc_parse_dt(indio_dev, pdev->dev.of_node, &conf0);
+	ret = xadc_parse_dt(indio_dev, dev->of_node, &conf0);
 	if (ret)
 		return ret;
 
@@ -1250,7 +1251,7 @@ static int xadc_probe(struct platform_device *pdev)
 		}
 	}
 
-	xadc->clk = devm_clk_get(&pdev->dev, NULL);
+	xadc->clk = devm_clk_get(dev, NULL);
 	if (IS_ERR(xadc->clk)) {
 		ret = PTR_ERR(xadc->clk);
 		goto err_free_samplerate_trigger;
@@ -1276,7 +1277,7 @@ static int xadc_probe(struct platform_device *pdev)
 	}
 
 	ret = request_irq(xadc->irq, xadc->ops->interrupt_handler, 0,
-			dev_name(&pdev->dev), indio_dev);
+			  dev_name(dev), indio_dev);
 	if (ret)
 		goto err_clk_disable_unprepare;
 
-- 
2.42.0



