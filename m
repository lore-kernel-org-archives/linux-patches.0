Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D03214600D;
	Thu, 13 Jun 2024 12:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280521; cv=none; b=dvvRtrxrLM1naiwpm7TcIKTcmhNLND4cOHmroT1/mP0Z7GxkEZ0DzhAWD1bSjxYDBMSSx8I9PlSu7Ont36g1KR818w9sTD4AP9+oF4d2hpWFkr0He6rU/PKxQb9uWSyAlX03nNJ5fKd01CMqhL0NLvnMAoC+0k6b0lQBIwSVA48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280521; c=relaxed/simple;
	bh=/gfNeMsMHpl2jz/SEtUXX5wbPxZcndCC4VbOCDKyzNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dohwuxpwsVasZdtlx7HegunowIEFhA6GR1itKvFcbpV1LZyN+V1Y98ARX5JS0zvU2J6UMijv0GDIU7+YvRbvf7+OhoN6GvbWiCjSiK4eFG1vZv+Bjt5i1swXjCnvgTbs7kT3/MwTwFlNLxIsas27VpY/AKXGlNZoJYFuPZd6fuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=isPoiw7x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="isPoiw7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B5AC4AF1A;
	Thu, 13 Jun 2024 12:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280520;
	bh=/gfNeMsMHpl2jz/SEtUXX5wbPxZcndCC4VbOCDKyzNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=isPoiw7x6DGFaK2dQrWQKHArLycmYrneDifSQCMQDxr0+xECSxYnPb+zpZ9sPoNYJ
	 UNbbYQYZ9Fuq40rtst5VNoASsRyd5Zwe52WO1WYOLbyFxUxwhCWWsNBjkNuhclShdn
	 4TE96o9JqWtwBwfr32IpoL5tL1TEK1qjySgZRTxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengming Zhou <chengming.zhou@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>,
	Stefan Roesch <shr@devkernel.io>,
	xu xin <xu.xin16@zte.com.cn>,
	Yang Yang <yang.yang29@zte.com.cn>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 082/137] mm/ksm: fix ksm_zero_pages accounting
Date: Thu, 13 Jun 2024 13:34:22 +0200
Message-ID: <20240613113226.479300428@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Chengming Zhou <chengming.zhou@linux.dev>

commit c2dc78b86e0821ecf9a9d0c35dba2618279a5bb6 upstream.

We normally ksm_zero_pages++ in ksmd when page is merged with zero page,
but ksm_zero_pages-- is done from page tables side, where there is no any
accessing protection of ksm_zero_pages.

So we can read very exceptional value of ksm_zero_pages in rare cases,
such as -1, which is very confusing to users.

Fix it by changing to use atomic_long_t, and the same case with the
mm->ksm_zero_pages.

