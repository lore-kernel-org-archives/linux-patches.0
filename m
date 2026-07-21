Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE293B8120;
	Tue, 21 Jul 2026 20:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667537; cv=none; b=PWaJJHiiUXGtD+Ok5zclz7ZKcxZOscX3HvBfEYuRvxF79P2KZld4In7codb4WzbL+F8eSiIIClX3P40JD1T2VgzfU39Oqd6i6gvutLzgmI6Spp3lt8iszXFMsebOr7+Zh5Wn2Bb5hQmk1BWJ/18O1scCTuz7e+G1CM5enmhw5T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667537; c=relaxed/simple;
	bh=Tv6UB/Jc6WqpnuU1NaMzu7vwbH4F9VdqCN/z/MpYY9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O9OU7R8xTWV7QnOgcnua6LADd3b0rA4ek2cI17cVZZONgWhYUVef5WuX20KDVWmwoY9GaCMp10QgR8Rwk2HqNJFHQ0tRaSRIhGfrQaPA1Y/wEIT8Y72ZYK1UOTOKH9cD8nkDLcngNmZ9puXlQ6cZgW5ZAzqnSXJ6pecMz7pv4oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QnAPN2ox; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QnAPN2ox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D1D71F000E9;
	Tue, 21 Jul 2026 20:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667535;
	bh=rH/keb3COuMJCi6js54vFlJMCWdDLg14ij08+ExTXuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QnAPN2oxYO3E7jODRkdGOqEVTPtMOPUi73HxCHZ65ZOfR6AdlwpRPiBAq8grba8XY
	 nZ5sWyfmanldx52HZ9MDQyUEVswD495MRPSbvG9+6/XFKKVjsTcvks5bxfbugDBfHA
	 ifVdiqMap7EOEonLm0l5NaKliFou0borDzuYKXAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyang Zhang <zhangtianyang@loongson.cn>,
	Hongchen Zhang <zhanghongchen@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 1097/1266] LoongArch: Fix missing dirty page tracking in {pte,pmd}_wrprotect()
Date: Tue, 21 Jul 2026 17:25:34 +0200
Message-ID: <20260721152506.350824284@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongchen Zhang <zhanghongchen@loongson.cn>

commit 018e9828eb523c638fa3d9bdf0fd4956b74555b2 upstream.

When hardware page table walker (PTW) is enabled on LoongArch, the CPU
may set _PAGE_DIRTY directly in the page table entry during a write TLB
miss, without going through the software TLB store handler. The software
TLB store handler (tlbex.S:254) sets both _PAGE_DIRTY and_PAGE_MODIFIED
together:

    ori t0, t0, (_PAGE_VALID | _PAGE_DIRTY | _PAGE_MODIFIED)

Since hardware PTW only sets _PAGE_DIRTY, the software-only bit, i.e.
_PAGE_MODIFIED is left unchanged. This creates a window where a PTE has
_PAGE_DIRTY set (hardware knows the page is dirty) but _PAGE_MODIFIED
clear (software is unaware).

When fork()/clone() triggers copy-on-write, __copy_present_ptes() calls
pte_wrprotect(), which unconditionally clears both the _PAGE_WRITE and
_PAGE_DIRTY bits:

    pte_val(pte) &= ~(_PAGE_WRITE | _PAGE_DIRTY);

Since _PAGE_MODIFIED was never set, the dirtiness information is lost
completely. Subsequently, when memory pressure triggers page reclaim,
page_mkclean() / try_to_unmap() sees the page as clean (i.e. pte_dirty()
returns false) and the page may be freed without writeback, causing data
corruption.

Fix this by propagating the _PAGE_DIRTY bit to the _PAGE_MODIFIED bit in
both pte_wrprotect() and pmd_wrprotect() before clearing writeable bits:

    if (pte_val(pte) & _PAGE_DIRTY)
        pte_val(pte) |= _PAGE_MODIFIED;

The pmd_wrprotect() fix handles the CONFIG_TRANSPARENT_HUGEPAGE case,
where pmd entries need the same treatment.

This ensures the software dirty tracking bit (checked by pte_dirty() and
pmd_dirty(), which read both the _PAGE_DIRTY and _PAGE_MODIFIED bits) is
preserved across fork COW write-protection.

The issue was found by the LTP madvise09 test case, which exercises page
reclaim after "madvise(MADV_FREE), write and fork" operation sequence on
private anonymous mappings.

Cc: stable@vger.kernel.org
Fixes: 09cfefb7fa70 ("LoongArch: Add memory management")
Co-developed-by: Tianyang Zhang <zhangtianyang@loongson.cn>
Signed-off-by: Tianyang Zhang <zhangtianyang@loongson.cn>
Signed-off-by: Hongchen Zhang <zhanghongchen@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/pgtable.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -410,6 +410,8 @@ static inline pte_t pte_mkwrite_novma(pt
 
 static inline pte_t pte_wrprotect(pte_t pte)
 {
+	if (pte_val(pte) & _PAGE_DIRTY)
+		pte_val(pte) |= _PAGE_MODIFIED;
 	pte_val(pte) &= ~(_PAGE_WRITE | _PAGE_DIRTY);
 	return pte;
 }
@@ -522,6 +524,8 @@ static inline pmd_t pmd_mkwrite_novma(pm
 
 static inline pmd_t pmd_wrprotect(pmd_t pmd)
 {
+	if (pmd_val(pmd) & _PAGE_DIRTY)
+		pmd_val(pmd) |= _PAGE_MODIFIED;
 	pmd_val(pmd) &= ~(_PAGE_WRITE | _PAGE_DIRTY);
 	return pmd;
 }


