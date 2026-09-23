Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A08374E64;
	Wed, 23 Sep 2026 14:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175246; cv=none; b=kdksbPHSPzGRq+gU3s2RSAURzIZeEhfjzBmTSVAEroOK1f16u5j5Tl1JZPHN2DL1l1vdY6vcPcX1UcAVKz5UrvmTL4zgA6UcigBrueS09sqTKduQVmrpR9l/g7P15D0lt49G06thNKh4VtsObsdvk4Dj7NnCqylm1469FqWPobU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175246; c=relaxed/simple;
	bh=36IY8OjONSA6bQe+TPnfcNmaXFUGC9GS/MBV64W7Q+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G16M4MBna3K+EyPSWxpT9KoRHV6ESYTD4djvb4ZFsD2eeGub4Tu6TBXuhS41qvournKvEjB+MrBgTIIbaPA9cd+M6ygdtHL+6l7Ws/ojEEH9blZ8xvsDiZRRmmGeZ8rhcovaZxbkZkes1/Q/0YsMjINgoMmmsc/K57c9NyNI348=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gi7b3h6b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gi7b3h6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55FC51F000FF;
	Wed, 23 Sep 2026 14:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175245;
	bh=Rq2fsOc0btZikY4yn0bRS92KURridAA96x+ZQjiPlzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gi7b3h6bIKneMu2gWBeoyiAISfkJQRyxGefF5VvWq46+DyhvBNuGOsJvi9UawmcFh
	 tYLZW6QbgTMYx1oV14a6uiTxl2qlam6vEGUC7B6/w/rQ8/tvzdpveOJLIGDqkE3wG5
	 kpDleeB4nVEkqT2Vdv4YbMo3oasgHwC5rV3KuDL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 367/398] xfrm: save input state data before secpath resets
Date: Wed, 23 Sep 2026 16:07:21 +0200
Message-ID: <20260923140652.954077718@linuxfoundation.org>
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

From: Zhiling Zou <zhilinz@nebusec.ai>

[ Upstream commit 3cf5cdecd99c9c186a5ea518d93bbf3045b6e3aa ]

xfrm_input() stores the current xfrm_state in the skb secpath while it
continues receive-side processing. Some input paths can reset that secpath
before xfrm_input() has finished dereferencing the state.

Receive callback users such as VTI and XFRM interfaces can reset the
secpath. The VTI receive path does so before checking whether the packet
crosses network namespaces, while the XFRM interface path does so only for
cross-network-namespace packets. The XFRM_MAX_DEPTH error path can also
reset the secpath before the final drop callback reports the current
state's protocol.

If secpath_reset() drops the last state reference while the state is
concurrently deleted, xfrm_input() can still dereference the freed state
when selecting transport_finish() or reporting the drop callback protocol.

Save the state protocol on the stack while the state is still valid,
and use the already saved address family for transport_finish(). A larval
XFRM_STATE_ACQ state has no type, so retain nexthdr as its protocol. This
preserves the existing drop-path fallback while avoiding the post-reset
state dereferences without adding an extra state reference to every
received packet.

Fixes: df3893c176e9 ("vti: Update the ipv4 side to use it's own receive hook.")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_input.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -471,6 +471,7 @@ int xfrm_input(struct sk_buff *skb, int
 	struct xfrm_state *x = NULL;
 	xfrm_address_t *daddr;
 	u32 mark = skb->mark;
+	u8 xfrm_proto = nexthdr;
 	unsigned int family = AF_UNSPEC;
 	int decaps = 0;
 	int async = 0;
@@ -482,6 +483,7 @@ int xfrm_input(struct sk_buff *skb, int
 	if (encap_type < 0 || (xo && (xo->flags & XFRM_GRO || encap_type == 0 ||
 				      encap_type == UDP_ENCAP_ESPINUDP))) {
 		x = xfrm_input_state(skb);
+		xfrm_proto = x->type ? x->type->proto : nexthdr;
 
 		if (unlikely(x->km.state != XFRM_STATE_VALID)) {
 			if (x->km.state == XFRM_STATE_ACQ)
@@ -589,11 +591,13 @@ int xfrm_input(struct sk_buff *skb, int
 
 		x = xfrm_input_state_lookup(net, mark, daddr, spi, nexthdr, family);
 		if (x == NULL) {
+			xfrm_proto = nexthdr;
 			secpath_reset(skb);
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMINNOSTATES);
 			xfrm_audit_state_notfound(skb, family, spi, seq);
 			goto drop;
 		}
+		xfrm_proto = x->type ? x->type->proto : nexthdr;
 
 		if (unlikely(x->dir && x->dir != XFRM_SA_DIR_IN)) {
 			secpath_reset(skb);
@@ -601,6 +605,7 @@ int xfrm_input(struct sk_buff *skb, int
 			xfrm_audit_state_notfound(skb, family, spi, seq);
 			xfrm_state_put(x);
 			x = NULL;
+			xfrm_proto = nexthdr;
 			goto drop;
 		}
 
@@ -725,7 +730,7 @@ resume_decapped:
 	} while (!err);
 
 	rcu_read_lock();
-	err = xfrm_rcv_cb(skb, family, x->type->proto, 0);
+	err = xfrm_rcv_cb(skb, family, xfrm_proto, 0);
 	if (err) {
 		rcu_read_unlock();
 		goto drop;
@@ -750,7 +755,7 @@ resume_decapped:
 			xfrm_gro = xo->flags & XFRM_GRO;
 
 		err = -EAFNOSUPPORT;
-		afinfo = xfrm_state_afinfo_get_rcu(x->props.family);
+		afinfo = xfrm_state_afinfo_get_rcu(family);
 		if (likely(afinfo))
 			err = afinfo->transport_finish(skb, xfrm_gro || async);
 		if (xfrm_gro) {
@@ -773,7 +778,7 @@ drop_unlock:
 drop:
 	if (async)
 		dev_put(dev);
-	xfrm_rcv_cb(skb, family, x && x->type ? x->type->proto : nexthdr, -1);
+	xfrm_rcv_cb(skb, family, xfrm_proto, -1);
 	kfree_skb(skb);
 	return 0;
 }


