Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBB47992D;
	Wed, 21 Feb 2024 13:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522958; cv=none; b=KyZ1L76qW4s2qnN26gxVRMyhzhPQmH46gE4YKuu0q9KHypzYsNUq4UjCMfpkSO4Z8ZacnDs3uNKweX4uFTVqBorT+NHGyB0TYsriL26PjwQYMPl2vH01E+SCNRE7JEStmZoyi1LzP6SjrK4Liej0bMqPWOEhC/Bu8SXwPuDV9qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522958; c=relaxed/simple;
	bh=h8fbINHqDhZ/24lZynN94ViKwLOH+i0LahxcaeevAiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G0w+KWgNjyhk0U9WwgA6EE+uARLCMDzjxkFQZEkt+YWiVSKZbyIZ4bsOXi9wIMx/N/7A5h/Pvg7sWm2mXT03F5rJ/xziCVBQlL3y1GjQ+4DV6qhzreiJhg+ljnFl3PpmrwRl3Avf3lMbzxe6ZEoiUD7OrS/LdWOdd7XmBEyF4e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rOix1Srt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rOix1Srt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92108C433F1;
	Wed, 21 Feb 2024 13:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522958;
	bh=h8fbINHqDhZ/24lZynN94ViKwLOH+i0LahxcaeevAiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rOix1SrtINbTeXq7hjnW6Hqna7Fyq3SruIZzKKegrdI3kpmset1XWhhiqCtOjQn5j
	 a0H8fWPrfnT8CZCh2fjZcBgUnpQqzZpYC/28DC+qM2/xnrP2HZkyFFjVXwSCJqBJ2a
	 xO9vxWAFUjnCEANUQuxiaxg5mEkqdnnvBXc1LJEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 274/476] ip6_tunnel: make sure to pull inner header in __ip6_tnl_rcv()
Date: Wed, 21 Feb 2024 14:05:25 +0100
Message-ID: <20240221130018.094549391@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 8d975c15c0cd744000ca386247432d57b21f9df0 ]

syzbot found __ip6_tnl_rcv() could access unitiliazed data [1].

Call pskb_inet_may_pull() to fix this, and initialize ipv6h
variable after this call as it can change skb->head.

[1]
 BUG: KMSAN: uninit-value in __INET_ECN_decapsulate include/net/inet_ecn.h:253 [inline]
 BUG: KMSAN: uninit-value in INET_ECN_decapsulate include/net/inet_ecn.h:275 [inline]
 BUG: KMSAN: uninit-value in IP6_ECN_decapsulate+0x7df/0x1e50 include/net/inet_ecn.h:321
  __INET_ECN_decapsulate include/net/inet_ecn.h:253 [inline]
  INET_ECN_decapsulate include/net/inet_ecn.h:275 [inline]
  IP6_ECN_decapsulate+0x7df/0x1e50 include/net/inet_ecn.h:321
  ip6ip6_dscp_ecn_decapsulate+0x178/0x1b0 net/ipv6/ip6_tunnel.c:727
  __ip6_tnl_rcv+0xd4e/0x1590 net/ipv6/ip6_tunnel.c:845
  ip6_tnl_rcv+0xce/0x100 net/ipv6/ip6_tunnel.c:888
 gre_rcv+0x143f/0x1870
  ip6_protocol_deliver_rcu+0xda6/0x2a60 net/ipv6/ip6_input.c:438
  ip6_input_finish net/ipv6/ip6_input.c:483 [inline]
  NF_HOOK include/linux/netfilter.h:314 [inline]
  ip6_input+0x15d/0x430 net/ipv6/ip6_input.c:492
  ip6_mc_input+0xa7e/0xc80 net/ipv6/ip6_input.c:586
  dst_input include/net/dst.h:461 [inline]
  ip6_rcv_finish+0x5db/0x870 net/ipv6/ip6_input.c:79
  NF_HOOK include/linux/netfilter.h:314 [inline]
  ipv6_rcv+0xda/0x390 net/ipv6/ip6_input.c:310
  __netif_receive_skb_one_core net/core/dev.c:5532 [inline]
  __netif_receive_skb+0x1a6/0x5a0 net/core/dev.c:5646
  netif_receive_skb_internal net/core/dev.c:5732 [inline]
  netif_receive_skb+0x58/0x660 net/core/dev.c:5791
  tun_rx_batched+0x3ee/0x980 drivers/net/tun.c:1555
  tun_get_user+0x53af/0x66d0 drivers/net/tun.c:2002
  tun_chr_write_iter+0x3af/0x5d0 drivers/net/tun.c:2048
  call_write_iter include/linux/fs.h:2084 [inline]
  new_sync_write fs/read_write.c:497 [inline]
  vfs_write+0x786/0x1200 fs/read_write.c:590
  ksys_write+0x20f/0x4c0 fs/read_write.c:643
  __do_sys_write fs/read_write.c:655 [inline]
  __se_sys_write fs/read_write.c:652 [inline]
  __x64_sys_write+0x93/0xd0 fs/read_write.c:652
  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
  do_syscall_64+0x6d/0x140 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x63/0x6b

