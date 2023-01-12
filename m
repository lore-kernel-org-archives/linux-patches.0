Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E58079C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:39:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050B8C433F0;
	Thu, 12 Jan 2023 14:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673534340;
	bh=MaKBrD4rQWjXW097NC1+SusXTwLYynUUnDEQ1ulFFus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BqiBw7IkrCS4Y5x8MOf+oVK0ykn5T7ALXKRiTYcoWxejNa8qdUnPNPrxTIyMtI2QQ
	 hWVAlrUxAlUFnGo9nkWDNEHYIHCB9d5nOoJoPrtYQtYyWkp2AG8Ye+TgOwaBpBU8tG
	 DUP7YL4EcgiaCUVJf3crT4jJzESm92MzEV7KzvcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Indan Zupancic <Indan.Zupancic@mep-info.com>,
	Dominique Martinet <dominique.martinet@atmark-techno.com>
Subject: [PATCH 5.10 776/783] fsl_lpuart: Dont enable interrupts too early
Date: Thu, 12 Jan 2023 14:58:12 +0100
Message-Id: <20230112135600.363788119@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Indan Zupancic <Indan.Zupancic@mep-info.com>

commit 401fb66a355eb0f22096cf26864324f8e63c7d78 upstream.

If an irq is pending when devm_request_irq() is called, the irq
handler will cause a NULL pointer access because initialisation
is not done yet.

Fixes: 9d7ee0e28da59 ("tty: serial: lpuart: avoid report NULL interrupt")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Indan Zupancic <Indan.Zupancic@mep-info.com>
Link: https://lore.kernel.org/r/20220505114750.45423-1-Indan.Zupancic@mep-info.com
[5.10 did not have lpuart_global_reset or anything after
uart_add_one_port(), so add the remove call in cleanup manually]
Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/fsl_lpuart.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2586,6 +2586,7 @@ static int lpuart_probe(struct platform_
 	struct device_node *np = pdev->dev.of_node;
 	struct lpuart_port *sport;
 	struct resource *res;
+	irq_handler_t handler;
 	int ret;
 
 	sport = devm_kzalloc(&pdev->dev, sizeof(*sport), GFP_KERNEL);
@@ -2658,17 +2659,12 @@ static int lpuart_probe(struct platform_
 
 	if (lpuart_is_32(sport)) {
 		lpuart_reg.cons = LPUART32_CONSOLE;
-		ret = devm_request_irq(&pdev->dev, sport->port.irq, lpuart32_int, 0,
-					DRIVER_NAME, sport);
+		handler = lpuart32_int;
 	} else {
 		lpuart_reg.cons = LPUART_CONSOLE;
-		ret = devm_request_irq(&pdev->dev, sport->port.irq, lpuart_int, 0,
-					DRIVER_NAME, sport);
+		handler = lpuart_int;
 	}
 
-	if (ret)
-		goto failed_irq_request;
-
 	ret = uart_get_rs485_mode(&sport->port);
 	if (ret)
 		goto failed_get_rs485;
@@ -2684,11 +2680,17 @@ static int lpuart_probe(struct platform_
 	if (ret)
 		goto failed_attach_port;
 
+	ret = devm_request_irq(&pdev->dev, sport->port.irq, handler, 0,
+				DRIVER_NAME, sport);
+	if (ret)
+		goto failed_irq_request;
+
 	return 0;
 
+failed_irq_request:
+	uart_remove_one_port(&lpuart_reg, &sport->port);
 failed_get_rs485:
 failed_attach_port:
-failed_irq_request:
 	lpuart_disable_clks(sport);
 	return ret;
 }


