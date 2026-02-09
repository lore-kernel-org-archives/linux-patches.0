Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F6135CB6B;
	Mon,  9 Feb 2026 14:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647284; cv=none; b=e+PguJpaHqWxoqSNz7MxpA20yMDBg8ymodKqLfFv0QnsQqoT7u0t7UTJVYnildcvi2PZwq6qawQLXc9oy0QdRVX7hM7RAb5epLSVv0SRshl7olF/5iRls/t1WQv+K3EiN8XHPptAtCN9MXiy7g/3Knc9cF/Lx28y0Mdm+Dbw/a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647284; c=relaxed/simple;
	bh=J7jTRB9F/x9uSRIKogzzxvYmBr25hDmeMo6PkSbWMk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Avwa/7hEV/Bb9wy07JA+PVsa6H4AfxuAZyhm+NIwUdTgKjn4MeBLTDM0r6icORYCEX5O1qUCReMT8weqEeQHTBVvPI5BN65gUbTyqIP1d7aAc8w86OtccdBUGtYdJfseMSB8eMAk+fIWY4JuHV1Z/hq/EYVV58PrI6yxHNAkaMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jmqLnjvG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jmqLnjvG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DBE7C116C6;
	Mon,  9 Feb 2026 14:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647283;
	bh=J7jTRB9F/x9uSRIKogzzxvYmBr25hDmeMo6PkSbWMk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jmqLnjvGJRI5Q13b69jxYQV5I9cAxnKI1HCbHHgRLEHgcCtlInCyvFE8b63hPWVkc
	 DF4BU/qcclKF8Nd2Ro63/RCQKf0/Gn0x34Wz1/PVgwonfoqUFs45sOK8ODw35v6l0n
	 ghznHXIytFs6TPz3hWXzKGpyjhGmKgAerh4/pLnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.18 020/175] cgroup/dmem: avoid pool UAF
Date: Mon,  9 Feb 2026 15:21:33 +0100
Message-ID: <20260209142321.207140534@linuxfoundation.org>
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

commit 99a2ef500906138ba58093b9893972a5c303c734 upstream.

An UAF issue was observed:

BUG: KASAN: slab-use-after-free in page_counter_uncharge+0x65/0x150
Write of size 8 at addr ffff888106715440 by task insmod/527

CPU: 4 UID: 0 PID: 527 Comm: insmod    6.19.0-rc7-next-20260129+ #11
Tainted: [O]=OOT_MODULE
Call Trace:
<TASK>
dump_stack_lvl+0x82/0xd0
kasan_report+0xca/0x100
kasan_check_range+0x39/0x1c0
page_counter_uncharge+0x65/0x150
dmem_cgroup_uncharge+0x1f/0x260

Allocated by task 527:

Freed by task 0:

The buggy address belongs to the object at ffff888106715400
which belongs to the cache kmalloc-512 of size 512
The buggy address is located 64 bytes inside of
freed 512-byte region [ffff888106715400, ffff888106715600)

The buggy address belongs to the physical page:

Memory state around the buggy address:
ffff888106715300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
ffff888106715380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888106715400: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
				     ^
ffff888106715480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
ffff888106715500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb

The issue occurs because a pool can still be held by a caller after its
associated memory region is unregistered. The current implementation frees
the pool even if users still hold references to it (e.g., before uncharge
operations complete).

This patch adds a reference counter to each pool, ensuring that a pool is
only freed when its reference count drops to zero.

Fixes: b168ed458dde ("kernel/cgroup: Add "dmem" memory accounting cgroup")
Cc: stable@vger.kernel.org # v6.14+
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/dmem.c | 60 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 58 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/dmem.c b/kernel/cgroup/dmem.c
index 787b334e0f5d..1ea6afffa985 100644
--- a/kernel/cgroup/dmem.c
+++ b/kernel/cgroup/dmem.c
@@ -14,6 +14,7 @@
 #include <linux/mutex.h>
 #include <linux/page_counter.h>
 #include <linux/parser.h>
+#include <linux/refcount.h>
 #include <linux/rculist.h>
 #include <linux/slab.h>
 
@@ -71,7 +72,9 @@ struct dmem_cgroup_pool_state {
 	struct rcu_head rcu;
 
 	struct page_counter cnt;
+	struct dmem_cgroup_pool_state *parent;
 
+	refcount_t ref;
 	bool inited;
 };
 
