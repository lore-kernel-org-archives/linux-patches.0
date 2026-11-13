Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590330;
	b=aLYLRV6I2vVBczjRr0aGHUaMpm5sPL/YM3ykxAhZWBLV8LxVKIytipqEHXFBcbB0QBHs
	 JZoedVjhq5QWPbfddXHmt8+1dpLfmlHLKgZTvdu9/qqXW1rEvLqCgiuzsSnkJUR6rbMki
	 TglnLK9F28jdPwY+Iu0atK3v6qiLBSYatxXZKlYgha8mBDF9HC3C05cyHUnXfKPJK6Z4T
	 QbaocGd4vvMHzRkvVWc2XoBCZxBOrjxbiGYyr5S+27aLngOlb9rZPgMm87OV9FCOaxfgW
	 bBSrdUm5cnqCxB4+dGreyz8xyxmoGaT0UtNMTH8faCMsflFrq65rRTmLdLBNimTVVpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590330;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xBD2FGnerQzCu2EUj4V58rr590nDQx0rwT9uYEK/QFM=;
	b=pfk81ZIZ3N+dFtUacgxGENuKwaEAyH4uoK8Jw+1RA7yQ+0fJQffQRX8p0dTXzCu/AVpG
	 vNSUfgCkAR27F7QlIPGjcblpvEPO+V4H3QdqnaX+jpsde3qmvVMxAJVFaTYERVL/wfkFH
	 CO/HLlO0NgrGk1vTgZOlDQw/IbDXcbpkC7Hr13msY/LlC6meGWuOlPd6FqD3FqI6PB7eE
	 ewT2XSWyrt6go9KHLRvGa/Guef1e1OthUlxLs4AgFo32XTcp3v2UgrtlE3dH5wpC+008L
	 G7NJIX9ARUmWMUsuB2lcM9SYIvdA0PL48089717Ka3OaVySL5M/zt9mP1Ol1ZtVuyzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="rHY/AWOK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3810606D49E;
	Fri, 13 Nov 2026 17:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rHY/AWOK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8483E1F000C7;
	Fri, 13 Nov 2026 17:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590330;
	bh=xBD2FGnerQzCu2EUj4V58rr590nDQx0rwT9uYEK/QFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rHY/AWOK76X2psVQETMQRqP9d7VoCRpU8d1evKLUi8PHw9c8BZ2FpE3umevASovN5
	 aucm5Td0ir6BuoEyRQkGNfkYJF6oXL2PhYJHZVQNPexQoj3CW03rOzcGVOoP4a14u1
	 qpdSrSxSxwsZdCrOax2qjkyVA7roxBIebCHlcXbA=
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
Subject: [PATCH 6.18 310/686] mm/hugetlb: fix mremap move length truncation
Date: Fri, 13 Nov 2026 10:47:23 -0500
Message-ID: <20261113153831.451603166@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ca6d6eb817118..d43965f4b6c82 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -122,10 +122,9 @@ void hugepage_put_subpool(struct hugepage_subpool *spool);
 
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
@@ -340,11 +339,9 @@ static inline int copy_hugetlb_page_range(struct mm_struct *dst,
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
index 42aace6e3ca17..1d71352bfec57 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5828,10 +5828,9 @@ static void move_huge_pte(struct vm_area_struct *vma, unsigned long old_addr,
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



