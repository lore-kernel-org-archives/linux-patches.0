Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D6847254E;
	Tue, 21 Jul 2026 18:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658672; cv=none; b=j6afsV8PY+F7ipcPUAQLWQhOP3EjK+k5FEy4YX49xY7TlhR0ROJzsduw7EiRA1wbGJEZru9SHyCaQpchcdZh3xsmsMGl7STa18QwiRfX5iZNRvEH69Cnqdpwh+/d9aJHifcSrVXvQs+4d5gWSHmq5guKVUz0B1Co6JVnnLb9MhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658672; c=relaxed/simple;
	bh=wIZipTNRh/LZOEJQKnUMIGwSYUQu8JkGWl5dYPaBgYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxtMBhaqGjLpaMv3ax7AE/nc0uNfBzC0z4yLIxEK0mR54oN8lELRG9FgWqz9+8WnLE5XhqC0vluh+JFPKYNccu6O/q1HSdiMpYxCSrqLhYru5zg4E+9JVmrYOhtf/QgBco3+JaDZCwcoS0HnifrOeND1E9+3fMd8p84oc0exy78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0LjQ67Ck; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0LjQ67Ck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F4B1F000E9;
	Tue, 21 Jul 2026 18:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658670;
	bh=KCNRxTDZl+4m2obyabTG4qqwhQW7OKG2qy1wYYgu8qQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0LjQ67Ckc2gQT6a4Z6qpn1OWT0cEGqpcItRHfvc8CeK9MjqV7B04P3VGQ9OrlixBV
	 4BHB1nsCzdRFN9A0w86OtAPQfDiH5thitKuWNFId/MZki+VbYqXYlxSe0PlzF6Srjh
	 8NOtEOg6B2NOqCQDC3sDWbNK4nUC3TTnQA1Xwn/0=
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
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 1231/1611] mm/hugetlb: fix hugetlb cgroup rsvd charge/uncharge mismatch
Date: Tue, 21 Jul 2026 17:22:27 +0200
Message-ID: <20260721152543.128969193@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

commit 15807d0ddde37407af72859426b654f3d1972b00 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2959,6 +2959,7 @@ struct folio *alloc_hugetlb_folio(struct
 	map_chg_state map_chg;
 	int ret, idx;
 	struct hugetlb_cgroup *h_cg = NULL;
+	struct hugetlb_cgroup *h_cg_rsvd = NULL;
 	gfp_t gfp = htlb_alloc_mask(h) | __GFP_RETRY_MAYFAIL;
 
 	idx = hstate_index(h);
@@ -3009,7 +3010,7 @@ struct folio *alloc_hugetlb_folio(struct
 	 */
 	if (map_chg) {
 		ret = hugetlb_cgroup_charge_cgroup_rsvd(
-			idx, pages_per_huge_page(h), &h_cg);
+			idx, pages_per_huge_page(h), &h_cg_rsvd);
 		if (ret)
 			goto out_subpool_put;
 	}
@@ -3051,7 +3052,7 @@ struct folio *alloc_hugetlb_folio(struct
 	 */
 	if (map_chg) {
 		hugetlb_cgroup_commit_charge_rsvd(idx, pages_per_huge_page(h),
-						  h_cg, folio);
+						  h_cg_rsvd, folio);
 	}
 
 	spin_unlock_irq(&hugetlb_lock);
@@ -3106,7 +3107,7 @@ out_uncharge_cgroup:
 out_uncharge_cgroup_reservation:
 	if (map_chg)
 		hugetlb_cgroup_uncharge_cgroup_rsvd(idx, pages_per_huge_page(h),
-						    h_cg);
+						    h_cg_rsvd);
 out_subpool_put:
 	/*
 	 * put page to subpool iff the quota of subpool's rsv_hpages is used


