Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBCE3AA187;
	Thu, 30 Jul 2026 15:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424742; cv=none; b=mVxOv0GIcrIWSoyHKuCUK/320wkNNMy+3VvuTfPWZWNcGR3h9T56suzVKEmu7XEuaDGVGxeOx6i/t64ex8OfR1GZjhDrusaqjNkw67rQ8btVRNS5WXmhYOlnz+abFZsNKQVDlRHPUmm/Q2Ufb+xbN3M9W2+dg8GZHxFgx5tcIZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424742; c=relaxed/simple;
	bh=8dLgqG+IL69SsRSaHSD7oB1kdEZZcFUSCmCaPBBfaRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGippwCLrQ7LCFaIXhwkd3/GnUwbg8M03cLaehAX3kZ0PyoLgHEaqr6lw3qOmdqnJF7/Qu5gCcv5KpfUFBkTXY+P9w71thFw6PMBJQH6+TtA7AcZu5Jtk4wxayySkg8Fu9qJ2/i1Px1jma31pkqfcRibGiwemattMkaXGkhUOaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0YQlfau+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0YQlfau+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102ED1F000E9;
	Thu, 30 Jul 2026 15:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424740;
	bh=Zix0aRCECCOiWDs1useRSuHlR13iJjkZtjahtGQhmXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0YQlfau+fkux6mjpo4AcaZ6E70QxR4BbewJmQBwLAcS9pWa7WRu21opDx9MEZ7bXk
	 4OERy1stBX/T5HGv0StrL+0caMNjOrw8LyUmKJiHX5NdpUPWxauW7nPPhBn35AZVgO
	 nTyHRrgVbaGxwUbDrfUkSD4sqn6pcZM3gSw3MkWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Muchun Song <muchun.song@linux.dev>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.18 498/675] arm64: make huge_ptep_get handled unaligned addresses
Date: Thu, 30 Jul 2026 16:13:48 +0200
Message-ID: <20260730141455.711671765@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
@@ -91,7 +91,7 @@ static int find_num_contig(struct mm_str
 	p4dp = p4d_offset(pgdp, addr);
 	pudp = pud_offset(p4dp, addr);
 	pmdp = pmd_offset(pudp, addr);
-	if ((pte_t *)pmdp == ptep) {
+	if ((pte_t *)PTR_ALIGN_DOWN(pmdp, sizeof(*pmdp) * CONT_PMDS) == ptep) {
 		*pgsize = PMD_SIZE;
 		return CONT_PMDS;
 	}


