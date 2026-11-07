Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061897;
	b=4g9j3fIy9eYUtyDQMaCNFVDT6lejHLChs7MdL1MnfLeC0IYUVnE3GrSuJn0KgUYgvVSB
	 w5MEAp6u5RCd/BFRzU8Pou8YGMjwbEQzEuPJ5Or9fkHWQZzHtMVyC1Xn/Uxm9ClqjOnoR
	 sXMtyqo7fmrQP/+fWD4vkFXMrfiZEkKKUuWMGM5GdtfbsAqkCG4Nk4NF1JN79fGBN2RH2
	 CDonXCJqPxJmM/BOi05/RA1yqJAc+BplJnRDVnuv17HyXUaX5K2urziA2Vz5oqCGgRXBM
	 TR0jnUBtRJfJsbu9bxZG9XnuVjP1bnzBxHKkS82qltCV3IXkMiapegE9Nvf6jVRugsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061897;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ktk7KhiVgXKNpNXGxG7Dsw7iqiky4yoyyMcfYN9E36A=;
	b=pzscfLjDHSbWN73dUzw8EnAOfCLA9uvVMJeXlAkeNiYCNGXQn0y+8L2lA0nPDqfRfnl1
	 SvNeSla87BNBjI+cj9eMBxMiNSXGhyn2w2tZYrOp/nF36rxECG10xGPOxVhBaQNoPW3bM
	 +ZZwCy/mOsO9DjTqjhfxPNEqw+4fMVIiFy8wfpnOsC0SJunz3D2YsMIicMOK4i2oMNqAw
	 ebfuxLF3pAv3Tq8wwZGA+ybvZ3yW9+cG+WmJG6hxLb55N/ZOhMl7MJ+pLdB99F1Z1Kwhk
	 bdDNrooG7/VwmYFO5XVm01urWgM8IpCCunLUmoZWkpvuUQLFC7rL7/i7KjKiVc0Pbzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P0ffgTuT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC351606A326;
	Sat,  7 Nov 2026 14:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P0ffgTuT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B371F0089F;
	Sat,  7 Nov 2026 14:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061896;
	bh=ktk7KhiVgXKNpNXGxG7Dsw7iqiky4yoyyMcfYN9E36A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P0ffgTuTKxF8u/MvEpwJo2dJQgnSdttl2JJpPWKP8YKhEiPRLKLPDo2lIxWJf+im8
	 CjgkMBxAiyBunfNy4sQxhjoaqvef+YfULz3FmubmrfSPiKK7VU7TVJKdh/p/KEym4x
	 U9V6a5Ui64qupyW/jeONLj7gOMsjlzrHpiPX3Olo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oscar Salvador <osalvador@suse.de>,
	Gavin Guo <gavinguo@igalia.com>,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0869/1536] mm,hugetlb: change mechanism to detect a COW on private mapping
Date: Sat,  7 Nov 2026 08:48:05 -0500
Message-ID: <20261107135021.953829493@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oscar Salvador <osalvador@suse.de>

[ Upstream commit 2ae1ab9934c785b855583e3eabd208d6f3ac91e1 ]

Patch series "Misc rework on hugetlb faulting path", v4.

This patchset aims to give some love to the hugetlb faulting path, doing
so by removing obsolete comments that are no longer true, sorting out the
folio lock, and changing the mechanism we use to determine whether we are
COWing a private mapping already.

The most important patch of the series is #1, as it fixes a deadlock that
was described in [1], where two processes were holding the same lock for
the folio in the pagecache, and then deadlocked in the mutex.  Note that
this can also happen for anymous folios.  This has been tested using this
reproducer, below

Looking up and locking the folio in the pagecache was done to check
whether that folio was the same folio we had mapped in our pagetables,
meaning that if it was different we knew that we already mapped that folio
privately, so any further CoW would be made on a private mapping, which
lead us to the question: __Was the reservation for that address
consumed?__ That is all we care about, because if it was indeed consumed
and we are the owner and we cannot allocate more folios, we need to unmap
the folio from the processes pagetables and make it exclusive for us.

