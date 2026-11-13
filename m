Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590649;
	b=xsg8XmngmZuOHLhRKG6i6HqQJ8q+biiZcXLrCKp0rKhatMaDP4u6lTuxXigiayQXQw7J
	 Jj2Y6nDzIF8Hnzc6yhT6idXNF1ZgGnxVwjYPOeiLl2xWORxMhn13Avt7r8KheCUkmjQBl
	 s0X6PLldOcnBj3OHJrRKR1MTTO0N+XQPfFs0TfWamd8DpFVyHVJGxVD6nv4+rMOJqcI3S
	 X4XXoyV04hMV2n6uIrzzl2HxpmSPleoiKiiXdmz46xSLmjgJqSe9gvZLiH126k6vfeh0H
	 1vJ/f9KF3mTCGYBpw8zpp9ip3wbXLNF2mr2Gt4/2zZvCq0UwWh8+tzy88wZJPsxuFJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yOwdAO/V2eJcb8ReB284vt2L/rhX/iWEPC+ujSKr5gM=;
	b=nAAia2tSxOJqIyq1pRvXzHyp6mYuFcKSSggRfuhW7HDMpsodTutyTn03878pa6Be5Qog
	 S8kzfXXOkMiU+HYXh7wfyVWs9gjsK1/A/t5ESFgKA3EEalNZM3adskIQ/7SG3qPP98jT9
	 1xNTbwbJ5xxM9ffdj6k8rOiKIU6mWTNceRM3rQmZmXlD+duLM78GtD/hw1C5xTdCSnnfX
	 NBWXccSeumcVea7MzZ3PT67KWcUTrUqthfOM/E3K1kV89bPs4cd+nmbj4329dRIvBDnhk
	 S7FwQkC9BBL11KgJ3VpqzXZ8CP4EGnsCkWkVdZ7LhywwrG2wObRfDkjjL30FE3mTf/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MhytC3Nl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F6B606B202;
	Fri, 13 Nov 2026 17:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MhytC3Nl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB4F1F000C4;
	Fri, 13 Nov 2026 17:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590649;
	bh=yOwdAO/V2eJcb8ReB284vt2L/rhX/iWEPC+ujSKr5gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MhytC3NlbGEfT8qYa4FHLNIG2So+7CVxwKhxFwoputMijLjNi87zJ4iq0pVl03NeU
	 5DcWALQfFf1wuXv3kfRpxq95kqpLOIh0R9+YSCfEgxjrYLVphj50vLjkGSIvkPhiPl
	 vtvqBwM2qRZwDb71ul0xXkk/z6aDY5iNuzekCE6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridong Chen <chenridong@xiaomi.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Chris Down <chris@chrisdown.name>,
	David Hildenbrand <david@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 570/686] mm/mglru: fix ineffective memory protection for non-kswapd reclaim
Date: Fri, 13 Nov 2026 10:51:43 -0500
Message-ID: <20261113153840.981290597@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ridong Chen <chenridong@xiaomi.com>

[ Upstream commit 15da1e4978dd4ea8f5faa6e15ee967ba4ad9a30a ]

For MGLRU, memory.min/low is not honored during global proactive reclaim
(writing to the root memory.reclaim) and global direct reclaim, because
these paths shrink memcgs using stale protection (emin/elow).  It can be
reproduced as follows:

  # echo 7 > /sys/kernel/mm/lru_gen/enabled
  # cd /sys/fs/cgroup
  # mkdir -p a/b
  # echo 100M > a/memory.min
  # echo +memory > a/cgroup.subtree_control
  # echo 100M > a/b/memory.min
  # echo $$ > a/b/cgroup.procs
  # dd if=/dev/zero of=/tmp/testfile bs=1M count=200
  # cat a/b/memory.current
  222650368
  # echo 500M > memory.reclaim
  -bash: echo: write error: Resource temporarily unavailable
  # cat a/b/memory.current
  6070272

memory.min is 100M, yet reclaim drops a/b down to 6M, breaking the
protection.  The traditional LRU path is not affected because
shrink_node() calls mem_cgroup_calculate_protection() for each memcg it
visits during a top-down tree walk.

