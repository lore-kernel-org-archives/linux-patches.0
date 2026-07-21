Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C16441616;
	Tue, 21 Jul 2026 22:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672260; cv=none; b=rV/J/oCkgEQstscTn2HoCkYxLXPS7BuTqFWcYN9sfs9/BTpYum5m0rBJVnHoR/gzDsWv17tTbbstev5R06gtOPn2iTwYbd0ZL7LxGtkX8MSepObEF0lBk1ppkfLMaxDib5pPtmsmRzTRyIxa1RA/X9BRh3WcNWtsL6OwJW7RDuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672260; c=relaxed/simple;
	bh=PrvIW9OYI0Ny2aAGlRfS7Uw9JqlzQcM17cbtXFF/AbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lY8hTJKr1fRPz9uit/jaohQ6WfqXPm4SbMlPYVkQOtvjKirOSCweN/4nklilXlcp/+Am2exg3w8UwyFVIaKAF8Wm5YxMPsszaZTKiTRCfZhLwxvtHEG9D43kxRl+eafG3KIrYYJ0c+ffdDtpXMqAEGn980lFaYYZhnAQ6wkODG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Efpvtuch; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Efpvtuch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A60D1F000E9;
	Tue, 21 Jul 2026 22:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672259;
	bh=PF/hUsF/iIFcMhwS2rvyaeM1wpQuDJDamH/p0IRRYTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EfpvtuchrylKyAN1TCBmz551hvP6uSGdYfcT1mbkRVOsXBSvfXjXpsG7dCz0ta1U6
	 ZN1fuq98+qmPkJ/fW4qipAZbxi96i1LiRMN+p5vt+2sFvjYR1figFf3CN8h+pGJfTF
	 AVnZh8INnfeHudfP1LJO970UdiZBvo6+/0VXuhkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Ghosh <sumang@marvell.com>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 540/843] octeontx2-pf: Add additional checks while configuring ucast/bcast/mcast rules
Date: Tue, 21 Jul 2026 17:22:55 +0200
Message-ID: <20260721152418.183141609@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suman Ghosh <sumang@marvell.com>

[ Upstream commit 674b3e164238a31f236ac63f82d5d160f7d4c201 ]

1. If a profile does not support DMAC extraction then avoid installing NPC
flow rules for unicast. Similarly, if LXMB(L2 and L3) extraction is not
supported by the profile then avoid installing broadcast and multicast
rules.
2. Allow MCAM entry insertion for promiscuous mode.
3. For the profiles where DMAC is not extracted in MKEX key default
unicast entry installed by AF is not valid. Hence do not use action
from the AF installed default unicast entry for such cases.
4. Adjacent packet header fields in a packet like IP header source
and destination addresses or UDP/TCP header source port and destination
can be extracted together in MKEX profile. Therefore MKEX profile can be
configured to in two ways:
	a. Total of 4 bytes from start of UDP header(src port
	   + destination port)
	or
	b. Two bytes from start and two bytes from offset 2

