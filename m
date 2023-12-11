Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C704FC2D0;
	Mon, 11 Dec 2023 18:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hy8sACGl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8FFC433C8;
	Mon, 11 Dec 2023 18:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319524;
	bh=CtAsJmgrd75+vMwxALmv0scVlfdF1z8e/cHEvjczECM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hy8sACGlTxl+L8Zlv4jHbcWAE4rZ9oljA3at9QIIBe2ejGm9MhVHfNXW5jaLwYPK1
	 fjPVo8/2hrYJ5AgsoCaP10rpCo6IeAUh9Wkuthn1HSgw8cl/aMmYqFLXeBP73R8KlE
	 d0br7SesteBG7CVV2OcgMzoTwIXIVSoDruw1lbT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Marciniszyn <mike.marciniszyn@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 108/244] RDMA/core: Fix umem iterator when PAGE_SIZE is greater then HCA pgsz
Date: Mon, 11 Dec 2023 19:20:01 +0100
Message-ID: <20231211182050.613646508@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

[ Upstream commit 4fbc3a52cd4d14de3793f4b2c721d7306ea84cf9 ]

64k pages introduce the situation in this diagram when the HCA 4k page
size is being used:

 +-------------------------------------------+ <--- 64k aligned VA
 |                                           |
 |              HCA 4k page                  |
 |                                           |
 +-------------------------------------------+
 |                   o                       |
 |                                           |
 |                   o                       |
 |                                           |
 |                   o                       |
 +-------------------------------------------+
 |                                           |
 |              HCA 4k page                  |
 |                                           |
 +-------------------------------------------+ <--- Live HCA page
 |OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO| <--- offset
 |                                           | <--- VA
 |                MR data                    |
 +-------------------------------------------+
 |                                           |
 |              HCA 4k page                  |
 |                                           |
 +-------------------------------------------+
 |                   o                       |
 |                                           |
 |                   o                       |
 |                                           |
 |                   o                       |
 +-------------------------------------------+
 |                                           |
 |              HCA 4k page                  |
 |                                           |
 +-------------------------------------------+

The VA addresses are coming from rdma-core in this diagram can be
arbitrary, but for 64k pages, the VA may be offset by some number of HCA
4k pages and followed by some number of HCA 4k pages.

The current iterator doesn't account for either the preceding 4k pages or
the following 4k pages.

Fix the issue by extending the ib_block_iter to contain the number of DMA
pages like comment [1] says and by using __sg_advance to start the
iterator at the first live HCA page.

The changes are contained in a parallel set of iterator start and next
functions that are umem aware and specific to umem since there is one user
of the rdma_for_each_block() without umem.

These two fixes prevents the extra pages before and after the user MR
data.

Fix the preceding pages by using the __sq_advance field to start at the
first 4k page containing MR data.

Fix the following pages by saving the number of pgsz blocks in the
iterator state and downcounting on each next.

This fix allows for the elimination of the small page crutch noted in the
Fixes.

Fixes: 10c75ccb54e4 ("RDMA/umem: Prevent small pages from being returned by ib_umem_find_best_pgsz()")
Link: https://lore.kernel.org/r/20231129202143.1434-2-shiraz.saleem@intel.com
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/umem.c | 6 ------
 include/rdma/ib_umem.h         | 9 ++++++++-
 include/rdma/ib_verbs.h        | 1 +
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index f9ab671c8eda5..07c571c7b6999 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -96,12 +96,6 @@ unsigned long ib_umem_find_best_pgsz(struct ib_umem *umem,
 		return page_size;
 	}
 
-	/* rdma_for_each_block() has a bug if the page size is smaller than the
-	 * page size used to build the umem. For now prevent smaller page sizes
-	 * from being returned.
-	 */
-	pgsz_bitmap &= GENMASK(BITS_PER_LONG - 1, PAGE_SHIFT);
-
 	/* The best result is the smallest page size that results in the minimum
 	 * number of required pages. Compute the largest page size that could
 	 * work based on VA address bits that don't change.
diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index 95896472a82bf..565a850445414 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -77,6 +77,13 @@ static inline void __rdma_umem_block_iter_start(struct ib_block_iter *biter,
 {
 	__rdma_block_iter_start(biter, umem->sgt_append.sgt.sgl,
 				umem->sgt_append.sgt.nents, pgsz);
+	biter->__sg_advance = ib_umem_offset(umem) & ~(pgsz - 1);
+	biter->__sg_numblocks = ib_umem_num_dma_blocks(umem, pgsz);
+}
+
+static inline bool __rdma_umem_block_iter_next(struct ib_block_iter *biter)
+{
+	return __rdma_block_iter_next(biter) && biter->__sg_numblocks--;
 }
 
 /**
@@ -92,7 +99,7 @@ static inline void __rdma_umem_block_iter_start(struct ib_block_iter *biter,
  */
 #define rdma_umem_for_each_dma_block(umem, biter, pgsz)                        \
 	for (__rdma_umem_block_iter_start(biter, umem, pgsz);                  \
-	     __rdma_block_iter_next(biter);)
+	     __rdma_umem_block_iter_next(biter);)
 
 #ifdef CONFIG_INFINIBAND_USER_MEM
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 533ab92684d81..62f9d126a71ad 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2846,6 +2846,7 @@ struct ib_block_iter {
 	/* internal states */
 	struct scatterlist *__sg;	/* sg holding the current aligned block */
 	dma_addr_t __dma_addr;		/* unaligned DMA address of this block */
+	size_t __sg_numblocks;		/* ib_umem_num_dma_blocks() */
 	unsigned int __sg_nents;	/* number of SG entries */
 	unsigned int __sg_advance;	/* number of bytes to advance in sg in next step */
 	unsigned int __pg_bit;		/* alignment of current block */
-- 
2.42.0



