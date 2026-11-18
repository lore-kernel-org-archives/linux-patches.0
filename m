Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040441;
	b=Q30vJOnnRndDXlTCiIjLO+j+zNOveGyIHro20yVYjkf4gsBHKNRLLKjIXQ+AsWCEgjch
	 2av4zutThaWoAGcKfT7IyHnFVJzcTpLQBNzOOYLbqMjrh7D13gAeyLn3UJxoAfnQzURVN
	 slHo04fLcITTURIAJ0B0WpzXNLDvwLsh1vR4nUk+7HabGGXxTEMKvpYxNiNyOjNp+Yo4C
	 jnDUm7MrPxCGpA+BKw7uA1ZZKB0NCkRWRNXIR2sPwZjx1fCc8+2cm9y9AIikdnhcX30x2
	 MvlXAIEDnfoOsrJswQeGE4QuNLoQhv6kPSz+2nMQL+fAZ2kLu8s8Na4T3t+ZrzPBz+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040441;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kci84AZmduGmRUGeFUEUvMPTWF9UNCbJQXG7H4KSfN0=;
	b=QeblXZPQidjuCAOj5k6awts4b9HrRDM6iL2ab/uKUwNJYMka31/VTzX8gSIKqLbT33IC
	 vlg35cIm/ll0pVCb7fjI0otb+LOE3YNvXS3Bi4b7KANsgTgegxZJa25NjAUwLWqqIn7Ia
	 wJP+mx6al6YjOhkeY9Q3WJqFgM/9xdZURj84wineCNiD7eaRLiwiL9PwHFTX8/7n0phSx
	 QmrgEvCLzuk5SgSCrdRajZgxBekaJ0wb211jVAiLfeS/dtU1OAJGf6pQg8mAqfI4CBcjI
	 aGYm+0DOO12NMO1q1E1Jte7lU6ovpj1suurIhySxyjctztY6BMAsFBUiZYcyrUmNa9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ru6j+RAC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B2D606A31C;
	Wed, 18 Nov 2026 22:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ru6j+RAC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B397F1F000C4;
	Wed, 18 Nov 2026 22:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040441;
	bh=kci84AZmduGmRUGeFUEUvMPTWF9UNCbJQXG7H4KSfN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ru6j+RACY4dw1cJrd5rW0C/mq1pOWnxXUz4PtRm6e58H2cARPSFbfgjaUZrH5cvvm
	 SGL3H2mvWUyLYDBbEK+rue9JEwhJcNDbnHDAGzJk0Prf8JnzcUvHZBwq07jtKDBgzK
	 ez269vPq/P3Tack98opz09ZklTI9roulwOTAz8JI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anumula Murali Mohan Reddy <anumula@chelsio.com>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2459/3318] RDMA/cxgb4: use dma_mmap_coherent() for mapping non-contiguous memory
Date: Wed, 18 Nov 2026 15:51:21 +0100
Message-ID: <20261118150435.200884378@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anumula Murali Mohan Reddy <anumula@chelsio.com>

[ Upstream commit 75ab1533d79b046152d424ffe947f79f9d15682c ]

dma_alloc_coherent() allocates contiguous memory irrespective of
iommu mode, but after commit f5ff79fddf0e ("dma-mapping: remove CONFIG_DMA_REMAP")
if iommu is enabled in translate mode, dma_alloc_coherent() may
allocate non-contiguous memory. Attempt to map this memory results in panic.
This patch fixes the issue by using dma_mmap_coherent() to map each page
to user space.

Signed-off-by: Anumula Murali Mohan Reddy <anumula@chelsio.com>
Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
Link: https://lore.kernel.org/r/20240716142532.97423-1-anumula@chelsio.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 1c5335a69026 ("RDMA/cxgb4: Do not allow userspace to write the status page")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/cq.c       |  8 ++-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h | 36 ++++++++++++++
 drivers/infiniband/hw/cxgb4/provider.c | 67 +++++++++++++-------------
 drivers/infiniband/hw/cxgb4/qp.c       | 32 ++++++++++--
 4 files changed, 105 insertions(+), 38 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index 7e2835dcbc1c6..b66d311bd97aa 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -1125,13 +1125,19 @@ int c4iw_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 			goto err_free_mm2;
 
 		mm->key = uresp.key;
