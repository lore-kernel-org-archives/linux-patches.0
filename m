Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C2CDDAB;
	Wed,  3 Dec 2025 15:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776390; cv=none; b=EUC1k4waXeY+lkthm7RbJ+tNvCU3CONM1WFEN9V+cVfvTy/Su5miXpVt1rxtoVEjk659PItitILcs1XkccTyl3seKN4wLehvN+h86HQ+tofz1XXWZt2l9zntJmyUMNtN41edWzYLjaOO7pRtStSUjh8DEZh4FIUI5AC9EUBZvA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776390; c=relaxed/simple;
	bh=2ox2KsSstZM80+PSzc2Czy34YubrG5JiHSjT/QFL4Mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yw+2JQZXOr7X166FCVRj5w+L8aWtRQwLCsZUy5d1XO7JHmchJitgK6XMoZ5QB8f9qk+N5DqSJxwwd2G/z6hOOH+R+Hv1IhckczuznoiPMnBamp7lX9eL/flGscNtS4zkgKw/zXK3b4TpfJvMERg2dmDMt9ALoyh2admUVa9ukKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZD+lQUgs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZD+lQUgs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA993C4CEF5;
	Wed,  3 Dec 2025 15:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776390;
	bh=2ox2KsSstZM80+PSzc2Czy34YubrG5JiHSjT/QFL4Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZD+lQUgsbzewLRuFG+QBSAIAl4IAOhbETnikUTut8lLEzIPVPEs+5zmjpPYdDAQTE
	 zTEnAwiSCcfxcWE4j8/prZeKLpkca6pXa75OU0yF78cB07Y1PzQuHaGIfunX6eO1+G
	 r1X3zllMgwl03CYceydoFwN5gYBJm3GeKNTTZmPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 167/300] sctp: hold endpoint before calling cb in sctp_transport_lookup_process
Date: Wed,  3 Dec 2025 16:26:11 +0100
Message-ID: <20251203152406.806474776@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit f9d31c4cf4c11ff10317f038b9c6f7c3bda6cdd4 ]

The same fix in commit 5ec7d18d1813 ("sctp: use call_rcu to free endpoint")
is also needed for dumping one asoc and sock after the lookup.

Fixes: 86fdb3448cc1 ("sctp: ensure ep is not destroyed before doing the dump")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: f1fc201148c7 ("sctp: Hold sock lock while iterating over address list")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sctp/sctp.h |  3 +--
 net/sctp/diag.c         | 46 +++++++++++++++++++----------------------
 net/sctp/socket.c       | 22 +++++++++++++-------
 3 files changed, 37 insertions(+), 34 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 6d89a7f3f6a4c..775fde82c6576 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -110,8 +110,7 @@ struct sctp_transport *sctp_transport_get_next(struct net *net,
 			struct rhashtable_iter *iter);
 struct sctp_transport *sctp_transport_get_idx(struct net *net,
 			struct rhashtable_iter *iter, int pos);
