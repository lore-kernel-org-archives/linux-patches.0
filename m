Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809103F1ACA;
	Wed, 20 May 2026 17:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296939; cv=none; b=smxysj+gJgP67CFs7UPLX8H+R6ZZhThbU0nT0K3wgQH6K7BPgpzc/GLItCZ7Ehv+QtxWBqRD5rBWmmZ2IPA7iI9mbmxwp+v7F5XMMLu75p1PzwuLQDXW45oEtsH0qBvoS7nx/wdz9naf/inRExqd+dZnEunGrSQ3sh8g0+r/5Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296939; c=relaxed/simple;
	bh=hL0j+/6jbw6hgMUSlBpSGBAm5Ofo06RrYrsUgd5wQpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4To4Y/e9wRjr3NHberP7mDtnZoM77l8lM04H+fhL8T8TDHiCFsr88Nz62nw1BZlmvdk9t5xt7u2aoqdbGvt30T4Ot5807Bx5ZxUtvw2oSBqdWWVxS/VOpoS0Yjny5mPY2KyHwfRrkWPBfi2XElD50BMtIO8Z7NeJbifxLNJckI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P2Z+N9UR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P2Z+N9UR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31001F000E9;
	Wed, 20 May 2026 17:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296938;
	bh=N1QlBnZEC2hcuH5AUVNlFk6cDDozJ0nN4v63SeBTKDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P2Z+N9URiRs/Zno0s/dzgIg2IdNml6NVFVIqx+R7E5w6AhCRyjvKL2y1DYkgBKh0e
	 AI1Ar4HzJcHb4GCBCA6px8RcdG4YJP8whv52Wmml0/RtvX8tf16XnXVVovG2iAX/M8
	 KMrgW8YNaU+f1JSIM+RJ4dGC7yhuPAsW8ro+e6SM=
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
Subject: [PATCH 7.0 0988/1146] bareudp: fix NULL pointer dereference in bareudp_fill_metadata_dst()
Date: Wed, 20 May 2026 18:20:38 +0200
Message-ID: <20260520162210.592297246@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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



