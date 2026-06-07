Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8462D8378;
	Sun,  7 Jun 2026 10:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829134; cv=none; b=YHsQft96dtj6YIKpG6P3B1sYqo/i1TD0enpMUYeMYTaiP9e00ex3saE7k6FARvGr0xZgMLNhYS6CAJ3bN1w6/SGnWRHuc3T7E/uyFoFRBlcZ3XKgzJ7mLk9/g09/5CqEQN/UWQzO9nFxvDmQ9w1LiaJ0U7k4h4Ys333ZScawrgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829134; c=relaxed/simple;
	bh=GNuRBi12EYkYnLNX7AgotnIp29X5S6FAJzJLeWg7hcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rnyklNVaTbjATDDwJFidiAFcwr1+VQOK2buFiMak0bo73piYZj3RoW+CsB+XBJfAIxm+10qAhgf/9jnTKQvS6Q0c3wnV86NDhibNw6xkD71YyNmYjyvzK4HFdu3uHkxm3pr2SIhcdGn3VSWSZhkivBbDXE8ZoGBxboUJQgQrwVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kcd0t1ZK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kcd0t1ZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908EC1F00893;
	Sun,  7 Jun 2026 10:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829133;
	bh=WqtGRCxw6tZe+xiewjQ3qTbSjQwNtQLjBSnKYyKujJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kcd0t1ZK5m0jJikLKQLoxIS0lISKQawZuySNCcZwsBQAAGdugTFAwZhR4kNeEe9rS
	 5LWH0XOSmI5GPnr5OBDG0zEBPhnFEi1ojZBrBf8obnrk6/INNPyoZKJ9MSU4N1NJ+i
	 mE72EhK4/+j8ZX6Gpt9PhOkkvnmboEqr7TLph3Zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Zhaoyang Yu <2426767509@qq.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 7.0 248/332] tty: serial: pch_uart: add check for dma_alloc_coherent()
Date: Sun,  7 Jun 2026 12:00:17 +0200
Message-ID: <20260607095737.158204572@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


