Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A209580618;
	Mon,  8 Apr 2024 14:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585165; cv=none; b=C8nYp5Uai7M6leGUs+2MrhGeLS0q/ngTr7bYMxLhdIdqrH9YufGTC2Z6Tqq0f0V4+I3Nh+Xgzrp9cQlwrKU7z/V0TAb42sjq/NHY0mKg1dvF9geDHm3vqxfDyUpPAFx/6uGkL9fMAZMkteLJMkKvoSW5LoYy56UcxpeyIOqaFyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585165; c=relaxed/simple;
	bh=yWVqFSaKYCdd3U+9qIxvUfZfM1RE65YJE7DGS9H308w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=su2MjSzNOnKTr16B8OMmEh63g3kzFndZbZiZS/XuMGWwxG8PwPV9T9GnR64N95NZ5xEhFMiwkrL0d07d1BiqV89LaftydIYye28/jGHJHMAB7v0h/g1VhvfcwCVNXq5xWPti1tcfSaU+e3AVzUO+KRcx1S7j/LIC+FsXFjYkoaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TVLXpu1s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TVLXpu1s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C179C433F1;
	Mon,  8 Apr 2024 14:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585165;
	bh=yWVqFSaKYCdd3U+9qIxvUfZfM1RE65YJE7DGS9H308w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TVLXpu1sa4fda5+vS8Yz7NDlBLKrQZHaCt4UQ4Np4FU8GqvMu5GF/p3aNr5SLeadZ
	 rg2z4Oq+pj1RPiHIjm91V1TXlcnmpzMnr8ik2buaHg8Ibvpt7s2mLiuO0ksAVFTBPa
	 tHrzLimrmFIbq9qg+84dDIpvi4kJt01KdvIVYb3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1c1cf138518bf0c53d68@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 645/690] erspan: make sure erspan_base_hdr is present in skb->head
Date: Mon,  8 Apr 2024 14:58:31 +0200
Message-ID: <20240408125423.015743687@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

commit 17af420545a750f763025149fa7b833a4fc8b8f0 upstream.

syzbot reported a problem in ip6erspan_rcv() [1]

Issue is that ip6erspan_rcv() (and erspan_rcv()) no longer make
sure erspan_base_hdr is present in skb linear part (skb->head)
before getting @ver field from it.

Add the missing pskb_may_pull() calls.

v2: Reload iph pointer in erspan_rcv() after pskb_may_pull()
    because skb->head might have changed.

[1]

 BUG: KMSAN: uninit-value in pskb_may_pull_reason include/linux/skbuff.h:2742 [inline]
 BUG: KMSAN: uninit-value in pskb_may_pull include/linux/skbuff.h:2756 [inline]
 BUG: KMSAN: uninit-value in ip6erspan_rcv net/ipv6/ip6_gre.c:541 [inline]
 BUG: KMSAN: uninit-value in gre_rcv+0x11f8/0x1930 net/ipv6/ip6_gre.c:610
  pskb_may_pull_reason include/linux/skbuff.h:2742 [inline]
  pskb_may_pull include/linux/skbuff.h:2756 [inline]
  ip6erspan_rcv net/ipv6/ip6_gre.c:541 [inline]
  gre_rcv+0x11f8/0x1930 net/ipv6/ip6_gre.c:610
  ip6_protocol_deliver_rcu+0x1d4c/0x2ca0 net/ipv6/ip6_input.c:438
  ip6_input_finish net/ipv6/ip6_input.c:483 [inline]
  NF_HOOK include/linux/netfilter.h:314 [inline]
  ip6_input+0x15d/0x430 net/ipv6/ip6_input.c:492
  ip6_mc_input+0xa7e/0xc80 net/ipv6/ip6_input.c:586
  dst_input include/net/dst.h:460 [inline]
  ip6_rcv_finish+0x955/0x970 net/ipv6/ip6_input.c:79
  NF_HOOK include/linux/netfilter.h:314 [inline]
  ipv6_rcv+0xde/0x390 net/ipv6/ip6_input.c:310
  __netif_receive_skb_one_core net/core/dev.c:5538 [inline]
  __netif_receive_skb+0x1da/0xa00 net/core/dev.c:5652
  netif_receive_skb_internal net/core/dev.c:5738 [inline]
  netif_receive_skb+0x58/0x660 net/core/dev.c:5798
  tun_rx_batched+0x3ee/0x980 drivers/net/tun.c:1549
  tun_get_user+0x5566/0x69e0 drivers/net/tun.c:2002
  tun_chr_write_iter+0x3af/0x5d0 drivers/net/tun.c:2048
  call_write_iter include/linux/fs.h:2108 [inline]
  new_sync_write fs/read_write.c:497 [inline]
  vfs_write+0xb63/0x1520 fs/read_write.c:590
  ksys_write+0x20f/0x4c0 fs/read_write.c:643
  __do_sys_write fs/read_write.c:655 [inline]
  __se_sys_write fs/read_write.c:652 [inline]
  __x64_sys_write+0x93/0xe0 fs/read_write.c:652
 do_syscall_64+0xd5/0x1f0
 entry_SYSCALL_64_after_hwframe+0x6d/0x75