-		mm->addr = virt_to_phys(chp->cq.queue);
+		mm->addr = 0;
+		mm->vaddr = chp->cq.queue;
+		mm->dma_addr = chp->cq.dma_addr;
 		mm->len = chp->cq.memsize;
+		insert_flag_to_mmap(&rhp->rdev, mm, mm->addr);
 		insert_mmap(ucontext, mm);
 
 		mm2->key = uresp.gts_key;
 		mm2->addr = chp->cq.bar2_pa;
 		mm2->len = PAGE_SIZE;
+		mm2->vaddr = NULL;
+		mm2->dma_addr = 0;
+		insert_flag_to_mmap(&rhp->rdev, mm2, mm2->addr);
 		insert_mmap(ucontext, mm2);
 	}
 
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 50cb2259bf874..a0529a045a4b6 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -532,11 +532,21 @@ static inline struct c4iw_ucontext *to_c4iw_ucontext(struct ib_ucontext *c)
 	return container_of(c, struct c4iw_ucontext, ibucontext);
 }
 
+enum {
+	CXGB4_MMAP_BAR,
+	CXGB4_MMAP_BAR_WC,
+	CXGB4_MMAP_CONTIG,
+	CXGB4_MMAP_NON_CONTIG,
+};
+
 struct c4iw_mm_entry {
 	struct list_head entry;
 	u64 addr;
 	u32 key;
+	void *vaddr;
+	dma_addr_t dma_addr;
 	unsigned len;
+	u8 mmap_flag;
 };
 
 static inline struct c4iw_mm_entry *remove_mmap(struct c4iw_ucontext *ucontext,
@@ -561,6 +571,32 @@ static inline struct c4iw_mm_entry *remove_mmap(struct c4iw_ucontext *ucontext,
 	return NULL;
 }
 
+static inline void insert_flag_to_mmap(struct c4iw_rdev *rdev,
+				       struct c4iw_mm_entry *mm, u64 addr)
+{
+	if (addr >= pci_resource_start(rdev->lldi.pdev, 0) &&
+	    (addr < (pci_resource_start(rdev->lldi.pdev, 0) +
+		    pci_resource_len(rdev->lldi.pdev, 0))))
+		mm->mmap_flag = CXGB4_MMAP_BAR;
+	else if (addr >= pci_resource_start(rdev->lldi.pdev, 2) &&
+		 (addr < (pci_resource_start(rdev->lldi.pdev, 2) +
+			 pci_resource_len(rdev->lldi.pdev, 2)))) {
+		if (addr >= rdev->oc_mw_pa) {
+			mm->mmap_flag = CXGB4_MMAP_BAR_WC;
+		} else {
+			if (is_t4(rdev->lldi.adapter_type))
+				mm->mmap_flag = CXGB4_MMAP_BAR;
+			else
+				mm->mmap_flag = CXGB4_MMAP_BAR_WC;
+		}
+	} else {
+		if (addr)
+			mm->mmap_flag = CXGB4_MMAP_CONTIG;
+		else
+			mm->mmap_flag = CXGB4_MMAP_NON_CONTIG;
+	}
+}
+
 static inline void insert_mmap(struct c4iw_ucontext *ucontext,
 			       struct c4iw_mm_entry *mm)
 {
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index 9008584946c62..e059f92d90fd4 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -113,6 +113,9 @@ static int c4iw_alloc_ucontext(struct ib_ucontext *ucontext,
 		mm->key = uresp.status_page_key;
 		mm->addr = virt_to_phys(rhp->rdev.status_page);
 		mm->len = PAGE_SIZE;
+		mm->vaddr = NULL;
+		mm->dma_addr = 0;
+		insert_flag_to_mmap(&rhp->rdev, mm, mm->addr);
 		insert_mmap(context, mm);
 	}
 	return 0;
@@ -131,6 +134,11 @@ static int c4iw_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 	struct c4iw_mm_entry *mm;
 	struct c4iw_ucontext *ucontext;
 	u64 addr;
+	u8 mmap_flag;
+	size_t size;
+	void *vaddr;
+	unsigned long vm_pgoff;
+	dma_addr_t dma_addr;
 
 	pr_debug("pgoff 0x%lx key 0x%x len %d\n", vma->vm_pgoff,
 		 key, len);
@@ -145,47 +153,38 @@ static int c4iw_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 	if (!mm)
 		return -EINVAL;
 	addr = mm->addr;
+	vaddr = mm->vaddr;
+	dma_addr = mm->dma_addr;
+	size = mm->len;
+	mmap_flag = mm->mmap_flag;
 	kfree(mm);
 
-	if ((addr >= pci_resource_start(rdev->lldi.pdev, 0)) &&
-	    (addr < (pci_resource_start(rdev->lldi.pdev, 0) +
-		    pci_resource_len(rdev->lldi.pdev, 0)))) {
-
-		/*
-		 * MA_SYNC register...
-		 */
-		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	switch (mmap_flag) {
+	case CXGB4_MMAP_BAR:
+		ret = io_remap_pfn_range(vma, vma->vm_start, addr >> PAGE_SHIFT,
+					 len,
+					 pgprot_noncached(vma->vm_page_prot));
+		break;
+	case CXGB4_MMAP_BAR_WC:
 		ret = io_remap_pfn_range(vma, vma->vm_start,
 					 addr >> PAGE_SHIFT,
-					 len, vma->vm_page_prot);
-	} else if ((addr >= pci_resource_start(rdev->lldi.pdev, 2)) &&
-		   (addr < (pci_resource_start(rdev->lldi.pdev, 2) +
-		    pci_resource_len(rdev->lldi.pdev, 2)))) {
-
-		/*
-		 * Map user DB or OCQP memory...
-		 */
-		if (addr >= rdev->oc_mw_pa)
-			vma->vm_page_prot = t4_pgprot_wc(vma->vm_page_prot);
-		else {
-			if (!is_t4(rdev->lldi.adapter_type))
-				vma->vm_page_prot =
-					t4_pgprot_wc(vma->vm_page_prot);
-			else
-				vma->vm_page_prot =
-					pgprot_noncached(vma->vm_page_prot);
-		}
+					 len, t4_pgprot_wc(vma->vm_page_prot));
+		break;
+	case CXGB4_MMAP_CONTIG:
 		ret = io_remap_pfn_range(vma, vma->vm_start,
 					 addr >> PAGE_SHIFT,
 					 len, vma->vm_page_prot);
-	} else {
-
-		/*
-		 * Map WQ or CQ contig dma memory...
-		 */
-		ret = remap_pfn_range(vma, vma->vm_start,
-				      addr >> PAGE_SHIFT,
-				      len, vma->vm_page_prot);
+		break;
+	case CXGB4_MMAP_NON_CONTIG:
+		vm_pgoff = vma->vm_pgoff;
+		vma->vm_pgoff = 0;
+		ret = dma_mmap_coherent(&rdev->lldi.pdev->dev, vma,
+					vaddr, dma_addr, size);
+		vma->vm_pgoff = vm_pgoff;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
 	}
 
 	return ret;
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index d16d8eaa14150..7b5c4522b426a 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -2281,24 +2281,39 @@ int c4iw_create_qp(struct ib_qp *qp, struct ib_qp_init_attr *attrs,
 		if (ret)
 			goto err_free_ma_sync_key;
 		sq_key_mm->key = uresp.sq_key;
-		sq_key_mm->addr = qhp->wq.sq.phys_addr;
+		sq_key_mm->addr = 0;
+		sq_key_mm->vaddr = qhp->wq.sq.queue;
+		sq_key_mm->dma_addr = qhp->wq.sq.dma_addr;
 		sq_key_mm->len = PAGE_ALIGN(qhp->wq.sq.memsize);
+		insert_flag_to_mmap(&rhp->rdev, sq_key_mm, sq_key_mm->addr);
 		insert_mmap(ucontext, sq_key_mm);
 		if (!attrs->srq) {
 			rq_key_mm->key = uresp.rq_key;
-			rq_key_mm->addr = virt_to_phys(qhp->wq.rq.queue);
+			rq_key_mm->addr = 0;
+			rq_key_mm->vaddr = qhp->wq.rq.queue;
+			rq_key_mm->dma_addr = qhp->wq.rq.dma_addr;
 			rq_key_mm->len = PAGE_ALIGN(qhp->wq.rq.memsize);
+			insert_flag_to_mmap(&rhp->rdev, rq_key_mm,
+					    rq_key_mm->addr);
 			insert_mmap(ucontext, rq_key_mm);
 		}
 		sq_db_key_mm->key = uresp.sq_db_gts_key;
 		sq_db_key_mm->addr = (u64)(unsigned long)qhp->wq.sq.bar2_pa;
+		sq_db_key_mm->vaddr = NULL;
+		sq_db_key_mm->dma_addr = 0;
 		sq_db_key_mm->len = PAGE_SIZE;
+		insert_flag_to_mmap(&rhp->rdev, sq_db_key_mm,
+				    sq_db_key_mm->addr);
 		insert_mmap(ucontext, sq_db_key_mm);
 		if (!attrs->srq) {
 			rq_db_key_mm->key = uresp.rq_db_gts_key;
 			rq_db_key_mm->addr =
 				(u64)(unsigned long)qhp->wq.rq.bar2_pa;
 			rq_db_key_mm->len = PAGE_SIZE;
+			rq_db_key_mm->vaddr = NULL;
+			rq_db_key_mm->dma_addr = 0;
+			insert_flag_to_mmap(&rhp->rdev, rq_db_key_mm,
+					    rq_db_key_mm->addr);
 			insert_mmap(ucontext, rq_db_key_mm);
 		}
 		if (ma_sync_key_mm) {
@@ -2307,6 +2322,10 @@ int c4iw_create_qp(struct ib_qp *qp, struct ib_qp_init_attr *attrs,
 				(pci_resource_start(rhp->rdev.lldi.pdev, 0) +
 				PCIE_MA_SYNC_A) & PAGE_MASK;
 			ma_sync_key_mm->len = PAGE_SIZE;
+			ma_sync_key_mm->vaddr = NULL;
+			ma_sync_key_mm->dma_addr = 0;
+			insert_flag_to_mmap(&rhp->rdev, ma_sync_key_mm,
+					    ma_sync_key_mm->addr);
 			insert_mmap(ucontext, ma_sync_key_mm);
 		}
 
@@ -2761,12 +2780,19 @@ int c4iw_create_srq(struct ib_srq *ib_srq, struct ib_srq_init_attr *attrs,
 		if (ret)
 			goto err_free_srq_db_key_mm;
 		srq_key_mm->key = uresp.srq_key;
-		srq_key_mm->addr = virt_to_phys(srq->wq.queue);
+		srq_key_mm->addr = 0;
 		srq_key_mm->len = PAGE_ALIGN(srq->wq.memsize);
+		srq_key_mm->vaddr = srq->wq.queue;
+		srq_key_mm->dma_addr = srq->wq.dma_addr;
+		insert_flag_to_mmap(&rhp->rdev, srq_key_mm, srq_key_mm->addr);
 		insert_mmap(ucontext, srq_key_mm);
 		srq_db_key_mm->key = uresp.srq_db_gts_key;
 		srq_db_key_mm->addr = (u64)(unsigned long)srq->wq.bar2_pa;
 		srq_db_key_mm->len = PAGE_SIZE;
+		srq_db_key_mm->vaddr = NULL;
+		srq_db_key_mm->dma_addr = 0;
+		insert_flag_to_mmap(&rhp->rdev, srq_db_key_mm,
+				    srq_db_key_mm->addr);
 		insert_mmap(ucontext, srq_db_key_mm);
 	}
 
-- 
2.53.0



