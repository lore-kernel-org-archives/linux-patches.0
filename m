Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B805F54E;
	Tue, 13 Feb 2024 17:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845476; cv=none; b=P39TdunPnyld/3lBbM0na6n/FB/s1S4dmW0l6EzQiiEzHL4CYo744Q06FzvtUmk83alq4jwuh5kqdH3UT/I47rGLWYlnKBFSFiH2dD30qEsHAnmqEaRQ6lp9Yr6+dFlYwnY53Ud3tVtClwK/c+uizJLOF2Fga0Zz3S6dBycnov0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845476; c=relaxed/simple;
	bh=0iZ4PCApV3lIfloDMe3TXZIcMVJPUaRCjPwJqEMC+p8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQzQGQQuSzScOuphBC73HkhphfJISan1fKI+AiAHbW5X8sfbaxyQVB3JmtZDnBCwVMTnhP53x1bY17boRSI3xHM7SOoI5jl5Gv9afYZBHoIT3buL6vES6aY1SnYcACeb9X5R8HpPRZ2ccksFtglJRwOPZ6N4eWXDSeo4/rHW4ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e5DmPTyS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e5DmPTyS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621DBC433C7;
	Tue, 13 Feb 2024 17:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845475;
	bh=0iZ4PCApV3lIfloDMe3TXZIcMVJPUaRCjPwJqEMC+p8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e5DmPTySEvrI8NWfv1r1CW66MC5vAmfzUWFfxP/HQPpxwJLWo522kFNGoOJREUZMy
	 4xI2Vdl+lALUiPIqxLJEbNfc5xzXjJM71g/wwIktrsggw8GRmjIMThgR0znaQGL1oR
	 Hfzkcbhr/uSEyidNC+wo4hVpKj9t4dS/RQXKCuCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 090/121] riscv: Fix set_huge_pte_at() for NAPOT mapping
Date: Tue, 13 Feb 2024 18:21:39 +0100
Message-ID: <20240213171855.621402235@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

From: Alexandre Ghiti <alexghiti@rivosinc.com>

[ Upstream commit 1458eb2c9d88ad4b35eb6d6a4aa1d43d8fbf7f62 ]

As stated by the privileged specification, we must clear a NAPOT
mapping and emit a sfence.vma before setting a new translation.

Fixes: 82a1a1f3bfb6 ("riscv: mm: support Svnapot in hugetlb page")
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20240117195741.1926459-2-alexghiti@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/hugetlbpage.c | 42 +++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/mm/hugetlbpage.c b/arch/riscv/mm/hugetlbpage.c
index b52f0210481f..24c0179565d8 100644
--- a/arch/riscv/mm/hugetlbpage.c
+++ b/arch/riscv/mm/hugetlbpage.c
@@ -177,13 +177,36 @@ pte_t arch_make_huge_pte(pte_t entry, unsigned int shift, vm_flags_t flags)
 	return entry;
 }
 
+static void clear_flush(struct mm_struct *mm,
+			unsigned long addr,
+			pte_t *ptep,
+			unsigned long pgsize,
+			unsigned long ncontig)
+{
+	struct vm_area_struct vma = TLB_FLUSH_VMA(mm, 0);
+	unsigned long i, saddr = addr;
+
+	for (i = 0; i < ncontig; i++, addr += pgsize, ptep++)
+		ptep_get_and_clear(mm, addr, ptep);
+
+	flush_tlb_range(&vma, saddr, addr);
+}
+
+/*
+ * When dealing with NAPOT mappings, the privileged specification indicates that
+ * "if an update needs to be made, the OS generally should first mark all of the
+ * PTEs invalid, then issue SFENCE.VMA instruction(s) covering all 4 KiB regions
+ * within the range, [...] then update the PTE(s), as described in Section
+ * 4.2.1.". That's the equivalent of the Break-Before-Make approach used by
+ * arm64.
+ */
 void set_huge_pte_at(struct mm_struct *mm,
 		     unsigned long addr,
 		     pte_t *ptep,
 		     pte_t pte,
 		     unsigned long sz)
 {
-	unsigned long hugepage_shift;
+	unsigned long hugepage_shift, pgsize;
 	int i, pte_num;
 
 	if (sz >= PGDIR_SIZE)
@@ -198,7 +221,22 @@ void set_huge_pte_at(struct mm_struct *mm,
 		hugepage_shift = PAGE_SHIFT;
 
 	pte_num = sz >> hugepage_shift;
-	for (i = 0; i < pte_num; i++, ptep++, addr += (1 << hugepage_shift))
+	pgsize = 1 << hugepage_shift;
+
+	if (!pte_present(pte)) {
+		for (i = 0; i < pte_num; i++, ptep++, addr += pgsize)
+			set_ptes(mm, addr, ptep, pte, 1);
+		return;
+	}
+
+	if (!pte_napot(pte)) {
+		set_ptes(mm, addr, ptep, pte, 1);
+		return;
+	}
+
+	clear_flush(mm, addr, ptep, pgsize, pte_num);
+
+	for (i = 0; i < pte_num; i++, ptep++, addr += pgsize)
 		set_pte_at(mm, addr, ptep, pte);
 }
 
-- 
2.43.0



