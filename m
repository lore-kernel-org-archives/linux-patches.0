Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 392357F1;
	Tue, 23 Jan 2024 00:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969467; cv=none; b=Vs633D4guRjEC5g25fj3MKuKXd4mn2oKPindA0LMVk8+Y0iCJ9OTZmOg7ln9nhIrkLzBOG3aBODYUgaQtCi1gicDr/lH4nRWVQCVgRCbIee6BMLr9IcdIvH2zZ+7rUvLzehgUa+VexzIxBVjtCBn/5nyJvTdhbwyWyj3MnUu62o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969467; c=relaxed/simple;
	bh=q0AZDMsH1XliitvMk1sSAdTDrvrCRfHl9NCyDCqH2Qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h/HsA6JvdfeZU8j+UmPnNH56RBLq6ga2CPqpSmz+x0f8qqXZDJai9EaVFStffbq/rzDC+hq9En2oF01ddO75FGlTHuuGk+3+ToSUqhZx5bkkzFk7dYfhcRi2yxj/rUdW2Q8oQ3QBpahXV9/wC7cC1M9WRRr/rr5eHDFFWslrMIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FKjxQNIL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FKjxQNIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 493A7C43394;
	Tue, 23 Jan 2024 00:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969467;
	bh=q0AZDMsH1XliitvMk1sSAdTDrvrCRfHl9NCyDCqH2Qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FKjxQNIL9TNoLyfhnl3R8jjlPAHAmaK1Q1AUrYi7uoA6avlJd9eTOyTGS94valMSO
	 5Sd9BVYZ6AV+LoFU7ujicZ6ELQbdLXmvyeU3wTLHYCslIgccrFH3PFXI2jpbdFZA9j
	 VYhkYKWVtxr6doXhipH9FEuJQnP494lx1HZ3qZG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 240/641] ip6_tunnel: fix NEXTHDR_FRAGMENT handling in ip6_tnl_parse_tlv_enc_lim()
Date: Mon, 22 Jan 2024 15:52:24 -0800
Message-ID: <20240122235825.440633555@linuxfoundation.org>
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

[ Upstream commit d375b98e0248980681e5e56b712026174d617198 ]

syzbot pointed out [1] that NEXTHDR_FRAGMENT handling is broken.

Reading frag_off can only be done if we pulled enough bytes
to skb->head. Currently we might access garbage.

[1]
BUG: KMSAN: uninit-value in ip6_tnl_parse_tlv_enc_lim+0x94f/0xbb0
ip6_tnl_parse_tlv_enc_lim+0x94f/0xbb0
ipxip6_tnl_xmit net/ipv6/ip6_tunnel.c:1326 [inline]
ip6_tnl_start_xmit+0xab2/0x1a70 net/ipv6/ip6_tunnel.c:1432
__netdev_start_xmit include/linux/netdevice.h:4940 [inline]
netdev_start_xmit include/linux/netdevice.h:4954 [inline]
xmit_one net/core/dev.c:3548 [inline]
dev_hard_start_xmit+0x247/0xa10 net/core/dev.c:3564
__dev_queue_xmit+0x33b8/0x5130 net/core/dev.c:4349
dev_queue_xmit include/linux/netdevice.h:3134 [inline]
neigh_connected_output+0x569/0x660 net/core/neighbour.c:1592
neigh_output include/net/neighbour.h:542 [inline]
ip6_finish_output2+0x23a9/0x2b30 net/ipv6/ip6_output.c:137
ip6_finish_output+0x855/0x12b0 net/ipv6/ip6_output.c:222
NF_HOOK_COND include/linux/netfilter.h:303 [inline]
ip6_output+0x323/0x610 net/ipv6/ip6_output.c:243
dst_output include/net/dst.h:451 [inline]
ip6_local_out+0xe9/0x140 net/ipv6/output_core.c:155
ip6_send_skb net/ipv6/ip6_output.c:1952 [inline]
ip6_push_pending_frames+0x1f9/0x560 net/ipv6/ip6_output.c:1972
rawv6_push_pending_frames+0xbe8/0xdf0 net/ipv6/raw.c:582
rawv6_sendmsg+0x2b66/0x2e70 net/ipv6/raw.c:920
inet_sendmsg+0x105/0x190 net/ipv4/af_inet.c:847
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
__kmem_cache_alloc_node+0x5c9/0x970 mm/slub.c:3517
__do_kmalloc_node mm/slab_common.c:1006 [inline]
__kmalloc_node_track_caller+0x118/0x3c0 mm/slab_common.c:1027
kmalloc_reserve+0x249/0x4a0 net/core/skbuff.c:582
pskb_expand_head+0x226/0x1a00 net/core/skbuff.c:2098
__pskb_pull_tail+0x13b/0x2310 net/core/skbuff.c:2655
pskb_may_pull_reason include/linux/skbuff.h:2673 [inline]
pskb_may_pull include/linux/skbuff.h:2681 [inline]
ip6_tnl_parse_tlv_enc_lim+0x901/0xbb0 net/ipv6/ip6_tunnel.c:408
ipxip6_tnl_xmit net/ipv6/ip6_tunnel.c:1326 [inline]
ip6_tnl_start_xmit+0xab2/0x1a70 net/ipv6/ip6_tunnel.c:1432
__netdev_start_xmit include/linux/netdevice.h:4940 [inline]
netdev_start_xmit include/linux/netdevice.h:4954 [inline]
xmit_one net/core/dev.c:3548 [inline]
dev_hard_start_xmit+0x247/0xa10 net/core/dev.c:3564
__dev_queue_xmit+0x33b8/0x5130 net/core/dev.c:4349
dev_queue_xmit include/linux/netdevice.h:3134 [inline]
neigh_connected_output+0x569/0x660 net/core/neighbour.c:1592
neigh_output include/net/neighbour.h:542 [inline]
ip6_finish_output2+0x23a9/0x2b30 net/ipv6/ip6_output.c:137
ip6_finish_output+0x855/0x12b0 net/ipv6/ip6_output.c:222
NF_HOOK_COND include/linux/netfilter.h:303 [inline]
ip6_output+0x323/0x610 net/ipv6/ip6_output.c:243
dst_output include/net/dst.h:451 [inline]
ip6_local_out+0xe9/0x140 net/ipv6/output_core.c:155
ip6_send_skb net/ipv6/ip6_output.c:1952 [inline]
ip6_push_pending_frames+0x1f9/0x560 net/ipv6/ip6_output.c:1972
rawv6_push_pending_frames+0xbe8/0xdf0 net/ipv6/raw.c:582
rawv6_sendmsg+0x2b66/0x2e70 net/ipv6/raw.c:920
inet_sendmsg+0x105/0x190 net/ipv4/af_inet.c:847
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

