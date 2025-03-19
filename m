Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035641DDC0F;
	Wed, 19 Mar 2025 14:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395129; cv=none; b=eGnkLY8P8j+/FSTfc5BJtrC3MEInU7O/16r0gWrBgCmwWskeJpwKdVjx6TZT8xipHgUICcbP0SaYVxz/W096hCHOe9SlRqV+wQfw//G6A8ufK5JbBQlC9b8QPvCiQujvXR7EzDUOuDDrA4EpFdrRbZKwwnGC2FUAnPBxEJqhwKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395129; c=relaxed/simple;
	bh=HSWc5fCxV7lvtTayJJEkLzGhrj+YsdPXh/awgWGIBfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQ7BgAnuAYR6iWlUS8+M/x1P6Xpm7vq0COYai5wmGZvG7HcIJVPBriGCAbFba0CxGMdLfb4g2seiNEJ3otyUkYZxegVSXfn3IFQOi/t+ST7KbKkvq/y1sct4zZUKGX2nPUqay6i46QKNwI1nOCKlCX4Rt4emf1GIUmoGfxJpBro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CYv+gBfT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CYv+gBfT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3E8C4CEE4;
	Wed, 19 Mar 2025 14:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395128;
	bh=HSWc5fCxV7lvtTayJJEkLzGhrj+YsdPXh/awgWGIBfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CYv+gBfTwi8EAhXxb+4WyEiVps2/1qJYhaC1m8pbHiCREaVSXfLdCDu/Xy97IB7WD
	 P6h7aRQDphmJJ+bYn2I+CEmDmy3dcr7TsRQ2KfwqkTKm7aTXoxBfUvnBMuVv2amxow
	 w3kkTwZG+/yXsZn9DaL5SI1PBVPTfOxiiE5T2pfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Piotr Jaroszynski <pjaroszynski@nvidia.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Alistair Popple <apopple@nvidia.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	SeongJae Park <sj@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6.12 192/231] Fix mmu notifiers for range-based invalidates
Date: Wed, 19 Mar 2025 07:31:25 -0700
Message-ID: <20250319143031.585102708@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Piotr Jaroszynski <pjaroszynski@nvidia.com>

commit f7edb07ad7c66eab3dce57384f33b9799d579133 upstream.

Update the __flush_tlb_range_op macro not to modify its parameters as
these are unexepcted semantics. In practice, this fixes the call to
mmu_notifier_arch_invalidate_secondary_tlbs() in
__flush_tlb_range_nosync() to use the correct range instead of an empty
range with start=end. The empty range was (un)lucky as it results in
taking the invalidate-all path that doesn't cause correctness issues,
but can certainly result in suboptimal perf.

This has been broken since commit 6bbd42e2df8f ("mmu_notifiers: call
invalidate_range() when invalidating TLBs") when the call to the
notifiers was added to __flush_tlb_range(). It predates the addition of
the __flush_tlb_range_op() macro from commit 360839027a6e ("arm64: tlb:
Refactor the core flush algorithm of __flush_tlb_range") that made the
bug hard to spot.

Fixes: 6bbd42e2df8f ("mmu_notifiers: call invalidate_range() when invalidating TLBs")

Signed-off-by: Piotr Jaroszynski <pjaroszynski@nvidia.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Raghavendra Rao Ananta <rananta@google.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Nicolin Chen <nicolinc@nvidia.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: iommu@lists.linux.dev
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Link: https://lore.kernel.org/r/20250304085127.2238030-1-pjaroszynski@nvidia.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/tlbflush.h |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -396,33 +396,35 @@ static inline void arch_tlbbatch_flush(s
 #define __flush_tlb_range_op(op, start, pages, stride,			\
 				asid, tlb_level, tlbi_user, lpa2)	\
 do {									\
+	typeof(start) __flush_start = start;				\
+	typeof(pages) __flush_pages = pages;				\
 	int num = 0;							\
 	int scale = 3;							\
 	int shift = lpa2 ? 16 : PAGE_SHIFT;				\
 	unsigned long addr;						\
 									\
-	while (pages > 0) {						\
+	while (__flush_pages > 0) {					\
 		if (!system_supports_tlb_range() ||			\
-		    pages == 1 ||					\
-		    (lpa2 && start != ALIGN(start, SZ_64K))) {		\
-			addr = __TLBI_VADDR(start, asid);		\
+		    __flush_pages == 1 ||				\
+		    (lpa2 && __flush_start != ALIGN(__flush_start, SZ_64K))) {	\
+			addr = __TLBI_VADDR(__flush_start, asid);	\
 			__tlbi_level(op, addr, tlb_level);		\
 			if (tlbi_user)					\
 				__tlbi_user_level(op, addr, tlb_level);	\
-			start += stride;				\
-			pages -= stride >> PAGE_SHIFT;			\
+			__flush_start += stride;			\
+			__flush_pages -= stride >> PAGE_SHIFT;		\
 			continue;					\
 		}							\
 									\
-		num = __TLBI_RANGE_NUM(pages, scale);			\
+		num = __TLBI_RANGE_NUM(__flush_pages, scale);		\
 		if (num >= 0) {						\
-			addr = __TLBI_VADDR_RANGE(start >> shift, asid, \
+			addr = __TLBI_VADDR_RANGE(__flush_start >> shift, asid, \
 						scale, num, tlb_level);	\
 			__tlbi(r##op, addr);				\
 			if (tlbi_user)					\
 				__tlbi_user(r##op, addr);		\
-			start += __TLBI_RANGE_PAGES(num, scale) << PAGE_SHIFT; \
-			pages -= __TLBI_RANGE_PAGES(num, scale);	\
+			__flush_start += __TLBI_RANGE_PAGES(num, scale) << PAGE_SHIFT; \
+			__flush_pages -= __TLBI_RANGE_PAGES(num, scale);\
 		}							\
 		scale--;						\
 	}								\


