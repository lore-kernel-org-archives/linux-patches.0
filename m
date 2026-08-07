Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE4546C4B0;
	Fri,  7 Aug 2026 15:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115149; cv=none; b=aP57V4pZBinE5ff4PFjm9qOdF+arV7w7xSHBfAIeW164Uu92cfFWIU8LUwUL5Z4P/g6y19a3WAt68/ubtr9hRRfJLCEqM4VLCZSZGkLsSXRff3eMfBcIKV8iy5vk7hKqeOQ7gAXk2xDKLFS139H/uvgNG/BMCd/S/ejMBwsTpLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115149; c=relaxed/simple;
	bh=zAvra07XjkQCyLh7JmaFzHkB38EGOPXyqljdgQ7SP5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wk0Z/eHgFwzG0lotsvJdgbbxvUhiRCiAUZMFFYG3sUrFEkBBWtrAmq3MKUOtxm7/DqtjXt+ji2wmbyoiBla3vCIrM34BFhLcFmUVp28s5b1seeUdBWYKqUlw/jGb2+UzrEAmItAuxKVwhLwCfxK3aRKxGXXXHYBhTxsA3O+oaUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YT7zPCRW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YT7zPCRW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EBCB1F000E9;
	Fri,  7 Aug 2026 15:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115144;
	bh=MFpY/6oJWaYgRtqL+fqMX2ZyOfi1kn9QV1r295Lphr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YT7zPCRWgG3lOsoc90wmhb89xFHGm5JIivQQX7vG2aG4vFEFut9atAROtIL2TWYpC
	 4R4+cGoDEyrKrBUhvgZGJAFZzSX4uwGszbf/vtOy3KLsjNlzxFHwfZpD5/Cc2a6VBo
	 ryl8K6frterCRysTVmUxyZ4EQQKac3NJB3gX/xMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiryl Shutsemau <kas@kernel.org>,
	Sashiko AI review <sashiko-bot@kernel.org>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Jann Horn <jannh@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 172/396] fs/proc/task_mmu: fix PAGEMAP_SCAN written state for PMD holes
Date: Fri,  7 Aug 2026 16:35:32 +0200
Message-ID: <20260807143428.011302747@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Kiryl Shutsemau (Meta) <kas@kernel.org>

commit 40de8160ca7f67d14619ee0351ce5d68fc4a237a upstream.

PAGEMAP_SCAN reports an unpopulated PTE in a uffd-wp VMA as written, but a
range with no page table at all -- a PMD hole -- is skipped:
pagemap_scan_pte_hole() tests p->cur_vma_category, which never carries
PAGE_IS_WRITTEN, so the hole is neither reported nor (under
PM_SCAN_WP_MATCHING) armed.

In a uffd-wp VMA, WP_UNPOPULATED installs uffd-wp markers when protecting
a range, allocating page tables as needed, so an unpopulated slot is
treated as written -- see the pte_none() handling in
pagemap_page_category().  A missing marker therefore means the range was
zapped, e.g.  via MADV_DONTNEED.  This applies to anon and shmem VMAs.

An anonymous THP is write-protected in place as a huge PMD, so a full-PMD
MADV_DONTNEED clears it to pmd_none -- a hole with no page table -- and
pagemap_scan_pte_hole() misses it.  For a MAP_PRIVATE|MAP_ANON mapping
MADV_DONTNEED has fill-with-zeros semantics, so a write-tracking
checkpoint/migration tool (e.g.  CRIU) treats the range as unchanged and
keeps its previous contents; after restore or live migration the process
reads stale data instead of zeroes -- data corruption.

Report a hole in a non-hugetlb uffd-wp VMA as written, matching the
pte_none handling in pagemap_page_category(); the existing
PM_SCAN_WP_MATCHING path then arms it via uffd_wp_range().

hugetlb is excluded: pagemap_hugetlb_category() reports an empty hugetlb
entry (huge_pte_none) as not-written, unlike pagemap_page_category(),
which reports pte_none as written.  pagemap_scan_pte_hole() fires for a
hugetlb slot only when it has no page table; keeping that not-written
matches how an allocated-but-empty hugetlb entry reads, so the hole and
the empty-entry cases agree within the VMA.

Link: https://lore.kernel.org/20260715144234.442721-2-kirill@shutemov.name
Fixes: 2bad466cc9d9 ("mm/uffd: UFFD_FEATURE_WP_UNPOPULATED")
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260707151349.92143-1-kirill@shutemov.name
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zenghui Yu <zenghui.yu@linux.dev>
Assisted-by: Claude:claude-fable-5
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/task_mmu.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2918,12 +2918,28 @@ static int pagemap_scan_pte_hole(unsigne
 {
 	struct pagemap_scan_private *p = walk->private;
 	struct vm_area_struct *vma = walk->vma;
+	unsigned long categories;
 	int ret, err;
 
-	if (!vma || !pagemap_scan_is_interesting_page(p->cur_vma_category, p))
+	if (!vma)
 		return 0;
 
-	ret = pagemap_scan_output(p->cur_vma_category, p, addr, &end);
+	/*
+	 * In a uffd-wp VMA an unpopulated range is treated as written:
+	 * uffd-wp registration populates page tables and installs markers
+	 * with WP_UNPOPULATED, so a missing marker means the range was
+	 * zapped. See the pte_none() handling in pagemap_page_category().
+	 *
+	 * hugetlb differs, see pagemap_hugetlb_category().
+	 */
+	categories = p->cur_vma_category;
+	if (userfaultfd_wp(vma) && !is_vm_hugetlb_page(vma))
+		categories |= PAGE_IS_WRITTEN;
+
+	if (!pagemap_scan_is_interesting_page(categories, p))
+		return 0;
+
+	ret = pagemap_scan_output(categories, p, addr, &end);
 	if (addr == end)
 		return ret;
 


