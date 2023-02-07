Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7A52C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51137C433EF;
	Tue,  7 Feb 2023 13:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775198;
	bh=i2h5QWv1pKWSJYkxbpOEQbmV6AZdrWL5NEdW9AwPDLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oHFo388V8uOAfZE60S8RSyjwf4IPK6L2szSGeX1b49bS8uKlaDrnV87aDNbbhC1aW
	 pv6k9OK95MqtxAQ+aaTGsCrFxesLbAcW1k5gC+xC3DOrcKfLd0FP6hQ1KywLl7LMib
	 HF9epF+oG4y6MVkzA5wkO16MZU2Py8QTwKUZfMS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Zach OKeefe <zokeefe@google.com>,
	"Kirill A. Shutemov" <kirill.shutemov@intel.linux.com>,
	Yang Shi <shy828301@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 169/208] mm/khugepaged: fix ->anon_vma race
Date: Tue,  7 Feb 2023 13:57:03 +0100
Message-Id: <20230207125642.069846036@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/khugepaged.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1649,7 +1649,7 @@ static int retract_page_tables(struct ad
 		 * has higher cost too. It would also probably require locking
 		 * the anon_vma.
 		 */
-		if (vma->anon_vma) {
+		if (READ_ONCE(vma->anon_vma)) {
 			result = SCAN_PAGE_ANON;
 			goto next;
 		}
@@ -1678,6 +1678,18 @@ static int retract_page_tables(struct ad
 		if ((cc->is_khugepaged || is_target) &&
 		    mmap_write_trylock(mm)) {
 			/*
+			 * Re-check whether we have an ->anon_vma, because
+			 * collapse_and_free_pmd() requires that either no
+			 * ->anon_vma exists or the anon_vma is locked.
+			 * We already checked ->anon_vma above, but that check
+			 * is racy because ->anon_vma can be populated under the
+			 * mmap lock in read mode.
+			 */
+			if (vma->anon_vma) {
+				result = SCAN_PAGE_ANON;
+				goto unlock_next;
+			}
+			/*
 			 * When a vma is registered with uffd-wp, we can't
 			 * recycle the pmd pgtable because there can be pte
 			 * markers installed.  Skip it only, so the rest mm/vma