CPU: 0 PID: 7345 Comm: syz-executor.3 Not tainted 6.7.0-rc8-syzkaller-00024-gac865f00af29 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/17/2023

Fixes: fbfa743a9d2a ("ipv6: fix ip6_tnl_parse_tlv_enc_lim()")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_tunnel.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 5e80e517f071..46c19bd48990 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -399,7 +399,7 @@ __u16 ip6_tnl_parse_tlv_enc_lim(struct sk_buff *skb, __u8 *raw)
 	const struct ipv6hdr *ipv6h = (const struct ipv6hdr *)raw;
 	unsigned int nhoff = raw - skb->data;
 	unsigned int off = nhoff + sizeof(*ipv6h);
-	u8 next, nexthdr = ipv6h->nexthdr;
+	u8 nexthdr = ipv6h->nexthdr;
 
 	while (ipv6_ext_hdr(nexthdr) && nexthdr != NEXTHDR_NONE) {
 		struct ipv6_opt_hdr *hdr;
@@ -410,25 +410,25 @@ __u16 ip6_tnl_parse_tlv_enc_lim(struct sk_buff *skb, __u8 *raw)
 
 		hdr = (struct ipv6_opt_hdr *)(skb->data + off);
 		if (nexthdr == NEXTHDR_FRAGMENT) {
-			struct frag_hdr *frag_hdr = (struct frag_hdr *) hdr;
-			if (frag_hdr->frag_off)
-				break;
 			optlen = 8;
 		} else if (nexthdr == NEXTHDR_AUTH) {
 			optlen = ipv6_authlen(hdr);
 		} else {
 			optlen = ipv6_optlen(hdr);
 		}
-		/* cache hdr->nexthdr, since pskb_may_pull() might
-		 * invalidate hdr
-		 */
-		next = hdr->nexthdr;
-		if (nexthdr == NEXTHDR_DEST) {
-			u16 i = 2;
 
-			/* Remember : hdr is no longer valid at this point. */
-			if (!pskb_may_pull(skb, off + optlen))
+		if (!pskb_may_pull(skb, off + optlen))
+			break;
+
+		hdr = (struct ipv6_opt_hdr *)(skb->data + off);
+		if (nexthdr == NEXTHDR_FRAGMENT) {
+			struct frag_hdr *frag_hdr = (struct frag_hdr *)hdr;
+
+			if (frag_hdr->frag_off)
 				break;
+		}
+		if (nexthdr == NEXTHDR_DEST) {
+			u16 i = 2;
 
 			while (1) {
 				struct ipv6_tlv_tnl_enc_lim *tel;
@@ -449,7 +449,7 @@ __u16 ip6_tnl_parse_tlv_enc_lim(struct sk_buff *skb, __u8 *raw)
 					i++;
 			}
 		}
-		nexthdr = next;
+		nexthdr = hdr->nexthdr;
 		off += optlen;
 	}
 	return 0;
-- 
2.43.0



