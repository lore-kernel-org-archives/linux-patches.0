Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D55839CD12;
	Sat, 12 Sep 2026 07:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196706; cv=none; b=StUydt7ie9InsxMyFKFPE4N/KT1T5dRdmH35yNA0oJ2BfgOSoTNw9pkFItNwkZKhmZmNINbXy8MnXXvTjZe1ICyRA+tNU+DyCZcxgNs38XNDlyGM9zmuwdmcMcSDKAJMkETcFkwK1aBnSwaLE6wnNOXCvbDhiefnrxHUGvXoa/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196706; c=relaxed/simple;
	bh=cdVDBU179/Zo0/XrLbnZRrkslm70NDkfJGDMhHkbtok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hh7xi0JtbPhCuwBk517jUYSInEUeicFbuZnmbu8YsH9eWqe+Ra0v5aJE2sI9YKl1nR3RHJF0lkgQ8HSko1PXAYPFcqTRfH7uKGLtDxyG39+wzmxaYWbPQebZ5SQfXOzbLTTNR+2vksQnO2hfTkRVDo1HaJgH3qv2/1eAsR+ETEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n2SsyVPT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n2SsyVPT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B2B1F000FF;
	Sat, 12 Sep 2026 07:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196704;
	bh=EDKIncCnU298S6e166po7WjeFJpZxVORcBT0kYT5PKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n2SsyVPTptMoDAXk8225CD6ydeUPx49R2GZwVuPfsro9rI3Gk0fAaII4qUBhrA3Lk
	 d/in3HmNg5EI8yIcpqI8ZOohxLQ46hMG2FZc6jah7c1jwmjrgzWUmv5g+lZ/j+uH5m
	 kDvwvM6HDL45b6SHk2GSC5nFHIyj2IP8mgtjPLb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0020/1815] memcg: move LRU size accounting on reparenting instead of copying it
Date: Sat, 12 Sep 2026 08:29:30 +0200
Message-ID: <20260912065649.481798081@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Shakeel Butt <shakeel.butt@linux.dev>

[ Upstream commit 0e0ac326c511d514817cc7b6d7741afd59098ce2 ]

When a memory cgroup is offlined its LRU folios are reparented to the
parent.  lruvec_reparent_lru() splices the child's lists into the
parent's and credits the parent with the child's per-zone
lru_zone_size[], but never clears the child's copy, so the size is
copied rather than moved.  lru_gen_reparent_memcg() does the same for
MGLRU.

The parent is left correct, credited with exactly the folios it took
over.  The stale value sits on the child and nothing will correct it:
folio->memcg_data now resolves to the parent, so every later
update_lru_size() for those folios goes there.

Dying cgroups are not freed immediately and mem_cgroup_iter() still
walks them, so shrink_lruvec() keeps being called on them.
get_scan_count() reads the phantom counter through lruvec_lru_size() and
the scan loop then grinds through nr[] in SWAP_CLUSTER_MAX steps against
an empty list, for as long as the dead cgroup lives.  Under MGLRU the
MGLRU scanner runs instead, but count_shadow_nodes() sums all of
NR_LRU_LISTS through lruvec_lru_size() and over-budgets the shadow node
limit just the same.

On one 251 GiB host a sweep of every mz->lru_zone_size[] found 380
counters describing folios on no list at all: 124777314 pages, 476 GiB,
1.89x the machine's RAM, across 57 cgroups.  All were on memcgs with
CSS_DYING set and CSS_ONLINE clear, and parent/child pairs reported
byte-identical sizes.

LRU_UNEVICTABLE needs its size moved too.  Its list is deliberately not
spliced because lruvec_init() poisons the head - the unevictable LRU is
imaginary and folios are never threaded on it - but the size is kept by
lruvec_add_folio()/lruvec_del_folio() and those folios account to the
parent from here on.

This depends on commit bf4ade7dbd76 ("memcg: keep folio's objcg same as
its node") and must not be backported ahead of it.  Without that
invariant a folio's objcg can belong to another node, so a folio already
spliced onto the parent's list can still resolve to the child's lruvec
until the objcg's node is reparented in a later iteration of
memcg_reparent_objcgs(); clearing the child's counter early then lets
lruvec_del_folio() underflow it and trip the WARN_ONCE()/VM_BUG_ON() in
mem_cgroup_update_lru_size().

Link: https://lore.kernel.org/20260822024707.77192-1-shakeel.butt@linux.dev
Fixes: 07a6e9a2c199 ("mm: vmscan: prepare for reparenting traditional LRU folios")
Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org> # After: bf4ade7dbd76: memcg: keep folio's objcg same as its node
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/swap.c   |    9 +++++++++
 mm/vmscan.c |    5 +++++
 2 files changed, 14 insertions(+)

--- a/mm/swap.c
+++ b/mm/swap.c
@@ -1153,7 +1153,16 @@ static void lruvec_reparent_lru(struct l
 	for_each_managed_zone_pgdat(zone, NODE_DATA(nid), zid, MAX_NR_ZONES - 1) {
 		unsigned long size = mem_cgroup_get_zone_lru_size(child_lruvec, lru, zid);
 
+		if (!size)
+			continue;
+
+		/*
+		 * The folios are accounted to the parent from now on, so the
+		 * size has to be moved, not just copied. Leaving it behind
+		 * makes the dying child describe folios it no longer owns.
+		 */
 		mem_cgroup_update_lru_size(parent_lruvec, lru, zid, size);
+		mem_cgroup_update_lru_size(child_lruvec, lru, zid, -(long)size);
 	}
 }
 
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4554,7 +4554,12 @@ void lru_gen_reparent_memcg(struct mem_c
 		for_each_managed_zone_pgdat(zone, NODE_DATA(nid), zid, MAX_NR_ZONES - 1) {
 			unsigned long size = mem_cgroup_get_zone_lru_size(child_lruvec, lru, zid);
 
+			if (!size)
+				continue;
+
+			/* Move the accounting, do not duplicate it. */
 			mem_cgroup_update_lru_size(parent_lruvec, lru, zid, size);
+			mem_cgroup_update_lru_size(child_lruvec, lru, zid, -(long)size);
 		}
 	}
 }


