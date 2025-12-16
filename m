Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3863451BD;
	Tue, 16 Dec 2025 12:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887826; cv=none; b=f8PReWXOK0gnwFnBX8A3JHn9xCoSxx1xEMgfZ+QCHztwuE/fE/AEdLUhXgIYBZWwz1ogY1oDXMdsUmOt/mlIa0nBKE3Sy2eKFsIEicg6ZPYXGlJR8aVZAdtchI0s/HUXyLQ/leA+AALY0kkkGS/zLY+MR/KtPICFb6kXH/hrsqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887826; c=relaxed/simple;
	bh=VpMbV47YXIzi9pFcqkLn2K2b/X2qFCPo3xhY3sZbvqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGXwNkii1Hjs1oChuPcetKUttklVG2x+1x1ZSitx2bklgVIww+cAaLpfgpZe2m4ZlHqfZlWux7rM5Ibr3HlWiUQBT9xE/Y8XMeKA1mihIHVDlxHmmM4YxZl7CyBZgSbXu2w5hSDpYL0Xg9iPBPLPW8vA/rB4fthw27+kCRkBJ9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LiIxVm1T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LiIxVm1T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A43C4CEF1;
	Tue, 16 Dec 2025 12:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887826;
	bh=VpMbV47YXIzi9pFcqkLn2K2b/X2qFCPo3xhY3sZbvqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LiIxVm1T2T0PVzU10UrfXEjnoodwiCrm/4SaQ5MsSh3bcICXO7ELNs+K6dnx87apJ
	 zxyAeQYsVCGGhG4fxNuGrYiMekduuVkpOEutn80/PObsqHhT1YBelE1zGipeVxyMoK
	 VSenf5SvoyqPJAPJw2DDYnNZZtR2dLFPY2wlQknA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 316/614] powerpc/64s/hash: Restrict stress_hpt_struct memblock region to within RMA limit
Date: Tue, 16 Dec 2025 12:11:23 +0100
Message-ID: <20251216111412.814830184@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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
index 3aee3af614af8..c99be1286d517 100644
--- a/arch/powerpc/mm/book3s64/hash_utils.c
+++ b/arch/powerpc/mm/book3s64/hash_utils.c
@@ -1302,11 +1302,14 @@ static void __init htab_initialize(void)
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
@@ -1322,7 +1325,7 @@ static void __init htab_initialize(void)
 		// Too early to use nr_cpu_ids, so use NR_CPUS
 		tmp = memblock_phys_alloc_range(sizeof(struct stress_hpt_struct) * NR_CPUS,
 						__alignof__(struct stress_hpt_struct),
-						0, MEMBLOCK_ALLOC_ANYWHERE);
+						MEMBLOCK_LOW_LIMIT, limit);
 		memset((void *)tmp, 0xff, sizeof(struct stress_hpt_struct) * NR_CPUS);
 		stress_hpt_struct = __va(tmp);
 
@@ -1356,11 +1359,10 @@ static void __init htab_initialize(void)
 			mmu_hash_ops.hpte_clear_all();
 #endif
 	} else {
-		unsigned long limit = MEMBLOCK_ALLOC_ANYWHERE;
 
 		table = memblock_phys_alloc_range(htab_size_bytes,
 						  htab_size_bytes,
-						  0, limit);
+						  MEMBLOCK_LOW_LIMIT, limit);
 		if (!table)
 			panic("ERROR: Failed to allocate %pa bytes below %pa\n",
 			      &htab_size_bytes, &limit);
-- 
2.51.0



