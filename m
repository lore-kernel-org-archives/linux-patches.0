Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987EA2BE7CD;
	Fri,  9 Oct 2026 14:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556306; cv=none; b=KdpANEW3BiAIAqqhNDM864VO8JG8PugGAOkC6ia8g4h8roOoCPwkavSRHz7pDuv0sLJL6IyDO4lCMEd9/fzh3NK4VY1u8wxI5eshR1/+OkLmMoLyRrTOdtKgtVketG0jBAz8dQLrAnzuBZP9NivykjxW6SzdWY8VuiR4QzOSdCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556306; c=relaxed/simple;
	bh=WS0XxYTFhqylUasiuJBJSw/Ox2jh2jlMT8S3iOIGf/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/nwSzNmVeR4KlOEAdlXoh2tWDU9PK5UAIq2yRXMmn8wMez3TJmTb/5hzXuKKVylLECQWrpieub47nNpxwBFMtqVJZUMvRxwHA/3huleqYV5WBqe/fudy/YdZkry/u235nKq0r4JoC3U+5d+V++ZCrNe1GpIQuvNKJuqkoy4LsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ycqtk3fY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ycqtk3fY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0742D1F000FF;
	Fri,  9 Oct 2026 14:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556305;
	bh=FsnQPEMj1uAV0/NPRRIR2I4HcZL0VCkKdBFye9GsSMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ycqtk3fYU1tyi/dPC/LmuxAe/XhStke4+P1QgPMup/J+QzeeTwxo2HXU2gcaKaI+r
	 4ziigeCf0PYELqbbmbWrM0kRvIe4OGjQ1cz0UtlQBwxsfVB+VmcoVGbj+3IXJXnC91
	 qw5riLVl77N8ua7rHBORxgjJC5QKPeqo2SojeUVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9408fbe0e6452a12e9ab@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@kernel.org>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 155/428] ipv6: sr: use skb_get_hash_net() in seg6_make_flowlabel()
Date: Fri,  9 Oct 2026 16:08:12 +0200
Message-ID: <20261009140949.572235600@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 8ec454dcd00ce3375119111c6394964455b36d0d ]

Since commit d58e468b1112 ("flow_dissector: implements flow dissector
BPF hook") __skb_flow_dissect() needs a net pointer, either from
skb->dev, skb->sk, or since commit 3cbf4ffba5ee ("net: plumb network
namespace into __skb_flow_dissect") a caller provided pointer.

syzbot was able to reach seg6_make_flowlabel() with an skb having
neither skb->dev nor skb->sk set: a TIPC UDP bearer sends a discovery
message through an IPv4 route using seg6 encap, while
net.ipv6.seg6_flowlabel is set to 1.

seg6_make_flowlabel() already has a net pointer, use skb_get_hash_net().

WARNING: net/core/flow_dissector.c:1131 at __skb_flow_dissect+0x910/0x5368 net/core/flow_dissector.c:1126, CPU#0: syz.0.17/4930
Call trace:
  __skb_flow_dissect+0x910/0x5368 net/core/flow_dissector.c:1126 (P)
  __skb_get_hash_net+0xe0/0x29c net/core/flow_dissector.c:1903
  skb_get_hash include/linux/skbuff.h:1663 [inline]
  seg6_make_flowlabel+0xcc/0x1ec net/ipv6/seg6_iptunnel.c:132
  __seg6_do_srh_encap+0x320/0xbf4 net/ipv6/seg6_iptunnel.c:161
  seg6_do_srh+0x4b4/0xa44 net/ipv6/seg6_iptunnel.c:431
  seg6_output_core+0x164/0x688 net/ipv6/seg6_iptunnel.c:681
  seg6_output+0x44/0x1ac net/ipv6/seg6_iptunnel.c:744
  lwtunnel_output+0x3d0/0x664 net/core/lwtunnel.c:356
  dst_output include/net/dst.h:470 [inline]
  ip_local_out+0x110/0x148 net/ipv4/ip_output.c:131
  iptunnel_xmit+0x50c/0xd38 net/ipv4/ip_tunnel_core.c:97
  udp_tunnel_xmit_skb+0x220/0x348 net/ipv4/udp_tunnel_core.c:187
  tipc_udp_xmit+0x75c/0x9c0 net/tipc/udp_media.c:202
  tipc_udp_send_msg+0x214/0x374 net/tipc/udp_media.c:274
  tipc_bearer_xmit_skb+0x260/0x3b0 net/tipc/bearer.c:576
  tipc_enable_bearer net/tipc/bearer.c:366 [inline]
  __tipc_nl_bearer_enable+0xc90/0xfb0 net/tipc/bearer.c:1048
  tipc_nl_bearer_enable+0x2c/0x48 net/tipc/bearer.c:1057
  genl_family_rcv_msg_doit+0x1e4/0x2d4 net/netlink/genetlink.c:1114

Fixes: d58e468b1112 ("flow_dissector: implements flow dissector BPF hook")
Reported-by: syzbot+9408fbe0e6452a12e9ab@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6abac2eb.3654fce1.1bec97.0000.GAE@google.com/
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260928194524.3617299-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6_iptunnel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index 4c45c0a77d75d..73422a2730809 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -127,7 +127,7 @@ static __be32 seg6_make_flowlabel(struct net *net, struct sk_buff *skb,
 	u32 hash;
 
 	if (do_flowlabel > 0) {
-		hash = skb_get_hash(skb);
+		hash = skb_get_hash_net(net, skb);
 		hash = rol32(hash, 16);
 		flowlabel = (__force __be32)hash & IPV6_FLOWLABEL_MASK;
 	} else if (!do_flowlabel && skb->protocol == htons(ETH_P_IPV6)) {
-- 
2.53.0



