Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7BC313E30;
	Thu, 16 Jul 2026 14:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210929; cv=none; b=dmvhvNjnIe9bqK0yLGFtkoSoufRm/+K+zqKXNKxUBgXaMokdfzeKj39kK8DUMOfRjs5CQWFtk1elrmeLhHIYIpkDEhggaigGxnLHF4RPUoGvrSq5Lj45gcIvV1eKQNRyWfD+J4Nqk9Hg9xeJCwbtSIQI68sqzDBPwqXKgPKmitw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210929; c=relaxed/simple;
	bh=LQZ0+VNtcy5e3xjLAAD/Rj4W/cdHvfH3Qe8SZ/77bVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CvxMBFpZ/UdmdOTKITWcvijGO2JxXnuKst0CMXPTbr2AK5awrwGvljh9WCp29mOI1JSfbE0qu6vTspv3SK0gpuL/RiWlx7Equ7LWZlTvsa584UThzUrRxYy5LQZmnLvkZt5yclRDnn3m1ls/UahufAP7UwVrlITmJyhvhNoam0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UmplMMTg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UmplMMTg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B071F00A3D;
	Thu, 16 Jul 2026 14:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210928;
	bh=7Xeq56SF+Z8Z1cZbHj64yGpw4Vsz1rm6vEbVdUMl548=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UmplMMTggeff+c+HRbIdfknNAnMsK8sXNU3apcRU4Jog5z986HfT066pRpN9rOwtw
	 fwAEDqqY+m+ocN9JDMmnybUJRjLAsQFW0e1mGiagL9jh8Y7wSx4ave8WovK7yOKDgJ
	 mnpQPG5XzNCUb2Y+pWMZK/tPWeCSpigsQ65BgvPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 190/480] mm: shrinker: fix shrinker_info teardown race with expansion
Date: Thu, 16 Jul 2026 15:28:57 +0200
Message-ID: <20260716133048.837513761@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qi Zheng <zhengqi.arch@bytedance.com>

commit 65476d31d8056e859c48580f82295ce159196ffe upstream.

expand_shrinker_info() iterates all visible memcgs under shrinker_mutex,
including memcgs that have not finished ->css_online() yet.

Once pn->shrinker_info has been published, teardown must stay serialized
with expand_shrinker_info() until that memcg is either fully online or no
longer visible to iteration.  Today alloc_shrinker_info() breaks that rule
by dropping shrinker_mutex before freeing a partially initialized
shrinker_info array, which may cause the following race:

CPU0                   CPU1
====                   ====

css_create
--> list_add_tail_rcu(&css->sibling, &parent_css->children);
    online_css
    --> mem_cgroup_css_online
        --> alloc_shrinker_info
            --> alloc node0 info
                rcu_assign_pointer(C->node0->shrinker_info, old0)
                alloc node1 info -> FAIL -> goto err
                mutex_unlock(shrinker_mutex)

                       shrinker_alloc()
                       --> shrinker_memcg_alloc
                           --> mutex_lock(shrinker_mutex)
                               expand_shrinker_info
                               --> mem_cgroup_iter see the memcg
                                   expand_one_shrinker_info
                                   --> old0 = C->node0->shrinker_info
                                       memcpy(new->unit, old0->unit, ...);

                free_shrinker_info
                --> kvfree(old0);

                                       /* double free !! */
                                       kvfree_rcu(old0, rcu);

The same problem exists later in mem_cgroup_css_online().  If
alloc_shrinker_info() succeeds but a subsequent objcg allocation fails,
the free_objcg -> free_shrinker_info() unwind path tears down the already
published pn->shrinker_info arrays without shrinker_mutex.  The
expand_one_shrinker_info() can race with that teardown in the same way,
leading to use-after-free or double-free of the old shrinker_info.

Fix this by serializing shrinker_info teardown with shrinker_mutex, and by
keeping alloc_shrinker_info() error cleanup inside the locked section.

Link: https://lore.kernel.org/20260617085658.27096-1-qi.zheng@linux.dev
Fixes: 307bececcd12 ("mm: shrinker: add a secondary array for shrinker_info::{map, nr_deferred}")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shrinker.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -59,12 +59,14 @@ static inline int shrinker_unit_alloc(st
 	return 0;
 }
 
-void free_shrinker_info(struct mem_cgroup *memcg)
+static void __free_shrinker_info(struct mem_cgroup *memcg)
 {
 	struct mem_cgroup_per_node *pn;
 	struct shrinker_info *info;
 	int nid;
 
+	lockdep_assert_held(&shrinker_mutex);
+
 	for_each_node(nid) {
 		pn = memcg->nodeinfo[nid];
 		info = rcu_dereference_protected(pn->shrinker_info, true);
@@ -74,6 +76,13 @@ void free_shrinker_info(struct mem_cgrou
 	}
 }
 
+void free_shrinker_info(struct mem_cgroup *memcg)
+{
+	mutex_lock(&shrinker_mutex);
+	__free_shrinker_info(memcg);
+	mutex_unlock(&shrinker_mutex);
+}
+
 int alloc_shrinker_info(struct mem_cgroup *memcg)
 {
 	int nid, ret = 0;
@@ -98,8 +107,8 @@ int alloc_shrinker_info(struct mem_cgrou
 	return ret;
 
 err:
+	__free_shrinker_info(memcg);
 	mutex_unlock(&shrinker_mutex);
-	free_shrinker_info(memcg);
 	return -ENOMEM;
 }
 


