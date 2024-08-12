Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7E41494B8;
	Mon, 12 Aug 2024 16:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480499; cv=none; b=MQINIQVxJ7kBmSxA0T+NcxcK4azhkYaIj4nZ3/3AyoEzXA8TNcvP7c47r1W7Zd2gouRluQzwjWk33u8O7IDKZj/p42x87i6vD3qtMh/pAJuiFlHW8hozkPtCWxPUj1YzMQI3ldG5Zdr7/pKf4tVPMyo1m2aquGWHMO+Y9NKeH98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480499; c=relaxed/simple;
	bh=hDWmHhK2D27GdUUf+iaJgj/PvUphRsVWEwDNmFnVE3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQf1pRgksu2yw/iKcnES+Xo3C7Hz9R20E2tqZBzkIcPjFdErTOvAPddnyMKUn/48Hq9uhoJmZJujyGrTAfXWrgb1O/8aV/xmb51NU6zNnTtShlAceZ5P0GObcfCX6m6sAxQWa6KDZh/dKLt/xqfJeYm2J/fetrROue/5Fx0Shuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WH8VbVjT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WH8VbVjT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7553EC32782;
	Mon, 12 Aug 2024 16:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480498;
	bh=hDWmHhK2D27GdUUf+iaJgj/PvUphRsVWEwDNmFnVE3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WH8VbVjTd/uLPph17S4ASKOFW4FTrZ7DP+BbanTLJF3je3bFb4PVs0k0k4KVLXZfT
	 yqJYxNo8OOqdEeC9Z+1Nt++WZe4DAeoHAjCMny4dfb/asIR40GmHv7Xe+bZdTjV3mc
	 MOpcSZsPKXq9UYFZN9jKmjNSLIpCJ5Z8e0Ac2umY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.10 213/263] memcg: protect concurrent access to mem_cgroup_idr
Date: Mon, 12 Aug 2024 18:03:34 +0200
Message-ID: <20240812160154.698236663@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shakeel Butt <shakeel.butt@linux.dev>

commit 9972605a238339b85bd16b084eed5f18414d22db upstream.

Commit 73f576c04b94 ("mm: memcontrol: fix cgroup creation failure after
many small jobs") decoupled the memcg IDs from the CSS ID space to fix the
cgroup creation failures.  It introduced IDR to maintain the memcg ID
space.  The IDR depends on external synchronization mechanisms for
modifications.  For the mem_cgroup_idr, the idr_alloc() and idr_replace()
happen within css callback and thus are protected through cgroup_mutex
from concurrent modifications.  However idr_remove() for mem_cgroup_idr
was not protected against concurrency and can be run concurrently for
different memcgs when they hit their refcnt to zero.  Fix that.

We have been seeing list_lru based kernel crashes at a low frequency in
our fleet for a long time.  These crashes were in different part of
list_lru code including list_lru_add(), list_lru_del() and reparenting
code.  Upon further inspection, it looked like for a given object (dentry
and inode), the super_block's list_lru didn't have list_lru_one for the
memcg of that object.  The initial suspicions were either the object is
not allocated through kmem_cache_alloc_lru() or somehow
memcg_list_lru_alloc() failed to allocate list_lru_one() for a memcg but
returned success.  No evidence were found for these cases.

Looking more deeply, we started seeing situations where valid memcg's id
is not present in mem_cgroup_idr and in some cases multiple valid memcgs
have same id and mem_cgroup_idr is pointing to one of them.  So, the most
reasonable explanation is that these situations can happen due to race
between multiple idr_remove() calls or race between
idr_alloc()/idr_replace() and idr_remove().  These races are causing
multiple memcgs to acquire the same ID and then offlining of one of them
would cleanup list_lrus on the system for all of them.  Later access from
other memcgs to the list_lru cause crashes due to missing list_lru_one.

Link: https://lkml.kernel.org/r/20240802235822.1830976-1-shakeel.butt@linux.dev
Fixes: 73f576c04b94 ("mm: memcontrol: fix cgroup creation failure after many small jobs")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5568,11 +5568,28 @@ static struct cftype mem_cgroup_legacy_f
 
 #define MEM_CGROUP_ID_MAX	((1UL << MEM_CGROUP_ID_SHIFT) - 1)
 static DEFINE_IDR(mem_cgroup_idr);
+static DEFINE_SPINLOCK(memcg_idr_lock);
+
+static int mem_cgroup_alloc_id(void)
+{
+	int ret;
+
+	idr_preload(GFP_KERNEL);
+	spin_lock(&memcg_idr_lock);
+	ret = idr_alloc(&mem_cgroup_idr, NULL, 1, MEM_CGROUP_ID_MAX + 1,
+			GFP_NOWAIT);
+	spin_unlock(&memcg_idr_lock);
+	idr_preload_end();
+	return ret;
+}
 
 static void mem_cgroup_id_remove(struct mem_cgroup *memcg)
 {
 	if (memcg->id.id > 0) {
+		spin_lock(&memcg_idr_lock);
 		idr_remove(&mem_cgroup_idr, memcg->id.id);
+		spin_unlock(&memcg_idr_lock);
+
 		memcg->id.id = 0;
 	}
 }
@@ -5706,8 +5723,7 @@ static struct mem_cgroup *mem_cgroup_all
 	if (!memcg)
 		return ERR_PTR(error);
 
-	memcg->id.id = idr_alloc(&mem_cgroup_idr, NULL,
-				 1, MEM_CGROUP_ID_MAX + 1, GFP_KERNEL);
+	memcg->id.id = mem_cgroup_alloc_id();
 	if (memcg->id.id < 0) {
 		error = memcg->id.id;
 		goto fail;
@@ -5854,7 +5870,9 @@ static int mem_cgroup_css_online(struct
 	 * publish it here at the end of onlining. This matches the
 	 * regular ID destruction during offlining.
 	 */
+	spin_lock(&memcg_idr_lock);
 	idr_replace(&mem_cgroup_idr, memcg, memcg->id.id);
+	spin_unlock(&memcg_idr_lock);
 
 	return 0;
 offline_kmem:


