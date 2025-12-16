Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFB8355028;
	Tue, 16 Dec 2025 11:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885861; cv=none; b=EsybKqlT0KITYRoSOXK7vkO5c9jv7UyRfwzOA3aHzK0xJWslwumRQgwdPY0sSQuoHkqJnunXHyqgiYQyxSyXAhsPnWkHK0RbZAvSWd3Oo+hwQRZk+fbdv9wkXPsc/B9jSDx4Z5E0GcTXzWzviufEVevDFDXwESstSnk9CDbxUpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885861; c=relaxed/simple;
	bh=COnD8cmPd+snSbuNPWDH2q/M1lSSvz+jbOpvnJ2H1Xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GsMXh/CpKFebk4Ii1Ph6yvEi/ARpV2QT640/0bshjghYmm46FZZzuXjbwsuY2lK497V8XzH0DK4/ToE0zyhBxthN+Bkjq6yY7k8FdmTxTVyZtvDtddBF0R4teO6akbuvLNJHu8moo7UxYxzGDKld2lE5t/DPUlB53X38Z5wif28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n9fiafnP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n9fiafnP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22E6C4CEF1;
	Tue, 16 Dec 2025 11:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885861;
	bh=COnD8cmPd+snSbuNPWDH2q/M1lSSvz+jbOpvnJ2H1Xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n9fiafnPt847nknnz1kHGDVnpBphzzKMj4zuUSCuDspbfnLeTiWUgX+wdVIRSYQD7
	 x1Qg2pAyKwUm5BRrY6seBGfaURMjXiJOPwKaynAAo2Q1k0pNBR+4YxmrYOTnhnxhPK
	 eKejMyJRIFMzjkStyyDCRm7LCgUdWB6GEvHyQId4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 266/507] powerpc/64s/hash: Restrict stress_hpt_struct memblock region to within RMA limit
Date: Tue, 16 Dec 2025 12:11:47 +0100
Message-ID: <20251216111355.122654726@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 4693c464fc5af..1e062056cfb82 100644
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



