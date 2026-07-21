Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B8639768C;
	Tue, 21 Jul 2026 22:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672167; cv=none; b=g91JzOs0kMr1qfVb+NxpxFeXA+tDv29DD/lFHbhrY7Jh7hoxv4JcRB5wlerwsmkcIUfXkLpS0nyAvvW0QyfCYNhLZDbSybfVKqKf0yG2pdlOT1aG46OSZrAcVUK1qym9uZIJu99j7ZkNjLwzHzjjSbLEcmZtSpy57uLqFi4FBoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672167; c=relaxed/simple;
	bh=lonbwLpQLlNPbPogPcz1H6sIIidyjX6uL/6NwlbkVb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eD8doitKk1COlhtqk+LBBs23AKsl3EULAPwsclxkEHCd5xGPjmAuJgPaawVew7CEUj6CtFB7zOXQ65RT76Qs+DrbdnkQySLRZAY/9UKsSDGyTUODC5D5Wthg4ruJk+gZyOcrrZjx6RVpCTs6jMrWYdEfv6NyUrx5rlvAF8GrWQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Udsk4aez; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Udsk4aez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DC41F000E9;
	Tue, 21 Jul 2026 22:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672166;
	bh=DIcUOMZXPEnqh7Vel2l9p9sdQXvH17tWrvWq9+HLDWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Udsk4aezn9FNa/WHk8EYRtqqwv7pBSwTPkN5k0GXhANlXrtXctS4SjOpaB0qZRJFx
	 CdptSXfEfZ4NmUH11AY4kIOX2YI1RIWVSFgmxXUhEB2CO7+5GWA032OKwxqAXLJLUJ
	 K5atXEUxYD26FtsAlxDYs9rqqP51xMX/jjxMIh5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 495/843] ipv6: remove RTNL protection from inet6_dump_fib()
Date: Tue, 21 Jul 2026 17:22:10 +0200
Message-ID: <20260721152417.169186663@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5fc68320c1fb3c7d456ddcae0b4757326a043e6f ]

No longer hold RTNL while calling inet6_dump_fib().

Also change return value for a completed dump,
so that NLMSG_DONE can be appended to current skb,
saving one recvmsg() system call.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20240329183053.644630-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 9facb861dc6b ("ipv6: fib6: fix NULL deref in fib6_walk_continue() on multi-batch dump")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_fib.c | 51 +++++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index ba8fc26b86142f..3dbc6d582325c6 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -620,23 +620,22 @@ static int inet6_dump_fib(struct sk_buff *skb, struct netlink_callback *cb)
 	struct rt6_rtnl_dump_arg arg = {
 		.filter.dump_exceptions = true,
 		.filter.dump_routes = true,
-		.filter.rtnl_held = true,
+		.filter.rtnl_held = false,
 	};
 	const struct nlmsghdr *nlh = cb->nlh;
 	struct net *net = sock_net(skb->sk);
-	unsigned int h, s_h;
 	unsigned int e = 0, s_e;
+	struct hlist_head *head;
 	struct fib6_walker *w;
 	struct fib6_table *tb;
-	struct hlist_head *head;
-	int res = 0;
+	unsigned int h, s_h;
+	int err = 0;
 
+	rcu_read_lock();
 	if (cb->strict_check) {
-		int err;
-
 		err = ip_valid_fib_dump_req(net, nlh, &arg.filter, cb);
 		if (err < 0)
-			return err;
+			goto unlock;
 	} else if (nlmsg_len(nlh) >= sizeof(struct rtmsg)) {
 		struct rtmsg *rtm = nlmsg_data(nlh);
 
@@ -651,8 +650,10 @@ static int inet6_dump_fib(struct sk_buff *skb, struct netlink_callback *cb)
 		 * 1. allocate and initialize walker.
 		 */
 		w = kzalloc(sizeof(*w), GFP_ATOMIC);
-		if (!w)
-			return -ENOMEM;
+		if (!w) {
+			err = -ENOMEM;
+			goto unlock;
+		}
 		w->func = fib6_dump_node;
 		cb->args[2] = (long)w;
 
@@ -672,46 +673,46 @@ static int inet6_dump_fib(struct sk_buff *skb, struct netlink_callback *cb)
 		tb = fib6_get_table(net, arg.filter.table_id);
 		if (!tb) {
 			if (rtnl_msg_family(cb->nlh) != PF_INET6)
-				goto out;
+				goto unlock;
 
 			NL_SET_ERR_MSG_MOD(cb->extack, "FIB table does not exist");
-			return -ENOENT;
+			err = -ENOENT;
+			goto unlock;
 		}
 
 		if (!cb->args[0]) {
-			res = fib6_dump_table(tb, skb, cb);
-			if (!res)
+			err = fib6_dump_table(tb, skb, cb);
+			if (!err)
 				cb->args[0] = 1;
 		}
-		goto out;
+		goto unlock;
 	}
 
 	s_h = cb->args[0];
 	s_e = cb->args[1];
 
-	rcu_read_lock();
 	for (h = s_h; h < FIB6_TABLE_HASHSZ; h++, s_e = 0) {
 		e = 0;
 		head = &net->ipv6.fib_table_hash[h];
 		hlist_for_each_entry_rcu(tb, head, tb6_hlist) {
 			if (e < s_e)
 				goto next;
-			res = fib6_dump_table(tb, skb, cb);
-			if (res != 0)
-				goto out_unlock;
+			err = fib6_dump_table(tb, skb, cb);
+			if (err != 0)
+				goto out;
 next:
 			e++;
 		}
 	}
-out_unlock:
-	rcu_read_unlock();
+out:
 	cb->args[1] = e;
 	cb->args[0] = h;
-out:
-	res = res < 0 ? res : skb->len;
-	if (res <= 0)
+
+unlock:
+	rcu_read_unlock();
+	if (err <= 0)
 		fib6_dump_end(cb);
-	return res;
+	return err;
 }
 
 void fib6_metric_set(struct fib6_info *f6i, int metric, u32 val)
@@ -2466,7 +2467,7 @@ int __init fib6_init(void)
 		goto out_kmem_cache_create;
 
 	ret = rtnl_register_module(THIS_MODULE, PF_INET6, RTM_GETROUTE, NULL,
-				   inet6_dump_fib, 0);
+				   inet6_dump_fib, RTNL_FLAG_DUMP_UNLOCKED);
 	if (ret)
 		goto out_unregister_subsys;
 
-- 
2.53.0



