Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F17D186E4B;
	Tue, 10 Sep 2024 09:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961888; cv=none; b=G07hnBm30UMl0uxnnGfr9BWcZmfArZRz/xKn79G5mGWqJ6H3+LTnX0eNtht4X9DrBGn35r2ydic+rB/AMOl5UUFkrH/DzPUoH7Ms1MBO3zdpkgRHWD/SD9BS885CDJBkfpCXmJXmZ151WFk3cZZVc01ZZsYrIa5bfqyTT1KoIoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961888; c=relaxed/simple;
	bh=xlfC2NlUR6IF8I4e1mqII02NIWsj4vGMd9PtkmRi9Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tjhbOm4I5pSAeVZpmuI+XYFtRRYHCm2eGeIh0W+g5R1MDySSC1KHEnbCFKDhf/718eFxa5XbO0xpy5CSP9lJ8cblWN9yVFjBAnawUKW/Mf/+Xs5poz6Sg2O2GoZnXIi9lODilGUgrJeRTtuxQkCIg1H7J5Vl5lBgLrOtCLUH9sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H0NOMod1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H0NOMod1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B927C4CEC3;
	Tue, 10 Sep 2024 09:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961887;
	bh=xlfC2NlUR6IF8I4e1mqII02NIWsj4vGMd9PtkmRi9Bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H0NOMod1JHqEQKUm+QzlOi7rm5N81jTGVogVRRNhRjcuSyC6plGO94F9DDyPD2cv/
	 UovCqrSDUsf/Z5mZTvuIqRb3rbEksUq+quOiVuNxuuVa1aht73S30P8b3RIqS1JSlN
	 lYziNqf3uzrP+ecph0vojIH2ivdHSoudUO3vpx2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 195/375] net: xilinx: axienet: Fix race in axienet_stop
Date: Tue, 10 Sep 2024 11:29:52 +0200
Message-ID: <20240910092629.052697441@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sean.anderson@linux.dev>

[ Upstream commit 858430db28a5f5a11f8faa3a6fa805438e6f0851 ]

axienet_dma_err_handler can race with axienet_stop in the following
manner:

CPU 1                       CPU 2
======================      ==================
axienet_stop()
    napi_disable()
    axienet_dma_stop()
                            axienet_dma_err_handler()
                                napi_disable()
                                axienet_dma_stop()
                                axienet_dma_start()
                                napi_enable()
    cancel_work_sync()
    free_irq()

Fix this by setting a flag in axienet_stop telling
axienet_dma_err_handler not to bother doing anything. I chose not to use
disable_work_sync to allow for easier backporting.

Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Fixes: 8a3b7a252dca ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Link: https://patch.msgid.link/20240903175141.4132898-1-sean.anderson@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h      | 3 +++
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 8 ++++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 09c9f9787180..1223fcc1a8da 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -436,6 +436,8 @@ struct skbuf_dma_descriptor {
  * @tx_bytes:	TX byte count for statistics
  * @tx_stat_sync: Synchronization object for TX stats
  * @dma_err_task: Work structure to process Axi DMA errors
+ * @stopping:   Set when @dma_err_task shouldn't do anything because we are
+ *              about to stop the device.
  * @tx_irq:	Axidma TX IRQ number
  * @rx_irq:	Axidma RX IRQ number
  * @eth_irq:	Ethernet core IRQ number
@@ -507,6 +509,7 @@ struct axienet_local {
 	struct u64_stats_sync tx_stat_sync;
 
 	struct work_struct dma_err_task;
+	bool stopping;
 
 	int tx_irq;
 	int rx_irq;
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 559c0d60d948..88d7bc2ea713 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1460,6 +1460,7 @@ static int axienet_init_legacy_dma(struct net_device *ndev)
 	struct axienet_local *lp = netdev_priv(ndev);
 
 	/* Enable worker thread for Axi DMA error handling */
+	lp->stopping = false;
 	INIT_WORK(&lp->dma_err_task, axienet_dma_err_handler);
 
 	napi_enable(&lp->napi_rx);
@@ -1580,6 +1581,9 @@ static int axienet_stop(struct net_device *ndev)
 	dev_dbg(&ndev->dev, "axienet_close()\n");
 
 	if (!lp->use_dmaengine) {
+		WRITE_ONCE(lp->stopping, true);
+		flush_work(&lp->dma_err_task);
+
 		napi_disable(&lp->napi_tx);
 		napi_disable(&lp->napi_rx);
 	}
@@ -2154,6 +2158,10 @@ static void axienet_dma_err_handler(struct work_struct *work)
 						dma_err_task);
 	struct net_device *ndev = lp->ndev;
 
+	/* Don't bother if we are going to stop anyway */
+	if (READ_ONCE(lp->stopping))
+		return;
+
 	napi_disable(&lp->napi_tx);
 	napi_disable(&lp->napi_rx);
 
-- 
2.43.0



