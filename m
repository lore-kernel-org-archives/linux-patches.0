Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585680;
	b=FTVSt41K7QTDvECoArQTgLCf5VCxjm6/N1e7RVY8JZVpPrLcKbBVoJOrBjvT3eE+IFHz
	 pKM9XIH89oXl4XPujZZLrcG8TIfyREtVImsf4MWVKwBjadP5Lu88YIDMr6Tm7EAV2oewq
	 rg0Z86Bu6QglCalJhzsBXc4UYl8sDFDGn4DLy2lT6Iql6hu2csI5xvVYZs76ahFZsNZeh
	 j6DM7K0fbhUmGscXpLEHAzIntkJCTas8EKUEr7egqDFrumu3THg8BEc0xtqKVXwkjHK3P
	 EGvOuomD3WL+CY1Hw+sBIIU8rZJilQgOo683vwXyfob21N94m43auai486hwugkS+YA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585680;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YRlO7cE2VvdCYBWJs9SkFrMzsC9aIb6qhSp+tf+ZpO4=;
	b=RI9C7jxpjbzFnd55S+C/MI5UMmtWK9W9/Q8lsLkCvhUAVbK4g5WA0PZDD/oYUVIq6UUh
	 jXqEfn5yR9H30RUnd1t5b9ZRu9aqdSB4AquXr+tGbv2MXzATGsi0VVsqXAYdrTLcoVia/
	 2E64YYIvnd/Nkfo9faSHTEG31lYg9W/+EjjAlM/TYaWvrxVJ4enqWEM/iUQf3UQUcJZKs
	 Sb/9U4qQnDxC5ieILdOXux3KuURQMQPo6jn5EC4vGaUHngj26LhxfaErjQmriQ/j7wOBf
	 /FYqB3+R6yhXZCYmoviTP0riFe90uyEYaO1Mtj2ozLV/LZxKsQmiay3q93+vhaovWWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P2leMcbT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E6B606A88F;
	Fri, 13 Nov 2026 16:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P2leMcbT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14DE31F000C4;
	Fri, 13 Nov 2026 16:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585680;
	bh=YRlO7cE2VvdCYBWJs9SkFrMzsC9aIb6qhSp+tf+ZpO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P2leMcbT+J6lL3NIRiYPBYiSMVgr7YUDL82F3omQkfDdPAgjsl43xfRoZFEVP4Lsp
	 yscatVKvMMIOi0Bg83L4cUIaXniCWUNe1FfR0GB57C+3nCWtweu14STDPhp71QnShr
	 ISqx72iK0qn7OIGcMhelLkU5oKriWWbaKLjSY/cQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cunhao Lu <1579567540@qq.com>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 292/507] can: skb: make echo skb freeing safe in any IRQ context
Date: Fri, 13 Nov 2026 10:49:56 -0500
Message-ID: <20261113153805.149696581@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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

---

FAQ:

Q: What about the comment in drivers/net/can/virtio_can.c
   virtio_can_start_xmit()? The error handling for virtqueue_add_sgs()
   mentions that can_put_echo_skb() consumes the skb via consume_skb().

A: The comment in virtio_can.c will be updated in a separate series, to
   ease backporting of this patch.

[mkl: add FAQ section]

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev/skb.c | 6 +++---
 include/linux/can/dev.h   | 2 +-
 include/linux/can/skb.h   | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index bc0787535b524..46c151eece8f7 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -63,7 +63,7 @@ int can_put_echo_skb(struct sk_buff *skb, struct net_device *dev,
 	    (skb->protocol != htons(ETH_P_CAN) &&
 	     skb->protocol != htons(ETH_P_CANFD) &&
 	     skb->protocol != htons(ETH_P_CANXL))) {
-		kfree_skb(skb);
+		dev_kfree_skb_any(skb);
 		return 0;
 	}
 
@@ -91,7 +91,7 @@ int can_put_echo_skb(struct sk_buff *skb, struct net_device *dev,
 	} else {
 		/* locking problem with netif_stop_queue() ?? */
 		netdev_err(dev, "%s: BUG! echo_skb %d is occupied!\n", __func__, idx);
-		kfree_skb(skb);
+		dev_kfree_skb_any(skb);
 		return -EBUSY;
 	}
 
@@ -403,7 +403,7 @@ bool can_dropped_invalid_skb(struct net_device *dev, struct sk_buff *skb)
 	return false;
 
 inval_skb:
-	kfree_skb(skb);
+	dev_kfree_skb_any(skb);
 	dev->stats.tx_dropped++;
 	return true;
 }
diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index 6d0710d6f571d..346faddee02eb 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -176,7 +176,7 @@ static inline bool can_dev_dropped_skb(struct net_device *dev, struct sk_buff *s
 	return can_dropped_invalid_skb(dev, skb);
 
 invalid_skb:
-	kfree_skb(skb);
+	dev_kfree_skb_any(skb);
 	dev->stats.tx_dropped++;
 	return true;
 }
diff --git a/include/linux/can/skb.h b/include/linux/can/skb.h
index 5d27843862fca..87ace09c0d8bd 100644
--- a/include/linux/can/skb.h
+++ b/include/linux/can/skb.h
@@ -78,12 +78,12 @@ static inline struct sk_buff *can_create_echo_skb(struct sk_buff *skb)
 
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



