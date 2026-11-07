Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065411;
	b=EVDNr5/G3kF7l0QgIWOsR7bxDwoAvt+D8Adelm1LgzscVI/ps5fX5lKQvoVveWQDuknG
	 Ks8m7uSuV/XBFkQMQbCFC8Gn20xP8x2WvtvRcG9EgMD2W9lyFnots9F1iGzQaVkiB4Z7o
	 J6cFbAAej2uyZe1cQw6SA9czMPP4WUieYxqKhrfpsW70x6f8uVSoRY1Cx6KjJ9G1eSkuu
	 crsB8r6+tr4CVeIQ9OHaJ5G+dP4R5/twsKctMsiO1mhSTzoG1NSN2D13qUjdySWPUSaSN
	 C/idQNOeaetVET4UiOUtaixxE//oRPgTWki4WnbwhGuB+L+T9SSF3VZU9JLEBGI3T8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065411;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CGAwar/0TbWmSJ3blFjW6JtRTqLRLDl/p+TNRbqx8DI=;
	b=hFLGYsxjhiDozC7roeNcX9FHeb5AhcShuU6ExNgR5+a9ckDpuuI8yOxGAETiGQfKIolH
	 2Z3kzZy8C9zQpzgByDjmIyE1NZnSSAon2GRpIvdZbp0wvbiY/yMZy/w5PcGp/Q99mO5EN
	 QigAbFBG+CkltEHh5RHpg/BgzkxnEdWlAlG0asX/i8l8N1uTEB8rzejs+lEs8bGe+es6h
	 WxhBo49LpzDyBQ6lQR7QsxSpZfIhslshmNDku9h3X0uKC0VTeOpDr74B6OvPrn7r0HxyT
	 eX7LtKMBFy9LxLjPEJ5SUjAHnOtyiN3GT9VT9Vq+YA3oGWt8/CU4ynpC/6BR9GJ5aqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="A/zinf/7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67927606A330;
	Sat,  7 Nov 2026 15:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A/zinf/7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1A31F0089F;
	Sat,  7 Nov 2026 15:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065411;
	bh=CGAwar/0TbWmSJ3blFjW6JtRTqLRLDl/p+TNRbqx8DI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A/zinf/7q5dtjXANHaHTl/uvW8PMIfISfaC4rivf+tRxs51LdxLpciJeUXY61GQ90
	 8LIOKIEStVdkviXwepASmBATZ2AjwSVoxUuwS1ETLzBGMbm8zi6kBOH4cZnhl+gW0/
	 JnqjBznUdswRKhb7rqkbR8UvRNY8nAiJiWZpJ4lM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1080/1257] mm/memfd: fix hugetlb reservation accounting in error paths
Date: Sat,  7 Nov 2026 08:56:16 -0500
Message-ID: <20261107135009.089503483@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongfu Li <lihongfu@kylinos.cn>

[ Upstream commit 50ee565c1e900e247e439e4139839b060c968343 ]

If hugetlb_add_to_page_cache() in memfd_alloc_folio() fails with -EEXIST,
a concurrent fault has already instantiated the folio in the page cache,
and the reservation now belongs to that folio.  Calling
hugetlb_unreserve_pages() in that case incorrectly removes the region
backing the cached folio and releases one reservation more than it should,
leaving that folio in the page cache with no region recording it.

That leaves resv_huge_pages one page short until that folio is removed
from the page cache, so available_huge_pages() reports a page that is not
actually free and the pool can grant one reservation more than it can
back.  Applications using hugetlb memfds can then fail to allocate or
fault in a page they already reserved.  They see -ENOMEM or -ENOSPC from
the allocation or fault path even though the reservation and
HugePages_Free still look healthy.

So hold the hugetlb fault mutex from hugetlb_reserve_pages() until the
error-path unreserve completes to make the reserve, allocate and
instantiate steps atomic against concurrent faults.  With the mutex held
from the start, a concurrent fault can no longer consume the reservation
between reserve and allocate/instantiate.  If a fault completed before the
mutex was taken, it has already added the region for that index, so
hugetlb_reserve_pages() returns 0 and the error path leaves the region in
place.

Link: https://lore.kernel.org/20260927094757.31665-1-hongfu.li@linux.dev
Link: https://lore.kernel.org/20260903030134.7407-1-hongfu.li@linux.dev
Fixes: 717cf9357325 ("mm/memfd: reserve hugetlb folios before allocation")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memfd.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/mm/memfd.c b/mm/memfd.c
index c708d92533f4a..0f6fff004f5e4 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -82,22 +82,31 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 		struct hstate *h = hstate_file(memfd);
 		int err = -ENOMEM;
 		long nr_resv;
+		u32 hash;
 
 		gfp_mask = htlb_alloc_mask(h);
 		gfp_mask &= ~(__GFP_HIGHMEM | __GFP_MOVABLE);
 		idx >>= huge_page_order(h);
 
+		/*
+		 * Serialize hugepage allocation and instantiation to prevent
+		 * races with concurrent allocations, as required by all other
+		 * callers of hugetlb_add_to_page_cache().
+		 */
+		hash = hugetlb_fault_mutex_hash(memfd->f_mapping, idx);
+		mutex_lock(&hugetlb_fault_mutex_table[hash]);
+
 		nr_resv = hugetlb_reserve_pages(inode, idx, idx + 1, NULL, EMPTY_VMA_FLAGS);
-		if (nr_resv < 0)
-			return ERR_PTR(nr_resv);
+		if (nr_resv < 0) {
+			err = nr_resv;
+			goto out_unlock;
+		}
 
 		folio = alloc_hugetlb_folio_reserve(h,
 						    numa_node_id(),
 						    NULL,
 						    gfp_mask);
 		if (folio) {
-			u32 hash;
-
 			/*
 			 * Zero the folio to prevent information leaks to userspace.
 			 * Use folio_zero_user() which is optimized for huge/gigantic
@@ -112,20 +121,9 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 			 */
 			__folio_mark_uptodate(folio);
 
-			/*
-			 * Serialize hugepage allocation and instantiation to prevent
-			 * races with concurrent allocations, as required by all other
-			 * callers of hugetlb_add_to_page_cache().
-			 */
-			hash = hugetlb_fault_mutex_hash(memfd->f_mapping, idx);
-			mutex_lock(&hugetlb_fault_mutex_table[hash]);
-
 			err = hugetlb_add_to_page_cache(folio,
 							memfd->f_mapping,
 							idx);
-
-			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
-
 			if (err) {
 				folio_put(folio);
 				goto err_unresv;
@@ -133,11 +131,14 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 
 			hugetlb_set_folio_subpool(folio, subpool_inode(inode));
 			folio_unlock(folio);
+			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			return folio;
 		}
 err_unresv:
 		if (nr_resv > 0)
 			hugetlb_unreserve_pages(inode, idx, idx + 1, 0);
+out_unlock:
+		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 		return ERR_PTR(err);
 	}
 #endif
-- 
2.53.0



