Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625020;
	b=rJgA52wsmw4BuAeT4ybIdPXLOZNZ9sE7mHVOytHbLtPe9Y6hR6ptPpb5zFXNJrLbWvYg
	 HZ67A7ehxsUNuOkccw6Bgc0P2QTusmm3qWty89jclu1Vc32GDLCJc87vyffD5N5aQiB5c
	 05DHhDaF7KIsh/hL0v4FK/FY+TxBCmAtxr+Rg5eksBlsFZ6yLfv449TkZQzd2Z5McSk0N
	 /IG+pxxsAttMo2QMmHwNONbEXSav0WaloUgSl8r6KIXWSToO+eHm6iPhiXAJHe0DcioTs
	 FSwE7sqtPNFdiinnYZIYgqB3AbpSMFE9ooRV05pRqUJ5i9ns1BnsyMSuhikQGpJXNLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625020;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lR3EkZb9NnSsfH80uvLwXsqtD755qAfqzy3+SqF04dA=;
	b=rvOdMzw0OX8dUCuZeagBg2JW0rz0aPug9QDVbLwqnS/Jy8S42Jw445dF/8ccRpH9xK1r
	 gnD6HxEpLEus76SuNmW1T2t4hrnTiJ+Z+8EPLljHwT1I5QNAAUWBAbmhjhtLlKnJtpbeg
	 HJqkb65t+cIwPUHQKASC7NIi3vy9CB8UbEmJU/MGlWnQ8wvviLjBUeRAtwqvTwuzZUTVn
	 2Y2vteZRdVsnADI8FZncnXsEUhYsh08HjeXldVMovQUvhb6xnigevwKCx36BV2fpIaoFo
	 CQ21rZnsNNbtE8+u1D6UL00Jczt9OAkmFmZMtMrKFgyWG+QjwdGZOrsFnr8zHgkrX5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TgXip8Io;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3757A606A31E;
	Wed, 25 Nov 2026 16:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TgXip8Io
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7461F000CF;
	Wed, 25 Nov 2026 16:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625020;
	bh=lR3EkZb9NnSsfH80uvLwXsqtD755qAfqzy3+SqF04dA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TgXip8Ioi+w3HXXjqmx1EuDGv5fkdtCWAkQiBL6qZJnZMsdkItqFPbO4DyICon4Pu
	 /rcDG6Axu5v/HBoejgosBKLI8R2WlS3YWofcJWoNkfsxoVljNNLFvmc/HOQswYJ+Z2
	 X5Kxd9epuF9TJcQYhYkAjSUbtlWKemGMxzc8C7lA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cunhao Lu <1579567540@qq.com>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 381/816] can: skb: make echo skb freeing safe in any IRQ context
Date: Wed, 25 Nov 2026 15:32:09 +0100
Message-ID: <20261125143858.024841753@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 23492213ea359..30a3512139cb9 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -160,7 +160,7 @@ static inline bool can_dev_dropped_skb(struct net_device *dev, struct sk_buff *s
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



