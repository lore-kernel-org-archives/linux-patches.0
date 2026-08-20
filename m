Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FF1471D0B;
	Thu, 20 Aug 2026 17:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247597; cv=none; b=oAzzBDtBu5naneUUhM8bP0zBPLfx/Zqcxl0ZUVZxp4xsvNQjdWb+Hsh2eS/C101op/3Kmu3nsSC8XVx1HDgGkvQ5J2xDG8d9Ho8nlDwr2I3yb11A+VoXN8k2imEmdjpFuJa6yxRj15e+ZsBIrt8NHNv0lk2wqN2GEGhxsqAKdKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247597; c=relaxed/simple;
	bh=FGD6iMAgc/3buXOlk00eFL3XDvJV6DzqWVb6KVHENwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qiWevg2drZdHWWBh/QM0ryBiywt7ozkmmqZLZRnfd6nq2csUxw3kGl5Nk7FRqtxsRrIh2lB4AS+KlxPVcGRnECVCD6ZAf0TmCp+YvYMEQNCuvtk3BlUcTuxGYjiafnCZEVvIWD35fE/avkHWHipEJ1RZdxulB/1MN7xT6zhUY3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q0jdAGg1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q0jdAGg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE781F000E9;
	Thu, 20 Aug 2026 17:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247595;
	bh=ta5DP9ZqmNrld5ZjqrfIISs+Lasr00gEsGk5IBl2S+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q0jdAGg1pV5w6ewX5UGY+NEj2Iv9ykSUynkei4Ea+/Eejbc3OfliHG3GpKVKX+4oS
	 6YQSp2b7eahsqmI3JarkVvBM0GBm0ghpMWSHjYJ11S/yIii45Mlgot8qra3zjDb77p
	 C6mt8MUXWpVNSv8ewZSC16EMFm6f1rXlMe9yi3W4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 101/166] mm: migrate_device: fix pte_pfn/pte_dirty called on non-present PTE
Date: Thu, 20 Aug 2026 16:56:00 +0200
Message-ID: <20260820145214.197614122@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

From: Kefeng Wang <wangkefeng.wang@huawei.com>

[ Upstream commit 63867c82d0c0c2d182016a32b1cc0103116b0ea5 ]

pte_pfn() and pte_dirty() have undefined behaviour when called on a
non-present PTE. In migrate_vma_collect_pmd(), these functions may be
invoked on non-present entries (e.g., device-private entries), leading
to potential crashes from pte_pfn() or incorrect dirty folio accounting
from pte_dirty(). Fix both by guarding with pte_present() checks.

Link: https://lore.kernel.org/20260708003955.4024340-1-wangkefeng.wang@huawei.com
Link: https://lore.kernel.org/20260706111958.3649651-1-wangkefeng.wang@huawei.com
Fixes: fd35ca3d12cc ("mm/migrate_device.c: copy pte dirty bit to page")
Fixes: 6c287605fd56 ("mm: remember exclusively mapped anonymous pages with PG_anon_exclusive")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ adapted `folio_test_anon(folio)`/`folio_mark_dirty(folio)` context lines to 6.6's `PageAnon(page)`/`folio_mark_dirty(page_folio(page))` spelling since the `folio` local doesn't exist ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/migrate_device.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -194,7 +194,8 @@ again:
 			bool anon_exclusive;
 			pte_t swp_pte;
 
-			flush_cache_page(vma, addr, pte_pfn(pte));
+			if (pte_present(pte))
+				flush_cache_page(vma, addr, pte_pfn(pte));
 			anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
 			if (anon_exclusive) {
 				pte = ptep_clear_flush(vma, addr, ptep);
@@ -213,7 +214,7 @@ again:
 			migrate->cpages++;
 
 			/* Set the dirty flag on the folio now the pte is gone. */
-			if (pte_dirty(pte))
+			if (pte_present(pte) && pte_dirty(pte))
 				folio_mark_dirty(page_folio(page));
 
 			/* Setup special migration page table entry */


