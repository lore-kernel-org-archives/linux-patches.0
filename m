Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C093D1CCA;
	Tue, 21 Jul 2026 17:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653677; cv=none; b=EyExkCr3LZnDL1mBI7A8z5VWs5/BU4DJGbKhoQhepokGjFJ5zSo8xcK9K/W6mIy/qKpGkipMn/1oQYcQSZ/JjbI+uoP6yIpP35cnOFTrdrQFcoNS6ZNaMmtt68K63xUCwBRi6wDtDuql0jTn4I+W7aEQ/7z5wVyHY4hi33NKoCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653677; c=relaxed/simple;
	bh=/vFHHI+7vBTRkyzGLNcYSsiuz6vtKLKXhEXAg077xzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJMXl1uCZ5AXD6ESIkl+hmvIvnuHZx7+2nBL4K4QqEZeB68/stT2jQgCBPD1KarKxNu8iNCC+tVD6b5rchRjNn98PBdbSiQH2mAhQX3OHiULB8Bk9Y1SdqWIcsurPX9KuEwZw4FC6JSrK7ikt/V3HbjDXUKVPAvyhbh9kYi4Adw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y1JsRoGq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y1JsRoGq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0DDB1F000E9;
	Tue, 21 Jul 2026 17:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653676;
	bh=/eAumxzMklKt7KlxDDtQy7bkz7VKZym9Gf7t+LB3cbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y1JsRoGqdh4q1f/UXtl0lxL00yaQQFwe0BMpt1WfxPbTPkmXFHCaley76+C/6+kb1
	 GdAgAg6yN3MJuIYso4TSf+iTy0BoRALcqGVrimk8xojwc7JeGkWFn8WX3LQJ7kr2Yw
	 wEAdBESqi59tPXN7Sj1DnlePkWczus7lAraejaKo=
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
Subject: [PATCH 7.1 1416/2077] arm64/mm: Optimize TLB flush in unmap_hotplug_[pmd|pud]_range()
Date: Tue, 21 Jul 2026 17:18:09 +0200
Message-ID: <20260721152626.202569384@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8242f93f05e4fc..fd756390fe925c 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1509,7 +1509,13 @@ static void unmap_hotplug_pmd_range(pud_t *pudp, unsigned long addr,
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
@@ -1539,7 +1545,8 @@ static void unmap_hotplug_pud_range(p4d_t *p4dp, unsigned long addr,
 		if (pud_leaf(pud)) {
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



