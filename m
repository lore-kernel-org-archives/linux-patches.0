Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104453F23CC;
	Wed, 20 May 2026 17:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299441; cv=none; b=onpvt7c+zsaDlQCzpF/jil/V0dHYT4QbFdvwBd4dqgF5OzVNLGF2ZnwApz1TegJtK2ttV9C5YN3+yMWzz45x8DYG138VEx66wCplaKTgS2TqoqMBljN0eRbbuLPRfY5RREvfM88vX3PxywqAewX089uB/QB20CcwdZ1/hjQJ0Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299441; c=relaxed/simple;
	bh=eJR4pG3vQBGrcZBUk5nV9QyE5J/9HNo339xQaFGSRX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JuLDXC3AraFBcx4QIBhTIQywM7iByBsWGRYjh58py68y+4YDNC8EJv8hQEdlYgsqnH54Q45lFkwVIg8cCpdXwpE2B2NOacC9LTLDWQTjCXz6ezd4tXNo8/GVfq1imJMUm6qG06EYMjdN0nN7QFQIsMffGrd/xzRwyEgKCQQOCy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=11GtN+5W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="11GtN+5W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751B21F000E9;
	Wed, 20 May 2026 17:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299440;
	bh=oPwj3EicaAZDDOokecdaoTQQvlG4Vm4DOtUujVW1ucM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=11GtN+5WNbulQ55xlJnAt+5n526bZOuSgpfXrZgGu81mEGvv+Tt1+m5WHV2X1peQi
	 A7xzJcCgA1d4oUuf7rBXcvv7445x1rfGfH3YwvEkCVCd7k6jN2FKQgpdPX/Kz5PXPG
	 3w6LXVlwSSAHylxNwRN+8GmuZY48CY3ba6b2gG+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 773/957] net: airoha: Do not wake all netdev TX queues in airoha_qdma_wake_netdev_txqs()
Date: Wed, 20 May 2026 18:20:56 +0200
Message-ID: <20260520162151.325337538@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9691b4134285f..7d7f2bf6172a3 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -878,13 +878,24 @@ static void airoha_qdma_wake_netdev_txqs(struct airoha_queue *q)
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
@@ -2018,7 +2029,7 @@ static netdev_tx_t airoha_dev_xmit(struct sk_buff *skb,
 	u16 index;
 	u8 fport;
 
-	qid = skb_get_queue_mapping(skb) % ARRAY_SIZE(qdma->q_tx);
+	qid = airoha_qdma_get_txq(qdma, skb_get_queue_mapping(skb));
 	tag = airoha_get_dsa_tag(skb, dev);
 
 	msg0 = FIELD_PREP(QDMA_ETH_TXMSG_CHAN_MASK,
diff --git a/drivers/net/ethernet/airoha/airoha_eth.h b/drivers/net/ethernet/airoha/airoha_eth.h
index abd996492cb7f..33277cc577990 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.h
+++ b/drivers/net/ethernet/airoha/airoha_eth.h
@@ -627,6 +627,11 @@ u32 airoha_rmw(void __iomem *base, u32 offset, u32 mask, u32 val);
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



