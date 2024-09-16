Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A33015687C;
	Mon, 16 Sep 2024 12:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488021; cv=none; b=X1oX2vCGOEYFdyHrMghVAHml7NrtFlBc221K+0WiUiBzGBC9MpQyoiIK1i9t2MUPC8656HDPtPWXIzkH98Ks3mhgjGyQLo449P+bLYt4VKcgkEcjw0G5gZ8UsNKFIGGPbB8oeFDoM7cH0qaGUpksbyJxGjJBNkEcyxns3lgWp/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488021; c=relaxed/simple;
	bh=tvsPvwa1bIHOx2x/9VaEeRpd8JwUg7mfyIgdMx1N+Fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hb4MhsnXsu7SPDIlNXPeIpRSB5o12NslWf43doC/v7mm0mmeDPEywvgE/RN2R/6MO+CPdRy4gN4EslX2UFVh4dKu0cLL8nT0qs6JlhMK11abL83k5GLXyb/a8RZ4eXsWhrbEhtDLqBRK5HB09x4C5Y9LTIdyVhvCZqvlKvRnjBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iGHk7VyW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iGHk7VyW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD177C4CEC7;
	Mon, 16 Sep 2024 12:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488020;
	bh=tvsPvwa1bIHOx2x/9VaEeRpd8JwUg7mfyIgdMx1N+Fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iGHk7VyWf/Nayw0omPtj4aIqoRe6OywH+cF0HFZT6RaVdIJNTzHxz+gyBs9apN5IL
	 I7/cWTHge/z+W+YAYhWubtf24dQSRMiDWgSEHzQ6NdU9MEMRtFvls0Yaqq9tUF3RBy
	 x1F5xO4epkXo33VXfjwYEhjp3Olk/UsSITRy+WS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 30/63] net: xilinx: axienet: Fix race in axienet_stop
Date: Mon, 16 Sep 2024 13:44:09 +0200
Message-ID: <20240916114222.137598743@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
References: <20240916114221.021192667@linuxfoundation.org>
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

From: Sean Anderson <sean.anderson@linux.dev>

commit 858430db28a5f5a11f8faa3a6fa805438e6f0851 upstream.

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
[ Adjusted to apply before dmaengine support ]
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h      |    3 +++
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |    8 ++++++++
 2 files changed, 11 insertions(+)

--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -419,6 +419,8 @@ struct axidma_bd {
  * @tx_bytes:	TX byte count for statistics
  * @tx_stat_sync: Synchronization object for TX stats
  * @dma_err_task: Work structure to process Axi DMA errors
+ * @stopping:   Set when @dma_err_task shouldn't do anything because we are
+ *              about to stop the device.
  * @tx_irq:	Axidma TX IRQ number
  * @rx_irq:	Axidma RX IRQ number
  * @eth_irq:	Ethernet core IRQ number
@@ -481,6 +483,7 @@ struct axienet_local {
 	struct u64_stats_sync tx_stat_sync;
 
 	struct work_struct dma_err_task;
+	bool stopping;
 
 	int tx_irq;
 	int rx_irq;
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1161,6 +1161,7 @@ static int axienet_open(struct net_devic
 	phylink_start(lp->phylink);
 
 	/* Enable worker thread for Axi DMA error handling */
+	lp->stopping = false;
 	INIT_WORK(&lp->dma_err_task, axienet_dma_err_handler);
 
 	napi_enable(&lp->napi_rx);
@@ -1216,6 +1217,9 @@ static int axienet_stop(struct net_devic
 
 	dev_dbg(&ndev->dev, "axienet_close()\n");
 
+	WRITE_ONCE(lp->stopping, true);
+	flush_work(&lp->dma_err_task);
+
 	napi_disable(&lp->napi_tx);
 	napi_disable(&lp->napi_rx);
 
@@ -1760,6 +1764,10 @@ static void axienet_dma_err_handler(stru
 						dma_err_task);
 	struct net_device *ndev = lp->ndev;
 
+	/* Don't bother if we are going to stop anyway */
+	if (READ_ONCE(lp->stopping))
+		return;
+
 	napi_disable(&lp->napi_tx);
 	napi_disable(&lp->napi_rx);
 


