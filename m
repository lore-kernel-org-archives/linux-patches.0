Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B0F64CEB;
	Tue, 23 Jan 2024 00:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971585; cv=none; b=Xz5Qm4swsYlgbvk43hngE+suofl6num7xGM3QpB3vMh/XfYnFwhWHU4oVtyQHi+1HB90hbmw8djEHWm0Kw7VkoCmUkF6zwavmPqStPFAg670irivhNkil1JbdHAMMUDoJNIwApEIV2e2/r8PSNJuwIVS/N019tIY31lUllqPRT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971585; c=relaxed/simple;
	bh=1v8FL6Iu8FQjoO3MfK1z6PrC3oVRbymHNPqcy7tmvng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dsbIYZJT8xZKimOefcu54zcTjCc7XPZHPBeLS9rqg+CC85c/nRDVMnNAuQX6viIsNHNgYzhKAlc15VKnicNA1+X4T26jQZfPaCQY+/F4kRCS5UC6sz9VvzXpbqcTcMV1VaXeH/vs7197g3DiZn2wyl7n+VEaPdkgdZYI2940Fws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KVQJIIUd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KVQJIIUd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B28C7C433F1;
	Tue, 23 Jan 2024 00:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971584;
	bh=1v8FL6Iu8FQjoO3MfK1z6PrC3oVRbymHNPqcy7tmvng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KVQJIIUdLaStB+MNXqm8fiyU+AHYkIK0phHmOODlVBAZ6B3l7Dl0N5Li+cX4u04mY
	 aLmgFcCUDMG1Davgqqcqw0kIGGX4txWMevuWekCAZvYVV9VqPjx2VowPK0gEYM/JiC
	 c72OvTSbiw7toquEUE41vQfQpZVeMDJdsrdVnnvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Christoph Niedermaier <cniedermaier@dh-electronics.com>,
	Lukas Wunner <lukas@wunner.de>
Subject: [PATCH 6.1 274/417] serial: imx: Ensure that imx_uart_rs485_config() is called with enabled clock
Date: Mon, 22 Jan 2024 15:57:22 -0800
Message-ID: <20240122235801.343961135@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Niedermaier <cniedermaier@dh-electronics.com>

commit 7c45eaa813476bd195ac1227a64b52f9cf2e2030 upstream.

There are register accesses in the function imx_uart_rs485_config(). The
clock must be enabled for these accesses. This was ensured by calling it
via the function uart_rs485_config() in the probe() function within the
range where the clock is enabled. With the commit 7c7f9bc986e6 ("serial:
Deassert Transmit Enable on probe in driver-specific way") it was removed
from the probe() function and is now only called through the function
uart_add_one_port() which is located at the end of the probe() function.
But the clock is already switched off in this area. To ensure that the
clock is enabled during register access, move the disabling of the clock
to the very end of the probe() function. To avoid leaking enabled clocks
on error also add an error path for exiting with disabling the clock.

Fixes: 7c7f9bc986e6 ("serial: Deassert Transmit Enable on probe in driver-specific way")
Cc: stable <stable@kernel.org>
Signed-off-by: Christoph Niedermaier <cniedermaier@dh-electronics.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Link: https://lore.kernel.org/r/20231226113647.39376-1-cniedermaier@dh-electronics.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/imx.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -2356,10 +2356,8 @@ static int imx_uart_probe(struct platfor
 	sport->ufcr = readl(sport->port.membase + UFCR);
 
 	ret = uart_get_rs485_mode(&sport->port);
-	if (ret) {
-		clk_disable_unprepare(sport->clk_ipg);
-		return ret;
-	}
+	if (ret)
+		goto err_clk;
 
 	/*
 	 * If using the i.MX UART RTS/CTS control then the RTS (CTS_B)
@@ -2439,8 +2437,6 @@ static int imx_uart_probe(struct platfor
 		imx_uart_writel(sport, ucr3, UCR3);
 	}
 
-	clk_disable_unprepare(sport->clk_ipg);
-
 	hrtimer_init(&sport->trigger_start_tx, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hrtimer_init(&sport->trigger_stop_tx, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	sport->trigger_start_tx.function = imx_trigger_start_tx;
@@ -2456,7 +2452,7 @@ static int imx_uart_probe(struct platfor
 		if (ret) {
 			dev_err(&pdev->dev, "failed to request rx irq: %d\n",
 				ret);
-			return ret;
+			goto err_clk;
 		}
 
 		ret = devm_request_irq(&pdev->dev, txirq, imx_uart_txint, 0,
@@ -2464,7 +2460,7 @@ static int imx_uart_probe(struct platfor
 		if (ret) {
 			dev_err(&pdev->dev, "failed to request tx irq: %d\n",
 				ret);
-			return ret;
+			goto err_clk;
 		}
 
 		ret = devm_request_irq(&pdev->dev, rtsirq, imx_uart_rtsint, 0,
@@ -2472,14 +2468,14 @@ static int imx_uart_probe(struct platfor
 		if (ret) {
 			dev_err(&pdev->dev, "failed to request rts irq: %d\n",
 				ret);
-			return ret;
+			goto err_clk;
 		}
 	} else {
 		ret = devm_request_irq(&pdev->dev, rxirq, imx_uart_int, 0,
 				       dev_name(&pdev->dev), sport);
 		if (ret) {
 			dev_err(&pdev->dev, "failed to request irq: %d\n", ret);
-			return ret;
+			goto err_clk;
 		}
 	}
 
@@ -2487,7 +2483,12 @@ static int imx_uart_probe(struct platfor
 
 	platform_set_drvdata(pdev, sport);
 
-	return uart_add_one_port(&imx_uart_uart_driver, &sport->port);
+	ret = uart_add_one_port(&imx_uart_uart_driver, &sport->port);
+
+err_clk:
+	clk_disable_unprepare(sport->clk_ipg);
+
+	return ret;
 }
 
 static int imx_uart_remove(struct platform_device *pdev)


