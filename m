Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE85C1B395C;
	Mon, 23 Dec 2024 16:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970139; cv=none; b=J+xyTPNDLwJFoSCSBzGrs+qJRqi5oLgt4tzkVZwrqf0axvGlXtDIHqipt2WYHd4PW8y0f96X5AroHJ2lSnlRYSY6nLx9xH/M08pCAGsP72XROtFqPB6nvvvBByhMS/wggYsVTlC+P6DgVGuiO21uhvZusmGTAHdGQDHFGu8kewo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970139; c=relaxed/simple;
	bh=8jctfwiTah3S2Qtr9MahY1v3MUyRd3hI9HtnU4b9e/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WyJ9wLv0RH/6iBXERC/i4jaXGgusfjlWSCMzsOo8mDmsJKSdXMEotvSr+rtbPTGrGBN7jaK7d4ko2NH4Liex9swvmK1DhYRzxB1uxaDKEWxzBq7o/3xNl1Kwtn3+P+cEKN66DaHgCKCt3bCa3jbAwqexn3yIVfH0wZd8j/vtBrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xOgO2lXQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xOgO2lXQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4633BC4CED6;
	Mon, 23 Dec 2024 16:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970138;
	bh=8jctfwiTah3S2Qtr9MahY1v3MUyRd3hI9HtnU4b9e/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xOgO2lXQ03s0ZBWqdCNl+9dv5xk2MTxZfDmJjA7zhmghL0jD1YtOegVbsIRV3bgjF
	 A13u54M4ea2JzlkT2brzqa1XSYqd5dls4EYfFkgevwSrY0/eOxIrKGvsvW0XrGHmeE
	 fi7NeHhNpGn7TCMd9F4wh2kq1r4A6sWgoqcndKw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	David Hildenbrand <david@redhat.com>,
	Huang Ying <ying.huang@intel.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 157/160] mm: use aligned address in copy_user_gigantic_page()
Date: Mon, 23 Dec 2024 16:59:28 +0100
Message-ID: <20241223155414.889533845@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kefeng Wang <wangkefeng.wang@huawei.com>

commit f5d09de9f1bf9674c6418ff10d0a40cfe29268e1 upstream.

In current kernel, hugetlb_wp() calls copy_user_large_folio() with the
fault address.  Where the fault address may be not aligned with the huge
page size.  Then, copy_user_large_folio() may call
copy_user_gigantic_page() with the address, while
copy_user_gigantic_page() requires the address to be huge page size
aligned.  So, this may cause memory corruption or information leak,
addtional, use more obvious naming 'addr_hint' instead of 'addr' for
copy_user_gigantic_page().

Link: https://lkml.kernel.org/r/20241028145656.932941-2-wangkefeng.wang@huawei.com
Fixes: 530dd9926dc1 ("mm: memory: improve copy_user_large_folio()")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    5 ++---
 mm/memory.c  |    5 +++--
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5333,7 +5333,7 @@ again:
 					break;
 				}
 				ret = copy_user_large_folio(new_folio, pte_folio,
-						ALIGN_DOWN(addr, sz), dst_vma);
+							    addr, dst_vma);
 				folio_put(pte_folio);
 				if (ret) {
 					folio_put(new_folio);
@@ -6632,8 +6632,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 			*foliop = NULL;
 			goto out;
 		}
-		ret = copy_user_large_folio(folio, *foliop,
-					    ALIGN_DOWN(dst_addr, size), dst_vma);
+		ret = copy_user_large_folio(folio, *foliop, dst_addr, dst_vma);
 		folio_put(*foliop);
 		*foliop = NULL;
 		if (ret) {
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6817,13 +6817,14 @@ void folio_zero_user(struct folio *folio
 }
 
 static int copy_user_gigantic_page(struct folio *dst, struct folio *src,
-				   unsigned long addr,
+				   unsigned long addr_hint,
 				   struct vm_area_struct *vma,
 				   unsigned int nr_pages)
 {
-	int i;
+	unsigned long addr = ALIGN_DOWN(addr_hint, folio_size(dst));
 	struct page *dst_page;
 	struct page *src_page;
+	int i;
 
 	for (i = 0; i < nr_pages; i++) {
 		dst_page = folio_page(dst, i);


