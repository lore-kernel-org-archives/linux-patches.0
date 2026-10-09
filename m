Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4638848C403;
	Fri,  9 Oct 2026 14:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557430; cv=none; b=fDH8j+uWdz0palZO41S2QlWj6jq3rUkkA5fJaDhxA60kjPPazfNq/Zq09R5FQKN/DjL0ZdsmMPvFcUx8bPRFzxXBY/YbdZkJw8Q7JX0zlIMLuthnJw7QGl+Jq0Gbz7iu1wWrCY9qj7r45vuqmDtK9yYdWFpCiOjO9miJWb/WigQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557430; c=relaxed/simple;
	bh=ooZcLFxaQFDlheQkRE6g0m0HUYy/1M9bIDo2xbsXink=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dEClwS3Tg/dymF6eCNxPm0O6BKxy3KwPe/TT7N30Br+LCPMmH8KofaxpiBCp5mFIgZeXqjbfkN0bOxzsohKakYE+g6h/vclkbZyQU5IFdHcl/XThz6hNlZyvq6rB7QZEYj90otZsn6qat+E+VKHnovJf4uuuv4aCgW6iuKWukTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V1H4BrI6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V1H4BrI6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97CDA1F000FF;
	Fri,  9 Oct 2026 14:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557429;
	bh=VVf4vQTKq4MrN0VOjNXB5+QqwIsdFVSrFaPesRz0iQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V1H4BrI6Mp8EnOxSZzf19A+VgT331TvQOEw51aOMv/mRllE7r6dYcXfq+pHEki+WG
	 /JHs9uIszzlQA761sqXEFefXNgpfSExmbJi0djaMTLWUc8aQbcbm3Y04GWkJJDKS+G
	 rX1o/qV9KOybwSOa+9M8TmPLmkVXExO20VfvBb2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 402/403] iio: adc: adi-axi-adc: Make use of dev_err_probe()
Date: Fri,  9 Oct 2026 16:12:43 +0200
Message-ID: <20261009141001.765730032@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit 634a6316617e2ced7016b002d0b284a1502e9601 ]

Be consistent and use dev_err_probe() as in all other places in the
.probe() path.

While at it, remove the line break in the version condition. Yes, it
goes over the 80 column limit but I do think the line break hurts
readability in this case. And use a struct device *dev helper for
neater code.

Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 549b71ce0506 ("iio: adc: adi-axi-adc: Initialize state mutex")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/adi-axi-adc.c |   55 +++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 30 deletions(-)

