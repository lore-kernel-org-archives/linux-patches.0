Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BD5364028;
	Wed, 30 Sep 2026 16:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784447; cv=none; b=cF+kYP4PTukqwHWAUlpIg81BZnGqq1sYAcUI9MkFODmCdQYwr8cTIUD+MBHDXVGytqF+m7g9MB5ufop9ZsjjyksABf3MdvIJBaby8xUOfvouLhunJLO7kDB4+L3U3vtyr1esl/y2/lPumfMj1TN958hR/3ya9cTL7ZcL+Ps8CYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784447; c=relaxed/simple;
	bh=t2YVOPLcrEAdIKhAzs2VyZgJ6peaoT2OdE8/tTbUd7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQeIgUtES+F8t0GJbOHGv4l7w1BF5F4LbpdICGXxW4PnvcZqNGDcmQmyseRyicxs4jTKMEuGOV31utdfzoWupwb8h7PEgUZrFhadzCRGrOC/Pu/bJS1MYDzO8wKmvvuDJtKKmIxE9iptO1WdSjOnm15C7RvAm9dMXZLvs9YqFZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bJ7mSfyN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJ7mSfyN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E011F000FF;
	Wed, 30 Sep 2026 16:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784442;
	bh=XDwoHJTyNrvSjj+75Tk9F6PxCkpHdEw5oMh94K4Ui9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bJ7mSfyNs07Q24XiNcc69TJQwYwyMKDqvUwKbeLF1R3Ox+pzRtN+URTMxU8mz9cc3
	 bQUUKb4fklhuFHh1HdR9nCMH1MdY+4ta2y+E0PnTomtk8/gJ/rdT33WjVIQnrLFiXA
	 Fd8pAuUo0UTLao3D1S4M69rMF/fn3/GGvu4w3xZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 155/982] RDMA/umem: Be careful about boundary conditions in ib_umem_find_best_pgsz()
Date: Wed, 30 Sep 2026 17:14:51 +0200
Message-ID: <20260930152420.140706656@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 09ea6837a0434fb4db99528a5055b6d822135dcf ]

Several corner cases, especially important on 32 bits:

- umem->iova is u64, the function argument should pass in u64 or
  iova will be truncated
- Check that the length is not too large for the iova
- Check that lengths > 4G don't overflow the GENMASK

Link: https://patch.msgid.link/r/2-v1-88303e9e509f+f7-ib_umem_types_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/umem.c | 18 ++++++++++++------
 include/rdma/ib_umem.h         |  4 ++--
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 1d154055a335b..9b1994ba7b487 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -78,14 +78,17 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
  */
 unsigned long ib_umem_find_best_pgsz(struct ib_umem *umem,
 				     unsigned long pgsz_bitmap,
-				     unsigned long virt)
+				     u64 virt)
 {
 	unsigned long curr_len = 0;
 	dma_addr_t curr_base = ~0;
-	unsigned long va, pgoff;
+	unsigned long pgoff;
 	struct scatterlist *sg;
-	dma_addr_t mask;
+	unsigned long mask = 0;
+	unsigned int bits;
 	dma_addr_t end;
+	u64 last_va;
+	u64 va;
 	int i;
 
 	umem->iova = va = virt;
@@ -103,9 +106,12 @@ unsigned long ib_umem_find_best_pgsz(struct ib_umem *umem,
 	 * number of required pages. Compute the largest page size that could
 	 * work based on VA address bits that don't change.
 	 */
-	mask = pgsz_bitmap &
-	       GENMASK(BITS_PER_LONG - 1,
-		       bits_per((umem->length - 1 + virt) ^ virt));
+	if (check_add_overflow(umem->length - 1, virt, &last_va))
+		return 0;
+	bits = bits_per(virt ^ last_va);
+	if (bits < BITS_PER_LONG)
+		mask = pgsz_bitmap & GENMASK(BITS_PER_LONG - 1, bits);
+
 	/* offset into first SGL */
 	pgoff = umem->address & ~PAGE_MASK;
 
diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index d049e7a60ad65..ace2ffff2312d 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -80,7 +80,7 @@ int ib_umem_copy_from(void *dst, struct ib_umem *umem, size_t offset,
 		      size_t length);
 unsigned long ib_umem_find_best_pgsz(struct ib_umem *umem,
 				     unsigned long pgsz_bitmap,
-				     unsigned long virt);
+				     u64 virt);
 
 /**
  * ib_umem_find_best_pgoff - Find best HW page size
@@ -144,7 +144,7 @@ static inline int ib_umem_copy_from(void *dst, struct ib_umem *umem, size_t offs
 }
 static inline unsigned long ib_umem_find_best_pgsz(struct ib_umem *umem,
 						   unsigned long pgsz_bitmap,
-						   unsigned long virt)
+						   u64 virt)
 {
 	return 0;
 }
-- 
2.53.0