Commit 30d77b7eef01 ("mm/mglru: fix ineffective protection calculation")
moved the protection computation into lru_gen_age_node(), which only runs
for kswapd.  Non-kswapd global reclaim reaches shrink_one() through
lru_gen_shrink_node() -> shrink_many() without any protection computation,
so emin/elow are whatever a previous kswapd run left behind - or zero if
kswapd never ran on this node.  Relying on a prior kswapd pass is not
correct either: a memcg's emin/elow are derived from its ancestors'
memory.min/low settings and from children_min_usage, both of which change
over time, so emin/elow go stale even after kswapd has run and must be
recomputed at the point of reclaim.

Introduce mem_cgroup_calculate_protection_path() which computes emin/elow
along the root-to-target path only, by iterating through the cgroup
ancestors array top-down.  This avoids the full tree traversal that would
be needed with mem_cgroup_calculate_protection(), limiting the cost to
O(depth) per memcg - typically 3-5 levels.

Call it from shrink_one() for the non-kswapd path so that each memcg about
to be shrunk has correct protection values.

Link: https://lore.kernel.org/20260907025445.1836238-3-ridong.chen@linux.dev
Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Assisted-by: Claude:claude-opus-4-8
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/memcontrol.h | 10 +++++++++
 mm/memcontrol.c            | 45 ++++++++++++++++++++++++++++++++++++++
 mm/vmscan.c                |  8 ++++++-
 3 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 706ddda4a60b1..b14bfce896d20 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1869,6 +1869,16 @@ static inline void mem_cgroup_node_filter_allowed(struct mem_cgroup *memcg,
 }
 #endif /* CONFIG_MEMCG */
 
+#if defined(CONFIG_MEMCG) && defined(CONFIG_LRU_GEN)
+void mem_cgroup_calculate_protection_path(struct mem_cgroup *root,
+					  struct mem_cgroup *memcg);
+#else
+static inline void mem_cgroup_calculate_protection_path(struct mem_cgroup *root,
+							struct mem_cgroup *memcg)
+{
+}
+#endif
+
 #if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
 bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
 void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 97ed5ad4053f0..db12e61ee9852 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4737,6 +4737,51 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 	page_counter_calculate_protection(&root->memory, &memcg->memory, recursive_protection);
 }
 
+#ifdef CONFIG_LRU_GEN
+/**
+ * mem_cgroup_calculate_protection_path - compute protection along a path
+ * @root: the top ancestor of the sub-tree being checked (NULL for root_mem_cgroup)
+ * @memcg: the target memory cgroup
+ *
+ * Walk the ancestor path from @root down to @memcg and compute the effective
+ * protection at each level.  This is safe for isolated queries because it
+ * ensures parents are computed before children.
+ */
+void mem_cgroup_calculate_protection_path(struct mem_cgroup *root,
+					  struct mem_cgroup *memcg)
+{
+	bool recursive_protection =
+		cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_RECURSIVE_PROT;
+	struct cgroup *cg;
+	int root_level, i;
+
+	if (mem_cgroup_disabled())
+		return;
+
+	if (!root)
+		root = root_mem_cgroup;
+
+	if (memcg == root)
+		return;
+
+	root_level = root->css.cgroup->level;
+	cg = memcg->css.cgroup;
+
+	rcu_read_lock();
+	for (i = root_level + 1; i <= cg->level; i++) {
+		struct mem_cgroup *cur;
+
+		cur = mem_cgroup_from_css(cgroup_css(cg->ancestors[i],
+						     &memory_cgrp_subsys));
+		if (cur)
+			page_counter_calculate_protection(&root->memory,
+							  &cur->memory,
+							  recursive_protection);
+	}
+	rcu_read_unlock();
+}
+#endif /* CONFIG_LRU_GEN */
+
 static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
 			gfp_t gfp)
 {
diff --git a/mm/vmscan.c b/mm/vmscan.c
index ed75f1bce9f0a..8556318ff721d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4927,7 +4927,13 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
-	/* lru_gen_age_node() called mem_cgroup_calculate_protection() */
+	/*
+	 * For kswapd, mem_cgroup_calculate_protection() has already
+	 * been called during the top-down cgroup traversal.
+	 */
+	if (!current_is_kswapd())
+		mem_cgroup_calculate_protection_path(NULL, memcg);
+
 	if (mem_cgroup_below_min(NULL, memcg))
 		return MEMCG_LRU_YOUNG;
 
-- 
2.53.0



