Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAC2225397;
	Mon,  2 Jun 2025 14:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874088; cv=none; b=GHA+Y/HXXKitXWHMQPK+rjCfCWCfPyaJRU4XQQW+TVHc8I/ZPKt7kW0AyzRI0LKT18JFWSBxJs3PM16gyjxtM9pE+u9lH69uWEpMO2KyQ7XZLQHe+W38oESOTu9nI9cMyNFiv1ZJcQ7yzx29V0mAehNSF8yE4pY212FNVSaN4bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874088; c=relaxed/simple;
	bh=/AvT+IXZJMliHO8zRiTSRawpq2aeFMwOcrBcswi3oeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MAZBK6uwP5yCX6pfPANN121JkYRpl7j6hozIMqJ9iSk5uQGszknR4m9SEI0YyYRtJGooN/QqmRQ2bXi7Y3yapQ4Mr0sgy38lOmg+RXdhfTt4oCY48IjqLFhU02DxYQUHLH74NpukReLAtactax7wUTzFyeoOWWDGiHgA5vQtDAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eRw10sPv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eRw10sPv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB21FC4CEEB;
	Mon,  2 Jun 2025 14:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874088;
	bh=/AvT+IXZJMliHO8zRiTSRawpq2aeFMwOcrBcswi3oeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eRw10sPvBrrBbo/BhZS6B8dnQnjnzbkjuUVNm1VKbec3ORszHb3W7bdRiLKTItS8W
	 eQptV6gHtyr+8xelONOndERLuZCOEtJfCN7Elx2DTSAlUw+JA3sqr309pa1IFkwZey
	 Dk63gEFt0utiPVlG5UF1QnF81nmlPEe//kqYU0D8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 354/444] octeontx2-af: Fix APR entry mapping based on APR_LMT_CFG
Date: Mon,  2 Jun 2025 15:46:58 +0200
Message-ID: <20250602134355.296787131@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit a6ae7129819ad20788e610261246e71736543b8b ]

The current implementation maps the APR table using a fixed size,
which can lead to incorrect mapping when the number of PFs and VFs
varies.
This patch corrects the mapping by calculating the APR table
size dynamically based on the values configured in the
APR_LMT_CFG register, ensuring accurate representation
of APR entries in debugfs.

Fixes: 0daa55d033b0 ("octeontx2-af: cn10k: debugfs for dumping LMTST map table").
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Link: https://patch.msgid.link/20250521060834.19780-3-gakula@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c |  9 ++++++---
 .../net/ethernet/marvell/octeontx2/af/rvu_debugfs.c   | 11 ++++++++---
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
index de91053ad5a3d..1e4cd4f7d0cfd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
@@ -13,7 +13,6 @@
 /* RVU LMTST */
 #define LMT_TBL_OP_READ		0
 #define LMT_TBL_OP_WRITE	1
-#define LMT_MAP_TABLE_SIZE	(128 * 1024)
 #define LMT_MAPTBL_ENTRY_SIZE	16
 #define LMT_MAX_VFS		256
 
@@ -26,10 +25,14 @@ static int lmtst_map_table_ops(struct rvu *rvu, u32 index, u64 *val,
 {
 	void __iomem *lmt_map_base;
 	u64 tbl_base, cfg;
+	int pfs, vfs;
 
 	tbl_base = rvu_read64(rvu, BLKADDR_APR, APR_AF_LMT_MAP_BASE);
+	cfg  = rvu_read64(rvu, BLKADDR_APR, APR_AF_LMT_CFG);
+	vfs = 1 << (cfg & 0xF);
+	pfs = 1 << ((cfg >> 4) & 0x7);
 
-	lmt_map_base = ioremap_wc(tbl_base, LMT_MAP_TABLE_SIZE);
+	lmt_map_base = ioremap_wc(tbl_base, pfs * vfs * LMT_MAPTBL_ENTRY_SIZE);
 	if (!lmt_map_base) {
 		dev_err(rvu->dev, "Failed to setup lmt map table mapping!!\n");
 		return -ENOMEM;
@@ -80,7 +83,7 @@ static int rvu_get_lmtaddr(struct rvu *rvu, u16 pcifunc,
 
 	mutex_lock(&rvu->rsrc_lock);
 	rvu_write64(rvu, BLKADDR_RVUM, RVU_AF_SMMU_ADDR_REQ, iova);
-	pf = rvu_get_pf(pcifunc) & 0x1F;
+	pf = rvu_get_pf(pcifunc) & RVU_PFVF_PF_MASK;
 	val = BIT_ULL(63) | BIT_ULL(14) | BIT_ULL(13) | pf << 8 |
 	      ((pcifunc & RVU_PFVF_FUNC_MASK) & 0xFF);
 	rvu_write64(rvu, BLKADDR_RVUM, RVU_AF_SMMU_TXN_REQ, val);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index feca86e429df2..56dab11833b53 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -580,6 +580,7 @@ static ssize_t rvu_dbg_lmtst_map_table_display(struct file *filp,
 	u64 lmt_addr, val, tbl_base;
 	int pf, vf, num_vfs, hw_vfs;
 	void __iomem *lmt_map_base;
+	int apr_pfs, apr_vfs;
 	int buf_size = 10240;
 	size_t off = 0;
 	int index = 0;
@@ -595,8 +596,12 @@ static ssize_t rvu_dbg_lmtst_map_table_display(struct file *filp,
 		return -ENOMEM;
 
 	tbl_base = rvu_read64(rvu, BLKADDR_APR, APR_AF_LMT_MAP_BASE);
+	val  = rvu_read64(rvu, BLKADDR_APR, APR_AF_LMT_CFG);
+	apr_vfs = 1 << (val & 0xF);
+	apr_pfs = 1 << ((val >> 4) & 0x7);
 
-	lmt_map_base = ioremap_wc(tbl_base, 128 * 1024);
+	lmt_map_base = ioremap_wc(tbl_base, apr_pfs * apr_vfs *
+				  LMT_MAPTBL_ENTRY_SIZE);
 	if (!lmt_map_base) {
 		dev_err(rvu->dev, "Failed to setup lmt map table mapping!!\n");
 		kfree(buf);
@@ -618,7 +623,7 @@ static ssize_t rvu_dbg_lmtst_map_table_display(struct file *filp,
 		off += scnprintf(&buf[off], buf_size - 1 - off, "PF%d  \t\t\t",
 				    pf);
 
-		index = pf * rvu->hw->total_vfs * LMT_MAPTBL_ENTRY_SIZE;
+		index = pf * apr_vfs * LMT_MAPTBL_ENTRY_SIZE;
 		off += scnprintf(&buf[off], buf_size - 1 - off, " 0x%llx\t\t",
 				 (tbl_base + index));
 		lmt_addr = readq(lmt_map_base + index);
@@ -631,7 +636,7 @@ static ssize_t rvu_dbg_lmtst_map_table_display(struct file *filp,
 		/* Reading num of VFs per PF */
 		rvu_get_pf_numvfs(rvu, pf, &num_vfs, &hw_vfs);
 		for (vf = 0; vf < num_vfs; vf++) {
-			index = (pf * rvu->hw->total_vfs * 16) +
+			index = (pf * apr_vfs * LMT_MAPTBL_ENTRY_SIZE) +
 				((vf + 1)  * LMT_MAPTBL_ENTRY_SIZE);
 			off += scnprintf(&buf[off], buf_size - 1 - off,
 					    "PF%d:VF%d  \t\t", pf, vf);
-- 
2.39.5



