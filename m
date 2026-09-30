Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB22036A37E;
	Wed, 30 Sep 2026 17:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788933; cv=none; b=jCkC7IJqJljHgIWAIgFhZTC9MCg82y2uCkGntxmPxjGlOvBpy49mg2BHQ0bviv3KnXu86qUAxcS5LIdhH8OJ22G4SR/JH8WxQQPc5TiMuoXLvE39YGLwfTACQrqAPXvmMic58ZgUF38P1WFS7mWgtRzPE80OUvJ2+Bm7Ubl+a7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788933; c=relaxed/simple;
	bh=Y8+r1D8mzMDfr11iSe9673LjxJUjXmtljhEqZWJn3q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=as6V5GkvzWGxu7vtLzKrINMkj5B40q+IE1SFPL/XeKYAGpGItNwTp5IPA69q7YP/cmMuOALDVlEdrndCmmvwoVtT0m+G1tCh698T9mIvi+02WsDXjAm90njcYfO8Bz1mV1/GQzwsh8zgdUUGTlry/W+J08nrB6+jleGxBPvEZkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LANmfX+F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LANmfX+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514081F000FF;
	Wed, 30 Sep 2026 17:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788931;
	bh=9048m6eBVdWzLEJmPr3QTyvqiw2t0YJ2a8sRB8BFfUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LANmfX+FkLw9TqAmzU+5Rki0v3GShsiZFHOIPFy141EpIF+/SFruhEAITukv2QW9S
	 SDGwEJGrMTwQ8nWGC0TmeZcrFFQLXqyN49ZGf8xkjtyCjFddNBNcIMvyxJBEBGUm+x
	 6TZjwlmgkT5RdkTGp5rKpiWSJkKKbzfYioH+DUEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Chunxiao <xuchunxiao3@huawei.com>,
	Dong Chenchen <dongchenchen2@huawei.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 297/877] xfrm: Fix dev use-after-free in xfrm async resumption
Date: Wed, 30 Sep 2026 17:20:08 +0200
Message-ID: <20260930152421.114180667@linuxfoundation.org>
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

Backport to 6.12: retain the synchronous xfrm_inner_mode_input()
error handling. This tree lacks the mode_cbs infrastructure that
introduced the -EINPROGRESS branch, so omit the dev_put() conversion
for that absent branch. Keep the original-device reference handling
and extended RCU protection for the existing receive paths.

This supplies the receive, transport-finish and drop-path context for
3cf5cdecd99c ("xfrm: save input state data before secpath resets"),
which applies without further changes.

Stable-dep-of: 3cf5cdecd99c ("xfrm: save input state data before secpath resets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/xfrm4_input.c |  2 --
 net/ipv6/xfrm6_input.c |  2 --
 net/xfrm/xfrm_input.c  | 27 +++++++++++++++------------
 3 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/net/ipv4/xfrm4_input.c b/net/ipv4/xfrm4_input.c
index adf21d6b6076c..9deee1558e3d6 100644
--- a/net/ipv4/xfrm4_input.c
+++ b/net/ipv4/xfrm4_input.c
@@ -76,8 +76,6 @@ int xfrm4_transport_finish(struct sk_buff *skb, int async)
 	NF_HOOK(NFPROTO_IPV4, NF_INET_PRE_ROUTING,
 		dev_net(dev), NULL, skb, dev, NULL,
 		xfrm4_rcv_encap_finish);
-	if (async)
-		dev_put(dev);
 	return 0;
 }
 
diff --git a/net/ipv6/xfrm6_input.c b/net/ipv6/xfrm6_input.c
index c9e208c57a6b5..07edef2589844 100644
--- a/net/ipv6/xfrm6_input.c
+++ b/net/ipv6/xfrm6_input.c
@@ -71,8 +71,6 @@ int xfrm6_transport_finish(struct sk_buff *skb, int async)
 	NF_HOOK(NFPROTO_IPV6, NF_INET_PRE_ROUTING,
 		dev_net(dev), NULL, skb, dev, NULL,
 		xfrm6_transport_finish2);
-	if (async)
-		dev_put(dev);
 	return 0;
 }
 
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 444334feece7b..ba512e9293201 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -457,6 +457,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 {
 	const struct xfrm_state_afinfo *afinfo;
 	struct net *net = dev_net(skb->dev);
+	struct net_device *dev = skb->dev;
 	int err;
 	__be32 seq;
 	__be32 seq_hi;
@@ -483,7 +484,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 					       LINUX_MIB_XFRMINSTATEINVALID);
 
 			if (encap_type == -1)
-				dev_put(skb->dev);
+				dev_put(dev);
 			goto drop;
 		}
 
@@ -641,16 +642,16 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 
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
@@ -707,9 +708,12 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
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
 
@@ -720,8 +724,9 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
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
@@ -729,23 +734,21 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
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
 
@@ -753,7 +756,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 	spin_unlock(&x->lock);
 drop:
 	if (async)
-		dev_put(skb->dev);
+		dev_put(dev);
 	xfrm_rcv_cb(skb, family, x && x->type ? x->type->proto : nexthdr, -1);
 	kfree_skb(skb);
 	return 0;
-- 
2.53.0



