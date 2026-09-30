Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7CE51B17D;
	Wed, 30 Sep 2026 17:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788366; cv=none; b=uz0Uq8wkuPhlB6JwNRvaBuVmVWMleSnGgLGPTGYYN/Dfd3OgQmEenigntcPbl53TE5LoF/CZwFvI7TuorvlCOfOzQ5knyfe0HT/mvMy/CsrGzRFEb6cLvd1NM9Ibwo6KGpNV9MGM94NfG3ksi8Vd5tM6R36NJLIP+dLVypsI9eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788366; c=relaxed/simple;
	bh=687+7hboOnAcYifSaH+YxZj4LmZXve+NR4oRoI59Qqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ANqpZQ9OYhv9EtviqE4GmSDILV4x9JS2EcsNeo5P1W6r5k+JYxRd4hJdz58HvTSK1hVzoyyMoB+VHpjUdaWgV3AjSWRFJykE34mKc+2h1KcuOFEFgF2zXpuHBwXDvXeYBrjHbnjL/YMzwWt63qQNBuv7B+DFI+Rm/GWdmpxEsDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z+RCVYkD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z+RCVYkD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E92AA1F000FF;
	Wed, 30 Sep 2026 17:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788365;
	bh=sx/YHLjCCl5eWJBTGpSEg9LnafsOXpR8lVqczhNxJ/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z+RCVYkDQkEhmkd2k7qVuZFjLrV3T/0nNy4d5MSN2u3XvATmcJYFQeIY9DBMAkNEj
	 QespvoRxx0XcgCAC3DQ6t7VWcD7AspvOi9OJ1wDgnEHJfVTXzhNSqL+Ar1fp7g3oKi
	 tjr75YNA+0KIp105IgoJTJ6ok89Kowhrs6VWDaKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 098/877] neighbour: Convert RTM_GETNEIGHTBL to RCU.
Date: Wed, 30 Sep 2026 17:16:49 +0200
Message-ID: <20260930152416.851103679@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

[ Upstream commit 4ae34be500649ec452ac1fc2748958683ad9b55d ]

neightbl_dump_info() calls these functions for each neigh_tables[]
entry:

  1. neightbl_fill_info() for tbl->parms
  2. neightbl_fill_param_info() for tbl->parms_list (except tbl->parms)

Both functions rely on the table lock (read_lock_bh(&tbl->lock))
and RTNL is not needed.

Let's fetch the table under RCU and convert RTM_GETNEIGHTBL to RCU.

