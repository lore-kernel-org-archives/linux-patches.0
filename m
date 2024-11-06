Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1FC1F4298;
	Wed,  6 Nov 2024 12:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897688; cv=none; b=UD6KzvzNW6D+i7dffTtnYVUXAm6saqjaN/0wd//N+F8i1iJOS/aGMgpA1nmuhdKXqz8JqqDnPejHzbaQxk3OLNOGq7PxD/XogV+qsQRmtV2diiFiGmatEtED//47gG6mvTjqT53lD0mBa7p421wo/Eb72swA7Ln6fXT2sqItZ0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897688; c=relaxed/simple;
	bh=Suj+vDmIvCRWbzP3z4IGtwoVZF2qvG8wZBj4JEAJoBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQBPUqWTgckkoCLVl2OL+A68DORPLZkDJMG2XCK73tY3iQdQ7Grmr7lLVsvLFNzdfalCTFEsJcJZhtX6vvjx9JHzHZMECQl173nY4xunG+klWDLEUL4rAkKLJgGBqIxKI+9aeR6/+6uOeJsvhpM1y9ZevV/0giN+UBJIO/72Ofo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bjkCnrKQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bjkCnrKQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2FDC4CECD;
	Wed,  6 Nov 2024 12:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897687;
	bh=Suj+vDmIvCRWbzP3z4IGtwoVZF2qvG8wZBj4JEAJoBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bjkCnrKQxdyGSouLerc26JlmeUrkLxMGA1gvn7makHW+Mr3KTZ9SdFaEWr1MQIu3J
	 NIWBSPHc9mPfAAXwJeepRDyzVd9Vuq2rfjeqeDhG4UglhitwiJtwYXzGWCUCE6gtUI
	 JkqMkfDAPvhxml4r7t60H3CFVXhJrf2SZYdwmd/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory Price <gourry@gourry.net>,
	Yang Shi <shy828301@gmail.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	"Huang, Ying" <ying.huang@intel.com>,
	Oscar Salvador <osalvador@suse.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Wei Xu <weixugc@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 137/151] vmscan,migrate: fix page count imbalance on node stats when demoting pages
Date: Wed,  6 Nov 2024 13:05:25 +0100
Message-ID: <20241106120312.624778396@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Gregory Price <gourry@gourry.net>

[ Upstream commit 35e41024c4c2b02ef8207f61b9004f6956cf037b ]

When numa balancing is enabled with demotion, vmscan will call
migrate_pages when shrinking LRUs.  migrate_pages will decrement the
the node's isolated page count, leading to an imbalanced count when
invoked from (MG)LRU code.

The result is dmesg output like such:

$ cat /proc/sys/vm/stat_refresh

[77383.088417] vmstat_refresh: nr_isolated_anon -103212
[77383.088417] vmstat_refresh: nr_isolated_file -899642

This negative value may impact compaction and reclaim throttling.

The following path produces the decrement:

shrink_folio_list
  demote_folio_list
    migrate_pages
      migrate_pages_batch
        migrate_folio_move
          migrate_folio_done
            mod_node_page_state(-ve) <- decrement

This path happens for SUCCESSFUL migrations, not failures.  Typically
callers to migrate_pages are required to handle putback/accounting for
failures, but this is already handled in the shrink code.

When accounting for migrations, instead do not decrement the count when
the migration reason is MR_DEMOTION.  As of v6.11, this demotion logic
is the only source of MR_DEMOTION.

Link: https://lkml.kernel.org/r/20241025141724.17927-1-gourry@gourry.net
Fixes: 26aa2d199d6f ("mm/migrate: demote pages during reclaim")
Signed-off-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Wei Xu <weixugc@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/migrate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 5d7d39b1c0699..c5ed8caf6a406 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1093,7 +1093,7 @@ static void migrate_folio_done(struct folio *src,
 	 * not accounted to NR_ISOLATED_*. They can be recognized
 	 * as __PageMovable
 	 */
-	if (likely(!__folio_test_movable(src)))
+	if (likely(!__folio_test_movable(src)) && reason != MR_DEMOTION)
 		mod_node_page_state(folio_pgdat(src), NR_ISOLATED_ANON +
 				    folio_is_file_lru(src), -folio_nr_pages(src));
 
-- 
2.43.0



