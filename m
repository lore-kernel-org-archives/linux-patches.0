Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9D441D4F1;
	Sat, 12 Sep 2026 09:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205777; cv=none; b=tdzxJNBv0Ndm2LJVYvOCy2rnikmB6vJJu0gJI8fSXYI386mxseiP4zc7G5ULQmuaT8sIqU/IicZ18IOl1gilyXoGP+PGtPyAUeAOEQYPAJ9l6Ry0YYKRnVwJ0ggQnGeJnvzH9LRX4Ne5HtXPFdwtfWcKUvWDV71dmVGyXTq8ImM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205777; c=relaxed/simple;
	bh=mfJDrk4C2X0Ou+mJfLTh1qt+2Nf6vRJBEHJJPLpG1ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ddZLbsDylaCyeGZC3bCkK9DpH27Dxg43mivGaANV+z6uy18dHb8/NrLQhDWjMiVikhXfBSFurz1JTDcSVYpyOCkbrT/OYbppxC+vkXNG5aarxIyRRaLmosLngNVYs/LnnSpEikRbPQrVBi+gsqjDFcNnqNQnQYu/WdTG06vBaXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FEGkUhnG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FEGkUhnG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC95C1F00898;
	Sat, 12 Sep 2026 09:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205772;
	bh=1ilTI+CL1x9XWETeBT50WuOE+1tJP7wn9WGdyb+OIfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FEGkUhnGAY8uuVri3YUblmLZW9ec8buHyJhY8igBRLeG5CP+hR7+AryusOsWjCp5+
	 IKmTcCPvWY0BQMItjA2RA44dl32iQJqg8bmfnYXO7znHaEHZL5u/yItlck13/zjAtx
	 B1ZZafp8HyTInKPU50xLrjhie6GGDxD1lbSHbM6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Barry Song <baohua@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0070/1518] mm: fix incorrect vm_flags usage when checking allowable orders for tmpfs
Date: Sat, 12 Sep 2026 08:37:19 +0200
Message-ID: <20260912065625.042653125@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Baolin Wang <baolin.wang@linux.alibaba.com>

[ Upstream commit 2fd4e7693674b17807a6d082feb01a3fbf86f5f8 ]

Lance reported that when nothing else causes the mm to be considered for
khugepaged collapse, an MADV_HUGEPAGE-advised tmpfs VMA alone does not
trigger scanning.

After commit 6beeab870e70 ("mm: shmem: move shmem_huge_global_enabled()
into shmem_allowable_huge_orders()"), the shmem/tmpfs allowable order
check reads vma->flags directly.  However, when MADV_HUGEPAGE is handled,
khugepaged_enter_vma() is called before the VMA's flags have been updated,
so the check uses stale flags and incorrectly rejects the VMA for
collapse.  As a result, khugepaged does not collapse the tmpfs file into
PMD order in time.

Fix this by calling khugepaged_enter_vma() with the new VMA flags in
madvise_update_vma().  Meanwhile we can remove the khugepaged_enter_vma()
in hugepage_madvise().

Link: https://lore.kernel.org/7d5b5eb27be798f89d563b06254c947ff53db0b2.1787020910.git.baolin.wang@linux.alibaba.com
Fixes: 6beeab870e70 ("mm: shmem: move shmem_huge_global_enabled() into shmem_allowable_huge_orders()")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reported-by: Lance Yang <lance.yang@linux.dev>
Closes: https://lore.kernel.org/all/20260815181632.21453-1-lance.yang@linux.dev/
Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ adapted newer VMA flag APIs to the older scalar vm_flags_t interface. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/khugepaged.c |    6 ------
 mm/madvise.c    |    8 ++++++++
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -353,12 +353,6 @@ int hugepage_madvise(struct vm_area_stru
 #endif
 		*vm_flags &= ~VM_NOHUGEPAGE;
 		*vm_flags |= VM_HUGEPAGE;
-		/*
-		 * If the vma become good for khugepaged to scan,
-		 * register it here without waiting a page fault that
-		 * may not happen any time soon.
-		 */
-		khugepaged_enter_vma(vma, *vm_flags);
 		break;
 	case MADV_NOHUGEPAGE:
 		*vm_flags &= ~VM_HUGEPAGE;
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -177,6 +177,14 @@ static int madvise_update_vma(vm_flags_t
 	/* vm_flags is protected by the mmap_lock held in write mode. */
 	vma_start_write(vma);
 	vm_flags_reset(vma, new_flags);
+	/*
+	 * If the vma become good for khugepaged to scan,
+	 * register it here without waiting a page fault that
+	 * may not happen any time soon.
+	 */
+	if (new_flags & VM_HUGEPAGE)
+		khugepaged_enter_vma(vma, new_flags);
+
 	if (set_new_anon_name)
 		return replace_anon_vma_name(vma, anon_name);
 


