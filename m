Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3904D17A2FC;
	Wed, 20 May 2026 18:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301952; cv=none; b=dmg7duRYwEtpH9gxQl3fDE98scxrWDIVgX6rqW7FP56DNllFLPr/jwfPB/cR/wKGXq8snBym2BCGYqWqwD9g0xMTgoF6eKPWNWstDwkkuNlL5YyC1heyq/qC2c0KeZIccjTozktY5YbCu4QydGHHNSN2R0kdBd28JOqYwleohAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301952; c=relaxed/simple;
	bh=jVlvgMqMZu4Nl3mCrgrXVgV0kBdQzeabY0/B8Qeihrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j4/lpiiefY5L+sKCCl+9vb5PBv9yh15Yh8BqZND60oZOY0XxA8smbt76rzLCzWF7ahozt7RwnF0LmfB+aOAeCmmY+ozAdN9fYtzQ8o9jzLq8nsy8mtEgpjonvZTV6gWmKT/rBUBrk/2rUPPocCfn349Z/VALRJItOEbWgkwENjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zq/dmYU6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zq/dmYU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DFED1F000E9;
	Wed, 20 May 2026 18:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301951;
	bh=3sEdDdUp+fHU4yL3t0MmHsY5bXZWLcy2VllCE1NyLrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zq/dmYU6PG0CWvG/xWWUYi+wkahujM0m1mUEb/rmISxtFlPqRM444LK2l9m5rumpZ
	 3l2upo4Z0PCKNuEj+khxjxk5lDAPPxrzqbtaKBhTHxMMWQLEE45rgToiej17wxsR8o
	 xMSYrZjJYe6DZWqOq1vnSY7suURJmGas1WQZKCW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/508] bpf: Use RCU-safe iteration in dev_map_redirect_multi() SKB path
Date: Wed, 20 May 2026 18:17:43 +0200
Message-ID: <20260520162059.461910515@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

[ Upstream commit 8ed82f807bb09d2c8455aaa665f2c6cb17bc6a19 ]

The DEVMAP_HASH branch in dev_map_redirect_multi() uses
hlist_for_each_entry_safe() to iterate hash buckets, but this function
runs under RCU protection (called from xdp_do_generic_redirect_map()
in softirq context). Concurrent writers (__dev_map_hash_update_elem,
dev_map_hash_delete_elem) modify the list using RCU primitives
(hlist_add_head_rcu, hlist_del_rcu).

hlist_for_each_entry_safe() performs plain pointer dereferences without
rcu_dereference(), missing the acquire barrier needed to pair with
writers' rcu_assign_pointer(). On weakly-ordered architectures (ARM64,
POWER), a reader can observe a partially-constructed node. It also
defeats CONFIG_PROVE_RCU lockdep validation and KCSAN data-race
detection.

Replace with hlist_for_each_entry_rcu() using rcu_read_lock_bh_held()
as the lockdep condition, consistent with the rcu_dereference_check()
used in the DEVMAP (non-hash) branch of the same functions. Also fix
the same incorrect lockdep_is_held(&dtab->index_lock) condition in
dev_map_enqueue_multi(), where the lock is not held either.

Fixes: e624d4ed4aa8 ("xdp: Extend xdp_redirect_map with broadcast support")
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://patch.msgid.link/20260320072645.16731-1-devnexen@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/devmap.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 3939221bd6098..c169f0624e100 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -642,7 +642,7 @@ int dev_map_enqueue_multi(struct xdp_frame *xdpf, struct net_device *dev_rx,
 		for (i = 0; i < dtab->n_buckets; i++) {
 			head = dev_map_index_hash(dtab, i);
 			hlist_for_each_entry_rcu(dst, head, index_hlist,
-						 lockdep_is_held(&dtab->index_lock)) {
+						rcu_read_lock_bh_held()) {
 				if (!is_valid_dst(dst, xdpf))
 					continue;
 
@@ -724,7 +724,6 @@ int dev_map_redirect_multi(struct net_device *dev, struct sk_buff *skb,
 	struct bpf_dtab_netdev *dst, *last_dst = NULL;
 	int excluded_devices[1+MAX_NEST_DEV];
 	struct hlist_head *head;
-	struct hlist_node *next;
 	int num_excluded = 0;
 	unsigned int i;
 	int err;
@@ -764,7 +763,7 @@ int dev_map_redirect_multi(struct net_device *dev, struct sk_buff *skb,
 	} else { /* BPF_MAP_TYPE_DEVMAP_HASH */
 		for (i = 0; i < dtab->n_buckets; i++) {
 			head = dev_map_index_hash(dtab, i);
-			hlist_for_each_entry_safe(dst, next, head, index_hlist) {
+			hlist_for_each_entry_rcu(dst, head, index_hlist, rcu_read_lock_bh_held()) {
 				if (is_ifindex_excluded(excluded_devices, num_excluded,
 							dst->dev->ifindex))
 					continue;
-- 
2.53.0



