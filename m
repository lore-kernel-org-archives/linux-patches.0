Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D5333372B;
	Fri,  9 Jan 2026 12:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963136; cv=none; b=V1CuyFUn+3qI64JtT4Ag5FGwGyC9iqCD5jBAAzliIKRyYmMkgYTRmdZPN3PJBLV8P5LhtOOkTDgL1TLkO7+GuFPo1CkUm1Pi5Gkj6S2yyEXxxbYvNjHz3USB9W5ffhqYqnq3xVlAklq9WO6NhLr+A7AZa4mYFn70RJSGKlPJB8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963136; c=relaxed/simple;
	bh=9o0gqq+yfliWMDmic0cJIQdFpmSQ7gfqSqB2evzuKJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNYUyao2P42Ng9GTCJBumtkKWORm1EXHik+xd/EKL8d82OTtj7bKZrqQ1XYM/t5jGY9A38fMjxlp42sSO8bajg/0F2aM3ctOJeYxefHd+qUo5BSdVx46vLWduorye+o0HzL/IUbwIoaHFfXYULHHY35Qhp0M7LxEywf0j/XzGzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yesU2q/+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yesU2q/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97648C4CEF1;
	Fri,  9 Jan 2026 12:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963136;
	bh=9o0gqq+yfliWMDmic0cJIQdFpmSQ7gfqSqB2evzuKJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yesU2q/+6Sfxd6kmYSB/EM7FJL6nbXiBrwxC57sLAMr1wFy5wYnVC+zbUcGPf5v55
	 H0dkQiumaZgOvSx0CJT6pFDjCLYAnchDq3JSKujzRMinbsNkqsQqa7DrSprpZYFgTK
	 sY5KlMi3QMXYjCzrAFcz6qbXdcMqNTAk8YzCU8cQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Xu <peterx@redhat.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	James Houghton <jthoughton@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	David Hildenbrand <david@redhat.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Nadav Amit <nadav.amit@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Harry Yoo <harry.yoo@oracle.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: [PATCH 6.1 610/634] mm/mprotect: use long for page accountings and retval
Date: Fri,  9 Jan 2026 12:44:48 +0100
Message-ID: <20260109112140.584949761@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Peter Xu <peterx@redhat.com>

commit a79390f5d6a78647fd70856bd42b22d994de0ba2 upstream.

Switch to use type "long" for page accountings and retval across the whole
procedure of change_protection().

The change should have shrinked the possible maximum page number to be
half comparing to previous (ULONG_MAX / 2), but it shouldn't overflow on
any system either because the maximum possible pages touched by change
protection should be ULONG_MAX / PAGE_SIZE.

Two reasons to switch from "unsigned long" to "long":

  1. It suites better on count_vm_numa_events(), whose 2nd parameter takes
     a long type.

  2. It paves way for returning negative (error) values in the future.

Currently the only caller that consumes this retval is change_prot_numa(),
where the unsigned long was converted to an int.  Since at it, touching up
the numa code to also take a long, so it'll avoid any possible overflow
too during the int-size convertion.

Link: https://lkml.kernel.org/r/20230104225207.1066932-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: James Houghton <jthoughton@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ Adjust context ]
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hugetlb.h |    4 ++--
 include/linux/mm.h      |    2 +-
 mm/hugetlb.c            |    4 ++--
 mm/mempolicy.c          |    2 +-
 mm/mprotect.c           |   26 +++++++++++++-------------
 5 files changed, 19 insertions(+), 19 deletions(-)

--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -233,7 +233,7 @@ void hugetlb_vma_lock_release(struct kre
 
 int pmd_huge(pmd_t pmd);
 int pud_huge(pud_t pud);
-unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
+long hugetlb_change_protection(struct vm_area_struct *vma,
 		unsigned long address, unsigned long end, pgprot_t newprot,
 		unsigned long cp_flags);
 
@@ -447,7 +447,7 @@ static inline void move_hugetlb_state(st
 {
 }
 
-static inline unsigned long hugetlb_change_protection(
+static inline long hugetlb_change_protection(
 			struct vm_area_struct *vma, unsigned long address,
 			unsigned long end, pgprot_t newprot,
 			unsigned long cp_flags)
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2148,7 +2148,7 @@ extern unsigned long move_page_tables(st
 #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
 					    MM_CP_UFFD_WP_RESOLVE)
 
-extern unsigned long change_protection(struct mmu_gather *tlb,
+extern long change_protection(struct mmu_gather *tlb,
 			      struct vm_area_struct *vma, unsigned long start,
 			      unsigned long end, pgprot_t newprot,
 			      unsigned long cp_flags);
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6668,7 +6668,7 @@ long follow_hugetlb_page(struct mm_struc
 	return i ? i : err;
 }
 
-unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
+long hugetlb_change_protection(struct vm_area_struct *vma,
 		unsigned long address, unsigned long end,
 		pgprot_t newprot, unsigned long cp_flags)
 {
@@ -6677,7 +6677,7 @@ unsigned long hugetlb_change_protection(
 	pte_t *ptep;
 	pte_t pte;
 	struct hstate *h = hstate_vma(vma);
-	unsigned long pages = 0, psize = huge_page_size(h);
+	long pages = 0, psize = huge_page_size(h);
 	bool shared_pmd = false;
 	struct mmu_notifier_range range;
 	unsigned long last_addr_mask;
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -628,7 +628,7 @@ unsigned long change_prot_numa(struct vm
 			unsigned long addr, unsigned long end)
 {
 	struct mmu_gather tlb;
-	int nr_updated;
+	long nr_updated;
 
 	tlb_gather_mmu(&tlb, vma->vm_mm);
 
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -72,13 +72,13 @@ static inline bool can_change_pte_writab
 	return true;
 }
 
-static unsigned long change_pte_range(struct mmu_gather *tlb,
+static long change_pte_range(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, pmd_t *pmd, unsigned long addr,
 		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
 {
 	pte_t *pte, oldpte;
 	spinlock_t *ptl;
-	unsigned long pages = 0;
+	long pages = 0;
 	int target_node = NUMA_NO_NODE;
 	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
@@ -346,13 +346,13 @@ uffd_wp_protect_file(struct vm_area_stru
 		}							\
 	} while (0)
 
-static inline unsigned long change_pmd_range(struct mmu_gather *tlb,
+static inline long change_pmd_range(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, pud_t *pud, unsigned long addr,
 		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
 {
 	pmd_t *pmd;
 	unsigned long next;
-	unsigned long pages = 0;
+	long pages = 0;
 	unsigned long nr_huge_updates = 0;
 	struct mmu_notifier_range range;
 
@@ -360,7 +360,7 @@ static inline unsigned long change_pmd_r
 
 	pmd = pmd_offset(pud, addr);
 	do {
-		unsigned long this_pages;
+		long this_pages;
 
 		next = pmd_addr_end(addr, end);
 
@@ -430,13 +430,13 @@ next:
 	return pages;
 }
 
-static inline unsigned long change_pud_range(struct mmu_gather *tlb,
+static inline long change_pud_range(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, p4d_t *p4d, unsigned long addr,
 		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
 {
 	pud_t *pud;
 	unsigned long next;
-	unsigned long pages = 0;
+	long pages = 0;
 
 	pud = pud_offset(p4d, addr);
 	do {
@@ -451,13 +451,13 @@ static inline unsigned long change_pud_r
 	return pages;
 }
 
-static inline unsigned long change_p4d_range(struct mmu_gather *tlb,
+static inline long change_p4d_range(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, pgd_t *pgd, unsigned long addr,
 		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
 {
 	p4d_t *p4d;
 	unsigned long next;
-	unsigned long pages = 0;
+	long pages = 0;
 
 	p4d = p4d_offset(pgd, addr);
 	do {
@@ -472,14 +472,14 @@ static inline unsigned long change_p4d_r
 	return pages;
 }
 
-static unsigned long change_protection_range(struct mmu_gather *tlb,
+static long change_protection_range(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, unsigned long addr,
 		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pgd_t *pgd;
 	unsigned long next;
-	unsigned long pages = 0;
+	long pages = 0;
 
 	BUG_ON(addr >= end);
 	pgd = pgd_offset(mm, addr);
@@ -498,12 +498,12 @@ static unsigned long change_protection_r
 	return pages;
 }
 
-unsigned long change_protection(struct mmu_gather *tlb,
+long change_protection(struct mmu_gather *tlb,
 		       struct vm_area_struct *vma, unsigned long start,
 		       unsigned long end, pgprot_t newprot,
 		       unsigned long cp_flags)
 {
-	unsigned long pages;
+	long pages;
 
 	BUG_ON((cp_flags & MM_CP_UFFD_WP_ALL) == MM_CP_UFFD_WP_ALL);
 


