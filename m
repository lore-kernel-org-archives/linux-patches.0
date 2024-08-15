Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108D41714A8;
	Thu, 15 Aug 2024 13:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729371; cv=none; b=H2T7xlkxFFBb7r6uQFu+EhU/TRt7sqfN6h3E9PuaJGSQYpHoIhenyBtcbtcUwTwaDjpQpna1zpO7NvSsTilvbvXz9a8hCAmYGjLHye0xqkGPND45aV4KkOfACNEnHItJgtmCZqLRwi6zj8rRHzrPzIJGe50Kr/jOqjWjI+Otv+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729371; c=relaxed/simple;
	bh=X2MJJCLNpsZOlqxelRyVSsWYilz1VVXtDrB+kTIj3B0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TH1djNxcXNkEs/Jc3QrZddtE4z8R7PCFoeFYvpFL4Bu3KGTrWVo41Cg5//QOFiqjZuXUUeSE19v3V86LFmA5n8X8hcjTLucyBymX3F+q+tuEdv2HVT6G2hlbpyxNZ8r6Ug7y2cdtwn4tjuZ0R4fGzyDXWGCzf5GAsthO1CwKKf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XotouH2S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XotouH2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77822C32786;
	Thu, 15 Aug 2024 13:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729370;
	bh=X2MJJCLNpsZOlqxelRyVSsWYilz1VVXtDrB+kTIj3B0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XotouH2SRl20TWF7Xrs6NMa+SIGtApRyYxwX41WtmrUXXj3dK3TOJkfsTLaj3awoh
	 JCOw+R9V64cSP/Ppa/tYQ/1+10RoGhrtoFBl887E30Vuym6Pi1A7pqWDahFPhwP4sK
	 cph0ggIh3zkGRS0mAc8CoraKWwTUGG3DIcZYqIUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Kodanev <aleksei.kodanev@bell-sw.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 077/484] bna: adjust name buf size of bna_tcb and bna_ccb structures
Date: Thu, 15 Aug 2024 15:18:55 +0200
Message-ID: <20240815131944.260397982@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

From: Alexey Kodanev <aleksei.kodanev@bell-sw.com>

[ Upstream commit c9741a03dc8e491e57b95fba0058ab46b7e506da ]

To have enough space to write all possible sprintf() args. Currently
'name' size is 16, but the first '%s' specifier may already need at
least 16 characters, since 'bnad->netdev->name' is used there.

For '%d' specifiers, assume that they require:
 * 1 char for 'tx_id + tx_info->tcb[i]->id' sum, BNAD_MAX_TXQ_PER_TX is 8
 * 2 chars for 'rx_id + rx_info->rx_ctrl[i].ccb->id', BNAD_MAX_RXP_PER_RX
   is 16

And replace sprintf with snprintf.

Detected using the static analysis tool - Svace.

Fixes: 8b230ed8ec96 ("bna: Brocade 10Gb Ethernet device driver")
Signed-off-by: Alexey Kodanev <aleksei.kodanev@bell-sw.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/brocade/bna/bna_types.h |  2 +-
 drivers/net/ethernet/brocade/bna/bnad.c      | 11 ++++++-----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/brocade/bna/bna_types.h b/drivers/net/ethernet/brocade/bna/bna_types.h
index 666b6922e24db..ebf54d74c2bbe 100644
--- a/drivers/net/ethernet/brocade/bna/bna_types.h
+++ b/drivers/net/ethernet/brocade/bna/bna_types.h
@@ -410,7 +410,7 @@ struct bna_ib {
 /* Tx object */
 
 /* Tx datapath control structure */
-#define BNA_Q_NAME_SIZE		16
+#define BNA_Q_NAME_SIZE		(IFNAMSIZ + 6)
 struct bna_tcb {
 	/* Fast path */
 	void			**sw_qpt;
diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index 0347c9d3aff32..a3b6b9af0b057 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -1535,8 +1535,9 @@ bnad_tx_msix_register(struct bnad *bnad, struct bnad_tx_info *tx_info,
 
 	for (i = 0; i < num_txqs; i++) {
 		vector_num = tx_info->tcb[i]->intr_vector;
-		sprintf(tx_info->tcb[i]->name, "%s TXQ %d", bnad->netdev->name,
-				tx_id + tx_info->tcb[i]->id);
+		snprintf(tx_info->tcb[i]->name, BNA_Q_NAME_SIZE, "%s TXQ %d",
+			 bnad->netdev->name,
+			 tx_id + tx_info->tcb[i]->id);
 		err = request_irq(bnad->msix_table[vector_num].vector,
 				  (irq_handler_t)bnad_msix_tx, 0,
 				  tx_info->tcb[i]->name,
@@ -1586,9 +1587,9 @@ bnad_rx_msix_register(struct bnad *bnad, struct bnad_rx_info *rx_info,
 
 	for (i = 0; i < num_rxps; i++) {
 		vector_num = rx_info->rx_ctrl[i].ccb->intr_vector;
-		sprintf(rx_info->rx_ctrl[i].ccb->name, "%s CQ %d",
-			bnad->netdev->name,
-			rx_id + rx_info->rx_ctrl[i].ccb->id);
+		snprintf(rx_info->rx_ctrl[i].ccb->name, BNA_Q_NAME_SIZE,
+			 "%s CQ %d", bnad->netdev->name,
+			 rx_id + rx_info->rx_ctrl[i].ccb->id);
 		err = request_irq(bnad->msix_table[vector_num].vector,
 				  (irq_handler_t)bnad_msix_rx, 0,
 				  rx_info->rx_ctrl[i].ccb->name,
-- 
2.43.0



