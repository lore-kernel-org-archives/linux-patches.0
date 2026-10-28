Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215700;
	b=Y1ZkJbNCTeUUyBO5leEFTjVenXRy1lckkXnvkLveYzNwFcbdoBZUZVZbF9jbA5EsvFiU
	 vjbKZQZsL1WAydAi4D0Romcz1GSH+mhEw0f0xIu81a3CF4h+xc0+h7xMgJg1BH+U+1Lvc
	 BFV6+IrkPeOWTmyuvP8M2Rs27Wve6/NSj1HRoXWMn3Er6Cs/+RYOFdrStjGQqF0YpR5hi
	 ExWOD+MF0S1sBbvi4LFP1EJeVjJrJQxP/rsk9XouF+5mO68BckBGHXmnFxEA/VqOdeJYp
	 b4+fMHHbQKJOU1d8w4BMAwG74nueRxJXklBgSZRo2ZGXaQ+RCAeg3KHiKMO4Pi3uyxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215700;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7iMVWxmMAlow44whxvtBtqoeynsR40d8oRHqgxva4Os=;
	b=t1owpeV7ZBMTvgiQZXs8xHvlTZnGCWtH55TKndGE5Yvqf+cHQyHZDhxWqOX069VblL7g
	 LQV4Te1XlnkxnP2/9OagVQsZmCm7Kpxvrbqs/h+LGoOnt2z/s+lD1ol9lJqWynWSNHvNj
	 7Ireu+2IoSMJN5PP0KCHTKS52yLRXENl/N+ESq6gaJ2oqCFnZIM6vhd9W2iB9oWUpFxqD
	 uQGd+W8uKgWiUIA+vkNLp2EJhhgHcDWrAw+JCESzJoMG0t8ifpRJzExrN26N4vE+BpI7J
	 eHucQzIRsGqWvPoAh/rqf4oPeiJtSZAL8IAJHKQLChcQsxCg84Y6PwOj2GJn9PfwcOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D0LzZnLt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F73606A326;
	Wed, 28 Oct 2026 19:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D0LzZnLt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88AC31F01825;
	Wed, 28 Oct 2026 19:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215700;
	bh=7iMVWxmMAlow44whxvtBtqoeynsR40d8oRHqgxva4Os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D0LzZnLt6sD+9cyVFoIAfUKAm6eGybxHbCj/M/PJehFQE9ePIPDdC03cs57BHdfJ8
	 tZNWtQsTYdfxtMf0vgw2SOm+OjaJPnS2mYBqxEix160lSxwtyGkHCY4kMUoLc3k+fD
	 4ft+BLyZSseH8syHdgSUuqO9Urg5CC4uAHjhfaDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1301/1887] bpf: Fix netns reference imbalance in conntrack kfuncs
Date: Wed, 28 Oct 2026 17:56:37 +0100
Message-ID: <20261028170529.035753600@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <nicoyip.dev@gmail.com>

[ Upstream commit fdeba03fea78407a8c52faa99177c9f7f29f90eb ]

The opts argument of the BPF conntrack kfuncs can point to a shared
map value.  __bpf_nf_ct_lookup() and __bpf_nf_ct_alloc_entry() read
opts->netns_id separately when acquiring and releasing the network
namespace reference.

The reference imbalance can occur as follows:

  CPU 0                                  CPU 1
  read opts->netns_id (-1)
  skip get_net_ns_by_id()
                                         write opts->netns_id (id)
  read opts->netns_id (id)
  put_net(net) /* no matching get */

The reverse transition leaks the reference.  Repeating the unmatched put
can destroy a live namespace and crash later users.

The kernel reported:

  Oops: general protection fault, probably for non-canonical address
  KASAN: null-ptr-deref in range [0x00000000000000e8-0x00000000000000ef]
  RIP: 0010:bpf_prog_test_run_xdp+0x52c/0x1700
  Call Trace:
   __sys_bpf+0x1662/0x50c0
   __x64_sys_bpf+0x73/0xb0
   do_syscall_64+0xf9/0x540
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  Kernel panic - not syncing: Fatal exception

Snapshot every input field of opts with READ_ONCE() before validating or
using it.  The netns_id snapshot keeps the namespace get/put pair
balanced, while the other snapshots keep the remaining options from
changing partway through an invocation.  The individual reads can still
observe an inconsistent combination during a concurrent update, but each
selected field value remains stable for that invocation.

