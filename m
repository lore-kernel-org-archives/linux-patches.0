Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E893A244687;
	Wed, 23 Sep 2026 14:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175249; cv=none; b=TsDtt6dul2q3wk9Ae0q2fEF/18xjbivaSfOnBtwkDwOL6i02RGxRfn5aQBcEkLVLCqNSzLn9iJ6gR2Hi8riuXLc4OVJutSxeE7G7iva3EhjSZBffIwFGD8CFy8BlkzspZfeuaPOTLGP49CZeAvZe34l3soJRdyjRQlMCtEUSCiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175249; c=relaxed/simple;
	bh=v7ob1bXtGQ8Me5gB2x20UlY+q3jR8b40QHcjOIp+a7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwB4F1QNnNKCQayVeRyT35SLcVymZ0FBkuLT7GrWJZmyb88+EEuywbscXjvbNwjsIFBDxE7XJ1lNRZCZevbSRshRaHZ9g3NoGymPRwwElrMSDfZLQKjR+wuLl6Y/6e4c+Cvv2lDMlJzVZqRqn/q2nxL0MEISIq789mxa1l12Iec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pxwIW1Qo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pxwIW1Qo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26BD61F000FF;
	Wed, 23 Sep 2026 14:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175247;
	bh=HKVNHQgAnbFmepZfFKyijIUrGO7ahKGE79KRBjlURco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pxwIW1QoV7a61OrYGLdUdr8TbCHSNYffYL6FDkkzpdZQTCuRtSuGkxTRelYdXp7iY
	 E3PoSNa0aAc5DptpBCRE7dyDicRDxHQ86Z7nkg7pLAytMvOcO4TzrAfnEr+1fhrTaJ
	 SqJEMO3sc/qaOguGNF9M58ZzcJnggC3RC79lbFgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Jann Horn <jannh@google.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 368/398] mm: move vma_kernel_pagesize() from hugetlb to mm.h
Date: Wed, 23 Sep 2026 16:07:22 +0200
Message-ID: <20260923140652.982079812@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: "David Hildenbrand (Arm)" <david@kernel.org>

[ Upstream commit 341ffe82a7a3a1e0756b58999405b6df0c2b3e8d ]

Patch series "mm: move vma_(kernel|mmu)_pagesize() out of hugetlb.c", v2.

Looking into vma_(kernel|mmu)_pagesize(), I realized that there is one
scenario where DAX would not do the right thing when the kernel is not
compiled with hugetlb support.

Without hugetlb support, vma_(kernel|mmu)_pagesize() will always return
PAGE_SIZE instead of using the ->pagesize() result provided by dax-device
code.

Fix that by moving vma_kernel_pagesize() to core MM code, where it
belongs.  I don't think this is stable material, but am not 100% sure.

Also, move vma_mmu_pagesize() while at it.  Remove the unnecessary
hugetlb.h inclusion from KVM code.

This patch (of 4):

In the past, only hugetlb had special "vma_kernel_pagesize()"
requirements, so it provided its own implementation.

In commit 05ea88608d4e ("mm, hugetlbfs: introduce ->pagesize() to
vm_operations_struct") we generalized that approach by providing a
vm_ops->pagesize() callback to be used by device-dax.

Once device-dax started using that callback in commit c1d53b92b95c
("device-dax: implement ->pagesize() for smaps to report MMUPageSize") it
was missed that CONFIG_DEV_DAX does not depend on hugetlb support.

So building a kernel with CONFIG_DEV_DAX but without CONFIG_HUGETLBFS
would not pick up that value.

Fix it by moving vma_kernel_pagesize() to mm.h, providing only a single
implementation.  While at it, improve the kerneldoc a bit.

Ideally, we'd move vma_mmu_pagesize() as well to the header.  However, its
__weak symbol might be overwritten by a PPC variant in hugetlb code.  So
let's leave it in there for now, as it really only matters for some
hugetlb oddities.

This was found by code inspection.

Link: https://lkml.kernel.org/r/20260309151901.123947-1-david@kernel.org
Link: https://lkml.kernel.org/r/20260309151901.123947-2-david@kernel.org
Fixes: c1d53b92b95c ("device-dax: implement ->pagesize() for smaps to report MMUPageSize")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: e384abeb559d ("mm/huge_memory: bypass THP tuneables for huge pfnmap mappings")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hugetlb.h |    7 -------
 include/linux/mm.h      |   20 ++++++++++++++++++++
 mm/hugetlb.c            |   17 -----------------
 3 files changed, 20 insertions(+), 24 deletions(-)

--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -767,8 +767,6 @@ static inline unsigned long huge_page_si
 	return (unsigned long)PAGE_SIZE << h->order;
 }
 
-extern unsigned long vma_kernel_pagesize(struct vm_area_struct *vma);
-
 extern unsigned long vma_mmu_pagesize(struct vm_area_struct *vma);
 
 static inline unsigned long huge_page_mask(struct hstate *h)
@@ -1184,11 +1182,6 @@ static inline unsigned long huge_page_ma
 	return PAGE_MASK;
 }
 
-static inline unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
-{
-	return PAGE_SIZE;
-}
-
 static inline unsigned long vma_mmu_pagesize(struct vm_area_struct *vma)
 {
 	return PAGE_SIZE;
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1020,6 +1020,26 @@ static inline bool vma_is_shared_maywrit
 	return is_shared_maywrite(vma->vm_flags);
 }
 
+/**
+ * vma_kernel_pagesize - Default page size granularity for this VMA.
+ * @vma: The user mapping.
+ *
+ * The kernel page size specifies in which granularity VMA modifications
+ * can be performed. Folios in this VMA will be aligned to, and at least
+ * the size of the number of bytes returned by this function.
+ *
+ * The default kernel page size is not affected by Transparent Huge Pages
+ * being in effect.
+ *
+ * Return: The default page size granularity for this VMA.
+ */
+static inline unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
+{
+	if (unlikely(vma->vm_ops && vma->vm_ops->pagesize))
+		return vma->vm_ops->pagesize(vma);
+	return PAGE_SIZE;
+}
+
 static inline
 struct vm_area_struct *vma_find(struct vma_iterator *vmi, unsigned long max)
 {
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1027,23 +1027,6 @@ static pgoff_t vma_hugecache_offset(stru
 			(vma->vm_pgoff >> huge_page_order(h));
 }
 
-/**
- * vma_kernel_pagesize - Page size granularity for this VMA.
- * @vma: The user mapping.
- *
- * Folios in this VMA will be aligned to, and at least the size of the
- * number of bytes returned by this function.
- *
- * Return: The default size of the folios allocated when backing a VMA.
- */
-unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
-{
-	if (vma->vm_ops && vma->vm_ops->pagesize)
-		return vma->vm_ops->pagesize(vma);
-	return PAGE_SIZE;
-}
-EXPORT_SYMBOL_GPL(vma_kernel_pagesize);
-
 /*
  * Return the page size being used by the MMU to back a VMA. In the majority
  * of cases, the page size used by the kernel matches the MMU size. On


