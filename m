Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CA2248BAF;
	Wed, 15 Jan 2025 11:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938883; cv=none; b=Jo5jx61AiXcvZI45lc1GCtsOWtgVM3UIAAqZYdbXV8tElOF+ra2w7uguRueLEE2KTKVvNexPWPK51ctCwTX7ACEBIuGWXpGOPQlr17qzKa+8UICcTY7Sk42uF9RrjtaDmdtMBv5LIrI8tsz+laE0gwnUBJJHKIJ/yDF0I6gfYs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938883; c=relaxed/simple;
	bh=zOdTszhpmSbDl9MrnTvkzJKXgpp17fd1HKjkRI1F7b0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZNohYx1j6ZDhwrEoi24M7nE8TG1tIFh0DAnz98u5GSjwIJz5HX/hnCzvfoiM4XoNuRoRJVu7Fujc2TpiL4KVhHfmp0oifb3feHrwZg9C07SfaSeia5UG9WyEkWiU6zD08jjLSt7RAmz+RpwBau9Zbo99Zhd0n0RbUKHuKsfPiG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YZOLCqRW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YZOLCqRW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26010C4CEDF;
	Wed, 15 Jan 2025 11:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938883;
	bh=zOdTszhpmSbDl9MrnTvkzJKXgpp17fd1HKjkRI1F7b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YZOLCqRWRV+18LMHbVnHPpwoPbW2E1WFf9tFsKgpeA3KpxKerJnYSeVyYXKrCzni5
	 0a12CI1sg5ZUAOKIk8cHlV1WCbWTz2FJXMf1Ggyp5vXnlGXyXxcSGGPvFOClQfyrjK
	 k3dgbOMZAtzSMLp1L2M1EHR7Iig+8uhwHlIIMIZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Borislav Petkov <bp@alien8.de>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Christian Brauner <brauner@kernel.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Juergen Gross <jgross@suse.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Muchun Song <muchun.song@linux.dev>,
	"Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Russell King <linux@armlinux.org.uk>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 126/129] mm/hugetlb: enforce that PMD PT sharing has split PMD PT locks
Date: Wed, 15 Jan 2025 11:38:21 +0100
Message-ID: <20250115103559.378310687@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

From: David Hildenbrand <david@redhat.com>

[ Upstream commit 188cac58a8bcdf82c7f63275b68f7a46871e45d6 ]

Sharing page tables between processes but falling back to per-MM page
table locks cannot possibly work.

So, let's make sure that we do have split PMD locks by adding a new
Kconfig option and letting that depend on CONFIG_SPLIT_PMD_PTLOCKS.

Link: https://lkml.kernel.org/r/20240726150728.3159964-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/Kconfig              | 4 ++++
 include/linux/hugetlb.h | 5 ++---
 mm/hugetlb.c            | 8 ++++----
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 0ad3c7c7e984..02a9237807a7 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -284,6 +284,10 @@ config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	depends on ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	depends on SPARSEMEM_VMEMMAP
 
+config HUGETLB_PMD_PAGE_TABLE_SHARING
+	def_bool HUGETLB_PAGE
+	depends on ARCH_WANT_HUGE_PMD_SHARE && SPLIT_PMD_PTLOCKS
+
 config ARCH_HAS_GIGANTIC_PAGE
 	bool
 
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 0c50c4fceb95..0ca93c7574ad 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1239,7 +1239,7 @@ static inline __init void hugetlb_cma_reserve(int order)
 }
 #endif
 
-#ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
+#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
 static inline bool hugetlb_pmd_shared(pte_t *pte)
 {
 	return page_count(virt_to_page(pte)) > 1;
@@ -1275,8 +1275,7 @@ bool __vma_private_lock(struct vm_area_struct *vma);
 static inline pte_t *
 hugetlb_walk(struct vm_area_struct *vma, unsigned long addr, unsigned long sz)
 {
-#if defined(CONFIG_HUGETLB_PAGE) && \
-	defined(CONFIG_ARCH_WANT_HUGE_PMD_SHARE) && defined(CONFIG_LOCKDEP)
+#if defined(CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING) && defined(CONFIG_LOCKDEP)
 	struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
 
 	/*
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 92b955cc5a41..5b8cc558ab6e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6907,7 +6907,7 @@ long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
 	return 0;
 }
 
-#ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
+#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
 static unsigned long page_table_shareable(struct vm_area_struct *svma,
 				struct vm_area_struct *vma,
 				unsigned long addr, pgoff_t idx)
@@ -7069,7 +7069,7 @@ int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
 	return 1;
 }
 
-#else /* !CONFIG_ARCH_WANT_HUGE_PMD_SHARE */
+#else /* !CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING */
 
 pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 		      unsigned long addr, pud_t *pud)
@@ -7092,7 +7092,7 @@ bool want_pmd_share(struct vm_area_struct *vma, unsigned long addr)
 {
 	return false;
 }
-#endif /* CONFIG_ARCH_WANT_HUGE_PMD_SHARE */
+#endif /* CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING */
 
 #ifdef CONFIG_ARCH_WANT_GENERAL_HUGETLB
 pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
@@ -7190,7 +7190,7 @@ unsigned long hugetlb_mask_last_page(struct hstate *h)
 /* See description above.  Architectures can provide their own version. */
 __weak unsigned long hugetlb_mask_last_page(struct hstate *h)
 {
-#ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
+#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
 	if (huge_page_size(h) == PMD_SIZE)
 		return PUD_SIZE - PMD_SIZE;
 #endif
-- 
2.39.5



