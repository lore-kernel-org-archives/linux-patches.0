Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032856;
	b=gphrM/Lk4/4i7Prwo/SpiaOvfy+ZbOjK2RE0aW+DKcOL7lgP0C1ZC8arc1bjEv7cLMzO
	 v4OcneqzZWZyJcGDAqkmCzBSmPhELO7M9RigWGRfH1LFIKehY+j1dWKy58+ql/jZwxR0l
	 Hi3cS7jgj7qxzUsymzj2MvVc67dgqcM+OR5oQeaFPAAV650J776lxMkybFDdDzbR5sRVw
	 g9hRF3zyzK61/oaP3MYL00aR0uJ8v5BlIetkpDgceH0e2sUESVWR/Ljr9Rj0DubcAaA2b
	 DEf8o9bpWPaTb+382GoDAJBN8xCgAHr2VPWGez98FA8GD1QMWdlk+i8V4bk+NPJemGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032856;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s6BSp8GGqCwSIiABmzI4GGBR+MpfS8lGe6UkJt724j8=;
	b=H9gfjx1rA4Dge6btqQB7C67tqwJKiDcT+0oiakoOY/dtnRYkZGxhPYADf2cxy2Jpuqgi
	 U3uo6qe8es5WyBrdtxn6G8N7BvUwPVRYc/SG5HsKmut3+xGc5N214QATyDyYnGM+2SQiU
	 g/zUg9c4abegMT23akWcmDtADlY/Ax1ZkPmQUaxOmeFBbHIEnIm/h44074DyrhWQ7V2Dj
	 qf0ZG+hU+yRpMDHuZKj+MYt0H60fHhQU2C3SiP7CJTkZsGa3Y0F4CuUxZdzL6mZffSsI/
	 bAZzkoK8gPZC0a+1gGm2NAxfvnizKFVlucTgqK2BYZZAfX3I4XkgBGjcBdgYWk3VgCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="SQd/ezSZ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDF260A263C;
	Wed, 18 Nov 2026 20:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SQd/ezSZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE671F000C4;
	Wed, 18 Nov 2026 20:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032856;
	bh=s6BSp8GGqCwSIiABmzI4GGBR+MpfS8lGe6UkJt724j8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SQd/ezSZdTvup6vw7uiYQGYxY5W6nOHfSU25C5N0Q6NbSZbRbI24+20rOL8jyJ857
	 afR+sL3L3Qe+iNlj80+9GYvdMlbiqnWswsQLOUv9kzDWrxdMTv0dp0LBBfMEF3OIIc
	 xk7yq4yzXcV4tSrSJbMKyXL8lIFx1J88M4/QhPa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Simon Horman <horms@kernel.org>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1517/1756] tipc: fix use-after-free of broadcast reception link at node release
Date: Wed, 18 Nov 2026 16:00:44 +0100
Message-ID: <20261118150109.260802041@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8807fd60e800f..f813ca2a39513 100644
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



