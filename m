Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2040336494B;
	Wed, 20 May 2026 17:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296797; cv=none; b=tBVAYVVOar887nNkBBdz08MZze8pXNabwJJ7F8Jhe93Ucr0cuFfgBYIfSXNpKtPi6ZkdwrQWsmqGfq4afR2go8wP17y+T+dcj7W4anoap3rREsE8bsawHCcewMicwoU5rb0J5xXd/FDcZw4+ybeSq/rFInoY/Lazi1esBLrD1go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296797; c=relaxed/simple;
	bh=6YcistEXAHR46oZzqWCTBn0ss+wpmaP3HLCLW+lCa7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L2nMkrnWPlTGrAUo9oq7DDHcicXQgyumASKBFX7uYe70Ia/O23OMf+pWuIw9R4Q0w/jmhcKKuTg9syXqMsK1EoIUyndoUVsEBnHZXcj70Z5c3LkB+YXCCKqYykHnrwVUq9b0wHx2pM0YYYcMP6MH3O9F0rUoxWXkzivXiERPJ1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GEReHb3X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GEReHb3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C1A1F000E9;
	Wed, 20 May 2026 17:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296796;
	bh=AAdIsMpcBibQP93e7+U586zClDSvBGYYbEN3RZVFwIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GEReHb3Xi+c163xX3swR8c8wJPbnNwQfpxIB07SdUSfbhJRDYuZzt3w96Xg+OcpzQ
	 3ukemJBbszBCz46teDR4vUuctPUMNpLwKs/yfizWacj9q5nWSR5IIpBQoUlGRWG0mD
	 CqJMOHOkUMR8O+W/DopxGX5r3A1VPtcM5kq2q9vU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0935/1146] net: airoha: stop net_device TX queue before updating CPU index
Date: Wed, 20 May 2026 18:19:45 +0200
Message-ID: <20260520162209.394838315@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 3854de7b38be742cf7558476956d12414cb274f2 ]

Currently, airoha_eth driver updates the CPU index register prior of
verifying whether the number of free descriptors has fallen below the
threshold.
Move net_device TX queue length check before updating the TX CPU index
in order to update TX CPU index even if there are more packets to be
transmitted but the net_device TX queue is going to be stopped
accounting the inflight packets.

Fixes: 1d304174106c ("net: airoha: Implement BQL support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260421-airoha-xmit-stop-condition-v1-1-e670d6a48467@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index a73c224d65755..4b804ca927819 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -2092,17 +2092,16 @@ static netdev_tx_t airoha_dev_xmit(struct sk_buff *skb,
 
 	skb_tx_timestamp(skb);
 	netdev_tx_sent_queue(txq, skb->len);
+	if (q->ndesc - q->queued < q->free_thr) {
+		netif_tx_stop_queue(txq);
+		q->txq_stopped = true;
+	}
 
 	if (netif_xmit_stopped(txq) || !netdev_xmit_more())
 		airoha_qdma_rmw(qdma, REG_TX_CPU_IDX(qid),
 				TX_RING_CPU_IDX_MASK,
 				FIELD_PREP(TX_RING_CPU_IDX_MASK, index));
 
-	if (q->ndesc - q->queued < q->free_thr) {
-		netif_tx_stop_queue(txq);
-		q->txq_stopped = true;
-	}
-
 	spin_unlock_bh(&q->lock);
 
 	return NETDEV_TX_OK;
-- 
2.53.0



