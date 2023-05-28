Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3718611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:44:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DFC4C433D2;
	Sun, 28 May 2023 19:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685303086;
	bh=I0gRVigCHeU5plZqCKqUw+xQMB4LE+7cQh0hh8fi06E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o1Mw3R1fkRhhxsB0GgWuWZRyVLKFaW1MI9P3No/7VycZ20KnS1+6JK1zwYVzsw1ao
	 UORFKiCwhfxUsNEsHfh6EzAEHvYl7L85XEcshLrN7XjmKrH71OU494Tq+s0DUpwTfg
	 e5ldAh5ozq+KXDcYqMP5Y61Eik7pwlTHktAyYf/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/211] vlan: fix a potential uninit-value in vlan_dev_hard_start_xmit()
Date: Sun, 28 May 2023 20:10:41 +0100
Message-Id: <20230528190846.539779588@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190843.514829708@linuxfoundation.org>
References: <20230528190843.514829708@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit dacab578c7c6cd06c50c89dfa36b0e0f10decd4e ]

syzbot triggered the following splat [1], sending an empty message
through pppoe_sendmsg().

When VLAN_FLAG_REORDER_HDR flag is set, vlan_dev_hard_header()
does not push extra bytes for the VLAN header, because vlan is offloaded.

Unfortunately vlan_dev_hard_start_xmit() first reads veth->h_vlan_proto
before testing (vlan->flags & VLAN_FLAG_REORDER_HDR).

We need to swap the two conditions.

[1]
BUG: KMSAN: uninit-value in vlan_dev_hard_start_xmit+0x171/0x7f0 net/8021q/vlan_dev.c:111
vlan_dev_hard_start_xmit+0x171/0x7f0 net/8021q/vlan_dev.c:111
__netdev_start_xmit include/linux/netdevice.h:4883 [inline]
netdev_start_xmit include/linux/netdevice.h:4897 [inline]
xmit_one net/core/dev.c:3580 [inline]
dev_hard_start_xmit+0x253/0xa20 net/core/dev.c:3596
__dev_queue_xmit+0x3c7f/0x5ac0 net/core/dev.c:4246
dev_queue_xmit include/linux/netdevice.h:3053 [inline]
pppoe_sendmsg+0xa93/0xb80 drivers/net/ppp/pppoe.c:900
sock_sendmsg_nosec net/socket.c:724 [inline]
sock_sendmsg net/socket.c:747 [inline]
____sys_sendmsg+0xa24/0xe40 net/socket.c:2501
___sys_sendmsg+0x2a1/0x3f0 net/socket.c:2555
__sys_sendmmsg+0x411/0xa50 net/socket.c:2641
__do_sys_sendmmsg net/socket.c:2670 [inline]
__se_sys_sendmmsg net/socket.c:2667 [inline]
__x64_sys_sendmmsg+0xbc/0x120 net/socket.c:2667
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

Uninit was created at:
slab_post_alloc_hook+0x12d/0xb60 mm/slab.h:774
slab_alloc_node mm/slub.c:3452 [inline]
kmem_cache_alloc_node+0x543/0xab0 mm/slub.c:3497
kmalloc_reserve+0x148/0x470 net/core/skbuff.c:520
__alloc_skb+0x3a7/0x850 net/core/skbuff.c:606
alloc_skb include/linux/skbuff.h:1277 [inline]
sock_wmalloc+0xfe/0x1a0 net/core/sock.c:2583
pppoe_sendmsg+0x3af/0xb80 drivers/net/ppp/pppoe.c:867
sock_sendmsg_nosec net/socket.c:724 [inline]
sock_sendmsg net/socket.c:747 [inline]
____sys_sendmsg+0xa24/0xe40 net/socket.c:2501
___sys_sendmsg+0x2a1/0x3f0 net/socket.c:2555
__sys_sendmmsg+0x411/0xa50 net/socket.c:2641
__do_sys_sendmmsg net/socket.c:2670 [inline]
__se_sys_sendmmsg net/socket.c:2667 [inline]
__x64_sys_sendmmsg+0xbc/0x120 net/socket.c:2667
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

CPU: 0 PID: 29770 Comm: syz-executor.0 Not tainted 6.3.0-rc6-syzkaller-gc478e5b17829 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/30/2023

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/8021q/vlan_dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 929f85c6cf112..8edac9307868a 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -108,8 +108,8 @@ static netdev_tx_t vlan_dev_hard_start_xmit(struct sk_buff *skb,
 	 * NOTE: THIS ASSUMES DIX ETHERNET, SPECIFICALLY NOT SUPPORTING
 	 * OTHER THINGS LIKE FDDI/TokenRing/802.3 SNAPs...
 	 */
-	if (veth->h_vlan_proto != vlan->vlan_proto ||
-	    vlan->flags & VLAN_FLAG_REORDER_HDR) {
+	if (vlan->flags & VLAN_FLAG_REORDER_HDR ||
+	    veth->h_vlan_proto != vlan->vlan_proto) {
 		u16 vlan_tci;
 		vlan_tci = vlan->vlan_id;
 		vlan_tci |= vlan_dev_get_egress_qos_mask(dev, skb->priority);
-- 
2.39.2



