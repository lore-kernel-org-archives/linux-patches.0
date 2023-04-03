Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F60E6FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:37:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFE1C4339B;
	Mon,  3 Apr 2023 14:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532623;
	bh=tdzRrGI/GBqPXJgmbWSrzj1vPupFlwoZ94TbPU9gWXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oD7sDOMiWlYOBOBvzCSE8UxdmShZG3i2wq1S9rvrLQt6sDgXpCdyo7wcAFKM9+z/w
	 8nngnRTeVJOfFm4YW8tZ0pOpfXyYxwGePXlTgMLmr5ORcLx/QZDw194UVPQqqWqlPX
	 T3cWkBs6a0+mp343jsr5RIClPoKhRxEyIOzMfy60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/181] tty: serial: fsl_lpuart: fix race on RX DMA shutdown
Date: Mon,  3 Apr 2023 16:07:39 +0200
Message-Id: <20230403140415.935093778@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Sverdlin <alexander.sverdlin@siemens.com>

[ Upstream commit 1be6f2b15f902c02e055ae0b419ca789200473c9 ]

>From time to time DMA completion can come in the middle of DMA shutdown:

<process ctx>:				<IRQ>:
lpuart32_shutdown()
  lpuart_dma_shutdown()
    del_timer_sync()
					lpuart_dma_rx_complete()
					  lpuart_copy_rx_to_tty()
					    mod_timer()
    lpuart_dma_rx_free()

When the timer fires a bit later, sport->dma_rx_desc is NULL:

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000004
pc : lpuart_copy_rx_to_tty+0xcc/0x5bc
lr : lpuart_timer_func+0x1c/0x2c
Call trace:
 lpuart_copy_rx_to_tty
 lpuart_timer_func
 call_timer_fn
 __run_timers.part.0
 run_timer_softirq
 __do_softirq
 __irq_exit_rcu
 irq_exit
 handle_domain_irq
 gic_handle_irq
 call_on_irq_stack
 do_interrupt_handler
 ...

To fix this fold del_timer_sync() into lpuart_dma_rx_free() after
dmaengine_terminate_sync() to make sure timer will not be re-started in
lpuart_copy_rx_to_tty() <= lpuart_dma_rx_complete().

Fixes: 4a8588a1cf86 ("serial: fsl_lpuart: delete timer on shutdown")
Cc: stable <stable@kernel.org>
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Link: https://lore.kernel.org/r/20230309134302.74940-2-alexander.sverdlin@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/fsl_lpuart.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 86e96696ab26d..cd98c04de0330 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1334,6 +1334,7 @@ static void lpuart_dma_rx_free(struct uart_port *port)
 	struct dma_chan *chan = sport->dma_rx_chan;
 
 	dmaengine_terminate_sync(chan);
+	del_timer_sync(&sport->lpuart_timer);
 	dma_unmap_sg(chan->device->dev, &sport->rx_sgl, 1, DMA_FROM_DEVICE);
 	kfree(sport->rx_ring.buf);
 	sport->rx_ring.tail = 0;
@@ -1757,7 +1758,6 @@ static int lpuart32_startup(struct uart_port *port)
 static void lpuart_dma_shutdown(struct lpuart_port *sport)
 {
 	if (sport->lpuart_dma_rx_use) {
-		del_timer_sync(&sport->lpuart_timer);
 		lpuart_dma_rx_free(&sport->port);
 		sport->lpuart_dma_rx_use = false;
 	}
@@ -1917,10 +1917,8 @@ lpuart_set_termios(struct uart_port *port, struct ktermios *termios,
 	 * Since timer function acqures sport->port.lock, need to stop before
 	 * acquring same lock because otherwise del_timer_sync() can deadlock.
 	 */
-	if (old && sport->lpuart_dma_rx_use) {
-		del_timer_sync(&sport->lpuart_timer);
+	if (old && sport->lpuart_dma_rx_use)
 		lpuart_dma_rx_free(&sport->port);
-	}
 
 	spin_lock_irqsave(&sport->port.lock, flags);
 
@@ -2154,10 +2152,8 @@ lpuart32_set_termios(struct uart_port *port, struct ktermios *termios,
 	 * Since timer function acqures sport->port.lock, need to stop before
 	 * acquring same lock because otherwise del_timer_sync() can deadlock.
 	 */
-	if (old && sport->lpuart_dma_rx_use) {
-		del_timer_sync(&sport->lpuart_timer);
+	if (old && sport->lpuart_dma_rx_use)
 		lpuart_dma_rx_free(&sport->port);
-	}
 
 	spin_lock_irqsave(&sport->port.lock, flags);
 
@@ -2850,7 +2846,6 @@ static int __maybe_unused lpuart_suspend(struct device *dev)
 		 * Rx DMA path before suspend and start Rx DMA path on resume.
 		 */
 		if (irq_wake) {
-			del_timer_sync(&sport->lpuart_timer);
 			lpuart_dma_rx_free(&sport->port);
 		}
 
-- 
2.39.2



