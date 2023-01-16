Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1690B6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:46:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A44C433D2;
	Mon, 16 Jan 2023 16:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887602;
	bh=ZE3cV21EtLxc+2Uh14AdGrR1FSyKzyLFGkk4Iyl3pvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mlBzCuY3qFqEddBc9Lpev77ogOP1qV1UN8xQbwhGEFxodOONARKP3nO22ULcSLpYd
	 qP3naAoqPfJkIITX/7RrwHvOOFNEE2JEShZwQFKZge/5r+zRFzBDE7LUZrPM8FO33Z
	 +E+RY2Ao3YOpd81fPFsa2XB/8y1gKuVonctkia/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shardar Shariff Md <smohammed@nvidia.com>,
	Krishna Yarlagadda <kyarlagadda@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 212/521] serial: tegra: add support to use 8 bytes trigger
Date: Mon, 16 Jan 2023 16:47:54 +0100
Message-Id: <20230116154856.650290735@linuxfoundation.org>
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

From: Krishna Yarlagadda <kyarlagadda@nvidia.com>

[ Upstream commit 7799a3aa81279637031abad19e56e4bbf1481d4e ]

Add support to use 8 bytes trigger for Tegra186 SOC.

Signed-off-by: Shardar Shariff Md <smohammed@nvidia.com>
Signed-off-by: Krishna Yarlagadda <kyarlagadda@nvidia.com>
Link: https://lore.kernel.org/r/1567572187-29820-9-git-send-email-kyarlagadda@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 109a951a9f1f ("serial: tegra: Read DMA status before terminating")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial-tegra.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index 55415a12d3cc..6a3c6bf5b964 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -88,6 +88,7 @@ struct tegra_uart_chip_data {
 	bool	support_clk_src_div;
 	bool	fifo_mode_enable_status;
 	int	uart_max_port;
+	int	max_dma_burst_bytes;
 };
 
 struct tegra_uart_port {
@@ -877,7 +878,12 @@ static int tegra_uart_hw_init(struct tegra_uart_port *tup)
 	 * programmed in the DMA registers.
 	 */
 	tup->fcr_shadow = UART_FCR_ENABLE_FIFO;
-	tup->fcr_shadow |= UART_FCR_R_TRIG_01;
+
+	if (tup->cdata->max_dma_burst_bytes == 8)
+		tup->fcr_shadow |= UART_FCR_R_TRIG_10;
+	else
+		tup->fcr_shadow |= UART_FCR_R_TRIG_01;
+
 	tup->fcr_shadow |= TEGRA_UART_TX_TRIG_16B;
 	tegra_uart_write(tup, tup->fcr_shadow, UART_FCR);
 
@@ -991,7 +997,7 @@ static int tegra_uart_dma_channel_allocate(struct tegra_uart_port *tup,
 		}
 		dma_sconfig.src_addr = tup->uport.mapbase;
 		dma_sconfig.src_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
-		dma_sconfig.src_maxburst = 4;
+		dma_sconfig.src_maxburst = tup->cdata->max_dma_burst_bytes;
 		tup->rx_dma_chan = dma_chan;
 		tup->rx_dma_buf_virt = dma_buf;
 		tup->rx_dma_buf_phys = dma_phys;
@@ -1263,6 +1269,7 @@ static struct tegra_uart_chip_data tegra20_uart_chip_data = {
 	.support_clk_src_div		= false,
 	.fifo_mode_enable_status	= false,
 	.uart_max_port			= 5,
+	.max_dma_burst_bytes		= 4,
 };
 
 static struct tegra_uart_chip_data tegra30_uart_chip_data = {
@@ -1271,6 +1278,7 @@ static struct tegra_uart_chip_data tegra30_uart_chip_data = {
 	.support_clk_src_div		= true,
 	.fifo_mode_enable_status	= false,
 	.uart_max_port			= 5,
+	.max_dma_burst_bytes		= 4,
 };
 
 static struct tegra_uart_chip_data tegra186_uart_chip_data = {
@@ -1279,6 +1287,7 @@ static struct tegra_uart_chip_data tegra186_uart_chip_data = {
 	.support_clk_src_div		= true,
 	.fifo_mode_enable_status	= true,
 	.uart_max_port			= 8,
+	.max_dma_burst_bytes		= 8,
 };
 
 static const struct of_device_id tegra_uart_of_match[] = {
-- 
2.35.1



