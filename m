Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0266D1519B8;
	Mon, 12 May 2025 18:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072850; cv=none; b=jE+xVmLS6twgYUa8cmipfgeKnVxLcDfABMiGFw08XMfmWGkSKBp2xYq10vH2wSj1m6nvuwzFi0bFOg0ecF6U7b1yzngp3m8xQVnbROei+k34SK0WEB+6MnhNRyeLwQqbc7U1L7p6PT51sSPhfCENNiXipBPRVtJZx1pbsH8go28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072850; c=relaxed/simple;
	bh=dv3vmSjrjAgitL390wiM0Y1WMtm0d6LDuMHD86z8U7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IgVAGe3nFoy2iUxRLbkuXySAKOm3NO/sV9vC6+spx97gU2XQYnVreNxYwDzDX+5nEFwsFFg/tHgxfYnjb6cCI9BRmVH82/sh9UkTsELWYAc/VcLFmUua4o1xoWX4mWRBqF6kr7jWFmqpdObEYKTtHnDtR9E3IPsxfIL3op1hgXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UAt8VJrN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UAt8VJrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE7DFC4CEE7;
	Mon, 12 May 2025 18:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072849;
	bh=dv3vmSjrjAgitL390wiM0Y1WMtm0d6LDuMHD86z8U7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UAt8VJrNJWLxiJMSYK/fZGEWILwT2o5dAfDZtIrdVBRpfFhtoXAgT5Vq0xlnQV4tX
	 I9VDzdNzBaytYlsHB3hiBTTO/N8lbZv0r8/l+z2BgnmdR8S9GHQqWWqiHDvxhS+aNq
	 o8ciBJoFX6XKuHSj0wl13HwepxnliOv7Fk2M/HgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gavin Guo <gavinguo@igalia.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Gavin Shan <gshan@redhat.com>,
	Florent Revest <revest@google.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 075/184] mm/huge_memory: fix dereferencing invalid pmd migration entry
Date: Mon, 12 May 2025 19:44:36 +0200
Message-ID: <20250512172044.883288720@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

From: Gavin Guo <gavinguo@igalia.com>

commit be6e843fc51a584672dfd9c4a6a24c8cb81d5fb7 upstream.

When migrating a THP, concurrent access to the PMD migration entry during
a deferred split scan can lead to an invalid address access, as
illustrated below.  To prevent this invalid access, it is necessary to
check the PMD migration entry and return early.  In this context, there is
no need to use pmd_to_swp_entry and pfn_swap_entry_to_page to verify the
equality of the target folio.  Since the PMD migration entry is locked, it
cannot be served as the target.

Mailing list discussion and explanation from Hugh Dickins: "An anon_vma
lookup points to a location which may contain the folio of interest, but
might instead contain another folio: and weeding out those other folios is
precisely what the "folio != pmd_folio((*pmd)" check (and the "risk of
replacing the wrong folio" comment a few lines above it) is for."

BUG: unable to handle page fault for address: ffffea60001db008
CPU: 0 UID: 0 PID: 2199114 Comm: tee Not tainted 6.14.0+ #4 NONE
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:split_huge_pmd_locked+0x3b5/0x2b60
Call Trace:
<TASK>
try_to_migrate_one+0x28c/0x3730
rmap_walk_anon+0x4f6/0x770
unmap_folio+0x196/0x1f0
split_huge_page_to_list_to_order+0x9f6/0x1560
deferred_split_scan+0xac5/0x12a0
shrinker_debugfs_scan_write+0x376/0x470
full_proxy_write+0x15c/0x220
vfs_write+0x2fc/0xcb0
ksys_write+0x146/0x250
do_syscall_64+0x6a/0x120
entry_SYSCALL_64_after_hwframe+0x76/0x7e

The bug is found by syzkaller on an internal kernel, then confirmed on
upstream.

Link: https://lkml.kernel.org/r/20250421113536.3682201-1-gavinguo@igalia.com
Link: https://lore.kernel.org/all/20250414072737.1698513-1-gavinguo@igalia.com/
Link: https://lore.kernel.org/all/20250418085802.2973519-1-gavinguo@igalia.com/
Fixes: 84c3fc4e9c56 ("mm: thp: check pmd migration entry in common path")
Signed-off-by: Gavin Guo <gavinguo@igalia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Cc: Florent Revest <revest@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2879,6 +2879,8 @@ static void __split_huge_pmd_locked(stru
 void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
 			   pmd_t *pmd, bool freeze, struct folio *folio)
 {
+	bool pmd_migration = is_pmd_migration_entry(*pmd);
+
 	VM_WARN_ON_ONCE(folio && !folio_test_pmd_mappable(folio));
 	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PMD_SIZE));
 	VM_WARN_ON_ONCE(folio && !folio_test_locked(folio));
@@ -2889,9 +2891,12 @@ void split_huge_pmd_locked(struct vm_are
 	 * require a folio to check the PMD against. Otherwise, there
 	 * is a risk of replacing the wrong folio.
 	 */
-	if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd) ||
-	    is_pmd_migration_entry(*pmd)) {
-		if (folio && folio != pmd_folio(*pmd))
+	if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd) || pmd_migration) {
+		/*
+		 * Do not apply pmd_folio() to a migration entry; and folio lock
+		 * guarantees that it must be of the wrong folio anyway.
+		 */
+		if (folio && (pmd_migration || folio != pmd_folio(*pmd)))
 			return;
 		__split_huge_pmd_locked(vma, pmd, address, freeze);
 	}


