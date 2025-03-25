Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AA3259CAD;
	Tue, 25 Mar 2025 12:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905800; cv=none; b=uwf4IHUf5cU8RW/m+mrPR5mMLdfDOoftyR+efDUmqflxQ2s7DN6vJXpL+vWid9ISKsXEH1HQslnU1mvFMgmQukjhSlZUezYmBEMMh+5TB7Lk528Z5vJjrkClos+o22HsLweq/Catv3K6w7gK0xL9bw9z9CXq9ohGNnJsry9IW44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905800; c=relaxed/simple;
	bh=77SsWQj4J0NJ37DppBeK4UBMYXYLx+ZOgfyeXQzdTL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oVs2wpur0XwaHfGTmm4dlgqTE9Xmau6S17KAdpGAfFALshmCWVqpLnxQmUpsidWRxhdkw2yRBrr5OjYuCITCNkyOT2fZ34QjMBN29Aryt4hGu0gIGtmtMS4Sn/q9ltkIUf2bl2r5gDbm48ibeEDobhnx/VgEHNxU4IK9bBl+UcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oF0vUyhk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oF0vUyhk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8D8C4CEE4;
	Tue, 25 Mar 2025 12:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905800;
	bh=77SsWQj4J0NJ37DppBeK4UBMYXYLx+ZOgfyeXQzdTL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oF0vUyhkAZZsNNfc4usmTSy+PPVZ5UnTp5QpENntI4B3h7wMTafQ+Oh54CVEnxGMB
	 cumoLTDv3nNdU9Jek+AXQUOi12W7z7u5eTq3+VUWxxLXSSBG/ICeFS/QEiM/3akdy9
	 iyxz64CJKRQchYz/cf9jZxTK27IufxOMa2MZGrs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Zhenhua Huang <quic_zhenhuah@quicinc.com>,
	Oscar Salvador <osalvador@suse.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 140/198] arm64: mm: Populate vmemmap at the page level if not section aligned
Date: Tue, 25 Mar 2025 08:21:42 -0400
Message-ID: <20250325122200.326136956@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhenhua Huang <quic_zhenhuah@quicinc.com>

[ Upstream commit d4234d131b0a3f9e65973f1cdc71bb3560f5d14b ]

On the arm64 platform with 4K base page config, SECTION_SIZE_BITS is set
to 27, making one section 128M. The related page struct which vmemmap
points to is 2M then.
Commit c1cc1552616d ("arm64: MMU initialisation") optimizes the
vmemmap to populate at the PMD section level which was suitable
initially since hot plug granule is always one section(128M). However,
commit ba72b4c8cf60 ("mm/sparsemem: support sub-section hotplug")
introduced a 2M(SUBSECTION_SIZE) hot plug granule, which disrupted the
existing arm64 assumptions.

The first problem is that if start or end is not aligned to a section
boundary, such as when a subsection is hot added, populating the entire
section is wasteful.

The next problem is if we hotplug something that spans part of 128 MiB
section (subsections, let's call it memblock1), and then hotplug something
that spans another part of a 128 MiB section(subsections, let's call it
memblock2), and subsequently unplug memblock1, vmemmap_free() will clear
the entire PMD entry which also supports memblock2 even though memblock2
is still active.

Assuming hotplug/unplug sizes are guaranteed to be symmetric. Do the
fix similar to x86-64: populate to pages levels if start/end is not aligned
with section boundary.

Cc: stable@vger.kernel.org # v5.4+
Fixes: ba72b4c8cf60 ("mm/sparsemem: support sub-section hotplug")
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Zhenhua Huang <quic_zhenhuah@quicinc.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20250304072700.3405036-1-quic_zhenhuah@quicinc.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/mmu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 6a4f118fb25f4..f095b99bb2144 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1209,8 +1209,11 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 	pmd_t *pmdp;
 
 	WARN_ON((start < VMEMMAP_START) || (end > VMEMMAP_END));
+	/* [start, end] should be within one section */
+	WARN_ON_ONCE(end - start > PAGES_PER_SECTION * sizeof(struct page));
 
-	if (!ARM64_KERNEL_USES_PMD_MAPS)
+	if (!ARM64_KERNEL_USES_PMD_MAPS ||
+	    (end - start < PAGES_PER_SECTION * sizeof(struct page)))
 		return vmemmap_populate_basepages(start, end, node, altmap);
 
 	do {
-- 
2.39.5



