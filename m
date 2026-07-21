Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2762746D543;
	Tue, 21 Jul 2026 15:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648689; cv=none; b=e6XDAhBb8xacysbSIYSy+GPq5NGflsqY8wzfMr1c9C1iBo/fWYRQJTGJlLeA99iV5jJnqbbannYZcdcg7o56iJERcLBkUbhrIsxYBn3teLkeokZNCeFYCDvqMbgROyEyBjK/IPsqoczwagusapS0D1hGBTOWqpjJYpZuBdMHhl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648689; c=relaxed/simple;
	bh=kfG2RrHkRzZc/mOXVNC8ohSDbqtULCrFlU4NcaexCuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfloutWf4Kx7iEFNonQEJ14XqitKP2NbJ6uKHqFvFwG1aK0KN4rOsjXesCaqsXRLHThCjmDg6DSs0yKECx1d2DFOWCNccrBybWkQeiqMWIwvoPVVRFSy1lt7AxdJPnmSLRgXEi899cVtKY5J4EzqzOS+uoGjkSpq+SZo2uw7GmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ijBE4Zh4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ijBE4Zh4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D21F1F000E9;
	Tue, 21 Jul 2026 15:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648688;
	bh=/8Lk/AU7e+QggRIPtJzMqae7LbFXi7EJdh1xDqZGUNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ijBE4Zh4LyymE/MJKjpBSfXAX9+kNHL+TYO3XJMX360kdsZDJHSL8Rx6cemNbWd8V
	 olBAbsYPj1/5M3no9/tETVOPL+4aMWSPXGRflOg9a8Ssp4MgAbiwmbfuUWO6ndv0L0
	 P+vHXIk910BafYlYNlOEYXsdznbnykTur4jYqYGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0294/2077] RDMA/irdma: Fix out-of-bounds write in irdma_copy_user_pgaddrs
Date: Tue, 21 Jul 2026 16:59:27 +0200
Message-ID: <20260721152559.609166438@linuxfoundation.org>
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

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit 5ebb3ed757be3e04cf803026004aa0beaeb13e9b ]

The irdma_copy_user_pgaddrs function loops through all of the umem DMA
blocks to populate the PBLEs and will stop when either the last DMA
block is reached or palloc->total_cnt is reached. The issue is that
the logic for checking palloc->total_cnt would only work for non-zero
values.

When irdma_setup_pbles is called with lvl==0, it
calls irdma_copy_user_pgaddrs with palloc->total_cnt==0, which means
the only way to break out of the loop is to reach the last umem DMA
block, which means it could end up going beyond the fixed size of 4
iwmr->pgaddrmem array that is used in the lvl==0 case.

In the case of QP/CQ/SRQ rings, the value of lvl is determined by a
separate input (for example, req.cq_pages in the case of a CQ). So,
we must perform explicit checking to ensure we don't overflow the
pgaddrmem array if the user provides a umem that consists of more
blocks than their provided req.cq_pages.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Link: https://patch.msgid.link/r/20260512183852.614045-1-jmoroni@google.com
Signed-off-by: Jacob Moroni <jmoroni@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 8cd4275328052e..661f2e0299ef7d 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2781,10 +2781,11 @@ static inline u64 *irdma_next_pbl_addr(u64 *pbl, struct irdma_pble_info **pinfo,
  * irdma_copy_user_pgaddrs - copy user page address to pble's os locally
  * @iwmr: iwmr for IB's user page addresses
  * @pbl: ple pointer to save 1 level or 0 level pble
+ * @pbl_len: Max number of PBL entries to populate
  * @level: indicated level 0, 1 or 2
  */
 static void irdma_copy_user_pgaddrs(struct irdma_mr *iwmr, u64 *pbl,
-				    enum irdma_pble_level level)
+				    u32 pbl_len, enum irdma_pble_level level)
 {
 	struct ib_umem *region = iwmr->region;
 	struct irdma_pbl *iwpbl = &iwmr->iwpbl;
@@ -2792,7 +2793,9 @@ static void irdma_copy_user_pgaddrs(struct irdma_mr *iwmr, u64 *pbl,
 	struct irdma_pble_info *pinfo;
 	struct ib_block_iter biter;
 	u32 idx = 0;
-	u32 pbl_cnt = 0;
+
+	if (!pbl_len)
+		return;
 
 	pinfo = (level == PBLE_LEVEL_1) ? NULL : palloc->level2.leaf;
 
@@ -2801,7 +2804,7 @@ static void irdma_copy_user_pgaddrs(struct irdma_mr *iwmr, u64 *pbl,
 
 	rdma_umem_for_each_dma_block(region, &biter, iwmr->page_size) {
 		*pbl = rdma_block_iter_dma_address(&biter);
-		if (++pbl_cnt == palloc->total_cnt)
+		if (!--pbl_len)
 			break;
 		pbl = irdma_next_pbl_addr(pbl, &pinfo, &idx);
 	}
@@ -2877,6 +2880,7 @@ static int irdma_setup_pbles(struct irdma_pci_f *rf, struct irdma_mr *iwmr,
 	u64 *pbl;
 	int status;
 	enum irdma_pble_level level = PBLE_LEVEL_1;
+	u32 pbl_len;
 
 	if (lvl) {
 		status = irdma_get_pble(rf->pble_rsrc, palloc, iwmr->page_cnt,
@@ -2884,16 +2888,18 @@ static int irdma_setup_pbles(struct irdma_pci_f *rf, struct irdma_mr *iwmr,
 		if (status)
 			return status;
 
+		pbl_len = palloc->total_cnt;
 		iwpbl->pbl_allocated = true;
 		level = palloc->level;
 		pinfo = (level == PBLE_LEVEL_1) ? &palloc->level1 :
 						  palloc->level2.leaf;
 		pbl = pinfo->addr;
 	} else {
+		pbl_len = IRDMA_MAX_SAVED_PHY_PGADDR;
 		pbl = iwmr->pgaddrmem;
 	}
 
-	irdma_copy_user_pgaddrs(iwmr, pbl, level);
+	irdma_copy_user_pgaddrs(iwmr, pbl, pbl_len, level);
 
 	if (lvl)
 		iwmr->pgaddrmem[0] = *pbl;
-- 
2.53.0



