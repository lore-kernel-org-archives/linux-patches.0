Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9262876029;
	Mon, 29 Jan 2024 17:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548618; cv=none; b=r1V/bqf2mCZ3Dg1J6JxzNQ7jbwBLI0WwgWlysRmqFru/I5I8b0ZAGHRwC+yn43CDg1jCWTg/RHSmx5rjPamsYBmbf/6IyYKsaXhrT0BC+XcgyP0yHJE5mZidFIpw6mG/RHedSHKSNTq67XVfwKE2f9fBaOsglGyz+NL4jlYVp9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548618; c=relaxed/simple;
	bh=Yh+ouFxk4S9dRFs/2X0YlnoY+nWofTRe6rzRJgNmE6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GhnITQIFaXvVgb8cd2zXvedk218h9BK0EwIAhieg9KRm0IGRlBCXhOvL32aNRijlhxwqj+aPT4ba/prP1ZPRgmhNRv7SW8jKlfhqEf6iDhUb624T9cr61eRPz6UOoiAECZ+ZUsO5/3cn5l+DKpz+enCdijis/h76oSsZpN+qMMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sEBhrU7b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sEBhrU7b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57CA4C433F1;
	Mon, 29 Jan 2024 17:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548618;
	bh=Yh+ouFxk4S9dRFs/2X0YlnoY+nWofTRe6rzRJgNmE6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sEBhrU7bftY6VFtinhaldIgB2CIH/XL3RFtLU6FHyGWKn8bet0jCPxaBzK0PAfAGJ
	 smwZDHC1+pUDXkif5ZdbktvRlFQSBXzJ8gxuEv4C0dFSq8gC9N55Jzyd2WvTf5iDHM
	 YfJmDZzO/xXiJ0cPvls+WHEzM/Rzj3uIXi/D8QCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Huang, Ying" <ying.huang@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Xu Yu <xuyu@linux.alibaba.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 287/331] mm: migrate: fix getting incorrect page mapping during page migration
Date: Mon, 29 Jan 2024 09:05:51 -0800
Message-ID: <20240129170023.256597812@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Baolin Wang <baolin.wang@linux.alibaba.com>

[ Upstream commit d1adb25df7111de83b64655a80b5a135adbded61 ]

When running stress-ng testing, we found below kernel crash after a few hours:

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
pc : dentry_name+0xd8/0x224
lr : pointer+0x22c/0x370
sp : ffff800025f134c0
......
Call trace:
  dentry_name+0xd8/0x224
  pointer+0x22c/0x370
  vsnprintf+0x1ec/0x730
  vscnprintf+0x2c/0x60
  vprintk_store+0x70/0x234
  vprintk_emit+0xe0/0x24c
  vprintk_default+0x3c/0x44
  vprintk_func+0x84/0x2d0
  printk+0x64/0x88
  __dump_page+0x52c/0x530
  dump_page+0x14/0x20
  set_migratetype_isolate+0x110/0x224
  start_isolate_page_range+0xc4/0x20c
  offline_pages+0x124/0x474
  memory_block_offline+0x44/0xf4
  memory_subsys_offline+0x3c/0x70
  device_offline+0xf0/0x120
  ......

After analyzing the vmcore, I found this issue is caused by page migration.
The scenario is that, one thread is doing page migration, and we will use the
target page's ->mapping field to save 'anon_vma' pointer between page unmap and
page move, and now the target page is locked and refcount is 1.

Currently, there is another stress-ng thread performing memory hotplug,
attempting to offline the target page that is being migrated. It discovers that
the refcount of this target page is 1, preventing the offline operation, thus
proceeding to dump the page. However, page_mapping() of the target page may
return an incorrect file mapping to crash the system in dump_mapping(), since
the target page->mapping only saves 'anon_vma' pointer without setting
PAGE_MAPPING_ANON flag.

There are seveval ways to fix this issue:
(1) Setting the PAGE_MAPPING_ANON flag for target page's ->mapping when saving
'anon_vma', but this can confuse PageAnon() for PFN walkers, since the target
page has not built mappings yet.
(2) Getting the page lock to call page_mapping() in __dump_page() to avoid crashing
the system, however, there are still some PFN walkers that call page_mapping()
without holding the page lock, such as compaction.
(3) Using target page->private field to save the 'anon_vma' pointer and 2 bits
page state, just as page->mapping records an anonymous page, which can remove
the page_mapping() impact for PFN walkers and also seems a simple way.

So I choose option 3 to fix this issue, and this can also fix other potential
issues for PFN walkers, such as compaction.

Link: https://lkml.kernel.org/r/e60b17a88afc38cb32f84c3e30837ec70b343d2b.1702641709.git.baolin.wang@linux.alibaba.com
Fixes: 64c8902ed441 ("migrate_pages: split unmap_and_move() to _unmap() and _move()")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Xu Yu <xuyu@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/migrate.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 3373fc1c2d0f..b4d972d80b10 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1026,38 +1026,31 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
 }
 
 /*
- * To record some information during migration, we use some unused
- * fields (mapping and private) of struct folio of the newly allocated
- * destination folio.  This is safe because nobody is using them
- * except us.
+ * To record some information during migration, we use unused private
+ * field of struct folio of the newly allocated destination folio.
+ * This is safe because nobody is using it except us.
  */
-union migration_ptr {
-	struct anon_vma *anon_vma;
-	struct address_space *mapping;
-};
-
 enum {
 	PAGE_WAS_MAPPED = BIT(0),
 	PAGE_WAS_MLOCKED = BIT(1),
+	PAGE_OLD_STATES = PAGE_WAS_MAPPED | PAGE_WAS_MLOCKED,
 };
 
 static void __migrate_folio_record(struct folio *dst,
-				   unsigned long old_page_state,
+				   int old_page_state,
 				   struct anon_vma *anon_vma)
 {
-	union migration_ptr ptr = { .anon_vma = anon_vma };
-	dst->mapping = ptr.mapping;
-	dst->private = (void *)old_page_state;
+	dst->private = (void *)anon_vma + old_page_state;
 }
 
 static void __migrate_folio_extract(struct folio *dst,
 				   int *old_page_state,
 				   struct anon_vma **anon_vmap)
 {
-	union migration_ptr ptr = { .mapping = dst->mapping };
-	*anon_vmap = ptr.anon_vma;
-	*old_page_state = (unsigned long)dst->private;
-	dst->mapping = NULL;
+	unsigned long private = (unsigned long)dst->private;
+
+	*anon_vmap = (struct anon_vma *)(private & ~PAGE_OLD_STATES);
+	*old_page_state = private & PAGE_OLD_STATES;
 	dst->private = NULL;
 }
 
-- 
2.43.0



