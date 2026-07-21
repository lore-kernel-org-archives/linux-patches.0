Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCD947011A;
	Tue, 21 Jul 2026 19:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661231; cv=none; b=Pt5+zp1dNwupnanpmGZowXJKxmSruRGJCYQWOyTSqo2p9lSYx51Ppw/AvhARkPUCi3xdBjKeZA/22yUgWktiejxozMjMo5gbX1ri1Tqte38nCfPaxV7qYLIWQc6CVut/wj1Dggq87na55G1AF8R5is24SxggG8Fwv0243BPCyQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661231; c=relaxed/simple;
	bh=NM6fMmFLgHmKTDf4/E/7Xvdi/dWskMNxCl/iy2B3B9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LwCizNnYe9hBvzMewKFttdO2zwhSlJE0EL01i9QukGhmNkGDAABnPucTTugQ0wpmMpdyDBWtmxX9/ocZhTTGmKgxl3XA66lJ9m4tnCI7cgJBZpuMD7modes/+m20fMxI3YXos7LmT9Rgad0iijDG3Pp+Z4HrtrWk+3NqBtQaaw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N4vFivuf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N4vFivuf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7237C1F000E9;
	Tue, 21 Jul 2026 19:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661229;
	bh=QEBgBeg0Gf0D/Z/X6x4dmBO6tsvcYFXWJ1/tZN+h7kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N4vFivufnmEuDJLsYSu4yyvZPr7Nb8420v6+2phjzxv5JwLEv/ICdDriOI9bmHPU5
	 K3K6MILKDF/tbpuQXfvOCkKlHw1uln2feOZUJbYHdMKMnEfsq8hx/p5tQh/0CrXmPI
	 vgtn2rwXX6zMYUHsMSAMMAatVflm//z5k23eRbrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linu Cherian <lcherian@marvell.com>,
	Yuho Choi <dbgh9129@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1279/2077] octeontx2-af: fix CGX debugfs RVU AF PCI reference leaks
Date: Tue, 21 Jul 2026 17:15:52 +0200
Message-ID: <20260721152622.985076747@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ratheesh Kannoth <rkannoth@marvell.com>

[ Upstream commit 469f4462ec83119e8bc0e4699ad01d80a9a4c61a ]

CGX per-lmac debugfs seq readers obtained struct rvu via
pci_get_drvdata(pci_get_device(..., PCI_DEVID_OCTEONTX2_RVU_AF, ...)),
which leaks a PCI device reference on every read. Store rvu and the CGX
handle in debugfs inode private data when creating stats, mac_filter,
and fwdata files (one context per CGX), and use debugfs aux numbers for
fwdata so lmac_id matches the other CGX debugfs entries.

Fixes: f967488d095e ("octeontx2-af: Add per CGX port level NIX Rx/Tx counters")
Fixes: dbc52debf95f ("octeontx2-af: Debugfs support for DMAC filters")
Fixes: 49f02e6877d1 ("Octeontx2-af: Debugfs support for firmware data")
Cc: Linu Cherian <lcherian@marvell.com>
Reported-by: Yuho Choi <dbgh9129@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Link: https://patch.msgid.link/20260622034229.2254145-1-rkannoth@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../marvell/octeontx2/af/rvu_debugfs.c        | 56 ++++++++++---------
 1 file changed, 30 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index ca2704b188a5cf..3456313d3b3c06 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -2810,6 +2810,14 @@ static void rvu_dbg_npa_init(struct rvu *rvu)
 			    &rvu_dbg_npa_ndc_hits_miss_fops);
 }
 
