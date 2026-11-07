Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064557;
	b=H7fypZiCeHShbRaWkgLXugXLxTMiFZNyYrjE7Gs2xsQ9beGWcqAa050VrAOcRb6SvuPV
	 z+LnbzUKpitdkXBuTSypfT7GyH9H2zUAhnsZel7LO9bKFdxFLPX9PZ/WZYtOf1yPy778m
	 isCGiopk5cXl2NYXzjUj8VXfV6xSbl3Qc7e/ZlXefBtucChLgWEOZ6izNxgzT2Yh4aQX0
	 JkclEzFkT/aTkTgv619vBv97UwhfFpktvRVhd9C0Z1k+9No6UOIXlo0bGpRt1Te0tOi+n
	 Qpb8lPchWi0srsK5VHNAhT4gbi5ypveqHl4qNhOlgcaSootjTonBg3GoYeVOeP7NOQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064557;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q2WpoCHrmF8fP10tsOAXTcC7C0M+pYX1xn/SUHwNO6Y=;
	b=fiBkNMFj3nmbbv9REYFk0Ad/fSu8vYh37/NtdvzKnqrvkXZ8n//AMhxC9NfpZjFELwrv
	 eaEFHOYSrMQ4WRLpAcDBfhMOw/f4rbS+suCL1UnEIM6W5qWiNDgpM/ucWBib4pv62J3gI
	 lLPZo+UdqV5cC/5a80brXRqXPsCHR7+myy3TsThKe28wor0SPRZrTXFLfs9mGsLcV1wlr
	 foYp2azSW37L48cPhXzUmnCx9kVa7ari3jXRQFl/k0q/EaZrIARQ0wkEGHpS85hdFXB20
	 v70rIx6Lr20gFIOplbt79f39TWSep6YNuZthZO7aGyflHWO1zwXQ2hi+BXVtX44HPtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BaHFpJvf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E365606D813;
	Sat,  7 Nov 2026 15:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BaHFpJvf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2FE1F0089F;
	Sat,  7 Nov 2026 15:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064556;
	bh=Q2WpoCHrmF8fP10tsOAXTcC7C0M+pYX1xn/SUHwNO6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BaHFpJvfNtMNaqAYXWP8sxtT79IJg4rIXxbVEGE+rXa4uW6pzwZWi9syWCTvTbEx4
	 Bk2waOldoTMqTdlJ6yj77jrJzvFHYwOkN2bARMgkSk83vjxONQmZ7wxHI7HXMnOcYf
	 YC1JWE87mWrRdStbvXbQ/UtBPpIMYolbiYnvzjK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinmeng Zhou <zhoujinmeng@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Ackerley Tng <ackerleytng@google.com>,
	David Hildenbrand <david@kernel.org>,
	Ma Wupeng <mawupeng1@huawei.com>,
	Oscar Salvador <osalvador@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0579/1257] mm/hugetlb: fix subpool minimum reservation rollback
Date: Sat,  7 Nov 2026 08:47:55 -0500
Message-ID: <20261107134955.336073808@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinmeng Zhou <jinmengzhou22@gmail.com>

[ Upstream commit e4949a80f3b07e52dca76c34ce353633927a28a5 ]

When a reservation request is partially covered by a subpool minimum and
the remaining global reservation fails, the error path first calls
hugepage_subpool_put_pages() for the subpool-backed portion.  It removes
the failed global portion from used_hpages only afterwards.

hugepage_subpool_put_pages() uses used_hpages to decide whether rsv_hpages
should be restored.  Since used_hpages still includes the global portion,
it can remain at or above min_hpages and prevent that restoration.  It
then reports the subpool reservation as releasable, causing
hugetlb_acct_memory() to incorrectly decrement h->resv_huge_pages.

This was reproduced with four 2 MB huge pages and a hugetlbfs mount with
size=10M,min_size=8M.  After a successful three-page reservation, a
two-page reservation which needed one subpool page and one global page
failed with -ENOMEM.  HugePages_Rsvd incorrectly dropped from four to
three even though the subpool minimum was still four pages.

Roll back the failed global portion from used_hpages first, so that
hugepage_subpool_put_pages() evaluates the minimum reservation against the
current usage and returns the correct global adjustment.

Link: https://lore.kernel.org/20260907132055.26696-1-zhoujinmeng@bytedance.com
Fixes: a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
Signed-off-by: Jinmeng Zhou <zhoujinmeng@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Tested-by: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Ma Wupeng <mawupeng1@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 1c2b5825b5614..8dec4f5fc1e6e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6837,15 +6837,6 @@ long hugetlb_reserve_pages(struct inode *inode,
 
 out_put_pages:
 	spool_resv = chg - gbl_reserve;
-	if (spool_resv) {
-		/* put sub pool's reservation back, chg - gbl_reserve */
-		gbl_resv = hugepage_subpool_put_pages(spool, spool_resv);
-		/*
-		 * subpool's reserved pages can not be put back due to race,
-		 * return to hstate.
-		 */
-		hugetlb_acct_memory(h, -gbl_resv);
-	}
 	/* Restore used_hpages for pages that failed global reservation */
 	if (gbl_reserve && spool) {
 		unsigned long flags;
@@ -6855,6 +6846,15 @@ long hugetlb_reserve_pages(struct inode *inode,
 			spool->used_hpages -= gbl_reserve;
 		unlock_or_release_subpool(spool, flags);
 	}
+	if (spool_resv) {
+		/* put sub pool's reservation back, chg - gbl_reserve */
+		gbl_resv = hugepage_subpool_put_pages(spool, spool_resv);
+		/*
+		 * subpool's reserved pages can not be put back due to race,
+		 * return to hstate.
+		 */
+		hugetlb_acct_memory(h, -gbl_resv);
+	}
 out_uncharge_cgroup:
 	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),
 					    chg * pages_per_huge_page(h), h_cg);
-- 
2.53.0



