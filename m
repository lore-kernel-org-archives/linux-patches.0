Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1D1393DD1;
	Tue, 26 Aug 2025 11:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208684; cv=none; b=VK5HQGtQ8D/Yg7n+oHkbS3OVzWgYlgiOEQwGSor1QiN4VtX9wIBd0RQpoM1bF0OiFCmTY6315gU7yhqPgKKLd8uw7Wxt5XUGp9FTJFOw76a9FeQvZ0YqUtHLvXM7xFwlD6j9Hn8b9LBHSN9sHQoVYRpeh3l2WTTfRQvG488g4Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208684; c=relaxed/simple;
	bh=GHP+vy+1urwYi59M4ioM2jjdq4dSsc0c/HP8WG9YPhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKqd2mvvSns84bLfv731NNZcfOfrmeBqwLtAnEX6U0ZXvs5oahLMg/p8vO8eu6QTr1sHjcfjK2CP4wWVANt4xzwW19KlyFiQn6ixmniPF6DnQTlF+NX4iFAyxZ71eWflVbptwjxztp2/XMHAL0nJt533RCG3R2POGcg0lAZKqjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wdzUhez6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wdzUhez6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A2DEC4CEF1;
	Tue, 26 Aug 2025 11:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208683;
	bh=GHP+vy+1urwYi59M4ioM2jjdq4dSsc0c/HP8WG9YPhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wdzUhez6Ac0m5Kn9GCbPfQIcvERIiu8RwTPgWwxJh+cgTtNHDJ43ibe/PhPHk7Qb5
	 8G2j6hRuo82DIt+Xx8XvBy2wNE8/2q3hkW2XKuk1YILxL5qHTGw2Lqktz1Ij6P+tXu
	 0mtRrGf4lEPfnuU4KLyt9fgIRdFZqr4R40eFluEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8425ccfb599521edb153@syzkaller.appspotmail.com,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.12 175/322] RDMA/rxe: Flush delayed SKBs while releasing RXE resources
Date: Tue, 26 Aug 2025 13:09:50 +0200
Message-ID: <20250826110920.181663427@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Zhu Yanjun <yanjun.zhu@linux.dev>

commit 3c3e9a9f2972b364e8c2cfbfdeb23c6d6be4f87f upstream.

When skb packets are sent out, these skb packets still depends on
the rxe resources, for example, QP, sk, when these packets are
destroyed.

If these rxe resources are released when the skb packets are destroyed,
the call traces will appear.

To avoid skb packets hang too long time in some network devices,
a timestamp is added when these skb packets are created. If these
skb packets hang too long time in network devices, these network
devices can free these skb packets to release rxe resources.

Reported-by: syzbot+8425ccfb599521edb153@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8425ccfb599521edb153
Tested-by: syzbot+8425ccfb599521edb153@syzkaller.appspotmail.com
Fixes: 1a633bdc8fd9 ("RDMA/rxe: Let destroy qp succeed with stuck packet")
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Link: https://patch.msgid.link/20250726013104.463570-1-yanjun.zhu@linux.dev
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/sw/rxe/rxe_net.c | 29 ++++++++---------------------
 drivers/infiniband/sw/rxe/rxe_qp.c  |  2 +-
 2 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 132a87e52d5c..ac0183a2ff7a 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -345,33 +345,15 @@ int rxe_prepare(struct rxe_av *av, struct rxe_pkt_info *pkt,
 
 static void rxe_skb_tx_dtor(struct sk_buff *skb)
 {
-	struct net_device *ndev = skb->dev;
-	struct rxe_dev *rxe;
-	unsigned int qp_index;
-	struct rxe_qp *qp;
+	struct rxe_qp *qp = skb->sk->sk_user_data;
 	int skb_out;
 
-	rxe = rxe_get_dev_from_net(ndev);
-	if (!rxe && is_vlan_dev(ndev))
-		rxe = rxe_get_dev_from_net(vlan_dev_real_dev(ndev));
-	if (WARN_ON(!rxe))
-		return;
-
-	qp_index = (int)(uintptr_t)skb->sk->sk_user_data;
-	if (!qp_index)
-		return;
-
-	qp = rxe_pool_get_index(&rxe->qp_pool, qp_index);
-	if (!qp)
-		goto put_dev;
-
 	skb_out = atomic_dec_return(&qp->skb_out);
-	if (qp->need_req_skb && skb_out < RXE_INFLIGHT_SKBS_PER_QP_LOW)
+	if (unlikely(qp->need_req_skb &&
+		skb_out < RXE_INFLIGHT_SKBS_PER_QP_LOW))
 		rxe_sched_task(&qp->send_task);
 
 	rxe_put(qp);
-put_dev:
-	ib_device_put(&rxe->ib_dev);
 	sock_put(skb->sk);
 }
 
@@ -383,6 +365,7 @@ static int rxe_send(struct sk_buff *skb, struct rxe_pkt_info *pkt)
 	sock_hold(sk);
 	skb->sk = sk;
 	skb->destructor = rxe_skb_tx_dtor;
+	rxe_get(pkt->qp);
 	atomic_inc(&pkt->qp->skb_out);
 
 	if (skb->protocol == htons(ETH_P_IP))
@@ -405,6 +388,7 @@ static int rxe_loopback(struct sk_buff *skb, struct rxe_pkt_info *pkt)
 	sock_hold(sk);
 	skb->sk = sk;
 	skb->destructor = rxe_skb_tx_dtor;
+	rxe_get(pkt->qp);
 	atomic_inc(&pkt->qp->skb_out);
 
 	if (skb->protocol == htons(ETH_P_IP))
@@ -497,6 +481,9 @@ struct sk_buff *rxe_init_packet(struct rxe_dev *rxe, struct rxe_av *av,
 		goto out;
 	}
 
+	/* Add time stamp to skb. */
+	skb->tstamp = ktime_get();
+
 	skb_reserve(skb, hdr_len + LL_RESERVED_SPACE(ndev));
 
 	/* FIXME: hold reference to this netdev until life of this skb. */
diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index f2af3e0aef35..95f1c1c2949d 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -244,7 +244,7 @@ static int rxe_qp_init_req(struct rxe_dev *rxe, struct rxe_qp *qp,
 	err = sock_create_kern(&init_net, AF_INET, SOCK_DGRAM, 0, &qp->sk);
 	if (err < 0)
 		return err;
-	qp->sk->sk->sk_user_data = (void *)(uintptr_t)qp->elem.index;
+	qp->sk->sk->sk_user_data = qp;
 
 	/* pick a source UDP port number for this QP based on
 	 * the source QPN. this spreads traffic for different QPs
-- 
2.50.1



