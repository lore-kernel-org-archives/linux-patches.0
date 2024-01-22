Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C47C54654;
	Tue, 23 Jan 2024 00:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970152; cv=none; b=Q1prfgHlTs0UyTSE0RkR3BA59bwio4rFX4B6XWbwMGuu0UeHjOmxfgrSq92rQm2MPFVuAIHx1IxuGlyfG1V+WhFE6GzqiLNp3k7+AIPHAPcHMZO+cFaH/wZdB7KMqnbVuDNcmYz4CIuJaSnUijv1qHeyV3Uo2Bp92TJjPMZQgow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970152; c=relaxed/simple;
	bh=terxFD6leXt/Q8Wg2DUtK5N6fMBBBQ3NB6zCqhYRbns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlhQbtCHEqPy4kDcIDZXXypnZssDyqONFAVJEpa6usuIZP1zoABSgipq14hJUBkEXqBU4kNrHkgk9VzKvhVaYEkE14SHP/yE4YHuVLFX9sA6pwCqoG4DAuuEDNej26Jy5vtteCY51RHEUahxfWM/ec7JGQyx4MGe3A36b7UN7YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iJGCKWh4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iJGCKWh4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53739C433C7;
	Tue, 23 Jan 2024 00:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970151;
	bh=terxFD6leXt/Q8Wg2DUtK5N6fMBBBQ3NB6zCqhYRbns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iJGCKWh4LicSMam19awtY3uLb+8b0Lt396RGPuwEe0DbcGt7MjLVYC4eHU0yRoqqP
	 Q9e+NMH3dGbcDfT0xS+mn4KPgX5aZUN9qLZjk83jIPBSd+i2wP0Dv5F3HwmMA6XCj3
	 NLgGwdrFXc4u/rQhATTLlnh+ATYvn6o+lXjIX0qE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7f4d0ea3df4d4fa9a65f@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 600/641] net: add more sanity check in virtio_net_hdr_to_skb()
Date: Mon, 22 Jan 2024 15:58:24 -0800
Message-ID: <20240122235836.993622984@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9181d6f8a2bb32d158de66a84164fac05e3ddd18 ]

syzbot/KMSAN reports access to uninitialized data from gso_features_check() [1]

The repro use af_packet, injecting a gso packet and hdrlen == 0.

We could fix the issue making gso_features_check() more careful
while dealing with NETIF_F_TSO_MANGLEID in fast path.

Or we can make sure virtio_net_hdr_to_skb() pulls minimal network and
transport headers as intended.

Note that for GSO packets coming from untrusted sources, SKB_GSO_DODGY
bit forces a proper header validation (and pull) before the packet can
hit any device ndo_start_xmit(), thus we do not need a precise disection
at virtio_net_hdr_to_skb() stage.

[1]
BUG: KMSAN: uninit-value in skb_gso_segment include/net/gso.h:83 [inline]
BUG: KMSAN: uninit-value in validate_xmit_skb+0x10f2/0x1930 net/core/dev.c:3629
 skb_gso_segment include/net/gso.h:83 [inline]
 validate_xmit_skb+0x10f2/0x1930 net/core/dev.c:3629
 __dev_queue_xmit+0x1eac/0x5130 net/core/dev.c:4341
 dev_queue_xmit include/linux/netdevice.h:3134 [inline]
 packet_xmit+0x9c/0x6b0 net/packet/af_packet.c:276
 packet_snd net/packet/af_packet.c:3087 [inline]
 packet_sendmsg+0x8b1d/0x9f30 net/packet/af_packet.c:3119
 sock_sendmsg_nosec net/socket.c:730 [inline]
 __sock_sendmsg net/socket.c:745 [inline]
 ____sys_sendmsg+0x9c2/0xd60 net/socket.c:2584
 ___sys_sendmsg+0x28d/0x3c0 net/socket.c:2638
 __sys_sendmsg net/socket.c:2667 [inline]
 __do_sys_sendmsg net/socket.c:2676 [inline]
 __se_sys_sendmsg net/socket.c:2674 [inline]
 __x64_sys_sendmsg+0x307/0x490 net/socket.c:2674
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0x44/0x110 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x63/0x6b

