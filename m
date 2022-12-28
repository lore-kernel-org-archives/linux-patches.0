Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E961868
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:27:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2524CC433F0;
	Wed, 28 Dec 2022 15:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241253;
	bh=d5AT1t18jRg+EHlRlDa4fgW/bB1AD/80ldiTVQYxRzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wWmAcxt3sqyCeE/SshUE5JZ9X/sw36I2Bvd9zMY5KsirZAu1tPeYfjmE/4/AHjRjs
	 3uB3aUGERstwlDbraW15CE9BdmCTtnsABSdF2zmZJabXakdqGpKcWBcRVVbXWs7qAz
	 zn1hzYUc6tBjs5z6itOvhcx34cU7Ppcx1Z1Q6XsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	delisun <delisun@pateo.com.cn>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 458/731] serial: pl011: Do not clear RX FIFO & RX interrupt in unthrottle.
Date: Wed, 28 Dec 2022 15:39:25 +0100
Message-Id: <20221228144309.829191330@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: delisun <delisun@pateo.com.cn>

[ Upstream commit 032d5a71ed378ffc6a2d41a187d8488a4f9fe415 ]

Clearing the RX FIFO will cause data loss.
Copy the pl011_enabl_interrupts implementation, and remove the clear
interrupt and FIFO part of the code.

Fixes: 211565b10099 ("serial: pl011: UPSTAT_AUTORTS requires .throttle/unthrottle")
Signed-off-by: delisun <delisun@pateo.com.cn>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20221110020108.7700-1-delisun@pateo.com.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/amba-pl011.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index ca105e9baa42..7c8515f83f0a 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1836,8 +1836,17 @@ static void pl011_enable_interrupts(struct uart_amba_port *uap)
 static void pl011_unthrottle_rx(struct uart_port *port)
 {
 	struct uart_amba_port *uap = container_of(port, struct uart_amba_port, port);
+	unsigned long flags;
 
-	pl011_enable_interrupts(uap);
+	spin_lock_irqsave(&uap->port.lock, flags);
+
+	uap->im = UART011_RTIM;
+	if (!pl011_dma_rx_running(uap))
+		uap->im |= UART011_RXIM;
+
+	pl011_write(uap->im, uap, REG_IMSC);
+
+	spin_unlock_irqrestore(&uap->port.lock, flags);
 }
 
 static int pl011_startup(struct uart_port *port)
-- 
2.35.1



