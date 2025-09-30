Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F2E223DD6;
	Tue, 30 Sep 2025 15:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245803; cv=none; b=Q3A+hT4WfjeJYUvWwiIZkCcWndwAOd57rwuOYQcsLuIsU9fqulmfAUKm5qGvDsWI6kNWtGaPyPdqkP9MzGU+1P1tGKaBQpmrhJ/En/QKvL3OriPhw7D+DqSldEsvaGS6jphpSY73n2JnKeKJYMsN1EllX7mF+nxGK5bU+EtO0W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245803; c=relaxed/simple;
	bh=QRGUz8TIhvj8Wk+rhRoUeR+4h8dgGxrlQ+bnEYpFfic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/jyz5do4BZNNzA9TOv9rpoNGdfq3D8VUDCJp21zlQUASNkgn0xfNHACpNkqgpYaoxxgO1no2vkugGinK1LWZDMOQ46YUlIj+Ts1QoH2PyZJXs7+gRNffMAH8Tx7D1x+40XfX6cWv9SMR/Xah+aVESzT9576ms/LwEajDDGsuhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B+4FHcNx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B+4FHcNx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BDE7C4CEF0;
	Tue, 30 Sep 2025 15:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245802;
	bh=QRGUz8TIhvj8Wk+rhRoUeR+4h8dgGxrlQ+bnEYpFfic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B+4FHcNx1hcZMmayKhP9hLbXdKrqhcNnXYq3e3DOL3oAQxD4DlsPEpOXyvaxge9rf
	 CMjWca420UYrTi61YkJIFWkeeDDacTAoPd0QDViKpilQ/bnigg/CLRKjBv9bRz31iM
	 VkJGbIAzUk1VytGdv0vATsjHeA1cWefWoboOFJRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Shivank Garg <shivankg@amd.com>,
	Matthew Wilcox <willy@infradead.org>,
	Alistair Popple <apopple@nvidia.com>,
	Dave Kleikamp <shaggy@kernel.org>,
	Donet Tom <donettom@linux.ibm.com>,
	Jane Chu <jane.chu@oracle.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 23/91] mm: add folio_expected_ref_count() for reference count calculation
Date: Tue, 30 Sep 2025 16:47:22 +0200
Message-ID: <20250930143822.098219618@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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

From: Shivank Garg <shivankg@amd.com>

[ Upstream commit 86ebd50224c0734d965843260d0dc057a9431c61 ]

Patch series " JFS: Implement migrate_folio for jfs_metapage_aops" v5.

This patchset addresses a warning that occurs during memory compaction due
to JFS's missing migrate_folio operation.  The warning was introduced by
commit 7ee3647243e5 ("migrate: Remove call to ->writepage") which added
explicit warnings when filesystem don't implement migrate_folio.

The syzbot reported following [1]:
  jfs_metapage_aops does not implement migrate_folio
  WARNING: CPU: 1 PID: 5861 at mm/migrate.c:955 fallback_migrate_folio mm/migrate.c:953 [inline]
  WARNING: CPU: 1 PID: 5861 at mm/migrate.c:955 move_to_new_folio+0x70e/0x840 mm/migrate.c:1007
  Modules linked in:
  CPU: 1 UID: 0 PID: 5861 Comm: syz-executor280 Not tainted 6.15.0-rc1-next-20250411-syzkaller #0 PREEMPT(full)
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
  RIP: 0010:fallback_migrate_folio mm/migrate.c:953 [inline]
  RIP: 0010:move_to_new_folio+0x70e/0x840 mm/migrate.c:1007

To fix this issue, this series implement metapage_migrate_folio() for JFS
which handles both single and multiple metapages per page configurations.

While most filesystems leverage existing migration implementations like
filemap_migrate_folio(), buffer_migrate_folio_norefs() or
buffer_migrate_folio() (which internally used folio_expected_refs()),
JFS's metapage architecture requires special handling of its private data
during migration.  To support this, this series introduce the
folio_expected_ref_count(), which calculates external references to a
folio from page/swap cache, private data, and page table mappings.

