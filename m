Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591054;
	b=jK4BbsgWkpB7nZIyp+bgkikPP9rfyGYzNzG4eiq9pI3yeywMaj9lZ9UVtsKdGOTI6RNg
	 7fpctEaTaxJfGsmMy0cjrwyrRzNABJW2drcglpKb3lF2g4WiCJRCtYhdPQTLt60s+K6pb
	 Ff5mvBLtgHpLZDaL06jT1B45FKXEvcCmSBjdBntRGunws1Wo63BKqDqvt82OnKocEirMh
	 YED9q41Q/LGa/K/3yRL1CJODZ4B/cKKcEzUM2i75kV9J2s2htuZYb5TwW/e2Dh33NDDuZ
	 SC7+FkswUZxbAlLDU+hMOR3ZijSRsoYzgJNTAGPbjpWedObroJA3JIrXaayNAOCj9Fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591054;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HfmxwwioDz6A3x8LlTJIGQUvR/L0LnbTyaJKx04JklM=;
	b=by19QUoyqPvqchnB+JUxTNHnUQ6zweEp4Qf+73jImTP9NFKyMmJ5IKVgmPvuyEphOLlp
	 uVaTUCHW3BRGwGaO78sTzyJgtC2eiXPXfA5ikVx2OV0kj/3Hry6WhCKiNiKyg7kFy4RTX
	 w4cHm18wnJVe/lKqUk1rPL/B6hW9TmZM8TbZBMxzhIllpzzN5PlSjtUS37mp8B5lCS1s/
	 BmUNcRUpYJAjKG7kebYvMgKEg7yHxV2dSIvL0V5WuQJ8K2BJxCLU9rkUxq9HjMEhYd2Fe
	 Zabt7z/wuCI6zY+K/uXUEc1G2gENta+14bsZ5GgiHHD0kG8t8/kgPICeyIJATrg/uSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H6zxJSMT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637FC606A889;
	Fri, 13 Nov 2026 17:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H6zxJSMT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1201F000C4;
	Fri, 13 Nov 2026 17:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591054;
	bh=HfmxwwioDz6A3x8LlTJIGQUvR/L0LnbTyaJKx04JklM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H6zxJSMTsdT8gY05Px3D6TnlJDaS/Btm7H9+ZJVyahC9RlQxngLnJIc7Hhg3PyADv
	 4WRJsTqaTUSgZ9yJPl8d8y/mi3+5xR9JVjk5i/cBNPUwT8ao0UxpwKmeNwmPO5zF42
	 dxainQJwDfPpJZq1abDygKr20ids2eBywO38T2N8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Victor Nogueira <victor@mojatatu.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 216/670] bpf: Fix skb_pull() BUG in __bpf_redirect_neigh()
Date: Fri, 13 Nov 2026 10:46:20 -0500
Message-ID: <20261113153819.229125451@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 23503acb214cbefaf3945d05ab9667ff11ae3de9 ]

The issue:
This is a follow-up to the short link-layer header fixes from Eric.
After vlan pop_eth, a privileged SCHED_ACT BPF program can call
bpf_skb_change_head(skb, 1, 0) and then bpf_redirect_neigh().

__bpf_redirect_neigh() calls skb_pull(skb, sizeof(*ethh)) after checking
only that mac_header < network_header.  Nothing verifies that the MAC
header is long enough, that it is linear, or that the IP header the
redirect goes on to read is linear either.

A SCHED_ACT BPF program can do:

    bpf_skb_change_head(skb, 1, 0);
    bpf_redirect_neigh(lo, NULL, 0, 0);

after vlan pop_eth.  The skb then has mac_len == 1 and only one byte of
linear data; skb_pull(ETH_HLEN) trips the skb->len < skb->data_len BUG in
__skb_pull():

    kernel BUG at ./include/linux/skbuff.h:2839!
    RIP: skb_pull+0x40/0x50
    Call Trace: skb_do_redirect -> packet_xmit -> packet_sendmsg
    Kernel panic - not syncing: Fatal exception in interrupt

The v4 and v6 paths read ip_hdr() and ipv6_hdr() as soon as the MAC
header is gone.  On the AF_PACKET frame below that leaves headlen == 0
after the pull, so the network header sits at skb->tail and the route
lookup reads ip4h->protocol, ip4h->saddr and ip4h->daddr past the linear
area.

The Fix:
Use skb_network_offset(), which is the MAC header span, instead of
skb->mac_len.  mac_len is zero for locally generated tc egress and netkit
packets, while the span still rejects the one-byte header produced by
pop_eth + bpf_skb_change_head(skb, 1, 0).  The single check also covers
the mac_header >= network_header test it replaces.

