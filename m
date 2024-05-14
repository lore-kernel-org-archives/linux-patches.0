Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB96320F;
	Tue, 14 May 2024 11:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687587; cv=none; b=T87/+mQdHv40c5zw6CzDYJFMI7Ck5KElIrQ6qiuHIxgnDNHjXfEP15oTPcUyBA6uMJ5pBL+iUOm7Dt/wIAia/sLTmt8qPkR0k9XP3ySfxvSlSYbIBnGc851gF2SyUGeYqDIpJVVHe+UnrFCOrnz65y+iPlsfmz9svBqxmTupxZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687587; c=relaxed/simple;
	bh=EwxoUEoYT9xjEteDWz4A0lRVkdCbo2dQKYoqaP3kB0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gsZXQ0waKYiZUQlA42q492BGvqXujn4CJIyNwKtRraKgKvibqidFDWaJk3Pn0HVe4rilZ0RZjdWBA3DIU7SJBaljoj0LX5D+qz1MuEmME5cbU8hFz119cTX1A6jT4AyP8eoQOCugjVtqJpN0T25TyvFjEiEP47sivJNemYRmqu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FN0kqGsy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FN0kqGsy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD5FC2BD10;
	Tue, 14 May 2024 11:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687586;
	bh=EwxoUEoYT9xjEteDWz4A0lRVkdCbo2dQKYoqaP3kB0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FN0kqGsyyVZ6y4i/O0gAyyxL6iWMzchOAPmgEw5eWxTQJupQAj5SGm47r+H2GTlZ5
	 7UJ+mJvdKWCMLwz264vb5+lik0oH+wqXej/+8k0madQnYghDFw3hEMgp92/pRC2swG
	 Y70EOLC6mK9BBX9Ay/SIKDyRjckBDucFE6MShvMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+42a0dc856239de4de60e@syzkaller.appspotmail.com,
	syzbot+c298c9f0e46a3c86332b@syzkaller.appspotmail.com
Subject: [PATCH 5.15 035/168] nsh: Restore skb->{protocol,data,mac_header} for outer header in nsh_gso_segment().
Date: Tue, 14 May 2024 12:18:53 +0200
Message-ID: <20240514101008.016914458@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 4b911a9690d72641879ea6d13cce1de31d346d79 ]

syzbot triggered various splats (see [0] and links) by a crafted GSO
packet of VIRTIO_NET_HDR_GSO_UDP layering the following protocols:

  ETH_P_8021AD + ETH_P_NSH + ETH_P_IPV6 + IPPROTO_UDP

NSH can encapsulate IPv4, IPv6, Ethernet, NSH, and MPLS.  As the inner
protocol can be Ethernet, NSH GSO handler, nsh_gso_segment(), calls
skb_mac_gso_segment() to invoke inner protocol GSO handlers.

nsh_gso_segment() does the following for the original skb before
calling skb_mac_gso_segment()

  1. reset skb->network_header
  2. save the original skb->{mac_heaeder,mac_len} in a local variable
  3. pull the NSH header
  4. resets skb->mac_header
  5. set up skb->mac_len and skb->protocol for the inner protocol.

and does the following for the segmented skb

  6. set ntohs(ETH_P_NSH) to skb->protocol
  7. push the NSH header
  8. restore skb->mac_header
  9. set skb->mac_header + mac_len to skb->network_header
 10. restore skb->mac_len

There are two problems in 6-7 and 8-9.

  (a)
  After 6 & 7, skb->data points to the NSH header, so the outer header
  (ETH_P_8021AD in this case) is stripped when skb is sent out of netdev.

  Also, if NSH is encapsulated by NSH + Ethernet (so NSH-Ethernet-NSH),
  skb_pull() in the first nsh_gso_segment() will make skb->data point
  to the middle of the outer NSH or Ethernet header because the Ethernet
  header is not pulled by the second nsh_gso_segment().

  (b)
  While restoring skb->{mac_header,network_header} in 8 & 9,
  nsh_gso_segment() does not assume that the data in the linear
  buffer is shifted.

  However, udp6_ufo_fragment() could shift the data and change
  skb->mac_header accordingly as demonstrated by syzbot.

  If this happens, even the restored skb->mac_header points to
  the middle of the outer header.

It seems nsh_gso_segment() has never worked with outer headers so far.

At the end of nsh_gso_segment(), the outer header must be restored for
the segmented skb, instead of the NSH header.

To do that, let's calculate the outer header position relatively from
the inner header and set skb->{data,mac_header,protocol} properly.

