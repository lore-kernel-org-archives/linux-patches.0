Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A89920967D;
	Thu, 12 Dec 2024 17:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024235; cv=none; b=kvK932rpmdnWYxtZUmvgLfSgTf8FgtQjRR02koIxbwZ0GRXVuVsin0Tm9IjzqM/7YzK6rJbly7v8Nd3k84OVOs1M/wCiuKuITF3RohpjFvTi+PVvNbcMStFeeiKfdBwLW1wSeH9CESAivzJ+S5My8xkcbUHCPTAXMOarPnR9MFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024235; c=relaxed/simple;
	bh=WqIn/tiZ0dCgP+we40bIj0zcIwLDkDPQLnBoreC/YJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=puojc2GIlrkSNHHkCZKO6I5OYRxbVhFZ3T4WEbziTFyfv1js9M7aX3tQOeU3k78yhtQ/ocpV/7Y0RoHtSaQ0iSUCXoL2cMWFXFe0QQX52NWiQOeBDW062aiMF4zTSpVQqP69wUrZUjMTFDR3GIGxKkGumsZj7eTJIJZAB84XzcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1XR+0oxG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1XR+0oxG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746FBC4CECE;
	Thu, 12 Dec 2024 17:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024234;
	bh=WqIn/tiZ0dCgP+we40bIj0zcIwLDkDPQLnBoreC/YJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1XR+0oxGxu5KWGLGDTSCb9RlTxnxDknxWguFRfcQCRd6eLU8XG70eUpjCDVTHlRvC
	 y0o/ri8iV6uFO1NinzFj1ur/T4tbcgiQ9oo1ByPZOcSGlwN9BQNfd5K/A5ByK5ztx1
	 9FtjnhvjIBy3kjKV6JJJNHj9zGxSRHWc+dYeHJpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 230/459] ipmr: fix tables suspicious RCU usage
Date: Thu, 12 Dec 2024 15:59:28 +0100
Message-ID: <20241212144302.654799835@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit fc9c273d6daaa9866f349bbe8cae25c67764c456 ]

Similar to the previous patch, plumb the RCU lock inside
the ipmr_get_table(), provided a lockless variant and apply
the latter in the few spots were the lock is already held.

Fixes: 709b46e8d90b ("net: Add compat ioctl support for the ipv4 multicast ioctl SIOCGETSGCNT")
Fixes: f0ad0860d01e ("ipv4: ipmr: support multiple tables")
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ipmr.c | 42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index fe3d23611a297..6e4f91e76e2d3 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -131,7 +131,7 @@ static struct mr_table *ipmr_mr_table_iter(struct net *net,
 	return ret;
 }
 
-static struct mr_table *ipmr_get_table(struct net *net, u32 id)
+static struct mr_table *__ipmr_get_table(struct net *net, u32 id)
 {
 	struct mr_table *mrt;
 
@@ -142,6 +142,16 @@ static struct mr_table *ipmr_get_table(struct net *net, u32 id)
 	return NULL;
 }
 
