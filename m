Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE591F76BF;
	Tue,  3 Dec 2024 16:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242032; cv=none; b=k2iDTUU7ue6iwtYcVjefohACQ1Nral+WGBY8mABnPe2NnK8z08gpXRzkeE71spSeTko9IJextAs8hgivKXxOF2wjDgcp2CF/fFk2cUwNjsHlbc8GFGT/1qXxgaBpFnEdFX8AnZYBFtQUm58uvYMzZBwdWo/wZAoih63eCRqCZ9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242032; c=relaxed/simple;
	bh=lV0eZaTXVpSSNwVhWNkWfPT39l5mxLsAQ/ntGb3AfhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i3XvrT6fMVBDXpPZBwQWj/pWkcmYRzncBULf8tFosMxwfD23aiR+tiSlmpNYbSoRUJN8tA09Y234B4kDnYId8rDIbvmRkoKJuxOZcMK8D76RRE4stlpSEnriNdq30cCoCHL63QMWsbSxplfSk5YjABYeLeq3hm5unR1gw8gnibE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VMaX4pFM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VMaX4pFM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D16BC4CECF;
	Tue,  3 Dec 2024 16:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242031;
	bh=lV0eZaTXVpSSNwVhWNkWfPT39l5mxLsAQ/ntGb3AfhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VMaX4pFMW0FcrwF8Kz7S05sicxrGyPFOnWfPmShc1L5G9aGPH1TgjMY/5exsBBaE3
	 OX3itmrKuFiGwJR/8mElA6hehM74sCEOyiaNP9yEG009qzmpIg8dexEv720MELeWEW
	 4H2/8iK/0w0Biwu2Arr2WoQKs1axFN4KkRDLfnZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 588/826] ip6mr: fix tables suspicious RCU usage
Date: Tue,  3 Dec 2024 15:45:15 +0100
Message-ID: <20241203144806.686563766@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit f1553c9894b4dbeb10a2ab15ab1aa113b3b4047c ]

Several places call ip6mr_get_table() with no RCU nor RTNL lock.
Add RCU protection inside such helper and provide a lockless variant
for the few callers that already acquired the relevant lock.

Note that some users additionally reference the table outside the RCU
lock. That is actually safe as the table deletion can happen only
after all table accesses are completed.

Fixes: e2d57766e674 ("net: Provide compat support for SIOCGETMIFCNT_IN6 and SIOCGETSGCNT_IN6.")
Fixes: d7c31cbde4bc ("net: ip6mr: add RTM_GETROUTE netlink op")
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6mr.c | 38 +++++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 2ce4ae0d8dc3b..d5057401701c1 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -125,7 +125,7 @@ static struct mr_table *ip6mr_mr_table_iter(struct net *net,
 	return ret;
 }
 
-static struct mr_table *ip6mr_get_table(struct net *net, u32 id)
+static struct mr_table *__ip6mr_get_table(struct net *net, u32 id)
 {
 	struct mr_table *mrt;
 
@@ -136,6 +136,16 @@ static struct mr_table *ip6mr_get_table(struct net *net, u32 id)
 	return NULL;
 }
 
+static struct mr_table *ip6mr_get_table(struct net *net, u32 id)
+{
+	struct mr_table *mrt;
+
+	rcu_read_lock();
+	mrt = __ip6mr_get_table(net, id);
+	rcu_read_unlock();
+	return mrt;
+}
+
 static int ip6mr_fib_lookup(struct net *net, struct flowi6 *flp6,
 			    struct mr_table **mrt)
 {
@@ -177,7 +187,7 @@ static int ip6mr_rule_action(struct fib_rule *rule, struct flowi *flp,
 
 	arg->table = fib_rule_get_table(rule, arg);
 
-	mrt = ip6mr_get_table(rule->fr_net, arg->table);
+	mrt = __ip6mr_get_table(rule->fr_net, arg->table);
 	if (!mrt)
 		return -EAGAIN;
 	res->mrt = mrt;
@@ -304,6 +314,8 @@ static struct mr_table *ip6mr_get_table(struct net *net, u32 id)
 	return net->ipv6.mrt6;
 }
 
+#define __ip6mr_get_table ip6mr_get_table
+
 static int ip6mr_fib_lookup(struct net *net, struct flowi6 *flp6,
 			    struct mr_table **mrt)
 {
@@ -382,7 +394,7 @@ static struct mr_table *ip6mr_new_table(struct net *net, u32 id)
 {
 	struct mr_table *mrt;
 
-	mrt = ip6mr_get_table(net, id);
+	mrt = __ip6mr_get_table(net, id);
 	if (mrt)
 		return mrt;
 
@@ -411,13 +423,15 @@ static void *ip6mr_vif_seq_start(struct seq_file *seq, loff_t *pos)
 	struct net *net = seq_file_net(seq);
 	struct mr_table *mrt;
 
-	mrt = ip6mr_get_table(net, RT6_TABLE_DFLT);
-	if (!mrt)
+	rcu_read_lock();
+	mrt = __ip6mr_get_table(net, RT6_TABLE_DFLT);
+	if (!mrt) {
+		rcu_read_unlock();
 		return ERR_PTR(-ENOENT);
+	}
 
 	iter->mrt = mrt;
 
-	rcu_read_lock();
 	return mr_vif_seq_start(seq, pos);
 }
 
@@ -2275,11 +2289,13 @@ int ip6mr_get_route(struct net *net, struct sk_buff *skb, struct rtmsg *rtm,
 	struct mfc6_cache *cache;
 	struct rt6_info *rt = dst_rt6_info(skb_dst(skb));
 
-	mrt = ip6mr_get_table(net, RT6_TABLE_DFLT);
-	if (!mrt)
+	rcu_read_lock();
+	mrt = __ip6mr_get_table(net, RT6_TABLE_DFLT);
+	if (!mrt) {
+		rcu_read_unlock();
 		return -ENOENT;
+	}
 
-	rcu_read_lock();
 	cache = ip6mr_cache_find(mrt, &rt->rt6i_src.addr, &rt->rt6i_dst.addr);
 	if (!cache && skb->dev) {
 		int vif = ip6mr_find_vif(mrt, skb->dev);
@@ -2559,7 +2575,7 @@ static int ip6mr_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 		grp = nla_get_in6_addr(tb[RTA_DST]);
 	tableid = tb[RTA_TABLE] ? nla_get_u32(tb[RTA_TABLE]) : 0;
 
-	mrt = ip6mr_get_table(net, tableid ?: RT_TABLE_DEFAULT);
+	mrt = __ip6mr_get_table(net, tableid ?: RT_TABLE_DEFAULT);
 	if (!mrt) {
 		NL_SET_ERR_MSG_MOD(extack, "MR table does not exist");
 		return -ENOENT;
@@ -2606,7 +2622,7 @@ static int ip6mr_rtm_dumproute(struct sk_buff *skb, struct netlink_callback *cb)
 	if (filter.table_id) {
 		struct mr_table *mrt;
 
-		mrt = ip6mr_get_table(sock_net(skb->sk), filter.table_id);
+		mrt = __ip6mr_get_table(sock_net(skb->sk), filter.table_id);
 		if (!mrt) {
 			if (rtnl_msg_family(cb->nlh) != RTNL_FAMILY_IP6MR)
 				return skb->len;
-- 
2.43.0



