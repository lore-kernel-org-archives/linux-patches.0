Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB25812BF34;
	Tue, 23 Jan 2024 01:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971753; cv=none; b=UkPOJErhiF5IAWah5ROlEJddIqkv5tknJJ95B88ThkQSWLk8xehSWA/D/uIdQve5jm3pKhgZS3YZK1+frWrLrzhvE3rgtIGghAwpq54MFo+HvXiw+y3U2Rjq0CcDoO5qGQ0SkaVhBoA5i+RS8tgqWSkO3wflg3IITGJiHTelHlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971753; c=relaxed/simple;
	bh=C25frbqcO9aEOlFcbzkKiV4XKHpxrYT5SYfRNefekSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9hXGsLUj1dBiffW91Q8UlFWHEEc2XpHBM11KormCme+Q8fla/u8IVZIk6C/CSRfHQLvQnMjCIYE86oC3XrI+43S7Id8hosNjTPp1AOsvrD5oLUKM8JSD1ZdzUq8d3YJg2vmHPAWs8rjwPbClV4TfDveiDvUuN063fC9IRv3gnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SV2Qwkkr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SV2Qwkkr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B6AC433C7;
	Tue, 23 Jan 2024 01:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971752;
	bh=C25frbqcO9aEOlFcbzkKiV4XKHpxrYT5SYfRNefekSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SV2Qwkkrvc/sYAZ+Y+iZLHSt/63u1UtqrqorS9fAoKm31yA6KDpz40+piKfm9Mr4z
	 yaPN1GoHdw8IsevoIaLS3LkICk5yNQTZeDmo5aoQh8sZLAYmKyKLHz3MZ8y0fIdn9o
	 FxGkXKQAk76oKd/kzkPOjpjHW2QPDBqM7dRvPofM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Christoph Niedermaier <cniedermaier@dh-electronics.com>,
	Lukas Wunner <lukas@wunner.de>
Subject: [PATCH 5.10 219/286] serial: imx: Ensure that imx_uart_rs485_config() is called with enabled clock
Date: Mon, 22 Jan 2024 15:58:45 -0800
Message-ID: <20240122235740.505571909@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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
@@ -2358,10 +2358,8 @@ static int imx_uart_probe(struct platfor
 	sport->ufcr = readl(sport->port.membase + UFCR);
 
 	ret = uart_get_rs485_mode(&sport->port);
-	if (ret) {
-		clk_disable_unprepare(sport->clk_ipg);
-		return ret;
-	}
+	if (ret)
+		goto err_clk;
 
 	if (sport->port.rs485.flags & SER_RS485_ENABLED &&
 	    (!sport->have_rtscts && !sport->have_rtsgpio))
@@ -2415,8 +2413,6 @@ static int imx_uart_probe(struct platfor
 		imx_uart_writel(sport, ucr3, UCR3);
 	}
 
-	clk_disable_unprepare(sport->clk_ipg);
-
 	hrtimer_init(&sport->trigger_start_tx, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hrtimer_init(&sport->trigger_stop_tx, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	sport->trigger_start_tx.function = imx_trigger_start_tx;
@@ -2432,7 +2428,7 @@ static int imx_uart_probe(struct platfor
 		if (ret) {
 			dev_err(&pdev->dev, "failed to request rx irq: %d\n",
 				ret);
-			return ret;
+			goto err_clk;
 		}
 
 		ret = devm_request_irq(&pdev->dev, txirq, imx_uart_txint, 0,
@@ -2440,7 +2436,7 @@ static int imx_uart_probe(struct platfor
 		if (ret) {
 			dev_err(&pdev->dev, "failed to request tx irq: %d\n",
 				ret);
-			return ret;
+			goto err_clk;
 		}
 
 		ret = devm_request_irq(&pdev->dev, rtsirq, imx_uart_rtsint, 0,
@@ -2448,14 +2444,14 @@ static int imx_uart_probe(struct platfor
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
 
@@ -2463,7 +2459,12 @@ static int imx_uart_probe(struct platfor
 
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


