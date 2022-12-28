Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7091868
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58E9C433D2;
	Wed, 28 Dec 2022 15:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241117;
	bh=xzZyTAWzuVY9BUd3ys3fux0z9N2SLUeed5L8yZ51Iqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YRsMKBodYG8JHvVzGnTzL/2mq0MOufzqDYHQBfCLlxqcqcJlTU1p95R6xZX22DDWo
	 bu97wpZDv0l7eNJMcTUuuwl+MYk/5a65yuoXuloP2qJJIMKCF8kF/lbtvvGtheOrk2
	 Ss+XdFvb1pmQEfotsLD3Ky8G0z+bD63Y91GnYKPE=
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
Subject: [PATCH 5.15 439/731] serial: tegra: Read DMA status before terminating
Date: Wed, 28 Dec 2022 15:39:06 +0100
Message-Id: <20221228144309.284632016@linuxfoundation.org>
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
index d4dba298de7a..79187ff9ac13 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -619,8 +619,9 @@ static void tegra_uart_stop_tx(struct uart_port *u)
 	if (tup->tx_in_progress != TEGRA_UART_TX_DMA)
 		return;
 
-	dmaengine_terminate_all(tup->tx_dma_chan);
+	dmaengine_pause(tup->tx_dma_chan);
 	dmaengine_tx_status(tup->tx_dma_chan, tup->tx_cookie, &state);
+	dmaengine_terminate_all(tup->tx_dma_chan);
 	count = tup->tx_bytes_requested - state.residue;
 	async_tx_ack(tup->tx_dma_desc);
 	uart_xmit_advance(&tup->uport, count);
@@ -763,8 +764,9 @@ static void tegra_uart_terminate_rx_dma(struct tegra_uart_port *tup)
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



