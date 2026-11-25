Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622365;
	b=nlKdq/zZKge+Nd5T6FSci7lhR+V4epTeHVyuPXGcCdE5kGwACggATx0I4yYKJd7YF5nR
	 N+IPiESQ0MQaw95SEVePMe5+Mr41WxV8jyx6o50W+/6B07b7ImENbi+Ounwift4OgTKIo
	 FOe0IzfrakkMjt0AYOzNF51ICP1hNNRz27+mkVebQ2LqoxH4Sj0j3M6QGxcvpPLNgn38M
	 YKrr/HeW1vq0RSkRuhOxNuln6f7n6/LZiy/Ee/8VG5G/7DGq3N6Q5h/ULTXphjW5iI2PL
	 6GPpcDDx3KghZKE4FpdqcP7WEMtdMVZYpA1YQOxcN78R9UjP3CZ93XwxQZva29HiK9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622365;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c3ReF4htuz3zRUC/v2FMgJoNphujXfB4T9zidptwjE0=;
	b=NwE32OTI67jpDUJQNWIwZSXPjHitiKTe8u4Q2O1SWdoq4Y4yFzVHZo4RWt/qoHf9ixp4
	 eXZ8gM/GmMKBhJwLHQJ4B/IaU6HxpU2PRIwLu03VJXWP2nm+xJScWuQJtA19DufZuLKZQ
	 lYyDqRx/OC/idhg4/Lmn79WN8QQnM0K/pscWDlHMUkaHLDpnugtkE0WuKEHhymoPHys+L
	 gg8bNnyYLs/CB9anCNM+fplN+Xvquq1ST6XQB9lyG83dTFu+ANBwjl6HuJorgQZ3xgtP/
	 gQWFjThwJjIIo5/5EF2fz7qLqKu5bQjNA7v44tEiV+EfKZBE9iFtz1olwhTm+paVPlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SnfakIOt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314D7606A321;
	Wed, 25 Nov 2026 15:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SnfakIOt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690D31F000EF;
	Wed, 25 Nov 2026 15:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622365;
	bh=c3ReF4htuz3zRUC/v2FMgJoNphujXfB4T9zidptwjE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SnfakIOtfH1CNHfiWiU2cheNVljJ0ltNPMdJhV/+mbpi9lIz6e5s5MB8IMRlXaqjO
	 oD6pidsy6KpPvAK4ZhgFHy0PgpZFBD9CMAYNlioc9Qb3bquq56/OkxNZ+PpajPgX8s
	 0r6xrqqUU6LLvG0W64FvlBMHIJ/rVkspWjGsVsbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cunhao Lu <1579567540@qq.com>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 497/990] can: skb: make echo skb freeing safe in any IRQ context
Date: Wed, 25 Nov 2026 15:31:04 +0100
Message-ID: <20261125143833.737361052@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cunhao Lu <1579567540@qq.com>

[ Upstream commit d743071964920c92af598c87a9e6f4369263ee09 ]

can_put_echo_skb() can be called with hardware interrupts disabled. Its
direct drop paths use kfree_skb(), while can_create_echo_skb() uses
kfree_skb() when cloning fails and consume_skb() after a successful clone.
None of these helpers is safe in every IRQ context.

Use dev_kfree_skb_any() for all drop paths and dev_consume_skb_any() when
consuming a successfully cloned skb. This preserves the respective skb drop
and consumed semantics regardless of the caller IRQ context.

Signed-off-by: Cunhao Lu <1579567540@qq.com>
Link: https://patch.msgid.link/tencent_E84809CF236D0137885E7E4E4D58340B3208@qq.com
Cc: stable@kernel.org
Fixes: ae64438be192 ("can: dev: fix skb drop check")
Fixes: 0ae89beb283a ("can: add destructor for self generated skbs")
Fixes: 3ccd4c6167d3 ("can: Unify droping of invalid tx skbs and netdev stats")
Fixes: 39549eef3587 ("can: CAN Network device driver and Netlink interface")
[mkl: also convert can_dropped_invalid_skb(), can_dev_dropped_skb()]
[mkl: add stable on Cc + add Fixes tags]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev/skb.c | 6 +++---
 include/linux/can/dev.h   | 2 +-
 include/linux/can/skb.h   | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index b643995fc5369..a39cfdce341ce 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -61,7 +61,7 @@ int can_put_echo_skb(struct sk_buff *skb, struct net_device *dev,
 	    (skb->protocol != htons(ETH_P_CAN) &&
 	     skb->protocol != htons(ETH_P_CANFD) &&
 	     skb->protocol != htons(ETH_P_CANXL))) {
-		kfree_skb(skb);
+		dev_kfree_skb_any(skb);
 		return 0;
 	}
 
@@ -87,7 +87,7 @@ int can_put_echo_skb(struct sk_buff *skb, struct net_device *dev,
 	} else {
 		/* locking problem with netif_stop_queue() ?? */
 		netdev_err(dev, "%s: BUG! echo_skb %d is occupied!\n", __func__, idx);
-		kfree_skb(skb);
+		dev_kfree_skb_any(skb);
 		return -EBUSY;
 	}
 
@@ -368,7 +368,7 @@ bool can_dropped_invalid_skb(struct net_device *dev, struct sk_buff *skb)
 	return false;
 
 inval_skb:
-	kfree_skb(skb);
+	dev_kfree_skb_any(skb);
 	dev->stats.tx_dropped++;
 	return true;
 }
diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index a2229a61ccde8..dbf9684c1a9da 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -103,7 +103,7 @@ static inline bool can_dev_dropped_skb(struct net_device *dev, struct sk_buff *s
 	if (priv->ctrlmode & CAN_CTRLMODE_LISTENONLY) {
 		netdev_info_once(dev,
 				 "interface in listen only mode, dropping skb\n");
-		kfree_skb(skb);
+		dev_kfree_skb_any(skb);
 		dev->stats.tx_dropped++;
 		return true;
 	}
diff --git a/include/linux/can/skb.h b/include/linux/can/skb.h
index 27d0ca115c6c1..1f0c3e8cde907 100644
--- a/include/linux/can/skb.h
+++ b/include/linux/can/skb.h
@@ -92,12 +92,12 @@ static inline struct sk_buff *can_create_echo_skb(struct sk_buff *skb)
 
 	nskb = skb_clone(skb, GFP_ATOMIC);
 	if (unlikely(!nskb)) {
-		kfree_skb(skb);
+		dev_kfree_skb_any(skb);
 		return NULL;
 	}
 
 	can_skb_set_owner(nskb, skb->sk);
-	consume_skb(skb);
+	dev_consume_skb_any(skb);
 	return nskb;
 }
 
-- 
2.53.0



