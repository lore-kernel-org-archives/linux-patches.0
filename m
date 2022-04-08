Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69F82C80
	for <patches@lists.linux.dev>; Fri,  8 Apr 2022 20:09:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6C3C385A3;
	Fri,  8 Apr 2022 20:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1649448554;
	bh=CqgdUQ8KtmQ/Yioj4EEH5I++u5nh/s1yL09Oz1Ljgus=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=lurkYQeuelUK9MzaQvPWE59Mc2SYGwBMwF5zstmCGj2AAUTY2zxII0D/2B+TR6M+t
	 zGJp1GhQsY6gZYogUUO5cUbUahD0DTXo1pShk8RZSvHH4Wz7RN/Y/QLrLdxRKyBIG8
	 Cvy8rjaytF8h3A10SHPnJ1U31nUmg3pN3jOf9ZOw=
Date: Fri, 08 Apr 2022 13:09:13 -0700
To: songmuchun@bytedance.com,shakeelb@google.com,roman.gushchin@linux.dev,mhocko@suse.com,longman@redhat.com,hannes@cmpxchg.org,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220408130819.a89195e527ce58dfbe0700b9@linux-foundation.org>
Subject: [patch 8/9] mm/list_lru.c: revert "mm/list_lru: optimize memcg_reparent_list_lru_node()"
Message-Id: <20220408200914.7C6C3C385A3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/list_lru.c: revert "mm/list_lru: optimize memcg_reparent_list_lru_node()"

405cc51fc1049c73 ("mm/list_lru: optimize memcg_reparent_list_lru_node()")
has subtle races which are proving ugly to fix.  Revert the original
optimization.  If quantitative testing indicates that we have a
significant problem here then other implementations can be looked at.

Fixes: 405cc51fc1049c73 ("mm/list_lru: optimize memcg_reparent_list_lru_node()")
Acked-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/list_lru.c~mm-list_lruc-revert-mm-list_lru-optimize-memcg_reparent_list_lru_node
+++ a/mm/list_lru.c
@@ -395,12 +395,6 @@ static void memcg_reparent_list_lru_node
 	struct list_lru_one *src, *dst;
 
 	/*
-	 * If there is no lru entry in this nlru, we can skip it immediately.
-	 */
-	if (!READ_ONCE(nlru->nr_items))
-		return;
-
-	/*
 	 * Since list_lru_{add,del} may be called under an IRQ-safe lock,
 	 * we have to use IRQ-safe primitives here to avoid deadlock.
 	 */
_
