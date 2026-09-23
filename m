Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57CB497B76;
	Wed, 23 Sep 2026 14:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174162; cv=none; b=GZgN9frQNeRv3cBw//ykp6ccslSILlyQiUF0k/5g+k83Ey5VJ8L3sbGcSGbQ8z9vzrjE/K9TOkf0lQleot2M9Biv8JpLHC3QebxdJxrupeCzV0s80Wzag62WM54AnMAJ87/COaNu3w6qyACwTXWky2QV+q4jvT4Dc2Uah7lLyig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174162; c=relaxed/simple;
	bh=xEnzeLOWQ+Ecd7tW860V/O0LQo6n23WvcmQSJUdBtHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GuHrBTvymTwdhPap2x6OuNpyE+J6oiRFZeoTTd6mhTkdh+WtPfn/M6VQWpv4HYGTC4BgiQatxLf4XnNtffM2HeoiPuNtJu1iKna0pWzfsUI7CuulPfGsocVX/8kU1USXQtphzqe0feSpoejoZ8Fjk2a2CL7Nspb7XSC8BLH835g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gqm2sVus; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gqm2sVus"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6511F000FF;
	Wed, 23 Sep 2026 14:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174160;
	bh=mZJLLOc46tQWTVoimJRNn1iXcnm9yZBNGybm/ph8zO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gqm2sVusyEutyWgSLvQu8SGALnsSuHI0miulJlyp9bHpdtzCDwxcV0kvNx23dIllb
	 g5Gj9abR/d87ic9HLaY3JLpnvDckPdf8+nCHAXjkfz3vbAO7QOoL9UHODLwPX+n+gI
	 1pYHCaoOLfR/HXxwaSZjjF2i3Tk8UOkGlYjjweZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Hongqiang Luo <wanbafv@gmail.com>,
	Xinyu Ma <mmmxny@gmail.com>,
	Zhanbo Ye <cainyzb@gmail.com>,
	Shaomin Chen <eeesssooo020@gmail.com>,
	Rui Ding <threonine42@gmail.com>,
	Miao Zhao <muel@nova.gal>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 029/398] RDMA/rxe: Restore HMM_PFN_WRITE check in ODP write paths
Date: Wed, 23 Sep 2026 16:01:43 +0200
Message-ID: <20260923140644.185473660@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit 769001ce838d907ecaa95f1d0a4e8fc86f761f9f ]

Commit 0b261d7c1cd3 ("RDMA/rxe: Break endless pagefault loop for RO
pages") dropped the access permission test from rxe_check_pagefault()
and left only HMM_PFN_VALID. A page faulted in read-only, for example
a page-cache folio behind a PROT_READ file mapping, then satisfies the
check and ODP write operations (RDMA WRITE, RDMA READ response, SEND
payload, atomics) modify it through kmap without ever breaking CoW.

An unprivileged user can register an ODP MR over such a mapping and
have incoming RDMA traffic overwrite the page cache of a file it only
holds O_RDONLY, including /etc/passwd or setuid binaries. This is the
same primitive class as Dirty COW and CVE-2022-2590.

mlx5 has the missing invariant: its ODP path sets the device write bit
only for pfns that carry HMM_PFN_WRITE. Restore it in rxe by requiring
HMM_PFN_WRITE in rxe_check_pagefault() for every operation except
RXE_PAGEFAULT_RDONLY. A write to a non-writable VMA now fails the one
fault attempt with -EPERM from hmm_vma_fault() instead of re-faulting
forever. For a writable VMA the fault breaks CoW and the write lands
in the private page.

Keep pmem flushes on the read-only check. arch_wb_cache_pmem() never
modifies memory, and the FLUSH access bits do not make the umem
writable, so classifying flushes as writes would make every flush
against a flush-only MR fail.

Fixes: 0b261d7c1cd3 ("RDMA/rxe: Break endless pagefault loop for RO pages")
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Link: https://patch.msgid.link/20260726111533.1037819-1-bestswngs@gmail.com
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Tested-by: Hongqiang Luo <wanbafv@gmail.com>
Tested-by: Xinyu Ma <mmmxny@gmail.com>
Tested-by: Zhanbo Ye <cainyzb@gmail.com>
Reported-by: Weiming Shi <bestswngs@gmail.com>
Reported-by: Shaomin Chen <eeesssooo020@gmail.com>
Reported-by: Rui Ding <threonine42@gmail.com>
Reported-by: Miao Zhao <muel@nova.gal>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_odp.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c b/drivers/infiniband/sw/rxe/rxe_odp.c
index 16b3fbdf2f867..995c1cb5c958e 100644
--- a/drivers/infiniband/sw/rxe/rxe_odp.c
+++ b/drivers/infiniband/sw/rxe/rxe_odp.c
@@ -126,19 +126,23 @@ int rxe_odp_mr_init_user(struct rxe_dev *rxe, u64 start, u64 length,
 }
 
 static inline bool rxe_check_pagefault(struct ib_umem_odp *umem_odp, u64 iova,
-				       int length)
+				       int length, bool write)
 {
 	bool need_fault = false;
+	u64 access = HMM_PFN_VALID;
 	u64 addr;
 	int idx;
 
+	if (write)
+		access |= HMM_PFN_WRITE;
+
 	addr = iova & (~(BIT(umem_odp->page_shift) - 1));
 
 	/* Skim through all pages that are to be accessed. */
 	while (addr < iova + length) {
 		idx = (addr - ib_umem_start(umem_odp)) >> umem_odp->page_shift;
 
-		if (!(umem_odp->map.pfn_list[idx] & HMM_PFN_VALID)) {
+		if ((umem_odp->map.pfn_list[idx] & access) != access) {
 			need_fault = true;
 			break;
 		}
@@ -161,6 +165,7 @@ static unsigned long rxe_odp_iova_to_page_offset(struct ib_umem_odp *umem_odp, u
 static int rxe_odp_map_range_and_lock(struct rxe_mr *mr, u64 iova, int length, u32 flags)
 {
 	struct ib_umem_odp *umem_odp = to_ib_umem_odp(mr->umem);
+	bool write = !(flags & RXE_PAGEFAULT_RDONLY);
 	bool need_fault;
 	int err;
 
@@ -169,7 +174,7 @@ static int rxe_odp_map_range_and_lock(struct rxe_mr *mr, u64 iova, int length, u
 
 	mutex_lock(&umem_odp->umem_mutex);
 
-	need_fault = rxe_check_pagefault(umem_odp, iova, length);
+	need_fault = rxe_check_pagefault(umem_odp, iova, length, write);
 	if (need_fault) {
 		mutex_unlock(&umem_odp->umem_mutex);
 
@@ -179,7 +184,7 @@ static int rxe_odp_map_range_and_lock(struct rxe_mr *mr, u64 iova, int length, u
 		if (err < 0)
 			return err;
 
-		need_fault = rxe_check_pagefault(umem_odp, iova, length);
+		need_fault = rxe_check_pagefault(umem_odp, iova, length, write);
 		if (need_fault) {
 			mutex_unlock(&umem_odp->umem_mutex);
 			return -EFAULT;
@@ -341,8 +346,9 @@ int rxe_odp_flush_pmem_iova(struct rxe_mr *mr, u64 iova,
 	int err;
 	u8 *va;
 
+	/* A flush never modifies memory; read-only access suffices. */
 	err = rxe_odp_map_range_and_lock(mr, iova, length,
-					 RXE_PAGEFAULT_DEFAULT);
+					 RXE_PAGEFAULT_RDONLY);
 	if (err)
 		return err;
 
-- 
2.53.0



