Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBA147CA8C;
	Thu, 20 Aug 2026 16:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243373; cv=none; b=tuyR+eHkYsHr436kdUac6UhQXWn5l3+AMMiJRzi+E0tk9p9WeTLjAG/fo8NQfO7XC26aPkGP+3Z0OUwEfsBlSOgcPIScdtSxvVah/KhK7kzITTbkBrm5nVtfhahhnxNqvV+WS2yYkJJKVU4x3U9doQvaweDu/SOw1AVEXJoNPXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243373; c=relaxed/simple;
	bh=3kNJdclpUk9pC2HNgB1eAJsiNcCmZvGTfwhje+Syq3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=boWW2fQdx6uON6xHVdZSrKcn8fLz9qSU44+Ngj/dZ2Zwet0rg2y3F4+YOL4R/EQgYSKCgfp7UfBvsct35o1TW9tABmp6y8zYSt7QHPlMOiv6u7jA9jqGUZWmn5S1zRV9oJl3kj32ybX3xkxhcPqOP+wi8c2V0/SA7OJHdIQlKIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h/JI4+hl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h/JI4+hl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 687DE1F000E9;
	Thu, 20 Aug 2026 16:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243371;
	bh=M6JVvzTV/VZsMFXq3kXHDm4VbrJ8rDMuOEPHacLsIYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h/JI4+hlYPM4WNsvti5bVth0p+kYV99spZqH2M4158xWujVYtQUS7a7fzcPBlJSq8
	 cCM8lq1zgVz+wZqa1y1jr0VzSkl4IlqkULURXUg1hBpnKId2AiCXkULElohDmWL/U1
	 5NzrtDuxEZOb5x0yBXFiZU9dTgJN4wA5LN+wC7lE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheng Zhao <sheng.zhao@bytedance.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 070/272] vduse: Use fixed 4KB bounce pages for non-4KB page size
Date: Thu, 20 Aug 2026 16:54:14 +0200
Message-ID: <20260820145233.384062170@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/vdpa/vdpa_user/iova_domain.c |   64 ++++++++++++++++++++++++-----------
 drivers/vdpa/vdpa_user/iova_domain.h |    5 ++
 2 files changed, 50 insertions(+), 19 deletions(-)

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
@@ -163,7 +187,7 @@ static void vduse_domain_bounce(struct v
 				enum dma_data_direction dir)
 {
 	struct vduse_bounce_map *map;
-	unsigned int offset;
+	unsigned int offset, head_offset;
 	void *addr;
 	size_t sz;
 
@@ -171,15 +195,16 @@ static void vduse_domain_bounce(struct v
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
 
-		addr = page_address(map->bounce_page) + offset;
+		addr = page_address(map->bounce_page) + head_offset;
 		do_bounce(map->orig_phys + offset, addr, sz, dir);
 		size -= sz;
 		iova += sz;
@@ -214,7 +239,7 @@ vduse_domain_get_bounce_page(struct vdus
 	struct page *page = NULL;
 
 	spin_lock(&domain->iotlb_lock);
-	map = &domain->bounce_maps[iova >> PAGE_SHIFT];
+	map = &domain->bounce_maps[iova >> BOUNCE_MAP_SHIFT];
 	if (!map->bounce_page)
 		goto out;
 
@@ -232,7 +257,7 @@ vduse_domain_free_bounce_pages(struct vd
 	struct vduse_bounce_map *map;
 	unsigned long pfn, bounce_pfns;
 
-	bounce_pfns = domain->bounce_size >> PAGE_SHIFT;
+	bounce_pfns = domain->bounce_size >> BOUNCE_MAP_SHIFT;
 
 	for (pfn = 0; pfn < bounce_pfns; pfn++) {
 		map = &domain->bounce_maps[pfn];
@@ -242,7 +267,8 @@ vduse_domain_free_bounce_pages(struct vd
 		if (!map->bounce_page)
 			continue;
 
-		__free_page(map->bounce_page);
+		if (!((pfn << BOUNCE_MAP_SHIFT) & ~PAGE_MASK))
+			__free_page(map->bounce_page);
 		map->bounce_page = NULL;
 	}
 }
@@ -489,7 +515,7 @@ vduse_domain_create(unsigned long iova_l
 	struct vduse_bounce_map *map;
 	unsigned long pfn, bounce_pfns;
 
-	bounce_pfns = PAGE_ALIGN(bounce_size) >> PAGE_SHIFT;
+	bounce_pfns = PAGE_ALIGN(bounce_size) >> BOUNCE_MAP_SHIFT;
 	if (iova_limit <= bounce_size)
 		return NULL;
 
@@ -520,7 +546,7 @@ vduse_domain_create(unsigned long iova_l
 	domain->file = file;
 	spin_lock_init(&domain->iotlb_lock);
 	init_iova_domain(&domain->stream_iovad,
-			PAGE_SIZE, IOVA_START_PFN);
+			BOUNCE_MAP_SIZE, IOVA_START_PFN);
 	init_iova_domain(&domain->consistent_iovad,
 			PAGE_SIZE, bounce_pfns);
 
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


