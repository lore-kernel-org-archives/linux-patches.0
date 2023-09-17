Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33786FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2D8C433C7;
	Sun, 17 Sep 2023 20:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981712;
	bh=oolUaj3iv16VWgqBG5yBCJZF3xDJy2+xr0nL1XfTrVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RpR9rtnm/78ot8AazG0CKntsAFY4h2vFYknV7ZCR0D2adbgib0FD2S+WIL1pn5OAY
	 AB+PuQpqwOFVspUEL/UQwuujcQAThiLsMY8kLeZxYtYtxBr3lw+4XlgZkT0r99E449
	 RfudlK3HdUgKk6AAAUvqCUIeY4vZo67SuEa1PUSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 087/511] ipv6: Add reasons for skb drops to __udp6_lib_rcv
Date: Sun, 17 Sep 2023 21:08:34 +0200
Message-ID: <20230917191115.973104486@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Ahern <dsahern@kernel.org>

[ Upstream commit 4cf91f825b2777f81799f98ce32172b829acd1b2 ]

Add reasons to __udp6_lib_rcv for skb drops. The only twist is that the
NO_SOCKET takes precedence over the CSUM or other counters for that
path (motivation behind this patch - csum counter was misleading).

Signed-off-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 9c02bec95954 ("bpf, net: Support SO_REUSEPORT sockets with bpf_sk_assign")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/udp.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 2dab9aab551c3..d5d254ca2dfe6 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -936,6 +936,7 @@ static int udp6_unicast_rcv_skb(struct sock *sk, struct sk_buff *skb,
 int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 		   int proto)
 {
+	enum skb_drop_reason reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	const struct in6_addr *saddr, *daddr;
 	struct net *net = dev_net(skb->dev);
 	struct udphdr *uh;
@@ -1012,6 +1013,8 @@ int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 		return udp6_unicast_rcv_skb(sk, skb, uh);
 	}
 
+	reason = SKB_DROP_REASON_NO_SOCKET;
+
 	if (!uh->check)
 		goto report_csum_error;
 
@@ -1024,10 +1027,12 @@ int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	__UDP6_INC_STATS(net, UDP_MIB_NOPORTS, proto == IPPROTO_UDPLITE);
 	icmpv6_send(skb, ICMPV6_DEST_UNREACH, ICMPV6_PORT_UNREACH, 0);
 
-	kfree_skb(skb);
+	kfree_skb_reason(skb, reason);
 	return 0;
 
 short_packet:
+	if (reason == SKB_DROP_REASON_NOT_SPECIFIED)
+		reason = SKB_DROP_REASON_PKT_TOO_SMALL;
 	net_dbg_ratelimited("UDP%sv6: short packet: From [%pI6c]:%u %d/%d to [%pI6c]:%u\n",
 			    proto == IPPROTO_UDPLITE ? "-Lite" : "",
 			    saddr, ntohs(uh->source),
@@ -1038,10 +1043,12 @@ int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 report_csum_error:
 	udp6_csum_zero_error(skb);
 csum_error:
+	if (reason == SKB_DROP_REASON_NOT_SPECIFIED)
+		reason = SKB_DROP_REASON_UDP_CSUM;
 	__UDP6_INC_STATS(net, UDP_MIB_CSUMERRORS, proto == IPPROTO_UDPLITE);
 discard:
 	__UDP6_INC_STATS(net, UDP_MIB_INERRORS, proto == IPPROTO_UDPLITE);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, reason);
 	return 0;
 }
 
-- 
2.40.1



