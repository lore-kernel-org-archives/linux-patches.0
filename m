Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B54827CB04;
	Tue, 27 May 2025 17:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366031; cv=none; b=HwoQU3Yl2zjZ3cWiDVll9z8Oqff8S+Wo5kF/bA2WvAAq3QceyyqpEgHVzxHK8zVz1pBz8YaOJ3cy/ARBQFOp57JVjnbJCvcURxREkjQstf3RJDdEAvGUNnioGLeeFhBUg98cL+AQckk7o8mZFD65bRh/ME7njmcndDTGerRJfpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366031; c=relaxed/simple;
	bh=VGWKy9pjrw+JDs1vpdClGUwvl5qQEAiaBvA8f+TvS9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EaS0KhfM3n5XNEd9I5j6JjikqZXg2y7GZ90fp7q7zhvKPE6GnXeVv6836f3M6IdhdWbLbb3FyqUWfDl6aelyRrSqQd0/odprBshCY8OTcXvmsoh9JoM8icdCnamB84j6pF0sGdVhfnDLRBxdFhOvNtNvFjz6+vkU+Tjyoqzsp+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=el6uPryG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="el6uPryG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8BAC4CEE9;
	Tue, 27 May 2025 17:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366031;
	bh=VGWKy9pjrw+JDs1vpdClGUwvl5qQEAiaBvA8f+TvS9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=el6uPryGXroqwCIIYZ7v8ZyNap2NpuGLXhFF6UkkMm+FpGesfm2igzcBs/DNd8L7Q
	 pddNQK3XWqxQqje66YEfuwxT5tL5sdVkGj8foWiD4VubLiYz8DM6RnKgXphcGJwHAX
	 4/EQYrg7Lh20rkNWw6hmu1p/wOpCuRfdxEpLFAeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 568/626] octeontx2-af: Fix APR entry mapping based on APR_LMT_CFG
Date: Tue, 27 May 2025 18:27:41 +0200
Message-ID: <20250527162508.043855681@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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
index 3838c04b78c22..4a3370a40dd88 100644
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
index 87ba77e5026a0..e24accfecb3fb 100644
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



