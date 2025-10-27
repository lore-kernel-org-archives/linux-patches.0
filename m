Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D5F2D5C95;
	Mon, 27 Oct 2025 19:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592803; cv=none; b=Rx0vl+u4qCV4MOdKt9fTHCOH8GQhlxLSbL0bBH3bK23e6Zw6jlmcryRTwGvasW8NlSrbLqg8wpbou2m3juXGvSONkYbToWX53n+5O7Di0pTjntQA4wQSN1Vkz60XOnCHJb//SBeCpRHG/NtYyB2fEwrxnBg1Nau6oeEyk5eJ/OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592803; c=relaxed/simple;
	bh=j/MfnhgQTJQFcjdb5chKDLlRraoRg9Y1QK9Dmwrweu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n50NvDdJoUl6xqNDtgWiNt9CnSgqeUzS4b5xpADTVyzwBbVMy36VG5ilWI5x3iYY/OoVIzLPwmFn8KgJ6zFYCXiFU6H9scf12v0etus1071UvucAqi3lrK4uo+DgowIYv9TzzmN7N+tLOvDoRGx/XIEp0veZTmghriQ95K1HPC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N+zCEp91; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+zCEp91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749A9C4CEF1;
	Mon, 27 Oct 2025 19:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592802;
	bh=j/MfnhgQTJQFcjdb5chKDLlRraoRg9Y1QK9Dmwrweu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+zCEp91nCLlIIjGMGWPOSbKhq9o7opAbNz10omkCSLcEGxg3pO2oG9RRSB27OLzQ
	 COtHx4dagM0+0fyN6MgIWdVWz0skZ361I/dzlbIFLxNe2wGHMUa7VBCHafPUg8IIoh
	 a52Nz2wULcaXyIMDxwQZZGL1xoWTSL0Aij1+anS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 018/117] s390/mm: Use __GFP_ACCOUNT for user page table allocations
Date: Mon, 27 Oct 2025 19:35:44 +0100
Message-ID: <20251027183454.440356276@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 5671ce2a1fc6b4a16cff962423bc416b92cac3c8 ]

Add missing kmemcg accounting of user page table allocations.

Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/pgalloc.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/s390/mm/pgalloc.c b/arch/s390/mm/pgalloc.c
index f5dece9353535..a2ec82ec78ac9 100644
--- a/arch/s390/mm/pgalloc.c
+++ b/arch/s390/mm/pgalloc.c
@@ -43,9 +43,13 @@ __initcall(page_table_register_sysctl);
 
 unsigned long *crst_table_alloc(struct mm_struct *mm)
 {
-	struct ptdesc *ptdesc = pagetable_alloc(GFP_KERNEL, CRST_ALLOC_ORDER);
+	gfp_t gfp = GFP_KERNEL_ACCOUNT;
+	struct ptdesc *ptdesc;
 	unsigned long *table;
 
+	if (mm == &init_mm)
+		gfp &= ~__GFP_ACCOUNT;
+	ptdesc = pagetable_alloc(gfp, CRST_ALLOC_ORDER);
 	if (!ptdesc)
 		return NULL;
 	table = ptdesc_to_virt(ptdesc);
@@ -142,7 +146,7 @@ struct ptdesc *page_table_alloc_pgste(struct mm_struct *mm)
 	struct ptdesc *ptdesc;
 	u64 *table;
 
-	ptdesc = pagetable_alloc(GFP_KERNEL, 0);
+	ptdesc = pagetable_alloc(GFP_KERNEL_ACCOUNT, 0);
 	if (ptdesc) {
 		table = (u64 *)ptdesc_to_virt(ptdesc);
 		__arch_set_page_dat(table, 1);
@@ -161,10 +165,13 @@ void page_table_free_pgste(struct ptdesc *ptdesc)
 
 unsigned long *page_table_alloc(struct mm_struct *mm)
 {
+	gfp_t gfp = GFP_KERNEL_ACCOUNT;
 	struct ptdesc *ptdesc;
 	unsigned long *table;
 
-	ptdesc = pagetable_alloc(GFP_KERNEL, 0);
+	if (mm == &init_mm)
+		gfp &= ~__GFP_ACCOUNT;
+	ptdesc = pagetable_alloc(gfp, 0);
 	if (!ptdesc)
 		return NULL;
 	if (!pagetable_pte_ctor(ptdesc)) {
-- 
2.51.0



