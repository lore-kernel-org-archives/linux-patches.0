Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0693EB0EF;
	Mon, 17 Aug 2026 13:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974995; cv=none; b=c9jJ+rRcfKkL/FGqndr+j1DigAkMZ75WUNTttYDHDK29ZFAz4TQoPZM09tRlvdCiDjnP5hXMH2gWL5qHBwvEV3w576rTaEhAhM9HpEI70STqegmvN+A7MJoXHLCVwoG6e51fjYdMEzBY/fKQA53MXzan5eqodWosOqAxrR1s9lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974995; c=relaxed/simple;
	bh=mkFVWqreoyAbjYjqFeyw6VAgoxiUhGnUsDKHPOE+YNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L1iX2gFqCXLT6FKV3dr7SczDKwj/St8z5UikXgCr++pchp1wGrMEKDNrmo8O2+JJAOawSpnPCN+jxJfLMiVRNk+gWbt3QxI0Jf9E+gloGLkVxJ4e6jKY7CDlhx2b02g9HFRg5+o7zpFNNTi5l3X76x16erGe8iftBxRQe0ehkk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T5SzIbUg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T5SzIbUg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207A11F00A3D;
	Mon, 17 Aug 2026 13:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974992;
	bh=+4CYO+StzENCeQf6VA/vZybv36pWeKbhYqCdkk9LXHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T5SzIbUg8KZwu7MG2PgQTNqEPRK1embOLh7w2rg3+amggzlgKFo8mFCZOk9OfLqxw
	 ml8qfnmxjJlF29i7959yIVrs2maz5/cUb1MptQBjFpodk1sVrBlQDCLzeQUau3rPyP
	 BLDqz6+5n9YlGx5aqy9Thd+BMb3LH28BMsi2rwuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Kiryl Shutsemau <kas@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	"Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Toshi Kani <toshi.kani@hpe.com>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 126/250] mm/vmalloc: acquire init_mm lock on huge vmap to avoid ptdump UAF
Date: Mon, 17 Aug 2026 15:31:27 +0200
Message-ID: <20260817132541.742842984@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

commit 26444eb71465c9934d9d418ef69c43f61185329b upstream.

Patch series "mm: fix UAF caused by race between ptdump and vmap pgtable
freeing", v6.

Kernel page table walkers fall into two broad categories - those ranges
where no exclusion is required via walk_kernel_page_table_range_lockless()
and those where exclusion is required via walk_kernel_page_table_range()
or walk_page_range_debug().

The former category is used only by arm64 arch code operating on ranges it
both wholly owns and does not concurrently write.

The latter category consists of kernel page table walkers operating on
ranges that are wholly owned (but which need exclusion against concurrent
writers).

The lock used for exclusion is the mmap lock, and for kernel ranges this
is the mmap lock on init_mm.

ptdump is a special case being both the only user of
walk_page_range_debug(), and the only case in which it walks ranges it
does not own.

This presents a problem, as page tables may be freed under ptdump.  And
indeed there is a use-after-free bug in the kernel as a result, which this
series addresses.

vmap promotes page tables to huge leaf entries where possible, freeing the
lower page table when it does.  It does this with no meaningful locks held
against concurrent ptdump walks.

As a result, use-after-free can currently occur.  This series addresses
the issue by having the vmap huge promotion logic acquire the mmap read
lock while both setting the huge page table entry and freeing the prior
leaf page table.

The ptdump code already acquires the mmap write lock, so by doing so we
ensure that the ptdump walker only ever observes either the huge page
table entry or the existing page table entry, and nothing is freed
underneath it.

A mitigation for this issue was already applied for arm64 in commit
fa93b45fd397 ("arm64: Enable vmalloc-huge with ptdump"), which this series
has to deal with carefully.

This mitigation resolves the issue by acquiring the mmap read lock on
init_mm on vmap page table free if a ptdump is in progress.

However the fix in this series would cause a deadlock if we were to simply
apply it for arm64 without also reverting the change.

This is because vmap may acquire the read lock before ptdump attempts to
acquire the write lock, which then gets queued, and rwsem starvation rules
mean that the (unacknowledged) nested mmap read lock in the arm64 code
would also block, meaning the original read lock is never released and
thus deadlock.