This standardized implementation replaces the previous ad-hoc
folio_expected_refs() function and enables JFS to accurately determine
whether a folio has unexpected references before attempting migration.

Implement folio_expected_ref_count() to calculate expected folio reference
counts from:
- Page/swap cache (1 per page)
- Private data (1)
- Page table mappings (1 per map)

While originally needed for page migration operations, this improved
implementation standardizes reference counting by consolidating all
refcount contributors into a single, reusable function that can benefit
any subsystem needing to detect unexpected references to folios.

The folio_expected_ref_count() returns the sum of these external
references without including any reference the caller itself might hold.
Callers comparing against the actual folio_ref_count() must account for
their own references separately.

Link: https://syzkaller.appspot.com/bug?extid=8bb6fd945af4e0ad9299 [1]
Link: https://lkml.kernel.org/r/20250430100150.279751-1-shivankg@amd.com
Link: https://lkml.kernel.org/r/20250430100150.279751-2-shivankg@amd.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Co-developed-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Dave Kleikamp <shaggy@kernel.org>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 98c6d259319e ("mm/gup: check ref_count instead of lru before migration")
[ Take the new function in mm.h, removing "const" from its parameter to stop
  build warnings; but avoid all the conflicts of using it in mm/migrate.c. ]
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mm.h | 55 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index b97d8a691b28b..ba77f08900ca2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2156,6 +2156,61 @@ static inline int folio_estimated_sharers(struct folio *folio)
 	return page_mapcount(folio_page(folio, 0));
 }
 
+/**
+ * folio_expected_ref_count - calculate the expected folio refcount
+ * @folio: the folio
+ *
+ * Calculate the expected folio refcount, taking references from the pagecache,
+ * swapcache, PG_private and page table mappings into account. Useful in
+ * combination with folio_ref_count() to detect unexpected references (e.g.,
+ * GUP or other temporary references).
+ *
+ * Does currently not consider references from the LRU cache. If the folio
+ * was isolated from the LRU (which is the case during migration or split),
+ * the LRU cache does not apply.
+ *
+ * Calling this function on an unmapped folio -- !folio_mapped() -- that is
+ * locked will return a stable result.
+ *
+ * Calling this function on a mapped folio will not result in a stable result,
+ * because nothing stops additional page table mappings from coming (e.g.,
+ * fork()) or going (e.g., munmap()).
+ *
+ * Calling this function without the folio lock will also not result in a
+ * stable result: for example, the folio might get dropped from the swapcache
+ * concurrently.
+ *
+ * However, even when called without the folio lock or on a mapped folio,
+ * this function can be used to detect unexpected references early (for example,
+ * if it makes sense to even lock the folio and unmap it).
+ *
+ * The caller must add any reference (e.g., from folio_try_get()) it might be
+ * holding itself to the result.
+ *
+ * Returns the expected folio refcount.
+ */
+static inline int folio_expected_ref_count(struct folio *folio)
+{
+	const int order = folio_order(folio);
+	int ref_count = 0;
+
+	if (WARN_ON_ONCE(folio_test_slab(folio)))
+		return 0;
+
+	if (folio_test_anon(folio)) {
+		/* One reference per page from the swapcache. */
+		ref_count += folio_test_swapcache(folio) << order;
+	} else if (!((unsigned long)folio->mapping & PAGE_MAPPING_FLAGS)) {
+		/* One reference per page from the pagecache. */
+		ref_count += !!folio->mapping << order;
+		/* One reference from PG_private. */
+		ref_count += folio_test_private(folio);
+	}
+
+	/* One reference per page table mapping. */
+	return ref_count + folio_mapcount(folio);
+}
+
 #ifndef HAVE_ARCH_MAKE_PAGE_ACCESSIBLE
 static inline int arch_make_page_accessible(struct page *page)
 {
-- 
2.51.0



