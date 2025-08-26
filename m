Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584E1200112;
	Tue, 26 Aug 2025 11:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208916; cv=none; b=dKYXoBzDWwmuYmxfCqBzUIs5FlWCDJQC0Lk3DWuLIRekHiEnNO3o3doozhQKMnV9vuXYTXGcixJwKsHJhusfofa+4PNZhpWBYmmg2FWBTEAZlmMVFiW54tzY5mz2MGRVmv/dnPARsyBodYoKr7o6dWQgrlhGpCMhI/i9RZiIKnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208916; c=relaxed/simple;
	bh=5qY0+5o/00NDpuuXLV/zw6kd0bDl8wMLruIK9FDe+sM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7gX5ouN0UYrQBiNulh0PZ0GbYEls0COURIgsvKz9FPvmIG2zi6xJIRJsiNCtCfBiXOy0b9jRdDyncICbdUVW50Gq3MXj4iomvTJMfpyshKqmoNk4yzidEZAuBufda9Mqy5h21cyfgpw4ck75jBeFJZP2oz0jyjwjIAPKXbb0jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MUmFs7sH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MUmFs7sH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA147C4CEF1;
	Tue, 26 Aug 2025 11:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208916;
	bh=5qY0+5o/00NDpuuXLV/zw6kd0bDl8wMLruIK9FDe+sM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MUmFs7sH1jFrOjplrZx5kiaTDV1GLDsfxdv2KvK+R/3PqQeg/88fjEKxJCFSKYbzQ
	 6W4l86p4jNgY/E0hVUFu6TOGLJLD4lPJd3DoQ8ZJ0FFUAl/eHnEeg5LB/ptuAgDf9/
	 0lPTkBcBrfRuE4re3LzCR0lBZ7B/xa64uBPBbX6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MD Danish Anwar <danishanwar@ti.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 294/322] net: ti: icssg-prueth: Fix HSR and switch offload Enablement during firwmare reload.
Date: Tue, 26 Aug 2025 13:11:49 +0200
Message-ID: <20250826110923.163373874@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: MD Danish Anwar <danishanwar@ti.com>

[ Upstream commit 01792bc3e5bdafa171dd83c7073f00e7de93a653 ]

To enable HSR / Switch offload, certain configurations are needed.
Currently they are done inside icssg_change_mode(). This function only
gets called if we move from one mode to another without bringing the
links up / down.

Once in HSR / Switch mode, if we bring the links down and bring it back
up again. The callback sequence is,

- emac_ndo_stop()
	Firmwares are stopped
- emac_ndo_open()
	Firmwares are loaded

In this path icssg_change_mode() doesn't get called and as a result the
configurations needed for HSR / Switch is not done.

To fix this, put all these configurations in a separate function
icssg_enable_fw_offload() and call this from both icssg_change_mode()
and emac_ndo_open()

Fixes: 56375086d093 ("net: ti: icssg-prueth: Enable HSR Tx duplication, Tx Tag and Rx Tag offload")
Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
Link: https://patch.msgid.link/20250814105106.1491871-1-danishanwar@ti.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icssg_prueth.c | 72 +++++++++++---------
 1 file changed, 41 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/ti/icssg/icssg_prueth.c b/drivers/net/ethernet/ti/icssg/icssg_prueth.c
index ddbc4624ae88..055c5765bd86 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_prueth.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_prueth.c
@@ -240,6 +240,44 @@ static void prueth_emac_stop(struct prueth *prueth)
 	}
 }
 
