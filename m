Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B3137BE84;
	Fri,  7 Aug 2026 15:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115359; cv=none; b=McSOXhF49e47zHUzpz6nPBEOBPHbnSBIdOPIk+EUuMxV59BEvIvoHYkPCn5D1M+ooSY4DHiT7wISXf1ro/kQsltVxAp/2O44Ir4v4UzqldB9tPu92ltkoK6AIqf4CUyU67Q+igJUd+hgW74zY1vqCaxzwqk1U9Tb+m0ZMKDnMKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115359; c=relaxed/simple;
	bh=fg0oZ7hdnGC1xNsxrfv3sp/wkKRHWpX9KHwl3WjNhsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p5AW/vFIV9RqEuhUqtPxiCUMsp7TC/fsHojnFjsAWNoRP0GvsEI9whaqx7CFJU4HEXuhFrD8qm3CV1TOIgQP5Qiic5gelh6p24JH/52KaSVlBi4yBtbTXLpPrusrjeHCTXyzHE4F+0tvbsDcNNU/jUd6OCNVwFXY3h6eUvwkXNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFzE24+s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFzE24+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1AC11F00A3A;
	Fri,  7 Aug 2026 15:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115357;
	bh=WqkdclazpO4Z89KZZBO3IKhPr7DUVd20GrCei94QMNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gFzE24+s/Qy0Xr4U0pj3ZkR+jPrvBsvYv5fgZc99BLxhU45VxYAa1hurcoLi4iN4Y
	 pYgxOIiFgzDn8UBOcJn7pH3q4HWsbFmduXZ13w6wb8HHw+ssTaFxa34rxaf1mB/9Jl
	 y0kSBEm3zhsOiW9/2S4T1cLen7cXv6FIH0ZmB9no=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 249/396] vxlan: use pskb_network_may_pull() in route_shortcircuit()
Date: Fri,  7 Aug 2026 16:36:49 +0200
Message-ID: <20260807143429.622547823@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

commit 26bb2dd0a8839617e2c79ffbbe1923f8e4bab9fb upstream.

route_shortcircuit() currently calls pskb_may_pull(skb, sizeof(struct iphdr))
(or ipv6hdr), which checks if bytes are available starting from skb->data.

However, in vxlan_xmit(), skb->data points to the MAC header, so
skb_network_offset(skb) is ETH_HLEN (14 bytes). Using pskb_may_pull(skb, 20)
only checks 20 bytes from skb->data (which is 14 bytes MAC header + 6 bytes of
IP header), leaving the rest of the IP header potentially un-pulled in non-linear
frags. Subsequent dereferences of ip_hdr(skb)->daddr can read beyond the pulled
linear buffer length.

Fix this by using pskb_network_may_pull(), which adds skb_network_offset(skb) to
the length check to ensure the full network header is present in the linear buffer.

Fixes: e4f67addf158 ("add DOVE extensions for VXLAN")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20260723144249.759100-5-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan/vxlan_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2115,7 +2115,7 @@ static bool route_shortcircuit(struct ne
 	{
 		struct iphdr *pip;
 
-		if (!pskb_may_pull(skb, sizeof(struct iphdr)))
+		if (!pskb_network_may_pull(skb, sizeof(struct iphdr)))
 			return false;
 		pip = ip_hdr(skb);
 		n = neigh_lookup(&arp_tbl, &pip->daddr, dev);
@@ -2141,7 +2141,7 @@ static bool route_shortcircuit(struct ne
 		 */
 		if (!ipv6_stub->nd_tbl)
 			return false;
-		if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
+		if (!pskb_network_may_pull(skb, sizeof(struct ipv6hdr)))
 			return false;
 		pip6 = ipv6_hdr(skb);
 		n = neigh_lookup(ipv6_stub->nd_tbl, &pip6->daddr, dev);


