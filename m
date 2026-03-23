Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783FE3AE19E;
	Mon, 23 Mar 2026 16:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282826; cv=none; b=Zt/icAqPH3BzaXBuiWNC/sCVAhN2xfZ67lpbiiX7JlEXRY08ohkyNnxkK+9FFh/+b+1s0NZBVxws0733BIa2EsLqw17WFRREDvwDMUq0A4U475ypSH1EsIxCpyOzh6+ynxJnIxNRn7qurLkCMQgEVbbrn7E2C9dFRaa78pO0hDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282826; c=relaxed/simple;
	bh=+wZkQuNPCz9BmeXvZ4lqfwrY0OEl7Jjqi2eIviyQHh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FomQATNG3rKyyrSSa0XDYazYBgKmDAU2qNGamiVl7c36rCmVrNc+QEEuOwYa/l/FAzHzHkW6mxjXHdbchfXWbgwgITE+pLf57N+u5gm3aLO0LADyNfS5rjzDqrQ1mKxe448f36y3bXK17+A/xK0Xbx6e5Q+Zw/LlkKVMuz6CYt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vDqcJIOZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vDqcJIOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A63BC4CEF7;
	Mon, 23 Mar 2026 16:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282826;
	bh=+wZkQuNPCz9BmeXvZ4lqfwrY0OEl7Jjqi2eIviyQHh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vDqcJIOZfSA/4g6amtThZX3iIEoVtTNqhIx1Q8GpxBnZEAI4q3QR0AfC0a4cboJip
	 tR4HMpfiDTtGgnncCbpeJD5Nm/OKGNEzeQtxT1wjzQg52/+1KPiWaiucmJ+6GGK9KM
	 4/03R3BZoMtbYQr5/hnFOGumFdmzQjIvaIXyziQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Raul E Rangel <rrangel@google.com>
Subject: [PATCH 6.1 300/481] serial: 8250: Fix TX deadlock when using DMA
Date: Mon, 23 Mar 2026 14:44:42 +0100
Message-ID: <20260323134532.426226289@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -146,7 +146,22 @@ void serial8250_tx_dma_flush(struct uart
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


