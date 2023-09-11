Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAD311710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:22:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED19EC433C7;
	Mon, 11 Sep 2023 15:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445733;
	bh=EUfMFaf8MJk1JcFLbWkKgpXhNgh81dnnbgyiJiahevg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KVTT/h48U6RdzgGVE3TmK2LdOeg1mTL3pZvQF2zRS/C3/Ib2osemkGDJm4jRYdZ6M
	 9B3ELWWjuP0Y+g1hHetsHAkGkWkETH4n55+3WLWg/sfOY19fBYR75S8zcEPoN/iqoJ
	 voqhZog+GN5OOr8fdg08IDfeiXovv7nWxep0gP38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunyan Zhang <chunyan.zhang@unisoc.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 426/600] serial: sprd: Fix DMA buffer leak issue
Date: Mon, 11 Sep 2023 15:47:39 +0200
Message-ID: <20230911134646.235824237@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chunyan Zhang <chunyan.zhang@unisoc.com>

[ Upstream commit cd119fdc3ee1450fbf7f78862b5de44c42b6e47f ]

Release DMA buffer when _probe() returns failure to avoid memory leak.

Fixes: f4487db58eb7 ("serial: sprd: Add DMA mode support")
Signed-off-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Link: https://lore.kernel.org/r/20230725064053.235448-2-chunyan.zhang@unisoc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sprd_serial.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/sprd_serial.c b/drivers/tty/serial/sprd_serial.c
index 58825443529f3..9c7f71993e945 100644
--- a/drivers/tty/serial/sprd_serial.c
+++ b/drivers/tty/serial/sprd_serial.c
@@ -367,7 +367,7 @@ static void sprd_rx_free_buf(struct sprd_uart_port *sp)
 	if (sp->rx_dma.virt)
 		dma_free_coherent(sp->port.dev, SPRD_UART_RX_SIZE,
 				  sp->rx_dma.virt, sp->rx_dma.phys_addr);
-
+	sp->rx_dma.virt = NULL;
 }
 
 static int sprd_rx_dma_config(struct uart_port *port, u32 burst)
@@ -1229,7 +1229,7 @@ static int sprd_probe(struct platform_device *pdev)
 		ret = uart_register_driver(&sprd_uart_driver);
 		if (ret < 0) {
 			pr_err("Failed to register SPRD-UART driver\n");
-			return ret;
+			goto free_rx_buf;
 		}
 	}
 
@@ -1248,6 +1248,7 @@ static int sprd_probe(struct platform_device *pdev)
 	sprd_port[index] = NULL;
 	if (--sprd_ports_num == 0)
 		uart_unregister_driver(&sprd_uart_driver);
+free_rx_buf:
 	sprd_rx_free_buf(sport);
 	return ret;
 }
-- 
2.40.1



