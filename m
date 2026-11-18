Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041741;
	b=isWG9lOHvxIeZlcsaHGVyS62njxYfad3OCT1XX6LaYbLQOHHmDo6MitDdrs9KJUcFk0G
	 v5cItgCLS/OFF3BGmEszU80aD49+YxnrjLidAfKiMvQTc3qob5q2xtVPo1j8i2g/J1yfK
	 p0stPiiqwZSC0ipjrYSYCjEHlP2bODd/MMPRxEfqjhW8UgOy3kTFyWPmGgb4hWzVViKwS
	 x0CsDCnMyFRrtmd09LvIMCCy/tABOgOpSiQH0s3l3mzOCx8ILnNg3SPPjbKlB1lkJctAc
	 8jOsggxXoLXoq8UssWwwnzN7a2ZCGE/4qd6DzLSBsVaH9AHMCUcVJhFRUwCyebfLbHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041741;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3Up/QP8cVftIjw+TJV8HzXopykzY4146sfVd8nGm4d8=;
	b=PeGhKGOIjNIwC2d1XJzKuyW3bRuXp6inan2EnA4WoS6OwQDT8vIPBypskDS2mpaxPaMP
	 nBZ/4o0oevK5YPgGSy7rKWPIGWLUo/agLlng2AsnkJs8LHojLli1Z1WPO7e3OX/KNWNEn
	 3snbEcMaHDgiePuaNmPdL9c7R/XI35plZ+yoV6PhW3t5UTEaMW6TZ/a8Ug8hLj28vlY3r
	 jMuNpqWayFmXknSuD032PQZCiz03oEZc2bSBikszjL4UN+23DOI920ROIS8Wln+sREFbp
	 TSzeSw7gfQjk8vo6eRch/qPrLnIrF039U+A4AcpJ6WXccsaYonx8r1chnnPP6AAsvHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fE4uF+Oy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738A0606A325;
	Wed, 18 Nov 2026 22:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fE4uF+Oy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD431F000C4;
	Wed, 18 Nov 2026 22:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041741;
	bh=3Up/QP8cVftIjw+TJV8HzXopykzY4146sfVd8nGm4d8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fE4uF+OyYkHjcsFLQ4tZ9kzJeKlVVtee8T0VkL/05ZIX2V5kjLxRCKWPHGjIy+EVh
	 7hOkOIaHGFACMGuB4AHFd3i0YnzgdzdGlQpdbFY6iX3/j/LVEzpABS07cqv6Xxbm3I
	 Ah69musFLqKSWclbv/Z939Ekf+5PCPeA/AsJ5Y5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xiongweimin <xiongweimin@kylinos.cn>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2921/3318] RDMA/rxe: Hold netdev reference for transmit skbs
Date: Wed, 18 Nov 2026 15:59:03 +0100
Message-ID: <20261118150448.042491968@linuxfoundation.org>
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

From: xiongweimin <xiongweimin@kylinos.cn>

[ Upstream commit 19881618ffa454c63e6b6bf34acd7cac28c695dc ]

rxe_init_packet() assigns skb->dev from an RCU-protected GID attribute
without holding a netdev reference. If the netdev is unregistered before
the skb is freed, subsequent accesses to skb->dev are unsafe.

Hold a reference with dev_hold() when the skb is initialized and release
it from the transmit destructor or via rxe_put_skb() on error paths that
run before the destructor is installed.

skb->dev can change on the TX path (VLAN/bond/tunnel, ip_finish_output2,
etc.), so put must use the same netdev that was held. Stash that pointer
in skb_shinfo()->destructor_arg: skb->cb is already used by
rxe_pkt_info and is rewritten by IP control blocks.

To avoid blocking netdev unregistration on held skbs, flush all QPs to
the error state on NETDEV_GOING_DOWN and NETDEV_UNREGISTER so pending TX
work is drained and references can be dropped.

