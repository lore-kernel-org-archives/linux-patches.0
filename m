Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64783B6349;
	Wed, 20 May 2026 16:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296124; cv=none; b=fXaSUZVt6x2C4L2dEZXBjcbdQGTuOXMALd0rok0ZtMsC21gHeaS8BThgkorFyTirC6vuz00L6WXs3PDAJbJLYFSfhA3f6JxsSo4NH68gHNiRZ5PeQVWq6QUVTvnx5zfMqUyQ9rvySK1Zk674BrjKTsRFeaHvlskn9UQkr154jQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296124; c=relaxed/simple;
	bh=rO5kWmK9x+XOlXzRod0zphxhXMm1MFOITt4O9OmXXTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uv8xgHBIGeT6U7N3yinQaYP9qfvZrSpBwXfUY1fi3ByKdPZPqv/lcc5g+qVBJJRTioqp3PgW7j3ipw6Mw2uDLoO2M+DsaJt5ABU6HSHpFhAsYKAoQKBFhU+EmA20HV18IRzZPXIYYY8bLDti8ePcyT0krEy4iXqZ5wQ7k+XRcRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vb7FrWDB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vb7FrWDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A961F000E9;
	Wed, 20 May 2026 16:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296123;
	bh=Yp+YdY+g2kWstYCMQvX8zFHiJb+jTVFQattAwMCo8YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vb7FrWDB6fUvV8PPwaAtcrdEHuAzCV3cyLxl9w8TTjx5dP5tWq1dIQi/EzRj+pI0b
	 KGtsOvdHG7V1rnrrFYMoDqW00PIY8lt6nNK6CWlLhVCPsduJ7raufHwYtYpHAkjZaD
	 VCpXZPwcvoUFZZ6K+Z6VPsk3wwHIkvaqDn53bySc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0679/1146] RDMA/umem: Use consistent DMA attributes when unmapping entries
Date: Wed, 20 May 2026 18:15:29 +0200
Message-ID: <20260520162203.553861851@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 179b32095854d44749dd535502f05d95bbf43775 ]

The DMA API expects that mapping and unmapping use the same DMA
attributes. The RDMA umem code did not meet this requirement, so fix
the mismatch.

Fixes: f03d9fadfe13 ("RDMA/core: Add weak ordering dma attr to dma mapping")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/umem.c | 13 ++++++-------
 include/rdma/ib_umem.h         |  1 +
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index edc34c69f0f23..acf4ce2891b76 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -55,8 +55,7 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
 
 	if (dirty)
 		ib_dma_unmap_sgtable_attrs(dev, &umem->sgt_append.sgt,
-					   DMA_BIDIRECTIONAL,
-					   DMA_ATTR_REQUIRE_COHERENT);
+					   DMA_BIDIRECTIONAL, umem->dma_attrs);
 
 	for_each_sgtable_sg(&umem->sgt_append.sgt, sg, i) {
 		unpin_user_page_range_dirty_lock(sg_page(sg),
@@ -170,7 +169,6 @@ struct ib_umem *ib_umem_get(struct ib_device *device, unsigned long addr,
 	unsigned long lock_limit;
 	unsigned long new_pinned;
 	unsigned long cur_base;
-	unsigned long dma_attr = DMA_ATTR_REQUIRE_COHERENT;
 	struct mm_struct *mm;
 	unsigned long npages;
 	int pinned, ret;
@@ -203,6 +201,10 @@ struct ib_umem *ib_umem_get(struct ib_device *device, unsigned long addr,
 	umem->iova = addr;
 	umem->writable   = ib_access_writable(access);
 	umem->owning_mm = mm = current->mm;
+	umem->dma_attrs = DMA_ATTR_REQUIRE_COHERENT;
+	if (access & IB_ACCESS_RELAXED_ORDERING)
+		umem->dma_attrs |= DMA_ATTR_WEAK_ORDERING;
+
 	mmgrab(mm);
 
 	page_list = (struct page **) __get_free_page(GFP_KERNEL);
@@ -255,11 +257,8 @@ struct ib_umem *ib_umem_get(struct ib_device *device, unsigned long addr,
 		}
 	}
 
-	if (access & IB_ACCESS_RELAXED_ORDERING)
-		dma_attr |= DMA_ATTR_WEAK_ORDERING;
-
 	ret = ib_dma_map_sgtable_attrs(device, &umem->sgt_append.sgt,
-				       DMA_BIDIRECTIONAL, dma_attr);
+				       DMA_BIDIRECTIONAL, umem->dma_attrs);
 	if (ret)
 		goto umem_release;
 	goto out;
diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index 0a8e092c0ea87..e426d451b8932 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -22,6 +22,7 @@ struct ib_umem {
 	u64 iova;
 	size_t			length;
 	unsigned long		address;
+	unsigned long		dma_attrs;
 	u32 writable : 1;
 	u32 is_odp : 1;
 	u32 is_dmabuf : 1;
-- 
2.53.0



