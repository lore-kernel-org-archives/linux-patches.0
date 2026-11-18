Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037780;
	b=F+49km+ErbiqVmbxkIJBdz0Yf/LW5b+i7XQgOsu/kA0G7owUyXoplWC+DcRytgAwh2OE
	 nM6Ugey9euECHwlQnvQXDROCsEGjzDmED6tLWiIyXkpD6nHwDQ+Lg4B35wLmYmQgT88WB
	 9szBXKzVaDwICvbS6N9KAm8EmDPaFQv3NHbbNuve4M6pySXxd8XsGJH5dtuNvZbKsPFUe
	 HEILWWdLx0lCMfwchsg2k1SvUN4Cz4wipv0/KBB3aw97H+MixNVk1V88hT4bbv5ZmXopC
	 80S51zUARh9D4oquBKI/CSmntYOJJ/qP94E3bOnA1IFLqpv/0qx8es7HI7VRcWa0Sqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037780;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QTx/Sl7f+9Rnf0mnBFQBDftmUL+WYkmTkkb2kojq/iU=;
	b=BCcHprJ7LT+qLjzPnASUG92KnHDFiir56bWEDMkPASFXNuCzz5EeZyZrH4Rzy06flQFM
	 cke2/qw7D+S6fuLvV34j5R5uMcZbYf9XHO3UD4bynaUBqJb6gd/PwVJEpuaJ71JZCirGH
	 Y3Mxba+sWGdRzk68/k2pmj4o7onsBR9RX5GqqjAW8LPZVEphZgkJhhgs4J1RNCE6WMd5w
	 VgEi5wx7jQiDLfs9x6A37ZXb1kRep6ze38N7NTsKBnItl2u/EuCyy0dHDSlvhCF+PNeo9
	 es/ZnTD+lxDtaQDuty9XsVQvRHWxZs3PpBx2qV02lYe/htkadvW68aoXT0FpHGhMbqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v2v0gyeE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F391606A31C;
	Wed, 18 Nov 2026 21:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v2v0gyeE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C3D51F000C4;
	Wed, 18 Nov 2026 21:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037780;
	bh=QTx/Sl7f+9Rnf0mnBFQBDftmUL+WYkmTkkb2kojq/iU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v2v0gyeErMuIciy7WqarEgLtLldzN0zrbihVd4mFQ7z9sS01cULfDZHfJ5e+hkbgE
	 IBm/fzPQ30yAs9SUn9Mt/XLpiY2BUz2drAq5tWBYK9NWX9lFjWLpy/gMVAXlt+inR2
	 qgVigeZBlps3PXakls5feKttOEJK4bGLJrh6k9iQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zhe <lizhe.67@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1475/3318] mm/hugetlb: fix mremap move length truncation
Date: Wed, 18 Nov 2026 15:34:57 +0100
Message-ID: <20261118150405.154231227@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zhe <lizhe.67@bytedance.com>

[ Upstream commit dfb190302d2b4af86c6ae48af0d3b09f28b35460 ]

Patch series "mm/hugetlb: fix mremap bugs", v3.

This series fixes a few hugetlb mremap bugs.

Patch 1 fixes the return type of move_hugetlb_page_tables(), so large
hugetlb moves cannot be truncated when reported back to the generic
mremap code.

Patch 2 disables hugetlb PMD sharing for UFFD missing mode, so
UFFDIO_POISON markers cannot become visible through shared PMD page
tables.

Patch 3 fixes the recursive i_mmap_rwsem deadlock in the hugetlb mremap
path by avoiding the destination PMD sharing allocation path while the
mapping lock is already held for write.

This patch (of 3):

move_hugetlb_page_tables() returns the number of bytes moved, but
its return type is int while the generic move_page_tables() path uses
unsigned long lengths.

A hugetlb mremap() move length above INT_MAX can therefore be
misreported to copy_vma_and_data(). The out-of-range conversion to int
is implementation-defined; on common 64-bit builds, for example, a
4 GiB move can be reported as zero, making the caller treat the move as
a failure and use the wrong length for rollback.

Return unsigned long from move_hugetlb_page_tables(), matching
move_page_tables() and preserving the full byte count.

Link: https://lore.kernel.org/20261022034543.51226-1-lizhe.67@bytedance.com
Link: https://lore.kernel.org/20261022034543.51226-2-lizhe.67@bytedance.com
Fixes: 550a7d60bd5e ("mm, hugepages: add mremap() support for hugepage backed vma")
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/hugetlb.h | 15 ++++++---------
 mm/hugetlb.c            |  7 +++----
 2 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 5b211cabfbb4d..32b5c6efd089e 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -127,10 +127,9 @@ void hugepage_put_subpool(struct hugepage_subpool *spool);
 
 void hugetlb_dup_vma_private(struct vm_area_struct *vma);
 void clear_vma_resv_huge_pages(struct vm_area_struct *vma);
-int move_hugetlb_page_tables(struct vm_area_struct *vma,
-			     struct vm_area_struct *new_vma,
-			     unsigned long old_addr, unsigned long new_addr,
-			     unsigned long len);
+unsigned long move_hugetlb_page_tables(struct vm_area_struct *vma,
+		struct vm_area_struct *new_vma, unsigned long old_addr,
+		unsigned long new_addr, unsigned long len);
 int copy_hugetlb_page_range(struct mm_struct *, struct mm_struct *,
 			    struct vm_area_struct *, struct vm_area_struct *);
 struct page *hugetlb_follow_page_mask(struct vm_area_struct *vma,
@@ -348,11 +347,9 @@ static inline int copy_hugetlb_page_range(struct mm_struct *dst,
 	return 0;
 }
 
-static inline int move_hugetlb_page_tables(struct vm_area_struct *vma,
-					   struct vm_area_struct *new_vma,
-					   unsigned long old_addr,
-					   unsigned long new_addr,
-					   unsigned long len)
+static inline unsigned long move_hugetlb_page_tables(struct vm_area_struct *vma,
+		struct vm_area_struct *new_vma, unsigned long old_addr,
+		unsigned long new_addr, unsigned long len)
 {
 	BUG();
 	return 0;
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 30e2531cc8568..34eedfec4ff8a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5271,10 +5271,9 @@ static void move_huge_pte(struct vm_area_struct *vma, unsigned long old_addr,
 	spin_unlock(dst_ptl);
 }
 
-int move_hugetlb_page_tables(struct vm_area_struct *vma,
-			     struct vm_area_struct *new_vma,
-			     unsigned long old_addr, unsigned long new_addr,
-			     unsigned long len)
+unsigned long move_hugetlb_page_tables(struct vm_area_struct *vma,
+		struct vm_area_struct *new_vma, unsigned long old_addr,
+		unsigned long new_addr, unsigned long len)
 {
 	struct hstate *h = hstate_vma(vma);
 	struct address_space *mapping = vma->vm_file->f_mapping;
-- 
2.53.0



