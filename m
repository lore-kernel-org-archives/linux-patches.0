Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF473148AC;
	Wed, 21 Jan 2026 18:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020539; cv=none; b=bTQbZVZJQtX1b2qcdNPPu3BRd9tjwQKYhlZziWroTHKUhnAkFGYVh2nY/ftf2fwPwvEdzCx0RA/ycskXreLzmwftjzpA/isCkcUlcbvytjESwWFO/9L+3Lg1kvJg1wugVD1utjmmySJxwtWOH3905gMCe7mvB1iHfMxaKJloFE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020539; c=relaxed/simple;
	bh=MF8TjWZlr7E4gCsPW4TKsLbaZD4njkf9Vcdx+ms4MLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eRRvzW5nUBqxwa1o2O/t2xa2mRQw16OMiqgtwFv6PDbESxnqQZ59DiZaNCcvzQsYnMBpvzkjsMRuwEJ/KVQ67EfH9ZzS9CiRZ+KpNRZMAddBLoxluwfmKBCSqmYdTN1UggsIH12Ck2pGk3L8FPvfwtM2nSUGgwUz3Y+fqPKVFWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qUy8BvYc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qUy8BvYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D27FEC4CEF1;
	Wed, 21 Jan 2026 18:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020539;
	bh=MF8TjWZlr7E4gCsPW4TKsLbaZD4njkf9Vcdx+ms4MLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qUy8BvYcObTFyubMMh/j+TcNNlahMAmSeQh+Fw6bRzPA4gXGXxGMVxD7hzdyxAEn1
	 oyqPhIuIM3f1qUGed2iTue+4t+WR09Ujcs6CXVzBehR1oEW7hoHxGb03Cu88ONoHEG
	 Cf0Tb9DyY3vbGpugCY2LQAlj02jQCVRZX5vIA3yQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	David Hildenbrand <david@redhat.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Alistair Popple <apopple@nvidia.com>,
	Andy Lutomirski <luto@kernel.org>,
	Borislav Betkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	Jann Horn <jannh@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <joro@8bytes.org>,
	Liam Howlett <liam.howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Robin Murohy <robin.murphy@arm.com>,
	Thomas Gleinxer <tglx@linutronix.de>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	Yi Lai <yi1.lai@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 189/198] mm: introduce deferred freeing for kernel page tables
Date: Wed, 21 Jan 2026 19:16:57 +0100
Message-ID: <20260121181425.359723354@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Dave Hansen <dave.hansen@linux.intel.com>

commit 5ba2f0a1556479638ac11a3c201421f5515e89f5 upstream.

This introduces a conditional asynchronous mechanism, enabled by
CONFIG_ASYNC_KERNEL_PGTABLE_FREE.  When enabled, this mechanism defers the
freeing of pages that are used as page tables for kernel address mappings.
These pages are now queued to a work struct instead of being freed
immediately.

This deferred freeing allows for batch-freeing of page tables, providing a
safe context for performing a single expensive operation (TLB flush) for a
batch of kernel page tables instead of performing that expensive operation
for each page table.

Link: https://lkml.kernel.org/r/20251022082635.2462433-8-baolu.lu@linux.intel.com
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robin Murohy <robin.murphy@arm.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vasant Hegde <vasant.hegde@amd.com>
Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mm.h   |   16 +++++++++++++---
 mm/Kconfig           |    3 +++
 mm/pgtable-generic.c |   37 +++++++++++++++++++++++++++++++++++++
 3 files changed, 53 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3038,6 +3038,14 @@ static inline void __pagetable_free(stru
 	__free_pages(page, compound_order(page));
 }
 
+#ifdef CONFIG_ASYNC_KERNEL_PGTABLE_FREE
+void pagetable_free_kernel(struct ptdesc *pt);
+#else
+static inline void pagetable_free_kernel(struct ptdesc *pt)
+{
+	__pagetable_free(pt);
+}
+#endif
 /**
  * pagetable_free - Free pagetables
  * @pt:	The page table descriptor
@@ -3047,10 +3055,12 @@ static inline void __pagetable_free(stru
  */
 static inline void pagetable_free(struct ptdesc *pt)
 {
-	if (ptdesc_test_kernel(pt))
+	if (ptdesc_test_kernel(pt)) {
 		ptdesc_clear_kernel(pt);
-
-	__pagetable_free(pt);
+		pagetable_free_kernel(pt);
+	} else {
+		__pagetable_free(pt);
+	}
 }
 
 #if defined(CONFIG_SPLIT_PTE_PTLOCKS)
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -915,6 +915,9 @@ config HAVE_GIGANTIC_FOLIOS
 	def_bool (HUGETLB_PAGE && ARCH_HAS_GIGANTIC_PAGE) || \
 		 (ZONE_DEVICE && HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
 
+config ASYNC_KERNEL_PGTABLE_FREE
+	def_bool n
+
 # TODO: Allow to be enabled without THP
 config ARCH_SUPPORTS_HUGE_PFNMAP
 	def_bool n
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -406,3 +406,40 @@ again:
 	pte_unmap_unlock(pte, ptl);
 	goto again;
 }
+
+#ifdef CONFIG_ASYNC_KERNEL_PGTABLE_FREE
+static void kernel_pgtable_work_func(struct work_struct *work);
+
+static struct {
+	struct list_head list;
+	/* protect above ptdesc lists */
+	spinlock_t lock;
+	struct work_struct work;
+} kernel_pgtable_work = {
+	.list = LIST_HEAD_INIT(kernel_pgtable_work.list),
+	.lock = __SPIN_LOCK_UNLOCKED(kernel_pgtable_work.lock),
+	.work = __WORK_INITIALIZER(kernel_pgtable_work.work, kernel_pgtable_work_func),
+};
+
+static void kernel_pgtable_work_func(struct work_struct *work)
+{
+	struct ptdesc *pt, *next;
+	LIST_HEAD(page_list);
+
+	spin_lock(&kernel_pgtable_work.lock);
+	list_splice_tail_init(&kernel_pgtable_work.list, &page_list);
+	spin_unlock(&kernel_pgtable_work.lock);
+
+	list_for_each_entry_safe(pt, next, &page_list, pt_list)
+		__pagetable_free(pt);
+}
+
+void pagetable_free_kernel(struct ptdesc *pt)
+{
+	spin_lock(&kernel_pgtable_work.lock);
+	list_add(&pt->pt_list, &kernel_pgtable_work.list);
+	spin_unlock(&kernel_pgtable_work.lock);
+
+	schedule_work(&kernel_pgtable_work.work);
+}
+#endif


