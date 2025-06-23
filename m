Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AB54409;
	Mon, 23 Jun 2025 22:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716068; cv=none; b=rdOF0Z0Gtzab5cuRj5UE0Yao7zjUISF/kcmBCynl24Ui+cjSdqiTOQsYrsZet67EM0egFKwMTP8tmfYQTEtPw0xOkJq4DJGa5eKYIziJXAZx19AJsIZ8LLii+oJOrtpu9U/JlbGe2iY0FN0HjMzSmJM1AvyfiUo81gmor7zZWFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716068; c=relaxed/simple;
	bh=SEG+aemVMWbwLN/kobM9AQsrHD/2TNyktbtR9pxiWmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XagzBDIDZwJtb9cY5BFmQqjw19/mfKTESR5p9MRSK2dZjTJHt2a+sxuTfUUJFQogonFDgCHGxvsKPiIruUDrVHIYdGvVaO7p2x3PX4HDQ8NPN0ms8PcYfVUt8LnCeC72639BnV6jSV2VGFF6IGusgfpC6CsjatWqBRtlxLpLNe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSfFTxzb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSfFTxzb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21627C4CEEA;
	Mon, 23 Jun 2025 22:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716068;
	bh=SEG+aemVMWbwLN/kobM9AQsrHD/2TNyktbtR9pxiWmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MSfFTxzbBKTbrh4yHagkEtdCqUyX/QMSiWt71B9qqfHZbBUks4NMm9eiKZrvQTEly
	 rIHrdSi/tvJ+APU4PR8MwRnf3foqQ4DI30Mf/OQe2mnQocBg8AMXUWBC/RfLVG+/tw
	 0hc+hM3hj/lf13tueVna8NLMDw2xx81bgjn8CxGk=
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
Subject: [PATCH 6.6 238/290] mm/huge_memory: fix dereferencing invalid pmd migration entry
Date: Mon, 23 Jun 2025 15:08:19 +0200
Message-ID: <20250623130634.082100330@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[gavin: backport the migration checking logic to __split_huge_pmd]
Signed-off-by: Gavin Guo <gavinguo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2260,12 +2260,14 @@ void __split_huge_pmd(struct vm_area_str
 {
 	spinlock_t *ptl;
 	struct mmu_notifier_range range;
+	bool pmd_migration;
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
 				address & HPAGE_PMD_MASK,
 				(address & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
 	ptl = pmd_lock(vma->vm_mm, pmd);
+	pmd_migration = is_pmd_migration_entry(*pmd);
 
 	/*
 	 * If caller asks to setup a migration entry, we need a folio to check
@@ -2274,13 +2276,12 @@ void __split_huge_pmd(struct vm_area_str
 	VM_BUG_ON(freeze && !folio);
 	VM_WARN_ON_ONCE(folio && !folio_test_locked(folio));
 
-	if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd) ||
-	    is_pmd_migration_entry(*pmd)) {
+	if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd) || pmd_migration) {
 		/*
-		 * It's safe to call pmd_page when folio is set because it's
-		 * guaranteed that pmd is present.
+		 * Do not apply pmd_folio() to a migration entry; and folio lock
+		 * guarantees that it must be of the wrong folio anyway.
 		 */
-		if (folio && folio != page_folio(pmd_page(*pmd)))
+		if (folio && (pmd_migration || folio != page_folio(pmd_page(*pmd))))
 			goto out;
 		__split_huge_pmd_locked(vma, pmd, range.start, freeze);
 	}


