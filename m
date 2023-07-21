Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65811ED25
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48936C433C7;
	Fri, 21 Jul 2023 16:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955934;
	bh=YOhcJ8tC+IWpkw7UpEG7iyAIYK7lwu66O2MwBeCMo8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RB/Pqx2dLOuCtulYNuqB+/HQjZyf1dYxPLvRwFSw7nLyz+laLPyLj2vHfrbv4ddbl
	 8MnnkVyDXMRMVYGhV9uHvYKxgK5erdaFHwey2dn6xmB7fuhpr/R+LN+F0MXMZSZnph
	 qTI0zh1YAWdkqgkDIFV8eSuSXev5gueHmO1LU4H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Simon Horman <simon.horman@corigine.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 082/292] net: fec: remove last_bdp from fec_enet_txq_xmit_frame()
Date: Fri, 21 Jul 2023 18:03:11 +0200
Message-ID: <20230721160532.329075140@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit bc638eabfed90fdc798fd5765e67e41abea76152 ]

The last_bdp is initialized to bdp, and both last_bdp and bdp are
not changed. That is to say that last_bdp and bdp are always equal.
So bdp can be used directly.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230529022615.669589-1-wei.fang@nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 20f797399035 ("net: fec: recycle pages for transmitted XDP frames")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index c08331f7da7b3..40d71be45f604 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3770,7 +3770,7 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 				   struct xdp_frame *frame)
 {
 	unsigned int index, status, estatus;
-	struct bufdesc *bdp, *last_bdp;
+	struct bufdesc *bdp;
 	dma_addr_t dma_addr;
 	int entries_free;
 
@@ -3782,7 +3782,6 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 
 	/* Fill in a Tx ring entry */
 	bdp = txq->bd.cur;
-	last_bdp = bdp;
 	status = fec16_to_cpu(bdp->cbd_sc);
 	status &= ~BD_ENET_TX_STATS;
 
@@ -3810,7 +3809,6 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 		ebdp->cbd_esc = cpu_to_fec32(estatus);
 	}
 
-	index = fec_enet_get_bd_index(last_bdp, &txq->bd);
 	txq->tx_skbuff[index] = NULL;
 
 	/* Make sure the updates to rest of the descriptor are performed before
@@ -3825,7 +3823,7 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 	bdp->cbd_sc = cpu_to_fec16(status);
 
 	/* If this was the last BD in the ring, start at the beginning again. */
-	bdp = fec_enet_get_nextdesc(last_bdp, &txq->bd);
+	bdp = fec_enet_get_nextdesc(bdp, &txq->bd);
 
 	/* Make sure the update to bdp are performed before txq->bd.cur. */
 	dma_wmb();
-- 
2.39.2



