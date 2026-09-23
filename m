Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20BE470121;
	Wed, 23 Sep 2026 14:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173666; cv=none; b=bSAbppZxIozjP7TKQ7Zj5hr5vQ9vo91U5vZckAWalMSGWTOrFw1M7pjvL4UZpcJCHjU7vbyQH7+pB5m3Mcbhv9oPylFwuTjzbFx4dsL4u50JstWnYi4lD7gaI2ZFnr+WBPWgk+lGbKeDDz06XpjSHdsDRmUA3SJevx/Qq5YN2Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173666; c=relaxed/simple;
	bh=/KPB5pPtjG5kIy+f5e5YaahUYv3q6YKfwK/wmTxdl9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bd9SFbmf/OS+LbI2o1Luy1U0MmbF9rkmX04H88adIxcmZ/6VzgVusrzjc04vh/Q2W6sTbcFf2HwWXMSXkcfl/J8uIrRFSROL98HK0lpO6uKxZGgA2B3vsKTnSxV6s/rEUbyBbAV2305/T8DKSPiLR6PBHHjzX9f9LVWgLTvVkdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aCdhtLJr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aCdhtLJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CDBE1F000FF;
	Wed, 23 Sep 2026 14:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173665;
	bh=GrRsmntFvVUuadutjr8rWn+jflRGj/WKyZgDFRbE5D0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aCdhtLJrA7E0ZyMSqKPwond6XMnS2RXxHHAm0hmLoQgd4B4NW8MpXly/2UWgTY1gK
	 ldsThpxtSkPuE9crHdikowa+PmBHaH3WP8DTlM5k7ozuFhrpqdjl/zYdU1EBu3HLV9
	 uS3piB7A/vUZi47+lVzQeU7irpkEvnx54FOr4Wos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Dave Chinner <david@fromorbit.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kairui Song <kasong@tencent.com>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 317/438] mm/shrinker: fix bogus set_shrinker_bit() with cgroup.memory=nokmem
Date: Wed, 23 Sep 2026 16:05:38 +0200
Message-ID: <20260923140653.009105876@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

commit 932cfb25e7ce98d1f93895671ec186a3087e4f80 upstream.

With cgroup.memory=nokmem, shrinker_memcg_alloc() bails out early and
never allocates an id, so shrinker->id keeps the 0 it got from the
kzalloc() in shrinker_alloc().  __list_lru_init() then copies that 0 into
lru->shrinker_id, where it looks like a valid bit index.

Nothing calls expand_shrinker_info() on nokmem either, so shrinker_nr_max
stays 0 and every memcg ends up with an empty map (map_nr_max == 0).

deferred_split_folio() hands a real memcg to __list_lru_add() regardless
of whether the lru is memcg aware, so the first THP queued in a cgroup
does set_shrinker_bit(memcg, nid, 0) and trips the bounds check:

WARNING: mm/shrinker.c:212 at set_shrinker_bit+0x7d/0x90, CPU#126
Call Trace:
 <TASK>
 deferred_split_folio+0x18c/0x220
 map_anon_folio_pmd_nopf+0xdd/0x130
 map_anon_folio_pmd_pf+0x14/0xb0
 do_huge_pmd_anonymous_page+0x1a1/0x620
 __handle_mm_fault+0xea9/0x10d0
 handle_mm_fault+0xe5/0x320
 do_user_addr_fault+0x1cc/0x870
 exc_page_fault+0x81/0x1b0
 asm_exc_page_fault+0x27/0x30
 </TASK>

Harmless, the WARN_ON_ONCE() is what keeps the out of bounds unit[] read
from happening, but the id should not look valid in the first place.
Clear it before returning.

Two other spots could paper over this: drop the id in __list_lru_init()
when nokmem turns memcg_aware off, or make deferred_split_folio() pass
NULL like list_lru_add_obj() does.  Both leave shrinker->id lying around
for the next caller, so fix it where the id is handed out.

Link: https://lore.kernel.org/20260902073800.305481-1-jiayuan.chen@linux.dev
Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shrinker.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/shrinker.c b/mm/shrinker.c
index a70aab124a0e..7ec2a9704f6f 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -227,6 +227,8 @@ static int shrinker_memcg_alloc(struct shrinker *shrinker)
 {
 	int id;
 
+	shrinker->id = -1;
+
 	if (mem_cgroup_disabled())
 		return -ENOSYS;
 	if (mem_cgroup_kmem_disabled() && !(shrinker->flags & SHRINKER_NONSLAB))
-- 
2.55.0



