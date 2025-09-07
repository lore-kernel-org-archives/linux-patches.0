Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759CE1CDFAC;
	Sun,  7 Sep 2025 20:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275671; cv=none; b=pQmzJFGnoyKikEexmdp3oW7cbynOvJGPTpb/Isur1XWE93BuE+7vefm/3f4PUYo0LhHB5Gmq0/niAdp2X5T4FD+Ngd6QXZraxpd4ew/xXsEs12ee5ClnscnP19Dlk5a23iCD9m9BWZjOv/K16C2wkaUGXFzhYaYUUrE1lHLOFZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275671; c=relaxed/simple;
	bh=19YQuDzu+JKlanDCTHkAcXkHPrzBMxmUVGRQaByYBvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L9YdKAEK2UCfnkYriFaG3lAA+3AnrMpgerAaYsnPfb57m/mCsfJ3jRkLzVu1vGIeB5aoA9Jy/BDAcpWvK7GHDqEoHIYG6yw5n6LxLBOxNkBKcrDKL+oq/wiHI2i0/PqwoFPsJXeBIju3ausFRJX/Emvc57/AbWWfGHZeCLaz/uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yN9ipPrk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yN9ipPrk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC541C4CEF0;
	Sun,  7 Sep 2025 20:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275671;
	bh=19YQuDzu+JKlanDCTHkAcXkHPrzBMxmUVGRQaByYBvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yN9ipPrkDVLOxw8CuMDE7STgc0aEgBLE2WKpSwfWPkAfcP1VWBk8UYdbUhYrpr8Kk
	 PqlLKDj7cFpVyVRoChvAX9EiFflDfF9wuDUmALsKsoR8sMIQCF7SJej0OSozCHuiFX
	 ZuydDgR80G22jJhfULusyXRtwooHL2F5+lWj3eFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Zach OKeefe <zokeefe@google.com>,
	"Kirill A. Shutemov" <kirill.shutemov@intel.linux.com>,
	Yang Shi <shy828301@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjoern Doebel <doebel@amazon.de>
Subject: [PATCH 5.10 27/52] mm/khugepaged: fix ->anon_vma race
Date: Sun,  7 Sep 2025 21:57:47 +0200
Message-ID: <20250907195602.778434893@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195601.957051083@linuxfoundation.org>
References: <20250907195601.957051083@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit 023f47a8250c6bdb4aebe744db4bf7f73414028b upstream.

If an ->anon_vma is attached to the VMA, collapse_and_free_pmd() requires
it to be locked.

Page table traversal is allowed under any one of the mmap lock, the
anon_vma lock (if the VMA is associated with an anon_vma), and the
mapping lock (if the VMA is associated with a mapping); and so to be
able to remove page tables, we must hold all three of them.
retract_page_tables() bails out if an ->anon_vma is attached, but does
this check before holding the mmap lock (as the comment above the check
explains).

If we racily merged an existing ->anon_vma (shared with a child
process) from a neighboring VMA, subsequent rmap traversals on pages
belonging to the child will be able to see the page tables that we are
concurrently removing while assuming that nothing else can access them.

Repeat the ->anon_vma check once we hold the mmap lock to ensure that
there really is no concurrent page table access.

Hitting this bug causes a lockdep warning in collapse_and_free_pmd(),
in the line "lockdep_assert_held_write(&vma->anon_vma->root->rwsem)".
It can also lead to use-after-free access.

Link: https://lore.kernel.org/linux-mm/CAG48ez3434wZBKFFbdx4M9j6eUwSUVPd4dxhzW_k_POneSDF+A@mail.gmail.com/
Link: https://lkml.kernel.org/r/20230111133351.807024-1-jannh@google.com
Fixes: f3f0e1d2150b ("khugepaged: add support of collapse for tmpfs/shmem pages")
Signed-off-by: Jann Horn <jannh@google.com>
Reported-by: Zach O'Keefe <zokeefe@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@intel.linux.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[doebel@amazon.de: Kernel 5.10 uses different control flow pattern,
    context adjustments]
Signed-off-by: Bjoern Doebel <doebel@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/khugepaged.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1611,7 +1611,7 @@ static void retract_page_tables(struct a
 		 * has higher cost too. It would also probably require locking
 		 * the anon_vma.
 		 */
-		if (vma->anon_vma)
+		if (READ_ONCE(vma->anon_vma))
 			continue;
 		addr = vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
 		if (addr & ~HPAGE_PMD_MASK)
@@ -1633,6 +1633,19 @@ static void retract_page_tables(struct a
 			if (!khugepaged_test_exit(mm)) {
 				struct mmu_notifier_range range;
 
+				/*
+				 * Re-check whether we have an ->anon_vma, because
+				 * collapse_and_free_pmd() requires that either no
+				 * ->anon_vma exists or the anon_vma is locked.
+				 * We already checked ->anon_vma above, but that check
+				 * is racy because ->anon_vma can be populated under the
+				 * mmap lock in read mode.
+				 */
+				if (vma->anon_vma) {
+					mmap_write_unlock(mm);
+					continue;
+				}
+
 				mmu_notifier_range_init(&range,
 							MMU_NOTIFY_CLEAR, 0,
 							NULL, mm, addr,


