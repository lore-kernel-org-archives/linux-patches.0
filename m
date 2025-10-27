Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B794932AAD9;
	Mon, 27 Oct 2025 18:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591556; cv=none; b=iwXgwv5MVfUENQyRgSye7/H3yg3RE2zhmBW2cAMoWXEbtzqr+aTco8YvPhe1UpXgVAkaJ7e3kIznAMOPgNmFArSGmJhDkVGTNB5RFozTvTGUwtk39vKTzAl0qjnKdrpRNZexcxDDOkb4XkjWKw9tGxu91MmIe2vakNsyks2+3XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591556; c=relaxed/simple;
	bh=2iX1smDxb1JeRav9S2Z72JZ9FaOF8qLeakWD2v4vVBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mesgq+FnpejpBRoIt9M+8uEzqRJe+BZDuETS/8kOD+iu/wElqZ43PB4kJQiLR1feDsMTa/8HIihbuohQ/SDKOQ9qbhpfuoxFV9TQAycj8FevoGLbjcv6CQWuuiVaJBiDZ/as0bg+KSh3osZ6k3RkaJaQr4JdQEcb8jlrelCtNqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y+eBu2oc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y+eBu2oc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4138EC4CEF1;
	Mon, 27 Oct 2025 18:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591556;
	bh=2iX1smDxb1JeRav9S2Z72JZ9FaOF8qLeakWD2v4vVBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y+eBu2ocAoouMnrpg2uDEzFEsS2NyaszZyiiNmB3ezBB1hQhTN+GYBbB0Om86M3Pt
	 pxrLJBW5d2gmqvDzc9pvlsltO5lpJNgQxFwJSvWYvNKSrISbye+DTiG4Uet/hHLd7/
	 qWLpnhU8aD13kMeG3TtP+saWMi8jfB2L17l7SJug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Francesco Ruggeri <fruggeri05@gmail.com>,
	Dmitry Safonov <dima@arista.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 243/332] net/ip6_tunnel: Prevent perpetual tunnel growth
Date: Mon, 27 Oct 2025 19:34:56 +0100
Message-ID: <20251027183531.249897624@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index cedf72924f19e..d7a037d32bcc2 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -468,6 +468,21 @@ struct metadata_dst *iptunnel_metadata_reply(struct metadata_dst *md,
 int skb_tunnel_check_pmtu(struct sk_buff *skb, struct dst_entry *encap_dst,
 			  int headroom, bool reply);
 
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
index cf9184928eded..6a85200002969 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -553,20 +553,6 @@ static int tnl_update_pmtu(struct net_device *dev, struct sk_buff *skb,
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
index bd27204725ed8..6efad8d6653b6 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1277,8 +1277,7 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
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