We figured we do not need to look up the folio at all, and it is just
enough to check whether the folio we have mapped is anonymous, which means
we mapped it privately, so the reservation was indeed consumed.

Patch#2 sorts out folio locking in the faulting path, reducing the scope
of it ,only taking it when we are dealing with an anonymous folio and
document it.  More details in the patch.

Patch#3-5 are cleanups.

Here is the reproducer:

 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
 #include <sys/mman.h>
 #include <sys/wait.h>

 #define PROTECTION (PROT_READ | PROT_WRITE)
 #define LENGTH (2UL*1024*1024)

 #define ADDR (void *)(0x0UL)
 #define FLAGS (MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB)

 void __read(char *addr)
 {
 	int i = 0;

 	printf("a[%d]: %c\n", i, addr[i]);
 }

 void fill(char *addr)
 {
 	addr[0] = 'd';

 	printf("addr: %c\n", addr[0]);
 }

 int main(void)
 {
 	void *addr;
 	pid_t pid, wpid;
 	int status;

 	addr = mmap(ADDR, LENGTH, PROTECTION, FLAGS, -1, 0);
 	if (addr == MAP_FAILED) {
 		perror("mmap");
 		return -1;
 	}

 	printf("Parent faulting in RO\n");
 	__read(addr);

 	sleep (10);
 	printf("Forking\n");

 	pid = fork();
 	switch (pid) {
 	case -1:
 		perror("fork");
 		break;
 	case 0:
 		sleep (4);
 		printf("Child: Faulting in\n");
 		fill(addr);
 		exit(0);
 		break;
 	default:
 		printf("Parent: Faulting in\n");
 		fill(addr);
 		while((wpid = wait(&status)) > 0);
 		if (munmap(addr, LENGTH))
 			perror("munmap");
 	}

 	return 0;
 }

You will also have to add a delay in hugetlb_wp, after releasing the mutex
and before unmapping, so the window is large enough to reproduce it
reliably.

:  --- a/mm/hugetlb.c
:  +++ b/mm/hugetlb.c
:  @@ -38,6 +38,7 @@
:   #include <linux/memory.h>
:   #include <linux/mm_inline.h>
:   #include <linux/padata.h>
:  +#include <linux/delay.h>
:
:   #include <asm/page.h>
:   #include <asm/pgalloc.h>
:  @@ -6261,6 +6262,8 @@ static vm_fault_t hugetlb_wp(struct vm_fault *vmf)
:   			hugetlb_vma_unlock_read(vma);
:   			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
:
:  +			mdelay(8000);
:  +
:   			unmap_ref_private(mm, vma, old_folio, vmf->address);
:
:   			mutex_lock(&hugetlb_fault_mutex_table[hash]);

This patch (of 5):

hugetlb_wp() checks whether the process is trying to COW on a private
mapping in order to know whether the reservation for that address was
already consumed.  If it was consumed and we are the ownner of the
mapping, the folio will have to be unmapped from the other processes.

Currently, that check is done by looking up the folio in the pagecache and
compare it to the folio which is mapped in our pagetables.  If it differs,
it means we already mapped it privately before, consuming a reservation on
the way.  All we are interested in is whether the mapped folio is
anonymous, so we can simplify and check for that instead.

Link: https://lkml.kernel.org/r/20250630144212.156938-1-osalvador@suse.de
Link: https://lkml.kernel.org/r/20250627102904.107202-1-osalvador@suse.de
Link: https://lkml.kernel.org/r/20250627102904.107202-2-osalvador@suse.de
Link: https://lore.kernel.org/lkml/20250513093448.592150-1-gavinguo@igalia.com/ [1]
Link: https://lkml.kernel.org/r/20250630144212.156938-2-osalvador@suse.de
Fixes: 40549ba8f8e0 ("hugetlb: use new vma_lock for pmd sharing synchronization")
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reported-by: Gavin Guo <gavinguo@igalia.com>
Closes: https://lore.kernel.org/lkml/20250513093448.592150-1-gavinguo@igalia.com/
Suggested-by: Peter Xu <peterx@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

