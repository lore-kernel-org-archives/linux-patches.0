Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968AF18A6CF;
	Wed, 17 Sep 2025 12:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112995; cv=none; b=I4lxTkJFklhewZKiFmWxRFxH/NPr5GeIVKd1cdV3oAalgb3V4DBNG45IFGacji+9fv710BhLw6H06JXRPu6ZdzFN0Pj6tYtFbl6SFMHFoTrVAWDp5vR2sR4V5ovNDVa60Peda4T5XRgJGjJSzVRXiCv2LOYrR+GFETCKAMpxQlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112995; c=relaxed/simple;
	bh=H6A18Eobicn9qNccnwglGPZn5KaUJx4UlMxfZufIEsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/Q3FjjdlPsgNh+XyB6D9ITKb3snITlYnov/hyTIdpcRgHk9HS3ujcVuW74cadxzdPzB67KIK30iortVgdwmU0MGZf19kSb7fntCgrYLRE7nmReONK9vv1MTlZ1GFwQ/nr3zojVwUcZESN41I61kI3vJLv8DO1owiApUKrpAEE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lt1CXDAK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lt1CXDAK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14CA7C4CEF0;
	Wed, 17 Sep 2025 12:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112995;
	bh=H6A18Eobicn9qNccnwglGPZn5KaUJx4UlMxfZufIEsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lt1CXDAKIOmWWlVwer+hsPpal7+ZUNl2ui36D7xEydjh4G/jRZQk1onz+oc2tesvX
	 G6K9Vf+lDjuyHCh6AcHHeXaPFqI0FMMD6dn/UBUeonbL3ks8RrfxtTWMB0g0MZPlaX
	 O/uzqK9wQmafcp/rgVYg9OLBEQaAX4ok30yLjG7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Moreno <amorenoz@redhat.com>,
	Antoine Tenart <atenart@kernel.org>,
	Stefano Brivio <sbrivio@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 138/189] tunnels: reset the GSO metadata before reusing the skb
Date: Wed, 17 Sep 2025 14:34:08 +0200
Message-ID: <20250917123355.233160805@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



