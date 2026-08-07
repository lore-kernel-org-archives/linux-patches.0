Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69654756BB;
	Fri,  7 Aug 2026 15:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117272; cv=none; b=N4hHBZcMkw/GVHqrATBUS02zb597tXKyiibH1Ez8G/QzdLDIkH/ouLdKQ/DBswc057twmDsVlgdJNk2XxhDmJwxcZ+9fIFLBYNd25R/3LA1qUMAjcGxWFu0ZHJV+men3c6QpoLyHWeejK2reGTwt37XxsHuRixmgYoBcfEDWqDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117272; c=relaxed/simple;
	bh=6z2+PSTj4mJ7TNMqPaE6cyYdGubEyqaqrT5b+mGS/Sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GuWySvzCoJfgjgj52K7OYv/0WOuyRmRNJJbM+n8YvRipPqZrN8qyYcuP+4eSwqEFlLfZIInw4Mt4nyTDxNhrKWjYL4ZBXNk0PzqZg6m7KEI/TVoG2wwN9+0RPgGo+96kidr9rYY9wnhOUMpqSJsehKCZXHQgO2QMCY7Lgz2HL64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2sJHF9fs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2sJHF9fs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198E21F000E9;
	Fri,  7 Aug 2026 15:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117270;
	bh=8SVkg4/zMP/nB1YbUtRctycR2qql70X/XQvdOFfABFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2sJHF9fsI0L5EqunQZ2eBd/StBIUmtg6zsT3ZH5agm6fg6sgcsqwq1p7zqJypSEJx
	 JrAIvp/dx77CViMUCua8fErO0gZnwD+LVpsQTv/G5es5aR7vAejEg0x2YubZvJm1l+
	 v3xk/LcX+u+sW9urvRMrY1R+T8obIikcFCV3ycd4=
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
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 215/438] mm: migrate_device: fix pte_pfn/pte_dirty called on non-present PTE
Date: Fri,  7 Aug 2026 16:36:51 +0200
Message-ID: <20260807143432.594062189@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Kefeng Wang <wangkefeng.wang@huawei.com>

commit 63867c82d0c0c2d182016a32b1cc0103116b0ea5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/migrate_device.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -401,7 +401,8 @@ again:
 			bool anon_exclusive;
 			pte_t swp_pte;
 
-			flush_cache_page(vma, addr, pte_pfn(pte));
+			if (pte_present(pte))
+				flush_cache_page(vma, addr, pte_pfn(pte));
 			anon_exclusive = folio_test_anon(folio) &&
 					  PageAnonExclusive(page);
 			if (anon_exclusive) {
@@ -422,7 +423,7 @@ again:
 			migrate->cpages++;
 
 			/* Set the dirty flag on the folio now the pte is gone. */
-			if (pte_dirty(pte))
+			if (pte_present(pte) && pte_dirty(pte))
 				folio_mark_dirty(folio);
 
 			/* Setup special migration page table entry */


