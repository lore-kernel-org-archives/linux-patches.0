Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B0136405A;
	Wed, 20 May 2026 17:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299181; cv=none; b=H8Ot4AZCsBjN/kgNf53Us2T+cbq4sLCdLTxHMIrLw/UehrRDXEXVXWse4YrrWTxOpq0vislTS+iNHKHm5EkYWzR3Ryw4qkGahh/ehUhWEpptNCzs3ry9o8OZWHXzb3NxHqsfVpWsRaIi1NLwHvnMnCK/N+eOeXDFeFawYxHHvxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299181; c=relaxed/simple;
	bh=vA9vzqHxUWjIovGY2t92UcmY2m4FpM7NvOTP9nymTqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVbOBfuJRUzhumEzhzIv9Y1hpJx7QobKn8dfED/vwNumqqbc1HUUl7ZV4H46I1aKprTua9p3hdHqimah+k0MzvnjNbRuVmYWeMSU5V5dywF1wt1512uGzLeR48V61yV8AK6dLR9jyGFGMZEUIITUQQYJKrutX8wErtM/92cAry0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0SqKWCCL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0SqKWCCL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E501F000E9;
	Wed, 20 May 2026 17:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299180;
	bh=1jqWgB2zcmadOyhUvIolOBi3Pt0LvIS+Y95PPhN+nKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0SqKWCCLsaIQXqJTxZ2TJbbRwOfUEaVEWa+KCS7eXNnMYAGPwAroAxDGudbFA0JY1
	 5XlsL/MEwH7Ob80X3BD1jDRKj5g1fuxPUfKIgIrgjWvcPpouI1qeQ2OCh0CaoMARq+
	 k6WaCewwhendrfFPkFyrEh4qCK6DWh+5JzPKvhFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 692/957] net: airoha: ppe: Move PPE memory info in airoha_eth_soc_data struct
Date: Wed, 20 May 2026 18:19:35 +0200
Message-ID: <20260520162149.547373532@linuxfoundation.org>
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

[ Upstream commit 5bd1d1fd48ea9f8300b211540d946899c7f96480 ]

