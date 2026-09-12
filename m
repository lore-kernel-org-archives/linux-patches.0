Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC8B349CD7;
	Sat, 12 Sep 2026 08:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200366; cv=none; b=pJSHv/WPpGQ4BakXIstdLb/V3fCvykNbMZExJIVQ63mag1QR8vsQMdJIYX3nPTAusVqX7qk/CxY0elkgoHWlCigSU8Q5fD1htbJWFR5GRdS1FdtzOXISO2TAhdduKgkFnD40f0Lp1U70sDpI7NxBa5icDZ3LEmF12+H6KQSkriM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200366; c=relaxed/simple;
	bh=H9zpKq+ZXppDEcHb3L1eq37hEHNnRpqPrTaO25GhTEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZY9FuVwBq+q677CGpaDS1uqA8mT9y49wZzC0ANtggHUs2xP2mWR5EBg6h/YZ8WLfItr6zt0ve34V3kt0qidID0MUFVBYDERQYPzup3fWLsWvqMOBwQbz3sJ12oiQy4YLGb2uqZRaceuqJf0+L+Omum83IXZu2E5smrdwkmDWGPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uiHP+hYA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uiHP+hYA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4FB1F00893;
	Sat, 12 Sep 2026 08:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200364;
	bh=MmEMlZfurkgJpnmGW9aih+ypUOGoEWgIZf570/LH91c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uiHP+hYAABrEC2Sbv/qxBorvXLSqy0tzRmKmKXPg0qUfGgLBI2oS76L1LdT3AelPs
	 RD8P6uhFY9S+no3RnGAoaIh3iwSCzMG+Zn1ssYxzLdRc+65jdob45gwIuBBh8GpeGi
	 Rkmb5bd2Helff5EPEVMmMUkV56BlNQulyYF1Vhlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0732/1815] RDMA/cxgb4: Fix dereg_skb leak and double free in write_tpt_entry()
Date: Sat, 12 Sep 2026 08:41:22 +0200
Message-ID: <20260912065706.084903387@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 373f3716a2de7adc739269ebb4d87e5bf4dc180c ]

When the device is in the fatal error state, write_tpt_entry() returns -EIO
before handing the caller's preallocated skb to the transmit path; its
allocation-failure returns do the same. c4iw_dereg_mr() ignores the error
and frees mhp, leaking mhp->dereg_skb. c4iw_get_dma_mr() instead frees the
skb a second time after dereg_mem() already consumed it, a double free.

Make write_tpt_entry() the sole owner of a non-NULL skb, freeing it on
every return preceding handoff to c4iw_ofld_send(): fatal error, tpt and
stag allocation failure. c4iw_ofld_send() consumes the skb on success and
error alike, so drop the redundant kfree_skb() in c4iw_get_dma_mr() after
dereg_mem().

Fixes: 0f8ab0b6e91b ("RDMA/iw_cxgb4: Low resource fixes for Memory registration")
Link: https://patch.msgid.link/20260726-leaked-mhp-dereg-skb-in-c4iw-dereg-m-v1-1-ebd6df364d53@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/mem.c | 46 ++++++++++++-------------------
 1 file changed, 17 insertions(+), 29 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index cd1b010141984..76220e57eef87 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -199,7 +199,8 @@ static int _c4iw_write_mem_dma(struct c4iw_rdev *rdev, u32 addr, u32 len,
 
 	daddr = dma_map_single(&rdev->lldi.pdev->dev, data, len, DMA_TO_DEVICE);
 	if (dma_mapping_error(&rdev->lldi.pdev->dev, daddr))
-		return -1;
+		return _c4iw_write_mem_inline(rdev, addr, len, data, skb,
+					      wr_waitp);
 	save = daddr;
 
 	while (remain > inline_threshold) {
@@ -235,30 +236,12 @@ static int write_adapter_mem(struct c4iw_rdev *rdev, u32 addr, u32 len,
 			     void *data, struct sk_buff *skb,
 			     struct c4iw_wr_wait *wr_waitp)
 {
-	int ret;
-
-	if (!rdev->lldi.ulptx_memwrite_dsgl || !use_dsgl) {
-		ret = _c4iw_write_mem_inline(rdev, addr, len, data, skb,
-					      wr_waitp);
-		goto out;
-	}
-
-	if (len <= inline_threshold) {
-		ret = _c4iw_write_mem_inline(rdev, addr, len, data, skb,
+	if (!rdev->lldi.ulptx_memwrite_dsgl || !use_dsgl ||
+	    len <= inline_threshold)
+		return _c4iw_write_mem_inline(rdev, addr, len, data, skb,
 					      wr_waitp);
-		goto out;
-	}
-
-	ret = _c4iw_write_mem_dma(rdev, addr, len, data, skb, wr_waitp);
-	if (ret) {
-		pr_warn_ratelimited("%s: dma map failure (non fatal)\n",
-				    pci_name(rdev->lldi.pdev));
-		ret = _c4iw_write_mem_inline(rdev, addr, len, data, skb,
-					      wr_waitp);
-	}
-out:
-	return ret;
 
+	return _c4iw_write_mem_dma(rdev, addr, len, data, skb, wr_waitp);
 }
 
 /*
@@ -279,12 +262,16 @@ static int write_tpt_entry(struct c4iw_rdev *rdev, u32 reset_tpt_entry,
 	u32 stag_idx;
 	static atomic_t key;
 
-	if (c4iw_fatal_error(rdev))
+	if (c4iw_fatal_error(rdev)) {
+		kfree_skb(skb);
 		return -EIO;
+	}
 
 	tpt = kmalloc_obj(*tpt);
-	if (!tpt)
+	if (!tpt) {
+		kfree_skb(skb);
 		return -ENOMEM;
+	}
 
 	stag_state = stag_state > 0;
 	stag_idx = (*stag) >> 8;
@@ -296,6 +283,7 @@ static int write_tpt_entry(struct c4iw_rdev *rdev, u32 reset_tpt_entry,
 			rdev->stats.stag.fail++;
 			mutex_unlock(&rdev->stats.lock);
 			kfree(tpt);
+			kfree_skb(skb);
 			return -ENOMEM;
 		}
 		mutex_lock(&rdev->stats.lock);
@@ -469,8 +457,10 @@ struct ib_mr *c4iw_get_dma_mr(struct ib_pd *pd, int acc)
 			      FW_RI_STAG_NSMR, mhp->attr.perms,
 			      mhp->attr.mw_bind_enable, 0, 0, ~0ULL, 0, 0, 0,
 			      NULL, mhp->wr_waitp);
-	if (ret)
-		goto err_free_skb;
+	if (ret) {
+		kfree_skb(mhp->dereg_skb);
+		goto err_free_wr_wait;
+	}
 
 	ret = finish_mem_reg(mhp, stag);
 	if (ret)
@@ -479,8 +469,6 @@ struct ib_mr *c4iw_get_dma_mr(struct ib_pd *pd, int acc)
 err_dereg_mem:
 	dereg_mem(&rhp->rdev, mhp->attr.stag, mhp->attr.pbl_size,
 		  mhp->attr.pbl_addr, mhp->dereg_skb, mhp->wr_waitp);
-err_free_skb:
-	kfree_skb(mhp->dereg_skb);
 err_free_wr_wait:
 	c4iw_put_wr_wait(mhp->wr_waitp);
 err_free_mhp:
-- 
2.53.0



