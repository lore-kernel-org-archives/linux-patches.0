Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F153C41B343;
	Wed,  4 Feb 2026 14:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216759; cv=none; b=QIg6bsBcPyMFT7DI4v4Oj+sNhNChylkzp3TJ6kpOtV7pGC+YniZGAs2kx+OH8na4sqHCSYzwTw45I2GMwD9P21bTFXW9iapT6q8/4oO9Mmfe+XmmdPGiTx2Vd7Ou4NzGZtvO6yNOETb90RuDdG0qjdyEcfYAuarSWOUpHBGhzYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216759; c=relaxed/simple;
	bh=lEJkcqPhPbP6nNOWUEan0Uc6CIwP5FlX/W1uAXEeiDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLMY6ZDLrX//GJJEQ2weujUbYSVhaSE89mDUuJJXklkAkgg3FtlH4OJuo8+KX/EIPEtcHviui3wAoXXDdwyWbXbhlK/B+ZwCwGpJnEU2RtdyWiQInTfrrC1vaxr11SaDyhd/dWZTITWgGlK+0/ro/dQ5N/G+YO1cdYiG+CyB8xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RIGJ0T/4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RIGJ0T/4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6459FC4CEF7;
	Wed,  4 Feb 2026 14:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216758;
	bh=lEJkcqPhPbP6nNOWUEan0Uc6CIwP5FlX/W1uAXEeiDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RIGJ0T/4rpDqlM/zAThQQwT0kLEP90BfReKIRFwrmUx5OlKJdbfVi4OsA04I8EZMQ
	 cB9ejjeXHKS0IwHq1SCz8Pp4VHwtGu4h8HTrLMm8EV2bL9MKMqKnZwsFfJOIcDSGlD
	 U6y1X3r2+h9VnxsszaUERpbOu+Ip5NCr43VqyV6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d4dda070f833dc5dc89a@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 006/206] ip6_tunnel: use skb_vlan_inet_prepare() in __ip6_tnl_rcv()
Date: Wed,  4 Feb 2026 15:37:17 +0100
Message-ID: <20260204143858.427827108@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 81c734dae203757fb3c9eee6f9896386940776bd ]

Blamed commit did not take care of VLAN encapsulations
as spotted by syzbot [1].

Use skb_vlan_inet_prepare() instead of pskb_inet_may_pull().

[1]
 BUG: KMSAN: uninit-value in __INET_ECN_decapsulate include/net/inet_ecn.h:253 [inline]
 BUG: KMSAN: uninit-value in INET_ECN_decapsulate include/net/inet_ecn.h:275 [inline]
 BUG: KMSAN: uninit-value in IP6_ECN_decapsulate+0x7a8/0x1fa0 include/net/inet_ecn.h:321
  __INET_ECN_decapsulate include/net/inet_ecn.h:253 [inline]
  INET_ECN_decapsulate include/net/inet_ecn.h:275 [inline]
  IP6_ECN_decapsulate+0x7a8/0x1fa0 include/net/inet_ecn.h:321
  ip6ip6_dscp_ecn_decapsulate+0x16f/0x1b0 net/ipv6/ip6_tunnel.c:729
  __ip6_tnl_rcv+0xed9/0x1b50 net/ipv6/ip6_tunnel.c:860
  ip6_tnl_rcv+0xc3/0x100 net/ipv6/ip6_tunnel.c:903
 gre_rcv+0x1529/0x1b90 net/ipv6/ip6_gre.c:-1
  ip6_protocol_deliver_rcu+0x1c89/0x2c60 net/ipv6/ip6_input.c:438
  ip6_input_finish+0x1f4/0x4a0 net/ipv6/ip6_input.c:489
  NF_HOOK include/linux/netfilter.h:318 [inline]
  ip6_input+0x9c/0x330 net/ipv6/ip6_input.c:500
  ip6_mc_input+0x7ca/0xc10 net/ipv6/ip6_input.c:590
  dst_input include/net/dst.h:474 [inline]
  ip6_rcv_finish+0x958/0x990 net/ipv6/ip6_input.c:79
  NF_HOOK include/linux/netfilter.h:318 [inline]
  ipv6_rcv+0xf1/0x3c0 net/ipv6/ip6_input.c:311
  __netif_receive_skb_one_core net/core/dev.c:6139 [inline]
  __netif_receive_skb+0x1df/0xac0 net/core/dev.c:6252
  netif_receive_skb_internal net/core/dev.c:6338 [inline]
  netif_receive_skb+0x57/0x630 net/core/dev.c:6397
  tun_rx_batched+0x1df/0x980 drivers/net/tun.c:1485
  tun_get_user+0x5c0e/0x6c60 drivers/net/tun.c:1953
  tun_chr_write_iter+0x3e9/0x5c0 drivers/net/tun.c:1999
  new_sync_write fs/read_write.c:593 [inline]
  vfs_write+0xbe2/0x15d0 fs/read_write.c:686
  ksys_write fs/read_write.c:738 [inline]
  __do_sys_write fs/read_write.c:749 [inline]
  __se_sys_write fs/read_write.c:746 [inline]
  __x64_sys_write+0x1fb/0x4d0 fs/read_write.c:746
  x64_sys_call+0x30ab/0x3e70 arch/x86/include/generated/asm/syscalls_64.h:2
  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
  do_syscall_64+0xd3/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
  slab_post_alloc_hook mm/slub.c:4960 [inline]
  slab_alloc_node mm/slub.c:5263 [inline]
  kmem_cache_alloc_node_noprof+0x9e7/0x17a0 mm/slub.c:5315
  kmalloc_reserve+0x13c/0x4b0 net/core/skbuff.c:586
  __alloc_skb+0x805/0x1040 net/core/skbuff.c:690
  alloc_skb include/linux/skbuff.h:1383 [inline]
  alloc_skb_with_frags+0xc5/0xa60 net/core/skbuff.c:6712
  sock_alloc_send_pskb+0xacc/0xc60 net/core/sock.c:2995
  tun_alloc_skb drivers/net/tun.c:1461 [inline]
  tun_get_user+0x1142/0x6c60 drivers/net/tun.c:1794
  tun_chr_write_iter+0x3e9/0x5c0 drivers/net/tun.c:1999
  new_sync_write fs/read_write.c:593 [inline]
  vfs_write+0xbe2/0x15d0 fs/read_write.c:686
  ksys_write fs/read_write.c:738 [inline]
  __do_sys_write fs/read_write.c:749 [inline]
  __se_sys_write fs/read_write.c:746 [inline]
  __x64_sys_write+0x1fb/0x4d0 fs/read_write.c:746
  x64_sys_call+0x30ab/0x3e70 arch/x86/include/generated/asm/syscalls_64.h:2
  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
  do_syscall_64+0xd3/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 0 UID: 0 PID: 6465 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(none)
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025

Fixes: 8d975c15c0cd ("ip6_tunnel: make sure to pull inner header in __ip6_tnl_rcv()")
Reported-by: syzbot+d4dda070f833dc5dc89a@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/695e88b2.050a0220.1c677c.036d.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260107163109.4188620-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_tunnel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index ccdea44438940..553851e3aca14 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -846,7 +846,7 @@ static int __ip6_tnl_rcv(struct ip6_tnl *tunnel, struct sk_buff *skb,
 
 	skb_reset_network_header(skb);
 
-	if (!pskb_inet_may_pull(skb)) {
+	if (skb_vlan_inet_prepare(skb, true)) {
 		DEV_STATS_INC(tunnel->dev, rx_length_errors);
 		DEV_STATS_INC(tunnel->dev, rx_errors);
 		goto drop;
-- 
2.51.0