Uninit was created at:
 slab_post_alloc_hook+0x129/0xa70 mm/slab.h:768
 slab_alloc_node mm/slub.c:3478 [inline]
 kmem_cache_alloc_node+0x5e9/0xb10 mm/slub.c:3523
 kmalloc_reserve+0x13d/0x4a0 net/core/skbuff.c:560
 __alloc_skb+0x318/0x740 net/core/skbuff.c:651
 alloc_skb include/linux/skbuff.h:1286 [inline]
 alloc_skb_with_frags+0xc8/0xbd0 net/core/skbuff.c:6334
 sock_alloc_send_pskb+0xa80/0xbf0 net/core/sock.c:2780
 packet_alloc_skb net/packet/af_packet.c:2936 [inline]
 packet_snd net/packet/af_packet.c:3030 [inline]
 packet_sendmsg+0x70e8/0x9f30 net/packet/af_packet.c:3119
 sock_sendmsg_nosec net/socket.c:730 [inline]
 __sock_sendmsg net/socket.c:745 [inline]
 ____sys_sendmsg+0x9c2/0xd60 net/socket.c:2584
 ___sys_sendmsg+0x28d/0x3c0 net/socket.c:2638
 __sys_sendmsg net/socket.c:2667 [inline]
 __do_sys_sendmsg net/socket.c:2676 [inline]
 __se_sys_sendmsg net/socket.c:2674 [inline]
 __x64_sys_sendmsg+0x307/0x490 net/socket.c:2674
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0x44/0x110 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x63/0x6b

CPU: 0 PID: 5025 Comm: syz-executor279 Not tainted 6.7.0-rc7-syzkaller-00003-gfbafc3e621c3 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/17/2023

Reported-by: syzbot+7f4d0ea3df4d4fa9a65f@syzkaller.appspotmail.com
Link: https://lore.kernel.org/netdev/0000000000005abd7b060eb160cd@google.com/
Fixes: 9274124f023b ("net: stricter validation of untrusted gso packets")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/virtio_net.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 27cc1d464321..4dfa9b69ca8d 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -3,6 +3,8 @@
 #define _LINUX_VIRTIO_NET_H
 
 #include <linux/if_vlan.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
 #include <linux/udp.h>
 #include <uapi/linux/tcp.h>
 #include <uapi/linux/virtio_net.h>
@@ -49,6 +51,7 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 					const struct virtio_net_hdr *hdr,
 					bool little_endian)
 {
+	unsigned int nh_min_len = sizeof(struct iphdr);
 	unsigned int gso_type = 0;
 	unsigned int thlen = 0;
 	unsigned int p_off = 0;
@@ -65,6 +68,7 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 			gso_type = SKB_GSO_TCPV6;
 			ip_proto = IPPROTO_TCP;
 			thlen = sizeof(struct tcphdr);
+			nh_min_len = sizeof(struct ipv6hdr);
 			break;
 		case VIRTIO_NET_HDR_GSO_UDP:
 			gso_type = SKB_GSO_UDP;
@@ -100,7 +104,8 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 		if (!skb_partial_csum_set(skb, start, off))
 			return -EINVAL;
 
-		p_off = skb_transport_offset(skb) + thlen;
+		nh_min_len = max_t(u32, nh_min_len, skb_transport_offset(skb));
+		p_off = nh_min_len + thlen;
 		if (!pskb_may_pull(skb, p_off))
 			return -EINVAL;
 	} else {
@@ -140,7 +145,7 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 
 			skb_set_transport_header(skb, keys.control.thoff);
 		} else if (gso_type) {
-			p_off = thlen;
+			p_off = nh_min_len + thlen;
 			if (!pskb_may_pull(skb, p_off))
 				return -EINVAL;
 		}
-- 
2.43.0



