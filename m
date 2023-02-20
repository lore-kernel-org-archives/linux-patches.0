Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C8563B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:41:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D862C433D2;
	Mon, 20 Feb 2023 13:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900476;
	bh=+Wmm24ybZHRlfUCjQyaHedjeeG1wQx7hwgE3sb1JsNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zbXjoRBoMqOnf/04IbREmAuxOjJ4dv/jX4Z1dke02VDyHI3aoUiqVskEStVMhasXJ
	 +3S5l6qZw04uBXXXTKjFV9+KTK+HU3Zx3bBBMWNIRTbQJXCyx5O1hXy4VQkfy2vWuo
	 8vpn0JfW9rzT/j1Jmb3cn6N7HPT8iAX+7HHGuvSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gilles BULOZ <gilles.buloz@kontron.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 4.19 39/89] serial: 8250_dma: Fix DMA Rx completion race
Date: Mon, 20 Feb 2023 14:35:38 +0100
Message-Id: <20230220133554.515333076@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit 31352811e13dc2313f101b890fd4b1ce760b5fe7 upstream.

__dma_rx_complete() is called from two places:
  - Through the DMA completion callback dma_rx_complete()
  - From serial8250_rx_dma_flush() after IIR_RLSI or IIR_RX_TIMEOUT
The former does not hold port's lock during __dma_rx_complete() which
allows these two to race and potentially insert the same data twice.

Extend port's lock coverage in dma_rx_complete() to prevent the race
and check if the DMA Rx is still pending completion before calling
into __dma_rx_complete().

Reported-by: Gilles BULOZ <gilles.buloz@kontron.com>
Tested-by: Gilles BULOZ <gilles.buloz@kontron.com>
Fixes: 9ee4b83e51f7 ("serial: 8250: Add support for dmaengine")
Cc: stable@vger.kernel.org
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20230130114841.25749-2-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_dma.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -61,6 +61,18 @@ static void __dma_rx_complete(void *para
 	tty_flip_buffer_push(tty_port);
 }
 
+static void dma_rx_complete(void *param)
+{
+	struct uart_8250_port *p = param;
+	struct uart_8250_dma *dma = p->dma;
+	unsigned long flags;
+
+	spin_lock_irqsave(&p->port.lock, flags);
+	if (dma->rx_running)
+		__dma_rx_complete(p);
+	spin_unlock_irqrestore(&p->port.lock, flags);
+}
+
 int serial8250_tx_dma(struct uart_8250_port *p)
 {
 	struct uart_8250_dma		*dma = p->dma;
@@ -126,7 +138,7 @@ int serial8250_rx_dma(struct uart_8250_p
 		return -EBUSY;
 
 	dma->rx_running = 1;
-	desc->callback = __dma_rx_complete;
+	desc->callback = dma_rx_complete;
 	desc->callback_param = p;
 
 	dma->rx_cookie = dmaengine_submit(desc);


