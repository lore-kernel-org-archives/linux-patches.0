Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042852;
	b=fOUJoqUVW5HMDQ/yiD5P9DneeIHYP+A/0m6Gk5zjgQ3AJ0kW7OPMwtoUECzD/iCun4ig
	 fPhbbNdDUOBMc0M+J8/2yNCsqHljSiBRJS1AUzUkd17IyzgzWgM4kAMDEanv2J4rHKWx8
	 AfvUheLM/bX4NnJmtC7L8qjJIu2pOSsk9G4+eY9DIOuegEvllfsiqA/RDgMFryFNSjsxA
	 As6CdvJugpAx76ACpBK52wKtWmsBDEVCUiWdVTbWGcWbDBTgo9l0nNcgwXXpG6Km+0fO1
	 +6cGlsYuxLV4h8Lt7bMgqqpBHJ2HHi2U+3hcQ5vwNy+l1gicoA4BL6nYZb5oa8ihy+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042852;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JS2gDG3IDRpwSSV5U/e9XnioTvwlVWAsjmDY7Bm76X4=;
	b=nG51HaZt4zLZ3hOtJt2kUXD3OK9p/gFrhpnlUz1SB7CoYOe4Y528sauNbpwYTyq4FCbX
	 fM83GHPjl3vebDkfZi6KspB+4U8V2pqghzhgblwZPM8jdDl9j77jnfdE8sUXJXI2VYCAT
	 vwXyS5CM7TjqNHakuyk/XzwyTM8Ko2ZZkk8kzckwOOEtlBRm0KDoG3c8AwS2eDqnW4E1g
	 XG9hqcBpyXjqNr9ymhHnEnAdQWfWu21GKcb9CPaK8T/BDJ3hYjB8Jqtyiytrtl0p68Cf8
	 sw594hdg50Xm1wqjldZzdZYi67DkSLC0oA2tTCIOfv4Rrq++8QuqWySSRf9jM2vd5TQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="k/T4ZbTo";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B07D606A325;
	Wed, 18 Nov 2026 23:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k/T4ZbTo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C001F000C4;
	Wed, 18 Nov 2026 23:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042852;
	bh=JS2gDG3IDRpwSSV5U/e9XnioTvwlVWAsjmDY7Bm76X4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k/T4ZbTo+S/A/59o7WqmyodvfWUrJ+CTKl0qs6dIsy0u3YH4bmlq1KaudsD0GBuHf
	 8Su9mxx0fLWaaAwHmzVjw5IL4VBK1m2K0NxfL9lSYwO1pKxmrC0neaxfvF5v2e/LNG
	 fW8rv5QJZJeugvybtKtRmXqxT/fjYe5tWx6kR63E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8425ccfb599521edb153@syzkaller.appspotmail.com,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.6 3317/3318] RDMA/rxe: Flush delayed SKBs while releasing RXE resources
Date: Wed, 18 Nov 2026 16:05:39 +0100
Message-ID: <20261118150459.076229959@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/infiniband/sw/rxe/rxe_net.c |   29 ++++++++---------------------
 drivers/infiniband/sw/rxe/rxe_qp.c  |    2 +-
 2 files changed, 9 insertions(+), 22 deletions(-)

--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -368,33 +368,15 @@ static void rxe_skb_put_held_ndev(struct
 
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
 	rxe_skb_put_held_ndev(skb);
 }
@@ -418,6 +400,7 @@ static int rxe_send(struct sk_buff *skb,
 	sock_hold(sk);
 	skb->sk = sk;
 	skb->destructor = rxe_skb_tx_dtor;
+	rxe_get(pkt->qp);
 	atomic_inc(&pkt->qp->skb_out);
 
 	if (skb->protocol == htons(ETH_P_IP))
@@ -445,6 +428,7 @@ static int rxe_loopback(struct sk_buff *
 	sock_hold(sk);
 	skb->sk = sk;
 	skb->destructor = rxe_skb_tx_dtor;
+	rxe_get(pkt->qp);
 	atomic_inc(&pkt->qp->skb_out);
 
 	if (skb->protocol == htons(ETH_P_IP))
@@ -543,6 +527,9 @@ struct sk_buff *rxe_init_packet(struct r
 		goto out;
 	}
 
+	/* Add time stamp to skb. */
+	skb->tstamp = ktime_get();
+
 	skb_reserve(skb, hdr_len + LL_RESERVED_SPACE(ndev));
 
 	rxe_skb_set_held_ndev(skb, ndev);
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -245,7 +245,7 @@ static int rxe_qp_init_req(struct rxe_de
 	err = sock_create_kern(&init_net, AF_INET, SOCK_DGRAM, 0, &qp->sk);
 	if (err < 0)
 		return err;
-	qp->sk->sk->sk_user_data = (void *)(uintptr_t)qp->elem.index;
+	qp->sk->sk->sk_user_data = qp;
 
 	/* pick a source UDP port number for this QP based on
 	 * the source QPN. this spreads traffic for different QPs


