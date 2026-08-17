Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4A7439F71;
	Mon, 17 Aug 2026 14:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978634; cv=none; b=c7S6jM2Cu/FL8v9BZIb8DeD2AfbSzTO/c8g1rthkowZIDH9aqoBkckDl7oOAe6Y5bJlK5xvvm1rdIXqov/jupPKvY0ayQSVXsVQWO2Sl9ZZNx+a/zCxfnZjbV/VY+1wUy+nzM70+KiCR8NCLrs0Hr90m9uBCHz6MtHq3Heqzjqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978634; c=relaxed/simple;
	bh=Lho1nqe/mG7QcUp8OUoooWrZZuzaOCOaG8gN69lZ1gU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KouLKVqSOFaZSvXXRgCVrFXebl70fwieQ/pw6rt6dxe2HALGmFFPSxQ/t5cljXZyL/vnC9zE+jhuQm7OI568k7phOBfDtuWwwjhUsTBcFMWcWG9XppocGIVyXbxzo33CKBjUkkSL6AByOClr8f7tP1RdxBjY/X8yw45Abe+OyLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Elb6tv+r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Elb6tv+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003421F000E9;
	Mon, 17 Aug 2026 14:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978633;
	bh=qugTl5J82LJVko98QTSUc4hYa/i2wClcaxReyXTHR7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Elb6tv+rowpT/BOFrU8hdngZgEFvm4J0uvfYND9e873hNqem1ajxXi+/ZFbmhWeZs
	 1FqU7ysyTX4x0Kuoc+htahzGjyKjRwWvlUaSpik6w80SPAkdD+US8hkF08BatgYST8
	 YW75l76XfO0IE+u0u3FmpimL2nsdN2M6dJvCIssk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Cunhao Lu <1579567540@qq.com>
Subject: [PATCH 6.6 104/156] serial: 8250_dma: Clear stale RX state on shutdown
Date: Mon, 17 Aug 2026 15:33:58 +0200
Message-ID: <20260817132538.688216498@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -201,11 +201,12 @@ void serial8250_rx_dma_flush(struct uart
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
 
@@ -314,6 +315,7 @@ void serial8250_release_dma(struct uart_
 
 	/* Release RX resources */
 	dmaengine_terminate_sync(dma->rxchan);
+	dma->rx_running = 0;
 	dma_free_coherent(dma->rxchan->device->dev, dma->rx_size, dma->rx_buf,
 			  dma->rx_addr);
 	dma_release_channel(dma->rxchan);


