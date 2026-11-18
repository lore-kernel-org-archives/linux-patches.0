Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021555;
	b=orLGYGJTLdP6Pz72urAtH1B4Ejr/FuZQhElJWG1M3ImxPqgdVbjDnizwqlFjsunBnZPy
	 Yc5h5nb0aaNzsQR5Nhq09VrZHk34k+k6aAi8wpMQAR2/VJSFPGZHnsXYXO+JSPB7kzQEj
	 CkwOi/obhQHquKSDZMnBlhmJFhN4DdCvgunBlMm08kdwShK+ZQs6amjwvRO1Zuku1d7Cp
	 cCziZ38jX+ONYypscEdK/MGkOJW2ACJI/0Hrh/bLDOM4fS5j0gZ/WtmJ61UATeOiVaFfJ
	 7fbLUnYsTPxrq7OWdH694ICIOlzAkU2NJI1++kMNcVMqYN4KRJL+k/m/0IG+BCIuafA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021555;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QvfrT7nSGdzRM1m09LQcvYSaZXOm+3dnUQH3bd1LT7o=;
	b=x/1TlGzUtPJXzvyG4G41tPha/A0UzPFR0C/u+ozXvj2pqZjUNpimw5JKBgoC4iF3U9YR
	 QdBkqySzRiqXgnzG+939HUWHamx4iZnbZq/MkUU05k3Of+uiouj1WEXqVVy4xvkRu1djR
	 fw+0XfIyoAoaA/+ULdrI25K2H4nLObwoaqTTa7Ubal80yBF0q1ptEym3xr3b+Bgp2lv1n
	 mCskL1o8iz9GdDmX8mFaatjCXe/gjweNodze82rFK/1wNlUGdaiHV8Xfd08kEnqB1LHl1
	 Zd6VafhgH1FVN2YdYYcRgbebGrSai/arr5manC5LpL2AmWxwEQxxJhIdDe7ouMqQWKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TVHbgki1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA260606A33A;
	Wed, 18 Nov 2026 17:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TVHbgki1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37EE11F000C9;
	Wed, 18 Nov 2026 17:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021555;
	bh=QvfrT7nSGdzRM1m09LQcvYSaZXOm+3dnUQH3bd1LT7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TVHbgki1uphSjfqoiUrUqDy7VnjRfWkSAJS3Ko4Gf/2bcwbRBtkU1LTL+eu1eKc3x
	 Rv+iklCWBY/sayrGNIkNjjKrNbD6BtvhyJeb4QRNj3wqjzlTtQm42JjVOplHUCUwP7
	 wd7vFAUtwcLzsn+OKPqdAoYjWdb25veMmxYGFxbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Simon Horman <horms@kernel.org>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2348/2651] tipc: fix use-after-free of broadcast reception link at node release
Date: Wed, 18 Nov 2026 15:59:48 +0100
Message-ID: <20261118150409.594806812@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Binbin Deng <18983559317@163.com>

[ Upstream commit 473167593f42551ce6b00c05cee8cd20309d45ac ]

When the last reference to a tipc_node is dropped, the node itself is
deferred to the RCU callback tipc_node_free(), but the nested broadcast
reception link, n->bc_entry.link, is kfree()d synchronously in
tipc_node_kref_release(), before call_rcu(), and the pointer is never
cleared.  Readers that obtained the node from node_list and then
dereference bc_entry.link deep into the link (tipc_link_name() in
tipc_nl_node_reset_link_stats(), bcl->name/stats in
tipc_nl_add_bc_link() on the link dump path) therefore touch freed
memory although the enclosing node stays alive for a full grace period.
The sibling per-bearer links get "kfree + NULL" under the node write
lock in tipc_node_clear_links(); the broadcast entry was missed.

The race is reachable through the node cleanup timer: once a peer has
been unreachable for NODE_CLEANUP_AFTER (300 s), tipc_node_timeout() ->
tipc_node_cleanup() unlinks the node under the write lock, and the
final tipc_node_put() at the caller runs outside node_list_lock, so the
kfree executes in timer softirq context, concurrently with genl dump/
reset walkers that hold only rcu_read_lock().  (A netlink "peer remove"
cannot race those walkers itself: tipc_genl_family has no parallel_ops,
so all doit/dumpit calls serialize on the global genl lock.)

Reproduced in a QEMU/KVM guest running v7.3.0 with KASAN and
PREEMPT(full): 10 TIPC peer namespaces on veth bearers, bearer removal
staggered so the 300 s node cleanup timers expire while other tasks
loop link dumps with the broadcast filter and reset-link-stats lookups.
KASAN hit within two cleanup cycles:

  BUG: KASAN: slab-use-after-free in strlen+0x85/0xa0
  Read of size 1 at addr ffff88800b54a004 by task poc_eth/371
   strlen+0x85/0xa0
   tipc_nl_add_bc_link+0x2f9/0xd40
   __tipc_nl_add_node_links+0x10c/0x140
   tipc_nl_node_dump_link+0x8d5/0xd50
  Freed by task 0:
   kfree+0x121/0x380
   tipc_node_timeout+0xa33/0xcf0
   run_timer_softirq+0x144/0x250
   sysvec_apic_timer_interrupt

with the freed object being the kmalloc-1k tipc_link allocated by
tipc_link_bc_create() during peer discovery.  The same defect fires in
strcmp() called from tipc_nl_node_reset_link_stats().

Move the kfree of n->bc_entry.link into the tipc_node_free() RCU
callback so the broadcast link lives exactly as long as the enclosing
node.  All readers are covered: the netlink walkers are inside
rcu_read_lock(), and the packet reception path reaches the node via
tipc_node_find(), whose kref defers kref_release itself.

Found during a static-analysis-assisted audit: candidate sites were
surfaced by a Coccinelle rule, and the reader/writer paths were
confirmed by LLM-assisted (GLM-5.3) code inspection.

Fixes: d25a01257e42 ("tipc: fix crash during node removal")
Assisted-by: GLM-5.3 coccinelle
Signed-off-by: Binbin Deng <18983559317@163.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Link: https://patch.msgid.link/20261019104352.488347-1-18983559317@163.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/node.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index d7cbfa786c132..53b0993c2c233 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -303,6 +303,7 @@ static void tipc_node_free(struct rcu_head *rp)
 #ifdef CONFIG_TIPC_CRYPTO
 	tipc_crypto_stop(&n->crypto_rx);
 #endif
+	kfree(n->bc_entry.link);
 	kfree(n);
 }
 
@@ -310,7 +311,6 @@ static void tipc_node_kref_release(struct kref *kref)
 {
 	struct tipc_node *n = container_of(kref, struct tipc_node, kref);
 
-	kfree(n->bc_entry.link);
 	call_rcu(&n->rcu, tipc_node_free);
 }
 
-- 
2.53.0



