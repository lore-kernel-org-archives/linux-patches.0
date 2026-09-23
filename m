Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A068306D2A;
	Wed, 23 Sep 2026 14:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175243; cv=none; b=QgR7mKizVWLT+Ue/I5bvsjpEPpjgTRDwxH85I5LRnNK3Y7rsQdPxvwer/Xq+hR+FqMytlFZOvbM6XK0OIZIT2iKkTh47B1NV3QkdMggQRQXbZoPF9/57YkbsNAOYsMU9N0C2mYR+YdACZDG7Vij0viRZzzlByrSkGUlTKzFEx8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175243; c=relaxed/simple;
	bh=w9x/YYi/6IkHmnvs0qQjH0iErUxpZjULaTlCKWYefZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tOgrYfSb6C/M6+qABK0epbROc/vuAc9CM3F+v+BD7he6K64aFW2Zp5f9n8oZOY3MqabfqM57oxwomo4U83r0qiJG+KXfbbgB1aNL60Wp3dsxAP3q++woFwvLjNF6/PyNmhGJ2/82BeyxO27kzl0u+msrcAUK2ZFditI60GNGttA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BV1zHV7y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BV1zHV7y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B021F000FF;
	Wed, 23 Sep 2026 14:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175242;
	bh=X7ewYrk22M1ihG654ya4PnkXUzUDoGr0n1aDeZWvQTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BV1zHV7yT6mYmEq+s2ELXWWpKqRG0CEsXjKxZVYATgKBSPs4Ey2BpSmD8CoUKXwmJ
	 P3dtg6WxLwXPROnC5R848INrAuBBVSY8eWbHgaxU8h2gik16TvsqVKgDrY5NHOgJf/
	 7Ej0dW9vzgUn9tJGVLheWDm/oVvxLpfkXw8Yklvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Chunxiao <xuchunxiao3@huawei.com>,
	Dong Chenchen <dongchenchen2@huawei.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 366/398] xfrm: Fix dev use-after-free in xfrm async resumption
Date: Wed, 23 Sep 2026 16:07:20 +0200
Message-ID: <20260923140652.927563417@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dong Chenchen <dongchenchen2@huawei.com>

[ Upstream commit 8045c0df98d4f14c54e5cb875f1c9c0ce89fe4ff ]

xfrm async resumption hold skb->dev refcnt until after transport_finish.
However, xfrm_rcv_cb may modify skb->dev to tunnel dev without taking
device reference, such as vti_rcv_cb. The subsequent async resumption
will decrement the tunnel device's reference count, which lead to uaf
of tunnel dev and refcnt leak of orig dev as below:

unregister_netdevice: waiting for vti1 to become free. Usage count = -2

Stash the original skb->dev to fix refcnt imbalance. The new skb->dev set
by xfrm_rcv_cb can race with device teardown. Extend rcu protection over
xfrm_rcv_cb and transport_finish to prevent races.

