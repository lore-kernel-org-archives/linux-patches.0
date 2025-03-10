Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6836235364;
	Mon, 10 Mar 2025 17:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627460; cv=none; b=j6X4bVg9h6Yrr7tKMEgxLgwi9zFM04/HSbGPdUuBY0No++fTlrmb9BNSGsF8Uv7umnnEIYSMcPZKLEPVW7pXGbCDrHExS4nHZmHJZUYeHtXiGSGZoPsYuJnwNtTt3TmJZ011UY1vd5+JlIMKUVgFceS6pjY9ZwAdK1YLlcDxlVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627460; c=relaxed/simple;
	bh=2ug4dBua3hnlzYIplZeHBBdV8n9wvcSS3No9PIR1o1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DTtsjjba/I1kmZp0hTYryuuDPWs2VsAyeagLBkkYXLPocxL0uFYplk25Iv08YHRMuyF/Na1GG6YuP4j9hEszKS4QwtHa2AwxlOG29z3zZlYwHKxlWZYOwJ78/tPxaHmhQLty5b9ygQbLv5f9cPrQ6bzDTfbEgpYjxflExO/HAzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8vG2gbb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8vG2gbb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34136C4CEE5;
	Mon, 10 Mar 2025 17:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627460;
	bh=2ug4dBua3hnlzYIplZeHBBdV8n9wvcSS3No9PIR1o1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z8vG2gbbDLOQlOqiDG3tSP7+pFSjwl2OXvUtD0jq+/9pXoWsgYqqtB/i2Dje/j1SX
	 RT4vT5CTTpW1GpGeAYm/aGG+jqwi1jIBm+spX4pJEuka9GW/BLs+oZ9SbCEEfqHCry
	 QkCG+4vWv/Ir0afhqAjKY/FOqdzeyXvERLD7PX20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Wupeng <mawupeng1@huawei.com>,
	David Hildenbrand <david@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Michal Hocko <mhocko@suse.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 136/269] mm: memory-failure: update ttu flag inside unmap_poisoned_folio
Date: Mon, 10 Mar 2025 18:04:49 +0100
Message-ID: <20250310170503.143175393@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

From: Ma Wupeng <mawupeng1@huawei.com>

commit b81679b1633aa43c0d973adfa816d78c1ed0d032 upstream.

Patch series "mm: memory_failure: unmap poisoned folio during migrate
properly", v3.

Fix two bugs during folio migration if the folio is poisoned.


This patch (of 3):