[0]:
BUG: KMSAN: uninit-value in ipvlan_process_outbound drivers/net/ipvlan/ipvlan_core.c:524 [inline]
BUG: KMSAN: uninit-value in ipvlan_xmit_mode_l3 drivers/net/ipvlan/ipvlan_core.c:602 [inline]
BUG: KMSAN: uninit-value in ipvlan_queue_xmit+0xf44/0x16b0 drivers/net/ipvlan/ipvlan_core.c:668
 ipvlan_process_outbound drivers/net/ipvlan/ipvlan_core.c:524 [inline]
 ipvlan_xmit_mode_l3 drivers/net/ipvlan/ipvlan_core.c:602 [inline]
 ipvlan_queue_xmit+0xf44/0x16b0 drivers/net/ipvlan/ipvlan_core.c:668
 ipvlan_start_xmit+0x5c/0x1a0 drivers/net/ipvlan/ipvlan_main.c:222
 __netdev_start_xmit include/linux/netdevice.h:4989 [inline]
 netdev_start_xmit include/linux/netdevice.h:5003 [inline]
 xmit_one net/core/dev.c:3547 [inline]
 dev_hard_start_xmit+0x244/0xa10 net/core/dev.c:3563
 __dev_queue_xmit+0x33ed/0x51c0 net/core/dev.c:4351
 dev_queue_xmit include/linux/netdevice.h:3171 [inline]
 packet_xmit+0x9c/0x6b0 net/packet/af_packet.c:276
 packet_snd net/packet/af_packet.c:3081 [inline]
 packet_sendmsg+0x8aef/0x9f10 net/packet/af_packet.c:3113
 sock_sendmsg_nosec net/socket.c:730 [inline]
 __sock_sendmsg net/socket.c:745 [inline]
 __sys_sendto+0x735/0xa10 net/socket.c:2191
 __do_sys_sendto net/socket.c:2203 [inline]
 __se_sys_sendto net/socket.c:2199 [inline]
 __x64_sys_sendto+0x125/0x1c0 net/socket.c:2199
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x63/0x6b

Uninit was created at:
 slab_post_alloc_hook mm/slub.c:3819 [inline]
 slab_alloc_node mm/slub.c:3860 [inline]
 __do_kmalloc_node mm/slub.c:3980 [inline]
 __kmalloc_node_track_caller+0x705/0x1000 mm/slub.c:4001
 kmalloc_reserve+0x249/0x4a0 net/core/skbuff.c:582
 __alloc_skb+0x352/0x790 net/core/skbuff.c:651
 skb_segment+0x20aa/0x7080 net/core/skbuff.c:4647
 udp6_ufo_fragment+0xcab/0x1150 net/ipv6/udp_offload.c:109
 ipv6_gso_segment+0x14be/0x2ca0 net/ipv6/ip6_offload.c:152
 skb_mac_gso_segment+0x3e8/0x760 net/core/gso.c:53
 nsh_gso_segment+0x6f4/0xf70 net/nsh/nsh.c:108
 skb_mac_gso_segment+0x3e8/0x760 net/core/gso.c:53
 __skb_gso_segment+0x4b0/0x730 net/core/gso.c:124
 skb_gso_segment include/net/gso.h:83 [inline]
 validate_xmit_skb+0x107f/0x1930 net/core/dev.c:3628
 __dev_queue_xmit+0x1f28/0x51c0 net/core/dev.c:4343
 dev_queue_xmit include/linux/netdevice.h:3171 [inline]
 packet_xmit+0x9c/0x6b0 net/packet/af_packet.c:276
 packet_snd net/packet/af_packet.c:3081 [inline]
 packet_sendmsg+0x8aef/0x9f10 net/packet/af_packet.c:3113
 sock_sendmsg_nosec net/socket.c:730 [inline]
 __sock_sendmsg net/socket.c:745 [inline]
 __sys_sendto+0x735/0xa10 net/socket.c:2191
 __do_sys_sendto net/socket.c:2203 [inline]
 __se_sys_sendto net/socket.c:2199 [inline]
 __x64_sys_sendto+0x125/0x1c0 net/socket.c:2199
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x63/0x6b

CPU: 1 PID: 5101 Comm: syz-executor421 Not tainted 6.8.0-rc5-syzkaller-00297-gf2e367d6ad3b #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/25/2024

Fixes: c411ed854584 ("nsh: add GSO support")
Reported-and-tested-by: syzbot+42a0dc856239de4de60e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=42a0dc856239de4de60e
Reported-and-tested-by: syzbot+c298c9f0e46a3c86332b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c298c9f0e46a3c86332b
Link: https://lore.kernel.org/netdev/20240415222041.18537-1-kuniyu@amazon.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/r/20240424023549.21862-1-kuniyu@amazon.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nsh/nsh.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/nsh/nsh.c b/net/nsh/nsh.c
index 0f23e5e8e03eb..3e0fc71d95a14 100644
--- a/net/nsh/nsh.c
+++ b/net/nsh/nsh.c
@@ -76,13 +76,15 @@ EXPORT_SYMBOL_GPL(nsh_pop);
 static struct sk_buff *nsh_gso_segment(struct sk_buff *skb,
 				       netdev_features_t features)
 {
+	unsigned int outer_hlen, mac_len, nsh_len;
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
 	u16 mac_offset = skb->mac_header;
-	unsigned int nsh_len, mac_len;
-	__be16 proto;
+	__be16 outer_proto, proto;
 
 	skb_reset_network_header(skb);
 
+	outer_proto = skb->protocol;
+	outer_hlen = skb_mac_header_len(skb);
 	mac_len = skb->mac_len;
 
 	if (unlikely(!pskb_may_pull(skb, NSH_BASE_HDR_LEN)))
@@ -112,10 +114,10 @@ static struct sk_buff *nsh_gso_segment(struct sk_buff *skb,
 	}
 
 	for (skb = segs; skb; skb = skb->next) {
-		skb->protocol = htons(ETH_P_NSH);
-		__skb_push(skb, nsh_len);
-		skb->mac_header = mac_offset;
-		skb->network_header = skb->mac_header + mac_len;
+		skb->protocol = outer_proto;
+		__skb_push(skb, nsh_len + outer_hlen);
+		skb_reset_mac_header(skb);
+		skb_set_network_header(skb, outer_hlen);
 		skb->mac_len = mac_len;
 	}
 
-- 
2.43.0