Uninit was created at:
  slab_post_alloc_hook mm/slub.c:3804 [inline]
  slab_alloc_node mm/slub.c:3845 [inline]
  kmem_cache_alloc_node+0x613/0xc50 mm/slub.c:3888
  kmalloc_reserve+0x13d/0x4a0 net/core/skbuff.c:577
  __alloc_skb+0x35b/0x7a0 net/core/skbuff.c:668
  alloc_skb include/linux/skbuff.h:1318 [inline]
  alloc_skb_with_frags+0xc8/0xbf0 net/core/skbuff.c:6504
  sock_alloc_send_pskb+0xa81/0xbf0 net/core/sock.c:2795
  tun_alloc_skb drivers/net/tun.c:1525 [inline]
  tun_get_user+0x209a/0x69e0 drivers/net/tun.c:1846
  tun_chr_write_iter+0x3af/0x5d0 drivers/net/tun.c:2048
  call_write_iter include/linux/fs.h:2108 [inline]
  new_sync_write fs/read_write.c:497 [inline]
  vfs_write+0xb63/0x1520 fs/read_write.c:590
  ksys_write+0x20f/0x4c0 fs/read_write.c:643
  __do_sys_write fs/read_write.c:655 [inline]
  __se_sys_write fs/read_write.c:652 [inline]
  __x64_sys_write+0x93/0xe0 fs/read_write.c:652
 do_syscall_64+0xd5/0x1f0
 entry_SYSCALL_64_after_hwframe+0x6d/0x75

CPU: 1 PID: 5045 Comm: syz-executor114 Not tainted 6.9.0-rc1-syzkaller-00021-g962490525cff #0

Fixes: cb73ee40b1b3 ("net: ip_gre: use erspan key field for tunnel lookup")
Reported-by: syzbot+1c1cf138518bf0c53d68@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/000000000000772f2c0614b66ef7@google.com/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://lore.kernel.org/r/20240328112248.1101491-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_gre.c  |    5 +++++
 net/ipv6/ip6_gre.c |    3 +++
 2 files changed, 8 insertions(+)

--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -280,8 +280,13 @@ static int erspan_rcv(struct sk_buff *sk
 					  tpi->flags | TUNNEL_NO_KEY,
 					  iph->saddr, iph->daddr, 0);
 	} else {
+		if (unlikely(!pskb_may_pull(skb,
+					    gre_hdr_len + sizeof(*ershdr))))
+			return PACKET_REJECT;
+
 		ershdr = (struct erspan_base_hdr *)(skb->data + gre_hdr_len);
 		ver = ershdr->ver;
+		iph = ip_hdr(skb);
 		tunnel = ip_tunnel_lookup(itn, skb->dev->ifindex,
 					  tpi->flags | TUNNEL_KEY,
 					  iph->saddr, iph->daddr, tpi->key);
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -533,6 +533,9 @@ static int ip6erspan_rcv(struct sk_buff
 	struct ip6_tnl *tunnel;
 	u8 ver;
 
+	if (unlikely(!pskb_may_pull(skb, sizeof(*ershdr))))
+		return PACKET_REJECT;
+
 	ipv6h = ipv6_hdr(skb);
 	ershdr = (struct erspan_base_hdr *)skb->data;
 	ver = ershdr->ver;