Commit 6da6b1d4a7df ("mm/hwpoison: convert TTU_IGNORE_HWPOISON to
TTU_HWPOISON") introduce TTU_HWPOISON to replace TTU_IGNORE_HWPOISON in
order to stop send SIGBUS signal when accessing an error page after a
memory error on a clean folio.  However during page migration, anon folio
must be set with TTU_HWPOISON during unmap_*().  For pagecache we need
some policy just like the one in hwpoison_user_mappings to set this flag.
So move this policy from hwpoison_user_mappings to unmap_poisoned_folio to
handle this warning properly.

Warning will be produced during unamp poison folio with the following log:

  ------------[ cut here ]------------
  WARNING: CPU: 1 PID: 365 at mm/rmap.c:1847 try_to_unmap_one+0x8fc/0xd3c
  Modules linked in:
  CPU: 1 UID: 0 PID: 365 Comm: bash Tainted: G        W          6.13.0-rc1-00018-gacdb4bbda7ab #42
  Tainted: [W]=WARN
  Hardware name: QEMU QEMU Virtual Machine, BIOS 0.0.0 02/06/2015
  pstate: 20400005 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  pc : try_to_unmap_one+0x8fc/0xd3c
  lr : try_to_unmap_one+0x3dc/0xd3c
  Call trace:
   try_to_unmap_one+0x8fc/0xd3c (P)
   try_to_unmap_one+0x3dc/0xd3c (L)
   rmap_walk_anon+0xdc/0x1f8
   rmap_walk+0x3c/0x58
   try_to_unmap+0x88/0x90
   unmap_poisoned_folio+0x30/0xa8
   do_migrate_range+0x4a0/0x568
   offline_pages+0x5a4/0x670
   memory_block_action+0x17c/0x374
   memory_subsys_offline+0x3c/0x78
   device_offline+0xa4/0xd0
   state_store+0x8c/0xf0
   dev_attr_store+0x18/0x2c
   sysfs_kf_write+0x44/0x54
   kernfs_fop_write_iter+0x118/0x1a8
   vfs_write+0x3a8/0x4bc
   ksys_write+0x6c/0xf8
   __arm64_sys_write+0x1c/0x28
   invoke_syscall+0x44/0x100
   el0_svc_common.constprop.0+0x40/0xe0
   do_el0_svc+0x1c/0x28
   el0_svc+0x30/0xd0
   el0t_64_sync_handler+0xc8/0xcc
   el0t_64_sync+0x198/0x19c
  ---[ end trace 0000000000000000 ]---

[mawupeng1@huawei.com: unmap_poisoned_folio(): remove shadowed local `mapping', per Miaohe]
  Link: https://lkml.kernel.org/r/20250219060653.3849083-1-mawupeng1@huawei.com
Link: https://lkml.kernel.org/r/20250217014329.3610326-1-mawupeng1@huawei.com
Link: https://lkml.kernel.org/r/20250217014329.3610326-2-mawupeng1@huawei.com
Fixes: 6da6b1d4a7df ("mm/hwpoison: convert TTU_IGNORE_HWPOISON to TTU_HWPOISON")
Signed-off-by: Ma Wupeng <mawupeng1@huawei.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Ma Wupeng <mawupeng1@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/internal.h       |    5 ++--
 mm/memory-failure.c |   63 +++++++++++++++++++++++++---------------------------
 mm/memory_hotplug.c |    3 +-
 3 files changed, 36 insertions(+), 35 deletions(-)

--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1101,7 +1101,7 @@ static inline int find_next_best_node(in
  * mm/memory-failure.c
  */
 #ifdef CONFIG_MEMORY_FAILURE
-void unmap_poisoned_folio(struct folio *folio, enum ttu_flags ttu);
+int unmap_poisoned_folio(struct folio *folio, unsigned long pfn, bool must_kill);
 void shake_folio(struct folio *folio);
 extern int hwpoison_filter(struct page *p);
 
@@ -1123,8 +1123,9 @@ void add_to_kill_ksm(struct task_struct
 unsigned long page_mapped_in_vma(struct page *page, struct vm_area_struct *vma);
 
 #else
-static inline void unmap_poisoned_folio(struct folio *folio, enum ttu_flags ttu)
+static inline int unmap_poisoned_folio(struct folio *folio, unsigned long pfn, bool must_kill)
 {
+	return -EBUSY;
 }
 #endif
 
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1554,11 +1554,35 @@ static int get_hwpoison_page(struct page
 	return ret;
 }
 
-void unmap_poisoned_folio(struct folio *folio, enum ttu_flags ttu)
+int unmap_poisoned_folio(struct folio *folio, unsigned long pfn, bool must_kill)
 {
-	if (folio_test_hugetlb(folio) && !folio_test_anon(folio)) {
-		struct address_space *mapping;
+	enum ttu_flags ttu = TTU_IGNORE_MLOCK | TTU_SYNC | TTU_HWPOISON;
+	struct address_space *mapping;
+
+	if (folio_test_swapcache(folio)) {
+		pr_err("%#lx: keeping poisoned page in swap cache\n", pfn);
+		ttu &= ~TTU_HWPOISON;
+	}
+
+	/*
+	 * Propagate the dirty bit from PTEs to struct page first, because we
+	 * need this to decide if we should kill or just drop the page.
+	 * XXX: the dirty test could be racy: set_page_dirty() may not always
+	 * be called inside page lock (it's recommended but not enforced).
+	 */
+	mapping = folio_mapping(folio);
+	if (!must_kill && !folio_test_dirty(folio) && mapping &&
+	    mapping_can_writeback(mapping)) {
+		if (folio_mkclean(folio)) {
+			folio_set_dirty(folio);
+		} else {
+			ttu &= ~TTU_HWPOISON;
+			pr_info("%#lx: corrupted page was clean: dropped without side effects\n",
+				pfn);
+		}
+	}
 
+	if (folio_test_hugetlb(folio) && !folio_test_anon(folio)) {
 		/*
 		 * For hugetlb folios in shared mappings, try_to_unmap
 		 * could potentially call huge_pmd_unshare.  Because of
@@ -1570,7 +1594,7 @@ void unmap_poisoned_folio(struct folio *
 		if (!mapping) {
 			pr_info("%#lx: could not lock mapping for mapped hugetlb folio\n",
 				folio_pfn(folio));
-			return;
+			return -EBUSY;
 		}
 
 		try_to_unmap(folio, ttu|TTU_RMAP_LOCKED);
@@ -1578,6 +1602,8 @@ void unmap_poisoned_folio(struct folio *
 	} else {
 		try_to_unmap(folio, ttu);
 	}
+
+	return folio_mapped(folio) ? -EBUSY : 0;
 }
 
 /*
@@ -1587,8 +1613,6 @@ void unmap_poisoned_folio(struct folio *
 static bool hwpoison_user_mappings(struct folio *folio, struct page *p,
 		unsigned long pfn, int flags)
 {
-	enum ttu_flags ttu = TTU_IGNORE_MLOCK | TTU_SYNC | TTU_HWPOISON;
-	struct address_space *mapping;
 	LIST_HEAD(tokill);
 	bool unmap_success;
 	int forcekill;
@@ -1611,29 +1635,6 @@ static bool hwpoison_user_mappings(struc
 	if (!folio_mapped(folio))
 		return true;
 
-	if (folio_test_swapcache(folio)) {
-		pr_err("%#lx: keeping poisoned page in swap cache\n", pfn);
-		ttu &= ~TTU_HWPOISON;
-	}
-
-	/*
-	 * Propagate the dirty bit from PTEs to struct page first, because we
-	 * need this to decide if we should kill or just drop the page.
-	 * XXX: the dirty test could be racy: set_page_dirty() may not always
-	 * be called inside page lock (it's recommended but not enforced).
-	 */
-	mapping = folio_mapping(folio);
-	if (!(flags & MF_MUST_KILL) && !folio_test_dirty(folio) && mapping &&
-	    mapping_can_writeback(mapping)) {
-		if (folio_mkclean(folio)) {
-			folio_set_dirty(folio);
-		} else {
-			ttu &= ~TTU_HWPOISON;
-			pr_info("%#lx: corrupted page was clean: dropped without side effects\n",
-				pfn);
-		}
-	}
-
 	/*
 	 * First collect all the processes that have the page
 	 * mapped in dirty form.  This has to be done before try_to_unmap,
@@ -1641,9 +1642,7 @@ static bool hwpoison_user_mappings(struc
 	 */
 	collect_procs(folio, p, &tokill, flags & MF_ACTION_REQUIRED);
 
-	unmap_poisoned_folio(folio, ttu);
-
-	unmap_success = !folio_mapped(folio);
+	unmap_success = !unmap_poisoned_folio(folio, pfn, flags & MF_MUST_KILL);
 	if (!unmap_success)
 		pr_err("%#lx: failed to unmap page (folio mapcount=%d)\n",
 		       pfn, folio_mapcount(folio));
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1806,7 +1806,8 @@ static void do_migrate_range(unsigned lo
 			if (WARN_ON(folio_test_lru(folio)))
 				folio_isolate_lru(folio);
 			if (folio_mapped(folio))
-				unmap_poisoned_folio(folio, TTU_IGNORE_MLOCK);
+				unmap_poisoned_folio(folio, pfn, false);
+
 			continue;
 		}
 


