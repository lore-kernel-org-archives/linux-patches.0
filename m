Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158FB3AA187;
	Fri,  4 Sep 2026 05:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498396; cv=none; b=V/4CagYt6GUrrUHWQw59LK5ymZDThFBJ+5plkCyiKU/wwWPbQz+q7yPoXMR6bx9+IiP5b4vnIgBOfujbdnShlpialumO/Fh90NiX/oh+PgnNHG4n1m3N8hD2QkV6oC8gj1RnuBDRMWVuaCTT/xUFtSSgxL8m1nsqM7JuO3I82MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498396; c=relaxed/simple;
	bh=/HyOpSrotDOrm40O/aZ8lXJ3bjUoDmOPyZoRRUPCKTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/KfPIAzC4P7O/ICciBolwhCaCnJWt+oCYbFbDiRNNc+qessjVjzR7ppInDidh1AWITb8C+PCUvXnbNB1y78IucSO6mjkp4GblFOshK9K8O1HOngFfvVDqGX8ktqp8Uodtohio+1dqAvpokofBIxH/jgRTUdT+F5PO+fivFPKrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qt1RtGmV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qt1RtGmV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67AB01F00A3E;
	Fri,  4 Sep 2026 05:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498395;
	bh=mrBUx5pRhazxtV1JBsesojkppicRnvElgSytb71YP3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qt1RtGmVmXGPpk+mhoSE/Mrm1W8SIk2457GZjR8LZ3X7RlD6JvNgJfo42fVsXCSlt
	 zaQ5ssfUsJ7nmvqPmiFsSEBgHajw34v3zOWEma3CA3QvzgUU1KekZlZaCWPYSTwDYy
	 B8lqLNcCjxlqKAY2erycIn3rTmYoMN77HuHwTs90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Usama Arif <usama.arif@linux.dev>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Zi Yan <ziy@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	Alistair Popple <apopple@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Byungchul Park <byungchul@sk.com>,
	Dev Jain <dev.jain@arm.com>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Jann Horn <jannh@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Nico Pache <npache@redhat.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	sashiko-bot <sashiko-bot@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 048/713] mm/huge_memory: skip device-private PMDs in madvise_free_huge_pmd
Date: Fri,  4 Sep 2026 06:50:16 +0200
Message-ID: <20260904045804.905616580@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Usama Arif <usama.arif@linux.dev>

commit ce579dcf730ce5ed8043a5eeea18a3e6706a97e5 upstream.

madvise_free_pte_range() checks pmd_trans_huge(*pmd) unlocked, then
madvise_free_huge_pmd() takes pmd_trans_huge_lock().  pmd_is_huge()
returns true for a device-private PMD, so orig_pmd can be device-private
and enter the !pmd_present() branch.

Skip device-private PMDs in that non-present branch and continue to out
before calling pmd_folio().  Downgrade the check to VM_WARN_ON_ONCE() so
an unexpected PMD softleaf logs a warning rather than panicking.  Drop the
thp_migration_supported() guard: it expands to
IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF), and both
pmd_is_migration_entry() and pmd_is_device_private_entry() already return
false when that config is not selected, so the guard suppresses only the
case where the warning would already be silent.

Potential trigger: an HMM-based GPU driver races with madvise(MADV_FREE):
migrate_vma_pages() flips the PMD to a device-private entry between the
caller's pmd_trans_huge() check and the callee's pmd_trans_huge_lock().

Link: https://lore.kernel.org/20260710105557.1987433-4-usama.arif@linux.dev
Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: sashiko-bot <sashiko-bot@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2340,8 +2340,8 @@ bool madvise_free_huge_pmd(struct mmu_ga
 		goto out;
 
 	if (unlikely(!pmd_present(orig_pmd))) {
-		VM_BUG_ON(thp_migration_supported() &&
-				  !pmd_is_migration_entry(orig_pmd));
+		VM_WARN_ON_ONCE(!pmd_is_migration_entry(orig_pmd) &&
+				!pmd_is_device_private_entry(orig_pmd));
 		goto out;
 	}
 


