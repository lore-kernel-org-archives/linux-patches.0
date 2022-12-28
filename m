Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8C61863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B685CC433D2;
	Wed, 28 Dec 2022 15:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241272;
	bh=pSQisx6Sl4nDaekEqTZOMxIng/PJE1oDPfYBsR1qefg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2HYH8fASK6w8/u1+KnbOReOC1PFlzYJWZudTJPRA1rA+tBL/lylfany+VIUoic23G
	 m+29gPhe9ats1V4nDod3lxxNHb4pk5BuH+OPbydpTJXsRiXY/kDdY24v0POlXvEd/H
	 HUR0yqdg726L7Y8CZ4yURt69dmxZUvteQD/ifH84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiongfeng Wang <wangxiongfeng2@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 460/731] serial: pch: Fix PCI device refcount leak in pch_request_dma()
Date: Wed, 28 Dec 2022 15:39:27 +0100
Message-Id: <20221228144309.885913504@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit 8be3a7bf773700534a6e8f87f6ed2ed111254be5 ]

As comment of pci_get_slot() says, it returns a pci_device with its
refcount increased. The caller must decrement the reference count by
calling pci_dev_put().

Since 'dma_dev' is only used to filter the channel in filter(), we can
call pci_dev_put() before exiting from pch_request_dma(). Add the
missing pci_dev_put() for the normal and error path.

Fixes: 3c6a483275f4 ("Serial: EG20T: add PCH_UART driver")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Link: https://lore.kernel.org/r/20221122114559.27692-1-wangxiongfeng2@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/pch_uart.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 1e65933f6cce..52cab2038da8 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -707,6 +707,7 @@ static void pch_request_dma(struct uart_port *port)
 	if (!chan) {
 		dev_err(priv->port.dev, "%s:dma_request_channel FAILS(Tx)\n",
 			__func__);
+		pci_dev_put(dma_dev);
 		return;
 	}
 	priv->chan_tx = chan;
@@ -723,6 +724,7 @@ static void pch_request_dma(struct uart_port *port)
 			__func__);
 		dma_release_channel(priv->chan_tx);
 		priv->chan_tx = NULL;
+		pci_dev_put(dma_dev);
 		return;
 	}
 
@@ -730,6 +732,8 @@ static void pch_request_dma(struct uart_port *port)
 	priv->rx_buf_virt = dma_alloc_coherent(port->dev, port->fifosize,
 				    &priv->rx_buf_dma, GFP_KERNEL);
 	priv->chan_rx = chan;
+
+	pci_dev_put(dma_dev);
 }
 
 static void pch_dma_rx_complete(void *arg)
-- 
2.35.1