+static void icssg_enable_fw_offload(struct prueth *prueth)
+{
+	struct prueth_emac *emac;
+	int mac;
+
+	for (mac = PRUETH_MAC0; mac < PRUETH_NUM_MACS; mac++) {
+		emac = prueth->emac[mac];
+		if (prueth->is_hsr_offload_mode) {
+			if (emac->ndev->features & NETIF_F_HW_HSR_TAG_RM)
+				icssg_set_port_state(emac, ICSSG_EMAC_HSR_RX_OFFLOAD_ENABLE);
+			else
+				icssg_set_port_state(emac, ICSSG_EMAC_HSR_RX_OFFLOAD_DISABLE);
+		}
+
+		if (prueth->is_switch_mode || prueth->is_hsr_offload_mode) {
+			if (netif_running(emac->ndev)) {
+				icssg_fdb_add_del(emac, eth_stp_addr, prueth->default_vlan,
+						  ICSSG_FDB_ENTRY_P0_MEMBERSHIP |
+						  ICSSG_FDB_ENTRY_P1_MEMBERSHIP |
+						  ICSSG_FDB_ENTRY_P2_MEMBERSHIP |
+						  ICSSG_FDB_ENTRY_BLOCK,
+						  true);
+				icssg_vtbl_modify(emac, emac->port_vlan | DEFAULT_VID,
+						  BIT(emac->port_id) | DEFAULT_PORT_MASK,
+						  BIT(emac->port_id) | DEFAULT_UNTAG_MASK,
+						  true);
+				if (prueth->is_hsr_offload_mode)
+					icssg_vtbl_modify(emac, DEFAULT_VID,
+							  DEFAULT_PORT_MASK,
+							  DEFAULT_UNTAG_MASK, true);
+				icssg_set_pvid(prueth, emac->port_vlan, emac->port_id);
+				if (prueth->is_switch_mode)
+					icssg_set_port_state(emac, ICSSG_EMAC_PORT_VLAN_AWARE_ENABLE);
+			}
+		}
+	}
+}
+
 static int prueth_emac_common_start(struct prueth *prueth)
 {
 	struct prueth_emac *emac;
@@ -690,6 +728,7 @@ static int emac_ndo_open(struct net_device *ndev)
 		ret = prueth_emac_common_start(prueth);
 		if (ret)
 			goto free_rx_irq;
+		icssg_enable_fw_offload(prueth);
 	}
 
 	flow_cfg = emac->dram.va + ICSSG_CONFIG_OFFSET + PSI_L_REGULAR_FLOW_ID_BASE_OFFSET;
@@ -1146,8 +1185,7 @@ static int prueth_emac_restart(struct prueth *prueth)
 
 static void icssg_change_mode(struct prueth *prueth)
 {
-	struct prueth_emac *emac;
-	int mac, ret;
+	int ret;
 
 	ret = prueth_emac_restart(prueth);
 	if (ret) {
@@ -1155,35 +1193,7 @@ static void icssg_change_mode(struct prueth *prueth)
 		return;
 	}
 
-	for (mac = PRUETH_MAC0; mac < PRUETH_NUM_MACS; mac++) {
-		emac = prueth->emac[mac];
-		if (prueth->is_hsr_offload_mode) {
-			if (emac->ndev->features & NETIF_F_HW_HSR_TAG_RM)
-				icssg_set_port_state(emac, ICSSG_EMAC_HSR_RX_OFFLOAD_ENABLE);
-			else
-				icssg_set_port_state(emac, ICSSG_EMAC_HSR_RX_OFFLOAD_DISABLE);
-		}
-
-		if (netif_running(emac->ndev)) {
-			icssg_fdb_add_del(emac, eth_stp_addr, prueth->default_vlan,
-					  ICSSG_FDB_ENTRY_P0_MEMBERSHIP |
-					  ICSSG_FDB_ENTRY_P1_MEMBERSHIP |
-					  ICSSG_FDB_ENTRY_P2_MEMBERSHIP |
-					  ICSSG_FDB_ENTRY_BLOCK,
-					  true);
-			icssg_vtbl_modify(emac, emac->port_vlan | DEFAULT_VID,
-					  BIT(emac->port_id) | DEFAULT_PORT_MASK,
-					  BIT(emac->port_id) | DEFAULT_UNTAG_MASK,
-					  true);
-			if (prueth->is_hsr_offload_mode)
-				icssg_vtbl_modify(emac, DEFAULT_VID,
-						  DEFAULT_PORT_MASK,
-						  DEFAULT_UNTAG_MASK, true);
-			icssg_set_pvid(prueth, emac->port_vlan, emac->port_id);
-			if (prueth->is_switch_mode)
-				icssg_set_port_state(emac, ICSSG_EMAC_PORT_VLAN_AWARE_ENABLE);
-		}
-	}
+	icssg_enable_fw_offload(prueth);
 }
 
 static int prueth_netdevice_port_link(struct net_device *ndev,
-- 
2.50.1



