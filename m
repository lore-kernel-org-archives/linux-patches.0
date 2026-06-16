Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822C543CEC7;
	Tue, 16 Jun 2026 18:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634946; cv=none; b=mBmi4qWrd86ure0I/1a2G2hvmZQSqLRbdd4/grBGy/Gw65LUYnhN/LNsI2pwZ8ctFXSn2Q2WqwZWhx6m0hVIIFBSYB7iR/lI8eXbzLvQ3lOZLgGXU2e6hQWuMNwL11lHONmXrDdzklb62BGDcKvUHxwUmY4NqSwVWh45/9rHWLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634946; c=relaxed/simple;
	bh=4sUu/QqyHPSvHlUX//WsyAzKh5Jo9LELS9be3nZYm+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dkkd6DzuG9OXQgQyAuz6PBy30qEzHKpqH+IioBnYU7MeobGwnmsOcikeaRgpW5gJpHjyrBP8oIR5dWyiGVf6I5bT5TyT/le4gUKQgbNFUspJ3CqamsqBOd8ffzwLKAM7zOx/8TYQnXUcaWEWSrbiY7BB6YdK0vKNVTUQnW6sX9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pMtpaMLX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pMtpaMLX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7071E1F000E9;
	Tue, 16 Jun 2026 18:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634945;
	bh=zR0fLoa5l2nCUJh8DAx6rvJNHnSdRv7WOqKunlRmo0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pMtpaMLXU4TxD8kh6oGL80ssHsBSYd1ORUGhQ7HcPa5vKULGcGvS7e2+ZURPJayLx
	 3Rd4RUw8WS1D7Vz+V4Ha1ZdmsHWSc0T+drMdM1Nx/Aym+k1baaxLvsZi+ULD+YBonV
	 Fl1WwiVBdQ4+S1xwUtQyNLKKisM0P+gHg2OMcvKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeng Heng <zengheng4@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 360/411] arm64: tlb: Flush walk cache when unsharing PMD tables
Date: Tue, 16 Jun 2026 20:29:58 +0530
Message-ID: <20260616145120.461136805@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zeng Heng <zengheng4@huawei.com>

[ Upstream commit c2ff4764e03e7a8d758352f4aceb8fe1be6ac971 ]

When huge_pmd_unshare() is called to unshare a PMD table, the
tlb_unshare_pmd_ptdesc() function sets tlb->unshared_tables=true
but the aarch64 tlb_flush() only checked tlb->freed_tables to
determine whether to use TLBF_NONE (vae1is, invalidates walk
cache) or TLBF_NOWALKCACHE (vale1is, leaf-only).

This caused the stale PMD page table entry to remain in the walk cache
after unshare, potentially leading to incorrect page table walks.

Fix by including unshared_tables in the check, so that when
unsharing tables, TLBF_NONE is used and the walk cache is properly
invalidated.

Here is the detailed distinction between vae1is and vale1is:

| Instruction Combination  | Actual Invalidation Scope                         |
| ------------------------ | --------------------------------------------------|
| `VAE1IS`  + TTL=`0`      | All entries at all levels (full invalidation)     |
| `VAE1IS`  + TTL=`2` (L2) | Non-leaf at Level 0/1 + leaf at Level 2           |
| `VALE1IS` + TTL=`0`      | Leaf entries at all levels (non-leaf not cleared) |
| `VALE1IS` + TTL=`2` (L2) | Leaf entry at Level 2 only                        |

Signed-off-by: Zeng Heng <zengheng4@huawei.com>
Fixes: 8ce720d5bd91 ("mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables using mmu_gather")
Cc: <stable@vger.kernel.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/tlb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/include/asm/tlb.h
+++ b/arch/arm64/include/asm/tlb.h
@@ -53,7 +53,7 @@ static inline int tlb_get_level(struct m
 static inline void tlb_flush(struct mmu_gather *tlb)
 {
 	struct vm_area_struct vma = TLB_FLUSH_VMA(tlb->mm, 0);
-	bool last_level = !tlb->freed_tables;
+	bool last_level = !(tlb->freed_tables || tlb->unshared_tables);
 	unsigned long stride = tlb_get_unmap_size(tlb);
 	int tlb_level = tlb_get_level(tlb);
 


