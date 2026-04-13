Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5827C26CE32;
	Mon, 13 Apr 2026 16:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097638; cv=none; b=imP64KCSyIZOmFNGXoP2QLTPNfz6wwQutNCYa/Gz4SkDWijfj4AASF8RsTChS3FuDOREwB+QIaG8ZqIuBE1EiM/njyog9z5vt8TQncX+0X2pLq0ARMZIkxFwqVaSkw0hd7/uv0r6vYhVSrgsrHjoli2IfJjYCOAFUZaXIk+cpmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097638; c=relaxed/simple;
	bh=EUY6LeTrq+wK2tecLTTIFv21UNSC/kIAMmPxec6ba94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=auOvQNdXBfqV1/33P5dwItRH2iDtQ+pniKtFTRwGPITc558rhFQntjmj3Z6wd7qXIJHTGhtdaxb6Wkh3exDZ3uz4eYWUawQD7LaVQ+ksgKZsbv7NTWrgzH7cyQtjx1dQHLtzcvPH8iykCnC31bkFdlNpeFDODIf8wKb20Z9VI8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rWOeXkp0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rWOeXkp0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E203AC2BCAF;
	Mon, 13 Apr 2026 16:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097638;
	bh=EUY6LeTrq+wK2tecLTTIFv21UNSC/kIAMmPxec6ba94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rWOeXkp0vHuZjKAgMxrN+EHlnB7/oYtd2cnoa8OVQgMVWQiTd43QEq2DUL5D9o8YA
	 PXFJ/Cz6nNSqab/1AtVXa3p8lhFa5lAG9QCeXMY8KUOiBJ0hH0287G64ovjYeqNuhg
	 InlHMZM1GNU4P8H3/ZHYvBSA6TpKg0C2OPImXJ9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaohe Lin <linmiaohe@huawei.com>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH 5.15 214/570] mm/hugetlb: make detecting shared pte more reliable
Date: Mon, 13 Apr 2026 17:55:45 +0200
Message-ID: <20260413155838.472278978@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaohe Lin <linmiaohe@huawei.com>

commit 3aa4ed8040e1535d95c03cef8b52cf11bf0d8546 upstream.

If the pagetables are shared, we shouldn't copy or take references.  Since
src could have unshared and dst shares with another vma, huge_pte_none()
is thus used to determine whether dst_pte is shared.  But this check isn't
reliable.  A shared pte could have pte none in pagetable in fact.  The
page count of ptep page should be checked here in order to reliably
determine whether pte is shared.

[lukas.bulwahn@gmail.com: remove unused local variable dst_entry in copy_hugetlb_page_range()]
  Link: https://lkml.kernel.org/r/20220822082525.26071-1-lukas.bulwahn@gmail.com
Link: https://lkml.kernel.org/r/20220816130553.31406-7-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4304,7 +4304,7 @@ hugetlb_install_page(struct vm_area_stru
 int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 			    struct vm_area_struct *vma)
 {
-	pte_t *src_pte, *dst_pte, entry, dst_entry;
+	pte_t *src_pte, *dst_pte, entry;
 	struct page *ptepage;
 	unsigned long addr;
 	bool cow = is_cow_mapping(vma->vm_flags);
@@ -4343,28 +4343,23 @@ int copy_hugetlb_page_range(struct mm_st
 
 		/*
 		 * If the pagetables are shared don't copy or take references.
-		 * dst_pte == src_pte is the common case of src/dest sharing.
 		 *
+		 * dst_pte == src_pte is the common case of src/dest sharing.
 		 * However, src could have 'unshared' and dst shares with
-		 * another vma.  If dst_pte !none, this implies sharing.
-		 * Check here before taking page table lock, and once again
-		 * after taking the lock below.
+		 * another vma. So page_count of ptep page is checked instead
+		 * to reliably determine whether pte is shared.
 		 */
-		dst_entry = huge_ptep_get(dst_pte);
-		if ((dst_pte == src_pte) || !huge_pte_none(dst_entry))
+		if (page_count(virt_to_page(dst_pte)) > 1)
 			continue;
 
 		dst_ptl = huge_pte_lock(h, dst, dst_pte);
 		src_ptl = huge_pte_lockptr(h, src, src_pte);
 		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
 		entry = huge_ptep_get(src_pte);
-		dst_entry = huge_ptep_get(dst_pte);
 again:
-		if (huge_pte_none(entry) || !huge_pte_none(dst_entry)) {
+		if (huge_pte_none(entry)) {
 			/*
-			 * Skip if src entry none.  Also, skip in the
-			 * unlikely case dst entry !none as this implies
-			 * sharing with another vma.
+			 * Skip if src entry none.
 			 */
 			;
 		} else if (unlikely(is_hugetlb_entry_migration(entry) ||
@@ -4423,7 +4418,7 @@ again:
 					restore_reserve_on_error(h, vma, addr,
 								new);
 					put_page(new);
-					/* dst_entry won't change as in child */
+					/* huge_ptep of dst_pte won't change as in child */
 					goto again;
 				}
 				hugetlb_install_page(vma, dst_pte, addr, new);


