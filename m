Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216700;
	b=En01oijNmOtsCfpgEZBal0zffTqfoGXP1YADhAwSXBl+uBW4O5wQ1eB7HjVYOu8kjYeA
	 W29SqfimWR+pdxZOcpShc+CYsm3bG/nT7jVCR4JwmuEq+3FOK4JGg27x9+fgEN5wDjiqW
	 IF1E5dO7PP3jY/DSdz/819MlbYpdOzDRq3aRbUBAC1D8OL0gnwXbs81982NjnzmI7q1TS
	 rbrxPz6URPawZW084/0QD2g2fhFmER6ADdyk7k/gp/EkiPs0TwtcvF2gsn8PE98aPtfDZ
	 kkdknFrlsukn4pGUOGIu9q0doPtN4RpiITBM/uacB6kpR4rYWBTmZzwBvzTafC9btgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216700;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zyy+okyXg/L5VCa2SELqMER2s5hUov30Jlg1PnoaHNo=;
	b=Yu2jFxTZ4Qpa11OWnvibsx11B4Et9fxE8y9WeRJ0MstKEF7xk+hqZ55mdZZjGeyIXC/C
	 s4qenB2SRzVRdeuvdQPeIpIJ1ACrmbLZISH6a6KY4Yz0ouXWqpk9VRfVyojVog8wAOBkU
	 W3VGx9SveRO/kCh/a3vkrqvd6VHp4StQC+SPyJeLitM78bpPnshda4Dfy/RoEvVNZOxuw
	 8KW6oWeoFFABqQY0t3udQo65ojOul1uMigagjd04zUuetMvSSQ3HFVrrwY6sVfrdZu/Ha
	 mhzA+PPc1cvnLTOZtD6ZwQz+ouRPWYDgyTuwCPSReJxBfcVSWiWq/ObUxXzHEtU/diA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FQPNMutD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF82E606A31A;
	Wed, 28 Oct 2026 19:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FQPNMutD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3051F01825;
	Wed, 28 Oct 2026 19:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216699;
	bh=Zyy+okyXg/L5VCa2SELqMER2s5hUov30Jlg1PnoaHNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FQPNMutDis2R9P0HBAGeko3sYVRzodTWwtIuzOPLEF8qU+RcQ2uNxJGGDC3dHAKV0
	 eHq52g/gQ8HskYpOuhTKjaXZOBcZz7VGtxF1dOuPFZQwh2QulUY/Yl/ri42UgGBksT
	 SNrNrMwFUmxUfvzquM4uRrpMumgBp141gTmx53jA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1605/1887] RDMA/cxgb4: Fix dereg_skb leak and double free in write_tpt_entry()
Date: Wed, 28 Oct 2026 18:01:41 +0100
Message-ID: <20261028170535.992833396@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9c24789bbb54b..9ed43d23c1835 100644
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
@@ -280,12 +263,16 @@ static int write_tpt_entry(struct c4iw_rdev *rdev, u32 reset_tpt_entry,
 	bool stag_idx_allocated = false;
 	static atomic_t key;
 
-	if (c4iw_fatal_error(rdev))
+	if (c4iw_fatal_error(rdev)) {
+		kfree_skb(skb);
 		return -EIO;
+	}
 
 	tpt = kmalloc(sizeof(*tpt), GFP_KERNEL);
-	if (!tpt)
+	if (!tpt) {
+		kfree_skb(skb);
 		return -ENOMEM;
+	}
 
 	stag_state = stag_state > 0;
 	stag_idx = (*stag) >> 8;
@@ -297,6 +284,7 @@ static int write_tpt_entry(struct c4iw_rdev *rdev, u32 reset_tpt_entry,
 			rdev->stats.stag.fail++;
 			mutex_unlock(&rdev->stats.lock);
 			kfree(tpt);
+			kfree_skb(skb);
 			return -ENOMEM;
 		}
 		mutex_lock(&rdev->stats.lock);
@@ -471,8 +459,10 @@ struct ib_mr *c4iw_get_dma_mr(struct ib_pd *pd, int acc)
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
@@ -481,8 +471,6 @@ struct ib_mr *c4iw_get_dma_mr(struct ib_pd *pd, int acc)
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



