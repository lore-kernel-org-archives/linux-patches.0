Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E481094A
	for <patches@lists.linux.dev>; Mon,  3 Jul 2023 18:57:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDEDAC433C7;
	Mon,  3 Jul 2023 18:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688410645;
	bh=QvUT5CLdWwZs0yZNg654AaRKjbaxBHfXJnibD6AgEb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oTHg3qSLqxdV3fH0TP+g1Q+69O8P4NhAvSeA5LUNNSXtZ1qApzkaTSeRsy0DWgt4A
	 nZ9aGczm9zLRzo4/4KWSAsuYnBbkTGd5NbKJbTt+VkE3Qn6ZRywfOr5ogp8wINFD7N
	 i6eSZK6ySHHvvpX5HnYzD7e3ECvTBaNDtZ21UPvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Alexander Potapenko <glider@google.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>
Subject: [PATCH 5.15 03/15] mm, hwpoison: try to recover from copy-on write faults
Date: Mon,  3 Jul 2023 20:54:48 +0200
Message-ID: <20230703184518.989435975@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230703184518.896751186@linuxfoundation.org>
References: <20230703184518.896751186@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tony Luck <tony.luck@intel.com>

commit a873dfe1032a132bf89f9e19a6ac44f5a0b78754 upstream.

Patch series "Copy-on-write poison recovery", v3.

Part 1 deals with the process that triggered the copy on write fault with
a store to a shared read-only page.  That process is send a SIGBUS with
the usual machine check decoration to specify the virtual address of the
lost page, together with the scope.

Part 2 sets up to asynchronously take the page with the uncorrected error
offline to prevent additional machine check faults.  H/t to Miaohe Lin
<linmiaohe@huawei.com> and Shuai Xue <xueshuai@linux.alibaba.com> for
pointing me to the existing function to queue a call to memory_failure().

On x86 there is some duplicate reporting (because the error is also
signalled by the memory controller as well as by the core that triggered
the machine check).  Console logs look like this:

This patch (of 2):

If the kernel is copying a page as the result of a copy-on-write
fault and runs into an uncorrectable error, Linux will crash because
it does not have recovery code for this case where poison is consumed
by the kernel.

It is easy to set up a test case. Just inject an error into a private
page, fork(2), and have the child process write to the page.

I wrapped that neatly into a test at:

  git://git.kernel.org/pub/scm/linux/kernel/git/aegl/ras-tools.git

just enable ACPI error injection and run:

  # ./einj_mem-uc -f copy-on-write

Add a new copy_user_highpage_mc() function that uses copy_mc_to_kernel()
on architectures where that is available (currently x86 and powerpc).
When an error is detected during the page copy, return VM_FAULT_HWPOISON
to caller of wp_page_copy(). This propagates up the call stack. Both x86
and powerpc have code in their fault handler to deal with this code by
sending a SIGBUS to the application.

Note that this patch avoids a system crash and signals the process that
triggered the copy-on-write action. It does not take any action for the
memory error that is still in the shared page. To handle that a call to
memory_failure() is needed. But this cannot be done from wp_page_copy()
because it holds mmap_lock(). Perhaps the architecture fault handlers
can deal with this loose end in a subsequent patch?

On Intel/x86 this loose end will often be handled automatically because
the memory controller provides an additional notification of the h/w
poison in memory, the handler for this will call memory_failure(). This
isn't a 100% solution. If there are multiple errors, not all may be
logged in this way.

Cc: <stable@vger.kernel.org>
[tony.luck@intel.com: add call to kmsan_unpoison_memory(), per Miaohe Lin]
  Link: https://lkml.kernel.org/r/20221031201029.102123-2-tony.luck@intel.com
Link: https://lkml.kernel.org/r/20221021200120.175753-1-tony.luck@intel.com
Link: https://lkml.kernel.org/r/20221021200120.175753-2-tony.luck@intel.com
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Tested-by: Shuai Xue <xueshuai@linux.alibaba.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ Due to missing commits
  c89357e27f20d ("mm: support GUP-triggered unsharing of anonymous pages")
  662ce1dc9caf4 ("delayacct: track delays from write-protect copy")
  b073d7f8aee4e ("mm: kmsan: maintain KMSAN metadata for page operations")
  The impact of c89357e27f20d is a name change from cow_user_page() to
  __wp_page_copy_user().
  The impact of 662ce1dc9caf4 is the introduction of a new feature of
  tracking write-protect copy in delayacct.
  The impact of b073d7f8aee4e is an introduction of KASAN feature.
  None of these commits establishes meaningful dependency, hence resolve by
  ignoring them. - jane]
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/highmem.h |   24 ++++++++++++++++++++++++
 mm/memory.c             |   31 +++++++++++++++++++++----------
 2 files changed, 45 insertions(+), 10 deletions(-)