:
:   #include <asm/page.h>
:   #include <asm/pgalloc.h>
:  @@ -6261,6 +6262,8 @@ static vm_fault_t hugetlb_wp(struct vm_fault *vmf)
:   			hugetlb_vma_unlock_read(vma);
:   			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
:
:  +			mdelay(8000);
:  +
:   			unmap_ref_private(mm, vma, old_folio, vmf->address);
:

Stable-dep-of: 824cc56bf43c ("mm/hugetlb: fix use-after-free of a new anon folio")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 88 ++++++++++++++++++++--------------------------------
 1 file changed, 34 insertions(+), 54 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 2805ddda5adeb..4d80b8497142a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5824,8 +5824,7 @@ static void unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
  * cannot race with other handlers or page migration.
  * Keep the pte_same checks anyway to make transition from the mutex easier.
  */
-static vm_fault_t hugetlb_wp(struct folio *pagecache_folio,
-		       struct vm_fault *vmf)
+static vm_fault_t hugetlb_wp(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct mm_struct *mm = vma->vm_mm;
@@ -5893,16 +5892,17 @@ static vm_fault_t hugetlb_wp(struct folio *pagecache_folio,
 		       PageAnonExclusive(&old_folio->page), &old_folio->page);
 
 	/*
-	 * If the process that created a MAP_PRIVATE mapping is about to
-	 * perform a COW due to a shared page count, attempt to satisfy
-	 * the allocation without using the existing reserves. The pagecache
-	 * page is used to determine if the reserve at this address was
-	 * consumed or not. If reserves were used, a partial faulted mapping
-	 * at the time of fork() could consume its reserves on COW instead
-	 * of the full address range.
+	 * If the process that created a MAP_PRIVATE mapping is about to perform
+	 * a COW due to a shared page count, attempt to satisfy the allocation
+	 * without using the existing reserves.
+	 * In order to determine where this is a COW on a MAP_PRIVATE mapping it
+	 * is enough to check whether the old_folio is anonymous. This means that
+	 * the reserve for this address was consumed. If reserves were used, a
+	 * partial faulted mapping at the fime of fork() could consume its reserves
+	 * on COW instead of the full address range.
 	 */
 	if (is_vma_resv_set(vma, HPAGE_RESV_OWNER) &&
-			old_folio != pagecache_folio)
+	    folio_test_anon(old_folio))
 		cow_from_owner = true;
 
 	folio_get(old_folio);
@@ -6283,7 +6283,7 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 	hugetlb_count_add(pages_per_huge_page(h), mm);
 	if ((vmf->flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED)) {
 		/* Optimization, do the COW without a second fault */
-		ret = hugetlb_wp(folio, vmf);
+		ret = hugetlb_wp(vmf);
 	}
 
 	spin_unlock(vmf->ptl);
@@ -6351,10 +6351,9 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	vm_fault_t ret;
 	u32 hash;
 	struct folio *folio = NULL;
-	struct folio *pagecache_folio = NULL;
 	struct hstate *h = hstate_vma(vma);
 	struct address_space *mapping;
-	int need_wait_lock = 0;
+	bool need_wait_lock = false;
 	struct vm_fault vmf = {
 		.vma = vma,
 		.address = address & huge_page_mask(h),
@@ -6445,8 +6444,7 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * If we are going to COW/unshare the mapping later, we examine the
 	 * pending reservations for this page now. This will ensure that any
 	 * allocations necessary to record that reservation occur outside the
-	 * spinlock. Also lookup the pagecache page now as it is used to
-	 * determine if a reservation has been consumed.
+	 * spinlock.
 	 */
 	if ((flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)) &&
 	    !(vma->vm_flags & VM_MAYSHARE) && !huge_pte_write(vmf.orig_pte)) {
@@ -6456,11 +6454,6 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		}
 		/* Just decrements count, does not deallocate */
 		vma_end_reservation(h, vma, vmf.address);
