Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF25285CA4;
	Sun,  7 Jun 2026 10:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829137; cv=none; b=AAnMrGog21AfHjaUa08n5fz7f3BaWJKS3Gqr90RIDA4rgjT1ATyqPUODPTA3ZCzpsB0SYDycYbcgY5aPt4adFjv7zvv9EWhC+9T/vBXylxbXLML143UMwtoyfOscoBxQaNNW8IE3fehsFfejVM7lkFFLfNFAQf2E5siZjF/x7Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829137; c=relaxed/simple;
	bh=zpV9mj4q/6bQrqAH9dkh/e9XKqHlBU+iS6/Uwsxiu9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=agCdiwe8J/HAL/HHFksfSEY5/M6EB9rx4Z7mi4k1vE0J182BhV2g05iJJ8AVT6APYMiOaK9qL4XZZ00AiOpG0b4suW7LoAhmSwKugmajlXyTA9rL0ptirFXXGa+dcPEQagmV9h66LYNDhh/ycHl8jGbsmrR3CouDbfNzGy00bdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FwvqxjBq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FwvqxjBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45671F00893;
	Sun,  7 Jun 2026 10:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829136;
	bh=U1peWhDutOzZFzbzGpZ/nhFaYWiP26PCe4G1GJEpv/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FwvqxjBqLP2TiYCNOmZMqy9gffW9x2yyay+ZGjjFnDDtGR0fiLJYDVjhq2RLXRdbx
	 22kfZ99W2QY87VFV3RehpzDn+1KZKRY9WJJQcFJPofjokqsD6tXnjviFvVruNom2+V
	 KZedZyU3edDPsfnmCb7NUunPkWru+aOe4u0nMZKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Zhaoyang Yu <2426767509@qq.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.18 220/315] tty: serial: pch_uart: add check for dma_alloc_coherent()
Date: Sun,  7 Jun 2026 12:00:07 +0200
Message-ID: <20260607095735.658445385@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhaoyang Yu <2426767509@qq.com>

commit 6fe472c1bbbe238e91141f7cabc1226e96a60d43 upstream.

Add a check for dma_alloc_coherent() failure to prevent a potential
NULL pointer dereference in dma_handle_rx(). Properly release DMA
channels and the PCI device reference using a goto ladder if the
allocation fails.

Fixes: 3c6a483275f4 ("Serial: EG20T: add PCH_UART driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Zhaoyang Yu <2426767509@qq.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/tencent_E328416B7CFD436F6029F2DF02AD7ED89C08@qq.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/pch_uart.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -689,8 +689,7 @@ static void pch_request_dma(struct uart_
 	if (!chan) {
 		dev_err(priv->port.dev, "%s:dma_request_channel FAILS(Tx)\n",
 			__func__);
-		pci_dev_put(dma_dev);
-		return;
+		goto err_pci_get;
 	}
 	priv->chan_tx = chan;
 
@@ -704,18 +703,26 @@ static void pch_request_dma(struct uart_
 	if (!chan) {
 		dev_err(priv->port.dev, "%s:dma_request_channel FAILS(Rx)\n",
 			__func__);
-		dma_release_channel(priv->chan_tx);
-		priv->chan_tx = NULL;
-		pci_dev_put(dma_dev);
-		return;
+		goto err_req_tx;
 	}
 
 	/* Get Consistent memory for DMA */
 	priv->rx_buf_virt = dma_alloc_coherent(port->dev, port->fifosize,
 				    &priv->rx_buf_dma, GFP_KERNEL);
+	if (!priv->rx_buf_virt)
+		goto err_req_rx;
 	priv->chan_rx = chan;
 
 	pci_dev_put(dma_dev);
+	return;
+
+err_req_rx:
+	dma_release_channel(chan);
+err_req_tx:
+	dma_release_channel(priv->chan_tx);
+	priv->chan_tx = NULL;
+err_pci_get:
+	pci_dev_put(dma_dev);
 }
 
 static void pch_dma_rx_complete(void *arg)