--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -247,6 +247,30 @@ static inline void copy_user_highpage(st
 
 #endif
 
+#ifdef copy_mc_to_kernel
+static inline int copy_mc_user_highpage(struct page *to, struct page *from,
+					unsigned long vaddr, struct vm_area_struct *vma)
+{
+	unsigned long ret;
+	char *vfrom, *vto;
+
+	vfrom = kmap_local_page(from);
+	vto = kmap_local_page(to);
+	ret = copy_mc_to_kernel(vto, vfrom, PAGE_SIZE);
+	kunmap_local(vto);
+	kunmap_local(vfrom);
+
+	return ret;
+}
+#else
+static inline int copy_mc_user_highpage(struct page *to, struct page *from,
+					unsigned long vaddr, struct vm_area_struct *vma)
+{
+	copy_user_highpage(to, from, vaddr, vma);
+	return 0;
+}
+#endif
+
 #ifndef __HAVE_ARCH_COPY_HIGHPAGE
 
 static inline void copy_highpage(struct page *to, struct page *from)
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2753,10 +2753,16 @@ static inline int pte_unmap_same(struct
 	return same;
 }
 
-static inline bool cow_user_page(struct page *dst, struct page *src,
-				 struct vm_fault *vmf)
+/*
+ * Return:
+ *	0:		copied succeeded
+ *	-EHWPOISON:	copy failed due to hwpoison in source page
+ *	-EAGAIN:	copied failed (some other reason)
+ */
+static inline int cow_user_page(struct page *dst, struct page *src,
+				      struct vm_fault *vmf)
 {
-	bool ret;
+	int ret;
 	void *kaddr;
 	void __user *uaddr;
 	bool locked = false;
@@ -2765,8 +2771,9 @@ static inline bool cow_user_page(struct
 	unsigned long addr = vmf->address;
 
 	if (likely(src)) {
-		copy_user_highpage(dst, src, addr, vma);
-		return true;
+		if (copy_mc_user_highpage(dst, src, addr, vma))
+			return -EHWPOISON;
+		return 0;
 	}
 
 	/*
@@ -2793,7 +2800,7 @@ static inline bool cow_user_page(struct
 			 * and update local tlb only
 			 */
 			update_mmu_tlb(vma, addr, vmf->pte);
-			ret = false;
+			ret = -EAGAIN;
 			goto pte_unlock;
 		}
 
@@ -2818,7 +2825,7 @@ static inline bool cow_user_page(struct
 		if (!likely(pte_same(*vmf->pte, vmf->orig_pte))) {
 			/* The PTE changed under us, update local tlb */
 			update_mmu_tlb(vma, addr, vmf->pte);
-			ret = false;
+			ret = -EAGAIN;
 			goto pte_unlock;
 		}
 
@@ -2837,7 +2844,7 @@ warn:
 		}
 	}
 
-	ret = true;
+	ret = 0;
 
 pte_unlock:
 	if (locked)
@@ -3003,6 +3010,7 @@ static vm_fault_t wp_page_copy(struct vm
 	pte_t entry;
 	int page_copied = 0;
 	struct mmu_notifier_range range;
+	int ret;
 
 	if (unlikely(anon_vma_prepare(vma)))
 		goto oom;
@@ -3018,17 +3026,20 @@ static vm_fault_t wp_page_copy(struct vm
 		if (!new_page)
 			goto oom;
 
-		if (!cow_user_page(new_page, old_page, vmf)) {
+		ret = cow_user_page(new_page, old_page, vmf);
+		if (ret) {
 			/*
 			 * COW failed, if the fault was solved by other,
 			 * it's fine. If not, userspace would re-fault on
 			 * the same address and we will handle the fault
 			 * from the second attempt.
+			 * The -EHWPOISON case will not be retried.
 			 */
 			put_page(new_page);
 			if (old_page)
 				put_page(old_page);
-			return 0;
+
+			return ret == -EHWPOISON ? VM_FAULT_HWPOISON : 0;
 		}
 	}
 


