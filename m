Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C204209695;
	Thu, 12 Dec 2024 17:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025889; cv=none; b=KLVKVNWmUrOow7AqrfMssTLRgga8M/GvnAXE5mkb5WSyEU5cNecysjCK7eF005tP0/AHGSeEEcErnGMNpxjIMbRPRvx7Q/enktoYo5Qrn1BLGai96hJxMyoPWv5tu87qp+trNGIIqWkqYocmn+7NFeF9mqSZtUEUSdK2TCnby7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025889; c=relaxed/simple;
	bh=LCBznP0wUkuXhYSOXsekiFPdus3gKILF1jV7924ulvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cQlXiYj3jk4A2hNhnpe0rhAkpoS5b+7RWkAgoH5dlOQ4P1jubjNTb8XWy28QmJWpFwDQ6jBVha6nkQ8BZvPqn0KEFbYI9e3OnGrUgFlWQ+FY3QAKq05Hdxsir+Aw6P51neqbRvBXBV1Gpq2yc9ZOUvgcHrXmqzmBr50GTCzIllw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tmut9HJd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tmut9HJd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A84C4CED1;
	Thu, 12 Dec 2024 17:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025889;
	bh=LCBznP0wUkuXhYSOXsekiFPdus3gKILF1jV7924ulvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tmut9HJdw0hTqoN+RbW221MqNTL4LYT5pj3yYyVWq5I+MYrwh3BEJsvu/UlyySoEH
	 TGwkZ5Jioskp9endi6VBTVKhZwOa5/WEY0YMxsDSvEZP7W1aLoa8kh4tbCAPFxDlcn
	 3Wj9sK426Y82bPErv225H16EY9oibk5eVjaubCQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 307/321] xdp: Simplify devmap cleanup
Date: Thu, 12 Dec 2024 16:03:45 +0100
Message-ID: <20241212144242.103610166@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Björn Töpel <bjorn.topel@intel.com>

[ Upstream commit 0536b85239b8440735cdd910aae0eb076ebbb439 ]

After the RCU flavor consolidation [1], call_rcu() and
synchronize_rcu() waits for preempt-disable regions (NAPI) in addition
to the read-side critical sections. As a result of this, the cleanup
code in devmap can be simplified

* There is no longer a need to flush in __dev_map_entry_free, since we
  know that this has been done when the call_rcu() callback is
  triggered.

* When freeing the map, there is no need to explicitly wait for a
  flush. It's guaranteed to be done after the synchronize_rcu() call
  in dev_map_free(). The rcu_barrier() is still needed, so that the
  map is not freed prior the elements.

[1] https://lwn.net/Articles/777036/

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/bpf/20191219061006.21980-2-bjorn.topel@gmail.com
Stable-dep-of: ab244dd7cf4c ("bpf: fix OOB devmap writes when deleting elements")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/devmap.c | 43 +++++--------------------------------------
 1 file changed, 5 insertions(+), 38 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 2370fc31169f5..e63ecb21e0554 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -206,7 +206,7 @@ static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
 static void dev_map_free(struct bpf_map *map)
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
-	int i, cpu;
+	int i;
 
 	/* At this point bpf_prog->aux->refcnt == 0 and this map->refcnt == 0,
 	 * so the programs (can be more than one that used this map) were
@@ -226,18 +226,6 @@ static void dev_map_free(struct bpf_map *map)
 	/* Make sure prior __dev_map_entry_free() have completed. */
 	rcu_barrier();
 
-	/* To ensure all pending flush operations have completed wait for flush
-	 * list to empty on _all_ cpus.
-	 * Because the above synchronize_rcu() ensures the map is disconnected
-	 * from the program we can assume no new items will be added.
-	 */
-	for_each_online_cpu(cpu) {
-		struct list_head *flush_list = per_cpu_ptr(dtab->flush_list, cpu);
-
-		while (!list_empty(flush_list))
-			cond_resched();
-	}
-
 	if (dtab->map.map_type == BPF_MAP_TYPE_DEVMAP_HASH) {
 		for (i = 0; i < dtab->n_buckets; i++) {
 			struct bpf_dtab_netdev *dev;
@@ -351,8 +339,7 @@ static int dev_map_hash_get_next_key(struct bpf_map *map, void *key,
 	return -ENOENT;
 }
 
-static int bq_xmit_all(struct xdp_bulk_queue *bq, u32 flags,
-		       bool in_napi_ctx)
+static int bq_xmit_all(struct xdp_bulk_queue *bq, u32 flags)
 {
 	struct bpf_dtab_netdev *obj = bq->obj;
 	struct net_device *dev = obj->dev;
@@ -390,11 +377,7 @@ static int bq_xmit_all(struct xdp_bulk_queue *bq, u32 flags,
 	for (i = 0; i < bq->count; i++) {
 		struct xdp_frame *xdpf = bq->q[i];
 
-		/* RX path under NAPI protection, can return frames faster */
-		if (likely(in_napi_ctx))
-			xdp_return_frame_rx_napi(xdpf);
-		else
-			xdp_return_frame(xdpf);
+		xdp_return_frame_rx_napi(xdpf);
 		drops++;
 	}
 	goto out;
@@ -415,7 +398,7 @@ void __dev_map_flush(struct bpf_map *map)
 
 	rcu_read_lock();
 	list_for_each_entry_safe(bq, tmp, flush_list, flush_node)
-		bq_xmit_all(bq, XDP_XMIT_FLUSH, true);
+		bq_xmit_all(bq, XDP_XMIT_FLUSH);
 	rcu_read_unlock();
 }
 
@@ -446,7 +429,7 @@ static int bq_enqueue(struct bpf_dtab_netdev *obj, struct xdp_frame *xdpf,
 	struct xdp_bulk_queue *bq = this_cpu_ptr(obj->bulkq);
 
 	if (unlikely(bq->count == DEV_MAP_BULK_SIZE))
-		bq_xmit_all(bq, 0, true);
+		bq_xmit_all(bq, 0);
 
 	/* Ingress dev_rx will be the same for all xdp_frame's in
 	 * bulk_queue, because bq stored per-CPU and must be flushed
@@ -515,27 +498,11 @@ static void *dev_map_hash_lookup_elem(struct bpf_map *map, void *key)
 	return dev ? &dev->ifindex : NULL;
 }
 
-static void dev_map_flush_old(struct bpf_dtab_netdev *dev)
-{
-	if (dev->dev->netdev_ops->ndo_xdp_xmit) {
-		struct xdp_bulk_queue *bq;
-		int cpu;
-
-		rcu_read_lock();
-		for_each_online_cpu(cpu) {
-			bq = per_cpu_ptr(dev->bulkq, cpu);
-			bq_xmit_all(bq, XDP_XMIT_FLUSH, false);
-		}
-		rcu_read_unlock();
-	}
-}
-
 static void __dev_map_entry_free(struct rcu_head *rcu)
 {
 	struct bpf_dtab_netdev *dev;
 
 	dev = container_of(rcu, struct bpf_dtab_netdev, rcu);
-	dev_map_flush_old(dev);
 	free_percpu(dev->bulkq);
 	dev_put(dev->dev);
 	kfree(dev);
-- 
2.43.0



