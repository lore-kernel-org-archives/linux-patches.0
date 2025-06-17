Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4101F2FA625;
	Tue, 17 Jun 2025 16:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178479; cv=none; b=q+pXW8HFPTNz1kCbk29TCzMl21mDHb2lK4uCCTrAntGPnCopUzhZ2Ew76f04yiPuCDuv6mx3HEVislnaxOWfnicHNbjUnmLoxphCgtZsuYw61OGkiQMe0iHEwokPOSY25oa/wMvNq3GrPy+HBuO/y0NtC53d/jwd+Ar3A5pDusY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178479; c=relaxed/simple;
	bh=Jxvl1E82BpgHq7lf6Khh4VNHWyxjv7bnTJ6dRaxagNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t6fH/rDLYbqoaK6xOVgv0pUbOvzxohpR14ULZ1jFh6DNfgAAnh0gX8NOHTNRjRxH2sEHGxS2f2uzPehm7q/4vrFia8Xl5C/8jv5pNeMuIX6OknupaW7sNH9kx97FAuaQfYM9Kgz4f5aN8sPwgqmP6w3IJroJUcb+6DUHI0f/OwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ncWaut6z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ncWaut6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A562DC4CEE3;
	Tue, 17 Jun 2025 16:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178479;
	bh=Jxvl1E82BpgHq7lf6Khh4VNHWyxjv7bnTJ6dRaxagNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ncWaut6z9pm3kiUenZwBbou9LMVvB8o5sNh2rWsMmZYkKEq1jeHlX/kS37Uyt5z3S
	 lFY1MBtNZ8/ciqd4fyY77a9XVXqn6DUCnauPnpivfRMaKIXCUoZGWJAh31gt2lG7Ax
	 FMjeu8gsglHv4JMQZX0Z4HVxSDYg1RXNDT43RUH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Mans Rullgard <mans@mansr.com>
Subject: [PATCH 6.12 491/512] tty: serial: 8250_omap: fix TX with DMA for am33xx
Date: Tue, 17 Jun 2025 17:27:37 +0200
Message-ID: <20250617152439.526983064@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

commit b495021a973e2468497689bd3e29b736747b896f upstream.

Commit 1788cf6a91d9 ("tty: serial: switch from circ_buf to kfifo")
introduced an error in the TX DMA handling for 8250_omap.

When the OMAP_DMA_TX_KICK flag is set, the "skip_byte" is pulled from
the kfifo and emitted directly in order to start the DMA. While the
kfifo is updated, dma->tx_size is not decreased. This leads to
uart_xmit_advance() called in omap_8250_dma_tx_complete() advancing the
kfifo by one too much.

In practice, transmitting N bytes has been seen to result in the last
N-1 bytes being sent repeatedly.

This change fixes the problem by moving all of the dma setup after the
OMAP_DMA_TX_KICK handling and using kfifo_len() instead of the DMA size
for the 4-byte cutoff check. This slightly changes the behaviour at
buffer wraparound, but it still transmits the correct bytes somehow.

Now, the "skip_byte" would no longer be accounted to the stats. As
previously, dma->tx_size included also this skip byte, up->icount.tx was
updated by aforementioned uart_xmit_advance() in
omap_8250_dma_tx_complete(). Fix this by using the uart_fifo_out()
helper instead of bare kfifo_get().

Based on patch by Mans Rullgard <mans@mansr.com>

Signed-off-by: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Fixes: 1788cf6a91d9 ("tty: serial: switch from circ_buf to kfifo")
Link: https://lore.kernel.org/all/20250506150748.3162-1-mans@mansr.com/
Reported-by: Mans Rullgard <mans@mansr.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250522053835.3495975-1-jirislaby@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_omap.c |   25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -1168,16 +1168,6 @@ static int omap_8250_tx_dma(struct uart_
 		return 0;
 	}
 
-	sg_init_table(&sg, 1);
-	ret = kfifo_dma_out_prepare_mapped(&tport->xmit_fifo, &sg, 1,
-					   UART_XMIT_SIZE, dma->tx_addr);
-	if (ret != 1) {
-		serial8250_clear_THRI(p);
-		return 0;
-	}
-
-	dma->tx_size = sg_dma_len(&sg);
-
 	if (priv->habit & OMAP_DMA_TX_KICK) {
 		unsigned char c;
 		u8 tx_lvl;
@@ -1202,18 +1192,22 @@ static int omap_8250_tx_dma(struct uart_
 			ret = -EBUSY;
 			goto err;
 		}
-		if (dma->tx_size < 4) {
+		if (kfifo_len(&tport->xmit_fifo) < 4) {
 			ret = -EINVAL;
 			goto err;
 		}
-		if (!kfifo_get(&tport->xmit_fifo, &c)) {
+		if (!uart_fifo_out(&p->port, &c, 1)) {
 			ret = -EINVAL;
 			goto err;
 		}
 		skip_byte = c;
-		/* now we need to recompute due to kfifo_get */
-		kfifo_dma_out_prepare_mapped(&tport->xmit_fifo, &sg, 1,
-				UART_XMIT_SIZE, dma->tx_addr);
+	}
+
+	sg_init_table(&sg, 1);
+	ret = kfifo_dma_out_prepare_mapped(&tport->xmit_fifo, &sg, 1, UART_XMIT_SIZE, dma->tx_addr);
+	if (ret != 1) {
+		ret = -EINVAL;
+		goto err;
 	}
 
 	desc = dmaengine_prep_slave_sg(dma->txchan, &sg, 1, DMA_MEM_TO_DEV,
@@ -1223,6 +1217,7 @@ static int omap_8250_tx_dma(struct uart_
 		goto err;
 	}
 
+	dma->tx_size = sg_dma_len(&sg);
 	dma->tx_running = 1;
 
 	desc->callback = omap_8250_dma_tx_complete;


