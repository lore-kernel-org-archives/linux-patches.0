Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBDE224D6;
	Sun,  7 Jun 2026 11:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780830115; cv=none; b=h6WA4qTQr6MAIfPV0w848iIqAngpuPI9qv9a7lmWCwN7CHlZb/CAgMX4qwL0JDmUUfXmcNCjPr0Q22nTkZSWvb5yzzIARzs8FKhkLzyddN4k+zyiK9PEJTIeMma2bTeoXbjigik42Xl7cYM0wTDeODxDcphm5btqeuQiXgahnug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780830115; c=relaxed/simple;
	bh=7nGCXsUq5+csYEHQ0j1QUXyC8GLlf59A0o+M3d1G2Vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=syDRrzxNoalUOFDVgojm2f87q3oVFziQOQhv48xEU3R/gz9L2AquCs85SwTM18ZDm12q/cCKjZ8yrWXcfxxrD7svLJgwnLS2AR9xXpa39Zr3fHKXnvLJAVDHdQLcAcq4IADhtRmJtm7JVVhlisTDg5AFZ0tSV7AqHtQD0maEuW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DG19IHOH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DG19IHOH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3971F00893;
	Sun,  7 Jun 2026 11:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780830114;
	bh=QEPekEl1F71dZbmqXb2EST1Ks1yvW967JtCJDlhR9Jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DG19IHOHkRFMmune3pZsd5c36suNzJcgOaDuPMS229tNdF2rUOeJETZrff/mYv76M
	 S0bjruxqkcYU4kqlpKr6d1xAFZOrjlg/lir7UQV5GfwmSIBhpv4h1TTWkgtag9btI1
	 WcOIV+TVHcmEmFUh7H6Vu64yQvunqi9RE7P2lHko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeng Heng <zengheng4@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 284/307] arm64: tlb: Flush walk cache when unsharing PMD tables
Date: Sun,  7 Jun 2026 12:01:21 +0200
Message-ID: <20260607095738.160567442@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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
@@ -58,7 +58,7 @@ static inline int tlb_get_level(struct m
 static inline void tlb_flush(struct mmu_gather *tlb)
 {
 	struct vm_area_struct vma = TLB_FLUSH_VMA(tlb->mm, 0);
-	bool last_level = !tlb->freed_tables;
+	bool last_level = !(tlb->freed_tables || tlb->unshared_tables);
 	unsigned long stride = tlb_get_unmap_size(tlb);
 	int tlb_level = tlb_get_level(tlb);
 


