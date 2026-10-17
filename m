Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CBB3BE178;
	Sat, 17 Oct 2026 17:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259166; cv=none; b=MlHhPDOcdEABlhL3EW7fuTnHwXikPHMIaht2S/fkK5i2UnAl23Yy6HEOOJyOO5ySyTY4qQYOVGg826dhc+kPASc30trGj6Rolq9JwHNVDtc2Y5DP0njOP5pZUJ6wp+W7g9mIHqxaJBqOzpBChoqKbRdPhoBtnqEaj0V+60jYeoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259166; c=relaxed/simple;
	bh=EXCigqPuGGl62mjfDTQtXC8SGIXRB/xW9wmoga+jH38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D1nIeD7/yQE+XcO/6+8BWMcPi44zQXB+Cu01B/gfgssbxnDW8QGiThbOrs8Aru8+7Wk/yHM4PxmJ7l3AHwQfmSV2vWZNVPJFucNRoF+WIA7uukw+b9GQOEIMeZ9dqqBT95TtfOBr4L+hh9lCAy9PcYz341QQ8aNtVQF+n7qB8y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QMNsVWYS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QMNsVWYS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3411F000C5;
	Sat, 17 Oct 2026 17:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259164;
	bh=SVE0h9WOAmJhI8TL+fLzZTZffGasf5N2mv4jJGLrhCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QMNsVWYSa6ib4cxlxvcdpzzVKMprIpJszCEEo4p7CEcYA/xAVW2RqbxhlN1uh7gxH
	 EfY5TEikWQI6xeiODPxG9cQafnlzbuBET/ybCAyRb/3O6TXDhVmqUMk+rF1jQJ94km
	 K60QgqUN59xnl0Kg9XUCRPwkEMhhdjtewLzy6wIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+226c1f947186f8fef796@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mina Almasry <almasrymina@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1123/1674] mm/hugetlb: fix hugetlb cgroup rsvd charge/uncharge mismatch
Date: Sat, 17 Oct 2026 17:56:35 +0200
Message-ID: <20261017160459.981446737@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit 15807d0ddde37407af72859426b654f3d1972b00 ]

In alloc_hugetlb_folio(), a single h_cg pointer is used for both the rsvd
and non-rsvd hugetlb cgroup charges.  When map_chg is set,
hugetlb_cgroup_charge_cgroup_rsvd() stores the charged cgroup in h_cg, but
the immediately following hugetlb_cgroup_charge_cgroup() overwrites h_cg
with the non-rsvd cgroup pointer.

As a result, hugetlb_cgroup_commit_charge_rsvd() stores the wrong
(non-rsvd) cgroup pointer into the folio's rsvd slot.

When the folio is later freed, free_huge_folio() unconditionally calls
both hugetlb_cgroup_uncharge_folio() and
hugetlb_cgroup_uncharge_folio_rsvd().  The rsvd uncharge reads back the
wrong cgroup from the folio and decrements a counter that was never
charged for that cgroup, causing a page_counter underflow:

  page_counter underflow: -512 nr_pages=512
  WARNING: mm/page_counter.c:61 at page_counter_cancel

Fix this by introducing a separate h_cg_rsvd pointer exclusively for the
rsvd charge path, keeping the rsvd and non-rsvd charges fully independent
through their charge, commit, and error uncharge paths.

Link: https://lore.kernel.org/20260328065534.346053-1-kartikey406@gmail.com
Fixes: 08cf9faf7558 ("hugetlb_cgroup: support noreserve mappings")
Reported-by: syzbot+226c1f947186f8fef796@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=226c1f947186f8fef796
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mina Almasry <almasrymina@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index cca79f0e78f70..8bfaaa84bb3f7 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3058,6 +3058,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	long gbl_chg;
 	int ret, idx;
 	struct hugetlb_cgroup *h_cg = NULL;
+	struct hugetlb_cgroup *h_cg_rsvd = NULL;
 	bool deferred_reserve;
 
 	idx = hstate_index(h);
@@ -3090,7 +3091,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	deferred_reserve = map_chg || avoid_reserve;
 	if (deferred_reserve) {
 		ret = hugetlb_cgroup_charge_cgroup_rsvd(
-			idx, pages_per_huge_page(h), &h_cg);
+			idx, pages_per_huge_page(h), &h_cg_rsvd);
 		if (ret)
 			goto out_subpool_put;
 	}
@@ -3127,7 +3128,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	 */
 	if (deferred_reserve) {
 		hugetlb_cgroup_commit_charge_rsvd(idx, pages_per_huge_page(h),
-						  h_cg, folio);
+						  h_cg_rsvd, folio);
 	}
 
 	spin_unlock_irq(&hugetlb_lock);
@@ -3163,7 +3164,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 out_uncharge_cgroup_reservation:
 	if (deferred_reserve)
 		hugetlb_cgroup_uncharge_cgroup_rsvd(idx, pages_per_huge_page(h),
-						    h_cg);
+						    h_cg_rsvd);
 out_subpool_put:
 	if (map_chg || avoid_reserve)
 		hugepage_subpool_put_pages(spool, 1);
-- 
2.53.0



