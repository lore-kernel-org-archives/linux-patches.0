Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7503218952C;
	Wed,  5 Feb 2025 14:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767575; cv=none; b=BmZkR2YpeTc5kgRqAiyA3UIQBMUjKNIyJu4GPE1qR9o9IKbCO0ds2/Sk+RkiyLmSqUO9EJ4jg87fA/OtDtiIqm7B5AWMqjLdKC/cDQdFZlz7475fjnrxSr0LrBcFr1RfE9+TmyckUXvVfsSXfL3n0NOCJ/2AmIDfXu4D10BhcxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767575; c=relaxed/simple;
	bh=GFAfoe/r62l+OFntfu1m4VZu/w3VnKcn+qVPdUn0bn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=faS1Ltg9uO9AUd83F8xJM4P5MLe4Wkwmb2EBPZgn1hHeZFqmTy19gviUNk0YQTm3X7pZ6TFutzoJtWJxn6dc/yr+r4t4UpuMsiumuVxn96mENfc/xYmzIbwcUbKTgApywYogtlyLWMQwJ671AicasaxE92jk7ywWFMzkt6UX1I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7ZwBrsy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7ZwBrsy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41A9C4CED6;
	Wed,  5 Feb 2025 14:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767575;
	bh=GFAfoe/r62l+OFntfu1m4VZu/w3VnKcn+qVPdUn0bn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7ZwBrsyChhKAY4rU7a2PwFtGt/YgOs7z/eQFs2Zu1/Gh0FJ5J68eCygvQf5GnSyD
	 MSRktvEuILg+MASQVyUUN34+lVONmDwK/8SoifnjiQjRVpvTTrX3bC1TqIMijhTNZ4
	 UzL38+fPpPnLE4KTnwJMRPJuHMSs9CTGRz94flQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dheeraj Reddy Jonnalagadda <dheeraj.linuxdev@gmail.com>,
	Wei Fang <wei.fang@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 477/590] net: fec: implement TSO descriptor cleanup
Date: Wed,  5 Feb 2025 14:43:52 +0100
Message-ID: <20250205134513.511883172@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dheeraj Reddy Jonnalagadda <dheeraj.linuxdev@gmail.com>

[ Upstream commit 61dc1fd9205bc9d9918aa933a847b08e80b4dc20 ]

Implement cleanup of descriptors in the TSO error path of
fec_enet_txq_submit_tso(). The cleanup

- Unmaps DMA buffers for data descriptors skipping TSO header
- Clears all buffer descriptors
- Handles extended descriptors by clearing cbd_esc when enabled

Fixes: 79f339125ea3 ("net: fec: Add software TSO support")
Signed-off-by: Dheeraj Reddy Jonnalagadda <dheeraj.linuxdev@gmail.com>
Reviewed-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20250120085430.99318-1-dheeraj.linuxdev@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 31 ++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 49d1748e0c043..2b05d9c6c21a4 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -840,6 +840,8 @@ static int fec_enet_txq_submit_tso(struct fec_enet_priv_tx_q *txq,
 	struct fec_enet_private *fep = netdev_priv(ndev);
 	int hdr_len, total_len, data_left;
 	struct bufdesc *bdp = txq->bd.cur;
+	struct bufdesc *tmp_bdp;
+	struct bufdesc_ex *ebdp;
 	struct tso_t tso;
 	unsigned int index = 0;
 	int ret;
@@ -913,7 +915,34 @@ static int fec_enet_txq_submit_tso(struct fec_enet_priv_tx_q *txq,
 	return 0;
 
 err_release:
-	/* TODO: Release all used data descriptors for TSO */
+	/* Release all used data descriptors for TSO */
+	tmp_bdp = txq->bd.cur;
+
+	while (tmp_bdp != bdp) {
+		/* Unmap data buffers */
+		if (tmp_bdp->cbd_bufaddr &&
+		    !IS_TSO_HEADER(txq, fec32_to_cpu(tmp_bdp->cbd_bufaddr)))
+			dma_unmap_single(&fep->pdev->dev,
+					 fec32_to_cpu(tmp_bdp->cbd_bufaddr),
+					 fec16_to_cpu(tmp_bdp->cbd_datlen),
+					 DMA_TO_DEVICE);
+
+		/* Clear standard buffer descriptor fields */
+		tmp_bdp->cbd_sc = 0;
+		tmp_bdp->cbd_datlen = 0;
+		tmp_bdp->cbd_bufaddr = 0;
+
+		/* Handle extended descriptor if enabled */
+		if (fep->bufdesc_ex) {
+			ebdp = (struct bufdesc_ex *)tmp_bdp;
+			ebdp->cbd_esc = 0;
+		}
+
+		tmp_bdp = fec_enet_get_nextdesc(tmp_bdp, &txq->bd);
+	}
+
+	dev_kfree_skb_any(skb);
+
 	return ret;
 }
 
-- 
2.39.5