-int sctp_transport_lookup_process(int (*cb)(struct sctp_transport *, void *),
-				  struct net *net,
+int sctp_transport_lookup_process(sctp_callback_t cb, struct net *net,
 				  const union sctp_addr *laddr,
 				  const union sctp_addr *paddr, void *p);
 int sctp_transport_traverse_process(sctp_callback_t cb, sctp_callback_t cb_done,
diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index b1e672227924a..3631a32d96b07 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -249,48 +249,44 @@ static size_t inet_assoc_attr_size(struct sctp_association *asoc)
 		+ 64;
 }
 
-static int sctp_tsp_dump_one(struct sctp_transport *tsp, void *p)
+static int sctp_sock_dump_one(struct sctp_endpoint *ep, struct sctp_transport *tsp, void *p)
 {
 	struct sctp_association *assoc = tsp->asoc;
-	struct sock *sk = tsp->asoc->base.sk;
 	struct sctp_comm_param *commp = p;
-	struct sk_buff *in_skb = commp->skb;
+	struct sock *sk = ep->base.sk;
 	const struct inet_diag_req_v2 *req = commp->r;
-	const struct nlmsghdr *nlh = commp->nlh;
-	struct net *net = sock_net(in_skb->sk);
+	struct sk_buff *skb = commp->skb;
 	struct sk_buff *rep;
 	int err;
 
 	err = sock_diag_check_cookie(sk, req->id.idiag_cookie);
 	if (err)
-		goto out;
+		return err;
 
-	err = -ENOMEM;
 	rep = nlmsg_new(inet_assoc_attr_size(assoc), GFP_KERNEL);
 	if (!rep)
-		goto out;
+		return -ENOMEM;
 
 	lock_sock(sk);
-	if (sk != assoc->base.sk) {
-		release_sock(sk);
-		sk = assoc->base.sk;
-		lock_sock(sk);
+	if (ep != assoc->ep) {
+		err = -EAGAIN;
+		goto out;
 	}
-	err = inet_sctp_diag_fill(sk, assoc, rep, req,
-				  sk_user_ns(NETLINK_CB(in_skb).sk),
-				  NETLINK_CB(in_skb).portid,
-				  nlh->nlmsg_seq, 0, nlh,
-				  commp->net_admin);
-	release_sock(sk);
+
+	err = inet_sctp_diag_fill(sk, assoc, rep, req, sk_user_ns(NETLINK_CB(skb).sk),
+				  NETLINK_CB(skb).portid, commp->nlh->nlmsg_seq, 0,
+				  commp->nlh, commp->net_admin);
 	if (err < 0) {
 		WARN_ON(err == -EMSGSIZE);
-		kfree_skb(rep);
 		goto out;
 	}
+	release_sock(sk);
 
-	err = nlmsg_unicast(net->diag_nlsk, rep, NETLINK_CB(in_skb).portid);
+	return nlmsg_unicast(sock_net(skb->sk)->diag_nlsk, rep, NETLINK_CB(skb).portid);
 
 out:
+	release_sock(sk);
+	kfree_skb(rep);
 	return err;
 }
 
@@ -431,15 +427,15 @@ static void sctp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
 static int sctp_diag_dump_one(struct netlink_callback *cb,
 			      const struct inet_diag_req_v2 *req)
 {
-	struct sk_buff *in_skb = cb->skb;
-	struct net *net = sock_net(in_skb->sk);
+	struct sk_buff *skb = cb->skb;
+	struct net *net = sock_net(skb->sk);
 	const struct nlmsghdr *nlh = cb->nlh;
 	union sctp_addr laddr, paddr;
 	struct sctp_comm_param commp = {
-		.skb = in_skb,
+		.skb = skb,
 		.r = req,
 		.nlh = nlh,
-		.net_admin = netlink_net_capable(in_skb, CAP_NET_ADMIN),
+		.net_admin = netlink_net_capable(skb, CAP_NET_ADMIN),
 	};
 
 	if (req->sdiag_family == AF_INET) {
@@ -462,7 +458,7 @@ static int sctp_diag_dump_one(struct netlink_callback *cb,
 		paddr.v6.sin6_family = AF_INET6;
 	}
 
-	return sctp_transport_lookup_process(sctp_tsp_dump_one,
+	return sctp_transport_lookup_process(sctp_sock_dump_one,
 					     net, &laddr, &paddr, &commp);
 }
 
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 8fe09f962957f..5ea0bad561a18 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5212,23 +5212,31 @@ int sctp_for_each_endpoint(int (*cb)(struct sctp_endpoint *, void *),
 }
 EXPORT_SYMBOL_GPL(sctp_for_each_endpoint);
 
-int sctp_transport_lookup_process(int (*cb)(struct sctp_transport *, void *),
-				  struct net *net,
+int sctp_transport_lookup_process(sctp_callback_t cb, struct net *net,
 				  const union sctp_addr *laddr,
 				  const union sctp_addr *paddr, void *p)
 {
 	struct sctp_transport *transport;
-	int err;
+	struct sctp_endpoint *ep;
+	int err = -ENOENT;
 
 	rcu_read_lock();
 	transport = sctp_addrs_lookup_transport(net, laddr, paddr);
+	if (!transport) {
+		rcu_read_unlock();
+		return err;
+	}
+	ep = transport->asoc->ep;
+	if (!sctp_endpoint_hold(ep)) { /* asoc can be peeled off */
+		sctp_transport_put(transport);
+		rcu_read_unlock();
+		return err;
+	}
 	rcu_read_unlock();
-	if (!transport)
-		return -ENOENT;
 
-	err = cb(transport, p);
+	err = cb(ep, transport, p);
+	sctp_endpoint_put(ep);
 	sctp_transport_put(transport);
-
 	return err;
 }
 EXPORT_SYMBOL_GPL(sctp_transport_lookup_process);
-- 
2.51.0



