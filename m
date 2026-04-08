Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E92E2727F3;
	Wed,  8 Apr 2026 18:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674193; cv=none; b=P24pHLJW29Hv/DbbGw3zfqHMS1rly7dUjyRFKalOG/BIa3bOgjy9Ay/8Ve+nATVYNaloHgYQkzeLBoFf3wnWXU+2wLS7RD7Rc+VBQR56Pv3sO5SOAepl3+Lp6GAA/105zpvt99H6/4BJDcCDDbPrt2kES9tzcUJYdkShJbMpSPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674193; c=relaxed/simple;
	bh=gQirPgQOJVknIH1VkDPw5u2WNtSCzRUytGW/OTPcKnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m1yss9YxGkl19D/iEF3sIStKMO67n27nFppw4JLT3DUbgonun9slQJSEUa4bGH5ZrOhbYBMo9shVnW9MBEXsI8uv7xcU05IvupIH4EFfCWivP/z3owssWfINnpmF0Fvsd7XwDA+8X3gs4JcDASWEj2dpXVTBXCpj7qweD7RnotI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y5sBRzRw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y5sBRzRw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8200C2BCB0;
	Wed,  8 Apr 2026 18:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674193;
	bh=gQirPgQOJVknIH1VkDPw5u2WNtSCzRUytGW/OTPcKnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y5sBRzRwaDe9JXqeBYLBAJZtPIZAj3yvAjx/+leL3rb3ZV/E9Dt6KZ5F1+duHzRBO
	 Hjt03/YeT3bkRVpZG0buXOxP0vx7yiw7LvL+twVWDJaeHdYEzPHd+K59WaNBOhGBCy
	 QEL3qjjzI8NZhUFBgN+VDFrNGXN9Y2pksul/MbJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tangxin Xie <xietangxin@yeah.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 214/242] net: correctly handle tunneled traffic on IPV6_CSUM GSO fallback
Date: Wed,  8 Apr 2026 20:04:14 +0200
Message-ID: <20260408175935.088830927@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit c4336a07eb6b2526dc2b62928b5104b41a7f81f5 ]

NETIF_F_IPV6_CSUM only advertises support for checksum offload of
packets without IPv6 extension headers. Packets with extension
headers must fall back onto software checksumming. Since TSO
depends on checksum offload, those must revert to GSO.

The below commit introduces that fallback. It always checks
network header length. For tunneled packets, the inner header length
must be checked instead. Extend the check accordingly.

A special case is tunneled packets without inner IP protocol. Such as
RFC 6951 SCTP in UDP. Those are not standard IPv6 followed by
transport header either, so also must revert to the software GSO path.

Cc: stable@vger.kernel.org
Fixes: 864e3396976e ("net: gso: Forbid IPv6 TSO with extensions on devices with only IPV6_CSUM")
Reported-by: Tangxin Xie <xietangxin@yeah.net>
Closes: https://lore.kernel.org/netdev/0414e7e2-9a1c-4d7c-a99d-b9039cf68f40@yeah.net/
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260320190148.2409107-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3579,6 +3579,22 @@ static netdev_features_t dflt_features_c
 	return vlan_features_check(skb, features);
 }
 
+static bool skb_gso_has_extension_hdr(const struct sk_buff *skb)
+{
+	if (!skb->encapsulation)
+		return ((skb_shinfo(skb)->gso_type & SKB_GSO_TCPV6 ||
+			 (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4 &&
+			  vlan_get_protocol(skb) == htons(ETH_P_IPV6))) &&
+			skb_transport_header_was_set(skb) &&
+			skb_network_header_len(skb) != sizeof(struct ipv6hdr));
+	else
+		return (!skb_inner_network_header_was_set(skb) ||
+			((skb_shinfo(skb)->gso_type & SKB_GSO_TCPV6 ||
+			  (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4 &&
+			   inner_ip_hdr(skb)->version == 6)) &&
+			 skb_inner_network_header_len(skb) != sizeof(struct ipv6hdr)));
+}
+
 static netdev_features_t gso_features_check(const struct sk_buff *skb,
 					    struct net_device *dev,
 					    netdev_features_t features)
@@ -3625,11 +3641,7 @@ static netdev_features_t gso_features_ch
 	 * so neither does TSO that depends on it.
 	 */
 	if (features & NETIF_F_IPV6_CSUM &&
-	    (skb_shinfo(skb)->gso_type & SKB_GSO_TCPV6 ||
-	     (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4 &&
-	      vlan_get_protocol(skb) == htons(ETH_P_IPV6))) &&
-	    skb_transport_header_was_set(skb) &&
-	    skb_network_header_len(skb) != sizeof(struct ipv6hdr) &&
+	    skb_gso_has_extension_hdr(skb) &&
 	    !ipv6_has_hopopt_jumbo(skb))
 		features &= ~(NETIF_F_IPV6_CSUM | NETIF_F_TSO6 | NETIF_F_GSO_UDP_L4);
 


