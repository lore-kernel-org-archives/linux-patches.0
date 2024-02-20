Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B3E14A4E2;
	Tue, 20 Feb 2024 21:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463025; cv=none; b=PpElNHZfarMwoDW/Hr7QkbYE+Pq4IFcp0xwxqT9h7Nh2JPFqMreYwTWoKZ895vr16xJf+bCIcUFX5lvAJK1MSaODkaBOZf/5xCR8WzYsJhaiWLAYf7WNYQzn0WGJTvzxuuU5QKQp5rS4nHV/jN8Jjci+jXxcTMoq4SQqou+pl40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463025; c=relaxed/simple;
	bh=tOv5XclihDy1jQtSVT4LlHq6Y/nvwuOb/UcI7sAixSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLzQRpe/3rnY3JUIWDw/JC+FpD4PO3bl4mA7uUzy8JlV2aXvDn2BMav9imKNbA0aGkAWTMaeu17RQCKz88EVy2BZmJqIYvMwNIspgJw8erg/U+XR/leX4QJY3J7JaSQ60gPQ6DMNxRwWmO/9hqEfkvdIv7orkJd72buCkk06HAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zx7vrNDS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zx7vrNDS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BCF0C433C7;
	Tue, 20 Feb 2024 21:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463024;
	bh=tOv5XclihDy1jQtSVT4LlHq6Y/nvwuOb/UcI7sAixSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zx7vrNDSy21zUHbt0C+V6N1jr4H4xxCok1b2h9xYokoAeNOWUWe5x3VIWQFhMGnWq
	 ro9NGbzZBJDaqcb1EjXfuifv7VmIqs7OAZkENLR3glQMNbVboxwYk0hx7M7fuLEUiS
	 BX2DGvV7g+0cVv0eTq8n76lW6GQOHdZOvtflXaK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sri Sakthi <srisakthi.s@gmail.com>
Subject: [PATCH 6.1 112/197] xfrm: Remove inner/outer modes from input path
Date: Tue, 20 Feb 2024 21:51:11 +0100
Message-ID: <20240220204844.432141261@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 5f24f41e8ea62a6a9095f9bbafb8b3aebe265c68 upstream.

The inner/outer modes were added to abstract out common code that
were once duplicated between IPv4 and IPv6.  As time went on the
abstractions have been removed and we are now left with empty
shells that only contain duplicate information.  These can be
removed one-by-one as the same information is already present
elsewhere in the xfrm_state object.

Removing them from the input path actually allows certain valid
combinations that are currently disallowed.  In particular, when
a transport mode SA sits beneath a tunnel mode SA that changes
address families, at present the transport mode SA cannot have
AF_UNSPEC as its selector because it will be erroneously be treated
as inter-family itself even though it simply sits beneath one.

This is a serious problem because you can't set the selector to
non-AF_UNSPEC either as that will cause the selector match to
fail as we always match selectors to the inner-most traffic.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Sri Sakthi <srisakthi.s@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_input.c |   66 +++++++++++++++++---------------------------------
 1 file changed, 23 insertions(+), 43 deletions(-)

