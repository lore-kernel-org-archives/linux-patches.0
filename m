Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897F73C1FCC;
	Thu, 15 Jan 2026 17:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498195; cv=none; b=RpFKJ+Bj09a6PD/Ldxkz78e2zjm80PMf2pYqSfNyRD6j+qgHAVN1tjTxIC8bL6YIcYXGKPZ5+ro3xOM3P+V3/ejcDPxS5cgCkNMxUpTOwgaNcNPgEeJSZ/HCyxSsUTSbWp63Nwa+i1f845UGVQ2mPrMzP/hp+xr0qufG8ZggtTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498195; c=relaxed/simple;
	bh=+C6Oict6VGh7RElSrcnZiXzvTn53zGYz1NL/i1hXqHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SIkMPMx/a8kjm/r4lqoz05akFfVTWiQEGf8YkHLjJRsPrKb9y2s6bM8RwgfM+ZtPbSPpSTDd07xUBlVX8PB2p8dPAFNOtlEaeK3aA6zHTV0vtFxp1AZujBmagRfqIB2dLSOvnVtXjRRr60tezcFOOCqYHNJq5mIwGcykVuInDSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j+Fds1V9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j+Fds1V9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC293C116D0;
	Thu, 15 Jan 2026 17:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498195;
	bh=+C6Oict6VGh7RElSrcnZiXzvTn53zGYz1NL/i1hXqHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j+Fds1V9R1OSc1OCWFiFK1SUTV82hhizLqku0MqB3tqQCnm/47of4a+wYXIHBdEdm
	 G426VR0mxMMvcu1gMjiNbYlMvWhnPN88y9jPvZH0yMW0rXA0o0q89Vk5rz/AAxqw32
	 cpzpOyYTKeuXTL6SseurSJP95fH6qh8EPkxt1ldQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+43a2ebcf2a64b1102d64@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 345/554] ip6_gre: make ip6gre_header() robust
Date: Thu, 15 Jan 2026 17:46:51 +0100
Message-ID: <20260115164258.716815348@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit db5b4e39c4e63700c68a7e65fc4e1f1375273476 ]

Over the years, syzbot found many ways to crash the kernel
in ip6gre_header() [1].

This involves team or bonding drivers ability to dynamically
change their dev->needed_headroom and/or dev->hard_header_len

In this particular crash mld_newpack() allocated an skb
with a too small reserve/headroom, and by the time mld_sendpack()
was called, syzbot managed to attach an ip6gre device.

[1]
skbuff: skb_under_panic: text:ffffffff8a1d69a8 len:136 put:40 head:ffff888059bc7000 data:ffff888059bc6fe8 tail:0x70 end:0x6c0 dev:team0
------------[ cut here ]------------
 kernel BUG at net/core/skbuff.c:213 !
 <TASK>
  skb_under_panic net/core/skbuff.c:223 [inline]
  skb_push+0xc3/0xe0 net/core/skbuff.c:2641
  ip6gre_header+0xc8/0x790 net/ipv6/ip6_gre.c:1371
  dev_hard_header include/linux/netdevice.h:3436 [inline]
  neigh_connected_output+0x286/0x460 net/core/neighbour.c:1618
  neigh_output include/net/neighbour.h:556 [inline]
  ip6_finish_output2+0xfb3/0x1480 net/ipv6/ip6_output.c:136
 __ip6_finish_output net/ipv6/ip6_output.c:-1 [inline]
  ip6_finish_output+0x234/0x7d0 net/ipv6/ip6_output.c:220
  NF_HOOK_COND include/linux/netfilter.h:307 [inline]
  ip6_output+0x340/0x550 net/ipv6/ip6_output.c:247
  NF_HOOK+0x9e/0x380 include/linux/netfilter.h:318
  mld_sendpack+0x8d4/0xe60 net/ipv6/mcast.c:1855
  mld_send_cr net/ipv6/mcast.c:2154 [inline]
  mld_ifc_work+0x83e/0xd60 net/ipv6/mcast.c:2693

Fixes: c12b395a4664 ("gre: Support GRE over IPv6")
Reported-by: syzbot+43a2ebcf2a64b1102d64@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/693b002c.a70a0220.33cd7b.0033.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20251211173550.2032674-1-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_gre.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 501630e3f1b6..84ba9ad00135 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1383,9 +1383,16 @@ static int ip6gre_header(struct sk_buff *skb, struct net_device *dev,
 {
 	struct ip6_tnl *t = netdev_priv(dev);
 	struct ipv6hdr *ipv6h;
+	int needed;
 	__be16 *p;
 
-	ipv6h = skb_push(skb, t->hlen + sizeof(*ipv6h));
+	needed = t->hlen + sizeof(*ipv6h);
+	if (skb_headroom(skb) < needed &&
+	    pskb_expand_head(skb, HH_DATA_ALIGN(needed - skb_headroom(skb)),
+			     0, GFP_ATOMIC))
+		return -needed;
+
+	ipv6h = skb_push(skb, needed);
 	ip6_flow_hdr(ipv6h, 0, ip6_make_flowlabel(dev_net(dev), skb,
 						  t->fl.u.ip6.flowlabel,
 						  true, &t->fl.u.ip6));
-- 
2.51.0