Signed-off-by: xiongweimin <xiongweimin@kylinos.cn>
Link: https://patch.msgid.link/20260716055255.157674-1-xiongwm2026@163.com
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 56a27df6cedd ("RDMA/rxe: Fix out-of-range unsigned-to-signed conversion for RDMA message in 2GiB size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_loc.h  |  1 +
 drivers/infiniband/sw/rxe/rxe_net.c  | 68 ++++++++++++++++++++++++++--
 drivers/infiniband/sw/rxe/rxe_req.c  |  2 +-
 drivers/infiniband/sw/rxe/rxe_resp.c |  4 +-
 4 files changed, 68 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index 86675a527cd6b..51d0121a7aa3e 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -91,6 +91,7 @@ void rxe_mw_cleanup(struct rxe_pool_elem *elem);
 /* rxe_net.c */
 struct sk_buff *rxe_init_packet(struct rxe_dev *rxe, struct rxe_av *av,
 				int paylen, struct rxe_pkt_info *pkt);
+void rxe_put_skb(struct sk_buff *skb);
 int rxe_prepare(struct rxe_av *av, struct rxe_pkt_info *pkt,
 		struct sk_buff *skb);
 int rxe_xmit_packet(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 1f0f5d077c453..816636d3701f9 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -343,6 +343,29 @@ int rxe_prepare(struct rxe_av *av, struct rxe_pkt_info *pkt,
 	return err;
 }
 
+/*
+ * skb->dev may be rewritten on the TX path (VLAN/bond/tunnel, etc.).
+ * The netdev we held in rxe_init_packet() is kept in destructor_arg so
+ * that put always matches hold. skb->cb cannot be used: it is already
+ * occupied by struct rxe_pkt_info and rewritten by IP control blocks.
+ */
+static void rxe_skb_set_held_ndev(struct sk_buff *skb, struct net_device *ndev)
+{
+	dev_hold(ndev);
+	skb->dev = ndev;
+	skb_shinfo(skb)->destructor_arg = ndev;
+}
+
+static void rxe_skb_put_held_ndev(struct sk_buff *skb)
+{
+	struct net_device *ndev = skb_shinfo(skb)->destructor_arg;
+
+	if (ndev) {
+		skb_shinfo(skb)->destructor_arg = NULL;
+		dev_put(ndev);
+	}
+}
+
 static void rxe_skb_tx_dtor(struct sk_buff *skb)
 {
 	struct net_device *ndev = skb->dev;
@@ -373,6 +396,18 @@ static void rxe_skb_tx_dtor(struct sk_buff *skb)
 put_dev:
 	ib_device_put(&rxe->ib_dev);
 	sock_put(skb->sk);
+	rxe_skb_put_held_ndev(skb);
+}
+
+/*
+ * Free an skb that still holds a netdev reference from rxe_init_packet()
+ * and does not yet have rxe_skb_tx_dtor() installed. Once the TX
+ * destructor is set, callers must use kfree_skb() instead.
+ */
+void rxe_put_skb(struct sk_buff *skb)
+{
+	rxe_skb_put_held_ndev(skb);
+	kfree_skb(skb);
 }
 
 static int rxe_send(struct sk_buff *skb, struct rxe_pkt_info *pkt)
@@ -468,7 +503,7 @@ int rxe_xmit_packet(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
 	goto done;
 
 drop:
-	kfree_skb(skb);
+	rxe_put_skb(skb);
 	err = 0;
 done:
 	return err;
@@ -510,8 +545,7 @@ struct sk_buff *rxe_init_packet(struct rxe_dev *rxe, struct rxe_av *av,
 
 	skb_reserve(skb, hdr_len + LL_RESERVED_SPACE(ndev));
 
-	/* FIXME: hold reference to this netdev until life of this skb. */
-	skb->dev	= ndev;
+	rxe_skb_set_held_ndev(skb, ndev);
 	rcu_read_unlock();
 
 	if (av->network_type == RXE_NETWORK_TYPE_IPV4)
@@ -618,6 +652,28 @@ void rxe_set_port_state(struct rxe_dev *rxe)
 	dev_put(ndev);
 }
 
+/*
+ * Move all QPs to the error state so pending send/recv work is drained and
+ * in-flight TX skbs (which hold a netdev reference) can be released. Called
+ * from the netdev notifier so unregister cannot stall on held skbs.
+ */
+static void rxe_flush_qps(struct rxe_dev *rxe)
+{
+	struct rxe_pool_elem *elem;
+	struct rxe_qp *qp;
+	unsigned long index;
+
+	rcu_read_lock();
+	xa_for_each(&rxe->qp_pool.xa, index, elem) {
+		if (!elem || !kref_get_unless_zero(&elem->ref_cnt))
+			continue;
+		qp = elem->obj;
+		rxe_qp_error(qp);
+		rxe_put(qp);
+	}
+	rcu_read_unlock();
+}
+
 static int rxe_notify(struct notifier_block *not_blk,
 		      unsigned long event,
 		      void *arg)
@@ -629,7 +685,12 @@ static int rxe_notify(struct notifier_block *not_blk,
 		return NOTIFY_OK;
 
 	switch (event) {
+	case NETDEV_GOING_DOWN:
+		/* Start draining TX queues before the netdev disappears. */
+		rxe_flush_qps(rxe);
+		break;
 	case NETDEV_UNREGISTER:
+		rxe_flush_qps(rxe);
 		ib_unregister_device_queued(&rxe->ib_dev);
 		break;
 	case NETDEV_UP:
@@ -646,7 +707,6 @@ static int rxe_notify(struct notifier_block *not_blk,
 		rxe_set_port_state(rxe);
 		break;
 	case NETDEV_REBOOT:
-	case NETDEV_GOING_DOWN:
 	case NETDEV_CHANGEADDR:
 	case NETDEV_CHANGENAME:
 	case NETDEV_FEAT_CHANGE:
diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index c7c025132bbc3..4ca7d536b9ccc 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -853,7 +853,7 @@ int rxe_requester(struct rxe_qp *qp)
 			wqe->status = IB_WC_LOC_PROT_ERR;
 		else
 			wqe->status = IB_WC_LOC_QP_OP_ERR;
-		kfree_skb(skb);
+		rxe_put_skb(skb);
 		if (ah)
 			rxe_put(ah);
 		goto err;
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 2eff46c5e1102..defcc8a62dcc6 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -849,7 +849,7 @@ static struct sk_buff *prepare_ack_packet(struct rxe_qp *qp,
 
 	err = rxe_prepare(&qp->pri_av, ack, skb);
 	if (err) {
-		kfree_skb(skb);
+		rxe_put_skb(skb);
 		return NULL;
 	}
 
@@ -977,7 +977,7 @@ static enum resp_states read_reply(struct rxe_qp *qp,
 	err = rxe_mr_copy(mr, res->read.va, payload_addr(&ack_pkt),
 			  payload, RXE_FROM_MR_OBJ);
 	if (err) {
-		kfree_skb(skb);
+		rxe_put_skb(skb);
 		state = RESPST_ERR_RKEY_VIOLATION;
 		goto err_out;
 	}
-- 
2.53.0



