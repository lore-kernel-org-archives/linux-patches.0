Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1385F79C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF71C433F1;
	Thu, 12 Jan 2023 14:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533108;
	bh=hRSga1FXnWJFblQSEETZu3DIZMfdO63WZgE/gW3nDM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BL8toS+9o2KVFM7Jf3EOTPmxYLuC8a3j8zdoS+d+dUrSfKZuhekTC/imJH/gXlxnj
	 d/X6rNHy/c7ZXBayM9ZcUqvD04kbwina88hYd9qFoyUtdnIz9NC6kUvWkIzm1m8wGW
	 fzyYtr5oV8COHx2kJKmpT9m37ODQYJ1VCNsPdHsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Thierry Reding <treding@nvidia.com>,
	Akhil R <akhilrajeev@nvidia.com>,
	Kartik <kkartik@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 342/783] serial: tegra: Read DMA status before terminating
Date: Thu, 12 Jan 2023 14:50:58 +0100
Message-Id: <20230112135540.169530733@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kartik <kkartik@nvidia.com>

[ Upstream commit 109a951a9f1fd8a34ebd1896cbbd5d5cede880a7 ]

Read the DMA status before terminating the DMA, as doing so deletes
the DMA desc.

Also, to get the correct transfer status information, pause the DMA
using dmaengine_pause() before reading the DMA status.

Fixes: e9ea096dd225 ("serial: tegra: add serial driver")
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
Signed-off-by: Kartik <kkartik@nvidia.com>
Link: https://lore.kernel.org/r/1666105086-17326-1-git-send-email-kkartik@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial-tegra.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index cda71802b698..62377c831894 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -614,8 +614,9 @@ static void tegra_uart_stop_tx(struct uart_port *u)
 	if (tup->tx_in_progress != TEGRA_UART_TX_DMA)
 		return;
 
-	dmaengine_terminate_all(tup->tx_dma_chan);
+	dmaengine_pause(tup->tx_dma_chan);
 	dmaengine_tx_status(tup->tx_dma_chan, tup->tx_cookie, &state);
+	dmaengine_terminate_all(tup->tx_dma_chan);
 	count = tup->tx_bytes_requested - state.residue;
 	async_tx_ack(tup->tx_dma_desc);
 	uart_xmit_advance(&tup->uport, count);
@@ -758,8 +759,9 @@ static void tegra_uart_terminate_rx_dma(struct tegra_uart_port *tup)
 		return;
 	}
 
-	dmaengine_terminate_all(tup->rx_dma_chan);
+	dmaengine_pause(tup->rx_dma_chan);
 	dmaengine_tx_status(tup->rx_dma_chan, tup->rx_cookie, &state);
+	dmaengine_terminate_all(tup->rx_dma_chan);
 
 	tegra_uart_rx_buffer_push(tup, state.residue);
 	tup->rx_dma_active = false;
-- 
2.35.1



