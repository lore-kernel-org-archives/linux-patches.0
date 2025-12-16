Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA243446B8;
	Tue, 16 Dec 2025 11:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884486; cv=none; b=L87sA3B7HPsnA20Kzyuokds4+G5o5Pajx70Isf+on+GB4nq4u4wv2T0+UFXpXg9EKT+1x5jNy5XEWTalUuo7rzhhu2rTdG5H+Aaf/Uj/qiWtu2yjyaH5tN9GQkB884i7mAhxCYnIJpx1rNRJMzbalpwva3QWQkAGB9zcMEO++zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884486; c=relaxed/simple;
	bh=tOziACPeHfjZbugyeIrtRVUSJ2l4YhWry6VsQobXpvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ElY+TFQT1qDD3wOeaATNISQa3rhtpxMmhJW/mWJMuG0rMeE0n205E50Vq9pjE/sM4Ad5kDP7uQJaa/zFvl43YFjyOCmt80r9DE2zK2JVudKQQUOEhrpH9T8ITXv1e4Sa/u94LSy6qGq7AHdHYPCezvJ0ommPGvz1ycgjPq07G90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=evG1Uu5Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="evG1Uu5Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512D7C4CEF1;
	Tue, 16 Dec 2025 11:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884486;
	bh=tOziACPeHfjZbugyeIrtRVUSJ2l4YhWry6VsQobXpvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=evG1Uu5Z/o5nvh7D48ZyNrwQ8L1EYBf4x3ti8MuRLz3q4tWgq16TsWD3+D9ZYfcyA
	 OJIzTKIaWQmjQD4NtD18cg9yNqCUfGFRzVu48Tmy5dftw+OzY0gc1o1a1voOUFB85s
	 ZYHmiW5LQdG3dzMCm0OQ+nX5nhA+lOsM9SrcYEPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 175/354] powerpc/64s/hash: Restrict stress_hpt_struct memblock region to within RMA limit
Date: Tue, 16 Dec 2025 12:12:22 +0100
Message-ID: <20251216111327.253205496@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

[ Upstream commit 17b45ccf09882e0c808ad2cf62acdc90ad968746 ]

When HV=0 & IR/DR=0, the Hash MMU is said to be in Virtual Real
Addressing Mode during early boot. During this, we should ensure that
memory region allocations for stress_hpt_struct should happen from
within RMA region as otherwise the boot might get stuck while doing
memset of this region.

History behind why do we have RMA region limitation is better explained
in these 2 patches [1] & [2]. This patch ensures that memset to
stress_hpt_struct during early boot does not cross ppc64_rma_size
boundary.

[1]: https://lore.kernel.org/all/20190710052018.14628-1-sjitindarsingh@gmail.com/
[2]: https://lore.kernel.org/all/87wp54usvj.fsf@linux.vnet.ibm.com/

Fixes: 6b34a099faa12 ("powerpc/64s/hash: add stress_hpt kernel boot option to increase hash faults")
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/ada1173933ea7617a994d6ee3e54ced8797339fc.1761834163.git.ritesh.list@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/book3s64/hash_utils.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/hash_utils.c b/arch/powerpc/mm/book3s64/hash_utils.c
index e1eadd03f1339..9914d89f9db7d 100644
--- a/arch/powerpc/mm/book3s64/hash_utils.c
+++ b/arch/powerpc/mm/book3s64/hash_utils.c
@@ -1039,11 +1039,14 @@ static void __init htab_initialize(void)
 	unsigned long table;
 	unsigned long pteg_count;
 	unsigned long prot;
-	phys_addr_t base = 0, size = 0, end;
+	phys_addr_t base = 0, size = 0, end, limit = MEMBLOCK_ALLOC_ANYWHERE;
 	u64 i;
 
 	DBG(" -> htab_initialize()\n");
 
+	if (firmware_has_feature(FW_FEATURE_LPAR))
+		limit = ppc64_rma_size;
+
 	if (mmu_has_feature(MMU_FTR_1T_SEGMENT)) {
 		mmu_kernel_ssize = MMU_SEGSIZE_1T;
 		mmu_highuser_ssize = MMU_SEGSIZE_1T;
@@ -1059,7 +1062,7 @@ static void __init htab_initialize(void)
 		// Too early to use nr_cpu_ids, so use NR_CPUS
 		tmp = memblock_phys_alloc_range(sizeof(struct stress_hpt_struct) * NR_CPUS,
 						__alignof__(struct stress_hpt_struct),
-						0, MEMBLOCK_ALLOC_ANYWHERE);
+						MEMBLOCK_LOW_LIMIT, limit);
 		memset((void *)tmp, 0xff, sizeof(struct stress_hpt_struct) * NR_CPUS);
 		stress_hpt_struct = __va(tmp);
 
@@ -1093,7 +1096,6 @@ static void __init htab_initialize(void)
 			mmu_hash_ops.hpte_clear_all();
 #endif
 	} else {
-		unsigned long limit = MEMBLOCK_ALLOC_ANYWHERE;
 
 #ifdef CONFIG_PPC_CELL
 		/*
@@ -1109,7 +1111,7 @@ static void __init htab_initialize(void)
 
 		table = memblock_phys_alloc_range(htab_size_bytes,
 						  htab_size_bytes,
-						  0, limit);
+						  MEMBLOCK_LOW_LIMIT, limit);
 		if (!table)
 			panic("ERROR: Failed to allocate %pa bytes below %pa\n",
 			      &htab_size_bytes, &limit);
-- 
2.51.0