Uninit was created at:
  slab_post_alloc_hook+0x129/0xa70 mm/slab.h:768
  slab_alloc_node mm/slub.c:3478 [inline]
  kmem_cache_alloc_node+0x5e9/0xb10 mm/slub.c:3523
  kmalloc_reserve+0x13d/0x4a0 net/core/skbuff.c:560
  __alloc_skb+0x318/0x740 net/core/skbuff.c:651
  alloc_skb include/linux/skbuff.h:1286 [inline]
  alloc_skb_with_frags+0xc8/0xbd0 net/core/skbuff.c:6334
  sock_alloc_send_pskb+0xa80/0xbf0 net/core/sock.c:2787
  tun_alloc_skb drivers/net/tun.c:1531 [inline]
  tun_get_user+0x1e8a/0x66d0 drivers/net/tun.c:1846
  tun_chr_write_iter+0x3af/0x5d0 drivers/net/tun.c:2048
  call_write_iter include/linux/fs.h:2084 [inline]
  new_sync_write fs/read_write.c:497 [inline]
  vfs_write+0x786/0x1200 fs/read_write.c:590
  ksys_write+0x20f/0x4c0 fs/read_write.c:643
  __do_sys_write fs/read_write.c:655 [inline]
  __se_sys_write fs/read_write.c:652 [inline]
  __x64_sys_write+0x93/0xd0 fs/read_write.c:652
  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
  do_syscall_64+0x6d/0x140 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x63/0x6b

CPU: 0 PID: 5034 Comm: syz-executor331 Not tainted 6.7.0-syzkaller-00562-g9f8413c4a66f #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/17/2023

Fixes: 0d3c703a9d17 ("ipv6: Cleanup IPv6 tunnel receive path")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240125170557.2663942-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_tunnel.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 35bd93347b8b..d370a71c9752 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -798,8 +798,8 @@ static int __ip6_tnl_rcv(struct ip6_tnl *tunnel, struct sk_buff *skb,
 						struct sk_buff *skb),
 			 bool log_ecn_err)
 {
-	const struct ipv6hdr *ipv6h = ipv6_hdr(skb);
-	int err;
+	const struct ipv6hdr *ipv6h;
+	int nh, err;
 
 	if ((!(tpi->flags & TUNNEL_CSUM) &&
 	     (tunnel->parms.i_flags & TUNNEL_CSUM)) ||
@@ -831,7 +831,6 @@ static int __ip6_tnl_rcv(struct ip6_tnl *tunnel, struct sk_buff *skb,
 			goto drop;
 		}
 
-		ipv6h = ipv6_hdr(skb);
 		skb->protocol = eth_type_trans(skb, tunnel->dev);
 		skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
 	} else {
@@ -839,7 +838,23 @@ static int __ip6_tnl_rcv(struct ip6_tnl *tunnel, struct sk_buff *skb,
 		skb_reset_mac_header(skb);
 	}
 
+	/* Save offset of outer header relative to skb->head,
+	 * because we are going to reset the network header to the inner header
+	 * and might change skb->head.
+	 */
+	nh = skb_network_header(skb) - skb->head;
+
 	skb_reset_network_header(skb);
+
+	if (!pskb_inet_may_pull(skb)) {
+		DEV_STATS_INC(tunnel->dev, rx_length_errors);
+		DEV_STATS_INC(tunnel->dev, rx_errors);
+		goto drop;
+	}
+
+	/* Get the outer header. */
+	ipv6h = (struct ipv6hdr *)(skb->head + nh);
+
 	memset(skb->cb, 0, sizeof(struct inet6_skb_parm));
 
 	__skb_tunnel_rx(skb, tunnel->dev, tunnel->net);
-- 
2.43.0