This series works around this by #ifndef CONFIG_ARM64'ing the mmap read
lock in vmap logic, then partially reverting commit fa93b45fd397 ("arm64:
Enable vmalloc-huge with ptdump"), keeping the enablement of huge vmap
support, and removing the ifdeffery with the partial revert patch.

There are related issues that are also addressed in this series:

* x86 page attribute logic, specifically Change Page Attributes (CPA),
  implements a feature whereby huge ranges can be collapsed into huge leaf
  entries. This can similarly cause a UAF when done in parallel with a
  ptdump walk, so similarly acquire the init_mm mmap lock to avoid this.

* The CPA logic allows concurrent page table manipulation and CPA
  collapse, meaning the former risks accessing a page table the latter
  frees. Fix this by acquiring mmap write lock on init_mm across the
  whole CPA collapse operation and read lock on the page table
  manipulation.

* x86 and arm64 permit walks of non-kernel mm's (both allowing efi mm
  walks, and in x86's case arbitrary mm's), so we ensure kernel mappings
  remain stable by locking the init_mm as well as the mm being walked.

The ordering of patches is established for both strict dependencies (the
arm64 partial revert in particular has to be done after the vmap changes)
and logical ones (the non-kernel mm fix only makes sense once the vmap/CPA
fixes are in place).


This patch (of 3):

Currently there is a nasty race between ptdump and vmap when attempting to
map a huge P4D, PUD or PMD entry:

* ptdump walks kernel page table ranges it doesn't own.

* When vmap maps ranges it tries to promotes existing ones to huge page
  tables in vmap_try_huge_[p4d,pud,pmd]() at P4D, PUD and PMD level,
  freeing the lower page table in [p4d,pud,pmd]_free_[pud,pmd,pte]_page()
  when it succeeds.

Both of these things can happen at the same time and as a result ptdump
can access a freed page table, resulting in a use-after-free and memory
corruption.

This is possible because while ptdump_walk_pgd() holds both the mem
hotplug lock and the mmap write lock before invoking
walk_page_range_debug(), vmap takes no relevant locks at all.

Fix this by holding the mmap read lock in vmap_try_huge_*() when freeing
page tables.

The read lock is sufficient: ptdump is the only walker that must be
excluded and it holds the mmap write lock.  Other holders of the read lock
may run concurrently, but each exclusively owns the range it operates on
and cannot reach the page tables freed here.

We also hold the lock while assigning the huge page table entry, which
means page table walkers observe only the huge or non-huge page table
entry.

We use a trylock to prevent ptdump from blocking vmap making forward
progress.  This is fine because it's an optimisation in any case, and thus
the vmap can safely proceed regardless.

All other kernel page table walkers that touch vmalloc ranges either
exclusively own the memory walked or acquire the mmap lock, so this
correctly excludes those walkers.

