Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8AF3148BB;
	Wed, 20 May 2026 18:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302829; cv=none; b=ernSfcrQauM0I8ck3r+WpTF9KpJvx6T0j9+RpsB7pQ7Bp4oPHxitPs4UMCZq5h0MCpUgiv38CuL8tf5hbSSKBMQD8DplkonnVjOLUvldkoED4XoQ0aQk1w4BXvnqWCmOQcwP8MaIzkrU1EZXDX97sDmY/6rT1+jacmVfqoLM1j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302829; c=relaxed/simple;
	bh=puFfWMeAGSjHh7lw6L/A+80MDdvg2nN5QbshhE8dJwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CtKoBMZaAk4TBxpIucv84agJuuIitufzzzFQTPTjN7w+tXzfYHtUkjUdbWfHrzrIRXUG7yro6r9A1u0Lnc1J66NDlzaM5c8JyNTDseBDiKwjMzaqO37Dudvh1+vsQyywKBrejrH7nanoXe8vJy//uYwvn44Gg6u4zT1wibEc3OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JO/suX+/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JO/suX+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484E91F000E9;
	Wed, 20 May 2026 18:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302827;
	bh=+JXUdSGOHLxPBNXwaE5qNxVZ0FRsN7vQKQIjfSpL4uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JO/suX+/7ziNlr1GqmrhcRs8UBsrxBNNdXmt8vGcfAeu1+GHC8aTwQ4EAxUo1LPy7
	 b2SDVUQR4Grw9s2Ti2QEmSsBhiC+aQMcoju24dO7CueVOCljjgyWgoCxy/oI36PpjY
	 iJ5gO1VoJaXKsFrR/i3wcqZTba8Ri6UaC9wC4JLo=
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
Subject: [PATCH 6.6 415/508] bareudp: fix NULL pointer dereference in bareudp_fill_metadata_dst()
Date: Wed, 20 May 2026 18:23:58 +0200
Message-ID: <20260520162107.600424725@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



