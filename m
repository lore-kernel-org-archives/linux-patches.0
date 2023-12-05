Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55216FB1;
	Tue,  5 Dec 2023 03:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YXBtpFOe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB81C433C8;
	Tue,  5 Dec 2023 03:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747099;
	bh=RN86tXMwnnDPvoxr1eZkh7D85gy0FNw89XPRWLPRE88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YXBtpFOeN6KmtCGboLN0g4JmNlImbMlz1eUr+aiFkBqwBpCnLBQM5uCj2jjdlwE81
	 Mct6nA893YMvy15IEXLwjchuSFFoEvKcvJ1d8Ydz/6BRxDK2MmvxLEdfRbdqiDLuEF
	 BrpZtdO4SCt6xq6wKxMO/nTbrQaQxfdGgAYKBtNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Eric Dumazet <edumazet@google.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 058/107] ipv4: igmp: fix refcnt uaf issue when receiving igmp query packet
Date: Tue,  5 Dec 2023 12:16:33 +0900
Message-ID: <20231205031535.037667703@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
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

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit e2b706c691905fe78468c361aaabc719d0a496f1 ]

When I perform the following test operations:
1.ip link add br0 type bridge
2.brctl addif br0 eth0
3.ip addr add 239.0.0.1/32 dev eth0
4.ip addr add 239.0.0.1/32 dev br0
5.ip addr add 224.0.0.1/32 dev br0
6.while ((1))
    do
        ifconfig br0 up
        ifconfig br0 down
    done
7.send IGMPv2 query packets to port eth0 continuously. For example,
./mausezahn ethX -c 0 "01 00 5e 00 00 01 00 72 19 88 aa 02 08 00 45 00 00
1c 00 01 00 00 01 02 0e 7f c0 a8 0a b7 e0 00 00 01 11 64 ee 9b 00 00 00 00"

The preceding tests may trigger the refcnt uaf issue of the mc list. The
stack is as follows:
	refcount_t: addition on 0; use-after-free.
	WARNING: CPU: 21 PID: 144 at lib/refcount.c:25 refcount_warn_saturate (lib/refcount.c:25)
	CPU: 21 PID: 144 Comm: ksoftirqd/21 Kdump: loaded Not tainted 6.7.0-rc1-next-20231117-dirty #80
	Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
	RIP: 0010:refcount_warn_saturate (lib/refcount.c:25)
	RSP: 0018:ffffb68f00657910 EFLAGS: 00010286
	RAX: 0000000000000000 RBX: ffff8a00c3bf96c0 RCX: ffff8a07b6160908
	RDX: 00000000ffffffd8 RSI: 0000000000000027 RDI: ffff8a07b6160900
	RBP: ffff8a00cba36862 R08: 0000000000000000 R09: 00000000ffff7fff
	R10: ffffb68f006577c0 R11: ffffffffb0fdcdc8 R12: ffff8a00c3bf9680
	R13: ffff8a00c3bf96f0 R14: 0000000000000000 R15: ffff8a00d8766e00
	FS:  0000000000000000(0000) GS:ffff8a07b6140000(0000) knlGS:0000000000000000
	CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
	CR2: 000055f10b520b28 CR3: 000000039741a000 CR4: 00000000000006f0
	Call Trace:
	<TASK>
	igmp_heard_query (net/ipv4/igmp.c:1068)
	igmp_rcv (net/ipv4/igmp.c:1132)
	ip_protocol_deliver_rcu (net/ipv4/ip_input.c:205)
	ip_local_deliver_finish (net/ipv4/ip_input.c:234)
	__netif_receive_skb_one_core (net/core/dev.c:5529)
	netif_receive_skb_internal (net/core/dev.c:5729)
	netif_receive_skb (net/core/dev.c:5788)
	br_handle_frame_finish (net/bridge/br_input.c:216)
	nf_hook_bridge_pre (net/bridge/br_input.c:294)
	__netif_receive_skb_core (net/core/dev.c:5423)
	__netif_receive_skb_list_core (net/core/dev.c:5606)
	__netif_receive_skb_list (net/core/dev.c:5674)
	netif_receive_skb_list_internal (net/core/dev.c:5764)
	napi_gro_receive (net/core/gro.c:609)
	e1000_clean_rx_irq (drivers/net/ethernet/intel/e1000/e1000_main.c:4467)
	e1000_clean (drivers/net/ethernet/intel/e1000/e1000_main.c:3805)
	__napi_poll (net/core/dev.c:6533)
	net_rx_action (net/core/dev.c:6735)
	__do_softirq (kernel/softirq.c:554)
	run_ksoftirqd (kernel/softirq.c:913)
	smpboot_thread_fn (kernel/smpboot.c:164)
	kthread (kernel/kthread.c:388)
	ret_from_fork (arch/x86/kernel/process.c:153)
	ret_from_fork_asm (arch/x86/entry/entry_64.S:250)
	</TASK>

The root causes are as follows:
Thread A					Thread B
...						netif_receive_skb
br_dev_stop					...
    br_multicast_leave_snoopers			...
        __ip_mc_dec_group			...
            __igmp_group_dropped		igmp_rcv
                igmp_stop_timer			    igmp_heard_query         //ref = 1
                ip_ma_put			        igmp_mod_timer
                    refcount_dec_and_test	            igmp_start_timer //ref = 0
			...                                     refcount_inc //ref increases from 0
When the device receives an IGMPv2 Query message, it starts the timer
immediately, regardless of whether the device is running. If the device is
down and has left the multicast group, it will cause the mc list refcount
uaf issue.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/igmp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index cbc4816ed7d83..ac53ef7eec915 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -216,8 +216,10 @@ static void igmp_start_timer(struct ip_mc_list *im, int max_delay)
 	int tv = prandom_u32_max(max_delay);
 
 	im->tm_running = 1;
-	if (!mod_timer(&im->timer, jiffies+tv+2))
-		refcount_inc(&im->refcnt);
+	if (refcount_inc_not_zero(&im->refcnt)) {
+		if (mod_timer(&im->timer, jiffies + tv + 2))
+			ip_ma_put(im);
+	}
 }
 
 static void igmp_gq_start_timer(struct in_device *in_dev)
-- 
2.42.0