Link: https://lkml.kernel.org/r/20240528-b4-ksm-counters-v3-2-34bb358fdc13@linux.dev
Fixes: e2942062e01d ("ksm: count all zero pages placed by KSM")
Fixes: 6080d19f0704 ("ksm: add ksm zero pages for each process")
Signed-off-by: Chengming Zhou <chengming.zhou@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Cc: Stefan Roesch <shr@devkernel.io>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/base.c           |    2 +-
 include/linux/ksm.h      |   17 ++++++++++++++---
 include/linux/mm_types.h |    2 +-
 mm/ksm.c                 |   11 +++++------
 4 files changed, 21 insertions(+), 11 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -3207,7 +3207,7 @@ static int proc_pid_ksm_stat(struct seq_
 	mm = get_task_mm(task);
 	if (mm) {
 		seq_printf(m, "ksm_rmap_items %lu\n", mm->ksm_rmap_items);
-		seq_printf(m, "ksm_zero_pages %lu\n", mm->ksm_zero_pages);
+		seq_printf(m, "ksm_zero_pages %ld\n", mm_ksm_zero_pages(mm));
 		seq_printf(m, "ksm_merging_pages %lu\n", mm->ksm_merging_pages);
 		seq_printf(m, "ksm_process_profit %ld\n", ksm_process_profit(mm));
 		mmput(mm);
--- a/include/linux/ksm.h
+++ b/include/linux/ksm.h
@@ -33,16 +33,27 @@ void __ksm_exit(struct mm_struct *mm);
  */
 #define is_ksm_zero_pte(pte)	(is_zero_pfn(pte_pfn(pte)) && pte_dirty(pte))
 
-extern unsigned long ksm_zero_pages;
+extern atomic_long_t ksm_zero_pages;
+
+static inline void ksm_map_zero_page(struct mm_struct *mm)
+{
+	atomic_long_inc(&ksm_zero_pages);
+	atomic_long_inc(&mm->ksm_zero_pages);
+}
 
 static inline void ksm_might_unmap_zero_page(struct mm_struct *mm, pte_t pte)
 {
 	if (is_ksm_zero_pte(pte)) {
-		ksm_zero_pages--;
-		mm->ksm_zero_pages--;
+		atomic_long_dec(&ksm_zero_pages);
+		atomic_long_dec(&mm->ksm_zero_pages);
 	}
 }
 
+static inline long mm_ksm_zero_pages(struct mm_struct *mm)
+{
+	return atomic_long_read(&mm->ksm_zero_pages);
+}
+
 static inline int ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
 	int ret;
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -899,7 +899,7 @@ struct mm_struct {
 		 * Represent how many empty pages are merged with kernel zero
 		 * pages when enabling KSM use_zero_pages.
 		 */
-		unsigned long ksm_zero_pages;
+		atomic_long_t ksm_zero_pages;
 #endif /* CONFIG_KSM */
 #ifdef CONFIG_LRU_GEN
 		struct {
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -282,7 +282,7 @@ static unsigned int zero_checksum __read
 static bool ksm_use_zero_pages __read_mostly;
 
 /* The number of zero pages which is placed by KSM */
-unsigned long ksm_zero_pages;
+atomic_long_t ksm_zero_pages = ATOMIC_LONG_INIT(0);
 
 #ifdef CONFIG_NUMA
 /* Zeroed when merging across nodes is not allowed */
@@ -1242,8 +1242,7 @@ static int replace_page(struct vm_area_s
 		 * the dirty bit in zero page's PTE is set.
 		 */
 		newpte = pte_mkdirty(pte_mkspecial(pfn_pte(page_to_pfn(kpage), vma->vm_page_prot)));
-		ksm_zero_pages++;
-		mm->ksm_zero_pages++;
+		ksm_map_zero_page(mm);
 		/*
 		 * We're replacing an anonymous page with a zero page, which is
 		 * not anonymous. We need to do proper accounting otherwise we
@@ -3105,7 +3104,7 @@ static void wait_while_offlining(void)
 #ifdef CONFIG_PROC_FS
 long ksm_process_profit(struct mm_struct *mm)
 {
-	return (long)(mm->ksm_merging_pages + mm->ksm_zero_pages) * PAGE_SIZE -
+	return (long)(mm->ksm_merging_pages + mm_ksm_zero_pages(mm)) * PAGE_SIZE -
 		mm->ksm_rmap_items * sizeof(struct ksm_rmap_item);
 }
 #endif /* CONFIG_PROC_FS */
@@ -3384,7 +3383,7 @@ KSM_ATTR_RO(pages_volatile);
 static ssize_t ksm_zero_pages_show(struct kobject *kobj,
 				struct kobj_attribute *attr, char *buf)
 {
-	return sysfs_emit(buf, "%ld\n", ksm_zero_pages);
+	return sysfs_emit(buf, "%ld\n", atomic_long_read(&ksm_zero_pages));
 }
 KSM_ATTR_RO(ksm_zero_pages);
 
@@ -3393,7 +3392,7 @@ static ssize_t general_profit_show(struc
 {
 	long general_profit;
 
-	general_profit = (ksm_pages_sharing + ksm_zero_pages) * PAGE_SIZE -
+	general_profit = (ksm_pages_sharing + atomic_long_read(&ksm_zero_pages)) * PAGE_SIZE -
 				ksm_rmap_items * sizeof(struct ksm_rmap_item);
 
 	return sysfs_emit(buf, "%ld\n", general_profit);