+static struct mr_table *ipmr_get_table(struct net *net, u32 id)
+{
+	struct mr_table *mrt;
+
+	rcu_read_lock();
+	mrt = __ipmr_get_table(net, id);
+	rcu_read_unlock();
+	return mrt;
+}
+
 static int ipmr_fib_lookup(struct net *net, struct flowi4 *flp4,
 			   struct mr_table **mrt)
 {
@@ -183,7 +193,7 @@ static int ipmr_rule_action(struct fib_rule *rule, struct flowi *flp,
 
 	arg->table = fib_rule_get_table(rule, arg);
 
-	mrt = ipmr_get_table(rule->fr_net, arg->table);
+	mrt = __ipmr_get_table(rule->fr_net, arg->table);
 	if (!mrt)
 		return -EAGAIN;
 	res->mrt = mrt;
@@ -315,6 +325,8 @@ static struct mr_table *ipmr_get_table(struct net *net, u32 id)
 	return net->ipv4.mrt;
 }
 
+#define __ipmr_get_table ipmr_get_table
+
 static int ipmr_fib_lookup(struct net *net, struct flowi4 *flp4,
 			   struct mr_table **mrt)
 {
@@ -404,7 +416,7 @@ static struct mr_table *ipmr_new_table(struct net *net, u32 id)
 	if (id != RT_TABLE_DEFAULT && id >= 1000000000)
 		return ERR_PTR(-EINVAL);
 
-	mrt = ipmr_get_table(net, id);
+	mrt = __ipmr_get_table(net, id);
 	if (mrt)
 		return mrt;
 
@@ -1366,7 +1378,7 @@ int ip_mroute_setsockopt(struct sock *sk, int optname, sockptr_t optval,
 		goto out_unlock;
 	}
 
-	mrt = ipmr_get_table(net, raw_sk(sk)->ipmr_table ? : RT_TABLE_DEFAULT);
+	mrt = __ipmr_get_table(net, raw_sk(sk)->ipmr_table ? : RT_TABLE_DEFAULT);
 	if (!mrt) {
 		ret = -ENOENT;
 		goto out_unlock;
@@ -2242,11 +2254,13 @@ int ipmr_get_route(struct net *net, struct sk_buff *skb,
 	struct mr_table *mrt;
 	int err;
 
-	mrt = ipmr_get_table(net, RT_TABLE_DEFAULT);
-	if (!mrt)
+	rcu_read_lock();
+	mrt = __ipmr_get_table(net, RT_TABLE_DEFAULT);
+	if (!mrt) {
+		rcu_read_unlock();
 		return -ENOENT;
+	}
 
-	rcu_read_lock();
 	cache = ipmr_cache_find(mrt, saddr, daddr);
 	if (!cache && skb->dev) {
 		int vif = ipmr_find_vif(mrt, skb->dev);
@@ -2537,7 +2551,7 @@ static int ipmr_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 	grp = tb[RTA_DST] ? nla_get_in_addr(tb[RTA_DST]) : 0;
 	tableid = tb[RTA_TABLE] ? nla_get_u32(tb[RTA_TABLE]) : 0;
 
-	mrt = ipmr_get_table(net, tableid ? tableid : RT_TABLE_DEFAULT);
+	mrt = __ipmr_get_table(net, tableid ? tableid : RT_TABLE_DEFAULT);
 	if (!mrt) {
 		err = -ENOENT;
 		goto errout_free;
@@ -2589,7 +2603,7 @@ static int ipmr_rtm_dumproute(struct sk_buff *skb, struct netlink_callback *cb)
 	if (filter.table_id) {
 		struct mr_table *mrt;
 
-		mrt = ipmr_get_table(sock_net(skb->sk), filter.table_id);
+		mrt = __ipmr_get_table(sock_net(skb->sk), filter.table_id);
 		if (!mrt) {
 			if (rtnl_msg_family(cb->nlh) != RTNL_FAMILY_IPMR)
 				return skb->len;
@@ -2697,7 +2711,7 @@ static int rtm_to_ipmr_mfcc(struct net *net, struct nlmsghdr *nlh,
 			break;
 		}
 	}
-	mrt = ipmr_get_table(net, tblid);
+	mrt = __ipmr_get_table(net, tblid);
 	if (!mrt) {
 		ret = -ENOENT;
 		goto out;
@@ -2902,13 +2916,15 @@ static void *ipmr_vif_seq_start(struct seq_file *seq, loff_t *pos)
 	struct net *net = seq_file_net(seq);
 	struct mr_table *mrt;
 
-	mrt = ipmr_get_table(net, RT_TABLE_DEFAULT);
-	if (!mrt)
+	rcu_read_lock();
+	mrt = __ipmr_get_table(net, RT_TABLE_DEFAULT);
+	if (!mrt) {
+		rcu_read_unlock();
 		return ERR_PTR(-ENOENT);
+	}
 
 	iter->mrt = mrt;
 
-	rcu_read_lock();
 	return mr_vif_seq_start(seq, pos);
 }
 
-- 
2.43.0



