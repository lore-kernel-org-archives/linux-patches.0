Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8975F3BED26;
	Wed, 20 May 2026 17:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297747; cv=none; b=Z4Uc0ymEb4sxu0EmzPQxOYd8zE5bAL5aH7sHpf4WMZjB1vLUPWXOzCGA6PGumlJh67cjERdNCoUfGTsasxNHB8b7ogdGESGDc7D0u+ZDtAN2W9LcEVZHqQdpijvE7aaAX7pc3Hv8f11zmfHDRinF49R3Sr/P3+Mv7ne7VlgE+Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297747; c=relaxed/simple;
	bh=hvklo49y+K+3cyO0Z0qn/drdYbwS9A1QHNnOiBn0MoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/sRuX00I277VE1DhhlmhVK9CeFengmFqHUs/7fsNynR0FXT3yUsGmVWfyvSUZmO4KnkbUsy+PRi0wz7rSr1tdObA0ynjGOzJxKdXbv7T4ILiPvuvbm08JZc5i5spX56USzr5tzVJVD70Xn3j6qMJ7bJFSOQmwhrl7NZuqbl7t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TxTBWHVp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TxTBWHVp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A80821F000E9;
	Wed, 20 May 2026 17:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297746;
	bh=dtjb4JtRlwI6F+LjfrFKyBlSP9G2TZ0c4lM6kIkUAXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TxTBWHVpnWfuCMoewyJRYcHlUA6Yer+R7vqRnir0AfKyXPGt+v0n8IL8UgZUfrSlq
	 aeWPR13DP8sQmt3Jb1pP8H6rHMQUVwFDBq0wCBQDQpOBakNGkN3zfJalhZNIKF0vIS
	 rMdE6wJg68/xQ4LZCcBAHCCFE14RqobUTS650qTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 148/957] net: airoha: Add airoha_ppe_get_num_stats_entries() and airoha_ppe_get_num_total_stats_entries()
Date: Wed, 20 May 2026 18:10:31 +0200
Message-ID: <20260520162137.764018429@linuxfoundation.org>
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

[ Upstream commit 15f357cd4581ce6e02e5e97719320600783140ec ]

Introduce airoha_ppe_get_num_stats_entries and
airoha_ppe_get_num_total_stats_entries routines in order to make the
code more readable controlling if CONFIG_NET_AIROHA_FLOW_STATS is
enabled or disabled.
Modify airoha_ppe_foe_get_flow_stats_index routine signature relying on
airoha_ppe_get_num_total_stats_entries().

Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20251017-an7583-eth-support-v3-3-f28319666667@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 02f729643959 ("net: airoha: Fix FE_PSE_BUF_SET configuration if PPE2 is available")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.h |  10 +--
 drivers/net/ethernet/airoha/airoha_ppe.c | 101 ++++++++++++++++++-----
 2 files changed, 81 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.h b/drivers/net/ethernet/airoha/airoha_eth.h
index cd13c1c1224f6..3e43f01e9a652 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.h
+++ b/drivers/net/ethernet/airoha/airoha_eth.h
@@ -50,15 +50,9 @@
 
 #define PPE_NUM				2
 #define PPE1_SRAM_NUM_ENTRIES		(8 * 1024)
-#define PPE_SRAM_NUM_ENTRIES		(2 * PPE1_SRAM_NUM_ENTRIES)
-#ifdef CONFIG_NET_AIROHA_FLOW_STATS
+#define PPE_SRAM_NUM_ENTRIES		(PPE_NUM * PPE1_SRAM_NUM_ENTRIES)
 #define PPE1_STATS_NUM_ENTRIES		(4 * 1024)
-#else
-#define PPE1_STATS_NUM_ENTRIES		0
-#endif /* CONFIG_NET_AIROHA_FLOW_STATS */
-#define PPE_STATS_NUM_ENTRIES		(2 * PPE1_STATS_NUM_ENTRIES)
-#define PPE1_SRAM_NUM_DATA_ENTRIES	(PPE1_SRAM_NUM_ENTRIES - PPE1_STATS_NUM_ENTRIES)
-#define PPE_SRAM_NUM_DATA_ENTRIES	(2 * PPE1_SRAM_NUM_DATA_ENTRIES)
+#define PPE_STATS_NUM_ENTRIES		(PPE_NUM * PPE1_STATS_NUM_ENTRIES)
 #define PPE_DRAM_NUM_ENTRIES		(16 * 1024)
 #define PPE_NUM_ENTRIES			(PPE_SRAM_NUM_ENTRIES + PPE_DRAM_NUM_ENTRIES)
 #define PPE_HASH_MASK			(PPE_NUM_ENTRIES - 1)
diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ethernet/airoha/airoha_ppe.c
index b3632f964a580..117dfc21d6a81 100644
--- a/drivers/net/ethernet/airoha/airoha_ppe.c
+++ b/drivers/net/ethernet/airoha/airoha_ppe.c
@@ -32,6 +32,24 @@ static const struct rhashtable_params airoha_l2_flow_table_params = {
 	.automatic_shrinking = true,
 };
 
