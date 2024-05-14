Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC76134CDC;
	Tue, 14 May 2024 11:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686188; cv=none; b=BVq9z7YgWDQk4cJxSnWXgt3FKid+XfV4NJF9stCxrmxsgbhn5HSFDo1FOMndHfaPbIOwxTW5RcpgbVC9pAN6GAXBCybCN555hFTLOlzmd5IEAwzRs6TKuM3NWUfpPqcAVH9TFeBQIzMtXjvEbReIvgFQ4A7XZHBGI9IgeMpJrz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686188; c=relaxed/simple;
	bh=klL047nBJv6aR2+6nev2n7UKJAbb7yZgScXPfM5X3ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0RDaETK+rT9BmOv+59y1fbDncV60nJy0Drk1PkvA5z3p3EGU3NMHQhGZwGFNsIgzEw9gv6HHIlrAaEueG0kX8qAwEdjZ590GStN9LXAg0h7KVHFu7q51t7n7VprPb3Kf+X5YwS0v7ys8rJfS5Jkpy6VetN8GMLxr6wjHqR0Sz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RbqJgLe0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RbqJgLe0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3968C2BD10;
	Tue, 14 May 2024 11:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686188;
	bh=klL047nBJv6aR2+6nev2n7UKJAbb7yZgScXPfM5X3ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RbqJgLe0OFmLtk+OdSGBmTUTr7rLjK++JlYG/31SU9BRyAY6HmsQMbz5QCeZOmNdL
	 U2jGr2x9cPSiv+b8MmJLRkJU8B2Ihk+64KjAwXrX1/hAcoBVIbu+5BZXigAESofvUT
	 SAFJEex7MgPP1iCJRVOdPSukLigKzcemGAX8d5sQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Colin Cross <ccross@google.com>,
	David Howells <dhowells@redhat.com>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Hugh Dickins <hughd@google.com>,
	kernel test robot <lkp@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Peter Xu <peterx@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	William Kucharski <william.kucharski@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/236] mm/hugetlb: add hugetlb_folio_subpool() helpers
Date: Tue, 14 May 2024 12:16:13 +0200
Message-ID: <20240514101020.758953781@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

From: Sidhartha Kumar <sidhartha.kumar@oracle.com>

[ Upstream commit 149562f7509404c382c32c3fa8a6ba356135e5cf ]

Allow hugetlbfs_migrate_folio to check and read subpool information by
passing in a folio.

Link: https://lkml.kernel.org/r/20220922154207.1575343-4-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Colin Cross <ccross@google.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: b76b46902c2d ("mm/hugetlb: fix missing hugetlb_lock for resv uncharge")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hugetlbfs/inode.c    |  8 ++++----
 include/linux/hugetlb.h | 15 +++++++++++++--
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 4fe4b3393e71c..330729445d8ab 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1108,10 +1108,10 @@ static int hugetlbfs_migrate_folio(struct address_space *mapping,
 	if (rc != MIGRATEPAGE_SUCCESS)
 		return rc;
 
-	if (hugetlb_page_subpool(&src->page)) {
-		hugetlb_set_page_subpool(&dst->page,
-					hugetlb_page_subpool(&src->page));
-		hugetlb_set_page_subpool(&src->page, NULL);
+	if (hugetlb_folio_subpool(src)) {
+		hugetlb_set_folio_subpool(dst,
+					hugetlb_folio_subpool(src));
+		hugetlb_set_folio_subpool(src, NULL);
 	}
 
 	if (mode != MIGRATE_SYNC_NO_COPY)
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 0c5326fd3c47a..02d9a8af3704e 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -754,18 +754,29 @@ extern unsigned int default_hstate_idx;
 
 #define default_hstate (hstates[default_hstate_idx])
 
+static inline struct hugepage_subpool *hugetlb_folio_subpool(struct folio *folio)
+{
+	return (void *)folio_get_private_1(folio);
+}
+
 /*
  * hugetlb page subpool pointer located in hpage[1].private
  */
 static inline struct hugepage_subpool *hugetlb_page_subpool(struct page *hpage)
 {
-	return (void *)page_private(hpage + SUBPAGE_INDEX_SUBPOOL);
+	return hugetlb_folio_subpool(page_folio(hpage));
+}
+
+static inline void hugetlb_set_folio_subpool(struct folio *folio,
+					struct hugepage_subpool *subpool)
+{
+	folio_set_private_1(folio, (unsigned long)subpool);
 }
 
 static inline void hugetlb_set_page_subpool(struct page *hpage,
 					struct hugepage_subpool *subpool)
 {
-	set_page_private(hpage + SUBPAGE_INDEX_SUBPOOL, (unsigned long)subpool);
+	hugetlb_set_folio_subpool(page_folio(hpage), subpool);
 }
 
 static inline struct hstate *hstate_file(struct file *f)
-- 
2.43.0



