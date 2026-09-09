Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91632577E47;
	Wed,  9 Sep 2026 14:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964886; cv=none; b=ebUbVGZuZLj5NeohjG40wNkcymFPHJcjXltmp7Oz6vYevVjXqEwEU0z7hryTlrL3XdTozq99lp7wbVlsiWC9dpBf1qLVQ+WpKnkdv3jA6qGrdWN4oQECJX4Ybff17ovMDMn+Rix7HypPStUFwhGqGcfYVUbepcWV4jtmypk3bA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964886; c=relaxed/simple;
	bh=+16M03FHeB8uK5xY/nqKPnmJ+aNHBd5oEtPDlgV2gYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+vMOlq9GFmgKTgOo240pGLyHVVa8ujLllgBYwRsDePhB4QvD/w/TmJSfooGSlG2ncFZUblYcTxPpypzgO9zk1KvEnfjt1ayI/h8THl0mDAStA99NjLzI7eIiszrO5OGGmkasv6OuiuINuh1hPgzEINlPIhr/U2AGPrJwIOD8fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ShBQfaPs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ShBQfaPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC301F00A3A;
	Wed,  9 Sep 2026 14:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964884;
	bh=LM5Xgg90nC2cyPVcp8Nb8LOCg/gu3SCd8zj2XdIazSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ShBQfaPsUoPBxNzcDTT55lhl3DdjBG+G7Igy4xd9qLkcP0wnJBPVMobMwgjLy4Kj7
	 IYe5g3XNlLv/nowZYV3johaVSqWz60jQVUUaDt07mdV2FcHb97cO8AoGXFiGcMaFUF
	 fCz59Yoxu2yvN8l88zwzd9ixLErEH/qC1U+7Z4uI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zi Yan <ziy@nvidia.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Balbir Singh <balbirs@nvidia.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Liam Howlett <liam.howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 577/583] mm/huge_memory: change folio_split_supported() to folio_check_splittable()
Date: Wed,  9 Sep 2026 15:44:22 +0200
Message-ID: <20260909134257.801146146@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zi Yan <ziy@nvidia.com>

[ Upstream commit bdd0d69a32c2aa6437d23e35acc705758b835a75 ]

Patch series "Improve folio split related functions", v4.

This patchset improves several folio split related functions to avoid
future misuse.  The changes are:

1. Consolidated folio splittable checks by moving truncated folio check,
   huge zero folio check, and writeback folio check into
   folio_split_supported(). Changed the function return type. Renamed it
   to folio_check_splittable() for clarification.

2. Replaced can_split_folio() with open coded folio_expected_ref_count()
   and folio_ref_count() and introduced folio_cache_ref_count().

3. Changed min_order_for_split() to always return an order.

4. Fixed folio split stats counting.

Motivation
==========
This is based on Wei's observation[1] and solves several potential
issues:
1. Dereferencing NULL folio->mapping in try_folio_split_to_order() if it
   is called on truncated folios.
2. Not handling of negative return value of min_order_for_split() in
   mm/memory-failure.c

There is no bug in the current code.

This patch (of 4):

folio_split_supported() used in try_folio_split_to_order() requires
folio->mapping to be non NULL, but current try_folio_split_to_order() does
not check it.  There is no issue in the current code, since
try_folio_split_to_order() is only used in truncate_inode_partial_folio(),
where folio->mapping is not NULL.

To prevent future misuse, move folio->mapping NULL check (i.e., folio is
truncated) into folio_split_supported().  Since folio->mapping NULL check
returns -EBUSY and folio_split_supported() == false means -EINVAL, change
folio_split_supported() return type from bool to int and return error
numbers accordingly.  Rename folio_split_supported() to
folio_check_splittable() to match the return type change.

While at it, move is_huge_zero_folio() check and folio_test_writeback()
check into folio_check_splittable() and add kernel-doc.

Remove all warnings inside folio_check_splittable() and give warnings
in __folio_split() instead, so that bool warns parameter can be removed.

Link: https://lkml.kernel.org/r/20251126210618.1971206-1-ziy@nvidia.com
Link: https://lkml.kernel.org/r/20251126210618.1971206-2-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: c299a2285d9d ("mm/huge_memory: use folio's memcg inside __folio_split()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/huge_mm.h |    6 ++--
 mm/huge_memory.c        |   72 ++++++++++++++++++++++++++----------------------
 2 files changed, 43 insertions(+), 35 deletions(-)

--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -369,8 +369,8 @@ int split_huge_page_to_list_to_order(str
 		unsigned int new_order);
 int min_order_for_split(struct folio *folio);
 int split_folio_to_list(struct folio *folio, struct list_head *list);
