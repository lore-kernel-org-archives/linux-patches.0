Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD402F0C52;
	Mon, 22 Sep 2025 19:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569948; cv=none; b=ekSfUo7CIEAlNDkWDJRzlwAtbhtorwTFMLIIlns5bz6XzSo5GPgfZmYshCcOj3Hu6PfVJrgJ2rPxSmxYLaqng2c6Naz/R/WjzzpKij5XFJB0OzlTUWduQKlidK32FPmP55YvtWogo9pl+jFrQku03hCA/lylTvhkkoKICyxC4BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569948; c=relaxed/simple;
	bh=8NTlvOueA/7oDB7JkzQ/20A9tOZdTUtWob+r3CxAk24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uI4zKeXwhyTaubgeMvh/IYDXe18EPBB9c93Bv10B+xlV3g35d2j6EjIPMSKMKYFQLKGGHQwDK5QqHJ0pk0/7WH3ARWGgXpxUQdkqouz/+bFFzDieUgLgjc7MDt2efkMVvAtVWTZS5R5Bnwbq5zC+CbpAgc1uJ0mA44WI40+JO5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=moNgMwZq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="moNgMwZq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68BBAC4CEF0;
	Mon, 22 Sep 2025 19:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569948;
	bh=8NTlvOueA/7oDB7JkzQ/20A9tOZdTUtWob+r3CxAk24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=moNgMwZqHrXQrmrPSxcjljYf1ikx+QrP74llZnIZTiNeTcnovlARmKS+yt1DyHD3c
	 u+wVes4fn5sokgoYwLQaFNn6CECXd8nSsxtYBFO0sEpL/9Q06XJm8hRSlGqLZ9WuHM
	 FYs8PmpxsM6bsOZv4gov5KaiELL1Zl4RPyYil6Hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.12 052/105] iommu/amd/pgtbl: Fix possible race while increase page table level
Date: Mon, 22 Sep 2025 21:29:35 +0200
Message-ID: <20250922192410.277723153@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasant Hegde <vasant.hegde@amd.com>

commit 1e56310b40fd2e7e0b9493da9ff488af145bdd0c upstream.

The AMD IOMMU host page table implementation supports dynamic page table levels
(up to 6 levels), starting with a 3-level configuration that expands based on
IOVA address. The kernel maintains a root pointer and current page table level
to enable proper page table walks in alloc_pte()/fetch_pte() operations.

The IOMMU IOVA allocator initially starts with 32-bit address and onces its
exhuasted it switches to 64-bit address (max address is determined based
on IOMMU and device DMA capability). To support larger IOVA, AMD IOMMU
driver increases page table level.

But in unmap path (iommu_v1_unmap_pages()), fetch_pte() reads
pgtable->[root/mode] without lock. So its possible that in exteme corner case,
when increase_address_space() is updating pgtable->[root/mode], fetch_pte()
reads wrong page table level (pgtable->mode). It does compare the value with
level encoded in page table and returns NULL. This will result is
iommu_unmap ops to fail and upper layer may retry/log WARN_ON.

CPU 0                                         CPU 1
------                                       ------
map pages                                    unmap pages
alloc_pte() -> increase_address_space()      iommu_v1_unmap_pages() -> fetch_pte()
  pgtable->root = pte (new root value)
                                             READ pgtable->[mode/root]
					       Reads new root, old mode
  Updates mode (pgtable->mode += 1)

Since Page table level updates are infrequent and already synchronized with a
spinlock, implement seqcount to enable lock-free read operations on the read path.

Fixes: 754265bcab7 ("iommu/amd: Fix race in increase_address_space()")
Reported-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Cc: stable@vger.kernel.org
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd/amd_iommu_types.h |    1 +
 drivers/iommu/amd/io_pgtable.c      |   25 +++++++++++++++++++++----
 2 files changed, 22 insertions(+), 4 deletions(-)

--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -545,6 +545,7 @@ struct gcr3_tbl_info {
 };
 
 struct amd_io_pgtable {
+	seqcount_t		seqcount;	/* Protects root/mode update */
 	struct io_pgtable	pgtbl;
 	int			mode;
 	u64			*root;
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/dma-mapping.h>
+#include <linux/seqlock.h>
 
 #include <asm/barrier.h>
 
@@ -144,8 +145,11 @@ static bool increase_address_space(struc
 
 	*pte = PM_LEVEL_PDE(pgtable->mode, iommu_virt_to_phys(pgtable->root));
 
+	write_seqcount_begin(&pgtable->seqcount);
 	pgtable->root  = pte;
 	pgtable->mode += 1;
+	write_seqcount_end(&pgtable->seqcount);
+
 	amd_iommu_update_and_flush_device_table(domain);
 
 	pte = NULL;
@@ -167,6 +171,7 @@ static u64 *alloc_pte(struct amd_io_pgta
 {
 	unsigned long last_addr = address + (page_size - 1);
 	struct io_pgtable_cfg *cfg = &pgtable->pgtbl.cfg;
+	unsigned int seqcount;
 	int level, end_lvl;
 	u64 *pte, *page;
 
@@ -184,8 +189,14 @@ static u64 *alloc_pte(struct amd_io_pgta
 	}
 
 
-	level   = pgtable->mode - 1;
-	pte     = &pgtable->root[PM_LEVEL_INDEX(level, address)];
+	do {
+		seqcount = read_seqcount_begin(&pgtable->seqcount);
+
+		level   = pgtable->mode - 1;
+		pte     = &pgtable->root[PM_LEVEL_INDEX(level, address)];
+	} while (read_seqcount_retry(&pgtable->seqcount, seqcount));
+
+
 	address = PAGE_SIZE_ALIGN(address, page_size);
 	end_lvl = PAGE_SIZE_LEVEL(page_size);
 
@@ -262,6 +273,7 @@ static u64 *fetch_pte(struct amd_io_pgta
 		      unsigned long *page_size)
 {
 	int level;
+	unsigned int seqcount;
 	u64 *pte;
 
 	*page_size = 0;
@@ -269,8 +281,12 @@ static u64 *fetch_pte(struct amd_io_pgta
 	if (address > PM_LEVEL_SIZE(pgtable->mode))
 		return NULL;
 
-	level	   =  pgtable->mode - 1;
-	pte	   = &pgtable->root[PM_LEVEL_INDEX(level, address)];
+	do {
+		seqcount = read_seqcount_begin(&pgtable->seqcount);
+		level	   =  pgtable->mode - 1;
+		pte	   = &pgtable->root[PM_LEVEL_INDEX(level, address)];
+	} while (read_seqcount_retry(&pgtable->seqcount, seqcount));
+
 	*page_size =  PTE_LEVEL_PAGE_SIZE(level);
 
 	while (level > 0) {
@@ -552,6 +568,7 @@ static struct io_pgtable *v1_alloc_pgtab
 	if (!pgtable->root)
 		return NULL;
 	pgtable->mode = PAGE_MODE_3_LEVEL;
+	seqcount_init(&pgtable->seqcount);
 
 	cfg->pgsize_bitmap  = amd_iommu_pgsize_bitmap;
 	cfg->ias            = IOMMU_IN_ADDR_BIT_SIZE;


