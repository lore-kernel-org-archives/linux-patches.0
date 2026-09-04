Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762163876B3;
	Fri,  4 Sep 2026 05:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498462; cv=none; b=SKT7R0jqOquHkd4YkV577cts1k5Luoxhno67zZn1yrrHtiH+OLbiR9etBSZxaPJRkQG5EwLQpsu/bskgR/slDch18NFG/GNoq2PZK95kMyFNteYwroXzakL6Q0EkesLtwq9ZjMyiEJDvky7a4ImTU7m8Sam1kaf2DampAyDWah8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498462; c=relaxed/simple;
	bh=VSzkc4QnhPkDReUVuMWFdUVUFVFQgtrzs6zGxlS6vD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T3FGaP4V/aBxH6MGagnRr8zVfC6DnQswV1K2/TOCjGbWTWmQQXXvwRZb02P0YvI0nQVK/ZCAK5Ci2DFZlA8yxIZ9XU5pUy6HNq2uaVXXBGlDUMt3leXVVFqu15EhpHDHKex/BGlkh4EgiYW7oh8pbrg9YmUg59RE75yRtJML43k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j0etVodc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j0etVodc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD05A1F00A3D;
	Fri,  4 Sep 2026 05:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498461;
	bh=POJDGjeUxn3XteK3lMJsAat/v/JqJxJKEhjEPlxPK6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j0etVodcArsOos3v315WZx+IRcQD53vt080WrjW9kj2xdWzvOTLQOaSdxtOtNcmVo
	 YM3uNUkST1StSjPyok6Z+KSCqYnc2cagmNfocZ0Nu/dK/E1naf3Og4C8rcIfhdLizy
	 Q32ITHDMrB1DYAPs3G+pVPkeYkI3SAFRE0lc5niI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Jia <jiahao1@lixiang.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 070/713] mm/zswap: fix global shrinker when memory cgroup is disabled
Date: Fri,  4 Sep 2026 06:50:38 +0200
Message-ID: <20260904045805.408285247@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Jia <jiahao1@lixiang.com>

commit dc8458f43fe964d8ade74c9b0fce54fe71d156de upstream.

Patch series "mm/zswap: Fixes and improves the zswap shrink", v4.

This series fixes and improves the zswap global shrinker
(shrink_worker()): Patch 1: Fix missing global shrinker when memory cgroup
is disabled.  Patch 2: Extend shrink_memcg() to support batch writeback
and thereby improving the writeback efficiency in the shrink_worker() and
zswap_store() paths.


This patch (of 2):

Zswap writeback when the global pool limit is hit fails when memory cgroup
is disabled.  The pool remains full until it is organically drained by
swapins or memory freeing, leading to zswap store failures and pages
bypassing getting written directly to the backing swap device, causing LRU
inversion (hotter pages with higher fault latency).

This happens because mem_cgroup_iter() always returns NULL when memory
cgroups are disabled.  As a result, the global shrinker shrink_worker()
repeatedly takes empty walks.  After MAX_RECLAIM_RETRIES failed attempts,
the worker gives up without writing back any pages.

Therefore, when memory cgroup is disabled, fall through with the !memcg
branch and shrink the root memcg directly.

With memcg disabled, shrink_memcg() only returns -ENOENT when the root LRU
is empty, which means the total pages are already below thr.  In the
absence of heavy concurrent zswap stores, the loop then safely bails out
via the zswap_total_pages() <= thr check; otherwise, it will resume
shrinking the memcg after processing the reschedule check.  For any other
return value from shrink_memcg(), the loop is guaranteed to terminate,
either after MAX_RECLAIM_RETRIES failures or once the threshold is met.

This is a potential performance regression for people using zswap
without memcg that was introduced by the commit in "Fixes".

Link: https://lore.kernel.org/20260806070943.95542-1-jiahao.kernel@gmail.com
Link: https://lore.kernel.org/20260806070943.95542-2-jiahao.kernel@gmail.com
Fixes: a65b0e7607cc ("zswap: make shrinking memcg-aware")
Signed-off-by: Hao Jia <jiahao1@lixiang.com>
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Reported-by: Yosry Ahmed <yosry@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/zswap.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1356,11 +1356,12 @@ static void shrink_worker(struct work_st
 		} while (memcg && !mem_cgroup_tryget_online(memcg));
 		spin_unlock(&zswap_shrink_lock);
 
-		if (!memcg) {
-			/*
-			 * Continue shrinking without incrementing failures if
-			 * we found candidate memcgs in the last tree walk.
-			 */
+		/*
+		 * A NULL memcg ends a full hierarchy pass (except when memcg is
+		 * disabled, where it is always NULL: fall through to the root LRU).
+		 * Count a failure only if the last pass found no candidates.
+		 */
+		if (!memcg && !mem_cgroup_disabled()) {
 			if (!attempts && ++failures == MAX_RECLAIM_RETRIES)
 				break;
 
@@ -1379,7 +1380,7 @@ static void shrink_worker(struct work_st
 		 * and failures.
 		 */
 		if (ret == -ENOENT)
-			continue;
+			goto resched;
 		++attempts;
 
 		if (ret && ++failures == MAX_RECLAIM_RETRIES)


