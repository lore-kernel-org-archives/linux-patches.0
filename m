Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C82A95E;
	Mon, 16 Sep 2024 12:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488071; cv=none; b=tIlsWeck0OolkHxwzWIT5aZTEiiaRdPcTqMQQKpXL2jtEU2xsAqzXYsjEepsK5sx+t+xaJd5JH5wsbln3sn4Yyu3+Nt63z2fwVMA74/LXDJhVegkgDG08W3NAp+wCyvS1OXoIfOP2kg7yESkpeTmx2g33ehjzc3G83Jakh1Ymy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488071; c=relaxed/simple;
	bh=2xw6tseLLgqUfiISwQnXEtnYVIkFd4wimEnDw2mXYSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dG9z8YV/71gYgqrpwk9Pr8HUR3oJ9KBtnNNiqadezGC7jkaPaA7oNiM7WCUmFu24rz2STjt5m87xUivy/EAPyCrS2O00r98ESmwL+hdbrPKKDjCM6H9SWZzD0KtWx6p5DJGU2K05GBvTh2P/KUbnOUrgeknb0EMHZz7sUmkKdKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fUOT5mnc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fUOT5mnc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C83EC4CEC4;
	Mon, 16 Sep 2024 12:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488071;
	bh=2xw6tseLLgqUfiISwQnXEtnYVIkFd4wimEnDw2mXYSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fUOT5mnc1zqLNmAqLd0+PK8oAfwT+KCQky9hdL1KhatGwPtFg0v6t8qciAwh+rJwN
	 mHUWAizmTl5yhMiMT5EJ8eim8aaeJ3s4AuAm0vE6PjIdXp48oK9XF6bhETow3+zIvE
	 KMJTWP5Sz2Ho+wN86rr+LGZ+f/gZUzdWGH+CJG4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naveen Mamindlapalli <naveenm@marvell.com>,
	Sunil Kovvuri Goutham <sgoutham@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 49/63] octeontx2-af: Modify SMQ flush sequence to drop packets
Date: Mon, 16 Sep 2024 13:44:28 +0200
Message-ID: <20240916114222.798982924@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
References: <20240916114221.021192667@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naveen Mamindlapalli <naveenm@marvell.com>

[ Upstream commit 019aba04f08c2102b35ce7fee9d4628d349f56c0 ]

The current implementation of SMQ flush sequence waits for the packets
in the TM pipeline to be transmitted out of the link. This sequence
doesn't succeed in HW when there is any issue with link such as lack of
link credits, link down or any other traffic that is fully occupying the
link bandwidth (QoS). This patch modifies the SMQ flush sequence to
drop the packets after TL1 level (SQM) instead of polling for the packets
to be sent out of RPM/CGX link.

