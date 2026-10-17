Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A4837701A;
	Sat, 17 Oct 2026 17:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259785; cv=none; b=K53G2csLGD4ysW/J6SDL52Nww4igF/puG+e0xGNL+JTinXYGTj+uWN5p66BJpcw1KmKoWoMZ2HE+JG7cx24p/bPmclzXh/6vRSJOd/2WZB4rwigRsg8nDdryviNJYCEJqJ6GbRrZLYtDP1sSxwtYMBUFvtoPVMIX1P+c72n1jY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259785; c=relaxed/simple;
	bh=G8BJgXnlQK6UqS2dc49yp5DzuVpt/xILsvt2M/nZGhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EdRplDySSy9HYdU4JI2eUEd1P/esB+hnvIp4q/1bu8ZLgESb59e9yaLfgPCd7AVFznKyh2qtSaSmCRCJA54ty6zEl0hRtBGSHKBIJiszHo8XnEdlPSiEpXhpeKUPubvGqNYmfdRX/p5D+mxEOxOybC9BO33MLp9qhV/z3onVShU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zdbNXXVx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zdbNXXVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304271F000C4;
	Sat, 17 Oct 2026 17:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259783;
	bh=EHk4/MtoCQcYhCYL7mtDl5PcBZcaPA2+LVHzBaLkyEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zdbNXXVxWxZZku2o1ZreIwiuZXg2Ma99BlH5eJ2FGoUVPa5BpXG8EUIcMrSm769at
	 V93pezcBc0g/UMNfmbvxpo5i/Sm50hEW4ngQbwOoVwZUIIqdpBM13IMYNW8s/2cW6u
	 Hj18dqIzWzCDPlsFdKRoDrhJXmfUudUfRaFRV50Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arvind Yadav <arvind.yadav@intel.com>,
	Zi Yan <ziy@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1330/1674] mm/migrate_device: clear stale mapping after freeing swapcache
Date: Sat, 17 Oct 2026 18:00:02 +0200
Message-ID: <20261017160505.284928579@linuxfoundation.org>
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

From: Arvind Yadav <arvind.yadav@intel.com>

[ Upstream commit 34a00895d032a414830d41106a09329ae6c251b6 ]

__migrate_device_pages() reads the folio mapping before calling
folio_free_swap().  When folio_free_swap() succeeds, the folio is removed
from the swap cache, but the saved mapping still points to swap_space.

Passing the stale mapping to folio_migrate_mapping() makes it use the
mapped-folio path for a folio that is no longer in swapcache.  It can then
operate on swap_space.i_pages with invalid reference accounting,
eventually triggering a folio reference count BUG.

After a successful split, nr still contains the number of pages in the
original large folio, although each resulting page is now a separate
order-0 folio.  Reset nr to 1 so each split folio is processed separately,
including its own swapcache removal and mapping lookup.

Refresh the saved mapping after folio_free_swap() so the current folio
state is used during migration.

Link: https://lore.kernel.org/20260728062832.1107127-1-arvind.yadav@intel.com
Fixes: df263d9a7dff ("mm/migrate_device: try to handle swapcache pages")
Signed-off-by: Arvind Yadav <arvind.yadav@intel.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/migrate_device.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index d4ee7ab735a38..1ec278a529b40 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -745,6 +745,12 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 					src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
 					continue;
 				}
+
+				/*
+				 * folio_free_swap() removed the folio from the swap
+				 * cache. Refresh the saved mapping before migration.
+				 */
+				mapping = folio_mapping(folio);
 			}
 		} else if (is_zone_device_page(newpage)) {
 			/*
-- 
2.53.0