@@ -88,6 +91,9 @@ struct dmem_cgroup_pool_state {
 static DEFINE_SPINLOCK(dmemcg_lock);
 static LIST_HEAD(dmem_cgroup_regions);
 
+static void dmemcg_free_region(struct kref *ref);
+static void dmemcg_pool_free_rcu(struct rcu_head *rcu);
+
 static inline struct dmemcg_state *
 css_to_dmemcs(struct cgroup_subsys_state *css)
 {
@@ -104,10 +110,38 @@ static struct dmemcg_state *parent_dmemcs(struct dmemcg_state *cg)
 	return cg->css.parent ? css_to_dmemcs(cg->css.parent) : NULL;
 }
 
+static void dmemcg_pool_get(struct dmem_cgroup_pool_state *pool)
+{
+	refcount_inc(&pool->ref);
+}
+
+static bool dmemcg_pool_tryget(struct dmem_cgroup_pool_state *pool)
+{
+	return refcount_inc_not_zero(&pool->ref);
+}
+
+static void dmemcg_pool_put(struct dmem_cgroup_pool_state *pool)
+{
+	if (!refcount_dec_and_test(&pool->ref))
+		return;
+
+	call_rcu(&pool->rcu, dmemcg_pool_free_rcu);
+}
+
+static void dmemcg_pool_free_rcu(struct rcu_head *rcu)
+{
+	struct dmem_cgroup_pool_state *pool = container_of(rcu, typeof(*pool), rcu);
+
+	if (pool->parent)
+		dmemcg_pool_put(pool->parent);
+	kref_put(&pool->region->ref, dmemcg_free_region);
+	kfree(pool);
+}
+
 static void free_cg_pool(struct dmem_cgroup_pool_state *pool)
 {
 	list_del(&pool->region_node);
-	kfree(pool);
+	dmemcg_pool_put(pool);
 }
 
 static void
@@ -342,6 +376,12 @@ alloc_pool_single(struct dmemcg_state *dmemcs, struct dmem_cgroup_region *region
 	page_counter_init(&pool->cnt,
 			  ppool ? &ppool->cnt : NULL, true);
 	reset_all_resource_limits(pool);
+	refcount_set(&pool->ref, 1);
+	kref_get(&region->ref);
+	if (ppool && !pool->parent) {
+		pool->parent = ppool;
+		dmemcg_pool_get(ppool);
+	}
 
 	list_add_tail_rcu(&pool->css_node, &dmemcs->pools);
 	list_add_tail(&pool->region_node, &region->pools);
@@ -389,6 +429,10 @@ get_cg_pool_locked(struct dmemcg_state *dmemcs, struct dmem_cgroup_region *regio
 
 		/* Fix up parent links, mark as inited. */
 		pool->cnt.parent = &ppool->cnt;
+		if (ppool && !pool->parent) {
+			pool->parent = ppool;
+			dmemcg_pool_get(ppool);
+		}
 		pool->inited = true;
 
 		pool = ppool;
@@ -435,6 +479,8 @@ void dmem_cgroup_unregister_region(struct dmem_cgroup_region *region)
 
 	list_for_each_entry_safe(pool, next, &region->pools, region_node) {
 		list_del_rcu(&pool->css_node);
+		list_del(&pool->region_node);
+		dmemcg_pool_put(pool);
 	}
 
 	/*
@@ -515,8 +561,10 @@ static struct dmem_cgroup_region *dmemcg_get_region_by_name(const char *name)
  */
 void dmem_cgroup_pool_state_put(struct dmem_cgroup_pool_state *pool)
 {
-	if (pool)
+	if (pool) {
 		css_put(&pool->cs->css);
+		dmemcg_pool_put(pool);
+	}
 }
 EXPORT_SYMBOL_GPL(dmem_cgroup_pool_state_put);
 
@@ -530,6 +578,8 @@ get_cg_pool_unlocked(struct dmemcg_state *cg, struct dmem_cgroup_region *region)
 	pool = find_cg_pool_locked(cg, region);
 	if (pool && !READ_ONCE(pool->inited))
 		pool = NULL;
+	if (pool && !dmemcg_pool_tryget(pool))
+		pool = NULL;
 	rcu_read_unlock();
 
 	while (!pool) {
@@ -538,6 +588,8 @@ get_cg_pool_unlocked(struct dmemcg_state *cg, struct dmem_cgroup_region *region)
 			pool = get_cg_pool_locked(cg, region, &allocpool);
 		else
 			pool = ERR_PTR(-ENODEV);
+		if (!IS_ERR(pool))
+			dmemcg_pool_get(pool);
 		spin_unlock(&dmemcg_lock);
 
 		if (pool == ERR_PTR(-ENOMEM)) {
@@ -573,6 +625,7 @@ void dmem_cgroup_uncharge(struct dmem_cgroup_pool_state *pool, u64 size)
 
 	page_counter_uncharge(&pool->cnt, size);
 	css_put(&pool->cs->css);
+	dmemcg_pool_put(pool);
 }
 EXPORT_SYMBOL_GPL(dmem_cgroup_uncharge);
 
@@ -624,7 +677,9 @@ int dmem_cgroup_try_charge(struct dmem_cgroup_region *region, u64 size,
 		if (ret_limit_pool) {
 			*ret_limit_pool = container_of(fail, struct dmem_cgroup_pool_state, cnt);
 			css_get(&(*ret_limit_pool)->cs->css);
+			dmemcg_pool_get(*ret_limit_pool);
 		}
+		dmemcg_pool_put(pool);
 		ret = -EAGAIN;
 		goto err;
 	}
@@ -719,6 +774,7 @@ static ssize_t dmemcg_limit_write(struct kernfs_open_file *of,
 
 		/* And commit */
 		apply(pool, new_limit);
+		dmemcg_pool_put(pool);
 
 out_put:
 		kref_put(&region->ref, dmemcg_free_region);
-- 
2.53.0