-bool folio_split_supported(struct folio *folio, unsigned int new_order,
-		bool uniform_split, bool warns);
+int folio_check_splittable(struct folio *folio, unsigned int new_order,
+			   bool uniform_split);
 int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
 		struct list_head *list);
 /*
@@ -390,7 +390,7 @@ int folio_split(struct folio *folio, uns
 static inline int try_folio_split_to_order(struct folio *folio,
 		struct page *page, unsigned int new_order)
 {
-	if (!folio_split_supported(folio, new_order, false, /* warns= */ false))
+	if (folio_check_splittable(folio, new_order, false))
 		return split_huge_page_to_list_to_order(&folio->page, NULL,
 				new_order);
 	return folio_split(folio, new_order, page, NULL);
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3605,15 +3605,40 @@ static int __split_unmapped_folio(struct
 	return ret;
 }
 
-bool folio_split_supported(struct folio *folio, unsigned int new_order,
-		bool uniform_split, bool warns)
+/**
+ * folio_check_splittable() - check if a folio can be split to a given order
+ * @folio: folio to be split
+ * @new_order: the smallest order of the after split folios (since buddy
+ *             allocator like split generates folios with orders from @folio's
+ *             order - 1 to new_order).
+ * @uniform_split: perform uniform split or not (non-uniform split)
+ *
+ * folio_check_splittable() checks if @folio can be split to @new_order using
+ * the requested split method. The truncated folio check must come first.
+ *
+ * Context: folio must be locked.
+ *
+ * Return: 0 - @folio can be split to @new_order, otherwise an error number is
+ * returned.
+ */
+int folio_check_splittable(struct folio *folio, unsigned int new_order,
+			   bool uniform_split)
 {
+	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
+	/*
+	 * Folios that just got truncated cannot get split. Signal to the
+	 * caller that there was a race.
+	 *
+	 * TODO: this will also currently refuse folios without a mapping in the
+	 * swapcache (shmem or to-be-anon folios).
+	 */
+	if (!folio->mapping && !folio_test_anon(folio))
+		return -EBUSY;
+
 	if (folio_test_anon(folio)) {
 		/* order-1 is not supported for anonymous THP. */
-		VM_WARN_ONCE(warns && new_order == 1,
-				"Cannot split to order-1 folio");
 		if (new_order == 1)
-			return false;
+			return -EINVAL;
 	} else if (!uniform_split || new_order) {
 		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
 		    !mapping_large_folio_support(folio->mapping)) {
@@ -3634,9 +3659,7 @@ bool folio_split_supported(struct folio
 			 * case, the mapping does not actually support large
 			 * folios properly.
 			 */
-			VM_WARN_ONCE(warns,
-				"Cannot split file folio to non-0 order");
-			return false;
+			return -EINVAL;
 		}
 	}
 
@@ -3649,12 +3672,16 @@ bool folio_split_supported(struct folio
 	 * here.
 	 */
 	if ((!uniform_split || new_order) && folio_test_swapcache(folio)) {
-		VM_WARN_ONCE(warns,
-			"Cannot split swapcache folio to non-0 order");
-		return false;
+		return -EINVAL;
 	}
 
-	return true;
+	if (is_huge_zero_folio(folio))
+		return -EINVAL;
+
+	if (folio_test_writeback(folio))
+		return -EBUSY;
+
+	return 0;
 }
 
 /*
@@ -3704,31 +3731,12 @@ static int __folio_split(struct folio *f
 		goto out;
 	}
 
-	/*
-	 * Folios that just got truncated cannot get split. Signal to the
-	 * caller that there was a race.
-	 *
-	 * TODO: this will also currently refuse shmem folios that are in the
-	 * swapcache.
-	 */
-	if (!is_anon && !folio->mapping)
-		return -EBUSY;
-
 	if (new_order >= old_order) {
 		ret = -EINVAL;
 		goto out;
 	}
 
-	if (is_huge_zero_folio(folio)) {
-		pr_warn_ratelimited("Called split_huge_page for huge zero page\n");
-		return -EBUSY;
-	}
-
-	if (folio_test_writeback(folio))
-		return -EBUSY;
-
-	ret = folio_split_supported(folio, new_order, uniform_split,
-				    /* warns = */ false) ? 0 : -EINVAL;
+	ret = folio_check_splittable(folio, new_order, uniform_split);
 	if (ret) {
 		VM_WARN_ONCE(ret == -EINVAL, "Tried to split an unsplittable folio");
 		goto out;


