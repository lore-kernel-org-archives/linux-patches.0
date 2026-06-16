Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1999C331A44;
	Tue, 16 Jun 2026 17:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631435; cv=none; b=ND8+j81AQaTsRIm2TPNs4tcoVRV5AF6MO4PX1CR1s+dQMDY0NEHKdXTO5AIPial+hVN2df9eR9mv1IdkIklYIscpY1CmbHNPnPqil9ezVT4M3JIteRaPG+gqNFtymRU2kau/h39YZR4H3dZ5WmQpsxvOSFuqoAxB/rGmd7XzAXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631435; c=relaxed/simple;
	bh=vr9yrF9g1HnKPrJEfwK0i0wyn3LsFSqSCjb23ndBuEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/Q5fxiTaqIYXFjMB/B8267/+78KXwOzZNICo4EVPJ0iBbJDNfPEoycEoqaVmAI1V1KVibIBTuazCH9d+YCYJL8rJqqmxAHwoRUkjDZ4wp9ScK9K7h1VKbADvVc8DCP6In5/tPqIT7IvofDueUyvNidTbwmVVbLiVJlD8iNzqoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bturRMP0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bturRMP0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283801F000E9;
	Tue, 16 Jun 2026 17:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631434;
	bh=d27B7WeC/Re/rlhQonTZuPhVmVp9H3CZ026rO/lJ6gI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bturRMP0itw0E5aIXnkdLLlj+8ZPKIx2VtmzBDa2uguBNQ0yvVqzoUfoP4Qm8OENI
	 Eob4wW5kpj+0gwL1ePTrF5HIORby/ZZmwXxOnRgaLrII5jkfHdpOxL9D0Z80HEF1+R
	 IsMDN8p21EQkjlhKxckhIJ91v+OWDJuetSPSyWpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naveen Mamindlapalli <naveenm@marvell.com>,
	Nithin Dabilpuram <ndabilpuram@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 221/522] octeontx2-af: npc: Fix CPT channel mask in npc_install_flow
Date: Tue, 16 Jun 2026 20:26:08 +0530
Message-ID: <20260616145136.361470994@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nithin Dabilpuram <ndabilpuram@marvell.com>

[ Upstream commit 1d31eb27e570daa04f5373345f9ac98c95863be9 ]

Use the CPT-aware NIX channel mask in the npc_install_flow path so that
when the host PF installs steering rules in kernel for a VF used from
userspace (e.g. DPDK), MCAM entries see the same channel mask semantics as
other RX paths.

Fixes: 56bcef528bd8 ("octeontx2-af: Use npc_install_flow API for promisc and broadcast entries")
Cc: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: Nithin Dabilpuram <ndabilpuram@marvell.com>
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Link: https://patch.msgid.link/20260602045853.1558530-1-rkannoth@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  1 +
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   | 32 +++++++++----------
 .../marvell/octeontx2/af/rvu_npc_fs.c         |  2 +-
 3 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index fc0f3398a556bb..86ef67745ebdf7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -895,6 +895,7 @@ int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int lf,
 			int slot);
 int rvu_cpt_ctx_flush(struct rvu *rvu, u16 pcifunc);
 int rvu_cpt_init(struct rvu *rvu);
+u32 rvu_get_cpt_chan_mask(struct rvu *rvu);
 
 #define NDC_AF_BANK_MASK       GENMASK_ULL(7, 0)
 #define NDC_AF_BANK_LINE_MASK  GENMASK_ULL(31, 16)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 9b8a6046e6dff0..65ad7476e60983 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -609,6 +609,19 @@ static u64 npc_get_mcam_action(struct rvu *rvu, struct npc_mcam *mcam,
 			  NPC_AF_MCAMEX_BANKX_ACTION(index, bank));
 }
 
+u32 rvu_get_cpt_chan_mask(struct rvu *rvu)
+{
+	/* For cn10k the upper two bits of the channel number are
+	 * cpt channel number. with masking out these bits in the
+	 * mcam entry, same entry used for NIX will allow packets
+	 * received from cpt for parsing.
+	 */
+	if (!is_rvu_otx2(rvu))
+		return NIX_CHAN_CPT_X2P_MASK;
+	else
+		return 0xFFFu;
+}
+
 void rvu_npc_install_ucast_entry(struct rvu *rvu, u16 pcifunc,
 				 int nixlf, u64 chan, u8 *mac_addr)
 {
@@ -652,7 +665,7 @@ void rvu_npc_install_ucast_entry(struct rvu *rvu, u16 pcifunc,
 	eth_broadcast_addr((u8 *)&req.mask.dmac);
 	req.features = BIT_ULL(NPC_DMAC);
 	req.channel = chan;
-	req.chan_mask = 0xFFFU;
+	req.chan_mask = rvu_get_cpt_chan_mask(rvu);
 	req.intf = pfvf->nix_rx_intf;
 	req.op = action.op;
 	req.hdr.pcifunc = 0; /* AF is requester */
@@ -722,11 +735,7 @@ void rvu_npc_install_promisc_entry(struct rvu *rvu, u16 pcifunc,
 	 * mcam entry, same entry used for NIX will allow packets
 	 * received from cpt for parsing.
 	 */
-	if (!is_rvu_otx2(rvu)) {
-		req.chan_mask = NIX_CHAN_CPT_X2P_MASK;
-	} else {
-		req.chan_mask = 0xFFFU;
-	}
+	req.chan_mask = rvu_get_cpt_chan_mask(rvu);
 
 	if (chan_cnt > 1) {
 		if (!is_power_of_2(chan_cnt)) {
@@ -915,16 +924,7 @@ void rvu_npc_install_allmulti_entry(struct rvu *rvu, u16 pcifunc, int nixlf,
 	ether_addr_copy(req.mask.dmac, mac_addr);
 	req.features = BIT_ULL(NPC_DMAC);
 
-	/* For cn10k the upper two bits of the channel number are
-	 * cpt channel number. with masking out these bits in the
-	 * mcam entry, same entry used for NIX will allow packets
-	 * received from cpt for parsing.
-	 */
-	if (!is_rvu_otx2(rvu))
-		req.chan_mask = NIX_CHAN_CPT_X2P_MASK;
-	else
-		req.chan_mask = 0xFFFU;
-
+	req.chan_mask = rvu_get_cpt_chan_mask(rvu);
 	req.channel = chan;
 	req.intf = pfvf->nix_rx_intf;
 	req.entry = index;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 80d6aa3f14c11f..b79b28192a5764 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -1320,7 +1320,7 @@ int rvu_mbox_handler_npc_install_flow(struct rvu *rvu,
 
 	/* ignore chan_mask in case pf func is not AF, revisit later */
 	if (!is_pffunc_af(req->hdr.pcifunc))
-		req->chan_mask = 0xFFF;
+		req->chan_mask = rvu_get_cpt_chan_mask(rvu);
 
 	err = npc_check_unsupported_flows(rvu, req->features, req->intf);
 	if (err)
-- 
2.53.0



