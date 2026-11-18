Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056744;
	b=MKS/8psfVF/PWJqrwV3VPA3usyS24B6/iU4HlZ89jaCmUMIC92twaSukbqIG23Cc1H5S
	 BPP75XiiXhyvEb1Ue1H4hs8rSWMD3n7lvN2j4ktNyEJ+C30zVpEDmIQEqGcbiLjHVCov3
	 khHI9FgZ1iahElrHdX9ht+cZYQis1jZQbG69YwD9Xv2mDvzzICafbFexA7wkTUbiXEx1l
	 X7uL8W1XP6IwrHhYeQxP3uXQnZdv89YlE8U7bX4wfa//WKlvEZS81ZwT2mwZFQvf7XJ0T
	 ZH/eLJAjRXR1C+z2G26LMbA8WQHIdktkwSPlgHL+Q3ky0K4j2WeVLTOtieQF1PPPC7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056744;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/PZmSmmfkRnLuj4Ur12CCjQBcsbxletOtx4/TdQgoq0=;
	b=kpS7rUANXwP0gSGKfHFtzs6gz+PzZObLtELOyBwQgmGXr8zm4tHMYPmNa+rypt0PN+iE
	 +cNcA7AkYRHNGQ9JKk7YnkduddTG3iY6lVzGfnjr7wGkiSypgZ5P/GZbbHWmt0NAaFQGb
	 o2/VI/poHiHfdIiPKewq8QfkdJ2Cvl0bj14UPZyRvKsT7PfmwqP7WIYs9Ih6FBzU6qYbd
	 oF8UMJCCnBYcuJXUFjEXaAvWEC1zHryG3dUHSWOo7PgUV0jcjplgm0cVK8ipgTFKD2K8z
	 KWIWcDaxz84ygTIClypRuIh/FGx7nPY+f2j6j0ftAIL7Uy6nfeejQklLDjL+jd/2P1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h4PTzjXj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F07606A31C;
	Thu, 19 Nov 2026 02:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h4PTzjXj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8219D1F000C4;
	Thu, 19 Nov 2026 02:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056744;
	bh=/PZmSmmfkRnLuj4Ur12CCjQBcsbxletOtx4/TdQgoq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h4PTzjXjPkbMSjlSFBTb7jHhmWUuvfOMBTSouHeqLn4YE3Qkv2jV51LMgQmXwVXvp
	 Bmraih4x2P65I2qapecLZj4Ds3KyvecN/65LVE5ENYyuN3h47QHoiGpQKopttM+IpH
	 6vIgcYYqUIXMe7LZCV5VTvontIGTCaZ3xX1CAzaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Simon Horman <horms@kernel.org>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2097/2214] tipc: fix use-after-free of broadcast reception link at node release
Date: Wed, 18 Nov 2026 16:02:53 +0100
Message-ID: <20261118150134.563782522@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e27e70c6366cd..7883fb65f7238 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -305,6 +305,7 @@ static void tipc_node_free(struct rcu_head *rp)
 #ifdef CONFIG_TIPC_CRYPTO
 	tipc_crypto_stop(&n->crypto_rx);
 #endif
+	kfree(n->bc_entry.link);
 	kfree(n);
 }
 
@@ -312,7 +313,6 @@ static void tipc_node_kref_release(struct kref *kref)
 {
 	struct tipc_node *n = container_of(kref, struct tipc_node, kref);
 
-	kfree(n->bc_entry.link);
 	call_rcu(&n->rcu, tipc_node_free);
 }
 
-- 
2.53.0