Fixes: 5d9b976d4480 ("octeontx2-af: Support fixed transmit scheduler topology")
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Reviewed-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Link: https://patch.msgid.link/20240906045838.1620308-1-naveenm@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  3 +-
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   | 59 +++++++++++++++----
 2 files changed, 48 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index ee64cb077103..fc0f3398a556 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -288,6 +288,7 @@ struct nix_mark_format {
 
 /* smq(flush) to tl1 cir/pir info */
 struct nix_smq_tree_ctx {
+	u16 schq;
 	u64 cir_off;
 	u64 cir_val;
 	u64 pir_off;
@@ -297,8 +298,6 @@ struct nix_smq_tree_ctx {
 /* smq flush context */
 struct nix_smq_flush_ctx {
 	int smq;
-	u16 tl1_schq;
-	u16 tl2_schq;
 	struct nix_smq_tree_ctx smq_tree_ctx[NIX_TXSCH_LVL_CNT];
 };
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 7d7e84dedb54..7ed0eb9bd4ed 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -2134,14 +2134,13 @@ static void nix_smq_flush_fill_ctx(struct rvu *rvu, int blkaddr, int smq,
 	schq = smq;
 	for (lvl = NIX_TXSCH_LVL_SMQ; lvl <= NIX_TXSCH_LVL_TL1; lvl++) {
 		smq_tree_ctx = &smq_flush_ctx->smq_tree_ctx[lvl];
+		smq_tree_ctx->schq = schq;
 		if (lvl == NIX_TXSCH_LVL_TL1) {
-			smq_flush_ctx->tl1_schq = schq;
 			smq_tree_ctx->cir_off = NIX_AF_TL1X_CIR(schq);
 			smq_tree_ctx->pir_off = 0;
 			smq_tree_ctx->pir_val = 0;
 			parent_off = 0;
 		} else if (lvl == NIX_TXSCH_LVL_TL2) {
-			smq_flush_ctx->tl2_schq = schq;
 			smq_tree_ctx->cir_off = NIX_AF_TL2X_CIR(schq);
 			smq_tree_ctx->pir_off = NIX_AF_TL2X_PIR(schq);
 			parent_off = NIX_AF_TL2X_PARENT(schq);
@@ -2176,8 +2175,8 @@ static void nix_smq_flush_enadis_xoff(struct rvu *rvu, int blkaddr,
 {
 	struct nix_txsch *txsch;
 	struct nix_hw *nix_hw;
+	int tl2, tl2_schq;
 	u64 regoff;
-	int tl2;
 
 	nix_hw = get_nix_hw(rvu->hw, blkaddr);
 	if (!nix_hw)
@@ -2185,16 +2184,17 @@ static void nix_smq_flush_enadis_xoff(struct rvu *rvu, int blkaddr,
 
 	/* loop through all TL2s with matching PF_FUNC */
 	txsch = &nix_hw->txsch[NIX_TXSCH_LVL_TL2];
+	tl2_schq = smq_flush_ctx->smq_tree_ctx[NIX_TXSCH_LVL_TL2].schq;
 	for (tl2 = 0; tl2 < txsch->schq.max; tl2++) {
 		/* skip the smq(flush) TL2 */
-		if (tl2 == smq_flush_ctx->tl2_schq)
+		if (tl2 == tl2_schq)
 			continue;
 		/* skip unused TL2s */
 		if (TXSCH_MAP_FLAGS(txsch->pfvf_map[tl2]) & NIX_TXSCHQ_FREE)
 			continue;
 		/* skip if PF_FUNC doesn't match */
 		if ((TXSCH_MAP_FUNC(txsch->pfvf_map[tl2]) & ~RVU_PFVF_FUNC_MASK) !=
-		    (TXSCH_MAP_FUNC(txsch->pfvf_map[smq_flush_ctx->tl2_schq] &
+		    (TXSCH_MAP_FUNC(txsch->pfvf_map[tl2_schq] &
 				    ~RVU_PFVF_FUNC_MASK)))
 			continue;
 		/* enable/disable XOFF */
@@ -2236,10 +2236,12 @@ static int nix_smq_flush(struct rvu *rvu, int blkaddr,
 			 int smq, u16 pcifunc, int nixlf)
 {
 	struct nix_smq_flush_ctx *smq_flush_ctx;
+	int err, restore_tx_en = 0, i;
 	int pf = rvu_get_pf(pcifunc);
 	u8 cgx_id = 0, lmac_id = 0;
-	int err, restore_tx_en = 0;
-	u64 cfg;
+	u16 tl2_tl3_link_schq;
+	u8 link, link_level;
+	u64 cfg, bmap = 0;
 
 	/* enable cgx tx if disabled */
 	if (is_pf_cgxmapped(rvu, pf)) {
@@ -2256,16 +2258,38 @@ static int nix_smq_flush(struct rvu *rvu, int blkaddr,
 	nix_smq_flush_enadis_xoff(rvu, blkaddr, smq_flush_ctx, true);
 	nix_smq_flush_enadis_rate(rvu, blkaddr, smq_flush_ctx, false);
 
-	cfg = rvu_read64(rvu, blkaddr, NIX_AF_SMQX_CFG(smq));
-	/* Do SMQ flush and set enqueue xoff */
-	cfg |= BIT_ULL(50) | BIT_ULL(49);
-	rvu_write64(rvu, blkaddr, NIX_AF_SMQX_CFG(smq), cfg);
-
 	/* Disable backpressure from physical link,
 	 * otherwise SMQ flush may stall.
 	 */
 	rvu_cgx_enadis_rx_bp(rvu, pf, false);
 
+	link_level = rvu_read64(rvu, blkaddr, NIX_AF_PSE_CHANNEL_LEVEL) & 0x01 ?
+			NIX_TXSCH_LVL_TL3 : NIX_TXSCH_LVL_TL2;
+	tl2_tl3_link_schq = smq_flush_ctx->smq_tree_ctx[link_level].schq;
+	link = smq_flush_ctx->smq_tree_ctx[NIX_TXSCH_LVL_TL1].schq;
+
+	/* SMQ set enqueue xoff */
+	cfg = rvu_read64(rvu, blkaddr, NIX_AF_SMQX_CFG(smq));
+	cfg |= BIT_ULL(50);
+	rvu_write64(rvu, blkaddr, NIX_AF_SMQX_CFG(smq), cfg);
+
+	/* Clear all NIX_AF_TL3_TL2_LINK_CFG[ENA] for the TL3/TL2 queue */
+	for (i = 0; i < (rvu->hw->cgx_links + rvu->hw->lbk_links); i++) {
+		cfg = rvu_read64(rvu, blkaddr,
+				 NIX_AF_TL3_TL2X_LINKX_CFG(tl2_tl3_link_schq, link));
+		if (!(cfg & BIT_ULL(12)))
+			continue;
+		bmap |= (1 << i);
+		cfg &= ~BIT_ULL(12);
+		rvu_write64(rvu, blkaddr,
+			    NIX_AF_TL3_TL2X_LINKX_CFG(tl2_tl3_link_schq, link), cfg);
+	}
+
+	/* Do SMQ flush and set enqueue xoff */
+	cfg = rvu_read64(rvu, blkaddr, NIX_AF_SMQX_CFG(smq));
+	cfg |= BIT_ULL(50) | BIT_ULL(49);
+	rvu_write64(rvu, blkaddr, NIX_AF_SMQX_CFG(smq), cfg);
+
 	/* Wait for flush to complete */
 	err = rvu_poll_reg(rvu, blkaddr,
 			   NIX_AF_SMQX_CFG(smq), BIT_ULL(49), true);
@@ -2274,6 +2298,17 @@ static int nix_smq_flush(struct rvu *rvu, int blkaddr,
 			 "NIXLF%d: SMQ%d flush failed, txlink might be busy\n",
 			 nixlf, smq);
 
+	/* Set NIX_AF_TL3_TL2_LINKX_CFG[ENA] for the TL3/TL2 queue */
+	for (i = 0; i < (rvu->hw->cgx_links + rvu->hw->lbk_links); i++) {
+		if (!(bmap & (1 << i)))
+			continue;
+		cfg = rvu_read64(rvu, blkaddr,
+				 NIX_AF_TL3_TL2X_LINKX_CFG(tl2_tl3_link_schq, link));
+		cfg |= BIT_ULL(12);
+		rvu_write64(rvu, blkaddr,
+			    NIX_AF_TL3_TL2X_LINKX_CFG(tl2_tl3_link_schq, link), cfg);
+	}
+
 	/* clear XOFF on TL2s */
 	nix_smq_flush_enadis_rate(rvu, blkaddr, smq_flush_ctx, true);
 	nix_smq_flush_enadis_xoff(rvu, blkaddr, smq_flush_ctx, false);
-- 
2.43.0



