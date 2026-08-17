Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14683D3339;
	Mon, 17 Aug 2026 13:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974363; cv=none; b=Jw0fVolPgAIrjK9XfNRERhapvIjS1P2VCu2NjpdMo3Y9N7OII4WSH7O3EhCQzJLKO7P0k4gBm403jcA3MJFqvOSS2sdXAMG/qhpCzeExQz4VK4la7Rr9xV26FJf2H9F6LRhM3B6CQwhrvFACNneHsgsZJ5Un7VDu931yZC2X9Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974363; c=relaxed/simple;
	bh=/Sb8i0Xq5slX6CN/q1fyc6MaZzW6peLWscHMsSzANZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IdHBfL1z+J1noZBLENWKWxzRxL7g6hrmKjitWQgojSnHNa6SYXmgZjYNbujAwMnctyNNFNwQtWQXn0WaxC5oBTeHgBxkEt99OkFDkV+WEZxlY61vRS1DUtNx3So5z1IsBILaFfUf2pfLnjx/6uNqadnNWJy3peEhOD6s0hP6byY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LedXdHac; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LedXdHac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBCB91F000E9;
	Mon, 17 Aug 2026 13:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974359;
	bh=wyYpnONNWQ5XzXGXXKv6yZZUFea50moss7DXYiKz2KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LedXdHacYzx5szK/rT0J1zf3X7Ue4t9WUkuW/5sQc+Xo6KsY0P1LGkhto577VknDe
	 OXBZx8sU0a1y+pIfIKcKQovy4qwJGWM/IRtRMUbymmEVxgzR+eG7mF9Yxse6/hZrFE
	 CYltplO0Ojv0Sj2o0CQGro5CkH5XjLwTvwo61ShA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Cunhao Lu <1579567540@qq.com>
Subject: [PATCH 7.1 179/271] serial: 8250_dma: Clear stale RX state on shutdown
Date: Mon, 17 Aug 2026 15:31:44 +0200
Message-ID: <20260817132544.206051598@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cunhao Lu <1579567540@qq.com>

commit e2fe6a0efecbef00e3ecc2db64dd5afa8c212b41 upstream.

serial8250_release_dma() terminates RX DMA and releases the channel, but
leaves rx_running set.  If the port is closed while an RX transfer is
active, the stale state remains while rxchan is NULL until the channel is
requested again on the next open.

The DesignWare BUSY workaround added by commit a7b9ce39fbe4
("serial: 8250_dw: Ensure BUSY is deasserted") calls
serial8250_rx_dma_flush() from the LCR write path during startup.  This
happens before serial8250_request_dma() obtains a new RX channel.  On
reopen, the stale rx_running state therefore makes the flush path pass a
NULL channel to dmaengine_pause(), causing a kernel Oops.

Clear rx_running after terminating RX DMA, matching the TX cleanup.  Also
make the flush helper return if the DMA object or RX channel is not
available so startup and teardown paths cannot pass a NULL channel to the
DMAengine API.

Fixes: 0fcb7901f9d6 ("tty: serial: 8250_dma: keep own book keeping about RX transfers")
Cc: stable <stable@kernel.org>
Signed-off-by: Cunhao Lu <1579567540@qq.com>
Link: https://patch.msgid.link/tencent_9EE2945F4C933B4D810C73C2D7485E000F06@qq.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_dma.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -211,11 +211,12 @@ void serial8250_rx_dma_flush(struct uart
 {
 	struct uart_8250_dma *dma = p->dma;
 
-	if (dma->rx_running) {
-		dmaengine_pause(dma->rxchan);
-		__dma_rx_complete(p);
-		dmaengine_terminate_async(dma->rxchan);
-	}
+	if (!dma || !dma->rxchan || !dma->rx_running)
+		return;
+
+	dmaengine_pause(dma->rxchan);
+	__dma_rx_complete(p);
+	dmaengine_terminate_async(dma->rxchan);
 }
 EXPORT_SYMBOL_GPL(serial8250_rx_dma_flush);
 
@@ -324,6 +325,7 @@ void serial8250_release_dma(struct uart_
 
 	/* Release RX resources */
 	dmaengine_terminate_sync(dma->rxchan);
+	dma->rx_running = 0;
 	dma_free_coherent(dma->rxchan->device->dev, dma->rx_size, dma->rx_buf,
 			  dma->rx_addr);
 	dma_release_channel(dma->rxchan);


