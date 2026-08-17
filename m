Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFE72E7BD6;
	Mon, 17 Aug 2026 15:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980169; cv=none; b=C1ldalkeaJCyjSiU2YPFuQQ3UrtTStip5bGo74ASI/hLJYbp8AShfzHyoqC9PEuD15iJDccIIcunKqiVpoLQiZk1RAZYbPaRnrYZbGUesVxXFdYxodheVUMQxx4cIpujsrB+qlwtHceKa3ucypLTwZ01gNNRL70N1jkF0K6mNkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980169; c=relaxed/simple;
	bh=n8QgaRuW9GCRq23aHdg1bfvJXy9G7xRIqHlw5cJdgMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYO07qHXHNAIjyXt7Kt+4j45Zj/rq8sMS/KI7vMKUUHMkSNWqYdvcmH/csIFPJwv6aLCC8gRWENbqW+R033ld28w0tXrqMd4uVGsx/PnTcNYWu3gtHdGmIFAbjH4WbVd31wqQ3kqim4kDULAbinznB+Gk6N7bXKzeTkRjJPVbGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kHekezGx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kHekezGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538951F000E9;
	Mon, 17 Aug 2026 15:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980166;
	bh=3PY8d7U0yG/Iu86/i3oH9tQOIXhjKIELfa+GyHoJQ+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kHekezGxMV+pH8dbxx7hURCKBMaDOYe10kjoyRcc9Amhymza9eFJ+e0i5O/iWB5bN
	 Bfi+oOJdHwYCxSYLqZUfPsm9T4LLGdVJMkArHcCaZ6wTF+VujVUfBaxKNiY8MDaDCl
	 NEoSkWc2fv5uN3dKANtBoGiB/ojeIBZFOrK8b6wE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiryl Shutsemau <kas@kernel.org>,
	Sashiko AI review <sashiko-bot@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 478/609] mm/hugetlb: fix swap entry corruption when clearing uffd-wp at fork()
Date: Mon, 17 Aug 2026 15:32:54 +0200
Message-ID: <20260817132559.943790390@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiryl Shutsemau (Meta) <kas@kernel.org>

[ Upstream commit 83abe2fd5b3aeb3123b5408a5a91709c5538fb23 ]

copy_hugetlb_page_range() clears the uffd-wp bit of migration and hwpoison
entries with huge_pte_clear_uffd_wp(), which operates on the present-PTE
bit position.  Swap entries keep the uffd-wp state elsewhere -- the
migration branch reads and sets it with pte_swp_uffd_wp() and
pte_swp_mkuffd_wp() -- and the present-PTE position falls into the swap
payload.  On x86-64 it lands in the inverted swap offset, where a
naturally-aligned hugetlb PFN always has the affected bit set, so the
clear advances the encoded PFN by two pages.

No userfaultfd needs to be involved: the clear is guarded only by the
child VMA not being uffd-wp registered, so a plain fork() with an
in-flight hugetlb migration entry (or a poisoned hugetlb page) corrupts
the entry copied into the child.  Instrumenting the clear and forking
after MADV_HWPOISON on a 2MB anon hugetlb page shows:

  offset before=120e00
  offset after =120e02

The fallout is mostly latent: rmap walks match migration entries by folio
range and remove_migration_pte() rebuilds the PTE from the folio, so a
within-folio PFN skew heals once migration completes.  But any path that
re-encodes the corrupted offset -- e.g.  hugetlb_change_protection()
rewriting a writable migration entry via
make_readable_migration_entry(swp_offset(entry)) -- propagates it.

Migration entries legitimately carry uffd-wp, so clear it with
pte_swp_clear_uffd_wp(), matching copy_nonpresent_pte() and
move_huge_pte().

A hwpoison entry, on the other hand, never carries the uffd-wp bit: it is
installed fresh by make_hwpoison_entry() (try_to_unmap_one() does not
preserve uffd-wp on the hwpoison path) and hugetlb_change_protection()
leaves hwpoison entries untouched.  There was nothing to clear there, only
the corruption, so drop the clear entirely.

Link: https://lore.kernel.org/20260708090110.136162-1-kirill@shutemov.name
Fixes: bc70fbf269fd ("mm/hugetlb: handle uffd-wp during fork()")
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260703140011.99E601F000E9@smtp.kernel.org/
Suggested-by: David Hildenbrand <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: Claude:claude-fable-5
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit 83abe2fd5b3aeb3123b5408a5a91709c5538fb23)
[ kas: 6.1 predates the huge_pte_*uffd_wp() -> pte_swp_*uffd_wp()
  conversion in copy_hugetlb_page_range() (commit 5a2f8d22ace4), so apply
  the fix inline: convert the migration branch's uffd-wp read and set to
  the swap-position helpers too, otherwise the src re-encode
  (huge_pte_mkuffd_wp) corrupts the offset the same way; and drop the
  hwpoison clear ]
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c7683d00584fd..ffe5196b4afa6 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5106,14 +5106,16 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 			 */
 			;
 		} else if (unlikely(is_hugetlb_entry_hwpoisoned(entry))) {
-			bool uffd_wp = huge_pte_uffd_wp(entry);
-
-			if (!userfaultfd_wp(dst_vma) && uffd_wp)
-				entry = huge_pte_clear_uffd_wp(entry);
+			/*
+			 * A hwpoison entry never carries the uffd-wp bit: it is
+			 * installed fresh by make_hwpoison_entry() and
+			 * hugetlb_change_protection() leaves it untouched, so
+			 * there is nothing to clear for the child.
+			 */
 			set_huge_pte_at(dst, addr, dst_pte, entry);
 		} else if (unlikely(is_hugetlb_entry_migration(entry))) {
 			swp_entry_t swp_entry = pte_to_swp_entry(entry);
-			bool uffd_wp = huge_pte_uffd_wp(entry);
+			bool uffd_wp = pte_swp_uffd_wp(entry);
 
 			if (!is_readable_migration_entry(swp_entry) && cow) {
 				/*
@@ -5124,11 +5126,11 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 							swp_offset(swp_entry));
 				entry = swp_entry_to_pte(swp_entry);
 				if (userfaultfd_wp(src_vma) && uffd_wp)
-					entry = huge_pte_mkuffd_wp(entry);
+					entry = pte_swp_mkuffd_wp(entry);
 				set_huge_pte_at(src, addr, src_pte, entry);
 			}
-			if (!userfaultfd_wp(dst_vma) && uffd_wp)
-				entry = huge_pte_clear_uffd_wp(entry);
+			if (!userfaultfd_wp(dst_vma))
+				entry = pte_swp_clear_uffd_wp(entry);
 			set_huge_pte_at(dst, addr, dst_pte, entry);
 		} else if (unlikely(is_pte_marker(entry))) {
 			/*
-- 
2.53.0



