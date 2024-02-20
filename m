Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9AF1509BF;
	Tue, 20 Feb 2024 21:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463021; cv=none; b=HG2w/cTOPsbLfHT2pO1FZlUAt85R2yFQhYNuDuOLvSxYoJUhVPl8Kw6eMurVl/zc+3PKs/RZTURRf6zKLqB8kHJtC5PGmkaNZSyh580n8O4gTtpIPN8M6+MF7Twc1p8BouBeVPG0VeCCf+0thYpH5bU6SmhAf856p6DGKegOTDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463021; c=relaxed/simple;
	bh=v6k1uTVDH2u+qQ+5ULS9REQubnyivn/JppqISCDecMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ppwh6GY2Q4zEmklHtJOn37seFVyNBNdSGjk7cw1hztx+KWVSb4LKp11hqxvx/mjJSo1GWo2BKmrIl2/TC1F3sLH3LlSLR2Wz9RFogXVZkyMLDZ/kT3nfXJPtbTU20pL8UKt/CbYRiv1tRMv42jYEyE0s2lAq3ZYizZ6XwmZ3V+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ygVz/mNY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ygVz/mNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF7DC433F1;
	Tue, 20 Feb 2024 21:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463021;
	bh=v6k1uTVDH2u+qQ+5ULS9REQubnyivn/JppqISCDecMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ygVz/mNYr9aTHLUjfpMNalCMnqzY96GRRUB0VRPfImmsDFEkkiXzauqndQLYcvhqx
	 cyjUbjAl4Yzp3KJWNYnBYEuCR1Luen//xin6oU/018HEw06uHd5RUGA3wYdM3fhk6D
	 URDW2PSRvebJDhEZsfKUTlZblW/61AkZgN1JZIBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sri Sakthi <srisakthi.s@gmail.com>
Subject: [PATCH 6.1 111/197] xfrm: Remove inner/outer modes from output path
Date: Tue, 20 Feb 2024 21:51:10 +0100
Message-ID: <20240220204844.403079513@linuxfoundation.org>
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

commit f4796398f21b9844017a2dac883b1dd6ad6edd60 upstream.

The inner/outer modes were added to abstract out common code that
were once duplicated between IPv4 and IPv6.  As time went on the
abstractions have been removed and we are now left with empty
shells that only contain duplicate information.  These can be
removed one-by-one as the same information is already present
elsewhere in the xfrm_state object.

Just like the input-side, removing this from the output code
makes it possible to use transport-mode SAs underneath an
inter-family tunnel mode SA.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Sri Sakthi <srisakthi.s@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_output.c |   33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -414,7 +414,7 @@ static int xfrm4_prepare_output(struct x
 	IPCB(skb)->flags |= IPSKB_XFRM_TUNNEL_SIZE;
 	skb->protocol = htons(ETH_P_IP);
 
-	switch (x->outer_mode.encap) {
+	switch (x->props.mode) {
 	case XFRM_MODE_BEET:
 		return xfrm4_beet_encap_add(x, skb);
 	case XFRM_MODE_TUNNEL:
@@ -437,7 +437,7 @@ static int xfrm6_prepare_output(struct x
 	skb->ignore_df = 1;
 	skb->protocol = htons(ETH_P_IPV6);
 
-	switch (x->outer_mode.encap) {
+	switch (x->props.mode) {
 	case XFRM_MODE_BEET:
 		return xfrm6_beet_encap_add(x, skb);
 	case XFRM_MODE_TUNNEL:
@@ -453,22 +453,22 @@ static int xfrm6_prepare_output(struct x
 
 static int xfrm_outer_mode_output(struct xfrm_state *x, struct sk_buff *skb)
 {
-	switch (x->outer_mode.encap) {
+	switch (x->props.mode) {
 	case XFRM_MODE_BEET:
 	case XFRM_MODE_TUNNEL:
-		if (x->outer_mode.family == AF_INET)
+		if (x->props.family == AF_INET)
 			return xfrm4_prepare_output(x, skb);
-		if (x->outer_mode.family == AF_INET6)
+		if (x->props.family == AF_INET6)
 			return xfrm6_prepare_output(x, skb);
 		break;
 	case XFRM_MODE_TRANSPORT:
-		if (x->outer_mode.family == AF_INET)
+		if (x->props.family == AF_INET)
 			return xfrm4_transport_output(x, skb);
-		if (x->outer_mode.family == AF_INET6)
+		if (x->props.family == AF_INET6)
 			return xfrm6_transport_output(x, skb);
 		break;
 	case XFRM_MODE_ROUTEOPTIMIZATION:
-		if (x->outer_mode.family == AF_INET6)
+		if (x->props.family == AF_INET6)
 			return xfrm6_ro_output(x, skb);
 		WARN_ON_ONCE(1);
 		break;
@@ -866,21 +866,10 @@ static int xfrm6_extract_output(struct x
 
 static int xfrm_inner_extract_output(struct xfrm_state *x, struct sk_buff *skb)
 {
-	const struct xfrm_mode *inner_mode;
-
-	if (x->sel.family == AF_UNSPEC)
-		inner_mode = xfrm_ip2inner_mode(x,
-				xfrm_af2proto(skb_dst(skb)->ops->family));
-	else
-		inner_mode = &x->inner_mode;
-
-	if (inner_mode == NULL)
-		return -EAFNOSUPPORT;
-
-	switch (inner_mode->family) {
-	case AF_INET:
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
 		return xfrm4_extract_output(x, skb);
-	case AF_INET6:
+	case htons(ETH_P_IPV6):
 		return xfrm6_extract_output(x, skb);
 	}
 


