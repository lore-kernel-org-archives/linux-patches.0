Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C32199FAB;
	Mon, 23 Mar 2026 13:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273793; cv=none; b=oip1GFKhRQjiJWa5VaullkbLWeQyQr2q6oqwfUS/Xtx1S3iE5Ie6Ceeois+FILftq9JzxO5xMWm7IqwFlmwXFR1O9yus++KWYn4S3DlZH4VTs34xVOGrxF+auFxw/dVX2UsDfpDbhQ48hnPjvfmS0+LTZ6U3erVHhmk0RRWNDec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273793; c=relaxed/simple;
	bh=eG8v+v94y11ftNPYiTYPIy1Gq7J1KgH8yKnUAOcEWaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0vRMlbttcjnuiF7OTsYnJKV6EoXBaMzqTuGdH+DM9av5qdpMT+DIfqnPhkN2Tyv3LFcoyvmn41X2/zssVJmnYxeZpJSIIPg3G7LSXBKwHRkMAn1/fSQLoZPt/R2+Zt66LPOwQFzWYjWZfab8/AijXr0Dr9FRM3NYDaHSb3tca8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RIkK/God; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RIkK/God"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC729C2BCB1;
	Mon, 23 Mar 2026 13:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774273793;
	bh=eG8v+v94y11ftNPYiTYPIy1Gq7J1KgH8yKnUAOcEWaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RIkK/God/7pEvfHsfpGxaJ2JHUcbQW5N7TMDI9IY8kM1TLCI9uKsoxyB8wopl9Hjv
	 SlnXjxZb2f+NfU/b3huC/9a2q3bKe8k9eLoukze72rFKXfXm10v8eyQDLPpkiba6OZ
	 56cvZnmCUTCTpWCIEYQ7RoTfKYBtY/nz8DKKkMTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Zi Yan <ziy@nvidia.com>,
	Lance Yang <lance.yang@linux.dev>,
	Gavin Guo <gavinguo@igalia.com>,
	"David Hildenbrand (arm)" <david@kernel.org>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.19 011/220] mm/huge_memory: fix early failure try_to_migrate() when split huge pmd for shared THP
Date: Mon, 23 Mar 2026 14:43:08 +0100
Message-ID: <20260323134504.937875443@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yang <richard.weiyang@gmail.com>

commit 939080834fef3ce42fdbcfef33fd29c9ffe5bbed upstream.

Commit 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and
split_huge_pmd_locked()") return false unconditionally after
split_huge_pmd_locked().  This may fail try_to_migrate() early when
TTU_SPLIT_HUGE_PMD is specified.

The reason is the above commit adjusted try_to_migrate_one() to, when a
PMD-mapped THP entry is found, and TTU_SPLIT_HUGE_PMD is specified (for
example, via unmap_folio()), return false unconditionally.  This breaks
the rmap walk and fail try_to_migrate() early, if this PMD-mapped THP is
mapped in multiple processes.

The user sensible impact of this bug could be:

  * On memory pressure, shrink_folio_list() may split partially mapped
    folio with split_folio_to_list(). Then free unmapped pages without IO.
    If failed, it may not be reclaimed.
  * On memory failure, memory_failure() would call try_to_split_thp_page()
    to split folio contains the bad page. If succeed, the PG_has_hwpoisoned
    bit is only set in the after-split folio contains @split_at. By doing
    so, we limit bad memory. If failed to split, the whole folios is not
    usable.

One way to reproduce:

    Create an anonymous THP range and fork 512 children, so we have a
    THP shared mapped in 513 processes. Then trigger folio split with
    /sys/kernel/debug/split_huge_pages debugfs to split the THP folio to
    order 0.

Without the above commit, we can successfully split to order 0.  With the
above commit, the folio is still a large folio.

And currently there are two core users of TTU_SPLIT_HUGE_PMD:

  * try_to_unmap_one()
  * try_to_migrate_one()

try_to_unmap_one() would restart the rmap walk, so only
try_to_migrate_one() is affected.

We can't simply revert commit 60fbb14396d5 ("mm/huge_memory: adjust
try_to_migrate_one() and split_huge_pmd_locked()"), since it removed some
duplicated check covered by page_vma_mapped_walk().

This patch fixes this by restart page_vma_mapped_walk() after
split_huge_pmd_locked().  Since we cannot simply return "true" to fix the
problem, as that would affect another case:

    When invoking folio_try_share_anon_rmap_pmd() from
    split_huge_pmd_locked(), the latter can fail and leave a large folio
    mapped through PTEs, in which case we ought to return true from
    try_to_migrate_one(). This might result in unnecessary walking of the
    rmap but is relatively harmless.

Link: https://lkml.kernel.org/r/20260305015006.27343-1-richard.weiyang@gmail.com
Fixes: 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and split_huge_pmd_locked()")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Gavin Guo <gavinguo@igalia.com>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/rmap.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2338,11 +2338,17 @@ static bool try_to_migrate_one(struct fo
 			__maybe_unused pmd_t pmdval;
 
 			if (flags & TTU_SPLIT_HUGE_PMD) {
+				/*
+				 * split_huge_pmd_locked() might leave the
+				 * folio mapped through PTEs. Retry the walk
+				 * so we can detect this scenario and properly
+				 * abort the walk.
+				 */
 				split_huge_pmd_locked(vma, pvmw.address,
 						      pvmw.pmd, true);
-				ret = false;
-				page_vma_mapped_walk_done(&pvmw);
-				break;
+				flags &= ~TTU_SPLIT_HUGE_PMD;
+				page_vma_mapped_walk_restart(&pvmw);
+				continue;
 			}
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
 			pmdval = pmdp_get(pvmw.pmd);


