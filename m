Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2276EB67;
	Tue, 23 Jan 2024 02:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975418; cv=none; b=kEqevNsz2u9kBYY8HZr8zM1sy+6AbwtN9K+sJd5j55s7kV4a3A307rlOh802uht4WmJMil8aK8GzJI+uPRzhE8pYHH7/rSOXu0HuszZQvrh6rALzP4uhKrJwE/TeR/UakDyGMsZIpUEdXpNyYEgUFYdqrsR7fPysMmudtXNdVuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975418; c=relaxed/simple;
	bh=69W/GtYNyW4FFBoDD3rh8vrXI/DvPIeNzKLF3aSJ/9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSNyjORjbe+Owx7lQtQye3RgowGXjyZgp11PKstahuO8+2/SumIQeouL/5KT/sY1ZM71xUvQdQRb9xfgxSmWlIr0NBMDfjjV0KTw1igTgUkthxjVw+dxsctOOeLmDG+Qzi5e4Tz87GomUxY8eH3t6AFHVJx7pfPSVTanJ46tBpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H9YnBRF8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H9YnBRF8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA23C433C7;
	Tue, 23 Jan 2024 02:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975417;
	bh=69W/GtYNyW4FFBoDD3rh8vrXI/DvPIeNzKLF3aSJ/9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H9YnBRF8LK8mY88GvGHUXMZY7lLAwRMZ13P2D1jzdnwlOE0MCRW+vbrNl1GNxPCfj
	 og1t57YYFvITIUk17byOF/hP1XNJ4KtuRP2z6WXb+XZ80s80NHoF96xiKGvaBXadSs
	 SU+79BrwiDxgg4J+odbv63d0gzZAnQdaCFDTE/jE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Christoph Niedermaier <cniedermaier@dh-electronics.com>,
	Lukas Wunner <lukas@wunner.de>
Subject: [PATCH 6.6 376/583] serial: imx: Ensure that imx_uart_rs485_config() is called with enabled clock
Date: Mon, 22 Jan 2024 15:57:07 -0800
Message-ID: <20240122235823.524747864@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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
@@ -2328,10 +2328,8 @@ static int imx_uart_probe(struct platfor
 	}
 
 	ret = uart_get_rs485_mode(&sport->port);
-	if (ret) {
-		clk_disable_unprepare(sport->clk_ipg);
-		return ret;
-	}
+	if (ret)
+		goto err_clk;
 
 	/*
 	 * If using the i.MX UART RTS/CTS control then the RTS (CTS_B)
@@ -2411,8 +2409,6 @@ static int imx_uart_probe(struct platfor
 		imx_uart_writel(sport, ucr3, UCR3);
 	}
 
-	clk_disable_unprepare(sport->clk_ipg);
-
 	hrtimer_init(&sport->trigger_start_tx, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hrtimer_init(&sport->trigger_stop_tx, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	sport->trigger_start_tx.function = imx_trigger_start_tx;
@@ -2428,7 +2424,7 @@ static int imx_uart_probe(struct platfor
 		if (ret) {
 			dev_err(&pdev->dev, "failed to request rx irq: %d\n",
 				ret);
-			return ret;
+			goto err_clk;
 		}
 
 		ret = devm_request_irq(&pdev->dev, txirq, imx_uart_txint, 0,
@@ -2436,7 +2432,7 @@ static int imx_uart_probe(struct platfor
 		if (ret) {
 			dev_err(&pdev->dev, "failed to request tx irq: %d\n",
 				ret);
-			return ret;
+			goto err_clk;
 		}
 
 		ret = devm_request_irq(&pdev->dev, rtsirq, imx_uart_rtsint, 0,
@@ -2444,14 +2440,14 @@ static int imx_uart_probe(struct platfor
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
 
@@ -2459,7 +2455,12 @@ static int imx_uart_probe(struct platfor
 
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


