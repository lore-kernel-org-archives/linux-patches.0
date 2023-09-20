Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAE03AC2A
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5917C433CA;
	Wed, 20 Sep 2023 12:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213108;
	bh=JCWd+VNgwFskt173nQBEMZsOBd4ZFrkS8Do4tlQd+mQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AxxHFa4obCKrVE0DNOqkOrnp1NMph6ceWrJY4rAKrbv8OKTXicJWiSVQATtZqZnGe
	 8UUPKpjTig24Is4+Su4GyT7KejYNB3250xKdyTmMMGD0zl6fMT2vk5zY3+HWAA/fBD
	 HxbZOIbcNSgvurCOeVvSxs4ZA2oLx3kobvpt9ttg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunyan Zhang <chunyan.zhang@unisoc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 164/367] serial: sprd: Assign sprd_port after initialized to avoid wrong access
Date: Wed, 20 Sep 2023 13:29:01 +0200
Message-ID: <20230920112902.893468823@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chunyan Zhang <chunyan.zhang@unisoc.com>

[ Upstream commit f9608f1887568b728839d006024585ab02ef29e5 ]

The global pointer 'sprd_port' may not zero when sprd_probe returns
failure, that is a risk for sprd_port to be accessed afterward, and
may lead to unexpected errors.

For example:

There are two UART ports, UART1 is used for console and configured in
kernel command line, i.e. "console=";

The UART1 probe failed and the memory allocated to sprd_port[1] was
released, but sprd_port[1] was not set to NULL;

In UART2 probe, the same virtual address was allocated to sprd_port[2],
and UART2 probe process finally will go into sprd_console_setup() to
register UART1 as console since it is configured as preferred console
(filled to console_cmdline[]), but the console parameters (sprd_port[1])
belong to UART2.

So move the sprd_port[] assignment to where the port already initialized
can avoid the above issue.

Fixes: b7396a38fb28 ("tty/serial: Add Spreadtrum sc9836-uart driver support")
Signed-off-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
Link: https://lore.kernel.org/r/20230725064053.235448-1-chunyan.zhang@unisoc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sprd_serial.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/sprd_serial.c b/drivers/tty/serial/sprd_serial.c
index 9cf771a9cff62..18f5a7f438329 100644
--- a/drivers/tty/serial/sprd_serial.c
+++ b/drivers/tty/serial/sprd_serial.c
@@ -1103,7 +1103,7 @@ static bool sprd_uart_is_console(struct uart_port *uport)
 static int sprd_clk_init(struct uart_port *uport)
 {
 	struct clk *clk_uart, *clk_parent;
-	struct sprd_uart_port *u = sprd_port[uport->line];
+	struct sprd_uart_port *u = container_of(uport, struct sprd_uart_port, port);
 
 	clk_uart = devm_clk_get(uport->dev, "uart");
 	if (IS_ERR(clk_uart)) {
@@ -1146,22 +1146,22 @@ static int sprd_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	struct uart_port *up;
+	struct sprd_uart_port *sport;
 	int irq;
 	int index;
 	int ret;
 
 	index = of_alias_get_id(pdev->dev.of_node, "serial");
-	if (index < 0 || index >= ARRAY_SIZE(sprd_port)) {
+	if (index < 0 || index >= UART_NR_MAX) {
 		dev_err(&pdev->dev, "got a wrong serial alias id %d\n", index);
 		return -EINVAL;
 	}
 
-	sprd_port[index] = devm_kzalloc(&pdev->dev, sizeof(*sprd_port[index]),
-					GFP_KERNEL);
-	if (!sprd_port[index])
+	sport = devm_kzalloc(&pdev->dev, sizeof(*sport), GFP_KERNEL);
+	if (!sport)
 		return -ENOMEM;
 
-	up = &sprd_port[index]->port;
+	up = &sport->port;
 	up->dev = &pdev->dev;
 	up->line = index;
 	up->type = PORT_SPRD;
@@ -1191,7 +1191,7 @@ static int sprd_probe(struct platform_device *pdev)
 	 * Allocate one dma buffer to prepare for receive transfer, in case
 	 * memory allocation failure at runtime.
 	 */
-	ret = sprd_rx_alloc_buf(sprd_port[index]);
+	ret = sprd_rx_alloc_buf(sport);
 	if (ret)
 		return ret;
 
@@ -1202,14 +1202,23 @@ static int sprd_probe(struct platform_device *pdev)
 			return ret;
 		}
 	}
+
 	sprd_ports_num++;
+	sprd_port[index] = sport;
 
 	ret = uart_add_one_port(&sprd_uart_driver, up);
 	if (ret)
-		sprd_remove(pdev);
+		goto clean_port;
 
 	platform_set_drvdata(pdev, up);
 
+	return 0;
+
+clean_port:
+	sprd_port[index] = NULL;
+	if (--sprd_ports_num == 0)
+		uart_unregister_driver(&sprd_uart_driver);
+	sprd_rx_free_buf(sport);
 	return ret;
 }
 
-- 
2.40.1