AN7583 SoC runs a single PPE device while EN7581 runs two of them.
Moreover PPE SRAM in AN7583 SoC is reduced to 8K (while SRAM is 16K on
EN7581). Take into account PPE memory layout during PPE configuration.

Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20251017-an7583-eth-support-v3-6-f28319666667@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 3309965fe44c ("net: airoha: Add missing bits in airoha_qdma_cleanup_tx_queue()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.h      |  10 +-
 drivers/net/ethernet/airoha/airoha_ppe.c      | 133 +++++++++---------
 .../net/ethernet/airoha/airoha_ppe_debugfs.c  |   3 +-
 3 files changed, 70 insertions(+), 76 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.h b/drivers/net/ethernet/airoha/airoha_eth.h
index 9929c44d84702..8d121d12dc120 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.h
+++ b/drivers/net/ethernet/airoha/airoha_eth.h
@@ -47,14 +47,9 @@
 #define QDMA_METER_IDX(_n)		((_n) & 0xff)
 #define QDMA_METER_GROUP(_n)		(((_n) >> 8) & 0x3)
 
-#define PPE_NUM				2
-#define PPE1_SRAM_NUM_ENTRIES		(8 * 1024)
-#define PPE_SRAM_NUM_ENTRIES		(PPE_NUM * PPE1_SRAM_NUM_ENTRIES)
-#define PPE1_STATS_NUM_ENTRIES		(4 * 1024)
-#define PPE_STATS_NUM_ENTRIES		(PPE_NUM * PPE1_STATS_NUM_ENTRIES)
+#define PPE_SRAM_NUM_ENTRIES		(8 * 1024)
+#define PPE_STATS_NUM_ENTRIES		(4 * 1024)
 #define PPE_DRAM_NUM_ENTRIES		(16 * 1024)
-#define PPE_NUM_ENTRIES			(PPE_SRAM_NUM_ENTRIES + PPE_DRAM_NUM_ENTRIES)
-#define PPE_HASH_MASK			(PPE_NUM_ENTRIES - 1)
 #define PPE_ENTRY_SIZE			80
 #define PPE_RAM_NUM_ENTRIES_SHIFT(_n)	(__ffs((_n) >> 10))
 
@@ -635,6 +630,7 @@ int airoha_ppe_setup_tc_block_cb(struct airoha_ppe_dev *dev, void *type_data);
 int airoha_ppe_init(struct airoha_eth *eth);
 void airoha_ppe_deinit(struct airoha_eth *eth);
 void airoha_ppe_init_upd_mem(struct airoha_gdm_port *port);
+u32 airoha_ppe_get_total_num_entries(struct airoha_ppe *ppe);
 struct airoha_foe_entry *airoha_ppe_foe_get_entry(struct airoha_ppe *ppe,
 						  u32 hash);
 void airoha_ppe_foe_entry_get_stats(struct airoha_ppe *ppe, u32 hash,
diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ethernet/airoha/airoha_ppe.c
index 072cc2dd50dda..239c43248b4f4 100644
--- a/drivers/net/ethernet/airoha/airoha_ppe.c
+++ b/drivers/net/ethernet/airoha/airoha_ppe.c
@@ -37,19 +37,36 @@ static int airoha_ppe_get_num_stats_entries(struct airoha_ppe *ppe)
 	if (!IS_ENABLED(CONFIG_NET_AIROHA_FLOW_STATS))
 		return -EOPNOTSUPP;
 
-	return PPE1_STATS_NUM_ENTRIES;
+	return PPE_STATS_NUM_ENTRIES;
 }
 
 static int airoha_ppe_get_total_num_stats_entries(struct airoha_ppe *ppe)
 {
 	int num_stats = airoha_ppe_get_num_stats_entries(ppe);
 
-	if (num_stats > 0)
-		num_stats = num_stats * PPE_NUM;
+	if (num_stats > 0) {
+		struct airoha_eth *eth = ppe->eth;
+
+		num_stats = num_stats * eth->soc->num_ppe;
+	}
 
 	return num_stats;
 }
 
+static u32 airoha_ppe_get_total_sram_num_entries(struct airoha_ppe *ppe)
+{
+	struct airoha_eth *eth = ppe->eth;
+
+	return PPE_SRAM_NUM_ENTRIES * eth->soc->num_ppe;
+}
+
+u32 airoha_ppe_get_total_num_entries(struct airoha_ppe *ppe)
+{
+	u32 sram_num_entries = airoha_ppe_get_total_sram_num_entries(ppe);
+
+	return sram_num_entries + PPE_DRAM_NUM_ENTRIES;
+}
+
 bool airoha_ppe_is_enabled(struct airoha_eth *eth, int index)
 {
 	if (index >= eth->soc->num_ppe)
@@ -67,14 +84,22 @@ static u32 airoha_ppe_get_timestamp(struct airoha_ppe *ppe)
 
 static void airoha_ppe_hw_init(struct airoha_ppe *ppe)
 {
-	u32 sram_tb_size, sram_num_entries, dram_num_entries;
+	u32 sram_ppe_num_data_entries = PPE_SRAM_NUM_ENTRIES, sram_num_entries;
+	u32 sram_tb_size, dram_num_entries;
 	struct airoha_eth *eth = ppe->eth;
 	int i, sram_num_stats_entries;
 
-	sram_tb_size = PPE_SRAM_NUM_ENTRIES * sizeof(struct airoha_foe_entry);
+	sram_num_entries = airoha_ppe_get_total_sram_num_entries(ppe);
+	sram_tb_size = sram_num_entries * sizeof(struct airoha_foe_entry);
 	dram_num_entries = PPE_RAM_NUM_ENTRIES_SHIFT(PPE_DRAM_NUM_ENTRIES);
 
-	for (i = 0; i < PPE_NUM; i++) {
+	sram_num_stats_entries = airoha_ppe_get_num_stats_entries(ppe);
+	if (sram_num_stats_entries > 0)
+		sram_ppe_num_data_entries -= sram_num_stats_entries;
+	sram_ppe_num_data_entries =
+		PPE_RAM_NUM_ENTRIES_SHIFT(sram_ppe_num_data_entries);
+
+	for (i = 0; i < eth->soc->num_ppe; i++) {
 		int p;
 
 		airoha_fe_wr(eth, REG_PPE_TB_BASE(i),
@@ -106,10 +131,16 @@ static void airoha_ppe_hw_init(struct airoha_ppe *ppe)
 
 		airoha_fe_rmw(eth, REG_PPE_TB_CFG(i),
 			      PPE_TB_CFG_SEARCH_MISS_MASK |
+			      PPE_SRAM_TB_NUM_ENTRY_MASK |
+			      PPE_DRAM_TB_NUM_ENTRY_MASK |
 			      PPE_TB_CFG_KEEPALIVE_MASK |
 			      PPE_TB_ENTRY_SIZE_MASK,
 			      FIELD_PREP(PPE_TB_CFG_SEARCH_MISS_MASK, 3) |
-			      FIELD_PREP(PPE_TB_ENTRY_SIZE_MASK, 0));
+			      FIELD_PREP(PPE_TB_ENTRY_SIZE_MASK, 0) |
+			      FIELD_PREP(PPE_SRAM_TB_NUM_ENTRY_MASK,
+					 sram_ppe_num_data_entries) |
+			      FIELD_PREP(PPE_DRAM_TB_NUM_ENTRY_MASK,
+					 dram_num_entries));
 
 		airoha_fe_rmw(eth, REG_PPE_BIND_RATE(i),
 			      PPE_BIND_RATE_L2B_BIND_MASK |
@@ -130,45 +161,6 @@ static void airoha_ppe_hw_init(struct airoha_ppe *ppe)
 				      FIELD_PREP(FP1_EGRESS_MTU_MASK,
 						 AIROHA_MAX_MTU));
 	}
-
-	if (airoha_ppe_is_enabled(eth, 1)) {
-		sram_num_entries = PPE1_SRAM_NUM_ENTRIES;
-		sram_num_stats_entries =
-			airoha_ppe_get_num_stats_entries(ppe);
-		if (sram_num_stats_entries > 0)
-			sram_num_entries -= sram_num_stats_entries;
-		sram_num_entries = PPE_RAM_NUM_ENTRIES_SHIFT(sram_num_entries);
-
-		airoha_fe_rmw(eth, REG_PPE_TB_CFG(0),
-			      PPE_SRAM_TB_NUM_ENTRY_MASK |
-			      PPE_DRAM_TB_NUM_ENTRY_MASK,
-			      FIELD_PREP(PPE_SRAM_TB_NUM_ENTRY_MASK,
-					 sram_num_entries) |
-			      FIELD_PREP(PPE_DRAM_TB_NUM_ENTRY_MASK,
-					 dram_num_entries));
-		airoha_fe_rmw(eth, REG_PPE_TB_CFG(1),
-			      PPE_SRAM_TB_NUM_ENTRY_MASK |
-			      PPE_DRAM_TB_NUM_ENTRY_MASK,
-			      FIELD_PREP(PPE_SRAM_TB_NUM_ENTRY_MASK,
-					 sram_num_entries) |
-			      FIELD_PREP(PPE_DRAM_TB_NUM_ENTRY_MASK,
-					 dram_num_entries));
-	} else {
-		sram_num_entries = PPE_SRAM_NUM_ENTRIES;
-		sram_num_stats_entries =
-			airoha_ppe_get_total_num_stats_entries(ppe);
-		if (sram_num_stats_entries > 0)
-			sram_num_entries -= sram_num_stats_entries;
-		sram_num_entries = PPE_RAM_NUM_ENTRIES_SHIFT(sram_num_entries);
-
-		airoha_fe_rmw(eth, REG_PPE_TB_CFG(0),
-			      PPE_SRAM_TB_NUM_ENTRY_MASK |
-			      PPE_DRAM_TB_NUM_ENTRY_MASK,
-			      FIELD_PREP(PPE_SRAM_TB_NUM_ENTRY_MASK,
-					 sram_num_entries) |
-			      FIELD_PREP(PPE_DRAM_TB_NUM_ENTRY_MASK,
-					 dram_num_entries));
-	}
 }
 
 static void airoha_ppe_flow_mangle_eth(const struct flow_action_entry *act, void *eth)
@@ -469,9 +461,11 @@ static int airoha_ppe_foe_entry_set_ipv6_tuple(struct airoha_foe_entry *hwe,
 	return 0;
 }
 
-static u32 airoha_ppe_foe_get_entry_hash(struct airoha_foe_entry *hwe)
+static u32 airoha_ppe_foe_get_entry_hash(struct airoha_ppe *ppe,
+					 struct airoha_foe_entry *hwe)
 {
 	int type = FIELD_GET(AIROHA_FOE_IB1_BIND_PACKET_TYPE, hwe->ib1);
+	u32 ppe_hash_mask = airoha_ppe_get_total_num_entries(ppe) - 1;
 	u32 hash, hv1, hv2, hv3;
 
 	switch (type) {
@@ -509,14 +503,14 @@ static u32 airoha_ppe_foe_get_entry_hash(struct airoha_foe_entry *hwe)
 	case PPE_PKT_TYPE_IPV6_6RD:
 	default:
 		WARN_ON_ONCE(1);
-		return PPE_HASH_MASK;
+		return ppe_hash_mask;
 	}
 
 	hash = (hv1 & hv2) | ((~hv1) & hv3);
 	hash = (hash >> 24) | ((hash & 0xffffff) << 8);
 	hash ^= hv1 ^ hv2 ^ hv3;
 	hash ^= hash >> 16;
-	hash &= PPE_NUM_ENTRIES - 1;
+	hash &= ppe_hash_mask;
 
 	return hash;
 }
@@ -617,9 +611,11 @@ static void airoha_ppe_foe_flow_stats_update(struct airoha_ppe *ppe,
 static struct airoha_foe_entry *
 airoha_ppe_foe_get_entry_locked(struct airoha_ppe *ppe, u32 hash)
 {
+	u32 sram_num_entries = airoha_ppe_get_total_sram_num_entries(ppe);
+
 	lockdep_assert_held(&ppe_lock);
 
-	if (hash < PPE_SRAM_NUM_ENTRIES) {
+	if (hash < sram_num_entries) {
 		u32 *hwe = ppe->foe + hash * sizeof(struct airoha_foe_entry);
 		struct airoha_eth *eth = ppe->eth;
 		bool ppe2;
@@ -627,7 +623,7 @@ airoha_ppe_foe_get_entry_locked(struct airoha_ppe *ppe, u32 hash)
 		int i;
 
 		ppe2 = airoha_ppe_is_enabled(ppe->eth, 1) &&
-		       hash >= PPE1_SRAM_NUM_ENTRIES;
+		       hash >= PPE_SRAM_NUM_ENTRIES;
 		airoha_fe_wr(ppe->eth, REG_PPE_RAM_CTRL(ppe2),
 			     FIELD_PREP(PPE_SRAM_CTRL_ENTRY_MASK, hash) |
 			     PPE_SRAM_CTRL_REQ_MASK);
@@ -678,6 +674,7 @@ static int airoha_ppe_foe_commit_entry(struct airoha_ppe *ppe,
 				       struct airoha_foe_entry *e,
 				       u32 hash, bool rx_wlan)
 {
+	u32 sram_num_entries = airoha_ppe_get_total_sram_num_entries(ppe);
 	struct airoha_foe_entry *hwe = ppe->foe + hash * sizeof(*hwe);
 	u32 ts = airoha_ppe_get_timestamp(ppe);
 	struct airoha_eth *eth = ppe->eth;
@@ -702,10 +699,10 @@ static int airoha_ppe_foe_commit_entry(struct airoha_ppe *ppe,
 	if (!rx_wlan)
 		airoha_ppe_foe_flow_stats_update(ppe, npu, hwe, hash);
 
-	if (hash < PPE_SRAM_NUM_ENTRIES) {
+	if (hash < sram_num_entries) {
 		dma_addr_t addr = ppe->foe_dma + hash * sizeof(*hwe);
 		bool ppe2 = airoha_ppe_is_enabled(eth, 1) &&
-			    hash >= PPE1_SRAM_NUM_ENTRIES;
+			    hash >= PPE_SRAM_NUM_ENTRIES;
 
 		err = npu->ops.ppe_foe_commit_entry(npu, addr, sizeof(*hwe),
 						    hash, ppe2);
@@ -832,7 +829,7 @@ static void airoha_ppe_foe_insert_entry(struct airoha_ppe *ppe,
 	if (state == AIROHA_FOE_STATE_BIND)
 		goto unlock;
 
-	index = airoha_ppe_foe_get_entry_hash(hwe);
+	index = airoha_ppe_foe_get_entry_hash(ppe, hwe);
 	hlist_for_each_entry_safe(e, n, &ppe->foe_flow[index], list) {
 		if (e->type == FLOW_TYPE_L2_SUBFLOW) {
 			state = FIELD_GET(AIROHA_FOE_IB1_BIND_STATE, hwe->ib1);
@@ -892,7 +889,7 @@ static int airoha_ppe_foe_flow_commit_entry(struct airoha_ppe *ppe,
 	if (type == PPE_PKT_TYPE_BRIDGE)
 		return airoha_ppe_foe_l2_flow_commit_entry(ppe, e);
 
-	hash = airoha_ppe_foe_get_entry_hash(&e->data);
+	hash = airoha_ppe_foe_get_entry_hash(ppe, &e->data);
 	e->type = FLOW_TYPE_L4;
 	e->hash = 0xffff;
 
@@ -1296,17 +1293,15 @@ static int airoha_ppe_flow_offload_cmd(struct airoha_eth *eth,
 static int airoha_ppe_flush_sram_entries(struct airoha_ppe *ppe,
 					 struct airoha_npu *npu)
 {
-	int i, sram_num_entries = PPE_SRAM_NUM_ENTRIES;
+	u32 sram_num_entries = airoha_ppe_get_total_sram_num_entries(ppe);
 	struct airoha_foe_entry *hwe = ppe->foe;
+	int i;
 
-	if (airoha_ppe_is_enabled(ppe->eth, 1))
-		sram_num_entries = sram_num_entries / 2;
-
-	for (i = 0; i < sram_num_entries; i++)
+	for (i = 0; i < PPE_SRAM_NUM_ENTRIES; i++)
 		memset(&hwe[i], 0, sizeof(*hwe));
 
 	return npu->ops.ppe_flush_sram_entries(npu, ppe->foe_dma,
-					       PPE_SRAM_NUM_ENTRIES);
+					       sram_num_entries);
 }
 
 static struct airoha_npu *airoha_ppe_npu_get(struct airoha_eth *eth)
@@ -1410,9 +1405,10 @@ void airoha_ppe_check_skb(struct airoha_ppe_dev *dev, struct sk_buff *skb,
 			  u16 hash, bool rx_wlan)
 {
 	struct airoha_ppe *ppe = dev->priv;
+	u32 ppe_hash_mask = airoha_ppe_get_total_num_entries(ppe) - 1;
 	u16 now, diff;
 
-	if (hash > PPE_HASH_MASK)
+	if (hash > ppe_hash_mask)
 		return;
 
 	now = (u16)jiffies;
@@ -1503,6 +1499,7 @@ EXPORT_SYMBOL_GPL(airoha_ppe_put_dev);
 int airoha_ppe_init(struct airoha_eth *eth)
 {
 	int foe_size, err, ppe_num_stats_entries;
+	u32 ppe_num_entries;
 	struct airoha_ppe *ppe;
 
 	ppe = devm_kzalloc(eth->dev, sizeof(*ppe), GFP_KERNEL);
@@ -1512,18 +1509,18 @@ int airoha_ppe_init(struct airoha_eth *eth)
 	ppe->dev.ops.setup_tc_block_cb = airoha_ppe_setup_tc_block_cb;
 	ppe->dev.ops.check_skb = airoha_ppe_check_skb;
 	ppe->dev.priv = ppe;
+	ppe->eth = eth;
+	eth->ppe = ppe;
 
-	foe_size = PPE_NUM_ENTRIES * sizeof(struct airoha_foe_entry);
+	ppe_num_entries = airoha_ppe_get_total_num_entries(ppe);
+	foe_size = ppe_num_entries * sizeof(struct airoha_foe_entry);
 	ppe->foe = dmam_alloc_coherent(eth->dev, foe_size, &ppe->foe_dma,
 				       GFP_KERNEL);
 	if (!ppe->foe)
 		return -ENOMEM;
 
-	ppe->eth = eth;
-	eth->ppe = ppe;
-
 	ppe->foe_flow = devm_kzalloc(eth->dev,
-				     PPE_NUM_ENTRIES * sizeof(*ppe->foe_flow),
+				     ppe_num_entries * sizeof(*ppe->foe_flow),
 				     GFP_KERNEL);
 	if (!ppe->foe_flow)
 		return -ENOMEM;
@@ -1538,7 +1535,7 @@ int airoha_ppe_init(struct airoha_eth *eth)
 			return -ENOMEM;
 	}
 
-	ppe->foe_check_time = devm_kzalloc(eth->dev, PPE_NUM_ENTRIES,
+	ppe->foe_check_time = devm_kzalloc(eth->dev, ppe_num_entries,
 					   GFP_KERNEL);
 	if (!ppe->foe_check_time)
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/airoha/airoha_ppe_debugfs.c b/drivers/net/ethernet/airoha/airoha_ppe_debugfs.c
index 05a756233f6a4..0112c41150bb0 100644
--- a/drivers/net/ethernet/airoha/airoha_ppe_debugfs.c
+++ b/drivers/net/ethernet/airoha/airoha_ppe_debugfs.c
@@ -53,9 +53,10 @@ static int airoha_ppe_debugfs_foe_show(struct seq_file *m, void *private,
 		[AIROHA_FOE_STATE_FIN] = "FIN",
 	};
 	struct airoha_ppe *ppe = m->private;
+	u32 ppe_num_entries = airoha_ppe_get_total_num_entries(ppe);
 	int i;
 
-	for (i = 0; i < PPE_NUM_ENTRIES; i++) {
+	for (i = 0; i < ppe_num_entries; i++) {
 		const char *state_str, *type_str = "UNKNOWN";
 		void *src_addr = NULL, *dest_addr = NULL;
 		u16 *src_port = NULL, *dest_port = NULL;
-- 
2.53.0



