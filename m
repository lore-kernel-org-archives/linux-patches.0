Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A42514C585;
	Tue, 20 Feb 2024 21:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463296; cv=none; b=O6+LuMp8WueGdB2A+zaUlTvp7asbWWj+XPkNlccyshcmyMfckVrIQKHb4MO3AwJ23lMH8WQt2PwMW/8ao2FANkguld55nTXre0WpZVOS34tYdLSFJpWNIphhaFtZXspJ93lEszGRcG0FAZg42/HVyXORMTtLeCzr/x3zoJ/jNHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463296; c=relaxed/simple;
	bh=igqhnclU9RrDHIB7u5zPWvRxp04scWsC1J6TKbyAvAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W/Mb09zrv+nLlhTqRApSjExuiKRIKiBC7MIXjNvti7QeQuCDQ8RCzuLPMbsAwfKW/5y7NOhIacMuru8SejzgFMdf+XfMGK8Ytx45CgoCCKympU9yVOkPzR3OOaiOTCtcNdeGigwROZGtltMaRz+eBCMwduBoK4t3CotqxCbkLPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d5L1avWG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d5L1avWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01265C433F1;
	Tue, 20 Feb 2024 21:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463296;
	bh=igqhnclU9RrDHIB7u5zPWvRxp04scWsC1J6TKbyAvAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d5L1avWGAwdpq+mmhowEIlMoyKqUATt1I0FaHEyK3Sh+SOAV163RCX1N8EkGZRGHU
	 7IB3u3Z5nzKnw0+nkEQw4taEPiD57TY8R0N51j9yFm/Dz85gi7Y2pWem324n50D88x
	 HLBDAP7Q0w1eW2If/haOXwikNFqJIJf6fLdBbH5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.1 168/197] xfrm: Silence warnings triggerable by bad packets
Date: Tue, 20 Feb 2024 21:52:07 +0100
Message-ID: <20240220204846.099230835@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 57010b8ece2821a1fdfdba2197d14a022f3769db upstream.

After the elimination of inner modes, a couple of warnings that
were previously unreachable can now be triggered by malformed
inbound packets.

Fix this by:

1. Moving the setting of skb->protocol into the decap functions.
2. Returning -EINVAL when unexpected protocol is seen.

Reported-by: Maciej Żenczykowski<maze@google.com>
Fixes: 5f24f41e8ea6 ("xfrm: Remove inner/outer modes from input path")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Maciej Żenczykowski <maze@google.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_input.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -180,6 +180,8 @@ static int xfrm4_remove_beet_encap(struc
 	int optlen = 0;
 	int err = -EINVAL;
 
+	skb->protocol = htons(ETH_P_IP);
+
 	if (unlikely(XFRM_MODE_SKB_CB(skb)->protocol == IPPROTO_BEETPH)) {
 		struct ip_beet_phdr *ph;
 		int phlen;
@@ -232,6 +234,8 @@ static int xfrm4_remove_tunnel_encap(str
 {
 	int err = -EINVAL;
 
+	skb->protocol = htons(ETH_P_IP);
+
 	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
 		goto out;
 
@@ -267,6 +271,8 @@ static int xfrm6_remove_tunnel_encap(str
 {
 	int err = -EINVAL;
 
+	skb->protocol = htons(ETH_P_IPV6);
+
 	if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
 		goto out;
 
@@ -296,6 +302,8 @@ static int xfrm6_remove_beet_encap(struc
 	int size = sizeof(struct ipv6hdr);
 	int err;
 
+	skb->protocol = htons(ETH_P_IPV6);
+
 	err = skb_cow_head(skb, size + skb->mac_len);
 	if (err)
 		goto out;
@@ -346,6 +354,7 @@ xfrm_inner_mode_encap_remove(struct xfrm
 			return xfrm6_remove_tunnel_encap(x, skb);
 		break;
 		}
+		return -EINVAL;
 	}
 
 	WARN_ON_ONCE(1);
@@ -366,19 +375,6 @@ static int xfrm_prepare_input(struct xfr
 		return -EAFNOSUPPORT;
 	}
 
-	switch (XFRM_MODE_SKB_CB(skb)->protocol) {
-	case IPPROTO_IPIP:
-	case IPPROTO_BEETPH:
-		skb->protocol = htons(ETH_P_IP);
-		break;
-	case IPPROTO_IPV6:
-		skb->protocol = htons(ETH_P_IPV6);
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		break;
-	}
-
 	return xfrm_inner_mode_encap_remove(x, skb);
 }
 


