Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF462D7BF;
	Tue,  3 Dec 2024 15:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239384; cv=none; b=aGVUSeOk/rOrKsmC2Lqf/SWA90LPQyqa05WbofGn1dwNtUmikflrJhK08W/zPqxIn55grrZjzJEsJCYRUUerPSiWn5V3ZsL/UdmEVKLhcMRYO7+rpLDW9I6n0Yr7jwAUQoXT8qD+anydpuqJQHmX79mWngf4Xy/7wLaejZaRyPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239384; c=relaxed/simple;
	bh=GBlINIzAdqJ8m5sWxIljc0MLmE0GyQumEeJ0PtJ8UHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PUWOJFRWVMGiuZEAMojo3HktzRp9SxROQws4Ylyv64shUirT12SoSXrvy/hZ364bouxrp9SssAsLPoRjFFH1rji3AXVjVUG9qQ2gn4AQOGkAU9xNlFM70KEB77ZMq9JOIaTU88ffdKi+jLfTmQv2Nfc0esk8/tAZaG8gv/rXvYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iN84NRSz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iN84NRSz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080DFC4CECF;
	Tue,  3 Dec 2024 15:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239384;
	bh=GBlINIzAdqJ8m5sWxIljc0MLmE0GyQumEeJ0PtJ8UHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iN84NRSzY00jgrJGaRGyZn2owsSFRax1ACNfic8zcOWm3ZqkxVAjeW6fRadaWSFIN
	 X4dADeKnHOXNkidbGmZnamHo8AHsMdieoQPaQY8/nURwgVxp+cc8dl/qVRFB9Uxj0C
	 UyPMkkvYJldd2HjiLWvm3F3d8es5M652iRijFs3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 595/817] ip6mr: fix tables suspicious RCU usage
Date: Tue,  3 Dec 2024 15:42:47 +0100
Message-ID: <20241203144019.149814050@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index dd342e6ecf3f4..f2b1e9210905b 100644
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
@@ -2560,7 +2576,7 @@ static int ip6mr_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 		grp = nla_get_in6_addr(tb[RTA_DST]);
 	tableid = tb[RTA_TABLE] ? nla_get_u32(tb[RTA_TABLE]) : 0;
 
-	mrt = ip6mr_get_table(net, tableid ?: RT_TABLE_DEFAULT);
+	mrt = __ip6mr_get_table(net, tableid ?: RT_TABLE_DEFAULT);
 	if (!mrt) {
 		NL_SET_ERR_MSG_MOD(extack, "MR table does not exist");
 		return -ENOENT;
@@ -2607,7 +2623,7 @@ static int ip6mr_rtm_dumproute(struct sk_buff *skb, struct netlink_callback *cb)
 	if (filter.table_id) {
 		struct mr_table *mrt;
 
-		mrt = ip6mr_get_table(sock_net(skb->sk), filter.table_id);
+		mrt = __ip6mr_get_table(sock_net(skb->sk), filter.table_id);
 		if (!mrt) {
 			if (rtnl_msg_family(cb->nlh) != RTNL_FAMILY_IP6MR)
 				return skb->len;
-- 
2.43.0



