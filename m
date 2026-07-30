Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3C645199A;
	Thu, 30 Jul 2026 16:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428061; cv=none; b=Zfu5/U/5PaG4NLSaqILBOXgiDMEOzBeiiOx02Ve71OxtmE7Zs9rxQ7EgsvKpPyb0mCCBIX/d9ZGIrXLLvo0TA5rYwdBUKbw4q8CQHsmJgCJwiiexTTZq3hX/+MbkmEviWmMbiAoQ9tSBzl0mG6FEkQGos69wc7IIBE/FcjnQekM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428061; c=relaxed/simple;
	bh=YxjKYaJ1job8fqgleyACumDnEV2iNalzENTX2NuDT6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ICghhr2wtVKh2trraTPAVYa2N1Vin88MZiQT186vdIPUQFrLpcyuMi9Nop8HDwf6PKzDxviE9uOs9ClwmpUvW7+i0gQ6nprBS/O3//Gk7mnMNiVLEJIYlJugt1WJamN48hQJeuO92Y3gJt9XCoUSgDlR27UhCm6e7BDvmUPIC3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=15mTucR8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="15mTucR8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D071F000E9;
	Thu, 30 Jul 2026 16:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428059;
	bh=/Taucw3WDOuylXIKiPz1Zs2ZTYVb2GbQk/9a8WXYlok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=15mTucR8mDspTJH+JtXGsQGFimBx1wsxqcByicZmMrXza7sSgXXue+xEFPTCE9fAh
	 2BfQwFuHRSouCKmbcGGyueZrtSWHQckEoKTlHWuqI8zuyX3GOglNyPyvRPst4tAnIH
	 BOAkIYY2fEAZHL3luLzl91h3VJopu3uMVeEBI1dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheng Zhao <sheng.zhao@bytedance.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 389/484] vduse: Use fixed 4KB bounce pages for non-4KB page size
Date: Thu, 30 Jul 2026 16:14:46 +0200
Message-ID: <20260730141431.925912162@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Sheng Zhao <sheng.zhao@bytedance.com>

[ Upstream commit 3fc3068e7247c94dec08e93fea422a1bb649bfe5 ]

The allocation granularity of bounce pages is PAGE_SIZE. This may cause
even small IO requests to occupy an entire bounce page exclusively. The
kind of memory waste will be more significant when PAGE_SIZE is larger
than 4KB (e.g. arm64 with 64KB pages).

So, optimize it by using fixed 4KB bounce maps and iova allocation
granularity. A single IO request occupies at least a 4KB bounce page
instead of the entire memory page of PAGE_SIZE.