Fixes: 1c428b038400 ("xfrm: hold dev ref until after transport_finish NF_HOOK")
Reported-by: Xu Chunxiao <xuchunxiao3@huawei.com>
Signed-off-by: Dong Chenchen <dongchenchen2@huawei.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Stable-dep-of: 3cf5cdecd99c ("xfrm: save input state data before secpath resets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/xfrm4_input.c |    2 --
 net/ipv6/xfrm6_input.c |    2 --
 net/xfrm/xfrm_input.c  |   29 ++++++++++++++++-------------
 3 files changed, 16 insertions(+), 17 deletions(-)

--- a/net/ipv4/xfrm4_input.c
+++ b/net/ipv4/xfrm4_input.c
@@ -76,8 +76,6 @@ int xfrm4_transport_finish(struct sk_buf
 	NF_HOOK(NFPROTO_IPV4, NF_INET_PRE_ROUTING,
 		dev_net(dev), NULL, skb, dev, NULL,
 		xfrm4_rcv_encap_finish);
-	if (async)
-		dev_put(dev);
 	return 0;
 }
 
--- a/net/ipv6/xfrm6_input.c
+++ b/net/ipv6/xfrm6_input.c
@@ -71,8 +71,6 @@ int xfrm6_transport_finish(struct sk_buf
 	NF_HOOK(NFPROTO_IPV6, NF_INET_PRE_ROUTING,
 		dev_net(dev), NULL, skb, dev, NULL,
 		xfrm6_transport_finish2);
-	if (async)
-		dev_put(dev);
 	return 0;
 }
 
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -464,6 +464,7 @@ int xfrm_input(struct sk_buff *skb, int
 {
 	const struct xfrm_state_afinfo *afinfo;
 	struct net *net = dev_net(skb->dev);
+	struct net_device *dev = skb->dev;
 	int err;
 	__be32 seq;
 	__be32 seq_hi;
@@ -490,7 +491,7 @@ int xfrm_input(struct sk_buff *skb, int
 					       LINUX_MIB_XFRMINSTATEINVALID);
 
 			if (encap_type == -1)
-				dev_put(skb->dev);
+				dev_put(dev);
 			goto drop;
 		}
 
@@ -652,16 +653,16 @@ lock:
 
 		if (!crypto_done) {
 			spin_unlock(&x->lock);
-			dev_hold(skb->dev);
+			dev_hold(dev);
 
 			nexthdr = x->type->input(x, skb);
 			if (nexthdr == -EINPROGRESS) {
 				if (async)
-					dev_put(skb->dev);
+					dev_put(dev);
 				return 0;
 			}
 
-			dev_put(skb->dev);
+			dev_put(dev);
 			spin_lock(&x->lock);
 		}
 resume:
@@ -696,7 +697,7 @@ resume:
 		err = xfrm_inner_mode_input(x, skb);
 		if (err == -EINPROGRESS) {
 			if (async)
-				dev_put(skb->dev);
+				dev_put(dev);
 			return 0;
 		} else if (err) {
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATEMODEERROR);
@@ -723,9 +724,12 @@ resume_decapped:
 		crypto_done = false;
 	} while (!err);
 
+	rcu_read_lock();
 	err = xfrm_rcv_cb(skb, family, x->type->proto, 0);
-	if (err)
+	if (err) {
+		rcu_read_unlock();
 		goto drop;
+	}
 
 	nf_reset_ct(skb);
 
@@ -736,8 +740,9 @@ resume_decapped:
 		if (skb_valid_dst(skb))
 			skb_dst_drop(skb);
 		if (async)
-			dev_put(skb->dev);
+			dev_put(dev);
 		gro_cells_receive(&gro_cells, skb);
+		rcu_read_unlock();
 		return 0;
 	} else {
 		xo = xfrm_offload(skb);
@@ -745,23 +750,21 @@ resume_decapped:
 			xfrm_gro = xo->flags & XFRM_GRO;
 
 		err = -EAFNOSUPPORT;
-		rcu_read_lock();
 		afinfo = xfrm_state_afinfo_get_rcu(x->props.family);
 		if (likely(afinfo))
 			err = afinfo->transport_finish(skb, xfrm_gro || async);
-		rcu_read_unlock();
 		if (xfrm_gro) {
 			sp = skb_sec_path(skb);
 			if (sp)
 				sp->olen = 0;
 			if (skb_valid_dst(skb))
 				skb_dst_drop(skb);
-			if (async)
-				dev_put(skb->dev);
 			gro_cells_receive(&gro_cells, skb);
-			return err;
 		}
 
+		if (async)
+			dev_put(dev);
+		rcu_read_unlock();
 		return err;
 	}
 
@@ -769,7 +772,7 @@ drop_unlock:
 	spin_unlock(&x->lock);
 drop:
 	if (async)
-		dev_put(skb->dev);
+		dev_put(dev);
 	xfrm_rcv_cb(skb, family, x && x->type ? x->type->proto : nexthdr, -1);
 	kfree_skb(skb);
 	return 0;


