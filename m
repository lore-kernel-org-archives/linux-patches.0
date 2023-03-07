Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00453BA34
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE58C433D2;
	Tue,  7 Mar 2023 17:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210341;
	bh=AJslyw4d2AombI42miWC+tWmcPS6kuHhGNmdBY459S4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F6c/VBn0EIz1AJylxxxdr+aWdG9fnz+Xhntc1rftXyknFghpf9jZQLVKU5cITyjJS
	 3kcb9jxst2w+I4Me8TktHDQ+SUQOlMSOzatf0q6yAB4dV64kpRTKYhU9tqZX4I+Lyi
	 LCWq9317j9TBInfQJPsGo6aIzbicZuVHzwK07IYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sherry Sun <sherry.sun@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0510/1001] tty: serial: fsl_lpuart: disable Rx/Tx DMA in lpuart32_shutdown()
Date: Tue,  7 Mar 2023 17:54:42 +0100
Message-Id: <20230307170043.560268040@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

[ Upstream commit 1d4bd0e4ae4ba95892bef919a8d4d3f08f122d7e ]

UARTBAUD_RDMAE and UARTBAUD_TDMAE are enabled in lpuart32_startup(), but
lpuart32_shutdown() not disable them, only free the dma ring buffer and
release the dma channels, so here disable the Rx/Tx DMA first in
lpuart32_shutdown().

Fixes: 42b68768e51b ("serial: fsl_lpuart: DMA support for 32-bit variant")
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Link: https://lore.kernel.org/r/20221125101953.18753-3-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/fsl_lpuart.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 5e69fb73f570f..5d1c28e094bb2 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1796,6 +1796,11 @@ static void lpuart32_shutdown(struct uart_port *port)
 
 	spin_lock_irqsave(&port->lock, flags);
 
+	/* disable Rx/Tx DMA */
+	temp = lpuart32_read(port, UARTBAUD);
+	temp &= ~(UARTBAUD_TDMAE | UARTBAUD_RDMAE);
+	lpuart32_write(port, temp, UARTBAUD);
+
 	/* disable Rx/Tx and interrupts */
 	temp = lpuart32_read(port, UARTCTRL);
 	temp &= ~(UARTCTRL_TE | UARTCTRL_RE |
-- 
2.39.2



