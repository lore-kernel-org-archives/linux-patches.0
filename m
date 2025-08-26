Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB13322C98;
	Tue, 26 Aug 2025 11:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208020; cv=none; b=n6P8Q0B9D/B/raYHPv5RmyOB8W/fQAb8r1d/BjhRFvVwvtt/dlAK6ykZTOCISX4F2u7hyvQYGze2XxQVunCAXS6yi+XXLfEvSBjLy/BkWjdfW7Qnd7/sMbNpHU/yfrR/Ubx/8iGNmgOCKmDZfFFcyn22pSLxL2qmJCPnc9nhkkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208020; c=relaxed/simple;
	bh=aehnlr5UcQLrwJRYXfiW038dSBvpStuAtRiRITRGt0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gBMQ60tasFz0vBkVf94cDzz5JzxQFW9vCSR4/DvQtPMzjXu328dq58/0jUr/gTzx5QYmzaHgXOmIj7a9wJpDyv2nxrpi8puhQT0ofblIy+kEWTc/ovCjnyLEAK4kbEYMPf19H0Tr+TxY8CC+KQHEStEa0PKPZ0jPH8B9atBaVtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ncFriAOJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ncFriAOJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E2FC4CEF1;
	Tue, 26 Aug 2025 11:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208020;
	bh=aehnlr5UcQLrwJRYXfiW038dSBvpStuAtRiRITRGt0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ncFriAOJaI614wzM3DF2LfS6zo+doqFpbLQkY7UHqbmUuADifMI3DzGkKqPNDXZH2
	 Tw17aB7D8vcPbRc3+hOQCPUaIFTcT6eUYLnhqnUWEjErZxJWONTcyoKKA1cuvd1EMG
	 ml6bJOmxxWy21e+V8QYk9cx7hMCnAMsoYPD5nLGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MD Danish Anwar <danishanwar@ti.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 407/457] net: ti: icssg-prueth: Fix HSR and switch offload Enablement during firwmare reload.
Date: Tue, 26 Aug 2025 13:11:31 +0200
Message-ID: <20250826110947.353789304@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 008d77727400..f436d7cf565a 100644
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
@@ -790,6 +828,7 @@ static int emac_ndo_open(struct net_device *ndev)
 		ret = prueth_emac_common_start(prueth);
 		if (ret)
 			goto free_rx_irq;
+		icssg_enable_fw_offload(prueth);
 	}
 
 	flow_cfg = emac->dram.va + ICSSG_CONFIG_OFFSET + PSI_L_REGULAR_FLOW_ID_BASE_OFFSET;
@@ -1397,8 +1436,7 @@ static int prueth_emac_restart(struct prueth *prueth)
 
 static void icssg_change_mode(struct prueth *prueth)
 {
-	struct prueth_emac *emac;
-	int mac, ret;
+	int ret;
 
 	ret = prueth_emac_restart(prueth);
 	if (ret) {
@@ -1406,35 +1444,7 @@ static void icssg_change_mode(struct prueth *prueth)
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



