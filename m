Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585601;
	b=vAuWYHTOYUM2qElC5N0hWkiMPRt8i8s6dp9Om+ZjsVyxGPM904dm15cIboV01S66n7N1
	 HZMfxhlu4qcmTVB94dFW8iQxKqLlb8a1nNGrZW+iWypocYzNUmgorETnkKp/A4w1vdonG
	 FXQsqPDDivO8M0oO5UqdXvWRbBDdheQUrkAxSJGlBxzMgQJJJ8RPkKceBjBXPNMvA6p5V
	 ASshsoCjbdtojUC8KUSzLAPydAoV5DT98o4Ude+PlxyhTUqiBuZ69szMXgffTGLCtDbJ0
	 BftZ65Pn2rygQFSJekdWcGFTMrqk9CFVviap++ei2ZDn1IeJ6jtn2FA8wbmBEhuzEjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585601;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DNnwnTAzlsccgk7qq88l9u4/xDkindeei8rM7vlZQoI=;
	b=XboNxfoUautAbGI3P1ymrL9kbIxo6WNRfEm7nVeiErn/f0lrEqw9lYKDHDa95qM2u3dA
	 NX6WK05Wb3KmzkFPjYrfrnQqrlmEmY0Ouqj32pILHM0qT9KeVXeYQTUbCX8XzqNY2Gkm4
	 XZagvpP/5fP8ajaXNYt2rJeugOrjraEnKwJ+zBlQw595HcPLlgMl5142El0x/AM3VLo7A
	 EEIiRG7GFTD367srwMM+O/FTJnmMu2QYoSm/nc8BIUBo/oNchdEZbE6lHOSoH76SThE0w
	 BCl8YlHhqqiruPBCdRUDw2nkbDtplD0iGwanSCnlwLYYtpgdmroAKgO+KWeTyJ1ICuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kwuqqWOj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5D9606A33B;
	Fri, 13 Nov 2026 16:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kwuqqWOj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8CA51F000C4;
	Fri, 13 Nov 2026 16:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585601;
	bh=DNnwnTAzlsccgk7qq88l9u4/xDkindeei8rM7vlZQoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kwuqqWOjq5s78roGqiP9vuC1TbWVv6tTg4IBRxBMK3lzTQCHm06S/BdluVi8HodH7
	 uQktyu7dxB8FRtVkIdZaJgW8WvzN+iVO5vahixWcFaVHQRQoxe58sN7mokhkA4rMdc
	 gXGvLYgmwdcsaEoPbsD9H0jGL2xJLyaMRqVHAZJM=
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
Subject: [PATCH 7.3 226/507] mm/hugetlb: fix mremap move length truncation
Date: Fri, 13 Nov 2026 10:48:50 -0500
Message-ID: <20261113153802.167638930@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 45ada75dc04e9..77d62c930dc37 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -121,10 +121,9 @@ void hugepage_put_subpool(struct hugepage_subpool *spool);
 
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
 void unmap_hugepage_range(struct vm_area_struct *,
@@ -339,11 +338,9 @@ static inline int copy_hugetlb_page_range(struct mm_struct *dst,
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
index e71e0ab116bfb..8eff9249dfb2b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5157,10 +5157,9 @@ static void move_huge_pte(struct vm_area_struct *vma, unsigned long old_addr,
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



