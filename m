Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5BCFBE8
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:27:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8726CC433EF;
	Thu,  1 Jun 2023 13:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685626043;
	bh=l1+wkJBql6UtkIYpV7h81XObR2QkUArtaDh2lgwwvy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z3DprAeuHwSweg2vojZsOetFL8gXUzKpv5ecYYvb8z07SJ072vuDrFRn050yWa33D
	 JsK9+zsdApxIdWCrUkxHTOn4AX2ISOxEkE85w2F0UzmUo9EX3kgjpzASzi+hEITbXK
	 QXTUfrHajF8tScN1T/DUzC7qpVO3PMoAgqCxHXcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenwei Wang <shenwei.wang@nxp.com>,
	Wei Fang <wei.fang@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 18/45] net: fec: add dma_wmb to ensure correct descriptor values
Date: Thu,  1 Jun 2023 14:21:14 +0100
Message-Id: <20230601131939.544331582@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131938.702671708@linuxfoundation.org>
References: <20230601131938.702671708@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shenwei Wang <shenwei.wang@nxp.com>

[ Upstream commit 9025944fddfed5966c8f102f1fe921ab3aee2c12 ]

Two dma_wmb() are added in the XDP TX path to ensure proper ordering of
descriptor and buffer updates:
1. A dma_wmb() is added after updating the last BD to make sure
   the updates to rest of the descriptor are visible before
   transferring ownership to FEC.
2. A dma_wmb() is also added after updating the bdp to ensure these
   updates are visible before updating txq->bd.cur.
3. Start the xmit of the frame immediately right after configuring the
   tx descriptor.

Fixes: 6d6b39f180b8 ("net: fec: add initial XDP support")
Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
Reviewed-by: Wei Fang <wei.fang@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 577d94821b3e7..38e5b5abe067c 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3834,6 +3834,11 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 	index = fec_enet_get_bd_index(last_bdp, &txq->bd);
 	txq->tx_skbuff[index] = NULL;
 
+	/* Make sure the updates to rest of the descriptor are performed before
+	 * transferring ownership.
+	 */
+	dma_wmb();
+
 	/* Send it on its way.  Tell FEC it's ready, interrupt when done,
 	 * it's the last BD of the frame, and to put the CRC on the end.
 	 */
@@ -3843,8 +3848,14 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 	/* If this was the last BD in the ring, start at the beginning again. */
 	bdp = fec_enet_get_nextdesc(last_bdp, &txq->bd);
 
+	/* Make sure the update to bdp are performed before txq->bd.cur. */
+	dma_wmb();
+
 	txq->bd.cur = bdp;
 
+	/* Trigger transmission start */
+	writel(0, txq->bd.reg_desc_active);
+
 	return 0;
 }
 
@@ -3873,12 +3884,6 @@ static int fec_enet_xdp_xmit(struct net_device *dev,
 		sent_frames++;
 	}
 
-	/* Make sure the update to bdp and tx_skbuff are performed. */
-	wmb();
-
-	/* Trigger transmission start */
-	writel(0, txq->bd.reg_desc_active);
-
 	__netif_tx_unlock(nq);
 
 	return sent_frames;
-- 
2.39.2