Note that the first entry of tbl->parms_list is tbl->parms.list and
embedded in neigh_table, so list_next_entry() is safe.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20251022054004.2514876-4-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 979aabdad8dd ("neighbour: Skip default parms when resumed in neightbl_dump_info().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 50a18ae55409e..d38c309e7fa61 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2131,7 +2131,7 @@ static int neightbl_fill_parms(struct sk_buff *skb, struct neigh_parms *parms)
 		return -ENOBUFS;
 
 	if ((parms->dev &&
-	     nla_put_u32(skb, NDTPA_IFINDEX, parms->dev->ifindex)) ||
+	     nla_put_u32(skb, NDTPA_IFINDEX, READ_ONCE(parms->dev->ifindex))) ||
 	    nla_put_u32(skb, NDTPA_REFCNT, refcount_read(&parms->refcnt)) ||
 	    nla_put_u32(skb, NDTPA_QUEUE_LENBYTES,
 			NEIGH_VAR(parms, QUEUE_LEN_BYTES)) ||
@@ -2183,8 +2183,6 @@ static int neightbl_fill_info(struct sk_buff *skb, struct neigh_table *tbl,
 		return -EMSGSIZE;
 
 	ndtmsg = nlmsg_data(nlh);
-
-	read_lock_bh(&tbl->lock);
 	ndtmsg->ndtm_family = tbl->family;
 	ndtmsg->ndtm_pad1   = 0;
 	ndtmsg->ndtm_pad2   = 0;
@@ -2210,11 +2208,9 @@ static int neightbl_fill_info(struct sk_buff *skb, struct neigh_table *tbl,
 			.ndtc_proxy_qlen	= READ_ONCE(tbl->proxy_queue.qlen),
 		};
 
-		rcu_read_lock();
 		nht = rcu_dereference(tbl->nht);
 		ndc.ndtc_hash_rnd = nht->hash_rnd[0];
 		ndc.ndtc_hash_mask = ((1 << nht->hash_shift) - 1);
-		rcu_read_unlock();
 
 		if (nla_put(skb, NDTA_CONFIG, sizeof(ndc), &ndc))
 			goto nla_put_failure;
@@ -2252,12 +2248,10 @@ static int neightbl_fill_info(struct sk_buff *skb, struct neigh_table *tbl,
 	if (neightbl_fill_parms(skb, &tbl->parms) < 0)
 		goto nla_put_failure;
 
-	read_unlock_bh(&tbl->lock);
 	nlmsg_end(skb, nlh);
 	return 0;
 
 nla_put_failure:
-	read_unlock_bh(&tbl->lock);
 	nlmsg_cancel(skb, nlh);
 	return -EMSGSIZE;
 }
@@ -2276,8 +2270,6 @@ static int neightbl_fill_param_info(struct sk_buff *skb,
 		return -EMSGSIZE;
 
 	ndtmsg = nlmsg_data(nlh);
-
-	read_lock_bh(&tbl->lock);
 	ndtmsg->ndtm_family = tbl->family;
 	ndtmsg->ndtm_pad1   = 0;
 	ndtmsg->ndtm_pad2   = 0;
@@ -2286,11 +2278,9 @@ static int neightbl_fill_param_info(struct sk_buff *skb,
 	    neightbl_fill_parms(skb, parms) < 0)
 		goto errout;
 
-	read_unlock_bh(&tbl->lock);
 	nlmsg_end(skb, nlh);
 	return 0;
 errout:
-	read_unlock_bh(&tbl->lock);
 	nlmsg_cancel(skb, nlh);
 	return -EMSGSIZE;
 }
@@ -2531,10 +2521,12 @@ static int neightbl_dump_info(struct sk_buff *skb, struct netlink_callback *cb)
 
 	family = ((struct rtgenmsg *)nlmsg_data(nlh))->rtgen_family;
 
+	rcu_read_lock();
+
 	for (tidx = 0; tidx < NEIGH_NR_TABLES; tidx++) {
 		struct neigh_parms *p;
 
-		tbl = rcu_dereference_rtnl(neigh_tables[tidx]);
+		tbl = rcu_dereference(neigh_tables[tidx]);
 		if (!tbl)
 			continue;
 
@@ -2548,7 +2540,7 @@ static int neightbl_dump_info(struct sk_buff *skb, struct netlink_callback *cb)
 
 		nidx = 0;
 		p = list_next_entry(&tbl->parms, list);
-		list_for_each_entry_from(p, &tbl->parms_list, list) {
+		list_for_each_entry_from_rcu(p, &tbl->parms_list, list) {
 			if (!net_eq(neigh_parms_net(p), net))
 				continue;
 
@@ -2568,6 +2560,8 @@ static int neightbl_dump_info(struct sk_buff *skb, struct netlink_callback *cb)
 		neigh_skip = 0;
 	}
 out:
+	rcu_read_unlock();
+
 	cb->args[0] = tidx;
 	cb->args[1] = nidx;
 
@@ -3882,7 +3876,8 @@ static const struct rtnl_msg_handler neigh_rtnl_msg_handlers[] __initconst = {
 	{.msgtype = RTM_DELNEIGH, .doit = neigh_delete},
 	{.msgtype = RTM_GETNEIGH, .doit = neigh_get, .dumpit = neigh_dump_info,
 	 .flags = RTNL_FLAG_DOIT_UNLOCKED | RTNL_FLAG_DUMP_UNLOCKED},
-	{.msgtype = RTM_GETNEIGHTBL, .dumpit = neightbl_dump_info},
+	{.msgtype = RTM_GETNEIGHTBL, .dumpit = neightbl_dump_info,
+	 .flags = RTNL_FLAG_DUMP_UNLOCKED},
 	{.msgtype = RTM_SETNEIGHTBL, .doit = neightbl_set},
 };
 
-- 
2.53.0



