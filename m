Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041930;
	b=pa3RqScduTXHP5jeFfWedw2/77O0wsKTVl62/SRSmq2YOAQEV0eSc0by1CLKFMwEOIn5
	 TLAssYE6+zQvV/08UG9cbueRG1+L9NAClJfvwNKSkZ1R8ZrtVjy98U62k93LxDdige+Vz
	 l55rXzyx1RAmN6+FnaTEpcLXM/qBif7AJsDPjh4MfH+2I5wSr8DUEmt/0R7Tv1v56t+8B
	 qfaC1o9LkvuizkvUTi39AKhrN4DSMQWyjC4zUcgV1qZxBZp7fSySFzFDBgMofWbykaCiy
	 oqI4VXows7kc1fHUDnLIuPo7T3/bdNiVRk+hFBmmUvCI9xclWylyKAT80jSphQgVVEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041930;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DCkxXSryfhf8Ppza2qFWNXQqCdoUXoKDLHl9uXWOgUw=;
	b=Kw48O0pfg1BlyteZHGMHQDevB1jffuyVpVwpa3V6zPgSshBZyFk2Ui71gVH7s+t/toiV
	 vUrqHqogFZL7tan/kydYwPXpVtqaw0Lm+xMNu9D5aw8NBfb/cSHtNm7V4hoXnlq4npZSA
	 b6BLqBmNTEZGfG17VLzNEIFMKFi1bvD6vyWEIN51v2m2nrbpGgXNo4lz+JRXvk97eyZok
	 szUlmJlu0Nvxyvr6G/s64I3Hhe9foUqbovbkaP/a34edmzj584ZCPLNu76FWN/BQf7Vcw
	 9hZaf23EpVncFUMneIsPoF+qVVHa4kCg3fqGdtZSzgkMaA7TcijA2O/TyYBDPUMlvTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KNl4IhGW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BD6606A31C;
	Wed, 18 Nov 2026 22:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KNl4IhGW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8611F000C4;
	Wed, 18 Nov 2026 22:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041930;
	bh=DCkxXSryfhf8Ppza2qFWNXQqCdoUXoKDLHl9uXWOgUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KNl4IhGWbM/KeQPyJR0pjnjZPe36Sfm8wJYYrHcCUyZ3FWbMcSA6dVQDaTqZD4uUo
	 9MVGM27DcfiR7KO9BVyTEAfvsMIRj24CadYtdrhRxXm9sx4d01+Rwcz70eMfV9edHB
	 rEWcMriRzxKtoJcS2j7CiA2Js+HyBVDvAjiBvmO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brad Fitzpatrick <bradfitz@tailscale.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2990/3318] gre: keep the UDP tunnel GSO type when completing GRO
Date: Wed, 18 Nov 2026 16:00:12 +0100
Message-ID: <20261118150449.967809485@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brad Fitzpatrick <bradfitz@tailscale.com>

[ Upstream commit 718f364a20ecee4f25986789c25550cf4da73b4c ]

gre_gro_complete() assigns SKB_GSO_GRE to gso_type rather than OR-ing
it in. When GRE is carried over UDP by FOU or GUE, udp_gro_complete()
has already set SKB_GSO_UDP_TUNNEL{,_CSUM} before calling into the FOU
or GUE gro_complete handler and then gre_gro_complete(), so that bit is
lost.

That has broken forwarding of such packets since FOU gained GRO: if a
host with a FOU or GUE socket on the tunnel's port merges transit
packets and then forwards them out a device that can't segment them
itself, udp4_ufo_fragment() finds neither tunnel bit and fails, and
the packets are dropped. Since commit 3d010c8031e3 ("udp: do not accept
non-tunnel GSO skbs landing in a tunnel"), local receive is broken too:
udp_unexpected_gso() considers the merged skb, which reaches the
encapsulation socket without either UDP tunnel bit, unexpected and
hands it to udp_rcv_segment(). Segmenting fails, so the packet is
freed and counted in UdpInErrors. Either way, only packets GRO didn't
merge get through, so TCP over FOU or GUE GRE tunnels slows to about
one segment per round trip whenever the receiving device has GRO
enabled.

OR in SKB_GSO_GRE instead, as ipip_gro_complete() and
sit_gro_complete() do for SKB_GSO_IPXIP4. For plain GRE, gso_type is
still zero at this point unless the driver set it, so nothing changes
there in the usual case.

The assignment dates to commit bf5a755f5e91 ("net-gre-gro: Add GRE
support to the GRO stack"), but nothing set gso_type before it until
FOU GRO came along, so the Fixes tag points there.

Tested under virtme-ng with bulk TCP over a GRE tunnel between two
network namespaces joined by a veth, with GRO on the receiving veth and
segmentation off on the sending one, so GRO sees wire-sized packets.
32 MiB took:

                  before                  after
  FOU over IPv4   26.0s, 9658 UDP errors  0.28s, 0 errors
  GUE over IPv4   26.1s, 9686 UDP errors  0.39s, 0 errors
  FOU over IPv6   26.4s, 9860 UDP errors  0.16s, 0 errors
  plain GRE       0.17s                   0.15s

Forwarding the same FOU traffic through a third namespace with its own
FOU socket on the port, GRO on its ingress and segmentation off on its
egress, took 26.0s with 4826 egress drops before and 0.31s with none
after. On v6.8, before 3d010c8031e3, local receive was fine but
forwarding failed the same way (25.7s, 4764 drops).

With GRO off on the receiver, all took under 0.2s both before and
after. The gre_gso.sh and fou_mcast_encap.sh selftests give the same
results before and after.

Fixes: afe93325bc02 ("fou: Add GRO support")
Signed-off-by: Brad Fitzpatrick <bradfitz@tailscale.com>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261011-bradfitz-gre-fou-gro-b4-v1-1-df713aad1531@tailscale.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/gre_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
index 311e70bfce407..22fa2493c529f 100644
--- a/net/ipv4/gre_offload.c
+++ b/net/ipv4/gre_offload.c
@@ -242,7 +242,7 @@ static int gre_gro_complete(struct sk_buff *skb, int nhoff)
 	__be16 type;
 
 	skb->encapsulation = 1;
-	skb_shinfo(skb)->gso_type = SKB_GSO_GRE;
+	skb_shinfo(skb)->gso_type |= SKB_GSO_GRE;
 
 	type = greh->protocol;
 	if (greh->flags & GRE_KEY)
-- 
2.53.0



