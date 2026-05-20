Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F263DA7C6;
	Wed, 20 May 2026 17:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297752; cv=none; b=P/BxGpF5X2ibNHKFSsoils5V6yozPyhjsE+MxjjuN9N2gx6euTn+fIz0F1/FiX1/ZUK2ijwTgnvN1hixKdR6HtC/nCZvEriiSiQ3BwOopktWIKjCy4Zb5yXoGjVluQk1aybDcRGI/2+DVWo8APx9MwKJq0soK1xH2mmZgG4QGlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297752; c=relaxed/simple;
	bh=lZiwdDzSdmrhbdsCrW3uQ0i5flBzFA/MJCWKmGe00Q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQpYSmJa4HWAaRf4+HmhchzgcQqraerGrfueXVDziB89+wPQXcRHdCcpPyis1D/O7KknU8k8sjRzJ6APMUiglyrtritM4t8W+Ux6mLTCKsrXu74e31fOUoqsScXc8W3y0sBNfLO+zc8QnjYMRsU/jNuIEdD8rHv0/nr//WKgKiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cd8npztx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cd8npztx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D4A1F000E9;
	Wed, 20 May 2026 17:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297751;
	bh=AAMX0mFd9ffhUJmWr3FfSYnZeo1lnhxNIL9GZyi3nQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cd8npztxp/+Ws84o7+hhJ41lloWqwwBxWJDcBSC/ztSd2Aqyu05XeoEIFgvLMNUgd
	 etWrP9XhFC7B50ei+2gL5rDnYoT9OLZcS4FkuxwWVbiSy5UYgx4O/srsBJrhL/59vt
	 CEYEevplwujpheFBT5bqw1jzR8yMUX6F+X1db/ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 150/957] net: airoha: Generalize airoha_ppe2_is_enabled routine
Date: Wed, 20 May 2026 18:10:33 +0200
Message-ID: <20260520162137.807242716@linuxfoundation.org>
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

[ Upstream commit ef9449f080b61920cdc3d3106f8ffc2d9ba8b861 ]

Rename airoha_ppe2_is_enabled() in airoha_ppe_is_enabled() and
generalize it in order to check if each PPE module is enabled.
Rely on airoha_ppe_is_enabled routine to properly initialize PPE for
AN7583 SoC since AN7583 does not support PPE2.

Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20251017-an7583-eth-support-v3-5-f28319666667@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 02f729643959 ("net: airoha: Fix FE_PSE_BUF_SET configuration if PPE2 is available")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 32 ++++++++++++++++--------
 drivers/net/ethernet/airoha/airoha_eth.h |  1 +
 drivers/net/ethernet/airoha/airoha_ppe.c | 17 +++++++------
 3 files changed, 32 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index 5162f2a689000..677e40001f9f2 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -297,8 +297,11 @@ static void airoha_fe_pse_ports_init(struct airoha_eth *eth)
 	int q;
 
 	all_rsv = airoha_fe_get_pse_all_rsv(eth);
-	/* hw misses PPE2 oq rsv */
-	all_rsv += PSE_RSV_PAGES * pse_port_num_queues[FE_PSE_PORT_PPE2];
+	if (airoha_ppe_is_enabled(eth, 1)) {
+		/* hw misses PPE2 oq rsv */
+		all_rsv += PSE_RSV_PAGES *
+			   pse_port_num_queues[FE_PSE_PORT_PPE2];
+	}
 	airoha_fe_set(eth, REG_FE_PSE_BUF_SET, all_rsv);
 
 	/* CMD1 */
@@ -335,13 +338,17 @@ static void airoha_fe_pse_ports_init(struct airoha_eth *eth)
 	for (q = 4; q < pse_port_num_queues[FE_PSE_PORT_CDM4]; q++)
 		airoha_fe_set_pse_oq_rsv(eth, FE_PSE_PORT_CDM4, q,
 					 PSE_QUEUE_RSV_PAGES);
