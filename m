Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C416BA4C
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:00:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041CBC4339B;
	Tue,  7 Mar 2023 19:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215655;
	bh=K2WIlPJSJylxOrtnROq0JI8ij+mr/WEIwAoQPsmNMn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HPaFjy/Dj34v03+yf4Mfc1wlp4xQRA+3DQCgzPbRWTDNq/dRCWz1GPJj+RdVXjR6/
	 JUxsQXs3GLU6QMSJ8U5Vz7GYg+6oiZ3R5hk3GTPTasL2rLdyK5298AiDto7NGp0fMi
	 KdSSIIBuolgMQbSXnKUJ7o3P+LEz9Rqjbv1PA5I4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sherry Sun <sherry.sun@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 299/567] tty: serial: fsl_lpuart: clear LPUART Status Register in lpuart32_shutdown()
Date: Tue,  7 Mar 2023 18:00:35 +0100
Message-Id: <20230307165918.824850117@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sherry Sun <sherry.sun@nxp.com>

[ Upstream commit 4029dfc034febb54f6dd8ea83568accc943bc088 ]

The LPUART Status Register needs to be cleared when closing the uart
port to get a clean environment when reopening the uart.

Fixes: 380c966c093e ("tty: serial: fsl_lpuart: add 32-bit register interface support")
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Link: https://lore.kernel.org/r/20221125101953.18753-4-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/fsl_lpuart.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 24f9001d10242..ccfd6dd5fbf4e 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1807,6 +1807,10 @@ static void lpuart32_shutdown(struct uart_port *port)
 
 	spin_lock_irqsave(&port->lock, flags);
 
+	/* clear status */
+	temp = lpuart32_read(&sport->port, UARTSTAT);
+	lpuart32_write(&sport->port, temp, UARTSTAT);
+
 	/* disable Rx/Tx DMA */
 	temp = lpuart32_read(port, UARTBAUD);
 	temp &= ~(UARTBAUD_TDMAE | UARTBAUD_RDMAE);
-- 
2.39.2



