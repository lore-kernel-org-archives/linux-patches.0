Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7231C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:18:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBFBC433D2;
	Wed, 28 Dec 2022 16:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244300;
	bh=Epcd0hG9bjQ6EmjXOX9Lt/Te4kfyUZcwutwROJnJ+4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yEB0LpHkbegcg0arzOU18ghBe5fNSD7g2wzXMRNbfblNVyUKne9D07NUJavGo36/+
	 6qw6T9bIBYlOzlO9h2fuD+KV3H8UBnF0Ff8E4TUZzfva5zDAD8opLrncwa8nTbZmit
	 K9gzr9D5H+zxOuxmRnA6hYkj8qSUL1RTFXRpEv+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiongfeng Wang <wangxiongfeng2@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0687/1073] serial: pch: Fix PCI device refcount leak in pch_request_dma()
Date: Wed, 28 Dec 2022 15:37:55 +0100
Message-Id: <20221228144346.696177052@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index 8a9065e4a903..ec501c3ce033 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -694,6 +694,7 @@ static void pch_request_dma(struct uart_port *port)
 	if (!chan) {
 		dev_err(priv->port.dev, "%s:dma_request_channel FAILS(Tx)\n",
 			__func__);
+		pci_dev_put(dma_dev);
 		return;
 	}
 	priv->chan_tx = chan;
@@ -710,6 +711,7 @@ static void pch_request_dma(struct uart_port *port)
 			__func__);
 		dma_release_channel(priv->chan_tx);
 		priv->chan_tx = NULL;
+		pci_dev_put(dma_dev);
 		return;
 	}
 
@@ -717,6 +719,8 @@ static void pch_request_dma(struct uart_port *port)
 	priv->rx_buf_virt = dma_alloc_coherent(port->dev, port->fifosize,
 				    &priv->rx_buf_dma, GFP_KERNEL);
 	priv->chan_rx = chan;
+
+	pci_dev_put(dma_dev);
 }
 
 static void pch_dma_rx_complete(void *arg)
-- 
2.35.1



