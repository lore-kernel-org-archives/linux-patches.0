Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45092FA62A;
	Tue, 17 Jun 2025 16:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178912; cv=none; b=cggyrRjUMr6zdocYRAKXA+3EoInUKNuCaL6MZPDQnId6S0g4VzwWQxN5Ds9IQDj6vDTFYWQSWrsXbjvPgqlOiAfw5RYIIgRZgwLPF5xIKBLT1QqG3Fu9DHVOqHm1D0haWXbiQ5Q1+4zBsb9OsiCmFw167pgdf+U4y4ps/OGr93M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178912; c=relaxed/simple;
	bh=tR65WPzb4D85z830+haySTaxYGXntnj4qJiZmWP/2Jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXSCJU8k1ePYkrtoA5J+LlWw/ciQ/qM8RC0c6h38gfGCMrux7kf22N2RK3tOCZnImNiNI2i4WPIYCYcrJXFfNjeeBJ/Rl82syvsPlArTyuBmVTeK4fqb27S5ww5ppCnHaJwle5K7jFGETtr7RAXA0rlPxi/FYluwmJfPzlwsaC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bl8GmdAi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bl8GmdAi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23229C4CEE3;
	Tue, 17 Jun 2025 16:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178912;
	bh=tR65WPzb4D85z830+haySTaxYGXntnj4qJiZmWP/2Jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bl8GmdAiuytGs1XV9gzpUbqz2BzpDAfscrDNbAj/XcbZ/ZptEaZ9sFgr35yqSP07Q
	 KLYjITVJu9ixTGH1U1xPJGm5wSH7KX3rH6OZDwGT+cz0RwaoTIRiMQqXvSobfPpjHi
	 FkU3TOFdVHWqTByzdSnadGdZg9mpTwY1okzg6tdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 591/780] net: airoha: Initialize PPE UPDMEM source-mac table
Date: Tue, 17 Jun 2025 17:24:59 +0200
Message-ID: <20250617152515.544102397@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit a869d3a5eb011a9cf9bd864f31f5cf27362de8c7 ]

UPDMEM source-mac table is a key-value map used to store devices mac
addresses according to the port identifier. UPDMEM source mac table is
used during IPv6 traffic hw acceleration since PPE entries, for space
constraints, do not contain the full source mac address but just the
identifier in the UPDMEM source-mac table.
Configure UPDMEM source-mac table with device mac addresses and set
the source-mac ID field for PPE IPv6 entries in order to select the
proper device mac address as source mac for L3 IPv6 hw accelerated traffic.

Fixes: 00a7678310fe ("net: airoha: Introduce flowtable offload support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250602-airoha-flowtable-ipv6-fix-v2-1-3287f8b55214@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c  |  2 ++
 drivers/net/ethernet/airoha/airoha_eth.h  |  1 +
 drivers/net/ethernet/airoha/airoha_ppe.c  | 26 ++++++++++++++++++++++-
 drivers/net/ethernet/airoha/airoha_regs.h | 10 +++++++++
 4 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index c8664840f3fc2..af28a9300a15c 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -80,6 +80,8 @@ static void airoha_set_macaddr(struct airoha_gdm_port *port, const u8 *addr)
 	val = (addr[3] << 16) | (addr[4] << 8) | addr[5];
 	airoha_fe_wr(eth, REG_FE_MAC_LMIN(reg), val);
 	airoha_fe_wr(eth, REG_FE_MAC_LMAX(reg), val);
+
+	airoha_ppe_init_upd_mem(port);
 }
 
 static void airoha_set_gdm_port_fwd_cfg(struct airoha_eth *eth, u32 addr,
diff --git a/drivers/net/ethernet/airoha/airoha_eth.h b/drivers/net/ethernet/airoha/airoha_eth.h
index 0204ea030c31a..2bf6b1a2dd9b0 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.h
+++ b/drivers/net/ethernet/airoha/airoha_eth.h
@@ -549,6 +549,7 @@ int airoha_ppe_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 				 void *cb_priv);
 int airoha_ppe_init(struct airoha_eth *eth);
 void airoha_ppe_deinit(struct airoha_eth *eth);
+void airoha_ppe_init_upd_mem(struct airoha_gdm_port *port);
 struct airoha_foe_entry *airoha_ppe_foe_get_entry(struct airoha_ppe *ppe,
 						  u32 hash);
 
diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ethernet/airoha/airoha_ppe.c
index 843fe7bd1446e..1b8f21f808890 100644
--- a/drivers/net/ethernet/airoha/airoha_ppe.c
+++ b/drivers/net/ethernet/airoha/airoha_ppe.c
@@ -206,6 +206,7 @@ static int airoha_ppe_foe_entry_prepare(struct airoha_eth *eth,
 	int dsa_port = airoha_get_dsa_port(&dev);
 	struct airoha_foe_mac_info_common *l2;
 	u32 qdata, ports_pad, val;
+	u8 smac_id = 0xf;
 
 	memset(hwe, 0, sizeof(*hwe));
 
@@ -240,6 +241,8 @@ static int airoha_ppe_foe_entry_prepare(struct airoha_eth *eth,
 		 */
 		if (airhoa_is_lan_gdm_port(port))
 			val |= AIROHA_FOE_IB2_FAST_PATH;
+
+		smac_id = port->id;
 	}
 
 	if (is_multicast_ether_addr(data->eth.h_dest))
@@ -280,7 +283,7 @@ static int airoha_ppe_foe_entry_prepare(struct airoha_eth *eth,
 		hwe->ipv4.l2.src_mac_lo =
 			get_unaligned_be16(data->eth.h_source + 4);
 	} else {
-		l2->src_mac_hi = FIELD_PREP(AIROHA_FOE_MAC_SMAC_ID, 0xf);
+		l2->src_mac_hi = FIELD_PREP(AIROHA_FOE_MAC_SMAC_ID, smac_id);
 	}
 
 	if (data->vlan.num) {
@@ -868,6 +871,27 @@ void airoha_ppe_check_skb(struct airoha_ppe *ppe, u16 hash)
 	airoha_ppe_foe_insert_entry(ppe, hash);
 }
 
+void airoha_ppe_init_upd_mem(struct airoha_gdm_port *port)
+{
+	struct airoha_eth *eth = port->qdma->eth;
+	struct net_device *dev = port->dev;
+	const u8 *addr = dev->dev_addr;
+	u32 val;
+
+	val = (addr[2] << 24) | (addr[3] << 16) | (addr[4] << 8) | addr[5];
+	airoha_fe_wr(eth, REG_UPDMEM_DATA(0), val);
+	airoha_fe_wr(eth, REG_UPDMEM_CTRL(0),
+		     FIELD_PREP(PPE_UPDMEM_ADDR_MASK, port->id) |
+		     PPE_UPDMEM_WR_MASK | PPE_UPDMEM_REQ_MASK);
+
+	val = (addr[0] << 8) | addr[1];
+	airoha_fe_wr(eth, REG_UPDMEM_DATA(0), val);
+	airoha_fe_wr(eth, REG_UPDMEM_CTRL(0),
+		     FIELD_PREP(PPE_UPDMEM_ADDR_MASK, port->id) |
+		     FIELD_PREP(PPE_UPDMEM_OFFSET_MASK, 1) |
+		     PPE_UPDMEM_WR_MASK | PPE_UPDMEM_REQ_MASK);
+}
+
 int airoha_ppe_init(struct airoha_eth *eth)
 {
 	struct airoha_ppe *ppe;
diff --git a/drivers/net/ethernet/airoha/airoha_regs.h b/drivers/net/ethernet/airoha/airoha_regs.h
index 8146cde4e8ba3..57bff8d2de276 100644
--- a/drivers/net/ethernet/airoha/airoha_regs.h
+++ b/drivers/net/ethernet/airoha/airoha_regs.h
@@ -312,6 +312,16 @@
 #define REG_PPE_RAM_BASE(_n)			(((_n) ? PPE2_BASE : PPE1_BASE) + 0x320)
 #define REG_PPE_RAM_ENTRY(_m, _n)		(REG_PPE_RAM_BASE(_m) + ((_n) << 2))
 
+#define REG_UPDMEM_CTRL(_n)			(((_n) ? PPE2_BASE : PPE1_BASE) + 0x370)
+#define PPE_UPDMEM_ACK_MASK			BIT(31)
+#define PPE_UPDMEM_ADDR_MASK			GENMASK(11, 8)
+#define PPE_UPDMEM_OFFSET_MASK			GENMASK(7, 4)
+#define PPE_UPDMEM_SEL_MASK			GENMASK(3, 2)
+#define PPE_UPDMEM_WR_MASK			BIT(1)
+#define PPE_UPDMEM_REQ_MASK			BIT(0)
+
+#define REG_UPDMEM_DATA(_n)			(((_n) ? PPE2_BASE : PPE1_BASE) + 0x374)
+
 #define REG_FE_GDM_TX_OK_PKT_CNT_H(_n)		(GDM_BASE(_n) + 0x280)
 #define REG_FE_GDM_TX_OK_BYTE_CNT_H(_n)		(GDM_BASE(_n) + 0x284)
 #define REG_FE_GDM_TX_ETH_PKT_CNT_H(_n)		(GDM_BASE(_n) + 0x288)
-- 
2.39.5



