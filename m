Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381AD2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:35:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E23FC433EF;
	Wed, 12 Apr 2023 08:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288529;
	bh=ju/phb9Tili4DIEqsqtxvNNopKuJX9yrO1bT4S+g86M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=csedh01mV17QSqp1rrFwNHC7EdF1qZl4Db3JPbntb0ssePwF1Z/2kT9nfos2HimXb
	 sjWhIliknArerAtc0dONgSuzeixFZLO7kqXmFonE3ezJfAXpCG+6yZmIBLCRliDJbX
	 WFIDMLznuBkuskiIFLb4PAOu/WuCAIb+GialCJTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mustafa Ismail <mustafa.ismail@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 13/93] RDMA/irdma: Do not request 2-level PBLEs for CQ alloc
Date: Wed, 12 Apr 2023 10:33:14 +0200
Message-Id: <20230412082823.597062982@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mustafa Ismail <mustafa.ismail@intel.com>

[ Upstream commit 8f7e2daa6336f9f4b6f8a4715a809674606df16b ]

When allocating PBLE's for a large CQ, it is possible
that a 2-level PBLE is returned which would cause the
CQ allocation to fail since 1-level is assumed and checked for.
Fix this by requesting a level one PBLE only.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Link: https://lore.kernel.org/r/20221115011701.1379-4-shiraz.saleem@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index c5971a840b876..27f22d595a5dc 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2272,9 +2272,10 @@ static bool irdma_check_mr_contiguous(struct irdma_pble_alloc *palloc,
  * @rf: RDMA PCI function
  * @iwmr: mr pointer for this memory registration
  * @use_pbles: flag if to use pble's
+ * @lvl_1_only: request only level 1 pble if true
  */
 static int irdma_setup_pbles(struct irdma_pci_f *rf, struct irdma_mr *iwmr,
-			     bool use_pbles)
+			     bool use_pbles, bool lvl_1_only)
 {
 	struct irdma_pbl *iwpbl = &iwmr->iwpbl;
 	struct irdma_pble_alloc *palloc = &iwpbl->pble_alloc;
@@ -2285,7 +2286,7 @@ static int irdma_setup_pbles(struct irdma_pci_f *rf, struct irdma_mr *iwmr,
 
 	if (use_pbles) {
 		status = irdma_get_pble(rf->pble_rsrc, palloc, iwmr->page_cnt,
-					false);
+					lvl_1_only);
 		if (status)
 			return -ENOMEM;
 
@@ -2328,16 +2329,10 @@ static int irdma_handle_q_mem(struct irdma_device *iwdev,
 	bool ret = true;
 
 	pg_size = iwmr->page_size;
-	err = irdma_setup_pbles(iwdev->rf, iwmr, use_pbles);
+	err = irdma_setup_pbles(iwdev->rf, iwmr, use_pbles, true);
 	if (err)
 		return err;
 
-	if (use_pbles && palloc->level != PBLE_LEVEL_1) {
-		irdma_free_pble(iwdev->rf->pble_rsrc, palloc);
-		iwpbl->pbl_allocated = false;
-		return -ENOMEM;
-	}
-
 	if (use_pbles)
 		arr = palloc->level1.addr;
 
@@ -2808,7 +2803,7 @@ static struct ib_mr *irdma_reg_user_mr(struct ib_pd *pd, u64 start, u64 len,
 	case IRDMA_MEMREG_TYPE_MEM:
 		use_pbles = (iwmr->page_cnt != 1);
 
-		err = irdma_setup_pbles(iwdev->rf, iwmr, use_pbles);
+		err = irdma_setup_pbles(iwdev->rf, iwmr, use_pbles, false);
 		if (err)
 			goto error;
 
-- 
2.39.2



