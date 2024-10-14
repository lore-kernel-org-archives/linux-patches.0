Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01D11AB538;
	Mon, 14 Oct 2024 15:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918818; cv=none; b=CQbfmUvzvtRXa7EkDZMVA4iJL87gIOYrK6K3W8OXGVljxxBOQ/dT4d9yImHQbpU8HxEPXcSIaIUe1D2Nrz3fXtQp83vd/tZJNLSsUujj5a/7Ya8n66+Ri2OPXoL/VE1ngzHRylQJWpryzdy9Bctxe11kAbNQ3R9WWBzqUMJdz3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918818; c=relaxed/simple;
	bh=d8SFnRpJWvJGRTyOa7QgM4NAmXqNM+jq0rJ+IIj6KOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E+6/zJ9nwokswxP0dJH+TzU22dEE1tpgLE/LB6rRjBGzJ55PDeYigE1ICzmOwFU4y9be5XEmMzpAmuqvIe1sI6fQpv7r983tKSQ2B2xUBvZ53EgeAqRe5I17b9rNZeSvS2JVGO8z1w7utXZB+N4WvNv1wLqJtOnSnT8ec/Y0Ag8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PYd+2kOZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PYd+2kOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17302C4CEC3;
	Mon, 14 Oct 2024 15:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918817;
	bh=d8SFnRpJWvJGRTyOa7QgM4NAmXqNM+jq0rJ+IIj6KOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PYd+2kOZALDq7cV6njuLkPqgylSJw2+nfqhmaqjH6IqPSlUHs17Bp/9+7TGMH10bm
	 x4VzjcgRzJoioGART3bhX1IlkpBJhCOZj1PvWa4rCS+DhPI0aIeztk1QHRvmB/cxfR
	 pksJmPwizP9qeAAexAA3/Hq955iHoqy7tgyCYEVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Danilov <littlesmilingcloud@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 400/798] ipv4: ip_gre: Fix drops of small packets in ipgre_xmit
Date: Mon, 14 Oct 2024 16:15:54 +0200
Message-ID: <20241014141233.660503426@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0267fa05374aa..2c311ed84a3b3 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -644,11 +644,11 @@ static netdev_tx_t ipgre_xmit(struct sk_buff *skb,
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



