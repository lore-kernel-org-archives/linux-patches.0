Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2079B39B48D;
	Sat, 17 Oct 2026 16:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253762; cv=none; b=LIx6dvvWYeJqb7X27XbHJgeNsYKhVUIoYoBpahlGMdnhigNQlez2u7jxLRz+emUF+ynvMwf15SW2Dt3bArCyJTHaVV1mj6PSDSScZvOHzJuDoH+GZIHNn0aMOEWwTwixTEraZzFDjs/SOXvMx8guhCDF3Np64tbWSdxM8QpOmX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253762; c=relaxed/simple;
	bh=ccSxchj88cbK2wdnrpjLSmKo/HT4yQOT9wFRUYDq7kM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=px8FDbpr102eF5BOLxrcDWFwzC7zf/evRgEOGjJUFcI7Fyf1shradRsVFf+3h4BbBII0b3ZKsuzyqGwj/MbA5Xc7V6/tyQ5us1dyOSwuvo6MhW9UjRk0e59jp5SGH64qCrgj0IXpcAECnf/DOmND7X/jX3DwXmenPoShe95EXUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=juLCjlaQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="juLCjlaQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A381F1F000C4;
	Sat, 17 Oct 2026 16:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253761;
	bh=1OUUHelXX3eNRTAH3ipb0gc2AEIp2MqbN2ZUCZRmc34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=juLCjlaQZiMyhCMZmciJmOY4wdKoRtyn+/lo6CkxnCmO+KmBJAym1rIv9Z5H0N/Rr
	 KQ8a4948eS413KRWbh/URL1uIYky8/Pr5C946sDk98YJdSC2wVHxBXJTE0/45JFkGU
	 vhv7oE8m0Dr0R/6xKexUuDnVktfqnowR36Gwht5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Guillaume Nault <gnault@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 224/869] mpls: Convert mpls_dump_routes() to RCU.
Date: Sat, 17 Oct 2026 17:51:05 +0200
Message-ID: <20261017160042.793021522@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit dde1b38e873cff70f0af36e884bbeb1b14a536ed ]

mpls_dump_routes() sets fib_dump_filter.rtnl_held to true and
calls __dev_get_by_index() in mpls_valid_fib_dump_req().

This is the only RTNL dependant in mpls_dump_routes().

Also, synchronize_rcu() in resize_platform_label_table()
guarantees that net->mpls.platform_label is alive under RCU.

Let's convert mpls_dump_routes() to RCU and use dev_get_by_index_rcu().

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Link: https://patch.msgid.link/20251029173344.2934622-11-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 629ec78ef860 ("mpls: add seqcount to protect the platform_label{,s} pair")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mpls/af_mpls.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index 5e060d373d7db..c555005cfcf55 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -2164,7 +2164,7 @@ static int mpls_valid_fib_dump_req(struct net *net, const struct nlmsghdr *nlh,
 				continue;
 
 			ifindex = nla_get_u32(tb[i]);
-			filter->dev = __dev_get_by_index(net, ifindex);
+			filter->dev = dev_get_by_index_rcu(net, ifindex);
 			if (!filter->dev)
 				return -ENODEV;
 			filter->filter_set = 1;
@@ -2202,20 +2202,19 @@ static int mpls_dump_routes(struct sk_buff *skb, struct netlink_callback *cb)
 	struct net *net = sock_net(skb->sk);
 	struct mpls_route __rcu **platform_label;
 	struct fib_dump_filter filter = {
-		.rtnl_held = true,
+		.rtnl_held = false,
 	};
 	unsigned int flags = NLM_F_MULTI;
 	size_t platform_labels;
 	unsigned int index;
+	int err;
 
-	ASSERT_RTNL();
+	rcu_read_lock();
 
 	if (cb->strict_check) {
-		int err;
-
 		err = mpls_valid_fib_dump_req(net, nlh, &filter, cb);
 		if (err < 0)
-			return err;
+			goto err;
 
 		/* for MPLS, there is only 1 table with fixed type and flags.
 		 * If either are set in the filter then return nothing.
@@ -2223,14 +2222,14 @@ static int mpls_dump_routes(struct sk_buff *skb, struct netlink_callback *cb)
 		if ((filter.table_id && filter.table_id != RT_TABLE_MAIN) ||
 		    (filter.rt_type && filter.rt_type != RTN_UNICAST) ||
 		     filter.flags)
-			return skb->len;
+			goto unlock;
 	}
 
 	index = cb->args[0];
 	if (index < MPLS_LABEL_FIRST_UNRESERVED)
 		index = MPLS_LABEL_FIRST_UNRESERVED;
 
-	platform_label = rtnl_dereference(net->mpls.platform_label);
+	platform_label = rcu_dereference(net->mpls.platform_label);
 	platform_labels = net->mpls.platform_labels;
 
 	if (filter.filter_set)
@@ -2239,7 +2238,7 @@ static int mpls_dump_routes(struct sk_buff *skb, struct netlink_callback *cb)
 	for (; index < platform_labels; index++) {
 		struct mpls_route *rt;
 
-		rt = rtnl_dereference(platform_label[index]);
+		rt = rcu_dereference(platform_label[index]);
 		if (!rt)
 			continue;
 
@@ -2254,7 +2253,13 @@ static int mpls_dump_routes(struct sk_buff *skb, struct netlink_callback *cb)
 	}
 	cb->args[0] = index;
 
+unlock:
+	rcu_read_unlock();
 	return skb->len;
+
+err:
+	rcu_read_unlock();
+	return err;
 }
 
 static inline size_t lfib_nlmsg_size(struct mpls_route *rt)
@@ -2779,7 +2784,8 @@ static struct rtnl_af_ops mpls_af_ops __read_mostly = {
 static const struct rtnl_msg_handler mpls_rtnl_msg_handlers[] __initdata_or_module = {
 	{THIS_MODULE, PF_MPLS, RTM_NEWROUTE, mpls_rtm_newroute, NULL, 0},
 	{THIS_MODULE, PF_MPLS, RTM_DELROUTE, mpls_rtm_delroute, NULL, 0},
-	{THIS_MODULE, PF_MPLS, RTM_GETROUTE, mpls_getroute, mpls_dump_routes, 0},
+	{THIS_MODULE, PF_MPLS, RTM_GETROUTE, mpls_getroute, mpls_dump_routes,
+	 RTNL_FLAG_DUMP_UNLOCKED},
 	{THIS_MODULE, PF_MPLS, RTM_GETNETCONF,
 	 mpls_netconf_get_devconf, mpls_netconf_dump_devconf,
 	 RTNL_FLAG_DUMP_UNLOCKED},
-- 
2.53.0



