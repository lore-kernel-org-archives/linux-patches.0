Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24804158536;
	Mon,  6 Jan 2025 15:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177823; cv=none; b=acrrUeThEtYc0IkrNjbXmRoIxEPYIdNcfDD5G73h/F+X5BJSKavHzJ0nIJWK0Hn9dTdqDOKzLxMI27VpsjtVMk+irDS+//IaQheWDHhTW6+YniY9Apmt5vCvGJDVVrPhJo+mknrGD1Ur5BcnAUswlNnCJCmNYSqKTUQAx0ICwho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177823; c=relaxed/simple;
	bh=zMS7FQDAG+2tG8yV6Su+xGbbYQ/yJIQ7cLyr5b3r9b0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Na2vYZWulXVq7yC4PZlQnFFN5xcYG9sjuvb3w1c0dueKcLH7IMjJVt1d2aoeXOoSw9axQYZwwhEU51nGn9yeQOFafnn8zjhFowdPx+2KCE/PXTMrlfVoQOKP44Pj61YaOiYvizeio49PC5aRfyS/PPfrbTnJCt4gnIe5ghhtWz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qs3qFEW6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qs3qFEW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F151C4CEDF;
	Mon,  6 Jan 2025 15:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177822;
	bh=zMS7FQDAG+2tG8yV6Su+xGbbYQ/yJIQ7cLyr5b3r9b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qs3qFEW6If3MttQfL5Hl8wgC8WfytGTDnJoJVgtsE9aQevqvsz62eY90EgydTe2us
	 FrsZi3RcL4xvrLZnQqCObCOpwBup1saAhiBPqGTXpiWxLkomnz1LTfINrQV5JKkh2L
	 U/bzwr3auetZrjUButRG7sASlRKE3sIb+LJX9DyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 068/156] net: reenable NETIF_F_IPV6_CSUM offload for BIG TCP packets
Date: Mon,  6 Jan 2025 16:15:54 +0100
Message-ID: <20250106151144.296221451@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 68e068cabd2c6c533ef934c2e5151609cf6ecc6d ]

The blamed commit disabled hardware offoad of IPv6 packets with
extension headers on devices that advertise NETIF_F_IPV6_CSUM,
based on the definition of that feature in skbuff.h:

 *   * - %NETIF_F_IPV6_CSUM
 *     - Driver (device) is only able to checksum plain
 *       TCP or UDP packets over IPv6. These are specifically
 *       unencapsulated packets of the form IPv6|TCP or
 *       IPv6|UDP where the Next Header field in the IPv6
 *       header is either TCP or UDP. IPv6 extension headers
 *       are not supported with this feature. This feature
 *       cannot be set in features for a device with
 *       NETIF_F_HW_CSUM also set. This feature is being
 *       DEPRECATED (see below).

The change causes skb_warn_bad_offload to fire for BIG TCP
packets.

[  496.310233] WARNING: CPU: 13 PID: 23472 at net/core/dev.c:3129 skb_warn_bad_offload+0xc4/0xe0

[  496.310297]  ? skb_warn_bad_offload+0xc4/0xe0
[  496.310300]  skb_checksum_help+0x129/0x1f0
[  496.310303]  skb_csum_hwoffload_help+0x150/0x1b0
[  496.310306]  validate_xmit_skb+0x159/0x270
[  496.310309]  validate_xmit_skb_list+0x41/0x70
[  496.310312]  sch_direct_xmit+0x5c/0x250
[  496.310317]  __qdisc_run+0x388/0x620

BIG TCP introduced an IPV6_TLV_JUMBO IPv6 extension header to
communicate packet length, as this is an IPv6 jumbogram. But, the
feature is only enabled on devices that support BIG TCP TSO. The
header is only present for PF_PACKET taps like tcpdump, and not
transmitted by physical devices.

For this specific case of extension headers that are not
transmitted, return to the situation before the blamed commit
and support hardware offload.

ipv6_has_hopopt_jumbo() tests not only whether this header is present,
but also that it is the only extension header before a terminal (L4)
header.

Fixes: 04c20a9356f2 ("net: skip offload for NETIF_F_IPV6_CSUM if ipv6 header contains extension")
Reported-by: syzbot <syzkaller@googlegroups.com>
Reported-by: Eric Dumazet <edumazet@google.com>
Closes: https://lore.kernel.org/netdev/CANn89iK1hdC3Nt8KPhOtTF8vCPc1AHDCtse_BTNki1pWxAByTQ@mail.gmail.com/
Signed-off-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250101164909.1331680-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 8453e14d301b..f3fa8353d262 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3640,8 +3640,10 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
 
 	if (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) {
 		if (vlan_get_protocol(skb) == htons(ETH_P_IPV6) &&
-		    skb_network_header_len(skb) != sizeof(struct ipv6hdr))
+		    skb_network_header_len(skb) != sizeof(struct ipv6hdr) &&
+		    !ipv6_has_hopopt_jumbo(skb))
 			goto sw_checksum;
+
 		switch (skb->csum_offset) {
 		case offsetof(struct tcphdr, check):
 		case offsetof(struct udphdr, check):
-- 
2.39.5



