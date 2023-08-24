Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E27711C86
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:56:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748FCC433C7;
	Thu, 24 Aug 2023 14:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692888981;
	bh=XcSxGhvERilvIBLVpQUTgWuApB8+phg2hbB3aO1qS7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o8J8b9MFH+ttNT00mxe6JuXT/huXf7ERZIUMZvEzklZS9ZKqwsnbVMEBxW8s6U6wm
	 Uq7GwNEL9SL/TMmI988jsFJPMmc9zyEBP7W+k49Uebezn5NphRiDW7gwl/qoV7TvVZ
	 q0KolUzya8AbsbRWx1A4o7WLChfnErzrMR3Za0VI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 083/139] ip6_vti: fix slab-use-after-free in decode_session6
Date: Thu, 24 Aug 2023 16:50:06 +0200
Message-ID: <20230824145027.249124210@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145023.559380953@linuxfoundation.org>
References: <20230824145023.559380953@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 9fd41f1ba638938c9a1195d09bc6fa3be2712f25 ]

When ipv6_vti device is set to the qdisc of the sfb type, the cb field
of the sent skb may be modified during enqueuing. Then,
slab-use-after-free may occur when ipv6_vti device sends IPv6 packets.

The stack information is as follows:
BUG: KASAN: slab-use-after-free in decode_session6+0x103f/0x1890
Read of size 1 at addr ffff88802e08edc2 by task swapper/0/0
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.4.0-next-20230707-00001-g84e2cad7f979 #410
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-1.fc33 04/01/2014
Call Trace:
<IRQ>
dump_stack_lvl+0xd9/0x150
print_address_description.constprop.0+0x2c/0x3c0
kasan_report+0x11d/0x130
decode_session6+0x103f/0x1890
__xfrm_decode_session+0x54/0xb0
vti6_tnl_xmit+0x3e6/0x1ee0
dev_hard_start_xmit+0x187/0x700
sch_direct_xmit+0x1a3/0xc30
__qdisc_run+0x510/0x17a0
__dev_queue_xmit+0x2215/0x3b10
neigh_connected_output+0x3c2/0x550
ip6_finish_output2+0x55a/0x1550
ip6_finish_output+0x6b9/0x1270
ip6_output+0x1f1/0x540
ndisc_send_skb+0xa63/0x1890
ndisc_send_rs+0x132/0x6f0
addrconf_rs_timer+0x3f1/0x870
call_timer_fn+0x1a0/0x580
expire_timers+0x29b/0x4b0
run_timer_softirq+0x326/0x910
__do_softirq+0x1d4/0x905
irq_exit_rcu+0xb7/0x120
sysvec_apic_timer_interrupt+0x97/0xc0
</IRQ>
Allocated by task 9176:
kasan_save_stack+0x22/0x40
kasan_set_track+0x25/0x30
__kasan_slab_alloc+0x7f/0x90
kmem_cache_alloc_node+0x1cd/0x410
kmalloc_reserve+0x165/0x270
__alloc_skb+0x129/0x330
netlink_sendmsg+0x9b1/0xe30
sock_sendmsg+0xde/0x190
____sys_sendmsg+0x739/0x920
___sys_sendmsg+0x110/0x1b0
__sys_sendmsg+0xf7/0x1c0
do_syscall_64+0x39/0xb0
entry_SYSCALL_64_after_hwframe+0x63/0xcd
Freed by task 9176:
kasan_save_stack+0x22/0x40
kasan_set_track+0x25/0x30
kasan_save_free_info+0x2b/0x40
____kasan_slab_free+0x160/0x1c0
slab_free_freelist_hook+0x11b/0x220
kmem_cache_free+0xf0/0x490
skb_free_head+0x17f/0x1b0
skb_release_data+0x59c/0x850
consume_skb+0xd2/0x170
netlink_unicast+0x54f/0x7f0
netlink_sendmsg+0x926/0xe30
sock_sendmsg+0xde/0x190
____sys_sendmsg+0x739/0x920
___sys_sendmsg+0x110/0x1b0
__sys_sendmsg+0xf7/0x1c0
do_syscall_64+0x39/0xb0
entry_SYSCALL_64_after_hwframe+0x63/0xcd
The buggy address belongs to the object at ffff88802e08ed00
which belongs to the cache skbuff_small_head of size 640
The buggy address is located 194 bytes inside of
freed 640-byte region [ffff88802e08ed00, ffff88802e08ef80)

As commit f855691975bb ("xfrm6: Fix the nexthdr offset in
_decode_session6.") showed, xfrm_decode_session was originally intended
only for the receive path. IP6CB(skb)->nhoff is not set during
transmission. Therefore, set the cb field in the skb to 0 before
sending packets.

Fixes: f855691975bb ("xfrm6: Fix the nexthdr offset in _decode_session6.")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_vti.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 42c37ec832f15..190aa3b19591c 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -570,12 +570,12 @@ vti6_tnl_xmit(struct sk_buff *skb, struct net_device *dev)
 		    vti6_addr_conflict(t, ipv6_hdr(skb)))
 			goto tx_err;
 
-		xfrm_decode_session(skb, &fl, AF_INET6);
 		memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
+		xfrm_decode_session(skb, &fl, AF_INET6);
 		break;
 	case htons(ETH_P_IP):
-		xfrm_decode_session(skb, &fl, AF_INET);
 		memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
+		xfrm_decode_session(skb, &fl, AF_INET);
 		break;
 	default:
 		goto tx_err;
-- 
2.40.1



