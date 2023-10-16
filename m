Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A461944F
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bqllfmTO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E71C433C7;
	Mon, 16 Oct 2023 08:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446263;
	bh=ZQHgGbNNkb1OrEoCXTDXOZ8UUxQP0LKrcsFnqe3WMSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bqllfmTOLz2iO5oaRehr/BvFP+8fdRL0OA2XAq06YTwlH1hkAWrPfA2XJI6/AjrD4
	 0CHEL3wygbHOgXkF+yaxcq4nL1oxnFhMm0NGAjnAxtPGlnlU2RIPphbLIqUBes0MSH
	 Fb0Iv/kT7IdUJv1QPYf8qgr32/szs/IfeHlzejLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 102/102] eth: remove remaining copies of the NAPI_POLL_WEIGHT define
Date: Mon, 16 Oct 2023 10:41:41 +0200
Message-ID: <20231016083956.422343545@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016083953.689300946@linuxfoundation.org>
References: <20231016083953.689300946@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

commit 36ffca1afea9b429d3e49aa0b6a68ecd93f3be11 upstream.

Defining local versions of NAPI_POLL_WEIGHT with the same
values in the drivers just makes refactoring harder.

This patch covers three more drivers which I missed in
commit 5f012b40ef63 ("eth: remove copies of the NAPI_POLL_WEIGHT define").

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c |    4 +---
 drivers/net/ethernet/brocade/bna/bnad.c      |    3 +--
 drivers/net/ethernet/nvidia/forcedeth.c      |    6 +++---
 3 files changed, 5 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -31,8 +31,6 @@ MODULE_LICENSE("GPL");
 
 #define ENA_MAX_RINGS min_t(unsigned int, ENA_MAX_NUM_IO_QUEUES, num_possible_cpus())
 
-#define ENA_NAPI_BUDGET 64
-
 #define DEFAULT_MSG_ENABLE (NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_IFUP | \
 		NETIF_MSG_TX_DONE | NETIF_MSG_TX_ERR | NETIF_MSG_RX_ERR)
 
@@ -2303,7 +2301,7 @@ static void ena_init_napi_in_range(struc
 		netif_napi_add(adapter->netdev,
 			       &napi->napi,
 			       ENA_IS_XDP_INDEX(adapter, i) ? ena_xdp_io_poll : ena_io_poll,
-			       ENA_NAPI_BUDGET);
+			       NAPI_POLL_WEIGHT);
 
 		if (!ENA_IS_XDP_INDEX(adapter, i)) {
 			napi->rx_ring = &adapter->rx_ring[i];
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -1881,7 +1881,6 @@ poll_exit:
 	return rcvd;
 }
 
-#define BNAD_NAPI_POLL_QUOTA		64
 static void
 bnad_napi_add(struct bnad *bnad, u32 rx_id)
 {
@@ -1892,7 +1891,7 @@ bnad_napi_add(struct bnad *bnad, u32 rx_
 	for (i = 0; i <	bnad->num_rxp_per_rx; i++) {
 		rx_ctrl = &bnad->rx_info[rx_id].rx_ctrl[i];
 		netif_napi_add(bnad->netdev, &rx_ctrl->napi,
-			       bnad_napi_poll_rx, BNAD_NAPI_POLL_QUOTA);
+			       bnad_napi_poll_rx, NAPI_POLL_WEIGHT);
 	}
 }
 
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -56,8 +56,8 @@
 
 #include <asm/irq.h>
 
-#define TX_WORK_PER_LOOP  64
-#define RX_WORK_PER_LOOP  64
+#define TX_WORK_PER_LOOP  NAPI_POLL_WEIGHT
+#define RX_WORK_PER_LOOP  NAPI_POLL_WEIGHT
 
 /*
  * Hardware access:
@@ -5869,7 +5869,7 @@ static int nv_probe(struct pci_dev *pci_
 	else
 		dev->netdev_ops = &nv_netdev_ops_optimized;
 
-	netif_napi_add(dev, &np->napi, nv_napi_poll, RX_WORK_PER_LOOP);
+	netif_napi_add(dev, &np->napi, nv_napi_poll, NAPI_POLL_WEIGHT);
 	dev->ethtool_ops = &ops;
 	dev->watchdog_timeo = NV_WATCHDOG_TIMEO;
 