Signed-off-by: Suman Ghosh <sumang@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Link: https://lore.kernel.org/r/20221118053329.2288486-1-sumang@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 235acadd3105 ("octeontx2-pf: check DMAC extraction support before filtering")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/af/mbox.h  | 14 ++++
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  1 +
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   | 22 ++++++
 .../marvell/octeontx2/af/rvu_npc_fs.c         | 76 +++++++++++++++----
 .../marvell/octeontx2/nic/otx2_flows.c        | 27 ++++++-
 5 files changed, 124 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 6fb7a67f5c4cf2..b7760463b08f8c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -240,6 +240,9 @@ M(NPC_MCAM_GET_STATS, 0x6012, npc_mcam_entry_stats,                     \
 M(NPC_GET_SECRET_KEY, 0x6013, npc_get_secret_key,                     \
 				   npc_get_secret_key_req,              \
 				   npc_get_secret_key_rsp)              \
+M(NPC_GET_FIELD_STATUS, 0x6014, npc_get_field_status,                     \
+				   npc_get_field_status_req,              \
+				   npc_get_field_status_rsp)              \
 /* NIX mbox IDs (range 0x8000 - 0xFFFF) */				\
 M(NIX_LF_ALLOC,		0x8000, nix_lf_alloc,				\
 				 nix_lf_alloc_req, nix_lf_alloc_rsp)	\
@@ -1415,6 +1418,17 @@ struct ptp_rsp {
 	u64 clk;
 };
 
+struct npc_get_field_status_req {
+	struct mbox_msghdr hdr;
+	u8 intf;
+	u8 field;
+};
+
+struct npc_get_field_status_rsp {
+	struct mbox_msghdr hdr;
+	u8 enable;
+};
+
 struct set_vf_perm  {
 	struct  mbox_msghdr hdr;
 	u16	vf;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 2a9c68f692d6f0..9ce7c78e512759 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -856,6 +856,7 @@ int npc_install_mcam_drop_rule(struct rvu *rvu, int mcam_idx, u16 *counter_idx,
 			       u64 chan_val, u64 chan_mask, u64 exact_val, u64 exact_mask,
 			       u64 bcast_mcast_val, u64 bcast_mcast_mask);
 void npc_mcam_rsrcs_reserve(struct rvu *rvu, int blkaddr, int entry_idx);
+bool npc_is_feature_supported(struct rvu *rvu, u64 features, u8 intf);
 
 /* CPT APIs */
 int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int lf, int slot);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index fa9d6c9948f293..9ad94badbb5e13 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -627,6 +627,12 @@ void rvu_npc_install_ucast_entry(struct rvu *rvu, u16 pcifunc,
 	if (blkaddr < 0)
 		return;
 
+	/* Ucast rule should not be installed if DMAC
+	 * extraction is not supported by the profile.
+	 */
+	if (!npc_is_feature_supported(rvu, BIT_ULL(NPC_DMAC), pfvf->nix_rx_intf))
+		return;
+
 	index = npc_get_nixlf_mcam_index(mcam, pcifunc,
 					 nixlf, NIXLF_UCAST_ENTRY);
 
@@ -791,6 +797,14 @@ void rvu_npc_install_bcast_match_entry(struct rvu *rvu, u16 pcifunc,
 	/* Get 'pcifunc' of PF device */
 	pcifunc = pcifunc & ~RVU_PFVF_FUNC_MASK;
 	pfvf = rvu_get_pfvf(rvu, pcifunc);
+
+	/* Bcast rule should not be installed if both DMAC
+	 * and LXMB extraction is not supported by the profile.
+	 */
+	if (!npc_is_feature_supported(rvu, BIT_ULL(NPC_DMAC), pfvf->nix_rx_intf) &&
+	    !npc_is_feature_supported(rvu, BIT_ULL(NPC_LXMB), pfvf->nix_rx_intf))
+		return;
+
 	index = npc_get_nixlf_mcam_index(mcam, pcifunc,
 					 nixlf, NIXLF_BCAST_ENTRY);
 
@@ -862,6 +876,14 @@ void rvu_npc_install_allmulti_entry(struct rvu *rvu, u16 pcifunc, int nixlf,
 	vf_func = pcifunc & RVU_PFVF_FUNC_MASK;
 	pcifunc = pcifunc & ~RVU_PFVF_FUNC_MASK;
 	pfvf = rvu_get_pfvf(rvu, pcifunc);
+
+	/* Mcast rule should not be installed if both DMAC
+	 * and LXMB extraction is not supported by the profile.
+	 */
+	if (!npc_is_feature_supported(rvu, BIT_ULL(NPC_DMAC), pfvf->nix_rx_intf) &&
+	    !npc_is_feature_supported(rvu, BIT_ULL(NPC_LXMB), pfvf->nix_rx_intf))
+		return;
+
 	index = npc_get_nixlf_mcam_index(mcam, pcifunc,
 					 nixlf, NIXLF_ALLMULTI_ENTRY);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 50d3994efa97af..f3fecd2a4015be 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -47,6 +47,19 @@ static const char * const npc_flow_names[] = {
 	[NPC_UNKNOWN]	= "unknown",
 };
 
+bool npc_is_feature_supported(struct rvu *rvu, u64 features, u8 intf)
+{
+	struct npc_mcam *mcam = &rvu->hw->mcam;
+	u64 mcam_features;
+	u64 unsupported;
+
+	mcam_features = is_npc_intf_tx(intf) ? mcam->tx_features : mcam->rx_features;
+	unsupported = (mcam_features ^ features) & ~mcam_features;
+
+	/* Return false if at least one of the input flows is not extracted */
+	return !unsupported;
+}
+
 const char *npc_get_field_name(u8 hdr)
 {
 	if (hdr >= ARRAY_SIZE(npc_flow_names))
@@ -436,8 +449,6 @@ static void npc_scan_ldata(struct rvu *rvu, int blkaddr, u8 lid,
 	nr_bytes = FIELD_GET(NPC_BYTESM, cfg) + 1;
 	hdr = FIELD_GET(NPC_HDR_OFFSET, cfg);
 	key = FIELD_GET(NPC_KEY_OFFSET, cfg);
-	start_kwi = key / 8;
-	offset = (key * 8) % 64;
 
 	/* For Tx, Layer A has NIX_INST_HDR_S(64 bytes) preceding
 	 * ethernet header.
@@ -452,13 +463,18 @@ static void npc_scan_ldata(struct rvu *rvu, int blkaddr, u8 lid,
 
 #define NPC_SCAN_HDR(name, hlid, hlt, hstart, hlen)			       \
 do {									       \
+	start_kwi = key / 8;						       \
+	offset = (key * 8) % 64;					       \
 	if (lid == (hlid) && lt == (hlt)) {				       \
 		if ((hstart) >= hdr &&					       \
 		    ((hstart) + (hlen)) <= (hdr + nr_bytes)) {	               \
 			bit_offset = (hdr + nr_bytes - (hstart) - (hlen)) * 8; \
 			npc_set_layer_mdata(mcam, (name), cfg, lid, lt, intf); \
+			offset += bit_offset;				       \
+			start_kwi += offset / 64;			       \
+			offset %= 64;					       \
 			npc_set_kw_masks(mcam, (name), (hlen) * 8,	       \
-					 start_kwi, offset + bit_offset, intf);\
+					 start_kwi, offset, intf);	       \
 		}							       \
 	}								       \
 } while (0)
@@ -650,9 +666,9 @@ static int npc_check_unsupported_flows(struct rvu *rvu, u64 features, u8 intf)
 
 	unsupported = (*mcam_features ^ features) & ~(*mcam_features);
 	if (unsupported) {
-		dev_info(rvu->dev, "Unsupported flow(s):\n");
+		dev_warn(rvu->dev, "Unsupported flow(s):\n");
 		for_each_set_bit(bit, (unsigned long *)&unsupported, 64)
-			dev_info(rvu->dev, "%s ", npc_get_field_name(bit));
+			dev_warn(rvu->dev, "%s ", npc_get_field_name(bit));
 		return -EOPNOTSUPP;
 	}
 
@@ -1007,8 +1023,20 @@ static void npc_update_rx_entry(struct rvu *rvu, struct rvu_pfvf *pfvf,
 	action.match_id = req->match_id;
 	action.flow_key_alg = req->flow_key_alg;
 
-	if (req->op == NIX_RX_ACTION_DEFAULT && pfvf->def_ucast_rule)
-		action = pfvf->def_ucast_rule->rx_action;
+	if (req->op == NIX_RX_ACTION_DEFAULT) {
+		if (pfvf->def_ucast_rule) {
+			action = pfvf->def_ucast_rule->rx_action;
+		} else {
+			/* For profiles which do not extract DMAC, the default
+			 * unicast entry is unused. Hence modify action for the
+			 * requests which use same action as default unicast
+			 * entry
+			 */
+			*(u64 *)&action = 0;
+			action.pf_func = target;
+			action.op = NIX_RX_ACTIONOP_UCAST;
+		}
+	}
 
 	entry->action = *(u64 *)&action;
 
@@ -1239,18 +1267,19 @@ int rvu_mbox_handler_npc_install_flow(struct rvu *rvu,
 	if (npc_check_field(rvu, blkaddr, NPC_DMAC, req->intf))
 		goto process_flow;
 
-	if (is_pffunc_af(req->hdr.pcifunc)) {
+	if (is_pffunc_af(req->hdr.pcifunc) &&
+	    req->features & BIT_ULL(NPC_DMAC)) {
 		if (is_unicast_ether_addr(req->packet.dmac)) {
-			dev_err(rvu->dev,
-				"%s: mkex profile does not support ucast flow\n",
-				__func__);
+			dev_warn(rvu->dev,
+				 "%s: mkex profile does not support ucast flow\n",
+				 __func__);
 			return NPC_FLOW_NOT_SUPPORTED;
 		}
 
 		if (!npc_is_field_present(rvu, NPC_LXMB, req->intf)) {
-			dev_err(rvu->dev,
-				"%s: mkex profile does not support bcast/mcast flow",
-				__func__);
+			dev_warn(rvu->dev,
+				 "%s: mkex profile does not support bcast/mcast flow",
+				 __func__);
 			return NPC_FLOW_NOT_SUPPORTED;
 		}
 
@@ -1603,3 +1632,22 @@ int npc_install_mcam_drop_rule(struct rvu *rvu, int mcam_idx, u16 *counter_idx,
 
 	return 0;
 }
+
+int rvu_mbox_handler_npc_get_field_status(struct rvu *rvu,
+					  struct npc_get_field_status_req *req,
+					  struct npc_get_field_status_rsp *rsp)
+{
+	int blkaddr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
+	if (blkaddr < 0)
+		return NPC_MCAM_INVALID_REQ;
+
+	if (!is_npc_interface_valid(rvu, req->intf))
+		return NPC_FLOW_INTF_INVALID;
+
+	if (npc_check_field(rvu, blkaddr, req->field, req->intf))
+		rsp->enable = 1;
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 3c46cb0bd0de0f..87e41b9a0ce63d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -164,6 +164,8 @@ EXPORT_SYMBOL(otx2_alloc_mcam_entries);
 static int otx2_mcam_entry_init(struct otx2_nic *pfvf)
 {
 	struct otx2_flow_config *flow_cfg = pfvf->flow_cfg;
+	struct npc_get_field_status_req *freq;
+	struct npc_get_field_status_rsp *frsp;
 	struct npc_mcam_alloc_entry_req *req;
 	struct npc_mcam_alloc_entry_rsp *rsp;
 	int vf_vlan_max_flows;
@@ -218,8 +220,29 @@ static int otx2_mcam_entry_init(struct otx2_nic *pfvf)
 	flow_cfg->rx_vlan_offset = flow_cfg->unicast_offset +
 					OTX2_MAX_UNICAST_FLOWS;
 	pfvf->flags |= OTX2_FLAG_UCAST_FLTR_SUPPORT;
-	pfvf->flags |= OTX2_FLAG_RX_VLAN_SUPPORT;
-	pfvf->flags |= OTX2_FLAG_VF_VLAN_SUPPORT;
+
+	/* Check if NPC_DMAC field is supported
+	 * by the mkex profile before setting VLAN support flag.
+	 */
+	freq = otx2_mbox_alloc_msg_npc_get_field_status(&pfvf->mbox);
+	if (!freq) {
+		mutex_unlock(&pfvf->mbox.lock);
+		return -ENOMEM;
+	}
+
+	freq->field = NPC_DMAC;
+	if (otx2_sync_mbox_msg(&pfvf->mbox)) {
+		mutex_unlock(&pfvf->mbox.lock);
+		return -EINVAL;
+	}
+
+	frsp = (struct npc_get_field_status_rsp *)otx2_mbox_get_rsp
+	       (&pfvf->mbox.mbox, 0, &freq->hdr);
+
+	if (frsp->enable) {
+		pfvf->flags |= OTX2_FLAG_RX_VLAN_SUPPORT;
+		pfvf->flags |= OTX2_FLAG_VF_VLAN_SUPPORT;
+	}
 
 	pfvf->flags |= OTX2_FLAG_MCAM_ENTRIES_ALLOC;
 	mutex_unlock(&pfvf->mbox.lock);
-- 
2.53.0