-
-		pagecache_folio = filemap_lock_hugetlb_folio(h, mapping,
-							     vmf.pgoff);
-		if (IS_ERR(pagecache_folio))
-			pagecache_folio = NULL;
 	}
 
 	vmf.ptl = huge_pte_lock(h, mm, vmf.pte);
@@ -6474,10 +6467,6 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	    (flags & FAULT_FLAG_WRITE) && !huge_pte_write(vmf.orig_pte)) {
 		if (!userfaultfd_wp_async(vma)) {
 			spin_unlock(vmf.ptl);
-			if (pagecache_folio) {
-				folio_unlock(pagecache_folio);
-				folio_put(pagecache_folio);
-			}
 			hugetlb_vma_unlock_read(vma);
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			return handle_userfault(&vmf, VM_UFFD_WP);
@@ -6489,24 +6478,19 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		/* Fallthrough to CoW */
 	}
 
-	/*
-	 * hugetlb_wp() requires page locks of pte_page(vmf.orig_pte) and
-	 * pagecache_folio, so here we need take the former one
-	 * when folio != pagecache_folio or !pagecache_folio.
-	 */
-	folio = page_folio(pte_page(vmf.orig_pte));
-	if (folio != pagecache_folio)
-		if (!folio_trylock(folio)) {
-			need_wait_lock = 1;
-			goto out_ptl;
-		}
-
-	folio_get(folio);
-
 	if (flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)) {
 		if (!huge_pte_write(vmf.orig_pte)) {
-			ret = hugetlb_wp(pagecache_folio, &vmf);
-			goto out_put_page;
+			/* hugetlb_wp() requires page locks of pte_page(vmf.orig_pte) */
+			folio = page_folio(pte_page(vmf.orig_pte));
+			if (!folio_trylock(folio)) {
+				need_wait_lock = true;
+				goto out_ptl;
+			}
+			folio_get(folio);
+			ret = hugetlb_wp(&vmf);
+			folio_unlock(folio);
+			folio_put(folio);
+			goto out_ptl;
 		} else if (likely(flags & FAULT_FLAG_WRITE)) {
 			vmf.orig_pte = huge_pte_mkdirty(vmf.orig_pte);
 		}
@@ -6515,17 +6499,8 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	if (huge_ptep_set_access_flags(vma, vmf.address, vmf.pte, vmf.orig_pte,
 						flags & FAULT_FLAG_WRITE))
 		update_mmu_cache(vma, vmf.address, vmf.pte);
-out_put_page:
-	if (folio != pagecache_folio)
-		folio_unlock(folio);
-	folio_put(folio);
 out_ptl:
 	spin_unlock(vmf.ptl);
-
-	if (pagecache_folio) {
-		folio_unlock(pagecache_folio);
-		folio_put(pagecache_folio);
-	}
 out_mutex:
 	hugetlb_vma_unlock_read(vma);
 
@@ -6538,11 +6513,16 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 
 	mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 	/*
-	 * Generally it's safe to hold refcount during waiting page lock. But
-	 * here we just wait to defer the next page fault to avoid busy loop and
-	 * the page is not used after unlocked before returning from the current
-	 * page fault. So we are safe from accessing freed page, even if we wait
-	 * here without taking refcount.
+	 * hugetlb_wp drops all the locks, but the folio lock, before trying to
+	 * unmap the folio from other processes. During that window, if another
+	 * process mapping that folio faults in, it will take the mutex and then
+	 * it will wait on folio_lock, causing an ABBA deadlock.
+	 * Use trylock instead and bail out if we fail.
+	 *
+	 * Ideally, we should hold a refcount on the folio we wait for, but we do
+	 * not want to use the folio after it becomes unlocked, but rather just
+	 * wait for it to become unlocked, so hopefully next fault successes on
+	 * the trylock.
 	 */
 	if (need_wait_lock)
 		folio_wait_locked(folio);
-- 
2.53.0



