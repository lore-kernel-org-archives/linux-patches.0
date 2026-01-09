Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992D042AA6;
	Fri,  9 Jan 2026 12:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962558; cv=none; b=fcHEBA85NFnzftLFtB2kpOEJ3CD4CEZW83eBw5Mk4qKk1AIc9sBRRRlWX5oGBUCX+MgDjhOc1kJVeNR9D+rH0PXl4Zdk/5gIA2CLfeDw+6Zjt4b0NA7hvrN1gkWtwBLHDDFO/RA49mXCIdukFJ5DJr0TBbBBXRShlo4jloTUAdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962558; c=relaxed/simple;
	bh=Tq50qmVUqI1Y8xpbvv1Lr8583uaa4yMHzCzQVoO58jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KgvO7uv0D88oWB8d8rv3g19WR3brWTqN5VD26trdtc20Y7K2fSF73gI7sdqe7gX7d3tklXjNLJ8uEJ1M9jS7TiI9vuqvi69k5v5yLp2q5cAK3ozmALg2Upwa9r/XFnlVBy6+y4uyP6nvzyvmRi7jp5la1KiNuFxq24esC6SVaNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2IgDuSU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2IgDuSU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C53C4CEF1;
	Fri,  9 Jan 2026 12:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962558;
	bh=Tq50qmVUqI1Y8xpbvv1Lr8583uaa4yMHzCzQVoO58jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w2IgDuSUjO23ZDERsFOzDVAHT/ZvTHX7nN3zM4Kcuxffv07fo2gtp3tbR91NEcEd9
	 7M0QJUHWgc1ymqbfIpap58AoQMLVHb36D3mTXOrQVuDSoNawAVKmfSDTSrDE1i5GQs
	 3XDTkBb9Rp176ELW4DGE3DVB+qRH/SkX/s7q36iE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+43a2ebcf2a64b1102d64@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 407/634] ip6_gre: make ip6gre_header() robust
Date: Fri,  9 Jan 2026 12:41:25 +0100
Message-ID: <20260109112132.845608275@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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
index 718fcad69cf1..249c613a9280 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1405,9 +1405,16 @@ static int ip6gre_header(struct sk_buff *skb, struct net_device *dev,
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



