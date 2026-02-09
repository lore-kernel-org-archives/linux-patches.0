Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F02335CB6B;
	Mon,  9 Feb 2026 14:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647280; cv=none; b=fRQcg0a/1RZfnahNTO7LahnF6CM85AKaAvgV6Uttbpm+T/WtUMl4oRylaLyT+ra9qtIFfYliWuK3U5TcY5WRitDSUvsKCnZJyVd8bIxPQYQjl+x5/N+Fb/Rz0eR3GmL8bksxwip9ZUgt7fvP6arAhtKnI/R8Fzl6EuKskxBKJgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647280; c=relaxed/simple;
	bh=ALsQgti4mvzZCVnDnaxZr7ZBukkO3J6hkJ6+D1O8fgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IG4Wr7vpQLNHSfF+xSu/bBiyQhxcTo2UqgcqbhO1Sj6Lk6yvLTgAUzN9FTpsLshYxVJ46AmTHVibxSteG3irwihY73JwV3BhTiMkWcMIzW5Ccd9155CLGsGBYU+jtedH23xrPSUDlTOiyPDNY0ekcjfwKkcEFaXCWDa7UwTi3WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=clo2wibQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="clo2wibQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B45C116C6;
	Mon,  9 Feb 2026 14:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647280;
	bh=ALsQgti4mvzZCVnDnaxZr7ZBukkO3J6hkJ6+D1O8fgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=clo2wibQi33LCw7ZFrN80ZrRFMa9ZwmQEO9ZaFs+nE4mSJsa6F/cXqSwT0cHNjK8W
	 Ght/CmWVkydSituuNqvK2Uk6dNAx4gqiWop20+l1NQJl0TVl+E36z3kysxirntcF8I
	 SZQDHz/3J8J39z2PAT4uPeyoLynmQ6QM0bC7ULZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.18 019/175] cgroup/dmem: avoid rcu warning when unregister region
Date: Mon,  9 Feb 2026 15:21:32 +0100
Message-ID: <20260209142321.170456063@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

From: Chen Ridong <chenridong@huawei.com>

commit 592a68212c5664bcaa88f24ed80bf791282790fe upstream.

A warnning was detected:

 WARNING: suspicious RCU usage
 6.19.0-rc7-next-20260129+ #1101 Tainted: G           O
 kernel/cgroup/dmem.c:456 suspicious rcu_dereference_check() usage!

 other info that might help us debug this:

 rcu_scheduler_active = 2, debug_locks = 1
 1 lock held by insmod/532:
  #0: ffffffff85e78b38 (dmemcg_lock){+.+.}-dmem_cgroup_unregister_region+

 stack backtrace:
 CPU: 2 UID: 0 PID: 532 Comm: insmod Tainted: 6.19.0-rc7-next-
 Tainted: [O]=OOT_MODULE
 Call Trace:
  <TASK>
  dump_stack_lvl+0xb0/0xd0
  lockdep_rcu_suspicious+0x151/0x1c0
  dmem_cgroup_unregister_region+0x1e2/0x380
  ? __pfx_dmem_test_init+0x10/0x10 [dmem_uaf]
  dmem_test_init+0x65/0xff0 [dmem_uaf]
  do_one_initcall+0xbb/0x3a0

The macro list_for_each_rcu() must be used within an RCU read-side critical
section (between rcu_read_lock() and rcu_read_unlock()). Using it outside
that context, as seen in dmem_cgroup_unregister_region(), triggers the
lockdep warning because the RCU protection is not guaranteed.

Replace list_for_each_rcu() with list_for_each_entry_safe(), which is
appropriate for traversal under spinlock protection where nodes may be
deleted.

Fixes: b168ed458dde ("kernel/cgroup: Add "dmem" memory accounting cgroup")
Cc: stable@vger.kernel.org # v6.14+
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/dmem.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/kernel/cgroup/dmem.c
+++ b/kernel/cgroup/dmem.c
@@ -423,7 +423,7 @@ static void dmemcg_free_region(struct kr
  */
 void dmem_cgroup_unregister_region(struct dmem_cgroup_region *region)
 {
-	struct list_head *entry;
+	struct dmem_cgroup_pool_state *pool, *next;
 
 	if (!region)
 		return;
@@ -433,10 +433,7 @@ void dmem_cgroup_unregister_region(struc
 	/* Remove from global region list */
 	list_del_rcu(&region->region_node);
 
-	list_for_each_rcu(entry, &region->pools) {
-		struct dmem_cgroup_pool_state *pool =
-			container_of(entry, typeof(*pool), region_node);
-
+	list_for_each_entry_safe(pool, next, &region->pools, region_node) {
 		list_del_rcu(&pool->css_node);
 	}
 


