Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B031F9412;
	Wed,  6 Nov 2024 13:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898310; cv=none; b=qeasUy3N0H4liDfq7/Pcm0l40Tm3qEJZbY4Ef+O6YiHYyfClOQtWmjTKDPSPmjZDDsrE7hJebR0JCy9PWrFYwHX8yYfeFi6vJUt8+HJxjoLd4H3v5Ts+mVwpGTDsr/hJzKHqJKnId6y+hzavQ7kMkTt5k195gNMxN9rpWFDLy6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898310; c=relaxed/simple;
	bh=HC7wsrGdwXKZjuuppx6E/hQROvSyDie3LURBkNhBt8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NbvlaVTU7011jjJK+ruNwVo+7Pwof53dFLSW/Ie7AL8z4kbg2nPppr1Q+vG3HKwHAhsm6Ll9DKs6C5XNfmQmQrDjqdbr3Mf+tbk2uR8YDGY3NthRY8fJA60FfErtO/3LVh3WqC+4kL1NcHp3lvjXQQq/OGBN3+WzAgxK6lhHcMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JjyNQ+B6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JjyNQ+B6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5274C4CECD;
	Wed,  6 Nov 2024 13:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898310;
	bh=HC7wsrGdwXKZjuuppx6E/hQROvSyDie3LURBkNhBt8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JjyNQ+B6z3tMhomnxS75cQaaxc/Ig0YfXykqU1TcVmrRpp3TF332//0V8g9lHVlqo
	 W9ajC05GJmspcviRd5V5OVP4stvR50F1JWF8wBI/T13+3hdy5gSmC1E61zFpGFvZsx
	 pghvJPK++0YLdfhqD9j1G9iRMog1DREGrsnpDOLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Danilov <littlesmilingcloud@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 188/462] ipv4: ip_gre: Fix drops of small packets in ipgre_xmit
Date: Wed,  6 Nov 2024 13:01:21 +0100
Message-ID: <20241106120336.158124649@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Danilov <littlesmilingcloud@gmail.com>

[ Upstream commit c4a14f6d9d17ad1e41a36182dd3b8a5fd91efbd7 ]

Regression Description:

Depending on the options specified for the GRE tunnel device, small
packets may be dropped. This occurs because the pskb_network_may_pull
function fails due to the packet's insufficient length.

For example, if only the okey option is specified for the tunnel device,
original (before encapsulation) packets smaller than 28 bytes (including
the IPv4 header) will be dropped. This happens because the required
length is calculated relative to the network header, not the skb->head.

Here is how the required length is computed and checked:

* The pull_len variable is set to 28 bytes, consisting of:
  * IPv4 header: 20 bytes
  * GRE header with Key field: 8 bytes

* The pskb_network_may_pull function adds the network offset, shifting
the checkable space further to the beginning of the network header and
extending it to the beginning of the packet. As a result, the end of
the checkable space occurs beyond the actual end of the packet.

Instead of ensuring that 28 bytes are present in skb->head, the function
is requesting these 28 bytes starting from the network header. For small
packets, this requested length exceeds the actual packet size, causing
the check to fail and the packets to be dropped.

This issue affects both locally originated and forwarded packets in
DMVPN-like setups.

How to reproduce (for local originated packets):

  ip link add dev gre1 type gre ikey 1.9.8.4 okey 1.9.8.4 \
          local <your-ip> remote 0.0.0.0

  ip link set mtu 1400 dev gre1
  ip link set up dev gre1
  ip address add 192.168.13.1/24 dev gre1
  ip neighbor add 192.168.13.2 lladdr <remote-ip> dev gre1
  ping -s 1374 -c 10 192.168.13.2
  tcpdump -vni gre1
  tcpdump -vni <your-ext-iface> 'ip proto 47'
  ip -s -s -d link show dev gre1

Solution:

Use the pskb_may_pull function instead the pskb_network_may_pull.

Fixes: 80d875cfc9d3 ("ipv4: ip_gre: Avoid skb_pull() failure in ipgre_xmit()")
Signed-off-by: Anton Danilov <littlesmilingcloud@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20240924235158.106062-1-littlesmilingcloud@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_gre.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 3aae46b845775..09e9e46259f70 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -635,11 +635,11 @@ static netdev_tx_t ipgre_xmit(struct sk_buff *skb,
 		if (skb_cow_head(skb, 0))
 			goto free_skb;
 
-		tnl_params = (const struct iphdr *)skb->data;
-
-		if (!pskb_network_may_pull(skb, pull_len))
+		if (!pskb_may_pull(skb, pull_len))
 			goto free_skb;
 
+		tnl_params = (const struct iphdr *)skb->data;
+
 		/* ip_tunnel_xmit() needs skb->data pointing to gre header. */
 		skb_pull(skb, pull_len);
 		skb_reset_mac_header(skb);
-- 
2.43.0



