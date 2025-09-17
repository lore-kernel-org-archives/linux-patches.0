Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA4130CB29;
	Wed, 17 Sep 2025 12:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113482; cv=none; b=Nq/I+PbqebHl5Ro/hmDQAB6zV1APJHq0WZBqWVSLYbq097qC0MQoVZhyyYucpTLbOeGJyw5ckPkvr1geoHtJmnRd4otiGRFWqzyymt74h6M4oeN00On2qxLjFe12cGeAgjoZ173SHV0sDg6R+sx6Q1QT0V5MHlr21bGEKH8/shQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113482; c=relaxed/simple;
	bh=Ioc+Ji2mp5ANTtEyuOxr26hHQwIrpEIY6m2mkd3swEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lz5AklbL/vROTrMYcDPnOAAI7eWHuyBTFfX4UzpZ3v/OpxzxCCEDEqZ9gXvijFgAwUNfvq+MdFnvyphINu8Akr/Ko7ifgoJJx1pMUatK2gekv4jgEJjz9btzbuVVcZVr8JYUxq5TD3PqsDRJrFvS1pqYfy/UX1oRGMnsf1VyjNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dBgRYq5s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dBgRYq5s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF953C4CEF0;
	Wed, 17 Sep 2025 12:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113481;
	bh=Ioc+Ji2mp5ANTtEyuOxr26hHQwIrpEIY6m2mkd3swEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dBgRYq5s7m9TILowb/n1SnnyKMa/C9mLrt2Yk1bTT3CYR9IlpdysxyNNW8KSWKGbu
	 v278adjZYSAhCSeVq+xDSTHTOqLQJCFIBPdzXMWKET7ZYW4rIM2PJUGvK0PHnVX5fW
	 Pt6jSUrd6TXWqPSmjKN7g4TbqbSHNUujkx/QLmko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Moreno <amorenoz@redhat.com>,
	Antoine Tenart <atenart@kernel.org>,
	Stefano Brivio <sbrivio@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 099/140] tunnels: reset the GSO metadata before reusing the skb
Date: Wed, 17 Sep 2025 14:34:31 +0200
Message-ID: <20250917123346.721879130@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit e3c674db356c4303804b2415e7c2b11776cdd8c3 ]

If a GSO skb is sent through a Geneve tunnel and if Geneve options are
added, the split GSO skb might not fit in the MTU anymore and an ICMP
frag needed packet can be generated. In such case the ICMP packet might
go through the segmentation logic (and dropped) later if it reaches a
path were the GSO status is checked and segmentation is required.

This is especially true when an OvS bridge is used with a Geneve tunnel
attached to it. The following set of actions could lead to the ICMP
packet being wrongfully segmented:

1. An skb is constructed by the TCP layer (e.g. gso_type SKB_GSO_TCPV4,
   segs >= 2).

2. The skb hits the OvS bridge where Geneve options are added by an OvS
   action before being sent through the tunnel.

3. When the skb is xmited in the tunnel, the split skb does not fit
   anymore in the MTU and iptunnel_pmtud_build_icmp is called to
   generate an ICMP fragmentation needed packet. This is done by reusing
   the original (GSO!) skb. The GSO metadata is not cleared.

4. The ICMP packet being sent back hits the OvS bridge again and because
   skb_is_gso returns true, it goes through queue_gso_packets...

5. ...where __skb_gso_segment is called. The skb is then dropped.

6. Note that in the above example on re-transmission the skb won't be a
   GSO one as it would be segmented (len > MSS) and the ICMP packet
   should go through.

Fix this by resetting the GSO information before reusing an skb in
iptunnel_pmtud_build_icmp and iptunnel_pmtud_build_icmpv6.

Fixes: 4cb47a8644cc ("tunnels: PMTU discovery support for directly bridged IP packets")
Reported-by: Adrian Moreno <amorenoz@redhat.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Link: https://patch.msgid.link/20250904125351.159740-1-atenart@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_tunnel_core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index f65d2f7273813..8392d304a72eb 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -204,6 +204,9 @@ static int iptunnel_pmtud_build_icmp(struct sk_buff *skb, int mtu)
 	if (!pskb_may_pull(skb, ETH_HLEN + sizeof(struct iphdr)))
 		return -EINVAL;
 
+	if (skb_is_gso(skb))
+		skb_gso_reset(skb);
+
 	skb_copy_bits(skb, skb_mac_offset(skb), &eh, ETH_HLEN);
 	pskb_pull(skb, ETH_HLEN);
 	skb_reset_network_header(skb);
@@ -298,6 +301,9 @@ static int iptunnel_pmtud_build_icmpv6(struct sk_buff *skb, int mtu)
 	if (!pskb_may_pull(skb, ETH_HLEN + sizeof(struct ipv6hdr)))
 		return -EINVAL;
 
+	if (skb_is_gso(skb))
+		skb_gso_reset(skb);
+
 	skb_copy_bits(skb, skb_mac_offset(skb), &eh, ETH_HLEN);
 	pskb_pull(skb, ETH_HLEN);
 	skb_reset_network_header(skb);
-- 
2.51.0