Fixes: aed8ee7feb44 ("net: netfilter: Deduplicate code in bpf_{xdp,skb}_ct_lookup")
Fixes: d7e79c97c00c ("net: netfilter: Add kfuncs to allocate and insert CT")
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Link: https://lore.kernel.org/bpf/20260731160921.3245840-1-nicoyip.dev@gmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_bpf.c | 42 ++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index 88ab73db654ae..2cea115c9c9d6 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -113,27 +113,32 @@ __bpf_nf_ct_alloc_entry(struct net *net, struct bpf_sock_tuple *bpf_tuple,
 {
 	struct nf_conntrack_tuple otuple, rtuple;
 	struct nf_conn *ct;
+	s32 netns_id;
+	u8 l4proto;
 	int err;
 
-	if (!opts || !bpf_tuple || opts->reserved[0] || opts->reserved[1] ||
-	    opts_len != NF_BPF_CT_OPTS_SZ)
+	if (!opts || !bpf_tuple || READ_ONCE(opts->reserved[0]) ||
+	    READ_ONCE(opts->reserved[1]) || opts_len != NF_BPF_CT_OPTS_SZ)
 		return ERR_PTR(-EINVAL);
 
-	if (unlikely(opts->netns_id < BPF_F_CURRENT_NETNS))
+	netns_id = READ_ONCE(opts->netns_id);
+	l4proto = READ_ONCE(opts->l4proto);
+
+	if (unlikely(netns_id < BPF_F_CURRENT_NETNS))
 		return ERR_PTR(-EINVAL);
 
-	err = bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, opts->l4proto,
+	err = bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, l4proto,
 				    IP_CT_DIR_ORIGINAL, &otuple);
 	if (err < 0)
 		return ERR_PTR(err);
 
-	err = bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, opts->l4proto,
+	err = bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, l4proto,
 				    IP_CT_DIR_REPLY, &rtuple);
 	if (err < 0)
 		return ERR_PTR(err);
 
-	if (opts->netns_id >= 0) {
-		net = get_net_ns_by_id(net, opts->netns_id);
+	if (netns_id >= 0) {
+		net = get_net_ns_by_id(net, netns_id);
 		if (unlikely(!net))
 			return ERR_PTR(-ENONET);
 	}
@@ -147,7 +152,7 @@ __bpf_nf_ct_alloc_entry(struct net *net, struct bpf_sock_tuple *bpf_tuple,
 	__nf_ct_set_timeout(ct, timeout * HZ);
 
 out:
-	if (opts->netns_id >= 0)
+	if (netns_id >= 0)
 		put_net(net);
 
 	return ct;
@@ -161,29 +166,34 @@ static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
 	struct nf_conntrack_tuple_hash *hash;
 	struct nf_conntrack_tuple tuple;
 	struct nf_conn *ct;
+	s32 netns_id;
+	u8 l4proto;
 	int err;
 
-	if (!opts || !bpf_tuple || opts->reserved[0] || opts->reserved[1] ||
-	    opts_len != NF_BPF_CT_OPTS_SZ)
+	if (!opts || !bpf_tuple || READ_ONCE(opts->reserved[0]) ||
+	    READ_ONCE(opts->reserved[1]) || opts_len != NF_BPF_CT_OPTS_SZ)
 		return ERR_PTR(-EINVAL);
-	if (unlikely(opts->l4proto != IPPROTO_TCP && opts->l4proto != IPPROTO_UDP))
+
+	netns_id = READ_ONCE(opts->netns_id);
+	l4proto = READ_ONCE(opts->l4proto);
+	if (unlikely(l4proto != IPPROTO_TCP && l4proto != IPPROTO_UDP))
 		return ERR_PTR(-EPROTO);
-	if (unlikely(opts->netns_id < BPF_F_CURRENT_NETNS))
+	if (unlikely(netns_id < BPF_F_CURRENT_NETNS))
 		return ERR_PTR(-EINVAL);
 
-	err = bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, opts->l4proto,
+	err = bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, l4proto,
 				    IP_CT_DIR_ORIGINAL, &tuple);
 	if (err < 0)
 		return ERR_PTR(err);
 
-	if (opts->netns_id >= 0) {
-		net = get_net_ns_by_id(net, opts->netns_id);
+	if (netns_id >= 0) {
+		net = get_net_ns_by_id(net, netns_id);
 		if (unlikely(!net))
 			return ERR_PTR(-ENONET);
 	}
 
 	hash = nf_conntrack_find_get(net, &nf_ct_zone_dflt, &tuple);
-	if (opts->netns_id >= 0)
+	if (netns_id >= 0)
 		put_net(net);
 	if (!hash)
 		return ERR_PTR(-ENOENT);
-- 
2.53.0



