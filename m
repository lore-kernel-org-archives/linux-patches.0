Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54972590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:23:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E55DC4339C;
	Sun, 22 Jan 2023 15:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401012;
	bh=mZby8Yb58rp1n1UxaOkn5jiZ6IQFsJURYPw6inTtGhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o8vJKt28TMJ/XW9vTxI3T8IFYifXMwfCii2QdhbIyQ9issuXif1ktDwbzcQjqJawZ
	 40e4NvYY6EHwwrElaQKk7z6X/a+hmVZGRyGTdwpy4BSSY6J/h2smAHkKIpsrugzNNx
	 c95WPUnYLxctDQ0lzxl3SWFcBg7VRhJgDpifxrds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Muchun Song <muchun.song@linux.dev>,
	Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 077/193] mm/hugetlb: fix uffd-wp handling for migration entries in hugetlb_change_protection()
Date: Sun, 22 Jan 2023 16:03:26 +0100
Message-Id: <20230122150249.868691719@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Hildenbrand <david@redhat.com>

commit 44f86392bdd165da7e43d3c772aeb1e128ffd6c8 upstream.

We have to update the uffd-wp SWP PTE bit independent of the type of
migration entry.  Currently, if we're unlucky and we want to install/clear
the uffd-wp bit just while we're migrating a read-only mapped hugetlb
page, we would miss to set/clear the uffd-wp bit.

Further, if we're processing a readable-exclusive migration entry and
neither want to set or clear the uffd-wp bit, we could currently end up
losing the uffd-wp bit.  Note that the same would hold for writable
migrating entries, however, having a writable migration entry with the
uffd-wp bit set would already mean that something went wrong.

Note that the change from !is_readable_migration_entry ->
writable_migration_entry is harmless and actually cleaner, as raised by
Miaohe Lin and discussed in [1].

[1] https://lkml.kernel.org/r/90dd6a93-4500-e0de-2bf0-bf522c311b0c@huawei.com

Link: https://lkml.kernel.org/r/20221222205511.675832-3-david@redhat.com
Fixes: 60dfaad65aa9 ("mm/hugetlb: allow uffd wr-protect none ptes")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6627,10 +6627,9 @@ unsigned long hugetlb_change_protection(
 		} else if (unlikely(is_hugetlb_entry_migration(pte))) {
 			swp_entry_t entry = pte_to_swp_entry(pte);
 			struct page *page = pfn_swap_entry_to_page(entry);
+			pte_t newpte = pte;
 
-			if (!is_readable_migration_entry(entry)) {
-				pte_t newpte;
-
+			if (is_writable_migration_entry(entry)) {
 				if (PageAnon(page))
 					entry = make_readable_exclusive_migration_entry(
 								swp_offset(entry));
@@ -6638,13 +6637,15 @@ unsigned long hugetlb_change_protection(
 					entry = make_readable_migration_entry(
 								swp_offset(entry));
 				newpte = swp_entry_to_pte(entry);
-				if (uffd_wp)
-					newpte = pte_swp_mkuffd_wp(newpte);
-				else if (uffd_wp_resolve)
-					newpte = pte_swp_clear_uffd_wp(newpte);
-				set_huge_pte_at(mm, address, ptep, newpte);
 				pages++;
 			}
+
+			if (uffd_wp)
+				newpte = pte_swp_mkuffd_wp(newpte);
+			else if (uffd_wp_resolve)
+				newpte = pte_swp_clear_uffd_wp(newpte);
+			if (!pte_same(pte, newpte))
+				set_huge_pte_at(mm, address, ptep, newpte);
 		} else if (unlikely(is_pte_marker(pte))) {
 			/* No other markers apply for now. */
 			WARN_ON_ONCE(!pte_marker_uffd_wp(pte));


