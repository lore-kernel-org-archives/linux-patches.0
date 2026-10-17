Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB2A37BE64;
	Sat, 17 Oct 2026 16:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254834; cv=none; b=pg0F38BgiTwAGAcMDq5mSWpAwM6zH15yQZzUpzFDQdJOXOXf8hHbTbJ0ZEnS76AB4/NH8KlR8HlEulroTVxd3Fw8D2T0bcS/+vy3+uNuBuSj4o1uqrxVQcdmEzuvh10LHM5WvCXrIbBDKzwpvIpvBIW/giutKN38KVMJOAn2Fg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254834; c=relaxed/simple;
	bh=6QCPllqapdmuXOWOFQMWM4ZAaGstrXk2vuW399ntfNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j4RgrUzqVTRWpH002fT3kvNgdoo75BSxUzYjVz9yuxbkrzgkSDut/DT0oxOZSUdMEfJGiTgVU+uZvlIVPZphKT+uPaiJYgc+AIoYQ+WNOxXJST114p52FIL1bMtkvKAQHG6AQQDRTQIS5uTbUu6TqWOYxNqEWGWteSRT2uVFUNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F6CiXRwr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F6CiXRwr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3931F000C4;
	Sat, 17 Oct 2026 16:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254832;
	bh=SyhW9Y8SPrer4b3lJqz2kJ5E+lzEFlGC64iWlADy4zM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F6CiXRwrnAZxsChUy7AA5sBtt9LvN9u3agc0ypFcSa5Pu7vNCBp0WZTzr+O0XFe/R
	 k2r2cwdtwAf247p9jUP3CGiGrVxQBxG9hdx+SLcyHHyfBimADYfIKxtYhNOG1IZr/W
	 qoR/shSdCoutNOxRar3j9Cn0W3ncN0YDSduAMaEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Chris Li <chrisl@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Stevens <stevensd@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kalesh Singh <kaleshsingh@google.com>,
	Leno Hou <lenohou@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	Wei Xu <weixugc@google.com>,
	Yafang <laoar.shao@gmail.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 577/869] mm/mglru: use the common routine for dirty/writeback reactivation
Date: Sat, 17 Oct 2026 17:56:58 +0200
Message-ID: <20261017160051.855111578@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Kairui Song <kasong@tencent.com>

[ Upstream commit 75d4c3f5fb980de1b620adede47e43dff4d6a5f3 ]

Currently MGLRU will move the dirty writeback folios to the second oldest
gen instead of reactivate them like the classical LRU.  This might help to
reduce the LRU contention as it skipped the isolation.  But as a result we
will see these folios at the LRU tail more frequently leading to
inefficient reclaim.

Besides, the dirty / writeback check after isolation in shrink_folio_list
is more accurate and covers more cases.  So instead, just drop the special
handling for dirty writeback, use the common routine and re-activate it
like the classical LRU.

This should in theory improve the scan efficiency.  These folios will be
rotated back to LRU tail once writeback is done so there is no risk of
hotness inversion.  And now each reclaim loop will have a higher success
rate.  This also prepares for unifying the writeback and throttling
mechanism with classical LRU, we keep these folios far from tail so
detecting the tail batch will have a similar pattern with classical LRU.

The micro optimization that avoids LRU contention by skipping the
isolation is gone, which should be fine.  Compared to IO and writeback
cost, the isolation overhead is trivial.

And using the common routine also keeps the folio's referenced bits (tier
bits), which could improve metrics in the long term.  Also no more need to
clean reclaim bit as the common routine will make use of it.

Note the common routine updates a few throttling and writeback counters,
which are not used, and never have been for the MGLRU case.  We will start
making use of these in later commits.

Link: https://lore.kernel.org/20260428-mglru-reclaim-v7-10-02fabb92dc43@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chen Ridong <chenridong@huaweicloud.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Stevens <stevensd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Leno Hou <lenohou@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yafang <laoar.shao@gmail.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: f7e698e326b2 ("mm/mglru: fix and remove redundant unevictable folio handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vmscan.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 460943a562c92..ec19d061232e7 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4313,7 +4313,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 		       int tier_idx)
 {
 	bool success;
-	bool dirty, writeback;
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
@@ -4359,22 +4358,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 		return true;
 	}
 
-	dirty = folio_test_dirty(folio);
-	writeback = folio_test_writeback(folio);
-	if (type == LRU_GEN_FILE && dirty) {
-		sc->nr.file_taken += delta;
-		if (!writeback)
-			sc->nr.unqueued_dirty += delta;
-	}
-
-	/* waiting for writeback */
-	if (folio_test_locked(folio) || writeback ||
-	    (type == LRU_GEN_FILE && dirty)) {
-		gen = folio_inc_gen(lruvec, folio, true);
-		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
-		return true;
-	}
-
 	return false;
 }
 
@@ -4384,7 +4367,7 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
 
 	/* swap constrained */
 	if (!(sc->gfp_mask & __GFP_IO) &&
-	    (folio_test_dirty(folio) ||
+	    ((folio_test_dirty(folio) && !folio_is_file_lru(folio)) ||
 	     (folio_test_anon(folio) && !folio_test_swapcache(folio))))
 		return false;
 
@@ -4403,7 +4386,6 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
 		folio_clear_lru_refs(folio);
 
 	/* for shrink_folio_list() */
-	folio_clear_reclaim(folio);
 	folio_clear_referenced(folio);
 
 	success = lru_gen_del_folio(lruvec, folio, true);
-- 
2.53.0



