Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622559;
	b=cfJpNyG0EoMLxdQn/cOR/RJRSiW1yckSJvJw6Abp5mzJa7e5T93f8SyGdfmnvy3/iC2Y
	 8OozKiMyeJbeNJEvBXZPWsf8mAAWXybQ7mgUgzLQm+pvETH5zzU0EDlV2gw0XT+FSm7FM
	 WRn1yTnLw0GIyjyeGroyL0uN7jL1UwglaSkx0nqGG+8R4Yc2cpEs4S2YsXmVZZyBEmZRv
	 mOOb5NldE7rrzCOLAu/+CO/leQ+RUtzQnCtTy2UcNv319hEhRi4jNSImLdqa6KovMuz5j
	 PAI/ovSzFafcb4q0OpIYIAzYsAsRxtU6tUSo9kHbM7MZWNCpOsGp8cZsnLJMYk+Byjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622559;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ycX+4qOYgS8qaoUpvr72bZkCbnIl6X4ZktYyqJVMgQ8=;
	b=Iox3dj2uxRuIdIROm9DJmlyf6X/J4gza6YJ0u/cyc+0xo+PTl8x9oQ9JAM9kLEAowZ8k
	 mulEF0jiYw729u5YiMj0f333cgh3M+FhwPVTzvjzN/KTK4YBI9tvHD7BupEfI2hSdMRRv
	 gKd/LdAY5z1G6C65k5gRALNS3uwcBy4lANBJaaWHtOK8l1Nu9girQYt/YrVNgcYKLEh5k
	 +eDCZgEPPV3EK9PnQxOAIfx/hahr95BLzaUY67of+dUA+1N6mGaP4UivBw6fqZ6jCgISF
	 3lABmd5J0r2n/vavw39fvodmu/rkzL7OJjHqaRBwlSEon2/TcMXoBdfVk9QpIqdM5Eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tQwz5VmW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA35606A31E;
	Wed, 25 Nov 2026 16:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tQwz5VmW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 123D41F000D0;
	Wed, 25 Nov 2026 16:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622558;
	bh=ycX+4qOYgS8qaoUpvr72bZkCbnIl6X4ZktYyqJVMgQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tQwz5VmWVO2W2eKOimdkCmcogydckdE0Huy7tU6ph7+TZjM6EcuxBxccqYQg0GjA0
	 MJYgFmzgISnYzxWEqGoqkN8Cw83Hm0AXpmNSWz/r5j4h0aeBatALIU4Hmo6Rc2c38Q
	 m8unkzp1XhGnH0tsZH/cnymnm3K8WUKK1KQOiIAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 575/990] net: stmmac: fix TX coalesce race and div-by-zero in XDP/legacy path
Date: Wed, 25 Nov 2026 15:32:22 +0100
Message-ID: <20261125143835.561650400@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit 237782c3d416b392a12642f32959e9d3c94e0c26 ]

tx_coal_frames[] is written by ethtool (stmmac_set_coalesce) and read
locklessly from the TX fast path (stmmac_xmit, stmmac_tso_xmit,
stmmac_xdp_xmit_zc and stmmac_xdp_xmit_xdpf), so pair every access
with READ_ONCE()/WRITE_ONCE() to mark the intentional data race and
read a consistent value into a local variable.

Moreover, ethtool allows disabling TX coalescing by setting
tx_max_coalesced_frames to 0: guard the modulo operation in
stmmac_xdp_xmit_xdpf() against a zero tx_coal_frames[queue] to avoid
a division by zero.

Both issues were found by code inspection while extending the XDP TX
path with multi-buff support, and neither has ever been triggered, so
they are only theoretical. Tested on the Qualcomm RB3-gen2 board.

