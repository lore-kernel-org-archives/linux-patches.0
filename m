Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F446465
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:47:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E123AC340EC;
	Tue, 22 Mar 2022 21:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985661;
	bh=dF8NF39j9FHPKjFgkJgcfFPmWB58valHeHG0ZipHqBo=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=Gb6IAwQ82eXxeIfhTlABwtWjdeiHo4n19Tmy4e37auS9yFMbjUypdUlgE5rgSdDVT
	 aYPSF4vGqTTIwGtwGyxw1tEbcqaL5qKdYLfsoSxeq2IaSzPU5SvNHEwaMsO5+6PBdz
	 3dz814Z/AhV6OKvE80lJtRFHGI2IBsOPrvvDW4E8=
Date: Tue, 22 Mar 2022 14:47:40 -0700
To: shy828301@gmail.com,kirill.shutemov@linux.intel.com,hughd@google.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 180/227] mm/thp: ClearPageDoubleMap in first page_add_file_rmap()
Message-Id: <20220322214740.E123AC340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Hugh Dickins <hughd@google.com>
Subject: mm/thp: ClearPageDoubleMap in first page_add_file_rmap()

PageDoubleMap is maintained differently for anon and for shmem+file: the
shmem+file one was never cleared, because a safe place to do so could not
be found; so it would blight future use of the cached hugepage until
evicted.

See https://lore.kernel.org/lkml/1571938066-29031-1-git-send-email-yang.shi@linux.alibaba.com/

But page_add_file_rmap() does provide a safe place to do so (though later
than one might wish): allowing testing to return to an initial state
without a damaging drop_caches.

Link: https://lkml.kernel.org/r/61c5cf99-a962-9a25-597a-53ab1bd8fbc0@google.com
Fixes: 9a73f61bdb8a ("thp, mlock: do not mlock PTE-mapped file huge pages")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/rmap.c~mm-thp-clearpagedoublemap-in-first-page_add_file_rmap
+++ a/mm/rmap.c
@@ -1252,6 +1252,17 @@ void page_add_file_rmap(struct page *pag
 		}
 		if (!atomic_inc_and_test(compound_mapcount_ptr(page)))
 			goto out;
+
+		/*
+		 * It is racy to ClearPageDoubleMap in page_remove_file_rmap();
+		 * but page lock is held by all page_add_file_rmap() compound
+		 * callers, and SetPageDoubleMap below warns if !PageLocked:
+		 * so here is a place that DoubleMap can be safely cleared.
+		 */
+		VM_WARN_ON_ONCE(!PageLocked(page));
+		if (nr == nr_pages && PageDoubleMap(page))
+			ClearPageDoubleMap(page);
+
 		if (PageSwapBacked(page))
 			__mod_lruvec_page_state(page, NR_SHMEM_PMDMAPPED,
 						nr_pages);
_