Use pskb_may_pull() to make the Ethernet header linear before it is read
or pulled, and to make the IP header linear in both the v4 and the v6
path before ip_hdr()/ipv6_hdr() is read.  The header pointers are taken
after the pull, since pskb_may_pull() may reallocate skb->head.

Conditions to recreate the bug:
On x86-64 with 4 KiB pages, enable CONFIG_PACKET, CONFIG_BPF_SYSCALL,
CONFIG_NET_SCH_INGRESS, CONFIG_NET_CLS_MATCHALL, CONFIG_NET_ACT_VLAN and
CONFIG_NET_ACT_BPF.  Run as root with BPF loading, network administration
and raw-packet privileges.  Bring lo up and attach a SCHED_ACT program
that calls bpf_skb_change_head(skb, 1, 0), then returns
bpf_redirect_neigh(skb->ifindex, NULL, 0, 0):

  ip link set lo up
  tc qdisc add dev lo clsact
  tc filter add dev lo egress matchall action vlan pop_eth pipe \
      action bpf object-file neigh_chghead.o section action

Send an untagged ETH_P_IP frame of ETH_HLEN + 8192 bytes through an
AF_PACKET/SOCK_RAW socket bound to lo, without PACKET_VNET_HDR or
PACKET_QDISC_BYPASS.  Use a unicast destination MAC.  The sender's skb
has a 14-byte linear Ethernet prefix and a fragmented payload; pop_eth
removes that prefix and change_head restores only one linear byte.
The unfixed neighbor redirect then tries to pull 14 bytes and BUGs.

Sending the same frame without pop_eth and change_head leaves the IP
header in the frags, which is the route lookup reading past skb->tail.

Fixes: b4ab31414970 ("bpf: Add redirect_neigh helper as redirect drop-in")
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/netdev/20261027082604.1485903-1-edumazet@kernel.org/
Link: https://lore.kernel.org/all/2a0f5ff1d8db81b07fc4b344b8e68e3505fcbf36f72a471d1678b2f1cecd881b@mail.kernel.org/
Link: https://lore.kernel.org/netdev/DMII4JGTEUEG.2WRJPT6ODT6J0@gmail.com/
Link: https://patch.msgid.link/bpf_redirect_neigh_short_linear.v3.r0.20261031153053-1@mojatatu.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index ce290de4b1652..5ec9954b94542 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2278,9 +2278,13 @@ static int bpf_out_neigh_v6(struct net *net, struct sk_buff *skb,
 static int __bpf_redirect_neigh_v6(struct sk_buff *skb, struct net_device *dev,
 				   struct bpf_nh_params *nh)
 {
-	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
 	struct net *net = dev_net(dev);
 	int err, ret = NET_XMIT_DROP;
+	const struct ipv6hdr *ip6h;
+
+	if (unlikely(!pskb_may_pull(skb, sizeof(*ip6h))))
+		goto out_drop;
+	ip6h = ipv6_hdr(skb);
 
 	if (!nh) {
 		struct dst_entry *dst;
@@ -2383,9 +2387,13 @@ static int bpf_out_neigh_v4(struct net *net, struct sk_buff *skb,
 static int __bpf_redirect_neigh_v4(struct sk_buff *skb, struct net_device *dev,
 				   struct bpf_nh_params *nh)
 {
-	const struct iphdr *ip4h = ip_hdr(skb);
 	struct net *net = dev_net(dev);
 	int err, ret = NET_XMIT_DROP;
+	const struct iphdr *ip4h;
+
+	if (unlikely(!pskb_may_pull(skb, sizeof(*ip4h))))
+		goto out_drop;
+	ip4h = ip_hdr(skb);
 
 	if (!nh) {
 		struct flowi4 fl4 = {
@@ -2435,15 +2443,14 @@ static int __bpf_redirect_neigh_v4(struct sk_buff *skb, struct net_device *dev,
 static int __bpf_redirect_neigh(struct sk_buff *skb, struct net_device *dev,
 				struct bpf_nh_params *nh)
 {
-	struct ethhdr *ethh = eth_hdr(skb);
-
-	if (unlikely(skb->mac_header >= skb->network_header))
+	if (unlikely(skb_network_offset(skb) < ETH_HLEN ||
+		     !pskb_may_pull(skb, ETH_HLEN)))
 		goto out;
 	bpf_push_mac_rcsum(skb);
-	if (is_multicast_ether_addr(ethh->h_dest))
+	if (is_multicast_ether_addr(eth_hdr(skb)->h_dest))
 		goto out;
 
-	skb_pull(skb, sizeof(*ethh));
+	skb_pull(skb, ETH_HLEN);
 	skb_unset_mac_header(skb);
 	skb_reset_network_header(skb);
 
-- 
2.53.0



