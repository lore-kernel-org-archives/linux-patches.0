Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9302596
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7445DC433EF;
	Sun, 22 Jan 2023 15:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400429;
	bh=0KAmPp0KnZxWX4uPI6TiN52TewChr6TWlZBRkhz/p1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cIiLbEkmVLo+7Gi9B/PtggH+NpzGaQ34s5a+IkC9DjnU+8nxzSYAk2ZclpqKGa4Be
	 J5dG0iCFzhWwk+FgFEh4HXuzrUNql2zuoUebTabxv9M7EHR1fT+INsT6ArEWQjn2AS
	 yIzvjD9S6JE3plvxS+zvypCAzg3XV5C0A2KIk5vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 5.10 71/98] serial: pch_uart: Pass correct sg to dma_unmap_sg()
Date: Sun, 22 Jan 2023 16:04:27 +0100
Message-Id: <20230122150232.442893287@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
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

commit e8914b52e5b024e4af3d810a935fe0805eee8a36 upstream.

A local variable sg is used to store scatterlist pointer in
pch_dma_tx_complete(). The for loop doing Tx byte accounting before
dma_unmap_sg() alters sg in its increment statement. Therefore, the
pointer passed into dma_unmap_sg() won't match to the one given to
dma_map_sg().

To fix the problem, use priv->sg_tx_p directly in dma_unmap_sg()
instead of the local variable.

Fixes: da3564ee027e ("pch_uart: add multi-scatter processing")
Cc: stable@vger.kernel.org
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20230103093435.4396-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/pch_uart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -769,7 +769,7 @@ static void pch_dma_tx_complete(void *ar
 	}
 	xmit->tail &= UART_XMIT_SIZE - 1;
 	async_tx_ack(priv->desc_tx);
-	dma_unmap_sg(port->dev, sg, priv->orig_nent, DMA_TO_DEVICE);
+	dma_unmap_sg(port->dev, priv->sg_tx_p, priv->orig_nent, DMA_TO_DEVICE);
 	priv->tx_dma_use = 0;
 	priv->nent = 0;
 	priv->orig_nent = 0;


