Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84E62D948D;
	Thu, 15 Jan 2026 17:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499021; cv=none; b=cCIu02F6Aa04zPrmDOu73vkSs2kHEhQEe5xkUV5Kmivqz3AlJKnPLqyD3x+wwKBW0Pvf3r/ClcEFSFQjpR+DVg9A869NykA9R3FJOtSM2xYZbJ0ZbH02IdyBllTY6Tv+xNJS6mpSfh9HDWYKF7VWk58YHkMZuDsc6uh5ITKbN3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499021; c=relaxed/simple;
	bh=rPnUOQ4wrX8J7M7olKQWnjG4yPbDgFr9Y15cYKTOmZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wglj/wHMB+cqpV1j5xc8Kt9vX02/GgCcxtTF6+ALw/EEJRBlY0CHccZIvpJsof64ui+jsutOGsYSh3fJGAGq6N7SnGPqRLtzVhme+rgYFyUfYGFIYGSmfVuBtbKg1kIPkFEfGq/0270/1ULnugj/nw5G1uA+N+TXxZNX3J4Qijk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KqCIBV2h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KqCIBV2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14CA6C116D0;
	Thu, 15 Jan 2026 17:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499021;
	bh=rPnUOQ4wrX8J7M7olKQWnjG4yPbDgFr9Y15cYKTOmZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KqCIBV2hZDV2wDG8tu2st8lY1RmuER9gddJgRdnqm07xgocgL6NVMmztJF2qR4ZrE
	 02ieXe6sS+YIIspDwjtGooXWB/mqGDCwF5fehyoCVuSgw+9BMmVJUDaq3tcXGr0VCm
	 fEtDoMBF6iN+A4o6iWuZO8ZG9oRpiAsMISA54lrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 080/451] watchdog: wdat_wdt: Fix ACPI table leak in probe function
Date: Thu, 15 Jan 2026 17:44:41 +0100
Message-ID: <20260115164233.809676599@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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
index ec308836aad9c..cabeec210f166 100644
--- a/drivers/watchdog/wdat_wdt.c
+++ b/drivers/watchdog/wdat_wdt.c
@@ -327,19 +327,27 @@ static int wdat_wdt_probe(struct platform_device *pdev)
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
 	wdat->wdd.min_hw_heartbeat_ms = wdat->period * tbl->min_count;
@@ -356,15 +364,20 @@ static int wdat_wdt_probe(struct platform_device *pdev)
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
@@ -386,8 +399,10 @@ static int wdat_wdt_probe(struct platform_device *pdev)
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
@@ -418,7 +433,8 @@ static int wdat_wdt_probe(struct platform_device *pdev)
 
 		if (!instr->reg) {
 			dev_err(dev, "I/O resource not found\n");
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out_put_table;
 		}
 
 		instructions = wdat->instructions[action];
@@ -426,8 +442,10 @@ static int wdat_wdt_probe(struct platform_device *pdev)
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
@@ -441,7 +459,7 @@ static int wdat_wdt_probe(struct platform_device *pdev)
 
 	ret = wdat_wdt_enable_reboot(wdat);
 	if (ret)
-		return ret;
+		goto out_put_table;
 
 	platform_set_drvdata(pdev, wdat);
 
@@ -459,12 +477,16 @@ static int wdat_wdt_probe(struct platform_device *pdev)
 
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
 
 #ifdef CONFIG_PM_SLEEP
-- 
2.51.0



