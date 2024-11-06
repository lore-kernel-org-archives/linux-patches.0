Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802791EE02D;
	Wed,  6 Nov 2024 12:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897277; cv=none; b=a72Nhq42DgaGyF/LbiMMVKA3kDV7VXTOvuZGMFaiFeSnJxDKPai2xbkzfoHklC6KB4rGw/6e2iWql72aFm5/hXCuQXJ7kjZ473V+UqZxPdWBVgn5uHgMsvLG1rv9pMW0hYQBdV1i/35qcOecb88KKrRxEGIu+KXLvqZMBjhZr78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897277; c=relaxed/simple;
	bh=jYHoGULAqPIkR+ki+HI2vx/cNNsBBUtDy1toYElOSo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NoeYMqdeyXTU0qPnRiMubNz4HOcamLVNfgD+AjHjlhOO1KSW+W9c920S0iUfLwtsGBzDgObuFa6cwFKLt/21iK9BNz2olak63rbPl8CYAQznShJnd2ap2U9nlpgD4Wp6XsI82aOwfxpOZOcUE47S9+LxviWRj6a6w98/VWnnxDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0HCojsqo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0HCojsqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8588DC4CED3;
	Wed,  6 Nov 2024 12:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897277;
	bh=jYHoGULAqPIkR+ki+HI2vx/cNNsBBUtDy1toYElOSo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0HCojsqoGVIJhWS12+nGqvqD3LvNFDm4jmtjsNKj62O3E+neK2P8JpIG8Njvq2jNB
	 RIPjEBNsKZDAps6ctD/o8xjGG93pHPLiK5plkVD2hnNk40Sqbte/lA0WjJ/v/wFVo2
	 kjA0duJ9cdZPPZ7K9Rx9f0hETQwQh29XY4Yu7LEA=
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
Subject: [PATCH 6.1 113/126] vmscan,migrate: fix page count imbalance on node stats when demoting pages
Date: Wed,  6 Nov 2024 13:05:14 +0100
Message-ID: <20241106120309.112808368@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 46a1476e188c3..9ff5d77b61a3e 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1044,7 +1044,7 @@ static void migrate_folio_done(struct folio *src,
 	 * not accounted to NR_ISOLATED_*. They can be recognized
 	 * as __PageMovable
 	 */
-	if (likely(!__folio_test_movable(src)))
+	if (likely(!__folio_test_movable(src)) && reason != MR_DEMOTION)
 		mod_node_page_state(folio_pgdat(src), NR_ISOLATED_ANON +
 				    folio_is_file_lru(src), -folio_nr_pages(src));
 
-- 
2.43.0



