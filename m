Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0034FB9C3;
	Wed, 30 Sep 2026 17:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788935; cv=none; b=BIA0ZCgq45WURxZQQvImHnpeiA0eYZTJtlnWdL3uRO3uujYmFrnTplORE63mkbUeKgvxgFV2U92AwT7E79KxOCBh14DpfLixT7Lq9G8FQcp4aZ4ZaEAk2xdp+wEWOOm6lwSxh+twbTEIXNydh1jBiGCyqVJD4HZ+4yyJ6nDP1nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788935; c=relaxed/simple;
	bh=8J6BC8gezqFtVIDbOK7aWU1uqJrM4akpTUzK6s1/IEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qfz1zGYI1ldOeQe0a0BVlQF3uLUAa89H9eC7gZTrZ2gs1eWqiu4PfGffGn/HQa82+h1WtH9bKTp6JpQlUexynvhT5KuhyLmicFHnSJdr0Vw3SKY6uCXondsX8XUfLhurxQkwiNDvoxGwOJT1l24JIM4iaPYhA7Ovc1D+z+3JW9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TWEszVLm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TWEszVLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 171741F000FF;
	Wed, 30 Sep 2026 17:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788934;
	bh=G9TUZ9CcFPSeab3la+eo6uD+T3HPGSU844OZ1nGL3qI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TWEszVLm8bz31PwrO4j6pG0sfOL+RPKv6nyDDqaC47Njd0nWFnv2f0XS+/cmvkqIs
	 LEGgvNeIY4zfqiELdA6q+m1QflBP/9oX7OuUv9i+tZbdo+aV5QPKzYf5jhYIfyYgqc
	 CRq0YxLf1T1xatiJ0knlYMxSqFw4eBt+Qrie5LOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 298/877] xfrm: save input state data before secpath resets
Date: Wed, 30 Sep 2026 17:20:09 +0200
Message-ID: <20260930152421.134387829@linuxfoundation.org>
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
---
 net/xfrm/xfrm_input.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index ba512e9293201..63d1504b50a92 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -464,6 +464,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 	struct xfrm_state *x = NULL;
 	xfrm_address_t *daddr;
 	u32 mark = skb->mark;
+	u8 xfrm_proto = nexthdr;
 	unsigned int family = AF_UNSPEC;
 	int decaps = 0;
 	int async = 0;
@@ -475,6 +476,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 	if (encap_type < 0 || (xo && (xo->flags & XFRM_GRO || encap_type == 0 ||
 				      encap_type == UDP_ENCAP_ESPINUDP))) {
 		x = xfrm_input_state(skb);
+		xfrm_proto = x->type ? x->type->proto : nexthdr;
 
 		if (unlikely(x->km.state != XFRM_STATE_VALID)) {
 			if (x->km.state == XFRM_STATE_ACQ)
@@ -578,11 +580,13 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 
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
@@ -590,6 +594,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 			xfrm_audit_state_notfound(skb, family, spi, seq);
 			xfrm_state_put(x);
 			x = NULL;
+			xfrm_proto = nexthdr;
 			goto drop;
 		}
 
@@ -709,7 +714,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 	} while (!err);
 
 	rcu_read_lock();
-	err = xfrm_rcv_cb(skb, family, x->type->proto, 0);
+	err = xfrm_rcv_cb(skb, family, xfrm_proto, 0);
 	if (err) {
 		rcu_read_unlock();
 		goto drop;
@@ -734,7 +739,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 			xfrm_gro = xo->flags & XFRM_GRO;
 
 		err = -EAFNOSUPPORT;
-		afinfo = xfrm_state_afinfo_get_rcu(x->props.family);
+		afinfo = xfrm_state_afinfo_get_rcu(family);
 		if (likely(afinfo))
 			err = afinfo->transport_finish(skb, xfrm_gro || async);
 		if (xfrm_gro) {
@@ -757,7 +762,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 drop:
 	if (async)
 		dev_put(dev);
-	xfrm_rcv_cb(skb, family, x && x->type ? x->type->proto : nexthdr, -1);
+	xfrm_rcv_cb(skb, family, xfrm_proto, -1);
 	kfree_skb(skb);
 	return 0;
 }
-- 
2.53.0