--- a/drivers/iio/adc/adi-axi-adc.c
+++ b/drivers/iio/adc/adi-axi-adc.c
@@ -704,13 +704,14 @@ static const struct iio_backend_info axi
 
 static int adi_axi_adc_probe(struct platform_device *pdev)
 {
+	struct device *dev = &pdev->dev;
 	struct adi_axi_adc_state *st;
 	void __iomem *base;
 	unsigned int ver;
 	struct clk *clk;
 	int ret;
 
-	st = devm_kzalloc(&pdev->dev, sizeof(*st), GFP_KERNEL);
+	st = devm_kzalloc(dev, sizeof(*st), GFP_KERNEL);
 	if (!st)
 		return -ENOMEM;
 
@@ -718,20 +719,19 @@ static int adi_axi_adc_probe(struct plat
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 
-	st->dev = &pdev->dev;
-	st->regmap = devm_regmap_init_mmio(&pdev->dev, base,
-					   &axi_adc_regmap_config);
+	st->dev = dev;
+	st->regmap = devm_regmap_init_mmio(dev, base, &axi_adc_regmap_config);
 	if (IS_ERR(st->regmap))
-		return dev_err_probe(&pdev->dev, PTR_ERR(st->regmap),
+		return dev_err_probe(dev, PTR_ERR(st->regmap),
 				     "failed to init register map\n");
 
-	st->info = device_get_match_data(&pdev->dev);
+	st->info = device_get_match_data(dev);
 	if (!st->info)
 		return -ENODEV;
 
-	clk = devm_clk_get_enabled(&pdev->dev, NULL);
+	clk = devm_clk_get_enabled(dev, NULL);
 	if (IS_ERR(clk))
-		return dev_err_probe(&pdev->dev, PTR_ERR(clk),
+		return dev_err_probe(dev, PTR_ERR(clk),
 				     "failed to get clock\n");
 
 	/*
@@ -746,47 +746,42 @@ static int adi_axi_adc_probe(struct plat
 	if (ret)
 		return ret;
 
-	if (ADI_AXI_PCORE_VER_MAJOR(ver) !=
-	    ADI_AXI_PCORE_VER_MAJOR(st->info->version)) {
-		dev_err(&pdev->dev,
-			"Major version mismatch. Expected %d.%.2d.%c, Reported %d.%.2d.%c\n",
-			ADI_AXI_PCORE_VER_MAJOR(st->info->version),
-			ADI_AXI_PCORE_VER_MINOR(st->info->version),
-			ADI_AXI_PCORE_VER_PATCH(st->info->version),
-			ADI_AXI_PCORE_VER_MAJOR(ver),
-			ADI_AXI_PCORE_VER_MINOR(ver),
-			ADI_AXI_PCORE_VER_PATCH(ver));
-		return -ENODEV;
-	}
+	if (ADI_AXI_PCORE_VER_MAJOR(ver) != ADI_AXI_PCORE_VER_MAJOR(st->info->version))
+		return dev_err_probe(dev, -ENODEV,
+				     "Major version mismatch. Expected %d.%.2d.%c, Reported %d.%.2d.%c\n",
+				     ADI_AXI_PCORE_VER_MAJOR(st->info->version),
+				     ADI_AXI_PCORE_VER_MINOR(st->info->version),
+				     ADI_AXI_PCORE_VER_PATCH(st->info->version),
+				     ADI_AXI_PCORE_VER_MAJOR(ver),
+				     ADI_AXI_PCORE_VER_MINOR(ver),
+				     ADI_AXI_PCORE_VER_PATCH(ver));
 
-	ret = devm_iio_backend_register(&pdev->dev, st->info->backend_info, st);
+	ret = devm_iio_backend_register(dev, st->info->backend_info, st);
 	if (ret)
-		return dev_err_probe(&pdev->dev, ret,
-				     "failed to register iio backend\n");
+		return dev_err_probe(dev, ret, "failed to register iio backend\n");
 
-	device_for_each_child_node_scoped(&pdev->dev, child) {
+	device_for_each_child_node_scoped(dev, child) {
 		int val;
 
 		if (!st->info->has_child_nodes)
-			return dev_err_probe(&pdev->dev, -EINVAL,
+			return dev_err_probe(dev, -EINVAL,
 					     "invalid fdt axi-dac compatible.");
 
 		/* Processing only reg 0 node */
 		ret = fwnode_property_read_u32(child, "reg", &val);
 		if (ret)
-			return dev_err_probe(&pdev->dev, ret,
-					     "invalid reg property.");
+			return dev_err_probe(dev, ret, "invalid reg property.");
 		if (val != 0)
-			return dev_err_probe(&pdev->dev, -EINVAL,
+			return dev_err_probe(dev, -EINVAL,
 					     "invalid node address.");
 
 		ret = axi_adc_create_platform_device(st, child);
 		if (ret)
-			return dev_err_probe(&pdev->dev, -EINVAL,
+			return dev_err_probe(dev, -EINVAL,
 					     "cannot create device.");
 	}
 
-	dev_info(&pdev->dev, "AXI ADC IP core (%d.%.2d.%c) probed\n",
+	dev_info(dev, "AXI ADC IP core (%d.%.2d.%c) probed\n",
 		 ADI_AXI_PCORE_VER_MAJOR(ver),
 		 ADI_AXI_PCORE_VER_MINOR(ver),
 		 ADI_AXI_PCORE_VER_PATCH(ver));