+static int airoha_ppe_get_num_stats_entries(struct airoha_ppe *ppe)
+{
+	if (!IS_ENABLED(CONFIG_NET_AIROHA_FLOW_STATS))
+		return -EOPNOTSUPP;
+
+	return PPE1_STATS_NUM_ENTRIES;
+}
+
+static int airoha_ppe_get_total_num_stats_entries(struct airoha_ppe *ppe)
+{
+	int num_stats = airoha_ppe_get_num_stats_entries(ppe);
+
+	if (num_stats > 0)
+		num_stats = num_stats * PPE_NUM;
+
+	return num_stats;
+}
+
 static bool airoha_ppe2_is_enabled(struct airoha_eth *eth)
 {
 	return airoha_fe_rr(eth, REG_PPE_GLO_CFG(1)) & PPE_GLO_CFG_EN_MASK;
@@ -48,7 +66,7 @@ static void airoha_ppe_hw_init(struct airoha_ppe *ppe)
 {
 	u32 sram_tb_size, sram_num_entries, dram_num_entries;
 	struct airoha_eth *eth = ppe->eth;
-	int i;
+	int i, sram_num_stats_entries;
 
 	sram_tb_size = PPE_SRAM_NUM_ENTRIES * sizeof(struct airoha_foe_entry);
 	dram_num_entries = PPE_RAM_NUM_ENTRIES_SHIFT(PPE_DRAM_NUM_ENTRIES);
@@ -103,8 +121,13 @@ static void airoha_ppe_hw_init(struct airoha_ppe *ppe)
 	}
 
 	if (airoha_ppe2_is_enabled(eth)) {
-		sram_num_entries =
-			PPE_RAM_NUM_ENTRIES_SHIFT(PPE1_SRAM_NUM_DATA_ENTRIES);
+		sram_num_entries = PPE1_SRAM_NUM_ENTRIES;
+		sram_num_stats_entries =
+			airoha_ppe_get_num_stats_entries(ppe);
+		if (sram_num_stats_entries > 0)
+			sram_num_entries -= sram_num_stats_entries;
+		sram_num_entries = PPE_RAM_NUM_ENTRIES_SHIFT(sram_num_entries);
+
 		airoha_fe_rmw(eth, REG_PPE_TB_CFG(0),
 			      PPE_SRAM_TB_NUM_ENTRY_MASK |
 			      PPE_DRAM_TB_NUM_ENTRY_MASK,
@@ -120,8 +143,13 @@ static void airoha_ppe_hw_init(struct airoha_ppe *ppe)
 			      FIELD_PREP(PPE_DRAM_TB_NUM_ENTRY_MASK,
 					 dram_num_entries));
 	} else {
-		sram_num_entries =
-			PPE_RAM_NUM_ENTRIES_SHIFT(PPE_SRAM_NUM_DATA_ENTRIES);
+		sram_num_entries = PPE_SRAM_NUM_ENTRIES;
+		sram_num_stats_entries =
+			airoha_ppe_get_total_num_stats_entries(ppe);
+		if (sram_num_stats_entries > 0)
+			sram_num_entries -= sram_num_stats_entries;
+		sram_num_entries = PPE_RAM_NUM_ENTRIES_SHIFT(sram_num_entries);
+
 		airoha_fe_rmw(eth, REG_PPE_TB_CFG(0),
 			      PPE_SRAM_TB_NUM_ENTRY_MASK |
 			      PPE_DRAM_TB_NUM_ENTRY_MASK,
@@ -482,13 +510,21 @@ static u32 airoha_ppe_foe_get_entry_hash(struct airoha_foe_entry *hwe)
 	return hash;
 }
 
-static u32 airoha_ppe_foe_get_flow_stats_index(struct airoha_ppe *ppe, u32 hash)
+static int airoha_ppe_foe_get_flow_stats_index(struct airoha_ppe *ppe,
+					       u32 hash, u32 *index)
 {
-	if (!airoha_ppe2_is_enabled(ppe->eth))
-		return hash;
+	int ppe_num_stats_entries;
+
+	ppe_num_stats_entries = airoha_ppe_get_total_num_stats_entries(ppe);
+	if (ppe_num_stats_entries < 0)
+		return ppe_num_stats_entries;
 
-	return hash >= PPE_STATS_NUM_ENTRIES ? hash - PPE1_STATS_NUM_ENTRIES
-					     : hash;
+	*index = hash;
+	if (airoha_ppe2_is_enabled(ppe->eth) &&
+	    hash >= ppe_num_stats_entries)
+		*index = *index - PPE_STATS_NUM_ENTRIES;
+
+	return 0;
 }
 
 static void airoha_ppe_foe_flow_stat_entry_reset(struct airoha_ppe *ppe,
@@ -502,9 +538,13 @@ static void airoha_ppe_foe_flow_stat_entry_reset(struct airoha_ppe *ppe,
 static void airoha_ppe_foe_flow_stats_reset(struct airoha_ppe *ppe,
 					    struct airoha_npu *npu)
 {
-	int i;
+	int i, ppe_num_stats_entries;
+
+	ppe_num_stats_entries = airoha_ppe_get_total_num_stats_entries(ppe);
+	if (ppe_num_stats_entries < 0)
+		return;
 
-	for (i = 0; i < PPE_STATS_NUM_ENTRIES; i++)
+	for (i = 0; i < ppe_num_stats_entries; i++)
 		airoha_ppe_foe_flow_stat_entry_reset(ppe, npu, i);
 }
 
@@ -515,10 +555,17 @@ static void airoha_ppe_foe_flow_stats_update(struct airoha_ppe *ppe,
 {
 	int type = FIELD_GET(AIROHA_FOE_IB1_BIND_PACKET_TYPE, hwe->ib1);
 	u32 index, pse_port, val, *data, *ib2, *meter;
+	int ppe_num_stats_entries;
 	u8 nbq;
 
-	index = airoha_ppe_foe_get_flow_stats_index(ppe, hash);
-	if (index >= PPE_STATS_NUM_ENTRIES)
+	ppe_num_stats_entries = airoha_ppe_get_total_num_stats_entries(ppe);
+	if (ppe_num_stats_entries < 0)
+		return;
+
+	if (airoha_ppe_foe_get_flow_stats_index(ppe, hash, &index))
+		return;
+
+	if (index >= ppe_num_stats_entries)
 		return;
 
 	if (type == PPE_PKT_TYPE_BRIDGE) {
@@ -1160,11 +1207,19 @@ static int airoha_ppe_flow_offload_destroy(struct airoha_eth *eth,
 void airoha_ppe_foe_entry_get_stats(struct airoha_ppe *ppe, u32 hash,
 				    struct airoha_foe_stats64 *stats)
 {
-	u32 index = airoha_ppe_foe_get_flow_stats_index(ppe, hash);
 	struct airoha_eth *eth = ppe->eth;
+	int ppe_num_stats_entries;
 	struct airoha_npu *npu;
+	u32 index;
+
+	ppe_num_stats_entries = airoha_ppe_get_total_num_stats_entries(ppe);
+	if (ppe_num_stats_entries < 0)
+		return;
 
-	if (index >= PPE_STATS_NUM_ENTRIES)
+	if (airoha_ppe_foe_get_flow_stats_index(ppe, hash, &index))
+		return;
+
+	if (index >= ppe_num_stats_entries)
 		return;
 
 	rcu_read_lock();
@@ -1259,7 +1314,7 @@ static int airoha_ppe_offload_setup(struct airoha_eth *eth)
 {
 	struct airoha_npu *npu = airoha_ppe_npu_get(eth);
 	struct airoha_ppe *ppe = eth->ppe;
-	int err;
+	int err, ppe_num_stats_entries;
 
 	if (IS_ERR(npu))
 		return PTR_ERR(npu);
@@ -1268,9 +1323,10 @@ static int airoha_ppe_offload_setup(struct airoha_eth *eth)
 	if (err)
 		goto error_npu_put;
 
-	if (PPE_STATS_NUM_ENTRIES) {
+	ppe_num_stats_entries = airoha_ppe_get_total_num_stats_entries(ppe);
+	if (ppe_num_stats_entries > 0) {
 		err = npu->ops.ppe_init_stats(npu, ppe->foe_stats_dma,
-					      PPE_STATS_NUM_ENTRIES);
+					      ppe_num_stats_entries);
 		if (err)
 			goto error_npu_put;
 	}
@@ -1407,8 +1463,8 @@ EXPORT_SYMBOL_GPL(airoha_ppe_put_dev);
 
 int airoha_ppe_init(struct airoha_eth *eth)
 {
+	int foe_size, err, ppe_num_stats_entries;
 	struct airoha_ppe *ppe;
-	int foe_size, err;
 
 	ppe = devm_kzalloc(eth->dev, sizeof(*ppe), GFP_KERNEL);
 	if (!ppe)
@@ -1433,8 +1489,9 @@ int airoha_ppe_init(struct airoha_eth *eth)
 	if (!ppe->foe_flow)
 		return -ENOMEM;
 
-	foe_size = PPE_STATS_NUM_ENTRIES * sizeof(*ppe->foe_stats);
-	if (foe_size) {
+	ppe_num_stats_entries = airoha_ppe_get_total_num_stats_entries(ppe);
+	if (ppe_num_stats_entries > 0) {
+		foe_size = ppe_num_stats_entries * sizeof(*ppe->foe_stats);
 		ppe->foe_stats = dmam_alloc_coherent(eth->dev, foe_size,
 						     &ppe->foe_stats_dma,
 						     GFP_KERNEL);
-- 
2.53.0



