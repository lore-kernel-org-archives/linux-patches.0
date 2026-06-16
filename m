Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE111A6803;
	Tue, 16 Jun 2026 16:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628345; cv=none; b=OVsfGQJk+82SOAtUuaaZtgTeVI+nA7Qt2kb3dNlhYV3pGA/fv7c0/uGyO5spvbLwag1gLQdp72rRXaePvbZQhAZ/QgaYLH7MABmYNiiVT8jPQgLsjtbmqfXeAjgSORIr8a+KkbEZf1RslKpI8UDT4WJB+R2GzJyaeqLVU+o3v6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628345; c=relaxed/simple;
	bh=uECzBRz6zb1ZBdejTrmGF2BVkBIEXTzAr+5YFmIhYvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GXKmsIkkxNkV8kR8I2l7tSKv87LGfq0VF5Nl8S2NkLm2hdXj73RiWtzKEFBPs9l1Bhgz5kCA9AOubSBfeEWZq9aNuJ1IOU/f1QaLTSqGyzvv/POLAsLPaegtwRd1YHB1R7ML8lhdHMjIro2uJ8l6be6MONoZ1STQexFD2K1AgSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kzSAvB9z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kzSAvB9z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48931F000E9;
	Tue, 16 Jun 2026 16:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628343;
	bh=T+JnCw22Uo7/4COEKVSES85OvHpRC0ngQz0/xYh+gm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kzSAvB9zYYX9mqEn7G8bFJxYb53MthvTNaVG/OFc5P2KZWWG7nLtn59h6Y/krybAw
	 DlWhycgd8RupXKqa98PWe0hqfVzTtTFtXmPYbbwFlh+uUYWl4YoR91FMCx2eoGLAyT
	 eY+9l4B2Z84pgMh6Kprj7s0skoWTSAbLrB/RowZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/452] net: mana: Add NULL guards in teardown path to prevent panic on attach failure
Date: Tue, 16 Jun 2026 20:24:31 +0530
Message-ID: <20260616145120.249028912@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dipayaan Roy <dipayanroy@linux.microsoft.com>

[ Upstream commit 17bfe0a8c014ee1d542ad352cd6a0a505361664a ]

When queue allocation fails partway through, the error cleanup frees
and NULLs apc->tx_qp and apc->rxqs. Multiple teardown paths such as
mana_remove(), mana_change_mtu() recovery, and internal error handling
in mana_alloc_queues() can subsequently call into functions that
dereference these pointers without NULL checks:

- mana_chn_setxdp() dereferences apc->rxqs[0], causing a NULL pointer
  dereference panic (CR2: 0000000000000000 at mana_chn_setxdp+0x26).
- mana_destroy_vport() iterates apc->rxqs without a NULL check.
- mana_fence_rqs() iterates apc->rxqs without a NULL check.
- mana_dealloc_queues() iterates apc->tx_qp without a NULL check.

Add NULL guards for apc->rxqs in mana_fence_rqs(),
mana_destroy_vport(), and before the mana_chn_setxdp() call. Add a
NULL guard for apc->tx_qp in mana_dealloc_queues() to skip TX queue
draining when TX queues were never allocated or already freed.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Link: https://patch.msgid.link/20260525081129.1230035-2-dipayanroy@linux.microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 70 +++++++++++--------
 1 file changed, 41 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 343f6e879af39e..3cf4ad1d91f67e 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1304,6 +1304,9 @@ static void mana_fence_rqs(struct mana_port_context *apc)
 	struct mana_rxq *rxq;
 	int err;
 
+	if (!apc->rxqs)
+		return;
+
 	for (rxq_idx = 0; rxq_idx < apc->num_queues; rxq_idx++) {
 		rxq = apc->rxqs[rxq_idx];
 		err = mana_fence_rq(apc, rxq);
@@ -2334,13 +2337,16 @@ static void mana_destroy_vport(struct mana_port_context *apc)
 	struct mana_rxq *rxq;
 	u32 rxq_idx;
 
-	for (rxq_idx = 0; rxq_idx < apc->num_queues; rxq_idx++) {
-		rxq = apc->rxqs[rxq_idx];
-		if (!rxq)
-			continue;
+	if (apc->rxqs) {
 
-		mana_destroy_rxq(apc, rxq, true);
-		apc->rxqs[rxq_idx] = NULL;
+		for (rxq_idx = 0; rxq_idx < apc->num_queues; rxq_idx++) {
+			rxq = apc->rxqs[rxq_idx];
+			if (!rxq)
+				continue;
+
+			mana_destroy_rxq(apc, rxq, true);
+			apc->rxqs[rxq_idx] = NULL;
+		}
 	}
 
 	mana_destroy_txq(apc);
@@ -2577,7 +2583,8 @@ static int mana_dealloc_queues(struct net_device *ndev)
 	if (apc->port_is_up)
 		return -EINVAL;
 
-	mana_chn_setxdp(apc, NULL);
+	if (apc->rxqs)
+		mana_chn_setxdp(apc, NULL);
 
 	if (gd->gdma_context->is_pf)
 		mana_pf_deregister_filter(apc);
@@ -2595,33 +2602,38 @@ static int mana_dealloc_queues(struct net_device *ndev)
 	 * number of queues.
 	 */
 
-	for (i = 0; i < apc->num_queues; i++) {
-		txq = &apc->tx_qp[i].txq;
-		tsleep = 1000;
-		while (atomic_read(&txq->pending_sends) > 0 &&
-		       time_before(jiffies, timeout)) {
-			usleep_range(tsleep, tsleep + 1000);
-			tsleep <<= 1;
-		}
-		if (atomic_read(&txq->pending_sends)) {
-			err = pcie_flr(to_pci_dev(gd->gdma_context->dev));
-			if (err) {
-				netdev_err(ndev, "flr failed %d with %d pkts pending in txq %u\n",
-					   err, atomic_read(&txq->pending_sends),
-					   txq->gdma_txq_id);
+	if (apc->tx_qp) {
+		for (i = 0; i < apc->num_queues; i++) {
+			txq = &apc->tx_qp[i].txq;
+			tsleep = 1000;
+			while (atomic_read(&txq->pending_sends) > 0 &&
+			       time_before(jiffies, timeout)) {
+				usleep_range(tsleep, tsleep + 1000);
+				tsleep <<= 1;
+			}
+			if (atomic_read(&txq->pending_sends)) {
+				err =
+				    pcie_flr(to_pci_dev(gd->gdma_context->dev));
+				if (err) {
+					netdev_err(ndev, "flr failed %d with %d pkts pending in txq %u\n",
+						   err,
+					    atomic_read(&txq->pending_sends),
+					    txq->gdma_txq_id);
+				}
+				break;
 			}
-			break;
 		}
-	}
 
-	for (i = 0; i < apc->num_queues; i++) {
-		txq = &apc->tx_qp[i].txq;
-		while ((skb = skb_dequeue(&txq->pending_skbs))) {
-			mana_unmap_skb(skb, apc);
-			dev_kfree_skb_any(skb);
+		for (i = 0; i < apc->num_queues; i++) {
+			txq = &apc->tx_qp[i].txq;
+			while ((skb = skb_dequeue(&txq->pending_skbs))) {
+				mana_unmap_skb(skb, apc);
+				dev_kfree_skb_any(skb);
+			}
+			atomic_set(&txq->pending_sends, 0);
 		}
-		atomic_set(&txq->pending_sends, 0);
 	}
+
 	/* We're 100% sure the queues can no longer be woken up, because
 	 * we're sure now mana_poll_tx_cq() can't be running.
 	 */
-- 
2.53.0



