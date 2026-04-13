Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09228318ED2;
	Mon, 13 Apr 2026 16:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099391; cv=none; b=GgU6DbkaLLwuibyW4c/2ij1Qsj5f815KjsUh2wqsGLR1D7n++JwbEoCPSqnbs3WwVeO8dIF0TrbLMXg08E/prFGRy83wWEsjaeX9TCV3brWKh1SbOLj1vR+2h8QuOk3EVZEdyTdhJYj9hBEEECv3frgguTPSCHi43UKi7hBHbuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099391; c=relaxed/simple;
	bh=NkDFIzaysPuRQctZzn9af83RaIYa7qCmUdFlWLm0hg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGuIHjZGzFUhiCyxR+bMpV2uvvnBivnLIGei9uG3hlu7XlKDlT+RdAyGi4/Sa0HC/oCzgDB1nYyTkaWKCNGShQLuMleXD2qaNM4aA0Kcvn3ihEOQQRHCul4vnUajC7WblYCq+ugN9+XZD031G4FCaKIQoK6kQSiggb/flQV31HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sz4kdUYr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sz4kdUYr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A644C2BCAF;
	Mon, 13 Apr 2026 16:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099390;
	bh=NkDFIzaysPuRQctZzn9af83RaIYa7qCmUdFlWLm0hg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sz4kdUYr9ubGQscOk4Q1DE6je7dRXpa3Xx6vPZOBnevxPq52hBqFqvARDL6f2zvYS
	 Wibpg1pdU9eoDyDcpWzw/4gcdAKP6/1NEizlxt8Z/7tfN06M8kzYU08P+RR1a1es1A
	 b9YC91GR/WhjQhLK3KxXmujI8wzTerLjJ6/veGOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 323/491] net: qrtr: Release distant nodes along the bridge node
Date: Mon, 13 Apr 2026 17:59:28 +0200
Message-ID: <20260413155831.135420350@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Loic Poulain <loic.poulain@linaro.org>

[ Upstream commit 90829f07baea7efe4ca77f79820f3849081186a8 ]

Distant QRTR nodes can be accessed via an other node that acts as
a bridge. When the a QRTR endpoint associated to a bridge node is
released, all the linked distant nodes should also be released.

This patch fixes endpoint release by:
- Submitting QRTR BYE message locally on behalf of all the nodes
accessible through the endpoint.
- Removing all the routable node IDs from radix tree pointing to
the released node endpoint.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 2428083101f6 ("net: qrtr: replace qrtr_tx_flow radix_tree with xarray to fix memory leak")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/qrtr/af_qrtr.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
index 01d8cb93ad756..68b6124fc8a10 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -172,8 +172,13 @@ static void __qrtr_node_release(struct kref *kref)
 	void __rcu **slot;
 
 	spin_lock_irqsave(&qrtr_nodes_lock, flags);
-	if (node->nid != QRTR_EP_NID_AUTO)
-		radix_tree_delete(&qrtr_nodes, node->nid);
+	/* If the node is a bridge for other nodes, there are possibly
+	 * multiple entries pointing to our released node, delete them all.
+	 */
+	radix_tree_for_each_slot(slot, &qrtr_nodes, &iter, 0) {
+		if (*slot == node)
+			radix_tree_iter_delete(&qrtr_nodes, &iter, slot);
+	}
 	spin_unlock_irqrestore(&qrtr_nodes_lock, flags);
 
 	list_del(&node->item);
@@ -615,6 +620,7 @@ void qrtr_endpoint_unregister(struct qrtr_endpoint *ep)
 	struct qrtr_ctrl_pkt *pkt;
 	struct qrtr_tx_flow *flow;
 	struct sk_buff *skb;
+	unsigned long flags;
 	void __rcu **slot;
 
 	mutex_lock(&node->ep_lock);
@@ -622,11 +628,18 @@ void qrtr_endpoint_unregister(struct qrtr_endpoint *ep)
 	mutex_unlock(&node->ep_lock);
 
 	/* Notify the local controller about the event */
-	skb = qrtr_alloc_ctrl_packet(&pkt, GFP_KERNEL);
-	if (skb) {
-		pkt->cmd = cpu_to_le32(QRTR_TYPE_BYE);
-		qrtr_local_enqueue(NULL, skb, QRTR_TYPE_BYE, &src, &dst);
+	spin_lock_irqsave(&qrtr_nodes_lock, flags);
+	radix_tree_for_each_slot(slot, &qrtr_nodes, &iter, 0) {
+		if (*slot != node)
+			continue;
+		src.sq_node = iter.index;
+		skb = qrtr_alloc_ctrl_packet(&pkt, GFP_ATOMIC);
+		if (skb) {
+			pkt->cmd = cpu_to_le32(QRTR_TYPE_BYE);
+			qrtr_local_enqueue(NULL, skb, QRTR_TYPE_BYE, &src, &dst);
+		}
 	}
+	spin_unlock_irqrestore(&qrtr_nodes_lock, flags);
 
 	/* Wake up any transmitters waiting for resume-tx from the node */
 	mutex_lock(&node->qrtr_tx_lock);
-- 
2.53.0



