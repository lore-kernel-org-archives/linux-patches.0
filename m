Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AC31C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:24:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE97C433D2;
	Wed, 28 Dec 2022 16:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244649;
	bh=CqE0CSaAkh3PlO1as11d/7BWmNUkGMRRYasRiRMzpD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gKQeygcwfsWdyRNEf0ggmtfNcPZoiN69DG4VN6+fIlDaoEOBuUiuDLPF1UDszeFgc
	 fsxG+QjIHVyUnrTM1fohTa9FRcb/jlOF9EYMjmsbfHzYSoa8kF7t07XdsvBmnJJzz5
	 wA4hbLhG2BUv0V3Jlbi3jkZgL6VmKiWSuIGSihw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Valentin Caron <valentin.caron@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0709/1146] serial: stm32: move dma_request_chan() before clk_prepare_enable()
Date: Wed, 28 Dec 2022 15:37:28 +0100
Message-Id: <20221228144349.404855198@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Valentin Caron <valentin.caron@foss.st.com>

[ Upstream commit 0d114e9ff940ebad8e88267013bf96c605a6b336 ]

If dma_request_chan() returns a PROBE_DEFER error, clk_disable_unprepare()
will be called and USART clock will be disabled. But early console can be
still active on the same USART.

While moving dma_request_chan() before clk_prepare_enable(), the clock
won't be taken in case of a DMA PROBE_DEFER error, and so it doesn't need
to be disabled. Then USART is still clocked for early console.

Fixes: a7770a4bfcf4 ("serial: stm32: defer probe for dma devices")
Reported-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Valentin Caron <valentin.caron@foss.st.com>
Link: https://lore.kernel.org/r/20221118170602.1057863-1-valentin.caron@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 47 ++++++++++++++++----------------
 1 file changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index dfdbcf092fac..b8aed28b8f17 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -1681,22 +1681,10 @@ static int stm32_usart_serial_probe(struct platform_device *pdev)
 	if (!stm32port->info)
 		return -EINVAL;
 
-	ret = stm32_usart_init_port(stm32port, pdev);
-	if (ret)
-		return ret;
-
-	if (stm32port->wakeup_src) {
-		device_set_wakeup_capable(&pdev->dev, true);
-		ret = dev_pm_set_wake_irq(&pdev->dev, stm32port->port.irq);
-		if (ret)
-			goto err_deinit_port;
-	}
-
 	stm32port->rx_ch = dma_request_chan(&pdev->dev, "rx");
-	if (PTR_ERR(stm32port->rx_ch) == -EPROBE_DEFER) {
-		ret = -EPROBE_DEFER;
-		goto err_wakeirq;
-	}
+	if (PTR_ERR(stm32port->rx_ch) == -EPROBE_DEFER)
+		return -EPROBE_DEFER;
+
 	/* Fall back in interrupt mode for any non-deferral error */
 	if (IS_ERR(stm32port->rx_ch))
 		stm32port->rx_ch = NULL;
@@ -1710,6 +1698,17 @@ static int stm32_usart_serial_probe(struct platform_device *pdev)
 	if (IS_ERR(stm32port->tx_ch))
 		stm32port->tx_ch = NULL;
 
+	ret = stm32_usart_init_port(stm32port, pdev);
+	if (ret)
+		goto err_dma_tx;
+
+	if (stm32port->wakeup_src) {
+		device_set_wakeup_capable(&pdev->dev, true);
+		ret = dev_pm_set_wake_irq(&pdev->dev, stm32port->port.irq);
+		if (ret)
+			goto err_deinit_port;
+	}
+
 	if (stm32port->rx_ch && stm32_usart_of_dma_rx_probe(stm32port, pdev)) {
 		/* Fall back in interrupt mode */
 		dma_release_channel(stm32port->rx_ch);
@@ -1746,19 +1745,11 @@ static int stm32_usart_serial_probe(struct platform_device *pdev)
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_put_noidle(&pdev->dev);
 
-	if (stm32port->tx_ch) {
+	if (stm32port->tx_ch)
 		stm32_usart_of_dma_tx_remove(stm32port, pdev);
-		dma_release_channel(stm32port->tx_ch);
-	}
-
 	if (stm32port->rx_ch)
 		stm32_usart_of_dma_rx_remove(stm32port, pdev);
 
-err_dma_rx:
-	if (stm32port->rx_ch)
-		dma_release_channel(stm32port->rx_ch);
-
-err_wakeirq:
 	if (stm32port->wakeup_src)
 		dev_pm_clear_wake_irq(&pdev->dev);
 
@@ -1768,6 +1759,14 @@ static int stm32_usart_serial_probe(struct platform_device *pdev)
 
 	stm32_usart_deinit_port(stm32port);
 
+err_dma_tx:
+	if (stm32port->tx_ch)
+		dma_release_channel(stm32port->tx_ch);
+
+err_dma_rx:
+	if (stm32port->rx_ch)
+		dma_release_channel(stm32port->rx_ch);
+
 	return ret;
 }
 
-- 
2.35.1



