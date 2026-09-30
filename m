Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6758320A37;
	Wed, 30 Sep 2026 19:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796965; cv=none; b=Zm+fsDci1hIXsVt5Yj8vKogppjK9kDqbYlNX6Fi5qJmVWnVV1K7ggBu1JZNGVVgbUacm3h43JCNaqm61OQnjvGDkq+Ccc5hoZSR3jJfMTQCODbt6RNWkBSgGWqJ/d3ZfRs5tKfGmRqur1l4VriHha31J4ZHIyCX4ZjdoHtXhcTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796965; c=relaxed/simple;
	bh=eqkj+L91Ng16+zZ28B33gB8FnEmZXFJyofbInkRXZfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WogpupGFgQpGoByw+jtYdEILcsfW+4bwiSQYf7ZUz6Pxhqf3YC9GjyW6VSUhqdVynE2I2fqjy3zT0aAXhQOO6ODV9ky4XRo6IHHDyDTdTrmjwBmkIKce+3W5rPphM5CApc7TiF1XnA8Lqco9w8hP3CBLwVid+UEcGY/TYg54MeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VE5xJzlc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VE5xJzlc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD691F000FF;
	Wed, 30 Sep 2026 19:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796963;
	bh=LjZbd/yD9HQWb5HliNUhD5A88gu78Tx98UtxarEChIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VE5xJzlcYNpRyRjdZcvVXstJLESTkxbIaLHNLclCifqFCRgrT7HQjln8Yndgh2Gij
	 Kpp2z0nUXuT6K5C7YrFOLZiKxmz8/LK9pdD8UVBoZS6y2AFu7Oy3RaVf3+bPt3s5MJ
	 zW0n2UL73z8mC4JlYavae6MPDNpy5uonPN+/KrS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Sasso <stesasso@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1054/1193] vrf: Stop corrupting skb->csum when capturing CHECKSUM_COMPLETE packets
Date: Wed, 30 Sep 2026 17:28:58 +0200
Message-ID: <20260930152457.642881906@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit ab7aa05c06ae340e5c7530bb78fa8d23794e460b ]

The VRF device is an Ethernet device but it can have non-Ethernet ports
such as IP tunnels. Before the cited commit, capturing packets from such
ports on the VRF device resulted in these packets being detected as
malformed since they lack an Ethernet header.

The cited commit fixed it by pushing a dummy Ethernet header to such
packets before the capture and pulling it afterwards. In the case of
CHECKSUM_COMPLETE packets it also updated skb->csum with the checksum of
the dummy Ethernet header. This is wrong as skb->csum should not include
the checksum of the Ethernet header ("checksum of the _whole_ packet as
seen by netif_rx()").

This also means that L4 protocols receive a corrupted skb->csum and
potentially drop the packet, as is the case with UDP packets whose
checksum was completed by software.

Fix by removing the unnecessary call to skb_postpush_rcsum().

Fixes: 048939088220 ("vrf: add mac header for tunneled packets when sniffer is attached")
Reported-by: Stefano Sasso <stesasso@gmail.com>
Closes: https://lore.kernel.org/netdev/CALtE316UtL3x7LL6uxfXzx8rW6AbzYPeDOb478hqJCr_-dj=Wg@mail.gmail.com/
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Link: https://patch.msgid.link/20260922131239.2509494-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vrf.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 8f435f58a8886..845b6ec660958 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1253,8 +1253,6 @@ static int vrf_prepare_mac_header(struct sk_buff *skb,
 	skb->protocol = eth->h_proto;
 	skb->pkt_type = PACKET_HOST;
 
-	skb_postpush_rcsum(skb, skb->data, ETH_HLEN);
-
 	skb_pull_inline(skb, ETH_HLEN);
 
 	return 0;
-- 
2.53.0



