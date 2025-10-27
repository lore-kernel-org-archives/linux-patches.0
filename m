Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E5831E0F0;
	Mon, 27 Oct 2025 18:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590749; cv=none; b=qHr+CUziYvtU7EzYeC10MK8EVlCRQkA4AtzzIYSatouzYz0CajrSRpMAUj5Rbgbstu66hHVGuFQ2/2dV4mMYTzIacUH89jiJEa+eHauk8leCQSV4vUbRlOOVgxIbvRGVAVNZQIhnMPDO1UaO80a7WD1JhsRvi75yhVjQUjj31UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590749; c=relaxed/simple;
	bh=TYQXI7TMEdc7n9uDN7G/JW1xI+gaJhvgLM1TERcvUhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7GVdQaltJ0vhGRFnXAJCyiqJQELaNgNjVU1JNVlNqzHj0yVddeo1od3AIcAUetQBGTX6BD/vxXLjMALh6zqfIjPAl+L0N5xEjoIryXdGXHu1z1YFmlOwBO88kMkcOEnAHIbwCHCSBrPZA9nXWo2S2a+FAFU+Ds8f9x2xmHCHDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X3YB6hGc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X3YB6hGc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA8CC4CEF1;
	Mon, 27 Oct 2025 18:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590749;
	bh=TYQXI7TMEdc7n9uDN7G/JW1xI+gaJhvgLM1TERcvUhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X3YB6hGciitO4AnhixmDNTYinsLYlMevUpGcrhyERA76UV3PQtJndZ0BbXxeqKHub
	 Lq83HqrHfeHCoaBPlvjm0TEXwqU/Msa+apR7h9oDiBPnP46g1aO7kLMgKGkocG8lXy
	 RzZMKCQhtQMCS7/cE7KegPm2lfMi4W6tPoPMwM1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Francesco Ruggeri <fruggeri05@gmail.com>,
	Dmitry Safonov <dima@arista.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 160/224] net/ip6_tunnel: Prevent perpetual tunnel growth
Date: Mon, 27 Oct 2025 19:35:06 +0100
Message-ID: <20251027183513.217764405@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Safonov <dima@arista.com>

[ Upstream commit 21f4d45eba0b2dcae5dbc9e5e0ad08735c993f16 ]

Similarly to ipv4 tunnel, ipv6 version updates dev->needed_headroom, too.
While ipv4 tunnel headroom adjustment growth was limited in
commit 5ae1e9922bbd ("net: ip_tunnel: prevent perpetual headroom growth"),
ipv6 tunnel yet increases the headroom without any ceiling.

Reflect ipv4 tunnel headroom adjustment limit on ipv6 version.

Credits to Francesco Ruggeri, who was originally debugging this issue
and wrote local Arista-specific patch and a reproducer.

Fixes: 8eb30be0352d ("ipv6: Create ip6_tnl_xmit")
Cc: Florian Westphal <fw@strlen.de>
Cc: Francesco Ruggeri <fruggeri05@gmail.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
Link: https://patch.msgid.link/20251009-ip6_tunnel-headroom-v2-1-8e4dbd8f7e35@arista.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip_tunnels.h | 15 +++++++++++++++
 net/ipv4/ip_tunnel.c     | 14 --------------
 net/ipv6/ip6_tunnel.c    |  3 +--
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index 3a04e2ccfb393..d2945ec5aba21 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -454,6 +454,21 @@ void iptunnel_xmit(struct sock *sk, struct rtable *rt, struct sk_buff *skb,
 struct metadata_dst *iptunnel_metadata_reply(struct metadata_dst *md,
 					     gfp_t flags);
 
+static inline void ip_tunnel_adj_headroom(struct net_device *dev,
+					  unsigned int headroom)
+{
+	/* we must cap headroom to some upperlimit, else pskb_expand_head
+	 * will overflow header offsets in skb_headers_offset_update().
+	 */
+	const unsigned int max_allowed = 512;
+
+	if (headroom > max_allowed)
+		headroom = max_allowed;
+
+	if (headroom > READ_ONCE(dev->needed_headroom))
+		WRITE_ONCE(dev->needed_headroom, headroom);
+}
+
 int iptunnel_handle_offloads(struct sk_buff *skb, int gso_type_mask);
 
 static inline int iptunnel_pull_offloads(struct sk_buff *skb)
diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 906c37c7f80d5..38cace81bfa2d 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -560,20 +560,6 @@ static int tnl_update_pmtu(struct net_device *dev, struct sk_buff *skb,
 	return 0;
 }
 
-static void ip_tunnel_adj_headroom(struct net_device *dev, unsigned int headroom)
-{
-	/* we must cap headroom to some upperlimit, else pskb_expand_head
-	 * will overflow header offsets in skb_headers_offset_update().
-	 */
-	static const unsigned int max_allowed = 512;
-
-	if (headroom > max_allowed)
-		headroom = max_allowed;
-
-	if (headroom > READ_ONCE(dev->needed_headroom))
-		WRITE_ONCE(dev->needed_headroom, headroom);
-}
-
 void ip_md_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 		       u8 proto, int tunnel_hlen)
 {
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 5319093d9aa62..c79e6c032b300 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1201,8 +1201,7 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 	 */
 	max_headroom = LL_RESERVED_SPACE(dst->dev) + sizeof(struct ipv6hdr)
 			+ dst->header_len + t->hlen;
-	if (max_headroom > READ_ONCE(dev->needed_headroom))
-		WRITE_ONCE(dev->needed_headroom, max_headroom);
+	ip_tunnel_adj_headroom(dev, max_headroom);
 
 	err = ip6_tnl_encap(skb, t, &proto, fl6);
 	if (err)
-- 
2.51.0



