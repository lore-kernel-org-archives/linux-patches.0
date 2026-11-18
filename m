Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056523;
	b=erZIHNG1BKXsQC/fQmkCsKKa8dNgrpOCx0W43uwU0IjzQIxi1lnssNX+0Ci764j6ejGM
	 2d/wkWVvY+qrweShSE2XP8yGNfjTwI79Nbj/Oy5uAKDcbpOVp9CapBRFF1lU/ia1ucqB8
	 JYpunVILCQCuA+DepLKUjGwL5k+3+yTEeaAgakcTVb+fZ+n4hEygVpf/kLg2wfmkLh4mw
	 TMm6ytgwUkFx2MyTNNV3bhPkywhCrQutXvjz5Dx8jz1SYjJwRMJ4X/lFp6DZIssbrS9Lv
	 /MPBtewAka3zIHpTXcotC2LPdXOPSaQOHj4StMu0FXE5bjle7hqCM7+yUgcag4Ef3lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056523;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JbGQJtsPMN5jXpwU5J7LYRPZzgXFoWCwvfw/KyOzWAo=;
	b=cCQe/tVujuEkVoOHGrwZrk4UogNiQgeIIf1rvcAyXospDD6BSbllzaNveW6tjQXLXTzk
	 42udJgCs29OKSGOpeS9v4+hXhAoByVdeeW0mBSQBK0FmqCAuGivQKDMhAwEl9MxwX+ZQO
	 LWZHgCP3S6QVdRRJPYa5P8HxC5DL+TGM+fEkvPpl28wljFlUPxQaf3/pE1SB3v0dzYMaq
	 czNgqC1Kkwd44wD4ZdFVwTzwkSpR6wZoHMNc5ufJ9uhzE6IkdhH2aaprAxTSxpTZDsE4C
	 NraM7nnFo2dJsroAvISkV2m+ffYVehS52sv5MFbFinOaOyITnAN29PjePJ6os6Hjzpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="K/c0qK1N";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04324606A338;
	Thu, 19 Nov 2026 02:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K/c0qK1N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4211F000C7;
	Thu, 19 Nov 2026 02:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056522;
	bh=JbGQJtsPMN5jXpwU5J7LYRPZzgXFoWCwvfw/KyOzWAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K/c0qK1NMD2nCqWqyUXrXP12QuPQAyKuNsWGxTueLx/2gLX6/e+cw0nQrjgturGBI
	 SB2YVjcdzkEDzYwEeywD0SRVZt3wyzYMbHC51/bvdmQ7AHDULh8TtyEfda76xM9LVx
	 nRUKmjm2NLVeu1Dv5uc4p5KNosm/cV69qoX+snzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brad Fitzpatrick <bradfitz@tailscale.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2018/2214] gre: keep the UDP tunnel GSO type when completing GRO
Date: Wed, 18 Nov 2026 16:01:34 +0100
Message-ID: <20261118150131.466199307@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9a18fd1d56481..4436051eca597 100644
--- a/net/ipv4/gre_offload.c
+++ b/net/ipv4/gre_offload.c
@@ -243,7 +243,7 @@ static int gre_gro_complete(struct sk_buff *skb, int nhoff)
 	__be16 type;
 
 	skb->encapsulation = 1;
-	skb_shinfo(skb)->gso_type = SKB_GSO_GRE;
+	skb_shinfo(skb)->gso_type |= SKB_GSO_GRE;
 
 	type = greh->protocol;
 	if (greh->flags & GRE_KEY)
-- 
2.53.0



