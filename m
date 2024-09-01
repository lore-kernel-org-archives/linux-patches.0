Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685CB2B9C7;
	Sun,  1 Sep 2024 16:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208902; cv=none; b=RvjU2h2YYlUkoTRw68Qu0wyuC8Wf8tjGF2aBm1Vogb/zu7W0/rjCxLMr55a+WzWYZC7wC99PieL61+NeGCQSvd9EnExMhdb0HJg+OFxk9Rwuy4RdHLvKJ2aMESBlumkZLmW/51FoqsOCW7J9LhkpsLZI0kNqH6Kqp1GZSOjd2co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208902; c=relaxed/simple;
	bh=ex5dHkP6gzt36J8P/RcGksy4vWcWMrXfB4+y8dVzOXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LARlja3fmLejqhkvbTrk9yjfqZ/4VR/SY4QHXcEb61uUvtsQ+s2rm1R8Dej5r0x+8otdMsWxiBuadxJmUfXfSnd8+8RUa+nC4ggWq2+IptQnjW+0Bfg8QJPrBzCRVqX5p6WIpJrU57d8KZZdEV3EDYE4ykMq+Ch909PQ3T26dHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h3yYHtOW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h3yYHtOW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD19AC4CEC3;
	Sun,  1 Sep 2024 16:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208902;
	bh=ex5dHkP6gzt36J8P/RcGksy4vWcWMrXfB4+y8dVzOXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h3yYHtOWbCv71lKoWonTCXaIhjUWVz3h19UjCIN8mNk8tNi/B+cjrXDrwsauZzINr
	 af7DmWNc7LfT4Yvlhih2W/c5w3PmnUzFf/+3CcvWuQgqNRxwzP657wNlXLskDMiTUt
	 dNU9KVsmH6Iwfnmpt6pdXES2yxwiVzGfCYUwksco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Harald Welte <laforge@gnumonks.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 074/134] gtp: pull network headers in gtp_dev_xmit()
Date: Sun,  1 Sep 2024 18:17:00 +0200
Message-ID: <20240901160812.886689254@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 3a3be7ff9224f424e485287b54be00d2c6bd9c40 upstream.

syzbot/KMSAN reported use of uninit-value in get_dev_xmit() [1]

We must make sure the IPv4 or Ipv6 header is pulled in skb->head
before accessing fields in them.

Use pskb_inet_may_pull() to fix this issue.

[1]
BUG: KMSAN: uninit-value in ipv6_pdp_find drivers/net/gtp.c:220 [inline]
 BUG: KMSAN: uninit-value in gtp_build_skb_ip6 drivers/net/gtp.c:1229 [inline]
 BUG: KMSAN: uninit-value in gtp_dev_xmit+0x1424/0x2540 drivers/net/gtp.c:1281
  ipv6_pdp_find drivers/net/gtp.c:220 [inline]
  gtp_build_skb_ip6 drivers/net/gtp.c:1229 [inline]
  gtp_dev_xmit+0x1424/0x2540 drivers/net/gtp.c:1281
  __netdev_start_xmit include/linux/netdevice.h:4913 [inline]
  netdev_start_xmit include/linux/netdevice.h:4922 [inline]
  xmit_one net/core/dev.c:3580 [inline]
  dev_hard_start_xmit+0x247/0xa20 net/core/dev.c:3596
  __dev_queue_xmit+0x358c/0x5610 net/core/dev.c:4423
  dev_queue_xmit include/linux/netdevice.h:3105 [inline]
  packet_xmit+0x9c/0x6c0 net/packet/af_packet.c:276
  packet_snd net/packet/af_packet.c:3145 [inline]
  packet_sendmsg+0x90e3/0xa3a0 net/packet/af_packet.c:3177
  sock_sendmsg_nosec net/socket.c:730 [inline]
  __sock_sendmsg+0x30f/0x380 net/socket.c:745
  __sys_sendto+0x685/0x830 net/socket.c:2204
  __do_sys_sendto net/socket.c:2216 [inline]
  __se_sys_sendto net/socket.c:2212 [inline]
  __x64_sys_sendto+0x125/0x1d0 net/socket.c:2212
  x64_sys_call+0x3799/0x3c10 arch/x86/include/generated/asm/syscalls_64.h:45
  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
  do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
  slab_post_alloc_hook mm/slub.c:3994 [inline]
  slab_alloc_node mm/slub.c:4037 [inline]
  kmem_cache_alloc_node_noprof+0x6bf/0xb80 mm/slub.c:4080
  kmalloc_reserve+0x13d/0x4a0 net/core/skbuff.c:583
  __alloc_skb+0x363/0x7b0 net/core/skbuff.c:674
  alloc_skb include/linux/skbuff.h:1320 [inline]
  alloc_skb_with_frags+0xc8/0xbf0 net/core/skbuff.c:6526
  sock_alloc_send_pskb+0xa81/0xbf0 net/core/sock.c:2815
  packet_alloc_skb net/packet/af_packet.c:2994 [inline]
  packet_snd net/packet/af_packet.c:3088 [inline]
  packet_sendmsg+0x749c/0xa3a0 net/packet/af_packet.c:3177
  sock_sendmsg_nosec net/socket.c:730 [inline]
  __sock_sendmsg+0x30f/0x380 net/socket.c:745
  __sys_sendto+0x685/0x830 net/socket.c:2204
  __do_sys_sendto net/socket.c:2216 [inline]
  __se_sys_sendto net/socket.c:2212 [inline]
  __x64_sys_sendto+0x125/0x1d0 net/socket.c:2212
  x64_sys_call+0x3799/0x3c10 arch/x86/include/generated/asm/syscalls_64.h:45
  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
  do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 0 UID: 0 PID: 7115 Comm: syz.1.515 Not tainted 6.11.0-rc1-syzkaller-00043-g94ede2a3e913 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/27/2024

Fixes: 999cb275c807 ("gtp: add IPv6 support")
Fixes: 459aa660eb1d ("gtp: add initial driver for datapath of GPRS Tunneling Protocol (GTP-U)")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Harald Welte <laforge@gnumonks.org>
Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
Link: https://patch.msgid.link/20240808132455.3413916-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/gtp.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -573,6 +573,9 @@ static netdev_tx_t gtp_dev_xmit(struct s
 	if (skb_cow_head(skb, dev->needed_headroom))
 		goto tx_err;
 
+	if (!pskb_inet_may_pull(skb))
+		goto tx_err;
+
 	skb_reset_inner_headers(skb);
 
 	/* PDP context lookups in gtp_build_skb_*() need rcu read-side lock. */


