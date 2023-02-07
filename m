Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861B82C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64DDC433D2;
	Tue,  7 Feb 2023 13:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775267;
	bh=Qy9oP3CzI3Oankw7lC/i5K5NR5VCL27Mjd98tOl0z9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F9BdSH5HHk2EsM78lEXZCOApcgdCkBD6PTvFlF19KNc2VWzCcDXQtt6Zme2a4KAUf
	 Puk1Et/I9fJks4ygOP9zyTEfp8VtlRdQZWeKtY57OJJrJgvYkWxZW2F9U3IDMp0S0Q
	 JqpGQ4gDNcyfdfBEurF7TMp75tMIaqRWSzi14/sY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gilles BULOZ <gilles.buloz@kontron.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.1 193/208] serial: 8250_dma: Fix DMA Rx rearm race
Date: Tue,  7 Feb 2023 13:57:27 +0100
Message-Id: <20230207125643.230139389@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
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

commit 57e9af7831dcf211c5c689c2a6f209f4abdf0bce upstream.

As DMA Rx can be completed from two places, it is possible that DMA Rx
completes before DMA completion callback had a chance to complete it.
Once the previous DMA Rx has been completed, a new one can be started
on the next UART interrupt. The following race is possible
(uart_unlock_and_check_sysrq_irqrestore() replaced with
spin_unlock_irqrestore() for simplicity/clarity):

CPU0					CPU1
					dma_rx_complete()
serial8250_handle_irq()
  spin_lock_irqsave(&port->lock)
  handle_rx_dma()
    serial8250_rx_dma_flush()
      __dma_rx_complete()
        dma->rx_running = 0
        // Complete DMA Rx
  spin_unlock_irqrestore(&port->lock)

serial8250_handle_irq()
  spin_lock_irqsave(&port->lock)
  handle_rx_dma()
    serial8250_rx_dma()
      dma->rx_running = 1
      // Setup a new DMA Rx
  spin_unlock_irqrestore(&port->lock)

					  spin_lock_irqsave(&port->lock)
					  // sees dma->rx_running = 1
					  __dma_rx_complete()
					    dma->rx_running = 0
					    // Incorrectly complete
					    // running DMA Rx

This race seems somewhat theoretical to occur for real but handle it
correctly regardless. Check what is the DMA status before complething
anything in __dma_rx_complete().

Reported-by: Gilles BULOZ <gilles.buloz@kontron.com>
Tested-by: Gilles BULOZ <gilles.buloz@kontron.com>
Fixes: 9ee4b83e51f7 ("serial: 8250: Add support for dmaengine")
Cc: stable@vger.kernel.org
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20230130114841.25749-3-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_dma.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -44,15 +44,23 @@ static void __dma_rx_complete(void *para
 	struct uart_8250_dma	*dma = p->dma;
 	struct tty_port		*tty_port = &p->port.state->port;
 	struct dma_tx_state	state;
+	enum dma_status		dma_status;
 	int			count;
 
-	dma->rx_running = 0;
-	dmaengine_tx_status(dma->rxchan, dma->rx_cookie, &state);
+	/*
+	 * New DMA Rx can be started during the completion handler before it
+	 * could acquire port's lock and it might still be ongoing. Don't to
+	 * anything in such case.
+	 */
+	dma_status = dmaengine_tx_status(dma->rxchan, dma->rx_cookie, &state);
+	if (dma_status == DMA_IN_PROGRESS)
+		return;
 
 	count = dma->rx_size - state.residue;
 
 	tty_insert_flip_string(tty_port, dma->rx_buf, count);
 	p->port.icount.rx += count;
+	dma->rx_running = 0;
 
 	tty_flip_buffer_push(tty_port);
 }


