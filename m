Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0FD3783D4;
	Tue, 21 Jul 2026 20:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665765; cv=none; b=U5PP+vG2hxWl77y8oxd3+FoLgVuLEIOVWntDAzVvjnz4LYKM50BalvtUMD0JVu2ITkfAWdSeJFvIC4X/JuKrvWAXZJxaEkasc7Lc+zi0Hr9SSkZ1wRksEjAI4okm0Jmpp6VJ+puzEP1r9lSZgNZSAghXuJ3vVTpcEz26X8jMHv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665765; c=relaxed/simple;
	bh=ql1RIa34lRQggwk50sqfxs5v7Q0EcP2ng/fEWgioHW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kDA/uVyOMM+rAATsjm8mncwDWhWah7y86SQI9bxB6Ry/Ugnwb0kK1ULaVIzI5kB5v6+5IafsEI+F1iXQE+nmQzatfLz+j5cmEZrf5B8fZPcztGy6TbKJDJZGMTKhudC8DpF9nIJWhv30n9bR6oaM7QVtQNRkuW7y59DQePtC8wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JnWqiLw+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JnWqiLw+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BBBA1F000E9;
	Tue, 21 Jul 2026 20:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665763;
	bh=rO1yaC5PzNlxM6mNvWgUkXxZh+vy79vNxLoNxdQz29A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JnWqiLw++BvO8SdD6xAyNlB1OLRKtntV1EItJynmFu0+PGDqfzzagxNKDvS+hrgT/
	 RD4s0NeVseChjQv2h+e2zV9XLFMjXrqalRpPFpRHH8zMaw/eQtnxuOITN4ROzhxbes
	 HCsSjjSQgOpCOURav4I4yUZcV1wYPPaaqfmNj37U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0428/1266] RDMA/irdma: Fix out-of-bounds write in irdma_copy_user_pgaddrs
Date: Tue, 21 Jul 2026 17:14:25 +0200
Message-ID: <20260721152451.418170765@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2358fab95784b0..91d5b1b0d6b1b2 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2326,10 +2326,11 @@ static inline u64 *irdma_next_pbl_addr(u64 *pbl, struct irdma_pble_info **pinfo,
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
@@ -2337,7 +2338,9 @@ static void irdma_copy_user_pgaddrs(struct irdma_mr *iwmr, u64 *pbl,
 	struct irdma_pble_info *pinfo;
 	struct ib_block_iter biter;
 	u32 idx = 0;
-	u32 pbl_cnt = 0;
+
+	if (!pbl_len)
+		return;
 
 	pinfo = (level == PBLE_LEVEL_1) ? NULL : palloc->level2.leaf;
 
@@ -2346,7 +2349,7 @@ static void irdma_copy_user_pgaddrs(struct irdma_mr *iwmr, u64 *pbl,
 
 	rdma_umem_for_each_dma_block(region, &biter, iwmr->page_size) {
 		*pbl = rdma_block_iter_dma_address(&biter);
-		if (++pbl_cnt == palloc->total_cnt)
+		if (!--pbl_len)
 			break;
 		pbl = irdma_next_pbl_addr(pbl, &pinfo, &idx);
 	}
@@ -2422,6 +2425,7 @@ static int irdma_setup_pbles(struct irdma_pci_f *rf, struct irdma_mr *iwmr,
 	u64 *pbl;
 	int status;
 	enum irdma_pble_level level = PBLE_LEVEL_1;
+	u32 pbl_len;
 
 	if (lvl) {
 		status = irdma_get_pble(rf->pble_rsrc, palloc, iwmr->page_cnt,
@@ -2429,16 +2433,18 @@ static int irdma_setup_pbles(struct irdma_pci_f *rf, struct irdma_mr *iwmr,
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



