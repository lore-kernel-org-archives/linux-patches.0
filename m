Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66EDC547050;
	Thu, 17 Sep 2026 18:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671508; cv=none; b=Pux3eWQ6MQy9PFPc5Ez5xqF2/F/DUqKWKkJ1KRpyxwTiYsx23QeZ9r/wsNX065psyRiJX1jkPlyqqEpD18+s20BydrcEi5aHmKVA0RTDEcrJBk8+ZSrZ05bKzHjgQOXjVLsYhSB1RcPjSkuF9XKBMjs5o7Sk3DIneZKOmLFDpNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671508; c=relaxed/simple;
	bh=DZX98xfhbdznq8zTYBLxVsvKsEsv0yTlKE9IoDDO9QM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PAr9xXZiPQ5rK8zh4/jYMqElSFLnV/LNlURk2CyqTtpxDm57qkFEuJARETkRgSYVL/8ZigQStv9RzujLglUHz/JTkXakihsvPyEbTmfYtnmc3BrSoIWEbC2FFROYtdGnfVrPJ8Tw2bQvtXJcGjQaLpWxQo98SsftEIYEY5ADGf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=023FqGsv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="023FqGsv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B51C1F000FF;
	Thu, 17 Sep 2026 18:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671507;
	bh=Uc6A7hFuuum651yWOv9ctZWF42O4RuB6rM/8xPyvQeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=023FqGsvGj0jNix0l+NQJ/NKMA9Vn0ZyrEM6mrXb8VFYZJBfFQT9rZsR6rU+RbSWJ
	 zWsrtkFnO3FBNoT166NbKOVygIouFBxdmG3HJY3y7ryv76x0FW4rSxIcktoIZU0jvp
	 VbYT6IBtNV33Ik2rLjX7Djw5jkq+yerlHLsFfoTA=
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
Subject: [PATCH 6.12 0998/1102] mm/migrate_device: clear stale mapping after freeing swapcache
Date: Thu, 17 Sep 2026 16:15:41 +0100
Message-ID: <20260917151605.783099607@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ refreshed folio_mapping() after folio_free_swap() instead of resetting the not-yet-present THP-split nr/batching loop ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/migrate_device.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -746,6 +746,12 @@ static void __migrate_device_pages(unsig
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
 		} else if (folio_is_zone_device(newfolio)) {
 			/*