+/* Per-lmac CGX debugfs files need both RVU and CGX handle; inode->i_private
+ * points here so seq_file ops avoid pci_get_device(PCI_DEVID_OCTEONTX2_RVU_AF).
+ */
+struct rvu_cgx_lmac_dbgfs_ctx {
+	struct rvu	*rvu;
+	void		*cgxd;
+};
+
 #define PRINT_CGX_CUML_NIXRX_STATUS(idx, name)				\
 	({								\
 		u64 cnt;						\
@@ -2832,18 +2840,14 @@ static void rvu_dbg_npa_init(struct rvu *rvu)
 
 static int cgx_print_stats(struct seq_file *s, int lmac_id)
 {
+	struct rvu_cgx_lmac_dbgfs_ctx *dctx = s->private;
 	struct cgx_link_user_info linfo;
+	struct rvu *rvu = dctx->rvu;
 	struct mac_ops *mac_ops;
-	void *cgxd = s->private;
+	void *cgxd = dctx->cgxd;
 	u64 ucast, mcast, bcast;
 	int stat = 0, err = 0;
 	u64 tx_stat, rx_stat;
-	struct rvu *rvu;
-
-	rvu = pci_get_drvdata(pci_get_device(PCI_VENDOR_ID_CAVIUM,
-					     PCI_DEVID_OCTEONTX2_RVU_AF, NULL));
-	if (!rvu)
-		return -ENODEV;
 
 	mac_ops = get_mac_ops(cgxd);
 	/* There can be no CGX devices at all */
@@ -2950,20 +2954,16 @@ RVU_DEBUG_SEQ_FOPS(cgx_stat, cgx_stat_display, NULL);
 
 static int cgx_print_dmac_flt(struct seq_file *s, int lmac_id)
 {
+	struct rvu_cgx_lmac_dbgfs_ctx *dctx = s->private;
+	struct rvu *rvu = dctx->rvu;
 	struct pci_dev *pdev = NULL;
-	void *cgxd = s->private;
+	void *cgxd = dctx->cgxd;
 	char *bcast, *mcast;
 	u16 index, domain;
 	u8 dmac[ETH_ALEN];
-	struct rvu *rvu;
 	u64 cfg, mac;
 	int pf;
 
-	rvu = pci_get_drvdata(pci_get_device(PCI_VENDOR_ID_CAVIUM,
-					     PCI_DEVID_OCTEONTX2_RVU_AF, NULL));
-	if (!rvu)
-		return -ENODEV;
-
 	pf = cgxlmac_to_pf(rvu, cgx_get_cgxid(cgxd), lmac_id);
 	domain = 2;
 
@@ -3010,17 +3010,13 @@ RVU_DEBUG_SEQ_FOPS(cgx_dmac_flt, cgx_dmac_flt_display, NULL);
 
 static int cgx_print_fwdata(struct seq_file *s, int lmac_id)
 {
+	struct rvu_cgx_lmac_dbgfs_ctx *dctx = s->private;
 	struct cgx_lmac_fwdata_s *fwdata;
-	void *cgxd = s->private;
+	struct rvu *rvu = dctx->rvu;
+	void *cgxd = dctx->cgxd;
 	struct phy_s *phy;
-	struct rvu *rvu;
 	int cgx_id, i;
 
-	rvu = pci_get_drvdata(pci_get_device(PCI_VENDOR_ID_CAVIUM,
-					     PCI_DEVID_OCTEONTX2_RVU_AF, NULL));
-	if (!rvu)
-		return -ENODEV;
-
 	if (!rvu->fwdata)
 		return -EAGAIN;
 
@@ -3101,6 +3097,7 @@ RVU_DEBUG_SEQ_FOPS(cgx_fwdata, cgx_fwdata_display, NULL);
 
 static void rvu_dbg_cgx_init(struct rvu *rvu)
 {
+	struct rvu_cgx_lmac_dbgfs_ctx *ctx;
 	struct mac_ops *mac_ops;
 	unsigned long lmac_bmap;
 	int i, lmac_id;
@@ -3127,6 +3124,13 @@ static void rvu_dbg_cgx_init(struct rvu *rvu)
 		rvu->rvu_dbg.cgx = debugfs_create_dir(dname,
 						      rvu->rvu_dbg.cgx_root);
 
+		ctx = devm_kzalloc(rvu->dev, sizeof(*ctx), GFP_KERNEL);
+		if (!ctx)
+			continue;
+
+		ctx->rvu = rvu;
+		ctx->cgxd = cgx;
+
 		for_each_set_bit(lmac_id, &lmac_bmap, rvu->hw->lmac_per_cgx) {
 			/* lmac debugfs dir */
 			sprintf(dname, "lmac%d", lmac_id);
@@ -3134,13 +3138,13 @@ static void rvu_dbg_cgx_init(struct rvu *rvu)
 				debugfs_create_dir(dname, rvu->rvu_dbg.cgx);
 
 			debugfs_create_file_aux_num("stats", 0600, rvu->rvu_dbg.lmac,
-					    cgx, lmac_id, &rvu_dbg_cgx_stat_fops);
+						    ctx, lmac_id, &rvu_dbg_cgx_stat_fops);
 			debugfs_create_file_aux_num("mac_filter", 0600,
-					    rvu->rvu_dbg.lmac, cgx, lmac_id,
+					    rvu->rvu_dbg.lmac, ctx, lmac_id,
 					    &rvu_dbg_cgx_dmac_flt_fops);
-			debugfs_create_file("fwdata", 0600,
-					    rvu->rvu_dbg.lmac, cgx,
-					    &rvu_dbg_cgx_fwdata_fops);
+			debugfs_create_file_aux_num("fwdata", 0600,
+						    rvu->rvu_dbg.lmac, ctx,
+						    lmac_id, &rvu_dbg_cgx_fwdata_fops);
 		}
 	}
 }
-- 
2.53.0