Fixes: db2f2842e6f5 ("net: stmmac: add per-queue TX & RX coalesce ethtool support")
Fixes: be8b38a722e6 ("net: stmmac: Add support for XDP_TX action")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Link: https://patch.msgid.link/20261001-b4-stmmac-xmit-mb-v4-1-664e0c3eb289@oss.qualcomm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Dropped the duplicate pay_len, mss, queue declaration and kept this branch's local variable names (des, has_vlan, set_ic, proto_hdr_len) instead of upstream's declaration changes. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  | 11 ++---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 42 ++++++++-----------
 2 files changed, 24 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 741e3864f5094..3d501be64619f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -832,7 +832,8 @@ static int __stmmac_get_coalesce(struct net_device *dev,
 
 	if (queue < tx_cnt) {
 		ec->tx_coalesce_usecs = priv->tx_coal_timer[queue];
-		ec->tx_max_coalesced_frames = priv->tx_coal_frames[queue];
+		ec->tx_max_coalesced_frames =
+			READ_ONCE(priv->tx_coal_frames[queue]);
 	} else {
 		ec->tx_coalesce_usecs = 0;
 		ec->tx_max_coalesced_frames = 0;
@@ -921,14 +922,14 @@ static int __stmmac_set_coalesce(struct net_device *dev,
 		int i;
 
 		for (i = 0; i < tx_cnt; i++) {
-			priv->tx_coal_frames[i] =
-				ec->tx_max_coalesced_frames;
+			WRITE_ONCE(priv->tx_coal_frames[i],
+				   ec->tx_max_coalesced_frames);
 			priv->tx_coal_timer[i] =
 				ec->tx_coalesce_usecs;
 		}
 	} else if (queue < tx_cnt) {
-		priv->tx_coal_frames[queue] =
-			ec->tx_max_coalesced_frames;
+		WRITE_ONCE(priv->tx_coal_frames[queue],
+			   ec->tx_max_coalesced_frames);
 		priv->tx_coal_timer[queue] =
 			ec->tx_coalesce_usecs;
 	}
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c2b975ac8b566..0dc333218aa98 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2524,7 +2524,8 @@ static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 		struct stmmac_metadata_request meta_req;
 		struct xsk_tx_metadata *meta = NULL;
 		dma_addr_t dma_addr;
-		bool set_ic;
+		bool set_ic = false;
+		u32 tx_coal;
 
 		/* We are sharing with slow path and stop XSK TX desc submission when
 		 * available TX ring is less than threshold.
@@ -2575,12 +2576,9 @@ static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 
 		tx_q->tx_count_frames++;
 
-		if (!priv->tx_coal_frames[queue])
-			set_ic = false;
-		else if (tx_q->tx_count_frames % priv->tx_coal_frames[queue] == 0)
+		tx_coal = READ_ONCE(priv->tx_coal_frames[queue]);
+		if (tx_coal && !(tx_q->tx_count_frames % tx_coal))
 			set_ic = true;
-		else
-			set_ic = false;
 
 		meta_req.priv = priv;
 		meta_req.tx_desc = tx_desc;
@@ -3179,7 +3177,7 @@ static void stmmac_init_coalesce(struct stmmac_priv *priv)
 	for (chan = 0; chan < tx_channel_count; chan++) {
 		struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[chan];
 
-		priv->tx_coal_frames[chan] = STMMAC_TX_FRAMES;
+		WRITE_ONCE(priv->tx_coal_frames[chan], STMMAC_TX_FRAMES);
 		priv->tx_coal_timer[chan] = STMMAC_COAL_TX_TIMER;
 
 		hrtimer_setup(&tx_q->txtimer, stmmac_tx_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
@@ -4268,9 +4266,9 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct stmmac_priv *priv = netdev_priv(dev);
 	unsigned int first_entry, entry, tx_packets;
 	struct stmmac_txq_stats *txq_stats;
+	u32 tx_coal, pay_len, mss, queue;
 	int i, first_tx, nfrags, ndesc;
 	struct stmmac_tx_queue *tx_q;
-	u32 pay_len, mss, queue;
 	u8 proto_hdr_len, hdr;
 	dma_addr_t des;
 	bool set_ic;
@@ -4408,16 +4406,16 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	tx_packets = (tx_q->cur_tx + 1) - first_tx;
 	tx_q->tx_count_frames += tx_packets;
 
+	tx_coal = READ_ONCE(priv->tx_coal_frames[queue]);
 	if ((skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) && priv->hwts_tx_en)
 		set_ic = true;
-	else if (!priv->tx_coal_frames[queue])
+	else if (!tx_coal)
 		set_ic = false;
 	else if (!netdev_xmit_more())
 		set_ic = true;
-	else if (tx_packets > priv->tx_coal_frames[queue])
+	else if (tx_packets > tx_coal)
 		set_ic = true;
-	else if ((tx_q->tx_count_frames %
-		  priv->tx_coal_frames[queue]) < tx_packets)
+	else if ((tx_q->tx_count_frames % tx_coal) < tx_packets)
 		set_ic = true;
 	else
 		set_ic = false;
@@ -4563,7 +4561,7 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 	bool has_vlan, set_ic;
 	int entry, first_tx;
 	dma_addr_t des;
-	u32 sdu_len;
+	u32 tx_coal, sdu_len;
 
 	tx_q = &priv->dma_conf.tx_queue[queue];
 	txq_stats = &priv->xstats.txq_stats[queue];
@@ -4697,16 +4695,16 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 	tx_packets = (entry + 1) - first_tx;
 	tx_q->tx_count_frames += tx_packets;
 
+	tx_coal = READ_ONCE(priv->tx_coal_frames[queue]);
 	if ((skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) && priv->hwts_tx_en)
 		set_ic = true;
-	else if (!priv->tx_coal_frames[queue])
+	else if (!tx_coal)
 		set_ic = false;
 	else if (!netdev_xmit_more())
 		set_ic = true;
-	else if (tx_packets > priv->tx_coal_frames[queue])
+	else if (tx_packets > tx_coal)
 		set_ic = true;
-	else if ((tx_q->tx_count_frames %
-		  priv->tx_coal_frames[queue]) < tx_packets)
+	else if ((tx_q->tx_count_frames % tx_coal) < tx_packets)
 		set_ic = true;
 	else
 		set_ic = false;
@@ -5008,7 +5006,7 @@ static int stmmac_xdp_xmit_xdpf(struct stmmac_priv *priv, int queue,
 	unsigned int entry = tx_q->cur_tx;
 	struct dma_desc *tx_desc;
 	dma_addr_t dma_addr;
-	bool set_ic;
+	u32 tx_coal;
 
 	if (stmmac_tx_avail(priv, queue) < STMMAC_TX_THRESH(priv))
 		return STMMAC_XDP_CONSUMED;
@@ -5061,12 +5059,8 @@ static int stmmac_xdp_xmit_xdpf(struct stmmac_priv *priv, int queue,
 
 	tx_q->tx_count_frames++;
 
-	if (tx_q->tx_count_frames % priv->tx_coal_frames[queue] == 0)
-		set_ic = true;
-	else
-		set_ic = false;
-
-	if (set_ic) {
+	tx_coal = READ_ONCE(priv->tx_coal_frames[queue]);
+	if (tx_coal && !(tx_q->tx_count_frames % tx_coal)) {
 		tx_q->tx_count_frames = 0;
 		stmmac_set_tx_ic(priv, tx_desc);
 		u64_stats_update_begin(&txq_stats->q_syncp);
-- 
2.53.0



