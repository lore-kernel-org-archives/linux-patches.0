Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30D2354AEE;
	Tue, 16 Dec 2025 11:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885807; cv=none; b=C+nfbK3V+RFfWfHoitHQ3bUBjS/+kKwwIJdxHcDZI7BgZeRg8oLFHgXz1yw/moZImwrG+ROasSpICp04GCUDZMgl+54baTBz/+xYB7dkAv8g8BHFe+gDLwMFdpS1bCYTVVghBGNBAY/EJvIlcIaxwWXR2utLqNeso8BfbAS3Hes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885807; c=relaxed/simple;
	bh=aRxw4KYh3XkbLTkm1Qv82kcJpoOkROMOO2Vc+1E+YcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GPXOcCHVdgBXTK6GfUvYHS5MDGYGHJFxpqTXajUHe82CiNoRYWqORa1gWKELu2RQtJ/4NOUSoNKHr4Nis1OW2sh1gSmZDCVzlZlAWawC9ngko2g7D8Xe6HEFzmxl47nwlRrtj3IMelcV4+IfIUHw4GPhOGzb5L14h5M1zdEj8+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iCrc75ec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iCrc75ec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4535DC4CEF1;
	Tue, 16 Dec 2025 11:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885807;
	bh=aRxw4KYh3XkbLTkm1Qv82kcJpoOkROMOO2Vc+1E+YcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iCrc75eczu9nJWBEnZvHMYYcLMmfX12o8fuz9sP5LaXQFsAQK7mr+5pTKxaDRH7J5
	 GRY2/rMgJqrvLah7Yclow0ULCStyd5acvPY1BpeOl05hVbKsyCx2pzN0Lzu/KczB6/
	 qdfTFEcchEhfmfH+6+maT/5cHL/1BiDGLO7RKyn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 251/507] watchdog: wdat_wdt: Fix ACPI table leak in probe function
Date: Tue, 16 Dec 2025 12:11:32 +0100
Message-ID: <20251216111354.586350059@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 25c0b472eab8379683d4eef681185c104bed8ffd ]

wdat_wdt_probe() calls acpi_get_table() to obtain the WDAT ACPI table but
never calls acpi_put_table() on any paths. This causes a permanent ACPI
table memory leak.

Add a single cleanup path which calls acpi_put_table() to ensure
the ACPI table is always released.

Fixes: 058dfc767008 ("ACPI / watchdog: Add support for WDAT hardware watchdog")
Suggested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/wdat_wdt.c | 64 +++++++++++++++++++++++++------------
 1 file changed, 43 insertions(+), 21 deletions(-)

diff --git a/drivers/watchdog/wdat_wdt.c b/drivers/watchdog/wdat_wdt.c
index 650fdc7996e1c..dd3c2d69c9df1 100644
--- a/drivers/watchdog/wdat_wdt.c
+++ b/drivers/watchdog/wdat_wdt.c
@@ -326,19 +326,27 @@ static int wdat_wdt_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	wdat = devm_kzalloc(dev, sizeof(*wdat), GFP_KERNEL);
-	if (!wdat)
-		return -ENOMEM;
+	if (!wdat) {
+		ret = -ENOMEM;
+		goto out_put_table;
+	}
 
 	regs = devm_kcalloc(dev, pdev->num_resources, sizeof(*regs),
 			    GFP_KERNEL);
-	if (!regs)
-		return -ENOMEM;
+	if (!regs) {
+		ret = -ENOMEM;
+		goto out_put_table;
+	}
 
 	/* WDAT specification wants to have >= 1ms period */
-	if (tbl->timer_period < 1)
-		return -EINVAL;
-	if (tbl->min_count > tbl->max_count)
-		return -EINVAL;
+	if (tbl->timer_period < 1) {
+		ret = -EINVAL;
+		goto out_put_table;
+	}
+	if (tbl->min_count > tbl->max_count) {
+		ret = -EINVAL;
+		goto out_put_table;
+	}
 
 	wdat->period = tbl->timer_period;
 	wdat->wdd.min_timeout = DIV_ROUND_UP(wdat->period * tbl->min_count, 1000);
@@ -355,15 +363,20 @@ static int wdat_wdt_probe(struct platform_device *pdev)
 		res = &pdev->resource[i];
 		if (resource_type(res) == IORESOURCE_MEM) {
 			reg = devm_ioremap_resource(dev, res);
-			if (IS_ERR(reg))
-				return PTR_ERR(reg);
+			if (IS_ERR(reg)) {
+				ret = PTR_ERR(reg);
+				goto out_put_table;
+			}
 		} else if (resource_type(res) == IORESOURCE_IO) {
 			reg = devm_ioport_map(dev, res->start, 1);
-			if (!reg)
-				return -ENOMEM;
+			if (!reg) {
+				ret = -ENOMEM;
+				goto out_put_table;
+			}
 		} else {
 			dev_err(dev, "Unsupported resource\n");
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out_put_table;
 		}
 
 		regs[i] = reg;
@@ -385,8 +398,10 @@ static int wdat_wdt_probe(struct platform_device *pdev)
 		}
 
 		instr = devm_kzalloc(dev, sizeof(*instr), GFP_KERNEL);
-		if (!instr)
-			return -ENOMEM;
+		if (!instr) {
+			ret = -ENOMEM;
+			goto out_put_table;
+		}
 
 		INIT_LIST_HEAD(&instr->node);
 		instr->entry = entries[i];
@@ -417,7 +432,8 @@ static int wdat_wdt_probe(struct platform_device *pdev)
 
 		if (!instr->reg) {
 			dev_err(dev, "I/O resource not found\n");
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out_put_table;
 		}
 
 		instructions = wdat->instructions[action];
@@ -425,8 +441,10 @@ static int wdat_wdt_probe(struct platform_device *pdev)
 			instructions = devm_kzalloc(dev,
 						    sizeof(*instructions),
 						    GFP_KERNEL);
-			if (!instructions)
-				return -ENOMEM;
+			if (!instructions) {
+				ret = -ENOMEM;
+				goto out_put_table;
+			}
 
 			INIT_LIST_HEAD(instructions);
 			wdat->instructions[action] = instructions;
@@ -443,7 +461,7 @@ static int wdat_wdt_probe(struct platform_device *pdev)
 
 	ret = wdat_wdt_enable_reboot(wdat);
 	if (ret)
-		return ret;
+		goto out_put_table;
 
 	platform_set_drvdata(pdev, wdat);
 
@@ -460,12 +478,16 @@ static int wdat_wdt_probe(struct platform_device *pdev)
 
 	ret = wdat_wdt_set_timeout(&wdat->wdd, timeout);
 	if (ret)
-		return ret;
+		goto out_put_table;
 
 	watchdog_set_nowayout(&wdat->wdd, nowayout);
 	watchdog_stop_on_reboot(&wdat->wdd);
 	watchdog_stop_on_unregister(&wdat->wdd);
-	return devm_watchdog_register_device(dev, &wdat->wdd);
+	ret = devm_watchdog_register_device(dev, &wdat->wdd);
+
+out_put_table:
+	acpi_put_table((struct acpi_table_header *)tbl);
+	return ret;
 }
 
 static int wdat_wdt_suspend_noirq(struct device *dev)
-- 
2.51.0



