Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CAC1DFC4
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fe4+U3EH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13FEC433C7;
	Tue, 31 Oct 2023 17:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698771737;
	bh=bduhNPn1+pmyUmK+jwX3fzAsAU/xyiS+Tn8V/HuWjnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fe4+U3EHQ8R5xInLF6Ywp6z86Buv3Zl7bcNfnyHih1gRSCASToGXrdClOPfAX+YX8
	 iaJtz5w4/WwmcjyOWQEjpfZDfSZPkntN8qNzM+kNUQVOfnznKy8wrRufpNkTX1VBhl
	 VZtJLWiV8DmYk0SsbLTMUtgbw1iCDDkK3HioxYpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Qinglin Pan <panqinglin2020@iscas.ac.cn>,
	Conor Dooley <conor@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 001/112] riscv: fix set_huge_pte_at() for NAPOT mappings when a swap entry is set
Date: Tue, 31 Oct 2023 18:00:02 +0100
Message-ID: <20231031165901.363456926@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Ghiti <alexghiti@rivosinc.com>

[ Upstream commit 1de195dd0e05d9cba43dec16f83d4ee32af94dd2 ]

We used to determine the number of page table entries to set for a NAPOT
hugepage by using the pte value which actually fails when the pte to set
is a swap entry.

So take advantage of a recent fix for arm64 reported in [1] which
introduces the size of the mapping as an argument of set_huge_pte_at(): we
can then use this size to compute the number of page table entries to set
for a NAPOT region.

Link: https://lkml.kernel.org/r/20230928151846.8229-3-alexghiti@rivosinc.com
Fixes: 82a1a1f3bfb6 ("riscv: mm: support Svnapot in hugetlb page")
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reported-by: Ryan Roberts <ryan.roberts@arm.com>
Closes: https://lore.kernel.org/linux-arm-kernel/20230922115804.2043771-1-ryan.roberts@arm.com/ [1]
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Qinglin Pan <panqinglin2020@iscas.ac.cn>
Cc: Conor Dooley <conor@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/hugetlbpage.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/riscv/mm/hugetlbpage.c b/arch/riscv/mm/hugetlbpage.c
index 96225a8533ad8..e92e89461c3bc 100644
--- a/arch/riscv/mm/hugetlbpage.c
+++ b/arch/riscv/mm/hugetlbpage.c
@@ -182,15 +182,22 @@ void set_huge_pte_at(struct mm_struct *mm,
 		     pte_t *ptep,
 		     pte_t pte)
 {
+	unsigned long hugepage_shift;
 	int i, pte_num;
 
-	if (!pte_napot(pte)) {
-		set_pte_at(mm, addr, ptep, pte);
-		return;
-	}
+	if (sz >= PGDIR_SIZE)
+		hugepage_shift = PGDIR_SHIFT;
+	else if (sz >= P4D_SIZE)
+		hugepage_shift = P4D_SHIFT;
+	else if (sz >= PUD_SIZE)
+		hugepage_shift = PUD_SHIFT;
+	else if (sz >= PMD_SIZE)
+		hugepage_shift = PMD_SHIFT;
+	else
+		hugepage_shift = PAGE_SHIFT;
 
-	pte_num = napot_pte_num(napot_cont_order(pte));
-	for (i = 0; i < pte_num; i++, ptep++, addr += PAGE_SIZE)
+	pte_num = sz >> hugepage_shift;
+	for (i = 0; i < pte_num; i++, ptep++, addr += (1 << hugepage_shift))
 		set_pte_at(mm, addr, ptep, pte);
 }
 
-- 
2.42.0



