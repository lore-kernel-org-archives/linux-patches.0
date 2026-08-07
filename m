Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0119341A576;
	Fri,  7 Aug 2026 14:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114235; cv=none; b=C6oyBwq+9bIOrKT/lC5igecR9PufAZsD+gZISngBK1IzHuWpXnlNyMI2mFeHoVBueSt5DEFvdGAT3zcy3JRsG2LPh9XvcSVUKt8YlytQeFTTTO98j2SRuJfByhv8A3oL9vOqtIDaJbAAAq0s49yo0y+4NJX01Uhca4Pc3IX907w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114235; c=relaxed/simple;
	bh=3aETzuqJbaQr9ZSPO9QuTMyXtniX8zpH70+q5PZ4Gvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkf4JtKzChsCd82qg+K4oXnQdkEOvVJMbigJi4SVgia4ekd1/ns6ejfnh1s/ZMIQtProuVTM/z14vvo3yZwnjaaTzu5Vovms1n6eUxIMgM8xSBZFkbGgReKmYuY3yP8YBS1ja0suKXY9nvv96hh/HuuKKyeKbeMTHWO7dc9vicA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cZ1Np2cH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cZ1Np2cH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284041F00A3A;
	Fri,  7 Aug 2026 14:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114229;
	bh=DL/ZYjudn7eC67besSglaGntUSN4OBSNzlQ94jGywcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cZ1Np2cHRHv0NrtSzaViuLYVqcJwCc1djhXLZN0ySBvMTlV69HLtiiSwxXFGhIXZY
	 hP/CH6QpePtuP/731XwIR4XrUdvop+MUBtCaF5gxM2/3n7dI5g6a6GhP73UjWuArca
	 tusc7E2GANu6DQLbaNnSwm8A/fnONqz13fNmpsgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 190/337] vxlan: use pskb_network_may_pull() in route_shortcircuit()
Date: Fri,  7 Aug 2026 16:36:33 +0200
Message-ID: <20260807143422.677621922@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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
@@ -2138,7 +2138,7 @@ static bool route_shortcircuit(struct ne
 	{
 		struct iphdr *pip;
 
-		if (!pskb_may_pull(skb, sizeof(struct iphdr)))
+		if (!pskb_network_may_pull(skb, sizeof(struct iphdr)))
 			return false;
 		pip = ip_hdr(skb);
 		n = neigh_lookup(&arp_tbl, &pip->daddr, dev);
@@ -2164,7 +2164,7 @@ static bool route_shortcircuit(struct ne
 		 */
 		if (!ipv6_stub->nd_tbl)
 			return false;
-		if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
+		if (!pskb_network_may_pull(skb, sizeof(struct ipv6hdr)))
 			return false;
 		pip6 = ipv6_hdr(skb);
 		n = neigh_lookup(ipv6_stub->nd_tbl, &pip6->daddr, dev);


