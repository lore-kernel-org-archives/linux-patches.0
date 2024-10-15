Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0001E6339;
	Tue, 15 Oct 2024 11:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993369; cv=none; b=Grz8EFkCAvOAF2kERjYYcVTnEdTkfDFYOJZjbJ7grR307Cq6kK6Evxt0ZYPntBM/Cw7A20AhytTVbF1fCvarzidoCuRd2tuNwnSpvox5l+JevJ2W7QTx/VFjBOO34m0s3hZ/690Ply0InPFj8xG763vXqHw9Dp+jXt0Zo3kYc8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993369; c=relaxed/simple;
	bh=QN1QGrouJspekZLInGJyzLds7smhH2t/CSpypjJ+hyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVxz2YR1EInJU78/SNOrC+IJNoZx4QAq4dbp/pXLqNMHccvy6DwU8A8h0ADs/ws6Cinis68Vk3LMB9eVhY3gfzLbMH2ykAvFSfswsrnK1WtB0QPf8p6VT6xBXW2QvHgQ8L3W4dbpfP3YWSrGDR7aVt4q4GNXTQZdrPEEU1mEy+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FcNEAX/o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FcNEAX/o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93133C4CEC6;
	Tue, 15 Oct 2024 11:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993369;
	bh=QN1QGrouJspekZLInGJyzLds7smhH2t/CSpypjJ+hyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FcNEAX/oEfvW5+xk620iRb7HeHnHDVS3eWnNZKMYsfK7XvF3VMc61pRF+HdlHcV1s
	 qJpKq6CyEqzNmGNsHG/FHeAJGlB36ydhU25j11uq5vh8V2GYQLDHiTf1uWN5+KGvWt
	 Ebk56uzpcSvNVxtHE3c3/xtotcIx9dV7sExsw8LI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Danilov <littlesmilingcloud@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 391/691] ipv4: ip_gre: Fix drops of small packets in ipgre_xmit
Date: Tue, 15 Oct 2024 13:25:39 +0200
Message-ID: <20241015112455.858997851@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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
index cd967493bf371..b4bce749645bb 100644
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