Signed-off-by: Sheng Zhao <sheng.zhao@bytedance.com>
Message-Id: <20250925113516.60305-1-sheng.zhao@bytedance.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Stable-dep-of: 9c1523803445 ("VDUSE: avoid leaking information to userspace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/vdpa_user/iova_domain.c |  134 +++++++++++++++++++++++++----------
 drivers/vdpa/vdpa_user/iova_domain.h |    5 +
 2 files changed, 101 insertions(+), 38 deletions(-)

--- a/drivers/vdpa/vdpa_user/iova_domain.c
+++ b/drivers/vdpa/vdpa_user/iova_domain.c
@@ -103,19 +103,38 @@ void vduse_domain_clear_map(struct vduse
 static int vduse_domain_map_bounce_page(struct vduse_iova_domain *domain,
 					 u64 iova, u64 size, u64 paddr)
 {
-	struct vduse_bounce_map *map;
+	struct vduse_bounce_map *map, *head_map;
+	struct page *tmp_page;
 	u64 last = iova + size - 1;
 
 	while (iova <= last) {
-		map = &domain->bounce_maps[iova >> PAGE_SHIFT];
+		/*
+		 * When PAGE_SIZE is larger than 4KB, multiple adjacent bounce_maps will
+		 * point to the same memory page of PAGE_SIZE. Since bounce_maps originate
+		 * from IO requests, we may not be able to guarantee that the orig_phys
+		 * values of all IO requests within the same 64KB memory page are contiguous.
+		 * Therefore, we need to store them separately.
+		 *
+		 * Bounce pages are allocated on demand. As a result, it may occur that
+		 * multiple bounce pages corresponding to the same 64KB memory page attempt
+		 * to allocate memory simultaneously, so we use cmpxchg to handle this
+		 * concurrency.
+		 */
+		map = &domain->bounce_maps[iova >> BOUNCE_MAP_SHIFT];
 		if (!map->bounce_page) {
-			map->bounce_page = alloc_page(GFP_ATOMIC);
-			if (!map->bounce_page)
-				return -ENOMEM;
+			head_map = &domain->bounce_maps[(iova & PAGE_MASK) >> BOUNCE_MAP_SHIFT];
+			if (!head_map->bounce_page) {
+				tmp_page = alloc_page(GFP_ATOMIC);
+				if (!tmp_page)
+					return -ENOMEM;
+				if (cmpxchg(&head_map->bounce_page, NULL, tmp_page))
+					__free_page(tmp_page);
+			}
+			map->bounce_page = head_map->bounce_page;
 		}
 		map->orig_phys = paddr;
-		paddr += PAGE_SIZE;
-		iova += PAGE_SIZE;
+		paddr += BOUNCE_MAP_SIZE;
+		iova += BOUNCE_MAP_SIZE;
 	}
 	return 0;
 }
@@ -127,12 +146,17 @@ static void vduse_domain_unmap_bounce_pa
 	u64 last = iova + size - 1;
 
 	while (iova <= last) {
-		map = &domain->bounce_maps[iova >> PAGE_SHIFT];
+		map = &domain->bounce_maps[iova >> BOUNCE_MAP_SHIFT];
 		map->orig_phys = INVALID_PHYS_ADDR;
-		iova += PAGE_SIZE;
+		iova += BOUNCE_MAP_SIZE;
 	}
 }
 
+static unsigned int offset_in_bounce_page(dma_addr_t addr)
+{
+	return (addr & ~BOUNCE_MAP_MASK);
+}
+
 static void do_bounce(phys_addr_t orig, void *addr, size_t size,
 		      enum dma_data_direction dir)
 {
@@ -162,7 +186,7 @@ static void vduse_domain_bounce(struct v
 				enum dma_data_direction dir)
 {
 	struct vduse_bounce_map *map;
-	unsigned int offset;
+	unsigned int offset, head_offset;
 	void *addr;
 	size_t sz;
 
@@ -170,16 +194,17 @@ static void vduse_domain_bounce(struct v
 		return;
 
 	while (size) {
-		map = &domain->bounce_maps[iova >> PAGE_SHIFT];
-		offset = offset_in_page(iova);
-		sz = min_t(size_t, PAGE_SIZE - offset, size);
+		map = &domain->bounce_maps[iova >> BOUNCE_MAP_SHIFT];
+		head_offset = offset_in_page(iova);
+		offset = offset_in_bounce_page(iova);
+		sz = min_t(size_t, BOUNCE_MAP_SIZE - offset, size);
 
 		if (WARN_ON(!map->bounce_page ||
 			    map->orig_phys == INVALID_PHYS_ADDR))
 			return;
 
 		addr = kmap_local_page(map->bounce_page);
-		do_bounce(map->orig_phys + offset, addr + offset, sz, dir);
+		do_bounce(map->orig_phys + offset, addr + head_offset, sz, dir);
 		kunmap_local(addr);
 		size -= sz;
 		iova += sz;
@@ -214,7 +239,7 @@ vduse_domain_get_bounce_page(struct vdus
 	struct page *page = NULL;
 
 	read_lock(&domain->bounce_lock);
-	map = &domain->bounce_maps[iova >> PAGE_SHIFT];
+	map = &domain->bounce_maps[iova >> BOUNCE_MAP_SHIFT];
 	if (domain->user_bounce_pages || !map->bounce_page)
 		goto out;
 
@@ -232,7 +257,7 @@ vduse_domain_free_kernel_bounce_pages(st
 	struct vduse_bounce_map *map;
 	unsigned long pfn, bounce_pfns;
 
-	bounce_pfns = domain->bounce_size >> PAGE_SHIFT;
+	bounce_pfns = domain->bounce_size >> BOUNCE_MAP_SHIFT;
 
 	for (pfn = 0; pfn < bounce_pfns; pfn++) {
 		map = &domain->bounce_maps[pfn];
@@ -242,7 +267,8 @@ vduse_domain_free_kernel_bounce_pages(st
 		if (!map->bounce_page)
 			continue;
 
-		__free_page(map->bounce_page);
+		if (!((pfn << BOUNCE_MAP_SHIFT) & ~PAGE_MASK))
+			__free_page(map->bounce_page);
 		map->bounce_page = NULL;
 	}
 }
@@ -250,8 +276,12 @@ vduse_domain_free_kernel_bounce_pages(st
 int vduse_domain_add_user_bounce_pages(struct vduse_iova_domain *domain,
 				       struct page **pages, int count)
 {
-	struct vduse_bounce_map *map;
-	int i, ret;
+	struct vduse_bounce_map *map, *head_map;
+	int i, j, ret;
+	int inner_pages = PAGE_SIZE / BOUNCE_MAP_SIZE;
+	int bounce_pfns = domain->bounce_size >> BOUNCE_MAP_SHIFT;
+	struct page *head_page = NULL;
+	bool need_copy;
 
 	/* Now we don't support partial mapping */
 	if (count != (domain->bounce_size >> PAGE_SHIFT))
@@ -263,17 +293,25 @@ int vduse_domain_add_user_bounce_pages(s
 		goto out;
 
 	for (i = 0; i < count; i++) {
-		map = &domain->bounce_maps[i];
-		if (map->bounce_page) {
+		need_copy = false;
+		head_map = &domain->bounce_maps[(i * inner_pages)];
+		head_page = head_map->bounce_page;
+		for (j = 0; j < inner_pages; j++) {
+			if ((i * inner_pages + j) >= bounce_pfns)
+				break;
+			map = &domain->bounce_maps[(i * inner_pages + j)];
 			/* Copy kernel page to user page if it's in use */
-			if (map->orig_phys != INVALID_PHYS_ADDR)
-				memcpy_to_page(pages[i], 0,
-					       page_address(map->bounce_page),
-					       PAGE_SIZE);
-			__free_page(map->bounce_page);
+			if ((head_page) && (map->orig_phys != INVALID_PHYS_ADDR))
+				need_copy = true;
+			map->bounce_page = pages[i];
 		}
-		map->bounce_page = pages[i];
 		get_page(pages[i]);
+		if ((head_page) && (need_copy))
+			memcpy_to_page(pages[i], 0,
+				       page_address(head_page),
+				       PAGE_SIZE);
+		if (head_page)
+			__free_page(head_page);
 	}
 	domain->user_bounce_pages = true;
 	ret = 0;
@@ -285,8 +323,12 @@ out:
 
 void vduse_domain_remove_user_bounce_pages(struct vduse_iova_domain *domain)
 {
-	struct vduse_bounce_map *map;
-	unsigned long i, count;
+	struct vduse_bounce_map *map, *head_map;
+	unsigned long i, j, count;
+	int inner_pages = PAGE_SIZE / BOUNCE_MAP_SIZE;
+	int bounce_pfns = domain->bounce_size >> BOUNCE_MAP_SHIFT;
+	struct page *head_page = NULL;
+	bool need_copy;
 
 	write_lock(&domain->bounce_lock);
 	if (!domain->user_bounce_pages)
@@ -296,18 +338,34 @@ void vduse_domain_remove_user_bounce_pag
 	for (i = 0; i < count; i++) {
 		struct page *page = NULL;
 
-		map = &domain->bounce_maps[i];
-		if (WARN_ON(!map->bounce_page))
+		need_copy = false;
+		head_map = &domain->bounce_maps[(i * inner_pages)];
+		if (WARN_ON(!head_map->bounce_page))
 			continue;
+		head_page = head_map->bounce_page;
 
-		/* Copy user page to kernel page if it's in use */
-		if (map->orig_phys != INVALID_PHYS_ADDR) {
+		for (j = 0; j < inner_pages; j++) {
+			if ((i * inner_pages + j) >= bounce_pfns)
+				break;
+			map = &domain->bounce_maps[(i * inner_pages + j)];
+			if (WARN_ON(!map->bounce_page))
+				continue;
+			/* Copy user page to kernel page if it's in use */
+			if (map->orig_phys != INVALID_PHYS_ADDR)
+				need_copy = true;
+		}
+		if (need_copy) {
 			page = alloc_page(GFP_ATOMIC | __GFP_NOFAIL);
 			memcpy_from_page(page_address(page),
-					 map->bounce_page, 0, PAGE_SIZE);
+					 head_page, 0, PAGE_SIZE);
+		}
+		for (j = 0; j < inner_pages; j++) {
+			if ((i * inner_pages + j) >= bounce_pfns)
+				break;
+			map = &domain->bounce_maps[(i * inner_pages + j)];
+			map->bounce_page = page;
 		}
-		put_page(map->bounce_page);
-		map->bounce_page = page;
+		put_page(head_page);
 	}
 	domain->user_bounce_pages = false;
 out:
@@ -557,7 +615,7 @@ vduse_domain_create(unsigned long iova_l
 	unsigned long pfn, bounce_pfns;
 	int ret;
 
-	bounce_pfns = PAGE_ALIGN(bounce_size) >> PAGE_SHIFT;
+	bounce_pfns = PAGE_ALIGN(bounce_size) >> BOUNCE_MAP_SHIFT;
 	if (iova_limit <= bounce_size)
 		return NULL;
 
@@ -589,7 +647,7 @@ vduse_domain_create(unsigned long iova_l
 	rwlock_init(&domain->bounce_lock);
 	spin_lock_init(&domain->iotlb_lock);
 	init_iova_domain(&domain->stream_iovad,
-			PAGE_SIZE, IOVA_START_PFN);
+			BOUNCE_MAP_SIZE, IOVA_START_PFN);
 	ret = iova_domain_init_rcaches(&domain->stream_iovad);
 	if (ret)
 		goto err_iovad_stream;
--- a/drivers/vdpa/vdpa_user/iova_domain.h
+++ b/drivers/vdpa/vdpa_user/iova_domain.h
@@ -19,6 +19,11 @@
 
 #define INVALID_PHYS_ADDR (~(phys_addr_t)0)
 
+#define BOUNCE_MAP_SHIFT	12
+#define BOUNCE_MAP_SIZE	(1 << BOUNCE_MAP_SHIFT)
+#define BOUNCE_MAP_MASK	(~(BOUNCE_MAP_SIZE - 1))
+#define BOUNCE_MAP_ALIGN(addr)	(((addr) + BOUNCE_MAP_SIZE - 1) & ~(BOUNCE_MAP_SIZE - 1))
+
 struct vduse_bounce_map {
 	struct page *bounce_page;
 	u64 orig_phys;


