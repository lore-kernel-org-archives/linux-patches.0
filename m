Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74196FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:46:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5ABC433D2;
	Mon, 16 Jan 2023 16:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887618;
	bh=4EH/XgjIFiPfcpV9nXv0MwJ2LoE57ZUpnDuqNYGzqis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o9kxim8q8/e+XEwHym7rPwQGfi8R+BjqfYRTJlq0tD6IimJr7maS0FwyOhpOZXOQf
	 w60+bkR8e2cUVOEKS7MmhmGWoP6SlPxvtXgqwm6Zfg52xCx5fEBOK2IAoNLWBuwX8P
	 q9PmZo4Es7vi1O1xCI8ZPLI07SRqfTZ7GxubkvsI=
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
Subject: [PATCH 4.19 217/521] serial: tegra: Read DMA status before terminating
Date: Mon, 16 Jan 2023 16:47:59 +0100
Message-Id: <20230116154856.862644708@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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
index 1d957144117e..cc613240a351 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -570,8 +570,9 @@ static void tegra_uart_stop_tx(struct uart_port *u)
 	if (tup->tx_in_progress != TEGRA_UART_TX_DMA)
 		return;
 
-	dmaengine_terminate_all(tup->tx_dma_chan);
+	dmaengine_pause(tup->tx_dma_chan);
 	dmaengine_tx_status(tup->tx_dma_chan, tup->tx_cookie, &state);
+	dmaengine_terminate_all(tup->tx_dma_chan);
 	count = tup->tx_bytes_requested - state.residue;
 	async_tx_ack(tup->tx_dma_desc);
 	uart_xmit_advance(&tup->uport, count);
@@ -697,8 +698,9 @@ static void tegra_uart_terminate_rx_dma(struct tegra_uart_port *tup)
 	if (!tup->rx_dma_active)
 		return;
 
-	dmaengine_terminate_all(tup->rx_dma_chan);
+	dmaengine_pause(tup->rx_dma_chan);
 	dmaengine_tx_status(tup->rx_dma_chan, tup->rx_cookie, &state);
+	dmaengine_terminate_all(tup->rx_dma_chan);
 
 	tegra_uart_rx_buffer_push(tup, state.residue);
 	tup->rx_dma_active = false;
-- 
2.35.1



