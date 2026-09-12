Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A558E3A873A;
	Sat, 12 Sep 2026 20:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243472; cv=none; b=K2WB4fr7qrl0H6v4SdrtUQ47a10T+MnP+sRENAG4bvFWrb+2eNpCIEIGgA6DpigXE9UGNahex/HfqJ8cl1Q/98lfNwWnYJcMoRmo8peOeijnuq9BS/skMS4PVJx0SHqyLU2Vl2nAvExN5NdWJW4dfHgzW1T+wxv9O3P3BSyVhpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243472; c=relaxed/simple;
	bh=d0YG9i9ByLLvVfcnA2yX6x+aH4TlxXpb70bRc9q7++s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zw5EbmnmZY6PU50w/FC02gl9jvariXf7TNlOVHKcsDZrtXbrx6zHhjVYIMhTUea6w48Zl0GYyvU1JG6h29UJk8kz8qIDmXaRrMhOd9NatnxAOneI/HU3743dwqdCSfTr+GBEGwhJF59UZYfuTJM6Uhz593oVhrUAObh/6P0Adiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LuUPuBYx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LuUPuBYx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025451F000FF;
	Sat, 12 Sep 2026 20:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243470;
	bh=08Le6glAZ1iVPCUmiLS7K1Td/LEyH7xuIFGIxW2bDLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LuUPuBYx2SN4JZ9wfzeV0REkWpxKgAORFTOK560Epq2vAOo9kztbyB8dAj4PzdogW
	 3SJzXs/2kY1pLYbLK45dRTR+LProWvO1Ys9RR0rC780yic6BS/t6FooCtsGEHwFCtr
	 orO8CdHGNFfhJOo+zewf0ItmIXMu5kUNKOo0xvtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 766/798] net/sched: sch_teql: restore skb->dev on the slave failure path
Date: Sat, 12 Sep 2026 09:06:34 +0200
Message-ID: <20260912065534.625365117@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit dc4b95b8fee95113587e93ca116356032d271371 ]

teql_master_xmit() sets skb->dev = slave before calling the slave's
ndo_start_xmit(), but never restores it when that transmit fails. The
skb then walks on to the next slave still pointing at the previous one.

If a later slave has no resolved neighbour, teql_resolve() hands the skb
to neigh_event_send(), which queues it on that neighbour's arp_queue
with the stale skb->dev. skb->dev holds no reference, so deleting the
previous slave frees the net_device while the skb is still queued.
Whatever runs next on that skb - arp_error_report() on timeout, or
neigh_direct_output() -> dev_queue_xmit() once the neighbour resolves -
causes a UAF like the one below:

BUG: KASAN: slab-use-after-free in __icmp_send (net/ipv4/icmp.c:914 (discriminator 2))
Read of size 4 at addr ffff888106e100b0 by task flood_packet/527
CPU: 0 UID: 0 PID: 527 Comm: flood_packet Not tainted 7.2.0-rc6-g594d90519502 #1 PREEMPT(lazy)
Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
<IRQ>
dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:120)
print_report (mm/kasan/report.c:378 mm/kasan/report.c:482)
? __pfx__raw_spin_lock_irqsave (./include/asm-generic/qrwlock.h:122 (discriminator 4))
? __icmp_send (net/ipv4/icmp.c:914 (discriminator 2))
kasan_report (mm/kasan/report.c:595)
? __icmp_send (net/ipv4/icmp.c:914 (discriminator 2))
__icmp_send (net/ipv4/icmp.c:914 (discriminator 2))
[...]
ipv4_link_failure (net/ipv4/route.c:1251 net/ipv4/route.c:1258)
? __pfx_ipv4_link_failure (./include/linux/skbuff.h:4327)
? _raw_write_lock (./include/linux/instrumented.h:55 ./include/linux/atomic/atomic-instrumented.h:1301 ./include/asm-generic/qrwlock.h:98 ./include/linux/rwlock_api_smp.h:230 kernel/locking/spinlock.c:304)
? __pfx__raw_write_lock (kernel/locking/spinlock.c:175)
arp_error_report (./include/net/dst.h:438 net/ipv4/arp.c:296)
neigh_invalidate (net/core/neighbour.c:1077)
neigh_timer_handler (net/core/neighbour.c:1169)
[...]
Allocated by task 505:
kasan_save_stack (mm/kasan/common.c:57)
kasan_save_track (mm/kasan/common.c:78)
__kasan_kmalloc (mm/kasan/common.c:398 mm/kasan/common.c:415)
__kvmalloc_node_noprof (./include/linux/kasan.h:263 mm/slub.c:5334 mm/slub.c:6905)
alloc_netdev_mqs (net/core/dev.c:12055 (discriminator 2))
rtnl_create_link (net/core/rtnetlink.c:3721)
rtnl_newlink (net/core/rtnetlink.c:3903 net/core/rtnetlink.c:4044 net/core/rtnetlink.c:4159)
rtnetlink_rcv_msg (net/core/rtnetlink.c:7076)
[...]
Freed by task 536:
kasan_save_stack (mm/kasan/common.c:57)
kasan_save_track (mm/kasan/common.c:78)
kasan_save_free_info (mm/kasan/generic.c:584)
__kasan_slab_free (mm/kasan/common.c:253 mm/kasan/common.c:285)
kfree (./include/linux/kasan.h:235 mm/slub.c:2677 mm/slub.c:6377 mm/slub.c:6692)
device_release (drivers/base/core.c:2636)
kobject_put (lib/kobject.c:689 lib/kobject.c:720 ./include/linux/kref.h:65 lib/kobject.c:737)
netdev_run_todo (net/core/dev.c:11756)
rtnl_dellink (net/core/rtnetlink.c:157 ./include/linux/rtnetlink.h:135 net/core/rtnetlink.c:3651)
rtnetlink_rcv_msg (net/core/rtnetlink.c:7076)
[...]

Fix this by restoring skb->dev to the master at the end of each slave's
iteration.

Fixes: 0cc0c2e661af ("net/sched: teql: fix NULL pointer dereference in iptunnel_xmit on TEQL slave xmit")
Reported-by: Vega <vega@nebusec.ai>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Link: https://patch.msgid.link/20260824115928.4099988-1-victor@mojatatu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_teql.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/sch_teql.c b/net/sched/sch_teql.c
index 4c65b4ed5ccd3..e78a849fb1b0b 100644
--- a/net/sched/sch_teql.c
+++ b/net/sched/sch_teql.c
@@ -338,6 +338,7 @@ static netdev_tx_t teql_master_xmit(struct sk_buff *skb, struct net_device *dev)
 			nores = 1;
 			break;
 		}
+		skb->dev = dev;
 		__skb_pull(skb, skb_network_offset(skb));
 	} while ((q = NEXT_SLAVE(q)) != start);
 
-- 
2.53.0



