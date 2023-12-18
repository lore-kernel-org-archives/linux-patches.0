Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFAF1D144;
	Mon, 18 Dec 2023 14:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p859O5Ce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FCE0C433CA;
	Mon, 18 Dec 2023 14:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908048;
	bh=URBOQUMNrzyJvfVyMQtYXjnZl6M9sMPAb1Rj5002W5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p859O5Ce1r/1V4QKakjjvLqfybCOQId85tWEdpwtG8ePB3PU+Lv2FndHtvdhmo7A0
	 I8gSPJWeCZYpIhJubnjJr/aWcDTgRCgIwKFavmGcLKSJj0D3Din7r1uXsx4SEPRl/Z
	 T9ZPhwbFA6q0nQWNark4+GW6LR53tnfo3HPpwaHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Sunil Kovvuri Goutham <sgoutham@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/166] octeontx2-af: Update RSS algorithm index
Date: Mon, 18 Dec 2023 14:50:01 +0100
Message-ID: <20231218135106.543731225@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit 570ba37898ecd9069beb58bf0b6cf84daba6e0fe ]

The RSS flow algorithm is not set up correctly for promiscuous or all
multi MCAM entries. This has an impact on flow distribution.

This patch fixes the issue by updating flow algorithm index in above
mentioned MCAM entries.

Fixes: 967db3529eca ("octeontx2-af: add support for multicast/promisc packet replication feature")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   | 55 +++++++++++++++----
 1 file changed, 44 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index f65805860c8d4..0bcf3e5592806 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -671,6 +671,7 @@ void rvu_npc_install_promisc_entry(struct rvu *rvu, u16 pcifunc,
 	int blkaddr, ucast_idx, index;
 	struct nix_rx_action action = { 0 };
 	u64 relaxed_mask;
+	u8 flow_key_alg;
 
 	if (!hw->cap.nix_rx_multicast && is_cgx_vf(rvu, pcifunc))
 		return;
@@ -701,6 +702,8 @@ void rvu_npc_install_promisc_entry(struct rvu *rvu, u16 pcifunc,
 		action.op = NIX_RX_ACTIONOP_UCAST;
 	}
 
+	flow_key_alg = action.flow_key_alg;
+
 	/* RX_ACTION set to MCAST for CGX PF's */
 	if (hw->cap.nix_rx_multicast && pfvf->use_mce_list &&
 	    is_pf_cgxmapped(rvu, rvu_get_pf(pcifunc))) {
@@ -740,7 +743,7 @@ void rvu_npc_install_promisc_entry(struct rvu *rvu, u16 pcifunc,
 	req.vf = pcifunc;
 	req.index = action.index;
 	req.match_id = action.match_id;
-	req.flow_key_alg = action.flow_key_alg;
+	req.flow_key_alg = flow_key_alg;
 
 	rvu_mbox_handler_npc_install_flow(rvu, &req, &rsp);
 }
@@ -854,6 +857,7 @@ void rvu_npc_install_allmulti_entry(struct rvu *rvu, u16 pcifunc, int nixlf,
 	u8 mac_addr[ETH_ALEN] = { 0 };
 	struct nix_rx_action action = { 0 };
 	struct rvu_pfvf *pfvf;
+	u8 flow_key_alg;
 	u16 vf_func;
 
 	/* Only CGX PF/VF can add allmulticast entry */
@@ -888,6 +892,7 @@ void rvu_npc_install_allmulti_entry(struct rvu *rvu, u16 pcifunc, int nixlf,
 		*(u64 *)&action = npc_get_mcam_action(rvu, mcam,
 							blkaddr, ucast_idx);
 
+	flow_key_alg = action.flow_key_alg;
 	if (action.op != NIX_RX_ACTIONOP_RSS) {
 		*(u64 *)&action = 0;
 		action.op = NIX_RX_ACTIONOP_UCAST;
@@ -924,7 +929,7 @@ void rvu_npc_install_allmulti_entry(struct rvu *rvu, u16 pcifunc, int nixlf,
 	req.vf = pcifunc | vf_func;
 	req.index = action.index;
 	req.match_id = action.match_id;
-	req.flow_key_alg = action.flow_key_alg;
+	req.flow_key_alg = flow_key_alg;
 
 	rvu_mbox_handler_npc_install_flow(rvu, &req, &rsp);
 }
@@ -990,11 +995,38 @@ static void npc_update_vf_flow_entry(struct rvu *rvu, struct npc_mcam *mcam,
 	mutex_unlock(&mcam->lock);
 }
 
+static void npc_update_rx_action_with_alg_idx(struct rvu *rvu, struct nix_rx_action action,
+					      struct rvu_pfvf *pfvf, int mcam_index, int blkaddr,
+					      int alg_idx)
+
+{
+	struct npc_mcam *mcam = &rvu->hw->mcam;
+	struct rvu_hwinfo *hw = rvu->hw;
+	int bank, op_rss;
+
+	if (!is_mcam_entry_enabled(rvu, mcam, blkaddr, mcam_index))
+		return;
+
+	op_rss = (!hw->cap.nix_rx_multicast || !pfvf->use_mce_list);
+
+	bank = npc_get_bank(mcam, mcam_index);
+	mcam_index &= (mcam->banksize - 1);
+
+	/* If Rx action is MCAST update only RSS algorithm index */
+	if (!op_rss) {
+		*(u64 *)&action = rvu_read64(rvu, blkaddr,
+				NPC_AF_MCAMEX_BANKX_ACTION(mcam_index, bank));
+
+		action.flow_key_alg = alg_idx;
+	}
+	rvu_write64(rvu, blkaddr,
+		    NPC_AF_MCAMEX_BANKX_ACTION(mcam_index, bank), *(u64 *)&action);
+}
+
 void rvu_npc_update_flowkey_alg_idx(struct rvu *rvu, u16 pcifunc, int nixlf,
 				    int group, int alg_idx, int mcam_index)
 {
 	struct npc_mcam *mcam = &rvu->hw->mcam;
-	struct rvu_hwinfo *hw = rvu->hw;
 	struct nix_rx_action action;
 	int blkaddr, index, bank;
 	struct rvu_pfvf *pfvf;
@@ -1050,15 +1082,16 @@ void rvu_npc_update_flowkey_alg_idx(struct rvu *rvu, u16 pcifunc, int nixlf,
 	/* If PF's promiscuous entry is enabled,
 	 * Set RSS action for that entry as well
 	 */
-	if ((!hw->cap.nix_rx_multicast || !pfvf->use_mce_list) &&
-	    is_mcam_entry_enabled(rvu, mcam, blkaddr, index)) {
-		bank = npc_get_bank(mcam, index);
-		index &= (mcam->banksize - 1);
+	npc_update_rx_action_with_alg_idx(rvu, action, pfvf, index, blkaddr,
+					  alg_idx);
 
-		rvu_write64(rvu, blkaddr,
-			    NPC_AF_MCAMEX_BANKX_ACTION(index, bank),
-			    *(u64 *)&action);
-	}
+	index = npc_get_nixlf_mcam_index(mcam, pcifunc,
+					 nixlf, NIXLF_ALLMULTI_ENTRY);
+	/* If PF's allmulti  entry is enabled,
+	 * Set RSS action for that entry as well
+	 */
+	npc_update_rx_action_with_alg_idx(rvu, action, pfvf, index, blkaddr,
+					  alg_idx);
 }
 
 void npc_enadis_default_mce_entry(struct rvu *rvu, u16 pcifunc,
-- 
2.43.0



