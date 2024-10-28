Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1745618E35B;
	Mon, 28 Oct 2024 06:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097804; cv=none; b=d3BuigQgv1YL26EZiMFP7xEYnlOCDW0ttrIll/NHaMLGnGSfGZTIB2WpjcOqBdPDi1j5AGVm/JcshGCjxyNymJHOoAlmh/Ko2GD7F47z64mMsAOzG7+smQJfX6ovPVu/7XNX/NMfmzIySLn5Dd4K+C1lW+Ksxh7M7UoCddkJIHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097804; c=relaxed/simple;
	bh=PadF3/ElQJRllbNFh4Z/TSRYj9GJZ9LqVEzAuiFCRAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8BqdP0kp8RLCeCq7L0DBG++bgC2p7g3P+MTEnsdPtSnxlSf5asrtzrfcDMvt7kNJGxxO2esPsvHI0lW5HSJDLD/OSP9AzTZJu3DyOgYMSaOhMpbRyV9PXbPnHfNXzOZaldVTLbrXFUBE43KthmAjFbcwTFJvUzaA/LUaTpTkTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r66SDCmt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r66SDCmt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABEC0C4CEC3;
	Mon, 28 Oct 2024 06:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097804;
	bh=PadF3/ElQJRllbNFh4Z/TSRYj9GJZ9LqVEzAuiFCRAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r66SDCmtWPU/tFUiYGjI2FZ2d/Nrz6WEUeupJptM2cJvvhVV7rCDeMK0HVi4B4Gc7
	 2iLuROHm5AyZhrjeV34q8jkLtUCO1MD14fSp9WpD9QnGhWJzvreGI7Y5fB8JB3Bx1x
	 P5QgAyI96DVHkNQjtsHVG8S0Bv6KyDNejvCkvCIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 155/208] net: sched: use RCU read-side critical section in taprio_dump()
Date: Mon, 28 Oct 2024 07:25:35 +0100
Message-ID: <20241028062310.443836186@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit b22db8b8befe90b61c98626ca1a2fbb0505e9fe3 ]

Fix possible use-after-free in 'taprio_dump()' by adding RCU
read-side critical section there. Never seen on x86 but
found on a KASAN-enabled arm64 system when investigating
https://syzkaller.appspot.com/bug?extid=b65e0af58423fc8a73aa:

[T15862] BUG: KASAN: slab-use-after-free in taprio_dump+0xa0c/0xbb0
[T15862] Read of size 4 at addr ffff0000d4bb88f8 by task repro/15862
[T15862]
[T15862] CPU: 0 UID: 0 PID: 15862 Comm: repro Not tainted 6.11.0-rc1-00293-gdefaf1a2113a-dirty #2
[T15862] Hardware name: QEMU QEMU Virtual Machine, BIOS edk2-20240524-5.fc40 05/24/2024
[T15862] Call trace:
[T15862]  dump_backtrace+0x20c/0x220
[T15862]  show_stack+0x2c/0x40
[T15862]  dump_stack_lvl+0xf8/0x174
[T15862]  print_report+0x170/0x4d8
[T15862]  kasan_report+0xb8/0x1d4
[T15862]  __asan_report_load4_noabort+0x20/0x2c
[T15862]  taprio_dump+0xa0c/0xbb0
[T15862]  tc_fill_qdisc+0x540/0x1020
[T15862]  qdisc_notify.isra.0+0x330/0x3a0
[T15862]  tc_modify_qdisc+0x7b8/0x1838
[T15862]  rtnetlink_rcv_msg+0x3c8/0xc20
[T15862]  netlink_rcv_skb+0x1f8/0x3d4
[T15862]  rtnetlink_rcv+0x28/0x40
[T15862]  netlink_unicast+0x51c/0x790
[T15862]  netlink_sendmsg+0x79c/0xc20
[T15862]  __sock_sendmsg+0xe0/0x1a0
[T15862]  ____sys_sendmsg+0x6c0/0x840
[T15862]  ___sys_sendmsg+0x1ac/0x1f0
[T15862]  __sys_sendmsg+0x110/0x1d0
[T15862]  __arm64_sys_sendmsg+0x74/0xb0
[T15862]  invoke_syscall+0x88/0x2e0
[T15862]  el0_svc_common.constprop.0+0xe4/0x2a0
[T15862]  do_el0_svc+0x44/0x60
[T15862]  el0_svc+0x50/0x184
[T15862]  el0t_64_sync_handler+0x120/0x12c
[T15862]  el0t_64_sync+0x190/0x194
[T15862]
[T15862] Allocated by task 15857:
[T15862]  kasan_save_stack+0x3c/0x70
[T15862]  kasan_save_track+0x20/0x3c
[T15862]  kasan_save_alloc_info+0x40/0x60
[T15862]  __kasan_kmalloc+0xd4/0xe0
[T15862]  __kmalloc_cache_noprof+0x194/0x334
[T15862]  taprio_change+0x45c/0x2fe0
[T15862]  tc_modify_qdisc+0x6a8/0x1838
[T15862]  rtnetlink_rcv_msg+0x3c8/0xc20
[T15862]  netlink_rcv_skb+0x1f8/0x3d4
[T15862]  rtnetlink_rcv+0x28/0x40
[T15862]  netlink_unicast+0x51c/0x790
[T15862]  netlink_sendmsg+0x79c/0xc20
[T15862]  __sock_sendmsg+0xe0/0x1a0
[T15862]  ____sys_sendmsg+0x6c0/0x840
[T15862]  ___sys_sendmsg+0x1ac/0x1f0
[T15862]  __sys_sendmsg+0x110/0x1d0
[T15862]  __arm64_sys_sendmsg+0x74/0xb0
[T15862]  invoke_syscall+0x88/0x2e0
[T15862]  el0_svc_common.constprop.0+0xe4/0x2a0
[T15862]  do_el0_svc+0x44/0x60
[T15862]  el0_svc+0x50/0x184
[T15862]  el0t_64_sync_handler+0x120/0x12c
[T15862]  el0t_64_sync+0x190/0x194
[T15862]
[T15862] Freed by task 6192:
[T15862]  kasan_save_stack+0x3c/0x70
[T15862]  kasan_save_track+0x20/0x3c
[T15862]  kasan_save_free_info+0x4c/0x80
[T15862]  poison_slab_object+0x110/0x160
[T15862]  __kasan_slab_free+0x3c/0x74
[T15862]  kfree+0x134/0x3c0
[T15862]  taprio_free_sched_cb+0x18c/0x220
[T15862]  rcu_core+0x920/0x1b7c
[T15862]  rcu_core_si+0x10/0x1c
[T15862]  handle_softirqs+0x2e8/0xd64
[T15862]  __do_softirq+0x14/0x20

Fixes: 18cdd2f0998a ("net/sched: taprio: taprio_dump and taprio_change are protected by rtnl_mutex")
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Link: https://patch.msgid.link/20241018051339.418890-2-dmantipov@yandex.ru
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_taprio.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index bc8e55c6d63d1..951a87909c297 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -2397,9 +2397,6 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	struct tc_mqprio_qopt opt = { 0 };
 	struct nlattr *nest, *sched_nest;
 
-	oper = rtnl_dereference(q->oper_sched);
-	admin = rtnl_dereference(q->admin_sched);
-
 	mqprio_qopt_reconstruct(dev, &opt);
 
 	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
@@ -2420,18 +2417,23 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	    nla_put_u32(skb, TCA_TAPRIO_ATTR_TXTIME_DELAY, q->txtime_delay))
 		goto options_error;
 
+	rcu_read_lock();
+
+	oper = rtnl_dereference(q->oper_sched);
+	admin = rtnl_dereference(q->admin_sched);
+
 	if (oper && taprio_dump_tc_entries(skb, q, oper))
-		goto options_error;
+		goto options_error_rcu;
 
 	if (oper && dump_schedule(skb, oper))
-		goto options_error;
+		goto options_error_rcu;
 
 	if (!admin)
 		goto done;
 
 	sched_nest = nla_nest_start_noflag(skb, TCA_TAPRIO_ATTR_ADMIN_SCHED);
 	if (!sched_nest)
-		goto options_error;
+		goto options_error_rcu;
 
 	if (dump_schedule(skb, admin))
 		goto admin_error;
@@ -2439,11 +2441,15 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	nla_nest_end(skb, sched_nest);
 
 done:
+	rcu_read_unlock();
 	return nla_nest_end(skb, nest);
 
 admin_error:
 	nla_nest_cancel(skb, sched_nest);
 
+options_error_rcu:
+	rcu_read_unlock();
+
 options_error:
 	nla_nest_cancel(skb, nest);
 
-- 
2.43.0



