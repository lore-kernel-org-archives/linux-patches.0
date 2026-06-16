Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5334C3AE1A2;
	Tue, 16 Jun 2026 18:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635830; cv=none; b=uRf0bE+k4LX3YawC+syMI00mwmyaRt1F3z3JZPjesJp1ylJifVe6XiNEZPJFrbIkSPPif2DnmoW/gSrwQESsMFmk5xnBESSJ/1YLA5xWGd9fFmpMqCmWjL6zGfr/8MBfdZ1rhP/XNQ5aTmiOaxeDLquU2kFhGLhiuEFnmPSUWe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635830; c=relaxed/simple;
	bh=Njep/D6UCmcf9WKMNE8+9s9WXNaU84OCdXRUAjIUmV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZdBnjZMFGuvq1obk4+sVqxKhndw8q/sd+k1HQQGSHtUxRN2HErDrU9q0WBEJzRyNFwYWm2dX2jzDL/pCcTDrlYmSJ2ZHHf+yFqPO6jjtWGzr+gjEo+hQn0yMMW9BvYfxcdeXLuBKF2mXw/YTMJt2DlvL1tCy8dQR5/sFa9Ez9Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bRse9W8P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bRse9W8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BB01F000E9;
	Tue, 16 Jun 2026 18:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635829;
	bh=bdfGMbgDngfPlWmHQmdhJ159uD65IlUW2QbjYNaobL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bRse9W8P8WXCQ0XUtnz0VuGgy3Fho+p6IzsEGK9OCtzfhDW1WhI9Qru5X+S7vFlVE
	 ekXeyp43Sa0VQdtPxeK+7ThEYZpn6goVsrMN9o2X0gNNv2M9kVZXyE05ETTi7dPvCK
	 3ndGkpXS44WT7XhECcxf+GQATu6F60BrsWaNKBKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Zhaoyang Yu <2426767509@qq.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.10 089/342] tty: serial: pch_uart: add check for dma_alloc_coherent()
Date: Tue, 16 Jun 2026 20:26:25 +0530
Message-ID: <20260616145052.388529396@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -711,8 +711,7 @@ static void pch_request_dma(struct uart_
 	if (!chan) {
 		dev_err(priv->port.dev, "%s:dma_request_channel FAILS(Tx)\n",
 			__func__);
-		pci_dev_put(dma_dev);
-		return;
+		goto err_pci_get;
 	}
 	priv->chan_tx = chan;
 
@@ -726,18 +725,26 @@ static void pch_request_dma(struct uart_
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


