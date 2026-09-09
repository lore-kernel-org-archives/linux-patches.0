Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2529452ED5E;
	Wed,  9 Sep 2026 13:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962208; cv=none; b=IxMBAkfEr/uIhY6vysx/OI78km0elmhQe5myRfzsehqrsSGTnmKPvlwyUzyQyo++vObMpefNrZkAnK5gGZVzUCsA44IvBO6pj45q3p2RtSuL6f9BANu++UQ6X6Jt3Xc7frcZyn2AjJb/KD/pyftwWiOLYr+HnrnIn+imwzUlhNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962208; c=relaxed/simple;
	bh=nK49VXmuk3YxXF5SOQRaygAD8LMqaUnUTU5aXJ7ATwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=US8AvGUaxvIPDrOGbpFfB9jhwwqe67+Ro+Fj0uMUuErf1UyAj9z0VUfNbpx5W49gar6g5lYOU+kBye+mOa/ewXmgIrobDO2myZrNEvGqR3a3Kaf3/zEnJY5AlehvtemP4JCha4ItCIjig/MeZ5sBwOaflBAskwkhvRmFZYS3l+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DKKe4YOp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DKKe4YOp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DAA01F00A3A;
	Wed,  9 Sep 2026 13:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962207;
	bh=AjTW6V3D+LLzEskflOCsjC9rF8KQ07F8aELDgIiAdFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DKKe4YOpin9zM7SG4niKFuLrJPnDIrm5Wv3rvuuGN8k3bkgrFBSjZSd5u87lAHP16
	 JDRX/Btk5GLGeRI9AvO2GODtbZzls219kaAmYwtmVeX1a0fby24ROALqVnWAxAjlmp
	 AZoz01xdoezYeJpI3Hnz5WwtWSu2N7lcwZQB/Wik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wupeng Ma <mawupeng1@huawei.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 170/556] mm/hugetlb: fix missing migratable flag on same-node hugetlb migration
Date: Wed,  9 Sep 2026 15:37:30 +0200
Message-ID: <20260909134236.401869310@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Wupeng Ma <mawupeng1@huawei.com>

commit 8ee1ef0f2f8ce29338f4ab00a3d344c010208058 upstream.

Commit ba23f58de896 ("mm/migrate: don't call
folio_putback_active_hugetlb() on dst hugetlb folio") moved setting of the
migratable flag and active-list placement from
folio_putback_active_hugetlb(dst) into move_hugetlb_state(), so that the
freshly allocated destination folio is handled where allocation is known
to have succeeded.

Unfortunately, the new code was appended after the existing
temporary-folio block in move_hugetlb_state(), which contains an early
return added earlier by commit 5af1ab1d24e08 ("mm/hugetlb: optimize the
surplus state transfer code in move_hugetlb_state()"):

  if (folio_test_hugetlb_temporary(new_folio)) {
      ...
      if (new_nid == old_nid)
          return;                       <-- skips the new code
      ...
  }

  /* added by ba23f58 */
  folio_set_hugetlb_migratable(new_folio);
  list_move_tail(&new_folio->lru, ...&h->hugepage_activelist);

When the destination folio is temporary (i.e.  the hugetlb pool was
exhausted and the migration callback fell back to
alloc_migrate_hugetlb_folio()) and the migration does not cross a node --
the common case, and always true on a single-NUMA system --
move_hugetlb_state() returns before setting the migratable flag or adding
the new folio to the active list.  The destination folio is then installed
in the page table but cannot be isolated afterwards, since
folio_isolate_hugetlb() rejects folios without the migratable flag; a
subsequent soft-offline, hard-offline or memory-hotplug offline of that
folio fails with -EBUSY.

This was reproduced on a single-NUMA arm64 VM: a second MADV_SOFT_OFFLINE
on an already-migrated hugetlb page returned EBUSY and logged "hugepage
isolation failed".

Keep the surplus adjustment, which is the only part that depends on the
node crossing, guarded by `if (new_nid != old_nid)', while making the
migratable flag and active-list placement unconditional.  This preserves
the cleanup intent of ba23f58 and closes the early-return hole.

Link: https://lore.kernel.org/20260707110254.3147686-1-mawupeng1@huawei.com
Fixes: ba23f58de896 ("mm/migrate: don't call folio_putback_active_hugetlb() on dst hugetlb folio")
Signed-off-by: Wupeng Ma <mawupeng1@huawei.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7243,14 +7243,14 @@ void move_hugetlb_state(struct folio *ol
 		 * There is no need to transfer the per-node surplus state
 		 * when we do not cross the node.
 		 */
-		if (new_nid == old_nid)
-			return;
-		spin_lock_irq(&hugetlb_lock);
-		if (h->surplus_huge_pages_node[old_nid]) {
-			h->surplus_huge_pages_node[old_nid]--;
-			h->surplus_huge_pages_node[new_nid]++;
+		if (new_nid != old_nid) {
+			spin_lock_irq(&hugetlb_lock);
+			if (h->surplus_huge_pages_node[old_nid]) {
+				h->surplus_huge_pages_node[old_nid]--;
+				h->surplus_huge_pages_node[new_nid]++;
+			}
+			spin_unlock_irq(&hugetlb_lock);
 		}
-		spin_unlock_irq(&hugetlb_lock);
 	}
 
 	/*


