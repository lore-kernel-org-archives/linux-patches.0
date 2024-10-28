Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E1218A922;
	Mon, 28 Oct 2024 06:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098185; cv=none; b=KkFY2JKoWPK2WTQD6qIt8tu/1QNF8RLJe3RyD3pm/U6DR5VXZrfAZJiNyWhUBtN0kupMrgaRhv+5h3KcCfWcdSeU4ZuawbJlYG3YBGQ4OrQXikrrZZ7BNDKiXm7D2OyPIHvP6gB/I8ijn8ChZX2J8yaTtpTvoKLg+GJZAm/+7WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098185; c=relaxed/simple;
	bh=UaCo9UmhU4EYUByOTDVYPfwv5BDayQS8t4QH7eJKb1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m+QHAZBy6iHpxjZ2BY+fuHhiZJSDtCib+BPcQQsnCIpE23bBNmUI3YZCw3je6C6TmI5/k6ZZMyYsPbg7Hka6ANjkIP31mS6LqFu+4KjMdwG+ek6zTP0va3txmllMsfIr4m1k4Ym9CxWn0SmwEpb+OANATfjSwHonXGgk0xiHf0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XuA2RxkU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XuA2RxkU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42149C4CEC3;
	Mon, 28 Oct 2024 06:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098184;
	bh=UaCo9UmhU4EYUByOTDVYPfwv5BDayQS8t4QH7eJKb1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XuA2RxkUqfV/jED6Mfgg4qK2wseJKfyUhq7Ji578ZLfI6tmZvrI3EpRHZqVKLXgeJ
	 +cZ8mr8gbL3J9zb0yG5h4kWZ7N23hrhhi2TWMDVURZFhEvwzRWekRoiW5LJDD2inIo
	 Pig+A0/LM65rWcbkElWEuxYQ/wJ6zMSFV3phCCOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	David Hildenbrand <david@redhat.com>,
	Leo Fu <bfu@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Hugh Dickins <hughd@google.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 115/261] mm: huge_memory: add vma_thp_disabled() and thp_disabled_by_hw()
Date: Mon, 28 Oct 2024 07:24:17 +0100
Message-ID: <20241028062314.911195962@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kefeng Wang <wangkefeng.wang@huawei.com>

[ Upstream commit 963756aac1f011d904ddd9548ae82286d3a91f96 ]

Patch series "mm: don't install PMD mappings when THPs are disabled by the
hw/process/vma".

During testing, it was found that we can get PMD mappings in processes
where THP (and more precisely, PMD mappings) are supposed to be disabled.
While it works as expected for anon+shmem, the pagecache is the
problematic bit.

For s390 KVM this currently means that a VM backed by a file located on
filesystem with large folio support can crash when KVM tries accessing the
problematic page, because the readahead logic might decide to use a
PMD-sized THP and faulting it into the page tables will install a PMD
mapping, something that s390 KVM cannot tolerate.

This might also be a problem with HW that does not support PMD mappings,
but I did not try reproducing it.

Fix it by respecting the ways to disable THPs when deciding whether we can
install a PMD mapping.  khugepaged should already be taking care of not
collapsing if THPs are effectively disabled for the hw/process/vma.

This patch (of 2):

Add vma_thp_disabled() and thp_disabled_by_hw() helpers to be shared by
shmem_allowable_huge_orders() and __thp_vma_allowable_orders().

[david@redhat.com: rename to vma_thp_disabled(), split out thp_disabled_by_hw() ]
Link: https://lkml.kernel.org/r/20241011102445.934409-2-david@redhat.com
Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Leo Fu <bfu@redhat.com>
Tested-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Boqiao Fu <bfu@redhat.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 2b0f922323cc ("mm: don't install PMD mappings when THPs are disabled by the hw/process/vma")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/huge_mm.h | 18 ++++++++++++++++++
 mm/huge_memory.c        | 13 +------------
 mm/shmem.c              |  7 +------
 3 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index e25d9ebfdf89a..6d334c211176c 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -308,6 +308,24 @@ static inline void count_mthp_stat(int order, enum mthp_stat_item item)
 	(transparent_hugepage_flags &					\
 	 (1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG))
 
+static inline bool vma_thp_disabled(struct vm_area_struct *vma,
+		unsigned long vm_flags)
+{
+	/*
+	 * Explicitly disabled through madvise or prctl, or some
+	 * architectures may disable THP for some mappings, for
+	 * example, s390 kvm.
+	 */
+	return (vm_flags & VM_NOHUGEPAGE) ||
+	       test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags);
+}
+
+static inline bool thp_disabled_by_hw(void)
+{
+	/* If the hardware/firmware marked hugepage support disabled. */
+	return transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED);
+}
+
 unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d12ec1c8c7f07..e44508e46e897 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -106,18 +106,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	if (!vma->vm_mm)		/* vdso */
 		return 0;
 
-	/*
-	 * Explicitly disabled through madvise or prctl, or some
-	 * architectures may disable THP for some mappings, for
-	 * example, s390 kvm.
-	 * */
-	if ((vm_flags & VM_NOHUGEPAGE) ||
-	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
-		return 0;
-	/*
-	 * If the hardware/firmware marked hugepage support disabled.
-	 */
-	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED))
+	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vm_flags))
 		return 0;
 
 	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
diff --git a/mm/shmem.c b/mm/shmem.c
index a332323eea0b9..27f496d6e43eb 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1642,12 +1642,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	loff_t i_size;
 	int order;
 
-	if (vma && ((vm_flags & VM_NOHUGEPAGE) ||
-	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags)))
-		return 0;
-
-	/* If the hardware/firmware marked hugepage support disabled. */
-	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED))
+	if (thp_disabled_by_hw() || (vma && vma_thp_disabled(vma, vm_flags)))
 		return 0;
 
 	global_huge = shmem_huge_global_enabled(inode, index, shmem_huge_force,
-- 
2.43.0



