Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215472;
	b=qvkouj1MLhRpDbbTefntczRao7pNQoV08L10OgkI7meNvN9MrvyrJldhf+ytGbpQ4ZoJ
	 GicaQ5SPYWm4bnJSMA5LVM+jGsbpGtf8oINKXDrl087g7aW6wjHPoW8TMsQRSkkgvR7EG
	 QZWVUl2bTl63E5xelAptUePJYbUxWd6d/cSDMhe7aN6BV74EjPcNRNlTvrTTRUTs1FSGT
	 7w3FOaZI2cWcQzUV/aMcdlsWEFNm2HHwGR32oiHNyPdWBMXwxh0DEagQ9QpOL1c2WR0ty
	 /o1LkjPhC9k8KXzmIzKhySG7elZCvjuzbpadwrAa5HV2FnzBCNX9OVJIhwIAvjWC9eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215472;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zXj70sCDxBBmANZDf3zRg50Lmf5anYInzAKyvFUdsFc=;
	b=xkfwwVITX33MncBxcnnC9rCIrRGrZNAMtKkE4VoUP4VTpq2mEMD+jBiOavx6LLBHGJhb
	 /71SgX0LXr/p6SJ4Pk+M7n7WjVErKyigbc5YRJTWSCREnBx7AMus4vmZlLGeNomwjJbXP
	 AMM3NyRNUbeDpP7KjfJD3U6WRIn0sKKSrYNuRaXtxkrfpovMAdLZ6vvi4IKbXR5C3bzji
	 EL1fPSc0L1BtpyympqDr1fjG2oqr99aeuEXBiJnICL7PuYfzhi8GPoPgNgVRWFk+w3m9D
	 tqUBLJbVzmPl9TQ3ovYxcfbR/OSMrr+YDllRSsrwn3VDVICRbD2f6q00p7O0n759gXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MjenTtGR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E276B606A322;
	Wed, 28 Oct 2026 19:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MjenTtGR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47831F01828;
	Wed, 28 Oct 2026 19:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215471;
	bh=zXj70sCDxBBmANZDf3zRg50Lmf5anYInzAKyvFUdsFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MjenTtGRsxURJZsMoHkahvhjSKXjhoyf4egozwImMyD57TxC7hoVv74gvQJimIOSk
	 4JEybDz7EJw7jIWsTb+Ns7cxhXI4T8XcmSRmjEEwn4iaQ7mLNu2PORfwNyg16J9NNB
	 3Uz5WAHc1plyZq/NM2gZEmEts8GNGFS7TQq8CsjI=
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
Subject: [PATCH 6.1 1220/1887] mm/hugetlb: fix hugetlb cgroup rsvd charge/uncharge mismatch
Date: Wed, 28 Oct 2026 17:55:16 +0100
Message-ID: <20261028170527.188340980@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 mm/hugetlb.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ee2685d5a6e1c..f549adc0b6705 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3083,7 +3083,8 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
 	long map_chg, map_commit;
 	long gbl_chg;
 	int ret, idx;
-	struct hugetlb_cgroup *h_cg;
+	struct hugetlb_cgroup *h_cg = NULL;
+	struct hugetlb_cgroup *h_cg_rsvd = NULL;
 	bool deferred_reserve;
 
 	idx = hstate_index(h);
@@ -3116,7 +3117,7 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
 	deferred_reserve = map_chg || avoid_reserve;
 	if (deferred_reserve) {
 		ret = hugetlb_cgroup_charge_cgroup_rsvd(
-			idx, pages_per_huge_page(h), &h_cg);
+			idx, pages_per_huge_page(h), &h_cg_rsvd);
 		if (ret)
 			goto out_subpool_put;
 	}
@@ -3154,7 +3155,7 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
 	 */
 	if (deferred_reserve) {
 		hugetlb_cgroup_commit_charge_rsvd(idx, pages_per_huge_page(h),
-						  h_cg, page);
+						  h_cg_rsvd, page);
 	}
 
 	spin_unlock_irq(&hugetlb_lock);
@@ -3190,7 +3191,7 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
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



