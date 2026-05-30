Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7BE33B6C4;
	Sat, 30 May 2026 17:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162023; cv=none; b=q3hu44dCdtYpjLHF4S9l5I30tCw0pOTUbAlo2dzC6mfUVwqU9LaX4ylUldNAdaf0ujLoQx3tIJ18PaF0TiVLqeb83ZRxKhUYEi7jP/DpCLdYK0m0+haA0q7l4VLzEQlD4Z1czH0PK9wEnGm2TaXcWBUZSXevoVSLRAH/OgReCn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162023; c=relaxed/simple;
	bh=M1nI+4tpjv0uJ9tLbHx2T4ZKbCHEgmiuRaq0oB2Z2dQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zwq5mfATg49DyMXh2v5/5AoiXVUSYKluFgukj2xT8ai7+oSBuTguEILWrBT61660DuQE51+uNhOEwDBgpx7RRFjWS58oWsItis4/P8KauE9QP5WiLswFwIrAExDJuGYJHmT/EYnShP5FwFhm/xq+lnzLADT/XakrHfHWd64d0jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mF2ziVPz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mF2ziVPz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CC11F00893;
	Sat, 30 May 2026 17:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162022;
	bh=2tlWUXBcUavi4b+A4p0spU0fuH7QsooWuluDAJ/MdBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mF2ziVPzAIcErn4zYG/0qlxP4C8EBfKSU9qT+dPMTVTjHd8kFPHzT8cXIPPDVqEJ4
	 TwVR8qST6HBspVvubWU+rYMKLLWgcXFiaj6zAVBDiBRpRYi2RP8CD3oHNvGObP6jAj
	 OsMO3e21eYAohc2KPdZojtPjPDTAEAmsm5qjX7rk=
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
Subject: [PATCH 6.1 768/969] bareudp: fix NULL pointer dereference in bareudp_fill_metadata_dst()
Date: Sat, 30 May 2026 18:04:52 +0200
Message-ID: <20260530160321.786104382@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
index 150049d9a81a7..b181c03368153 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -520,6 +520,9 @@ static int bareudp_fill_metadata_dst(struct net_device *dev,
 		struct in6_addr saddr;
 		struct socket *sock = rcu_dereference(bareudp->sock);
 
+		if (!sock)
+			return -ESHUTDOWN;
+
 		dst = udp_tunnel6_dst_lookup(skb, dev, bareudp->net, sock,
 					     &saddr, info, IPPROTO_UDP,
 					     use_cache);
-- 
2.53.0



