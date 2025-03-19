Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F8F18BC36;
	Wed, 19 Mar 2025 14:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395250; cv=none; b=hm6r5m2/DZNdd0WiOeA67ZYb08dU1fmE4JgHi1zTRiCGbwTzrFiA+mJCZ4fMUoiuC+CNZk4M9EkBPAi9zG7MFycQC9c3ruawA6Te3czQ3XMPfC8NvCRzyUfNtQDOx5En6cpGHVI1XvaTRecH47cboczSMGofAGYRYwIU6mnwtyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395250; c=relaxed/simple;
	bh=kqWaQgsjDgimILJLyb/3593xDejv02tHvnA5OVh+Fus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gcoV/V5WCOF2g3oAqTAHeT1fFrGd1ePXC86S/Xm3D2BlXgr+o2cr+RAW1eFAVts9Ou9Pk8SMzSCXb+8OcXw7HPLuckMbpEVqq8VyABhMxSe+/yLCbS3rOCDmMezyQ/i2hdEy1fNT+hcWkwD15lN1MQ2EIAMdOkadabhdSdrYPvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T8vwU4vu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T8vwU4vu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25B2C4CEE4;
	Wed, 19 Mar 2025 14:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395250;
	bh=kqWaQgsjDgimILJLyb/3593xDejv02tHvnA5OVh+Fus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T8vwU4vuhs5FVF6ELy8GcuL/9l4zR0+DOOMvzAUo9gwQC15xnSsb31a+ye80h7xOC
	 s1SR94D+Icnsc5iYOhgMLb2cKON7LiYRliTQ3Zpuf/Y4e8TEevpHg8DrfZEjLsnbOz
	 8wLxPTvo73f7Xq/oHZxGjSrs2/7QvWMsJBL8XSE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Zhenhua Huang <quic_zhenhuah@quicinc.com>,
	Oscar Salvador <osalvador@suse.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.6 132/166] arm64: mm: Populate vmemmap at the page level if not section aligned
Date: Wed, 19 Mar 2025 07:31:43 -0700
Message-ID: <20250319143023.590012332@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhenhua Huang <quic_zhenhuah@quicinc.com>

commit d4234d131b0a3f9e65973f1cdc71bb3560f5d14b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/mmu.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1150,8 +1150,11 @@ int __meminit vmemmap_populate(unsigned
 		struct vmem_altmap *altmap)
 {
 	WARN_ON((start < VMEMMAP_START) || (end > VMEMMAP_END));
+	/* [start, end] should be within one section */
+	WARN_ON_ONCE(end - start > PAGES_PER_SECTION * sizeof(struct page));
 
-	if (!IS_ENABLED(CONFIG_ARM64_4K_PAGES))
+	if (!IS_ENABLED(CONFIG_ARM64_4K_PAGES) ||
+	    (end - start < PAGES_PER_SECTION * sizeof(struct page)))
 		return vmemmap_populate_basepages(start, end, node, altmap);
 	else
 		return vmemmap_populate_hugepages(start, end, node, altmap);


