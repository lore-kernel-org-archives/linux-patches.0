Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E6F19ADB1;
	Thu,  6 Jun 2024 14:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683362; cv=none; b=ImLmSYMbNR6O2gD/bhMqaGaXF7CS4xYdKWXubvs6b9nWqC0fkrze9SMrQvY2oFccpzWaan4TqZfycaKEokEUu028pYl30MbWhnELhTwqeEO4pMbUQw5p7Koc2ApmuUj/6LYYJ2A1KhyBaDgU0m2MZ9WdhprcHpHeTVaPto6fP+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683362; c=relaxed/simple;
	bh=lHtyYm90QWqPrvj5FDbDNOBmlj/6lG4HsdGXcWrDCJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JXaWjJo7N0hJje+AZ+gRJtlz90KllA5Um9g4MH02sdikKGOeoie0oAzuWNzcgaw72MsFmfNAHoigKDoR0FKcQgkXLsDd4YvEZR9E57NzSj+yAz7QGolGbdLV46TjvGRwB7zX477sg/U2Ah7xj/d8j/WEV7TWV+JAnHTw8ASAVq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZIn2HduF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZIn2HduF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3FEEC2BD10;
	Thu,  6 Jun 2024 14:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683361;
	bh=lHtyYm90QWqPrvj5FDbDNOBmlj/6lG4HsdGXcWrDCJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZIn2HduFsaFSxk+sm+fwaBL1QcjN3s/0xQlUfKQcaUyFVVV+jSe4onNF083TNnmGO
	 VFbrchrPQDk1KPgMCvXf45qDRAQSiD/ke3sXwQI74gYGoHgsXl61Guujf+Q+KOychx
	 +Qr2ZP8Iu3VJ/iGKmM7OK4NaPBqGd9yRfmxPW3Jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 246/473] RDMA/rxe: Replace pr_xxx by rxe_dbg_xxx in rxe_net.c
Date: Thu,  6 Jun 2024 16:02:55 +0200
Message-ID: <20240606131708.137096564@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit 34549e88e0a3088416177023abf1232fe40e721c ]

Replace (some) calls to pr_xxx() in rxe_net.c with rxe_dbg_xxx().
Calls with a rxe device not yet in scope are left as is.

Link: https://lore.kernel.org/r/20221103171013.20659-7-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 8776618dbbd1 ("RDMA/rxe: Fix incorrect rxe_put in error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_net.c | 38 ++++++++++++++++-------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 719432808a063..6bd6ed80f4a6c 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -20,9 +20,10 @@
 
 static struct rxe_recv_sockets recv_sockets;
 
