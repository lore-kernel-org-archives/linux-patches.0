Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23613D3002;
	Wed, 30 Sep 2026 18:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794351; cv=none; b=gOmIgam75pc4OPh01VYjYhFoJkYDGUFOSLa8DvQ23mSaq7QoUvqwHlZDFKvkECw2LP6j9oolT1ySv5p7hmRoH6O2021iH1Oo+IzrWmwJk8WIyQNE14kBb2OQk3qyzXm8s765kclTEUXJO/n/WBiM2Wa2WmX3w4P+nKkA30kZ59k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794351; c=relaxed/simple;
	bh=AsEUHjaobLtrUR5VzKyEm75ntAuyUnjiZfaQV2tCKSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VVToSq7k5Y/2agGHfE4Qv+L+5fH4jxQ5oCGfCIyJKE/amzPStZdzNG1XVfoWlZn5ogZiCIjzjOkQwKlWgO6Gb6AAbFUg0gN8u+dBqm6YjWzjvrEzL2CEPGzjhX9+msoTvkwRmARdx2ndKfBagr85w+DdW0YF1XKITrjmp+sRr+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UsKDZScc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UsKDZScc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181141F00898;
	Wed, 30 Sep 2026 18:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794350;
	bh=g6nnwaWUzK3MWrybcBRzuPStGta/DmUb8C3gZFttKZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UsKDZSccldVCIIcVBnt3/Cq50lP/y9J4lqj8ceDB7Fl32e1x64Bx+xC3miWaO5gsR
	 7SxGSr5yLPWCmEs4+NS+np/GiRHczmLtwTiHvG4eLh1fGxT6GFA4ipwz8+dAzacHGS
	 zbrtN3zBh8q4Cf47r38p9WWAweYMmcSF3b0zkC+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0179/1193] RDMA/umem: Be careful about boundary conditions in ib_umem_find_best_pgsz()
Date: Wed, 30 Sep 2026 17:14:23 +0200
Message-ID: <20260930152438.172042196@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index fd3a774904f8d..468d662c42c47 100644
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
index 4c5329b504d0c..821f23d2a4458 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -81,7 +81,7 @@ int ib_umem_copy_from(void *dst, struct ib_umem *umem, size_t offset,
 		      size_t length);
 unsigned long ib_umem_find_best_pgsz(struct ib_umem *umem,
 				     unsigned long pgsz_bitmap,
-				     unsigned long virt);
+				     u64 virt);
 
 /**
  * ib_umem_find_best_pgoff - Find best HW page size
@@ -161,7 +161,7 @@ static inline int ib_umem_copy_from(void *dst, struct ib_umem *umem, size_t offs
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



