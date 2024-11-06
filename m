Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83251F8F06;
	Wed,  6 Nov 2024 12:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897218; cv=none; b=gZQ3tbP7AiI4hbL6meOYNjCuAWm8asL+ojTDxMjOoBjuzcpVfUyP7SpN4jQwbuavy9SWLfCFlIPa12URkcGeWBw0hHr6HPX0tACUloAa45l6ZiSOHB75I8fvmgJn92MvxlcKoCO7ZUeDOWqAtVB6F+YF0/QDvVc9qJjSW2kyMzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897218; c=relaxed/simple;
	bh=HoaaCcO5MbPwFOJWMeNV4sT5Ee2JmVa7z2AA3El12AI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HWU1KSy5TgVe6Re6SK9t7EsOiuK0HOpxfAZlDR4PNECqs4kZCw/JAq9AQDMnFooxBsT9slnqbcTOAR7tPjaqI7u+XapTMGk3a9a5LU6orcbbfhReT5BC0C9OEdQALJa/0Gb0KGTKTAaLD2uvipESsQWwOvD1hqZOrjutyLor9cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WNI9Jbi8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WNI9Jbi8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6C0C4CECD;
	Wed,  6 Nov 2024 12:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897217;
	bh=HoaaCcO5MbPwFOJWMeNV4sT5Ee2JmVa7z2AA3El12AI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WNI9Jbi89kXRmwNkMyxApVQULKLh+QQYw5C6/tUhsaLTjwyCq1U6AejKp2ayshBFp
	 vlR4V0dDnbkmFIxiQjx+6WweLpmMdp45hWlbbA5txmSyHAlgiX8l+C4nzv0624fHyQ
	 FvTnxJjzmXhWInwom+lVPyniiuSP72MNcW7akXrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Huang, Ying" <ying.huang@intel.com>,
	Alistair Popple <apopple@nvidia.com>,
	David Hildenbrand <david@redhat.com>,
	Yang Shi <shy828301@gmail.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 105/126] mm: migrate: try again if THP split is failed due to page refcnt
Date: Wed,  6 Nov 2024 13:05:06 +0100
Message-ID: <20241106120308.898481386@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baolin Wang <baolin.wang@linux.alibaba.com>

[ Upstream commit fd4a7ac32918d3d7a2d17dc06c5520f45e36eb52 ]

When creating a virtual machine, we will use memfd_create() to get a file
descriptor which can be used to create share memory mappings using the
mmap function, meanwhile the mmap() will set the MAP_POPULATE flag to
allocate physical pages for the virtual machine.

When allocating physical pages for the guest, the host can fallback to
allocate some CMA pages for the guest when over half of the zone's free
memory is in the CMA area.

In guest os, when the application wants to do some data transaction with
DMA, our QEMU will call VFIO_IOMMU_MAP_DMA ioctl to do longterm-pin and
create IOMMU mappings for the DMA pages.  However, when calling
VFIO_IOMMU_MAP_DMA ioctl to pin the physical pages, we found it will be
failed to longterm-pin sometimes.

After some invetigation, we found the pages used to do DMA mapping can
contain some CMA pages, and these CMA pages will cause a possible failure
of the longterm-pin, due to failed to migrate the CMA pages.  The reason
of migration failure may be temporary reference count or memory allocation
failure.  So that will cause the VFIO_IOMMU_MAP_DMA ioctl returns error,
which makes the application failed to start.

I observed one migration failure case (which is not easy to reproduce) is
that, the 'thp_migration_fail' count is 1 and the 'thp_split_page_failed'
count is also 1.

That means when migrating a THP which is in CMA area, but can not allocate
a new THP due to memory fragmentation, so it will split the THP.  However
THP split is also failed, probably the reason is temporary reference count
of this THP.  And the temporary reference count can be caused by dropping
page caches (I observed the drop caches operation in the system), but we
can not drop the shmem page caches due to they are already dirty at that
time.

Especially for THP split failure, which is caused by temporary reference
count, we can try again to mitigate the failure of migration in this case
according to previous discussion [1].

[1] https://lore.kernel.org/all/470dc638-a300-f261-94b4-e27250e42f96@redhat.com/
Link: https://lkml.kernel.org/r/6784730480a1df82e8f4cba1ed088e4ac767994b.1666599848.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 35e41024c4c2 ("vmscan,migrate: fix page count imbalance on node stats when demoting pages")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/huge_memory.c |  4 ++--
 mm/migrate.c     | 19 ++++++++++++++++---
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 98a1a05f2db2d..f53bc54dacb37 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2728,7 +2728,7 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 	 * split PMDs
 	 */
 	if (!can_split_folio(folio, &extra_pins)) {
-		ret = -EBUSY;
+		ret = -EAGAIN;
 		goto out_unlock;
 	}
 
@@ -2780,7 +2780,7 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 			xas_unlock(&xas);
 		local_irq_enable();
 		remap_page(folio, folio_nr_pages(folio));
-		ret = -EBUSY;
+		ret = -EAGAIN;
 	}
 
 out_unlock:
diff --git a/mm/migrate.c b/mm/migrate.c
index 0252aa4ff572e..b0caa89e67d5f 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1518,9 +1518,22 @@ int migrate_pages(struct list_head *from, new_page_t get_new_page,
 				if (is_thp) {
 					nr_thp_failed++;
 					/* THP NUMA faulting doesn't split THP to retry. */
-					if (!nosplit && !try_split_thp(page, &thp_split_pages)) {
-						nr_thp_split++;
-						break;
+					if (!nosplit) {
+						int ret = try_split_thp(page, &thp_split_pages);
+
+						if (!ret) {
+							nr_thp_split++;
+							break;
+						} else if (reason == MR_LONGTERM_PIN &&
+							   ret == -EAGAIN) {
+							/*
+							 * Try again to split THP to mitigate
+							 * the failure of longterm pinning.
+							 */
+							thp_retry++;
+							nr_retry_pages += nr_subpages;
+							break;
+						}
 					}
 				} else if (!no_subpage_counting) {
 					nr_failed++;
-- 
2.43.0