-static struct dst_entry *rxe_find_route4(struct net_device *ndev,
-				  struct in_addr *saddr,
-				  struct in_addr *daddr)
+static struct dst_entry *rxe_find_route4(struct rxe_qp *qp,
+					 struct net_device *ndev,
+					 struct in_addr *saddr,
+					 struct in_addr *daddr)
 {
 	struct rtable *rt;
 	struct flowi4 fl = { { 0 } };
@@ -35,7 +36,7 @@ static struct dst_entry *rxe_find_route4(struct net_device *ndev,
 
 	rt = ip_route_output_key(&init_net, &fl);
 	if (IS_ERR(rt)) {
-		pr_err_ratelimited("no route to %pI4\n", &daddr->s_addr);
+		rxe_dbg_qp(qp, "no route to %pI4\n", &daddr->s_addr);
 		return NULL;
 	}
 
@@ -43,7 +44,8 @@ static struct dst_entry *rxe_find_route4(struct net_device *ndev,
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
-static struct dst_entry *rxe_find_route6(struct net_device *ndev,
+static struct dst_entry *rxe_find_route6(struct rxe_qp *qp,
+					 struct net_device *ndev,
 					 struct in6_addr *saddr,
 					 struct in6_addr *daddr)
 {
@@ -60,12 +62,12 @@ static struct dst_entry *rxe_find_route6(struct net_device *ndev,
 					       recv_sockets.sk6->sk, &fl6,
 					       NULL);
 	if (IS_ERR(ndst)) {
-		pr_err_ratelimited("no route to %pI6\n", daddr);
+		rxe_dbg_qp(qp, "no route to %pI6\n", daddr);
 		return NULL;
 	}
 
 	if (unlikely(ndst->error)) {
-		pr_err("no route to %pI6\n", daddr);
+		rxe_dbg_qp(qp, "no route to %pI6\n", daddr);
 		goto put;
 	}
 
@@ -77,7 +79,8 @@ static struct dst_entry *rxe_find_route6(struct net_device *ndev,
 
 #else
 
-static struct dst_entry *rxe_find_route6(struct net_device *ndev,
+static struct dst_entry *rxe_find_route6(struct rxe_qp *qp,
+					 struct net_device *ndev,
 					 struct in6_addr *saddr,
 					 struct in6_addr *daddr)
 {
@@ -105,14 +108,14 @@ static struct dst_entry *rxe_find_route(struct net_device *ndev,
 
 			saddr = &av->sgid_addr._sockaddr_in.sin_addr;
 			daddr = &av->dgid_addr._sockaddr_in.sin_addr;
-			dst = rxe_find_route4(ndev, saddr, daddr);
+			dst = rxe_find_route4(qp, ndev, saddr, daddr);
 		} else if (av->network_type == RXE_NETWORK_TYPE_IPV6) {
 			struct in6_addr *saddr6;
 			struct in6_addr *daddr6;
 
 			saddr6 = &av->sgid_addr._sockaddr_in6.sin6_addr;
 			daddr6 = &av->dgid_addr._sockaddr_in6.sin6_addr;
-			dst = rxe_find_route6(ndev, saddr6, daddr6);
+			dst = rxe_find_route6(qp, ndev, saddr6, daddr6);
 #if IS_ENABLED(CONFIG_IPV6)
 			if (dst)
 				qp->dst_cookie =
@@ -285,7 +288,7 @@ static int prepare4(struct rxe_av *av, struct rxe_pkt_info *pkt,
 
 	dst = rxe_find_route(skb->dev, qp, av);
 	if (!dst) {
-		pr_err("Host not reachable\n");
+		rxe_dbg_qp(qp, "Host not reachable\n");
 		return -EHOSTUNREACH;
 	}
 
@@ -309,7 +312,7 @@ static int prepare6(struct rxe_av *av, struct rxe_pkt_info *pkt,
 
 	dst = rxe_find_route(skb->dev, qp, av);
 	if (!dst) {
-		pr_err("Host not reachable\n");
+		rxe_dbg_qp(qp, "Host not reachable\n");
 		return -EHOSTUNREACH;
 	}
 
@@ -368,7 +371,8 @@ static int rxe_send(struct sk_buff *skb, struct rxe_pkt_info *pkt)
 	} else if (skb->protocol == htons(ETH_P_IPV6)) {
 		err = ip6_local_out(dev_net(skb_dst(skb)->dev), skb->sk, skb);
 	} else {
-		pr_err("Unknown layer 3 protocol: %d\n", skb->protocol);
+		rxe_dbg_qp(pkt->qp, "Unknown layer 3 protocol: %d\n",
+				skb->protocol);
 		atomic_dec(&pkt->qp->skb_out);
 		rxe_put(pkt->qp);
 		kfree_skb(skb);
@@ -376,7 +380,7 @@ static int rxe_send(struct sk_buff *skb, struct rxe_pkt_info *pkt)
 	}
 
 	if (unlikely(net_xmit_eval(err))) {
-		pr_debug("error sending packet: %d\n", err);
+		rxe_dbg_qp(pkt->qp, "error sending packet: %d\n", err);
 		return -EAGAIN;
 	}
 
@@ -417,7 +421,7 @@ int rxe_xmit_packet(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
 
 	if ((is_request && (qp->req.state != QP_STATE_READY)) ||
 	    (!is_request && (qp->resp.state != QP_STATE_READY))) {
-		pr_info("Packet dropped. QP is not in ready state\n");
+		rxe_dbg_qp(qp, "Packet dropped. QP is not in ready state\n");
 		goto drop;
 	}
 
@@ -598,7 +602,7 @@ static int rxe_notify(struct notifier_block *not_blk,
 		rxe_port_down(rxe);
 		break;
 	case NETDEV_CHANGEMTU:
-		pr_info("%s changed mtu to %d\n", ndev->name, ndev->mtu);
+		rxe_dbg(rxe, "%s changed mtu to %d\n", ndev->name, ndev->mtu);
 		rxe_set_mtu(rxe, ndev->mtu);
 		break;
 	case NETDEV_CHANGE:
@@ -610,7 +614,7 @@ static int rxe_notify(struct notifier_block *not_blk,
 	case NETDEV_CHANGENAME:
 	case NETDEV_FEAT_CHANGE:
 	default:
-		pr_info("ignoring netdev event = %ld for %s\n",
+		rxe_dbg(rxe, "ignoring netdev event = %ld for %s\n",
 			event, ndev->name);
 		break;
 	}
-- 
2.43.0



