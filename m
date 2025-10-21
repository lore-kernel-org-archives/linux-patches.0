Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D67F25A355;
	Tue, 21 Oct 2025 20:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077364; cv=none; b=UMJGdJQ/VfpDFSxcZGgobDSaSIZTCjX4h90GQjfYFr4SBcalFhIVPYgz541YH0kvGLfhxodtOi4YB/dqD5FKo2Zsbr5Gy9G2ZjxY0aqBCipCU1eiaMkOTXPpADl9+Z3hWpbowRL1olamGDCNOPtuOqf1Se8+GK5lGx8LVCoPdlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077364; c=relaxed/simple;
	bh=y566A7en1hCGn2QES0oYbz71TwpRboM04xzlnwlm4Kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A46sziM5d2AFAA37h4vY/9xnM3wJ5jI4nlFYv8OeMZsGdTaqxzDUTdKWbsKPo+4ZMPdBZjaD/9epPYQsMXdZls69Jd0I+P0ma6suo8EjTdbpHue0CMdH9YIzjjkt8ow3xYfU3JWeNQfbTIozEfsjC84PAMEuz89p3JXoeSuf7Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G6dLbpg3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G6dLbpg3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC328C4CEF1;
	Tue, 21 Oct 2025 20:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077364;
	bh=y566A7en1hCGn2QES0oYbz71TwpRboM04xzlnwlm4Kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G6dLbpg3/TadLZRu11G8GSqq90Ng8y2h34r5CbbE7BuEL0NtdEsj6a6MvFNg9Yl1x
	 1VenQG0kfQdi3PpK8GuRVJxZQBwTwugcNqSy8LHtMKSlWAkD3Jxg4JgOkS07wvaMgO
	 bBiskZKeocdLzSKRTcGeKpe4TAdVyPdjPf1f4g+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 080/159] net: airoha: Take into account out-of-order tx completions in airoha_dev_xmit()
Date: Tue, 21 Oct 2025 21:50:57 +0200
Message-ID: <20251021195045.120551583@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit bd5afca115f181c85f992d42a57cd497bc823ccb ]

Completion napi can free out-of-order tx descriptors if hw QoS is
enabled and packets with different priority are queued to same DMA ring.
Take into account possible out-of-order reports checking if the tx queue
is full using circular buffer head/tail pointer instead of the number of
queued packets.

Fixes: 23020f0493270 ("net: airoha: Introduce ethernet support for EN7581 SoC")
Suggested-by: Simon Horman <horms@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20251012-airoha-tx-busy-queue-v2-1-a600b08bab2d@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index 6d23c5c049b9a..ffb10c758c293 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -1872,6 +1872,20 @@ static u32 airoha_get_dsa_tag(struct sk_buff *skb, struct net_device *dev)
 #endif
 }
 
+static bool airoha_dev_tx_queue_busy(struct airoha_queue *q, u32 nr_frags)
+{
+	u32 tail = q->tail <= q->head ? q->tail + q->ndesc : q->tail;
+	u32 index = q->head + nr_frags;
+
+	/* completion napi can free out-of-order tx descriptors if hw QoS is
+	 * enabled and packets with different priorities are queued to the same
+	 * DMA ring. Take into account possible out-of-order reports checking
+	 * if the tx queue is full using circular buffer head/tail pointers
+	 * instead of the number of queued packets.
+	 */
+	return index >= tail;
+}
+
 static netdev_tx_t airoha_dev_xmit(struct sk_buff *skb,
 				   struct net_device *dev)
 {
@@ -1925,7 +1939,7 @@ static netdev_tx_t airoha_dev_xmit(struct sk_buff *skb,
 	txq = netdev_get_tx_queue(dev, qid);
 	nr_frags = 1 + skb_shinfo(skb)->nr_frags;
 
-	if (q->queued + nr_frags > q->ndesc) {
+	if (airoha_dev_tx_queue_busy(q, nr_frags)) {
 		/* not enough space in the queue */
 		netif_tx_stop_queue(txq);
 		spin_unlock_bh(&q->lock);
-- 
2.51.0



