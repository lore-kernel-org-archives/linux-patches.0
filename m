Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D3B470107;
	Tue, 21 Jul 2026 19:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660579; cv=none; b=Ljg8uzPwmX/qL3ekWUmhya3JvLFUxjrroaFZwW/EW9/Aa7x20wRZxYX7Lr4ioabTPQF23OEv9u70elAe9pbPDhm8XSxb2wc6JXZaOjAQ0xAJgWCfZmSmnKGe0STvawkdE8WpzexkQdSKGD1dpHl21u4eGcuDf9q5hGD5WELPCiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660579; c=relaxed/simple;
	bh=uJ+U3987fKQ1kjXWrnBTKxPRkS2n4LXzHYOb+7E/scU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EGBo1x7jF8+nke9UQFlzgE0e1fMGotGErTiESk+yPLRk+cTAa/umfTkhaRteHF1eA9qTCoVLvbvx4BPln0Ff8A0ttv1i/r23+DILqdK2DGTuw9KJrvBL91bOtUDwPbx1++PoI7irYm13G7RiiASi9vapcCpuRui/2VkHNCLI7hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lQemH54p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lQemH54p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEBE71F000E9;
	Tue, 21 Jul 2026 19:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660576;
	bh=LngPpxHEnbcS6hWPiyN6uCs2PEWOAukgfK36Ad2C5qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lQemH54pYrkGJStj8mz3CqYfc3iob7yfviUR20cCTNTPMbdja3McliYFja9Iq4Vbc
	 IV9SlhjiHOlWnrhunGdT1IUXUWBxjVrF19KB+X82Mjy/mXErLl3iOaBT5sePSVGqjH
	 8DLUEavPJAAfhVrOMQV3kDHpWCHXX08+p8RGjAfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Chunxiao <xuchunxiao3@huawei.com>,
	Dong Chenchen <dongchenchen2@huawei.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1032/2077] xfrm: Fix dev use-after-free in xfrm async resumption
Date: Tue, 21 Jul 2026 17:11:45 +0200
Message-ID: <20260721152617.156864337@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/xfrm4_input.c |  2 --
 net/ipv6/xfrm6_input.c |  2 --
 net/xfrm/xfrm_input.c  | 29 ++++++++++++++++-------------
 3 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/net/ipv4/xfrm4_input.c b/net/ipv4/xfrm4_input.c
index c2eac844bcdb4e..f6f2a8ef3f8847 100644
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
index 699a001ac16629..89d0443b530732 100644
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
index e4c2cd24936d3f..eecab337bd0a79 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -467,6 +467,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 {
 	const struct xfrm_state_afinfo *afinfo;
 	struct net *net = dev_net(skb->dev);
+	struct net_device *dev = skb->dev;
 	int err;
 	__be32 seq;
 	__be32 seq_hi;
@@ -493,7 +494,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 					       LINUX_MIB_XFRMINSTATEINVALID);
 
 			if (encap_type == -1)
-				dev_put(skb->dev);
+				dev_put(dev);
 			goto drop;
 		}
 
@@ -655,16 +656,16 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 
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
@@ -699,7 +700,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 		err = xfrm_inner_mode_input(x, skb);
 		if (err == -EINPROGRESS) {
 			if (async)
-				dev_put(skb->dev);
+				dev_put(dev);
 			return 0;
 		} else if (err) {
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATEMODEERROR);
@@ -726,9 +727,12 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
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
 
@@ -739,8 +743,9 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
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
@@ -748,23 +753,21 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
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
 
@@ -772,7 +775,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
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



