Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6E4378D8E;
	Fri,  7 Aug 2026 15:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114824; cv=none; b=E85K62zkR6HhfF1M6gjsuKV1XrfICNu7omWzV5rVdo69sihxoNyfJBHnEbGimQv6ykzplKxZ65uWVoQ3uMymmsjXa1vFyOY1KYNWFF3MPdX17jinCcWQjw0QAdZboiAHe0mGylqHFDbzks8sTN9y2DG0UhgN8fmk/ajB2FFsZMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114824; c=relaxed/simple;
	bh=sPWbAjE4CaZohFlZ9Gt0iXk1lZahRloTBkTu3VJaHYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SCVwukkYBvq1pNGyPT0vXkN0TsWLyanpb4kVfCutwFNTVVyR8/ZuWvnoZ5tncoyTGBxSuMiW4DHtqHwrBNEJQzPdWgD2AdPOw7B3OY9YiEtv3kgFbFSgGp8CwjJWSO94pr+5Zxmakj9V6tiJ38FkCAPrYZo1LUtaerViBygbu6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fhThmclP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fhThmclP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E40C1F000E9;
	Fri,  7 Aug 2026 15:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114822;
	bh=uFQM4NlMxlOZlnDTaQFZCaQ6fqPKdZmYEZEID2hKFwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fhThmclPZVv3oRRp/7SDnV2i/YuR63SdgEXbJ9bqmu2J4qkH3fixS2IJ9foKu27ty
	 nLnbQvyhi8M3jBptMb8mT40PRC/s8hBUDiFR6lTzJqWNnOujHzRjn580DAQsGmlmrk
	 7brSulEcvx8HDd7FVMUatfylXZaD4rh6PxFPeJ0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kernelxing@tencent.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 061/396] xsk: use a smaller new lock for shared pool case
Date: Fri,  7 Aug 2026 16:33:41 +0200
Message-ID: <20260807143425.589501066@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Jason Xing <kernelxing@tencent.com>

[ Upstream commit 30ed05adca4a05c50594384cff18910858dd1d35 ]

- Split cq_lock into two smaller locks: cq_prod_lock and
  cq_cached_prod_lock
- Avoid disabling/enabling interrupts in the hot xmit path

In either xsk_cq_cancel_locked() or xsk_cq_reserve_locked() function,
the race condition is only between multiple xsks sharing the same
pool. They are all in the process context rather than interrupt context,
so now the small lock named cq_cached_prod_lock can be used without
handling interrupts.

While cq_cached_prod_lock ensures the exclusive modification of
@cached_prod, cq_prod_lock in xsk_cq_submit_addr_locked() only cares
about @producer and corresponding @desc. Both of them don't necessarily
be consistent with @cached_prod protected by cq_cached_prod_lock.
That's the reason why the previous big lock can be split into two
smaller ones. Please note that SPSC rule is all about the global state
of producer and consumer that can affect both layers instead of local
or cached ones.

Frequently disabling and enabling interrupt are very time consuming
in some cases, especially in a per-descriptor granularity, which now
can be avoided after this optimization, even when the pool is shared by
multiple xsks.

With this patch, the performance number[1] could go from 1,872,565 pps
to 1,961,009 pps. It's a minor rise of around 5%.

[1]: taskset -c 1 ./xdpsock -i enp2s0f1 -q 0 -t -S -s 64

Signed-off-by: Jason Xing <kernelxing@tencent.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://patch.msgid.link/20251030000646.18859-3-kerneljasonxing@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: bd44a6dcd424 ("xsk: drain continuation descs after overflow in xsk_build_skb()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xsk_buff_pool.h | 13 +++++++++----
 net/xdp/xsk.c               | 15 ++++++---------
 net/xdp/xsk_buff_pool.c     |  3 ++-
 3 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index cac56e6b0869b..92a2358c6ce34 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -85,11 +85,16 @@ struct xsk_buff_pool {
 	bool unaligned;
 	bool tx_sw_csum;
 	void *addrs;
-	/* Mutual exclusion of the completion ring in the SKB mode. Two cases to protect:
-	 * NAPI TX thread and sendmsg error paths in the SKB destructor callback and when
-	 * sockets share a single cq when the same netdev and queue id is shared.
+	/* Mutual exclusion of the completion ring in the SKB mode.
+	 * Protect: NAPI TX thread and sendmsg error paths in the SKB
+	 * destructor callback.
 	 */
-	spinlock_t cq_lock;
+	spinlock_t cq_prod_lock;
+	/* Mutual exclusion of the completion ring in the SKB mode.
+	 * Protect: when sockets share a single cq when the same netdev
+	 * and queue id is shared.
+	 */
+	spinlock_t cq_cached_prod_lock;
 	struct xdp_buff_xsk *free_heads[];
 };
 
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 024e23c08b8db..72d83b671f844 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -547,12 +547,11 @@ static int xsk_wakeup(struct xdp_sock *xs, u8 flags)
 
 static int xsk_cq_reserve_locked(struct xsk_buff_pool *pool)
 {
-	unsigned long flags;
 	int ret;
 
-	spin_lock_irqsave(&pool->cq_lock, flags);
+	spin_lock(&pool->cq_cached_prod_lock);
 	ret = xskq_prod_reserve(pool->cq);
-	spin_unlock_irqrestore(&pool->cq_lock, flags);
+	spin_unlock(&pool->cq_cached_prod_lock);
 
 	return ret;
 }
@@ -603,7 +602,7 @@ static void xsk_cq_submit_addr_locked(struct xsk_buff_pool *pool,
 	unsigned long flags;
 	u32 idx, i;
 
-	spin_lock_irqsave(&pool->cq_lock, flags);
+	spin_lock_irqsave(&pool->cq_prod_lock, flags);
 	idx = xskq_get_prod(pool->cq);
 
 	if (unlikely(num_descs > 1)) {
@@ -621,16 +620,14 @@ static void xsk_cq_submit_addr_locked(struct xsk_buff_pool *pool,
 		descs_processed++;
 	}
 	xskq_prod_submit_n(pool->cq, descs_processed);
-	spin_unlock_irqrestore(&pool->cq_lock, flags);
+	spin_unlock_irqrestore(&pool->cq_prod_lock, flags);
 }
 
 static void xsk_cq_cancel_locked(struct xsk_buff_pool *pool, u32 n)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&pool->cq_lock, flags);
+	spin_lock(&pool->cq_cached_prod_lock);
 	xskq_prod_cancel_n(pool->cq, n);
-	spin_unlock_irqrestore(&pool->cq_lock, flags);
+	spin_unlock(&pool->cq_cached_prod_lock);
 }
 
 static void xsk_destruct_skb(struct sk_buff *skb)
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index a129ce6f1c25f..c9688735b643c 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -96,7 +96,8 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 	INIT_LIST_HEAD(&pool->xskb_list);
 	INIT_LIST_HEAD(&pool->xsk_tx_list);
 	spin_lock_init(&pool->xsk_tx_list_lock);
-	spin_lock_init(&pool->cq_lock);
+	spin_lock_init(&pool->cq_prod_lock);
+	spin_lock_init(&pool->cq_cached_prod_lock);
 	refcount_set(&pool->users, 1);
 
 	pool->fq = xs->fq_tmp;
-- 
2.53.0



