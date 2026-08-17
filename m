Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2CFE2F1FDF;
	Mon, 17 Aug 2026 15:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980003; cv=none; b=d8kaH9V/HILPaObueYgtjZ9PUawhWk31ShlizD76qD9jyEi5xXsMwzDeifhMg31qjOqDB86D/COQNjE+BBTHByBx0f0FXm/ZvB8uXkZyPv5+J1XFT19wsvpzZnha2Mzy+X2jo3cEClvC+jw+y58w/Eyc/ZWiIKuoC/+8s1kV1Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980003; c=relaxed/simple;
	bh=666zL9AEg5/OLWj+eTt1Fj7L1iiPcvKyXb/E3ELJcqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5xzq8+7fBUIRjmfk8kSi1Bu8ZnuezvFbfYtT6gtKgAe6z56JO5uRIS4io1TjtnR+0j/GsJT9XEfdWPlKTMCnmXYeERuO7jt1ny1nF2Og5ZwjG2+D7q1XBwgQjoh2jUHO+f8Ndhu2FL4jRP62bkenrPYk2VT6zvrchhcvoSxFw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1HdU2jqt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1HdU2jqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E711F000E9;
	Mon, 17 Aug 2026 15:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980002;
	bh=0LaV+ZFyzIHEx9GN89a0OxrCz3XU/tutjUomd2Zbwx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1HdU2jqt2YzeUiuMCuPSie4TovWv1JxUrn6X4oRUPcToWx+JWR3H9Sr00Np9qpPdg
	 2nrFIO8E362/f/rjsKwhG1meZjiDe360fK34vUHzMT2X4ywQLPK1K22uXexDWlkS+3
	 YRjm1P8o06qpbKWv+94GzOr0duC7+hUoDMqWGWsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 422/609] vxlan: use pskb_network_may_pull() in route_shortcircuit()
Date: Mon, 17 Aug 2026 15:31:58 +0200
Message-ID: <20260817132558.235549497@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2156,7 +2156,7 @@ static bool route_shortcircuit(struct ne
 	{
 		struct iphdr *pip;
 
-		if (!pskb_may_pull(skb, sizeof(struct iphdr)))
+		if (!pskb_network_may_pull(skb, sizeof(struct iphdr)))
 			return false;
 		pip = ip_hdr(skb);
 		n = neigh_lookup(&arp_tbl, &pip->daddr, dev);
@@ -2182,7 +2182,7 @@ static bool route_shortcircuit(struct ne
 		 */
 		if (!ipv6_stub->nd_tbl)
 			return false;
-		if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
+		if (!pskb_network_may_pull(skb, sizeof(struct ipv6hdr)))
 			return false;
 		pip6 = ipv6_hdr(skb);
 		n = neigh_lookup(ipv6_stub->nd_tbl, &pip6->daddr, dev);


