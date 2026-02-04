Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3C741C30A;
	Wed,  4 Feb 2026 15:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217415; cv=none; b=pLd0qyMFu3v4tY/o/5B5lLDVc5Jn0UVWNnFG6nToxc+qtXmFQ5j8V/8gn88CrKJs3QD+Y1gXEWzMXA3ACmeeJpWsUABz8VtBgTW/B9wIXKPL6Qr18tcPx0BI6zFpROGvPUygDS5jM8e5Vb0BzWXrvNcxvSPTx0ZkQ5K4UfHroZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217415; c=relaxed/simple;
	bh=K1RQiGoRKkVdFXmc3Xs96MPmuiqhgAWsYB3jVMG9sFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A54wZYF85bSsMl6PqQ4T5SNj4vrBnn+b05Rjq9VfcmQb2/O3V7TupIgdV9Dys8ifkWMfq2C6TgxQHk3km8rHhtb/xRDlqjknnQH/EiEI7aXZRamVslHXBH5g0z0gIs0yrVCUxzINnj6+eCPhKo9Z5jTULKF9vb5wTvmwgRR8BkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ERf385P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ERf385P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798DAC4CEF7;
	Wed,  4 Feb 2026 15:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217414;
	bh=K1RQiGoRKkVdFXmc3Xs96MPmuiqhgAWsYB3jVMG9sFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ERf385PpMTaztL60K3pK5qWv81dPmaKNT7FC4fwOaz9bGFBmHDk+03ydwoZxXxto
	 6C6xr4G13UFLMeWA9Pa2oykUFHqfF26TFirlwFhSlPZqW2CcyY3OME8sQiKTWcp2vn
	 Xqm3Xmq7gfucgbgeineevMJQ7UOrW5yXQweZbd7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d4dda070f833dc5dc89a@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 010/280] ip6_tunnel: use skb_vlan_inet_prepare() in __ip6_tnl_rcv()
Date: Wed,  4 Feb 2026 15:36:24 +0100
Message-ID: <20260204143909.999401683@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index dfca22c6d345d..8ce36fcc3dd5b 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -844,7 +844,7 @@ static int __ip6_tnl_rcv(struct ip6_tnl *tunnel, struct sk_buff *skb,
 
 	skb_reset_network_header(skb);
 
-	if (!pskb_inet_may_pull(skb)) {
+	if (skb_vlan_inet_prepare(skb, true)) {
 		DEV_STATS_INC(tunnel->dev, rx_length_errors);
 		DEV_STATS_INC(tunnel->dev, rx_errors);
 		goto drop;
-- 
2.51.0



