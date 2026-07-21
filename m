Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928273B9D9D;
	Tue, 21 Jul 2026 21:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669770; cv=none; b=poPZRHXe3zdeeG3mx4tl5sBtZs0eJbDKs9OsZth9VfGaYDtGX/917BRebRsu8ZQlY7vpFTToxhpoVyaJ613hW76AgjWTgGojByn/HHUFe41LlUVZhE/iNclkRPD8LWf59HTtU+COkNA8mz0pPYrZCQENu/kPq0p7/vdCFmAJ5hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669770; c=relaxed/simple;
	bh=bP6ssLmAxJMLahVXmtGLuM68tXPh9hcmo1lf6RJ1L0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WixsmgVdR9WOY1HJhNARrzDepKRlbLNu6x/47uJOam8NV5OdSZoJZg7+v78058oDAVWQ1JooD7KDMbdO64fMvQzVj5+Dj+jSc4YqreL6HhJhZG/7UcPBZdjb3BDrouY3zyohCy0I8zo0wjb/qzYdU0gQvYMLd23c70QzhpluljQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DQGUkwms; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DQGUkwms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097721F00A3E;
	Tue, 21 Jul 2026 21:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669769;
	bh=TaZy8rWxizDk2i8wZ5hDa7OgOIQ8IUWkWFPcFtdx6zU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DQGUkwms88kKMNzryGv1Quff05APms7n5L7H90DmGKxsImF19zWP89U3NdmPNCh/B
	 KUE3mn6NUboCpkRyVISKHM7zTpsRwwX6QgRbcdCb4+fsvh+bxcJwLrh5w2TePGdQWd
	 V7UCQ6PRSmppav41WrBKRfAYu4umxo+Q6PnXDxyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Ben Hutchings <ben@decadent.org.uk>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0680/1067] arm64/mm: Optimize TLB flush in unmap_hotplug_[pmd|pud]_range()
Date: Tue, 21 Jul 2026 17:21:21 +0200
Message-ID: <20260721152439.810335999@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anshuman Khandual <anshuman.khandual@arm.com>

[ Upstream commit ff4c5a0de1f2ef7737a8688a86e19301e567020d ]

Commit 48478b9f7913 ("arm64/mm: Enable batched TLB flush in
unmap_hotplug_range") inadvertently introduced redundant TLB
invalidation when clearing a block entry, resulting in unnecessary
broadcast invalidation on CPUs without support for range-based
invalidation.

Re-introduce the old behaviour, along with some expanded comments to
help people working in this area next time around.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Closes: https://lore.kernel.org/all/b0d5836032ce3135bfc473f6bff791306d086925.camel@decadent.org.uk/
Fixes: 48478b9f7913 ("arm64/mm: Enable batched TLB flush in unmap_hotplug_range()")
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
[will: Reword comments and commit message]
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/mmu.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 3d7f9732201667..72fb70f2bfb203 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -956,7 +956,13 @@ static void unmap_hotplug_pmd_range(pud_t *pudp, unsigned long addr,
 			if (free_mapped) {
 				/* CONT blocks are not supported in the vmemmap */
 				WARN_ON(pmd_cont(pmd));
-				flush_tlb_kernel_range(addr, addr + PMD_SIZE);
+				/*
+				 * Invalidating a block entry requires just
+				 * a single overlapping TLB invalidation,
+				 * so limit the range of the flush to a single
+				 * page.
+				 */
+				flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
 				free_hotplug_page_range(pmd_page(pmd),
 							PMD_SIZE, altmap);
 			}
@@ -986,7 +992,8 @@ static void unmap_hotplug_pud_range(p4d_t *p4dp, unsigned long addr,
 		if (pud_sect(pud)) {
 			pud_clear(pudp);
 			if (free_mapped) {
-				flush_tlb_kernel_range(addr, addr + PUD_SIZE);
+				/* See comment in unmap_hotplug_pmd_range(). */
+				flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
 				free_hotplug_page_range(pud_page(pud),
 							PUD_SIZE, altmap);
 			}
-- 
2.53.0



