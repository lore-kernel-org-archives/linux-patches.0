Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993731FBCBB;
	Wed,  6 Nov 2024 12:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897708; cv=none; b=fklCilAsBkJUIMpw7jW4vaPcbj8D+3ZTXpGGD477Qs6zKEsrtINGZpOwrk39Xn5yDiZ7vDRb8m0A0UYhoAv+Xt9LpbhX1ZFXjoUgl32p1uDPrRcWP9FlY5/+r4ekZQ2AqrY910nRo0fEuWBYoG65WX5XAT8FZKQ8Iai/b/R4I94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897708; c=relaxed/simple;
	bh=xSMDZZK/Ol4espxmTzwWjxdSgTj7dZB9kX+fiy+fjlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lsW3nTJp6KvV6EweLFcYaSUoeyBmdfI6/V/fDLTvtjHOBs8ovGHqj+IwgrQMkv/enTLMQHY3wGR+kPx1tObcBILffJTMBdHTNcbYii8sA9znlFdNTKq7tg/j0D9Fo5NHlQpsP6TfGHRDb0MDhqzRmzplb/w6dHulGaqQ7jCq89s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ktFn4wI8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ktFn4wI8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62B0C4CECD;
	Wed,  6 Nov 2024 12:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897708;
	bh=xSMDZZK/Ol4espxmTzwWjxdSgTj7dZB9kX+fiy+fjlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ktFn4wI8gCRohe9G6dawf7r7Xuxgx27pNHwbqO5PHwkWiLexyCjFJRwz/SL9mVVCp
	 EvcXyVltU8SeSI5uQoDz0TpGRLt5xIizmfLDIBDBwitNsBxU358DHt/TQTrywJM+TQ
	 mKty0WKeElG+TCh68xXLhS0Ti0rPx6q4mwkAeRnc=
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
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 143/151] mm: huge_memory: add vma_thp_disabled() and thp_disabled_by_hw()
Date: Wed,  6 Nov 2024 13:05:31 +0100
Message-ID: <20241106120312.785070083@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

From: Kefeng Wang <wangkefeng.wang@huawei.com>

commit 963756aac1f011d904ddd9548ae82286d3a91f96 upstream.

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
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/huge_mm.h |   18 ++++++++++++++++++
 mm/huge_memory.c        |   13 +------------
 2 files changed, 19 insertions(+), 12 deletions(-)

--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -137,6 +137,24 @@ bool hugepage_vma_check(struct vm_area_s
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
 
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -78,18 +78,7 @@ bool hugepage_vma_check(struct vm_area_s
 	if (!vma->vm_mm)		/* vdso */
 		return false;
 
-	/*
-	 * Explicitly disabled through madvise or prctl, or some
-	 * architectures may disable THP for some mappings, for
-	 * example, s390 kvm.
-	 * */
-	if ((vm_flags & VM_NOHUGEPAGE) ||
-	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
-		return false;
-	/*
-	 * If the hardware/firmware marked hugepage support disabled.
-	 */
-	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED))
+	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vm_flags))
 		return false;
 
 	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */


