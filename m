Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2345D365A19;
	Thu, 30 Jul 2026 14:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423027; cv=none; b=N+/AbSOkcGWAgoiKnoap3cLr4gZBPneqDm0Df8hrcQfJ+hacKjgocCrJg5pud9+ifqPBjgyQtgSvGiV9pcBh9X+hzwGis/WH2dD2lk0IpC9ejYzGtdXQL9kRvRzSG/GS8NK7TW4yidJ+QXO4jeeGnu9Qn1xdH87r2JDhZ1Rd6/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423027; c=relaxed/simple;
	bh=XO4Bnq3j5ZyRWaFBzRyYWu+nP2WiO2v+j1Nf+8jVWVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hjhkNUl2qSI1N/YR19XuxjEOjjN/5/A1Da1MPnZRSm1ZmQrJ/3aFB5Dq0vHNf98nr5Sz3DzJIhByzro5FjADQXXR6SU2Kmp8GhL00DarYGWthjKh4/cKQhSotnI/28RrRgQUCArHNdeyADlSNDI33mpEOl8+q+fII92iyK7GsWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xfkF6aDd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xfkF6aDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A6BA1F000E9;
	Thu, 30 Jul 2026 14:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423026;
	bh=Xjw7gQ3cnc/H/xzCLEXRBD9vcTmzTc/uCbZwUMi/Nyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xfkF6aDdYzSWWDQvTsDYj+ZhgYWFAYx5TsorQ8a5lqyClKfxSJpfJ6BBiDQsXCAL5
	 Kv0CEvJYnWxQdWxbQhF1s3HZ0TGLs8oWNwqunn8yntcLfPEaXV7IhNiO6XUEdTDC5X
	 GsAApCsxs346bhcaBfQGhIB3qSqWP+wjhUQAtHcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Muchun Song <muchun.song@linux.dev>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 7.1 603/744] arm64: make huge_ptep_get handled unaligned addresses
Date: Thu, 30 Jul 2026 16:14:36 +0200
Message-ID: <20260730141457.093629826@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dev Jain <dev.jain@arm.com>

commit f73a8edc2ccc6ec72c37d5c578e7592d2e1f9922 upstream.

huge_ptep_get() can be handed a virtual address pointing to the middle
of a contpmd/contpte mapped hugetlb folio (examples of callers are
pagemap_hugetlb_range, page_mapped_in_vma).

The arm64 helper rewalks the pgtables in find_num_contig to answer
whether the huge pte we have maps a contpmd or a contpte hugetlb folio,
and returns CONT_PMDS or CONT_PTES, so that it can collect a/d bits over
the contiguous ptes. We can falsely return CONT_PTES instead of
CONT_PMDS if the addr is not aligned. On systems where CONT_PTES !=
CONT_PMDS (meaning page size is 16K), we could collect excess A/D bit
state, meaning extra work for the kernel. Even worse, we may iterate
beyond the PTE table and dereference a garbage ptep pointer to access
physical memory we don't own. Since the ptep pointer is a linear map
address, we may run off the end of the linear map or into a hole,
dereference a VA not mapped into the kernel pgtables and cause kernel
panic.

Fix this by aligning the pmdp pointer down to a contpmd base before
checking equality with the passed huge pte pointer, to correctly answer
whether the huge pte is the base of a contpmd block.

Fixes: 29cb80519689 ("arm64: hugetlb: Cleanup huge_pte size discovery mechanisms")
Cc: stable@vger.kernel.org
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/hugetlbpage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -87,7 +87,7 @@ static int find_num_contig(struct mm_str
 	p4dp = p4d_offset(pgdp, addr);
 	pudp = pud_offset(p4dp, addr);
 	pmdp = pmd_offset(pudp, addr);
-	if ((pte_t *)pmdp == ptep) {
+	if ((pte_t *)PTR_ALIGN_DOWN(pmdp, sizeof(*pmdp) * CONT_PMDS) == ptep) {
 		*pgsize = PMD_SIZE;
 		return CONT_PMDS;
 	}


