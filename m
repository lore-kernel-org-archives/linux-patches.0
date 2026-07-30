Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E498367B89;
	Thu, 30 Jul 2026 14:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422970; cv=none; b=k8zhcFtr+nJaMp7yVJ0BYdHjE/opErDP2x/guIyHF6UHIc4KtuEITSTvS3xJgWjC2NmfxtzB/epOQFdHjmXPd/XqdqCCh/tRO1dQmmO0aE/ZG52CB+9/0v5zl2bZbAZq3iM4dMfNM12iku6POVEVr43FkIHqzjyqn4WEfwpTIGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422970; c=relaxed/simple;
	bh=wSIywQxr+LTA9x+8yTj0ES08AqlwAMMDryyHx+5S7XU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyglFAFtvyis7cxgY9ChN5epUibmS2mRXmOzkcuNiUlk4YlrNNNKCKU0wtQ08aaDu2KMkTFw7coXPRXgryheK78XarJKmaF3KHbnZ9F9a+sRQXjW7OrLTPH+An8WKn6kq6o1EwAyYK3+4k/lEZu/MZciB+FMrJ+1cDXTRKHnIS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJ8N4E/G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJ8N4E/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0A3B1F000E9;
	Thu, 30 Jul 2026 14:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422969;
	bh=F1NjZjOqyeZ96eZ5OvrByaSPDbKReClMW65NdYumBQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EJ8N4E/G5P67ZBfE0c/JXkUqfKHZaJuDCUeTgdtiWSnTmu5gjUHQO73omR+pwW/5W
	 bqyc52y8jsmloDtLUfwhPUIVsnML9E/d+CSS/FIa5c44rpramMSDejbyaJsdyaSPMC
	 av6z9bk0S32QXSGI9pI9xXb8RUUG1xvV5drABYNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Balbir Singh <balbirs@nvidia.com>,
	Klara Modin <klarasmodin@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 620/744] mm/page_vma_mapped: fix device-private PMD handling
Date: Thu, 30 Jul 2026 16:14:53 +0200
Message-ID: <20260730141457.452254915@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Wei Yang <richard.weiyang@gmail.com>

commit f84ca9b1888d8fce7dfefe0e750fa971f8797486 upstream.

Commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
device-private entries") introduced the concept of device-private PMD
entries, but did not correctly update the rmap walk code to account for
them.

As a result, when page_vma_mapped_walk() encounters device-private PMD
entries, it takes no action other than to acquire the PMD lock and exit.

However this is highly problematic for two reasons - firstly, device
private entries possess a PFN so check_pmd() needs to be called to ensure
an overlapping PFN range.

Secondly, and more importantly, if PVMW_MIGRATION is set the caller
assumes the returned entry is a migration entry, resulting in memory
corruption when the caller tries to interpret the device private entry as
such.

In addition, commit 146287290023 ("mm/huge_memory: implement
device-private THP splitting") allowed device private PMDs to be split
like THP mappings, but again did not update this code path.

As a result, we might race a PMD split prior to acquiring the PMD lock.

This patch addresses all of these issues by invoking check_pmd(), ensuring
PMVW_MIGRATION is not set and checks whether a split raced us we do for
PMD THP and migration entries.

Instead of checking for a subset of the cases after taking the pmd_lock(),
put device-private along with pmd_trans_huge() and
pmd_is_migration_entry().  Also remove thp_migration_supported() as it is
already guarded by pmd_is_migration_entry().

[akpm@linux-foundation.org: fix Raspberry Pi 1 build, per David]
Link: https://lore.kernel.org/20260630021540.17297-1-richard.weiyang@gmail.com
Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Suggested-by: David Hildenbrand <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Tested-by: Klara Modin <klarasmodin@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: <stable@vger.kernel.org>q
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_vma_mapped.c |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -242,21 +242,31 @@ restart:
 		 */
 		pmde = pmdp_get_lockless(pvmw->pmd);
 
-		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
+		if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+		    (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde) ||
+		    pmd_is_device_private_entry(pmde))) {
 			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
 			pmde = *pvmw->pmd;
-			if (!pmd_present(pmde)) {
+			if (pmd_is_migration_entry(pmde)) {
 				softleaf_t entry;
 
-				if (!thp_migration_supported() ||
-				    !(pvmw->flags & PVMW_MIGRATION))
+				if (!(pvmw->flags & PVMW_MIGRATION))
 					return not_found(pvmw);
 				entry = softleaf_from_pmd(pmde);
+				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
+					return not_found(pvmw);
+				return true;
+			} else if (pmd_is_device_private_entry(pmde)) {
+				softleaf_t entry;
 
-				if (!softleaf_is_migration(entry) ||
-				    !check_pmd(softleaf_to_pfn(entry), pvmw))
+				if (pvmw->flags & PVMW_MIGRATION)
+					return not_found(pvmw);
+				entry = softleaf_from_pmd(pmde);
+				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
 					return not_found(pvmw);
 				return true;
+			} else if (!pmd_present(pmde)) {
+				return not_found(pvmw);
 			}
 			if (likely(pmd_trans_huge(pmde))) {
 				if (pvmw->flags & PVMW_MIGRATION)
@@ -265,17 +275,10 @@ restart:
 					return not_found(pvmw);
 				return true;
 			}
-			/* THP pmd was split under us: handle on pte level */
+			/* THP/device-private pmd was split under us: handle on pte level */
 			spin_unlock(pvmw->ptl);
 			pvmw->ptl = NULL;
 		} else if (!pmd_present(pmde)) {
-			const softleaf_t entry = softleaf_from_pmd(pmde);
-
-			if (softleaf_is_device_private(entry)) {
-				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
-				return true;
-			}
-
 			if ((pvmw->flags & PVMW_SYNC) &&
 			    thp_vma_suitable_order(vma, pvmw->address,
 						   PMD_ORDER) &&