--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -232,9 +232,6 @@ static int xfrm4_remove_tunnel_encap(str
 {
 	int err = -EINVAL;
 
-	if (XFRM_MODE_SKB_CB(skb)->protocol != IPPROTO_IPIP)
-		goto out;
-
 	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
 		goto out;
 
@@ -270,8 +267,6 @@ static int xfrm6_remove_tunnel_encap(str
 {
 	int err = -EINVAL;
 
-	if (XFRM_MODE_SKB_CB(skb)->protocol != IPPROTO_IPV6)
-		goto out;
 	if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
 		goto out;
 
@@ -332,22 +327,26 @@ out:
  */
 static int
 xfrm_inner_mode_encap_remove(struct xfrm_state *x,
-			     const struct xfrm_mode *inner_mode,
 			     struct sk_buff *skb)
 {
-	switch (inner_mode->encap) {
+	switch (x->props.mode) {
 	case XFRM_MODE_BEET:
-		if (inner_mode->family == AF_INET)
+		switch (XFRM_MODE_SKB_CB(skb)->protocol) {
+		case IPPROTO_IPIP:
+		case IPPROTO_BEETPH:
 			return xfrm4_remove_beet_encap(x, skb);
-		if (inner_mode->family == AF_INET6)
+		case IPPROTO_IPV6:
 			return xfrm6_remove_beet_encap(x, skb);
+		}
 		break;
 	case XFRM_MODE_TUNNEL:
-		if (inner_mode->family == AF_INET)
+		switch (XFRM_MODE_SKB_CB(skb)->protocol) {
+		case IPPROTO_IPIP:
 			return xfrm4_remove_tunnel_encap(x, skb);
-		if (inner_mode->family == AF_INET6)
+		case IPPROTO_IPV6:
 			return xfrm6_remove_tunnel_encap(x, skb);
 		break;
+		}
 	}
 
 	WARN_ON_ONCE(1);
@@ -356,9 +355,7 @@ xfrm_inner_mode_encap_remove(struct xfrm
 
 static int xfrm_prepare_input(struct xfrm_state *x, struct sk_buff *skb)
 {
-	const struct xfrm_mode *inner_mode = &x->inner_mode;
-
-	switch (x->outer_mode.family) {
+	switch (x->props.family) {
 	case AF_INET:
 		xfrm4_extract_header(skb);
 		break;
@@ -370,17 +367,12 @@ static int xfrm_prepare_input(struct xfr
 		return -EAFNOSUPPORT;
 	}
 
-	if (x->sel.family == AF_UNSPEC) {
-		inner_mode = xfrm_ip2inner_mode(x, XFRM_MODE_SKB_CB(skb)->protocol);
-		if (!inner_mode)
-			return -EAFNOSUPPORT;
-	}
-
-	switch (inner_mode->family) {
-	case AF_INET:
+	switch (XFRM_MODE_SKB_CB(skb)->protocol) {
+	case IPPROTO_IPIP:
+	case IPPROTO_BEETPH:
 		skb->protocol = htons(ETH_P_IP);
 		break;
-	case AF_INET6:
+	case IPPROTO_IPV6:
 		skb->protocol = htons(ETH_P_IPV6);
 		break;
 	default:
@@ -388,7 +380,7 @@ static int xfrm_prepare_input(struct xfr
 		break;
 	}
 
-	return xfrm_inner_mode_encap_remove(x, inner_mode, skb);
+	return xfrm_inner_mode_encap_remove(x, skb);
 }
 
 /* Remove encapsulation header.
@@ -434,17 +426,16 @@ static int xfrm6_transport_input(struct
 }
 
 static int xfrm_inner_mode_input(struct xfrm_state *x,
-				 const struct xfrm_mode *inner_mode,
 				 struct sk_buff *skb)
 {
-	switch (inner_mode->encap) {
+	switch (x->props.mode) {
 	case XFRM_MODE_BEET:
 	case XFRM_MODE_TUNNEL:
 		return xfrm_prepare_input(x, skb);
 	case XFRM_MODE_TRANSPORT:
-		if (inner_mode->family == AF_INET)
+		if (x->props.family == AF_INET)
 			return xfrm4_transport_input(x, skb);
-		if (inner_mode->family == AF_INET6)
+		if (x->props.family == AF_INET6)
 			return xfrm6_transport_input(x, skb);
 		break;
 	case XFRM_MODE_ROUTEOPTIMIZATION:
@@ -462,7 +453,6 @@ int xfrm_input(struct sk_buff *skb, int
 {
 	const struct xfrm_state_afinfo *afinfo;
 	struct net *net = dev_net(skb->dev);
-	const struct xfrm_mode *inner_mode;
 	int err;
 	__be32 seq;
 	__be32 seq_hi;
@@ -492,7 +482,7 @@ int xfrm_input(struct sk_buff *skb, int
 			goto drop;
 		}
 
-		family = x->outer_mode.family;
+		family = x->props.family;
 
 		/* An encap_type of -1 indicates async resumption. */
 		if (encap_type == -1) {
@@ -676,17 +666,7 @@ resume:
 
 		XFRM_MODE_SKB_CB(skb)->protocol = nexthdr;
 
-		inner_mode = &x->inner_mode;
-
-		if (x->sel.family == AF_UNSPEC) {
-			inner_mode = xfrm_ip2inner_mode(x, XFRM_MODE_SKB_CB(skb)->protocol);
-			if (inner_mode == NULL) {
-				XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATEMODEERROR);
-				goto drop;
-			}
-		}
-
-		if (xfrm_inner_mode_input(x, inner_mode, skb)) {
+		if (xfrm_inner_mode_input(x, skb)) {
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATEMODEERROR);
 			goto drop;
 		}
@@ -701,7 +681,7 @@ resume:
 		 * transport mode so the outer address is identical.
 		 */
 		daddr = &x->id.daddr;
-		family = x->outer_mode.family;
+		family = x->props.family;
 
 		err = xfrm_parse_spi(skb, nexthdr, &spi, &seq);
 		if (err < 0) {
@@ -732,7 +712,7 @@ resume:
 
 		err = -EAFNOSUPPORT;
 		rcu_read_lock();
-		afinfo = xfrm_state_afinfo_get_rcu(x->inner_mode.family);
+		afinfo = xfrm_state_afinfo_get_rcu(x->props.family);
 		if (likely(afinfo))
 			err = afinfo->transport_finish(skb, xfrm_gro || async);
 		rcu_read_unlock();


