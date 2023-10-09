Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2FC1A5A4
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ocy1jq+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241CFC433C9;
	Mon,  9 Oct 2023 13:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857833;
	bh=EJ1JiyABQV/TcWqBSemQ7ptie1+stlnSqP0Wvny97rQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ocy1jq+w+tzLn/D/fj8BBGMV1Qifa/rLYXk6rgRGDTNzUZ8Kbg7ufeSQ/9IOX2KK5
	 oywb11BYCgiqWxkaaSSvc+yPOIt2vUvrqExFptFV5Ua8bFZ7Vqpued14L46W49Oio5
	 ex9VtWjwoVy4NzimwdxffZ4nlAL2VpGowoVnARMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 159/162] vrf: Fix lockdep splat in output path
Date: Mon,  9 Oct 2023 15:02:20 +0200
Message-ID: <20231009130127.311150880@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

commit 2033ab90380d46e0e9f0520fd6776a73d107fd95 upstream.

Cited commit converted the neighbour code to use the standard RCU
variant instead of the RCU-bh variant, but the VRF code still uses
rcu_read_lock_bh() / rcu_read_unlock_bh() around the neighbour lookup
code in its IPv4 and IPv6 output paths, resulting in lockdep splats
[1][2]. Can be reproduced using [3].

Fix by switching to rcu_read_lock() / rcu_read_unlock().

[1]
=============================
WARNING: suspicious RCU usage
6.5.0-rc1-custom-g9c099e6dbf98 #403 Not tainted
-----------------------------
include/net/neighbour.h:302 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
2 locks held by ping/183:
 #0: ffff888105ea1d80 (sk_lock-AF_INET){+.+.}-{0:0}, at: raw_sendmsg+0xc6c/0x33c0
 #1: ffffffff85b46820 (rcu_read_lock_bh){....}-{1:2}, at: vrf_output+0x2e3/0x2030

stack backtrace:
CPU: 0 PID: 183 Comm: ping Not tainted 6.5.0-rc1-custom-g9c099e6dbf98 #403
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-1.fc37 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xc1/0xf0
 lockdep_rcu_suspicious+0x211/0x3b0
 vrf_output+0x1380/0x2030
 ip_push_pending_frames+0x125/0x2a0
 raw_sendmsg+0x200d/0x33c0
 inet_sendmsg+0xa2/0xe0
 __sys_sendto+0x2aa/0x420
 __x64_sys_sendto+0xe5/0x1c0
 do_syscall_64+0x38/0x80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

[2]
=============================
WARNING: suspicious RCU usage
6.5.0-rc1-custom-g9c099e6dbf98 #403 Not tainted
-----------------------------
include/net/neighbour.h:302 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
2 locks held by ping6/182:
 #0: ffff888114b63000 (sk_lock-AF_INET6){+.+.}-{0:0}, at: rawv6_sendmsg+0x1602/0x3e50
 #1: ffffffff85b46820 (rcu_read_lock_bh){....}-{1:2}, at: vrf_output6+0xe9/0x1310

stack backtrace:
CPU: 0 PID: 182 Comm: ping6 Not tainted 6.5.0-rc1-custom-g9c099e6dbf98 #403
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-1.fc37 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xc1/0xf0
 lockdep_rcu_suspicious+0x211/0x3b0
 vrf_output6+0xd32/0x1310
 ip6_local_out+0xb4/0x1a0
 ip6_send_skb+0xbc/0x340
 ip6_push_pending_frames+0xe5/0x110
 rawv6_sendmsg+0x2e6e/0x3e50
 inet_sendmsg+0xa2/0xe0
 __sys_sendto+0x2aa/0x420
 __x64_sys_sendto+0xe5/0x1c0
 do_syscall_64+0x38/0x80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

[3]
#!/bin/bash

ip link add name vrf-red up numtxqueues 2 type vrf table 10
ip link add name swp1 up master vrf-red type dummy
ip address add 192.0.2.1/24 dev swp1
ip address add 2001:db8:1::1/64 dev swp1
ip neigh add 192.0.2.2 lladdr 00:11:22:33:44:55 nud perm dev swp1
ip neigh add 2001:db8:1::2 lladdr 00:11:22:33:44:55 nud perm dev swp1
ip vrf exec vrf-red ping 192.0.2.2 -c 1 &> /dev/null
ip vrf exec vrf-red ping6 2001:db8:1::2 -c 1 &> /dev/null

Fixes: 09eed1192cec ("neighbour: switch to standard rcu, instead of rcu_bh")
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Link: https://lore.kernel.org/netdev/CA+G9fYtEr-=GbcXNDYo3XOkwR+uYgehVoDjsP0pFLUpZ_AZcyg@mail.gmail.com/
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230715153605.4068066-1-idosch@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vrf.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -664,7 +664,7 @@ static int vrf_finish_output6(struct net
 	skb->protocol = htons(ETH_P_IPV6);
 	skb->dev = dev;
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 	nexthop = rt6_nexthop((struct rt6_info *)dst, &ipv6_hdr(skb)->daddr);
 	neigh = __ipv6_neigh_lookup_noref(dst->dev, nexthop);
 	if (unlikely(!neigh))
@@ -672,10 +672,10 @@ static int vrf_finish_output6(struct net
 	if (!IS_ERR(neigh)) {
 		sock_confirm_neigh(skb, neigh);
 		ret = neigh_output(neigh, skb, false);
-		rcu_read_unlock_bh();
+		rcu_read_unlock();
 		return ret;
 	}
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 
 	IP6_INC_STATS(dev_net(dst->dev),
 		      ip6_dst_idev(dst), IPSTATS_MIB_OUTNOROUTES);
@@ -889,7 +889,7 @@ static int vrf_finish_output(struct net
 		}
 	}
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 
 	neigh = ip_neigh_for_gw(rt, skb, &is_v6gw);
 	if (!IS_ERR(neigh)) {
@@ -898,11 +898,11 @@ static int vrf_finish_output(struct net
 		sock_confirm_neigh(skb, neigh);
 		/* if crossing protocols, can not use the cached header */
 		ret = neigh_output(neigh, skb, is_v6gw);
-		rcu_read_unlock_bh();
+		rcu_read_unlock();
 		return ret;
 	}
 
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 	vrf_tx_error(skb->dev, skb);
 	return -EINVAL;
 }


