Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B283C39B483;
	Wed, 20 May 2026 17:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299564; cv=none; b=SO4h1EwatlBfozAK7VGf5PdEdjE/Q4LUwJ4ntUl3FYi7FW7KjhvoMJsP/1GQex40kHfRbBnwBif9UsTzKIN+/HRTSD+l/3EXJV0xSXDL8pjJAj7kKuH8w2RZmaSgk6HE+lf9Q++x7PDRhxHVpqPdGuLbi4nuzfEmrXzTQS9I6wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299564; c=relaxed/simple;
	bh=BMRgcE4nKSReXGy/pQlvx6pTHbNnc8eDCWFl1ICCBFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sny6G72vIWEnaYpcKp5Tj1yoGth9YT5AsBzNGNAclybiKdDC3s+y5SQ9ypl5DrUg8AS3m7QSljtcUoIgJXfTwV1eHo0J+E3ppU/+LIBRCdWo8/LXGoY9CSBCOKjJP7OgAtulgt1yJmX/d0IktIcgiAZ8lLnawq3V+F8YN+6h6ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJDZnS4T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJDZnS4T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D971F000E9;
	Wed, 20 May 2026 17:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299563;
	bh=ZnD9xXasB2OrUpk6px7N9/1Wz8qDpPa9/15VP00aEzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gJDZnS4TNEOGnaYqJLamjrtPfqtdgeN0QnfGnPd5l4+/fITmDBtmrCZDZxS7kfMOJ
	 FyHb0kNbxvAxwO+FgXxt7TWJ3yhKccA6UOsU7Lu+xLrEJbexyolp5mkpnx00ZtBN/w
	 Oqydr1O5nSmGP39UkDpqvsXzoL43ZbNLtBJUbDy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 820/957] bareudp: fix NULL pointer dereference in bareudp_fill_metadata_dst()
Date: Wed, 20 May 2026 18:21:43 +0200
Message-ID: <20260520162152.350719501@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit aa6c6d9ee064aabfede4402fd1283424e649ca19 ]

bareudp_fill_metadata_dst() passes bareudp->sock to
udp_tunnel6_dst_lookup() in the IPv6 path without a NULL check.
The socket is only created in bareudp_open() and NULLed in
bareudp_stop(), so calling this function while the device is down
triggers a NULL dereference via sock->sk.

 BUG: kernel NULL pointer dereference, address: 0000000000000018
 RIP: 0010:udp_tunnel6_dst_lookup (net/ipv6/ip6_udp_tunnel.c:160)
 Call Trace:
  <TASK>
  bareudp_fill_metadata_dst (drivers/net/bareudp.c:532)
  do_execute_actions (net/openvswitch/actions.c:901)
  ovs_execute_actions (net/openvswitch/actions.c:1589)
  ovs_packet_cmd_execute (net/openvswitch/datapath.c:700)
  genl_family_rcv_msg_doit (net/netlink/genetlink.c:1114)
  genl_rcv_msg (net/netlink/genetlink.c:1209)
  netlink_rcv_skb (net/netlink/af_netlink.c:2550)
  </TASK>

Add a NULL check returning -ESHUTDOWN, consistent with the xmit paths
in the same driver.

Fixes: 571912c69f0e ("net: UDP tunnel encapsulation module for tunnelling different protocols like MPLS, IP, NSH etc.")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260426165350.1663137-2-bestswngs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bareudp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 0df3208783ad9..da5866ba06999 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -529,6 +529,9 @@ static int bareudp_fill_metadata_dst(struct net_device *dev,
 		struct in6_addr saddr;
 		struct socket *sock = rcu_dereference(bareudp->sock);
 
+		if (!sock)
+			return -ESHUTDOWN;
+
 		dst = udp_tunnel6_dst_lookup(skb, dev, bareudp->net, sock,
 					     0, &saddr, &info->key,
 					     sport, bareudp->port, info->key.tos,
-- 
2.53.0



