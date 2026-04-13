Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FFFE3093B2;
	Mon, 13 Apr 2026 16:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097625; cv=none; b=Sicoap6cvdLWCuYj8XX+B6dpdh1f+o5K8/HXpCGYmTnXMEj/VkB3s5aeejN6+rd57XU0eT88CFYt5jLG6Dp4vzwR/nZXcs1N4QkS9dW/o8+6yDeHUL1Pcn49V2ILrlhXjdH8lEog9tAbAAnsxvFTAAaOm7FSl3Af886tYdZsjPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097625; c=relaxed/simple;
	bh=VSp9Z7Joel7cAInllUSf43fjxNyr8KtejRsOnp0f52E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4imI9Rwcg7NAhkpOeHLUwzIkL6YQYfs4Z+UdUbfQtwQuF78wC+FF5RDfi/kztsd9WpQjGZbsUIgxf3ZngOFcnvB8/BxAALEmNpQTt0G3i1txI5AM7UvfRJYuATNWs5H9/BI9qBwHNbP3Czk1ILtHv5gDqzWgtSL03ckIeLdijc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JMvQ7I8G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JMvQ7I8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15EE9C2BCAF;
	Mon, 13 Apr 2026 16:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097625;
	bh=VSp9Z7Joel7cAInllUSf43fjxNyr8KtejRsOnp0f52E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JMvQ7I8Gm45G+D3UmbDw8tc0EO0nL4D51+2BtT+C1gSNmqCPkW0er2qmW7k1dg7uc
	 z1Kd2p4BDNjEd7SGzpfxgYRStACRzOUYQhpbObwZouj/mVlhoRC4qvzdFbeXHhQnC3
	 LnMbnAXOTYiUzebLwJsrc9gwW29CPyWTAfaLZJQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Raul E Rangel <rrangel@google.com>
Subject: [PATCH 5.15 210/570] serial: 8250: Fix TX deadlock when using DMA
Date: Mon, 13 Apr 2026 17:55:41 +0200
Message-ID: <20260413155838.324491566@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raul E Rangel <rrangel@chromium.org>

commit a424a34b8faddf97b5af41689087e7a230f79ba7 upstream.

`dmaengine_terminate_async` does not guarantee that the
`__dma_tx_complete` callback will run. The callback is currently the
only place where `dma->tx_running` gets cleared. If the transaction is
canceled and the callback never runs, then `dma->tx_running` will never
get cleared and we will never schedule new TX DMA transactions again.

This change makes it so we clear `dma->tx_running` after we terminate
the DMA transaction. This is "safe" because `serial8250_tx_dma_flush`
is holding the UART port lock. The first thing the callback does is also
grab the UART port lock, so access to `dma->tx_running` is serialized.

Fixes: 9e512eaaf8f4 ("serial: 8250: Fix fifo underflow on flush")
Cc: stable <stable@kernel.org>
Signed-off-by: Raul E Rangel <rrangel@google.com>
Link: https://patch.msgid.link/20260209135815.1.I16366ecb0f62f3c96fe3dd5763fcf6f3c2b4d8cd@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_dma.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -150,7 +150,22 @@ void serial8250_tx_dma_flush(struct uart
 	 */
 	dma->tx_size = 0;
 
+	/*
+	 * We can't use `dmaengine_terminate_sync` because `uart_flush_buffer` is
+	 * holding the uart port spinlock.
+	 */
 	dmaengine_terminate_async(dma->txchan);
+
+	/*
+	 * The callback might or might not run. If it doesn't run, we need to ensure
+	 * that `tx_running` is cleared so that we can schedule new transactions.
+	 * If it does run, then the zombie callback will clear `tx_running` again
+	 * and perform a no-op since `tx_size` was cleared above.
+	 *
+	 * In either case, we ASSUME the DMA transaction will terminate before we
+	 * issue a new `serial8250_tx_dma`.
+	 */
+	dma->tx_running = 0;
 }
 
 int serial8250_rx_dma(struct uart_8250_port *p)


