Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C56A40315B;
	Tue, 21 Jul 2026 17:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654501; cv=none; b=nHFFIcNqPkaak/bZqYpGFd5x+Wclm01//wtC2TsVk7Rja/SE3oceNAAnrj5cLBkfDUavUnA3OtQrph9vSWwHtFSf2rE5Uk7cXXwI2ytDoL493d1DmxlaVnsIo158BpnFqx56mydxwoI4ejf5IFpC/s6pfRPuJcGoYglOYwqDJsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654501; c=relaxed/simple;
	bh=3HCUtW2SRPGcFZw/IoHCtpVicX13zOAVYuq19+TwMVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OSbM6EFltQKqstGtvVMEDk/py2qiQkm8CMoqyt4n8T+blk0jW5yCBLZJOK2IhJ+YMA2yNGTbkt55+1lHTeUQ6aao1bmvcY7kWglVDg7KNhfw+6B4vSfekKiESmpvoDYfe03kLTn3G+F1WwEiUiDg82WWVtx1R6gZjLjkbszpBfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OMvOBSmS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OMvOBSmS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4FE1F000E9;
	Tue, 21 Jul 2026 17:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654499;
	bh=XK2mWocdomJwQK7sJaQ9zB8c821K5kTgyWOIfNQbJHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OMvOBSmSYAjuqX0rahDmmwXf1bcPK5X1nzkq6y1fPmMrVSrOwtlaHShuwtQDCbUXi
	 qqugcI93dLpGlrhQcW5dWjroeZqCbeWBfgmKM43CqpF03Tcqm58liP0a1HdOi+3ovZ
	 H8L79QzN5tABh4oSK5KxrU3jPL7pHu4qk76oUT08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiryl Shutsemau <kas@kernel.org>,
	Sashiko AI review <sashiko-bot@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Balbir Singh <balbirs@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 1728/2077] fs/proc/task_mmu: fix make_uffd_wp_huge_pte() prot-update race
Date: Tue, 21 Jul 2026 17:23:21 +0200
Message-ID: <20260721152633.509079532@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiryl Shutsemau (Meta) <kas@kernel.org>

commit 04718f7c9290f95385f0dd328758753dc1c36dec upstream.

Patch series "userfaultfd/pagemap: pre-existing fixes".

These are pre-existing bug fixes that were carried at the front of the
userfaultfd RWP working-set-tracking series up to v5 [1].  Per review
feedback that fixes should not sit in the middle of a feature series, they
are split out and sent on their own; the RWP series is reposted rebased on
top of this.

All six were flagged by the Sashiko AI review of the RWP series and carry
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>.  They are
independent of RWP, apply to mm-new directly, and carry Cc: stable@.

  1: fs/proc/task_mmu: a missing huge_ptep_modify_prot_start() in
     make_uffd_wp_huge_pte() can lose hardware Dirty/Accessed updates
     when PAGEMAP_SCAN write-protects a hugetlb PTE.

  2: fs/proc/task_mmu: pagemap_scan_hugetlb_entry() compares the range
     against HPAGE_SIZE rather than the hstate page size, so it never
     write-protects gigantic hugetlb pages.

  3: fs/proc/task_mmu: PAGEMAP_SCAN with PM_SCAN_WP_MATCHING over an
     unpopulated hugetlb range self-deadlocks -- pagemap_scan_pte_hole()
     calls uffd_wp_range() while walk_hugetlb_range() holds the hugetlb
     vma lock for read, and hugetlb_change_protection() then takes it
     for write. Install the marker inline instead.

  4: mm/huge_memory: change_non_present_huge_pmd() drops pmd_swp_uffd_wp
     on a device-private PMD permission downgrade, silently losing the
     uffd-wp marker.

  5: userfaultfd: must_wait() applies pte_write() to a locklessly read
     PTE without checking pte_present(), so swap/migration entries
     decode random offset bits and a thread can stay parked on a stale
     fault.

  6: userfaultfd: __VMA_UFFD_FLAGS feeds VMA_UFFD_MINOR_BIT (41) to
     mk_vma_flags() unconditionally, an out-of-bounds write into the
     single-word vma_flags_t on 32-bit. Build the mask from config-gated
     per-mode masks so an unavailable bit is never materialised.


This patch (of 6):

make_uffd_wp_huge_pte() arms the UFFD_WP bit on a present HugeTLB PTE by
calling huge_ptep_modify_prot_commit() with a ptent snapshot that was
fetched without the corresponding huge_ptep_modify_prot_start().  The
start helper is what atomically clears the entry so the kernel-owned
snapshot stays consistent until the commit; without it, the hardware may
set Dirty or Accessed in the live PTE between the original read and the
commit, and huge_ptep_modify_prot_commit() (whose generic implementation
just calls set_huge_pte_at()) then writes the stale snapshot back over the
live hardware bits, losing the update.

The non-hugetlb sibling make_uffd_wp_pte() does this correctly via
ptep_modify_prot_start() / ptep_modify_prot_commit().  Mirror that pattern
for the present-PTE branch.  The migration case stays as-is -- migration
entries are non-present, so there's no hardware update to race against.

Link: https://lore.kernel.org/20260529172331.356655-1-kas@kernel.org
Link: https://lore.kernel.org/20260529172331.356655-2-kas@kernel.org
Link: https://lore.kernel.org/all/20260526130509.2748441-1-kirill@shutemov.name/ [1]
Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/task_mmu.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2523,12 +2523,16 @@ static void make_uffd_wp_huge_pte(struct
 	if (softleaf_is_hwpoison(entry) || softleaf_is_marker(entry))
 		return;
 
-	if (softleaf_is_migration(entry))
+	if (softleaf_is_migration(entry)) {
 		set_huge_pte_at(vma->vm_mm, addr, ptep,
 				pte_swp_mkuffd_wp(ptent), psize);
-	else
-		huge_ptep_modify_prot_commit(vma, addr, ptep, ptent,
-					     huge_pte_mkuffd_wp(ptent));
+	} else {
+		pte_t old_pte, new_pte;
+
+		old_pte = huge_ptep_modify_prot_start(vma, addr, ptep);
+		new_pte = huge_pte_mkuffd_wp(old_pte);
+		huge_ptep_modify_prot_commit(vma, addr, ptep, old_pte, new_pte);
+	}
 }
 #endif /* CONFIG_HUGETLB_PAGE */
 


