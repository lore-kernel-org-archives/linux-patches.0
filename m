Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8961170E
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A3EC433C9;
	Mon, 21 Aug 2023 19:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647513;
	bh=GgeIIeu6cvgXtpDBWUBMz4YsOKP4w3daMw7gLGepmlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IxC3D1YEEEmHZ8IBab8zdzMbSfCfRrOs7+BIU26SNLANY5PGygEC9Du4K3n0tjvHu
	 niwZg4uWO250i47/RLJLJDaXS/vE6ay6oEJgfHsD6thG1pxOG7ztFpTiW2YyZv2nTN
	 L0COdKNL3CMFn3UP+/4ulIA1Cc/dL/X/1X5hjUE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/194] serial: stm32: Ignore return value of uart_remove_one_port() in .remove()
Date: Mon, 21 Aug 2023 21:40:20 +0200
Message-ID: <20230821194124.611096683@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 6bd6cd29c92401a101993290051fa55078238a52 ]

Returning early from stm32_usart_serial_remove() results in a resource
leak as several cleanup functions are not called. The driver core ignores
the return value and there is no possibility to clean up later.

uart_remove_one_port() only returns non-zero if there is some
inconsistency (i.e. stm32_usart_driver.state[port->line].uart_port == NULL).
This should never happen, and even if it does it's a bad idea to exit
early in the remove callback without cleaning up.

This prepares changing the prototype of struct platform_driver::remove to
return void. See commit 5c5a7680e67b ("platform: Provide a remove callback
that returns no value") for further details about this quest.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20230512173810.131447-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index 28edbaf7bb329..2a9c4058824a8 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -1753,13 +1753,10 @@ static int stm32_usart_serial_remove(struct platform_device *pdev)
 	struct uart_port *port = platform_get_drvdata(pdev);
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
-	int err;
 	u32 cr3;
 
 	pm_runtime_get_sync(&pdev->dev);
-	err = uart_remove_one_port(&stm32_usart_driver, port);
-	if (err)
-		return(err);
+	uart_remove_one_port(&stm32_usart_driver, port);
 
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
-- 
2.40.1