-	/* PPE2 */
-	for (q = 0; q < pse_port_num_queues[FE_PSE_PORT_PPE2]; q++) {
-		if (q < pse_port_num_queues[FE_PSE_PORT_PPE2] / 2)
-			airoha_fe_set_pse_oq_rsv(eth, FE_PSE_PORT_PPE2, q,
-						 PSE_QUEUE_RSV_PAGES);
-		else
-			airoha_fe_set_pse_oq_rsv(eth, FE_PSE_PORT_PPE2, q, 0);
+	if (airoha_ppe_is_enabled(eth, 1)) {
+		/* PPE2 */
+		for (q = 0; q < pse_port_num_queues[FE_PSE_PORT_PPE2]; q++) {
+			if (q < pse_port_num_queues[FE_PSE_PORT_PPE2] / 2)
+				airoha_fe_set_pse_oq_rsv(eth, FE_PSE_PORT_PPE2,
+							 q,
+							 PSE_QUEUE_RSV_PAGES);
+			else
+				airoha_fe_set_pse_oq_rsv(eth, FE_PSE_PORT_PPE2,
+							 q, 0);
+		}
 	}
 	/* GMD4 */
 	for (q = 0; q < pse_port_num_queues[FE_PSE_PORT_GDM4]; q++)
@@ -1781,8 +1788,11 @@ static int airoha_dev_init(struct net_device *dev)
 			airhoha_set_gdm2_loopback(port);
 		fallthrough;
 	case 2:
-		pse_port = FE_PSE_PORT_PPE2;
-		break;
+		if (airoha_ppe_is_enabled(eth, 1)) {
+			pse_port = FE_PSE_PORT_PPE2;
+			break;
+		}
+		fallthrough;
 	default:
 		pse_port = FE_PSE_PORT_PPE1;
 		break;
diff --git a/drivers/net/ethernet/airoha/airoha_eth.h b/drivers/net/ethernet/airoha/airoha_eth.h
index 655bc6acd80f0..d76f71558f8c2 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.h
+++ b/drivers/net/ethernet/airoha/airoha_eth.h
@@ -627,6 +627,7 @@ static inline bool airoha_is_7581(struct airoha_eth *eth)
 bool airoha_is_valid_gdm_port(struct airoha_eth *eth,
 			      struct airoha_gdm_port *port);
 
+bool airoha_ppe_is_enabled(struct airoha_eth *eth, int index);
 void airoha_ppe_check_skb(struct airoha_ppe_dev *dev, struct sk_buff *skb,
 			  u16 hash, bool rx_wlan);
 int airoha_ppe_setup_tc_block_cb(struct airoha_ppe_dev *dev, void *type_data);
diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ethernet/airoha/airoha_ppe.c
index 117dfc21d6a81..4ed244557065d 100644
--- a/drivers/net/ethernet/airoha/airoha_ppe.c
+++ b/drivers/net/ethernet/airoha/airoha_ppe.c
@@ -50,9 +50,12 @@ static int airoha_ppe_get_total_num_stats_entries(struct airoha_ppe *ppe)
 	return num_stats;
 }
 
-static bool airoha_ppe2_is_enabled(struct airoha_eth *eth)
+bool airoha_ppe_is_enabled(struct airoha_eth *eth, int index)
 {
-	return airoha_fe_rr(eth, REG_PPE_GLO_CFG(1)) & PPE_GLO_CFG_EN_MASK;
+	if (index >= eth->soc->num_ppe)
+		return false;
+
+	return airoha_fe_rr(eth, REG_PPE_GLO_CFG(index)) & PPE_GLO_CFG_EN_MASK;
 }
 
 static u32 airoha_ppe_get_timestamp(struct airoha_ppe *ppe)
@@ -120,7 +123,7 @@ static void airoha_ppe_hw_init(struct airoha_ppe *ppe)
 						 AIROHA_MAX_MTU));
 	}
 
-	if (airoha_ppe2_is_enabled(eth)) {
+	if (airoha_ppe_is_enabled(eth, 1)) {
 		sram_num_entries = PPE1_SRAM_NUM_ENTRIES;
 		sram_num_stats_entries =
 			airoha_ppe_get_num_stats_entries(ppe);
@@ -520,7 +523,7 @@ static int airoha_ppe_foe_get_flow_stats_index(struct airoha_ppe *ppe,
 		return ppe_num_stats_entries;
 
 	*index = hash;
-	if (airoha_ppe2_is_enabled(ppe->eth) &&
+	if (airoha_ppe_is_enabled(ppe->eth, 1) &&
 	    hash >= ppe_num_stats_entries)
 		*index = *index - PPE_STATS_NUM_ENTRIES;
 
@@ -615,7 +618,7 @@ airoha_ppe_foe_get_entry_locked(struct airoha_ppe *ppe, u32 hash)
 		u32 val;
 		int i;
 
-		ppe2 = airoha_ppe2_is_enabled(ppe->eth) &&
+		ppe2 = airoha_ppe_is_enabled(ppe->eth, 1) &&
 		       hash >= PPE1_SRAM_NUM_ENTRIES;
 		airoha_fe_wr(ppe->eth, REG_PPE_RAM_CTRL(ppe2),
 			     FIELD_PREP(PPE_SRAM_CTRL_ENTRY_MASK, hash) |
@@ -693,7 +696,7 @@ static int airoha_ppe_foe_commit_entry(struct airoha_ppe *ppe,
 
 	if (hash < PPE_SRAM_NUM_ENTRIES) {
 		dma_addr_t addr = ppe->foe_dma + hash * sizeof(*hwe);
-		bool ppe2 = airoha_ppe2_is_enabled(eth) &&
+		bool ppe2 = airoha_ppe_is_enabled(eth, 1) &&
 			    hash >= PPE1_SRAM_NUM_ENTRIES;
 
 		err = npu->ops.ppe_foe_commit_entry(npu, addr, sizeof(*hwe),
@@ -1288,7 +1291,7 @@ static int airoha_ppe_flush_sram_entries(struct airoha_ppe *ppe,
 	int i, sram_num_entries = PPE_SRAM_NUM_ENTRIES;
 	struct airoha_foe_entry *hwe = ppe->foe;
 
-	if (airoha_ppe2_is_enabled(ppe->eth))
+	if (airoha_ppe_is_enabled(ppe->eth, 1))
 		sram_num_entries = sram_num_entries / 2;
 
 	for (i = 0; i < sram_num_entries; i++)
-- 
2.53.0



