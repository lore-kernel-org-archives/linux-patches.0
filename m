Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632252D7BF;
	Tue,  3 Dec 2024 15:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239387; cv=none; b=rNamPA/6cfXWoNfqW4zS2sJt1T4ez4f2Q5d+eDEkFhvi96rKXguzulW8b4nQisyUjmG5CkzmOCTu81UBvbBkqA5V5K0cyo/nd5WlOCwTU3mlpxuyU9bW+OqIro3oA6VOoYD82U1wdEq7CdPEJmkkXHMzYbmx2QVlX+hk0U8yduE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239387; c=relaxed/simple;
	bh=iAzUJDARBT4JSsVYntW2EjoD6e3VQhH3f8Ry/4As74M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HpII2zQVobTDQRg9EX4XeyJSjf0qwGuSYW+e15MwYf0IW0onHcwCjdfYETOw6AyYrLGJ2TXLOo3qtK/YGUBnotQfTtNeBAr+CuUtgOsT/W/nKzhN9VBCMYCDBipRKGoz5tqCnw/5fXHZEAP1EcN00Q/OioyCqpmm3Z6imLKWOPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k8ZZfeFi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k8ZZfeFi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E0FC4CECF;
	Tue,  3 Dec 2024 15:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239387;
	bh=iAzUJDARBT4JSsVYntW2EjoD6e3VQhH3f8Ry/4As74M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k8ZZfeFiEfAIFkWtglbw4btIiaum1XMixxwrAcMSpjAr/p/AQ9u7JuXyIQWXXIQBR
	 aX0rvzv16+gFpNc94MXBIgB1NeWvopxWxblyV8h7vyrYPmwNgXoeCpgu1p0uuFS9qS
	 e3oXLW3UUjS5dJ+q7hAh1Kvd1FTRD8a2cvUXAHvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 596/817] ipmr: fix tables suspicious RCU usage
Date: Tue,  3 Dec 2024 15:42:48 +0100
Message-ID: <20241203144019.188950358@linuxfoundation.org>
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
index 6c750bd13dd8d..035d6f0ff01ee 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -136,7 +136,7 @@ static struct mr_table *ipmr_mr_table_iter(struct net *net,
 	return ret;
 }
 
-static struct mr_table *ipmr_get_table(struct net *net, u32 id)
+static struct mr_table *__ipmr_get_table(struct net *net, u32 id)
 {
 	struct mr_table *mrt;
 
@@ -147,6 +147,16 @@ static struct mr_table *ipmr_get_table(struct net *net, u32 id)
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
@@ -188,7 +198,7 @@ static int ipmr_rule_action(struct fib_rule *rule, struct flowi *flp,
 
 	arg->table = fib_rule_get_table(rule, arg);
 
-	mrt = ipmr_get_table(rule->fr_net, arg->table);
+	mrt = __ipmr_get_table(rule->fr_net, arg->table);
 	if (!mrt)
 		return -EAGAIN;
 	res->mrt = mrt;
@@ -314,6 +324,8 @@ static struct mr_table *ipmr_get_table(struct net *net, u32 id)
 	return net->ipv4.mrt;
 }
 
+#define __ipmr_get_table ipmr_get_table
+
 static int ipmr_fib_lookup(struct net *net, struct flowi4 *flp4,
 			   struct mr_table **mrt)
 {
@@ -402,7 +414,7 @@ static struct mr_table *ipmr_new_table(struct net *net, u32 id)
 	if (id != RT_TABLE_DEFAULT && id >= 1000000000)
 		return ERR_PTR(-EINVAL);
 
-	mrt = ipmr_get_table(net, id);
+	mrt = __ipmr_get_table(net, id);
 	if (mrt)
 		return mrt;
 
@@ -1373,7 +1385,7 @@ int ip_mroute_setsockopt(struct sock *sk, int optname, sockptr_t optval,
 		goto out_unlock;
 	}
 
-	mrt = ipmr_get_table(net, raw_sk(sk)->ipmr_table ? : RT_TABLE_DEFAULT);
+	mrt = __ipmr_get_table(net, raw_sk(sk)->ipmr_table ? : RT_TABLE_DEFAULT);
 	if (!mrt) {
 		ret = -ENOENT;
 		goto out_unlock;
@@ -2261,11 +2273,13 @@ int ipmr_get_route(struct net *net, struct sk_buff *skb,
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
@@ -2550,7 +2564,7 @@ static int ipmr_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 	grp = tb[RTA_DST] ? nla_get_in_addr(tb[RTA_DST]) : 0;
 	tableid = tb[RTA_TABLE] ? nla_get_u32(tb[RTA_TABLE]) : 0;
 
-	mrt = ipmr_get_table(net, tableid ? tableid : RT_TABLE_DEFAULT);
+	mrt = __ipmr_get_table(net, tableid ? tableid : RT_TABLE_DEFAULT);
 	if (!mrt) {
 		err = -ENOENT;
 		goto errout_free;
@@ -2604,7 +2618,7 @@ static int ipmr_rtm_dumproute(struct sk_buff *skb, struct netlink_callback *cb)
 	if (filter.table_id) {
 		struct mr_table *mrt;
 
-		mrt = ipmr_get_table(sock_net(skb->sk), filter.table_id);
+		mrt = __ipmr_get_table(sock_net(skb->sk), filter.table_id);
 		if (!mrt) {
 			if (rtnl_msg_family(cb->nlh) != RTNL_FAMILY_IPMR)
 				return skb->len;
@@ -2712,7 +2726,7 @@ static int rtm_to_ipmr_mfcc(struct net *net, struct nlmsghdr *nlh,
 			break;
 		}
 	}
-	mrt = ipmr_get_table(net, tblid);
+	mrt = __ipmr_get_table(net, tblid);
 	if (!mrt) {
 		ret = -ENOENT;
 		goto out;
@@ -2920,13 +2934,15 @@ static void *ipmr_vif_seq_start(struct seq_file *seq, loff_t *pos)
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



