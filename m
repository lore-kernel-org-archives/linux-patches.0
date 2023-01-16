Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771106FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:46:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0311C433EF;
	Mon, 16 Jan 2023 16:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887600;
	bh=FnS3AZ2mGUeg3aEmBCeTYnrD4xzz9w1QN/ENfR6vCYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LFApMKG/KTxL+Kd3SOgJyZV7U4smwpBxPP+9TPcA+hybVxYYvPJasKev3Xrvd4VtT
	 +bkDioIDydkxdTKvgBJ7d5KMyLmK5mZAje861wlCReRWqKCPzHmMPLyV+I8n8m6rgP
	 66dnMXxqoW+Ttovwd+TEhxgsmDns//y4suJ6Z4Sw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shardar Shariff Md <smohammed@nvidia.com>,
	Krishna Yarlagadda <kyarlagadda@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 211/521] serial: tegra: set maximum num of uart ports to 8
Date: Mon, 16 Jan 2023 16:47:53 +0100
Message-Id: <20230116154856.601623467@linuxfoundation.org>
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

[ Upstream commit 53d0a062cb771d62cd205d9e2845fe26c9989142 ]

Set maximum number of UART ports to 8 as older chips have 5 ports and
Tergra186 and later chips will have 8 ports. Add this info to chip
data. Read device tree compatible of this driver and register uart
driver with max ports of matching chip data.

Signed-off-by: Shardar Shariff Md <smohammed@nvidia.com>
Signed-off-by: Krishna Yarlagadda <kyarlagadda@nvidia.com>
Link: https://lore.kernel.org/r/1567572187-29820-8-git-send-email-kyarlagadda@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 109a951a9f1f ("serial: tegra: Read DMA status before terminating")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial-tegra.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index 5408486be834..55415a12d3cc 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -62,7 +62,7 @@
 #define TEGRA_UART_TX_TRIG_4B			0x20
 #define TEGRA_UART_TX_TRIG_1B			0x30
 
-#define TEGRA_UART_MAXIMUM			5
+#define TEGRA_UART_MAXIMUM			8
 
 /* Default UART setting when started: 115200 no parity, stop, 8 data bits */
 #define TEGRA_UART_DEFAULT_BAUD			115200
@@ -87,6 +87,7 @@ struct tegra_uart_chip_data {
 	bool	allow_txfifo_reset_fifo_mode;
 	bool	support_clk_src_div;
 	bool	fifo_mode_enable_status;
+	int	uart_max_port;
 };
 
 struct tegra_uart_port {
@@ -1261,6 +1262,7 @@ static struct tegra_uart_chip_data tegra20_uart_chip_data = {
 	.allow_txfifo_reset_fifo_mode	= true,
 	.support_clk_src_div		= false,
 	.fifo_mode_enable_status	= false,
+	.uart_max_port			= 5,
 };
 
 static struct tegra_uart_chip_data tegra30_uart_chip_data = {
@@ -1268,6 +1270,7 @@ static struct tegra_uart_chip_data tegra30_uart_chip_data = {
 	.allow_txfifo_reset_fifo_mode	= false,
 	.support_clk_src_div		= true,
 	.fifo_mode_enable_status	= false,
+	.uart_max_port			= 5,
 };
 
 static struct tegra_uart_chip_data tegra186_uart_chip_data = {
@@ -1275,6 +1278,7 @@ static struct tegra_uart_chip_data tegra186_uart_chip_data = {
 	.allow_txfifo_reset_fifo_mode	= false,
 	.support_clk_src_div		= true,
 	.fifo_mode_enable_status	= true,
+	.uart_max_port			= 8,
 };
 
 static const struct of_device_id tegra_uart_of_match[] = {
@@ -1409,11 +1413,22 @@ static struct platform_driver tegra_uart_platform_driver = {
 static int __init tegra_uart_init(void)
 {
 	int ret;
+	struct device_node *node;
+	const struct of_device_id *match = NULL;
+	const struct tegra_uart_chip_data *cdata = NULL;
+
+	node = of_find_matching_node(NULL, tegra_uart_of_match);
+	if (node)
+		match = of_match_node(tegra_uart_of_match, node);
+	if (match)
+		cdata = match->data;
+	if (cdata)
+		tegra_uart_driver.nr = cdata->uart_max_port;
 
 	ret = uart_register_driver(&tegra_uart_driver);
 	if (ret < 0) {
 		pr_err("Could not register %s driver\n",
-			tegra_uart_driver.driver_name);
+		       tegra_uart_driver.driver_name);
 		return ret;
 	}
 
-- 
2.35.1