One wrinkle here is commit fa93b45fd397 ("arm64: Enable vmalloc-huge with
ptdump"), which addresses the issue for arm64 only by explicitly acquiring
the mmap read lock on kernel page table freeing should a concurrent ptdump
be in progress.

This is problematic as vmap may acquire the mmap read lock prior to ptdump
attempting to acquire an mmap write lock, leading to a deadlock when the
mmap read lock is slept upon on page table freeing due to rwsem
anti-starvation.

We work around this by predicating the mmap lock being taken on
!CONFIG_ARM64 for the time being.

With this patch applied, a follow up will partially revert commit
fa93b45fd397 ("arm64: Enable vmalloc-huge with ptdump") and at that stage
remove the arm64 ifdeffery.

We also update walk_page_range_debug() to assert the mmap write lock
unconditionally and update the comment here to reflect this change.

The issue has existed as long as ptdump was available and vmap freed page
tables when promoting to a huge leaf entry, that is, since commit
b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page table")
for huge ioremap, and commit 121e6f3258fe ("mm/vmalloc: hugepage vmalloc
mappings") for huge vmalloc.

Since the former is the earlier of the two we choose that for our Fixes
tag.

We also define a guard class for mmap_read_trylock() so we can use
cleanup.h to make the scope handling cleaner in the implementation.

This patch is based on work by David Carlier (linked), with gratitude!

Link: https://lore.kernel.org/20260723-series-vmap-race-fix-v6-0-8cc77dcc0018@kernel.org
Link: https://lore.kernel.org/20260723-series-vmap-race-fix-v6-1-8cc77dcc0018@kernel.org
Fixes: b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page table")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reported-by: syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6a287988.39669fcc.33b062.00a0.GAE@google.com/T/
Link: https://lore.kernel.org/linux-mm/20260706203128.162335-1-devnexen@gmail.com/
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Kiryl Shutsemau <kas@kernel.org>
Cc: <stable@vger.kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mmap_lock.h |    1 
 mm/pagewalk.c             |   22 +++++++++++---------
 mm/vmalloc.c              |   49 +++++++++++++++++++++++++++++++++++++---------
 3 files changed, 53 insertions(+), 19 deletions(-)

--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -397,6 +397,7 @@ static inline void mmap_read_unlock(stru
 
 DEFINE_GUARD(mmap_read_lock, struct mm_struct *,
 	     mmap_read_lock(_T), mmap_read_unlock(_T))
+DEFINE_GUARD_COND(mmap_read_lock, _try, mmap_read_trylock(_T))
 
 static inline void mmap_read_unlock_non_owner(struct mm_struct *mm)
 {
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -678,6 +678,8 @@ int walk_kernel_page_table_range_lockles
  * will also not lock the PTEs for the pte_entry() callback.
  *
  * This is for debugging purposes ONLY.
+ *
+ * The mmap write lock must be held.
  */
 int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
 			  unsigned long end, const struct mm_walk_ops *ops,
@@ -691,6 +693,16 @@ int walk_page_range_debug(struct mm_stru
 		.no_vma		= true
 	};
 
+	/*
+	 * When walking userland page tables, an mmap write lock must be held to
+	 * account for munmap() downgrading to an mmap read lock when tearing
+	 * down page tables.
+	 *
+	 * When walking kernel page tables, an mmap write lock must also be held
+	 * to account for page table freeing on vmap huge page mapping.
+	 */
+	mmap_assert_write_locked(mm);
+
 	/* For convenience, we allow traversal of kernel mappings. */
 	if (mm == &init_mm)
 		return walk_kernel_page_table_range(start, end, ops,
@@ -700,16 +712,6 @@ int walk_page_range_debug(struct mm_stru
 	if (!check_ops_valid(ops))
 		return -EINVAL;
 
-	/*
-	 * The mmap lock protects the page walker from changes to the page
-	 * tables during the walk.  However a read lock is insufficient to
-	 * protect those areas which don't have a VMA as munmap() detaches
-	 * the VMAs before downgrading to a read lock and actually tearing
-	 * down PTEs/page tables. In which case, the mmap write lock should
-	 * be held.
-	 */
-	mmap_assert_write_locked(mm);
-
 	return walk_pgd_range(start, end, &walk);
 }
 
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -43,6 +43,7 @@
 #include <asm/tlbflush.h>
 #include <asm/shmparam.h>
 #include <linux/page_owner.h>
+#include <linux/cleanup.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/vmalloc.h>
@@ -155,10 +156,24 @@ static int vmap_try_huge_pmd(pmd_t *pmd,
 	if (!IS_ALIGNED(phys_addr, PMD_SIZE))
 		return 0;
 
-	if (pmd_present(*pmd) && !pmd_free_pte_page(pmd, addr))
-		return 0;
+	if (!pmd_present(*pmd))
+		return pmd_set_huge(pmd, phys_addr, prot);
 
-	return pmd_set_huge(pmd, phys_addr, prot);
+	/*
+	 * Acquire the mmap read lock to exclude ptdump, which walks
+	 * kernel page tables it does not own under the mmap write lock.
+	 *
+	 * Concurrent read lock holders are safe: each exclusively owns
+	 * the range it operates on and cannot reach this page table.
+	 */
+#ifndef CONFIG_ARM64
+	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm)
+#endif
+	{
+		if (!pmd_free_pte_page(pmd, addr))
+			return 0;
+		return pmd_set_huge(pmd, phys_addr, prot);
+	}
 }
 
 static int vmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
@@ -205,10 +220,18 @@ static int vmap_try_huge_pud(pud_t *pud,
 	if (!IS_ALIGNED(phys_addr, PUD_SIZE))
 		return 0;
 
-	if (pud_present(*pud) && !pud_free_pmd_page(pud, addr))
-		return 0;
+	if (!pud_present(*pud))
+		return pud_set_huge(pud, phys_addr, prot);
 
-	return pud_set_huge(pud, phys_addr, prot);
+	/* See comment in vmap_try_huge_pmd(). */
+#ifndef CONFIG_ARM64
+	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm)
+#endif
+	{
+		if (!pud_free_pmd_page(pud, addr))
+			return 0;
+		return pud_set_huge(pud, phys_addr, prot);
+	}
 }
 
 static int vmap_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
@@ -256,10 +279,18 @@ static int vmap_try_huge_p4d(p4d_t *p4d,
 	if (!IS_ALIGNED(phys_addr, P4D_SIZE))
 		return 0;
 
-	if (p4d_present(*p4d) && !p4d_free_pud_page(p4d, addr))
-		return 0;
+	if (!p4d_present(*p4d))
+		return p4d_set_huge(p4d, phys_addr, prot);
 
-	return p4d_set_huge(p4d, phys_addr, prot);
+	/* See comment in vmap_try_huge_pmd(). */
+#ifndef CONFIG_ARM64
+	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm)
+#endif
+	{
+		if (!p4d_free_pud_page(p4d, addr))
+			return 0;
+		return p4d_set_huge(p4d, phys_addr, prot);
+	}
 }
 
 static int vmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,


