Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6999B18C332;
	Wed, 30 Sep 2026 16:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787312; cv=none; b=DydytjClXwA5qRLF+MQ9MQqeewj8IO4yH0t5P6uDOTsbUNwFUzO/y+duN3cewkXLAFwfo9wKkD6AvOucKRb8xlI3re9FG6D3Z/2reL4QTzSritFvDH2/veFTBDVZNYLPGmlkjdVU+kvH8GAt+GsDFpv7hSmY2rwj+3kggz96hAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787312; c=relaxed/simple;
	bh=FSg/yK/Jdxn0ntt1NLE7a0dRmijD+VzSaynxnx+k9BQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VqAykVRSKsoXQrlYbbw3Li9Iwu4rGNEJvrgdO/tEjcZ7MYcpVWqPS2PAq5eiWd61il1U8aRM6FAcAXkjR0aIwSRwOQEd5ythCL1dBGX7OAkEPEOS3aVJ90Me8SRtSRtN1b9+kfVokFmaa8EQR4jdbczaVs2nzQbIeWsqtbjp6Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pOpiba71; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pOpiba71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06F11F000FF;
	Wed, 30 Sep 2026 16:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787311;
	bh=zQO0NkoiHESkhElaFqDidzYOSil16EUnTILd+3X9Cds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pOpiba71ArwolElqACBR2Dg30ghsm4zCo0K63COl9icx5M2u4xkcnqHA1LwNYx032
	 cPCnq6RdUq9DaXYVKJklAPWjeRO3Ezs6yMpazqI4ePf0Vysir784+rsRKUPCS5y0aH
	 CoJfIfms3UMbF12fbxTlqw5IirydNgvWDmqNDwNU=
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
Subject: [PATCH 7.2 185/457] vrf: Stop corrupting skb->csum when capturing CHECKSUM_COMPLETE packets
Date: Wed, 30 Sep 2026 17:24:50 +0200
Message-ID: <20260930152350.044080976@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 46209917ae4d6..bae0b69cf894c 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1175,8 +1175,6 @@ static int vrf_prepare_mac_header(struct sk_buff *skb,
 	skb->protocol = eth->h_proto;
 	skb->pkt_type = PACKET_HOST;
 
-	skb_postpush_rcsum(skb, skb->data, ETH_HLEN);
-
 	skb_pull_inline(skb, ETH_HLEN);
 
 	return 0;
-- 
2.53.0



