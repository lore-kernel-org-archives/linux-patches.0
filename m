Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641D63F0AB8;
	Wed, 20 May 2026 17:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296802; cv=none; b=Au17SQUbOokJyfANI92orGWt0RHKnv+lTKmxdNlbBULr2vHvmLrL7PR089wf157wrc8kypytUtBmvQC3db2R81R44XvfnFI82mN4m7y1oWgnrdy34A4XM8/DaGk4M6+yyZQG96UNNSJAJpqoPsRUVoNiB10v8n12SP6oMFDfSzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296802; c=relaxed/simple;
	bh=6CldsTlAksE0z2Q1nc7Mj+57Bpx//PDc7svjSLvT9FA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gx0++ZIQLxDT4XKxsZmXkrc1J+kGmh2FJv7Ut7ehfgPZYc/8gpK0//zr7yS/bCQDGYwisltNSj7FPHDBtA4lLVLArJMF3n6TEzAbUGgrmPxOwxdQidJp6sWM2LcmatC0qISJSoCHWHCNClFkADWTdKagB12w4UtkzRJ8/qs55HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OOWhVeYq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OOWhVeYq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5A21F000E9;
	Wed, 20 May 2026 17:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296801;
	bh=/MP4WCC+wMQqxPcXbajUdkk295uufHg+7xwiFiovdTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OOWhVeYqciCWoD+/E+XfMlHY5lVcagrOXkEwfETWhv5H3+wBpagWY5TeG7demy9tg
	 S1weJMozmHMSX2TufkBhm0gGKoD+1c2LNZ43OxRrhXqEQy3eKtPQkAsoPXSVMBHrcN
	 TqRoEXJImfxH+taxxBUvMwWJA5RhkRHGlzYgKzl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0937/1146] net: airoha: Do not wake all netdev TX queues in airoha_qdma_wake_netdev_txqs()
Date: Wed, 20 May 2026 18:19:47 +0200
Message-ID: <20260520162209.441317388@linuxfoundation.org>
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

[ Upstream commit e070aac63b42bf81f4dc565f9f841ff47e6c992f ]

Do not wake every netdev TX queue across all ports sharing the QDMA
running netif_tx_wake_all_queues routine in airoha_qdma_wake_netdev_txqs()
but only the ones that are mapped the specific QDMA stopped hw TX queue.
This patch can potentially avoid waking already stopped netdev TX queues
that are mapped to a different QDMA hw TX queue.
Introduce airoha_qdma_get_txq utility routine.

Fixes: b94769eb2f30 ("net: airoha: Fix possible TX queue stall in airoha_qdma_tx_napi_poll()")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260421-airoha-wake_netdev_txqs-optmization-v1-1-e0be95115d53@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 19 +++++++++++++++----
 drivers/net/ethernet/airoha/airoha_eth.h |  5 +++++
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index 8819e24283abc..f9e6406ca55da 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -847,13 +847,24 @@ static void airoha_qdma_wake_netdev_txqs(struct airoha_queue *q)
 {
 	struct airoha_qdma *qdma = q->qdma;
 	struct airoha_eth *eth = qdma->eth;
-	int i;
+	int i, qid = q - &qdma->q_tx[0];
 
 	for (i = 0; i < ARRAY_SIZE(eth->ports); i++) {
 		struct airoha_gdm_port *port = eth->ports[i];
+		int j;
+
+		if (!port)
+			continue;
 
-		if (port && port->qdma == qdma)
-			netif_tx_wake_all_queues(port->dev);
+		if (port->qdma != qdma)
+			continue;
+
+		for (j = 0; j < port->dev->num_tx_queues; j++) {
+			if (airoha_qdma_get_txq(qdma, j) != qid)
+				continue;
+
+			netif_wake_subqueue(port->dev, j);
+		}
 	}
 	q->txq_stopped = false;
 }
@@ -1999,7 +2010,7 @@ static netdev_tx_t airoha_dev_xmit(struct sk_buff *skb,
 	u16 index;
 	u8 fport;
 
-	qid = skb_get_queue_mapping(skb) % ARRAY_SIZE(qdma->q_tx);
+	qid = airoha_qdma_get_txq(qdma, skb_get_queue_mapping(skb));
 	tag = airoha_get_dsa_tag(skb, dev);
 
 	msg0 = FIELD_PREP(QDMA_ETH_TXMSG_CHAN_MASK,
diff --git a/drivers/net/ethernet/airoha/airoha_eth.h b/drivers/net/ethernet/airoha/airoha_eth.h
index 46f4197007074..7098e95f0067a 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.h
+++ b/drivers/net/ethernet/airoha/airoha_eth.h
@@ -630,6 +630,11 @@ u32 airoha_rmw(void __iomem *base, u32 offset, u32 mask, u32 val);
 #define airoha_qdma_clear(qdma, offset, val)			\
 	airoha_rmw((qdma)->regs, (offset), (val), 0)
 
+static inline u16 airoha_qdma_get_txq(struct airoha_qdma *qdma, u16 qid)
+{
+	return qid % ARRAY_SIZE(qdma->q_tx);
+}
+
 static inline bool airoha_is_lan_gdm_port(struct airoha_gdm_port *port)
 {
 	/* GDM1 port on EN7581 SoC is connected to the lan dsa switch.
-- 
2.53.0



