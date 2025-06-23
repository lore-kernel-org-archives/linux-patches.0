Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6013D1E87B;
	Mon, 23 Jun 2025 22:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716350; cv=none; b=cze1mMutqGAZlqv0zfdCHvcbw1w8DYS4jIafF6z5Shdnq69Qe/8clzUKU10xe4wCVTkdWoOOR2Qs7LZpBPnmcgLnzU+AKc7X//2gKBTOvQv0bZvf1GMEWY+L0SHzzjpHUld97goGAlX9lDMveml9X8B+ptkLcqQgGq0unlCka00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716350; c=relaxed/simple;
	bh=ogRKshTWkBKACzdoRwjN6nv94+Q/TMVzChVeIi8Tqks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NWW00BsBI6JEuGSmlSPhrNOth5vXl08lSDd8u8Zha256JoQI92FQXFD/89/BbLvuG2UHRdN01rO45K2K+PfCjlaKRKFfm16orBHX7iCBG3hUg9yu7TXhwPgnbdsVnjcyjM8TAmWIdjiZh7hwzh+jMDA/s6gfdhQrCoOtbui1qfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CGEeLY9k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CGEeLY9k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA6CC4CEEA;
	Mon, 23 Jun 2025 22:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716350;
	bh=ogRKshTWkBKACzdoRwjN6nv94+Q/TMVzChVeIi8Tqks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CGEeLY9k9n4KP55caoZ7/7M+lkgEUayu91hVE0ZDdDP+0UMT+RtxLYRgo1W5vg1GB
	 5vsPIkdCVwXjjlRlMNHKeEBVTTHiVTGOc2s8eTUHCqK2jqztavchgAyVFasxRGsuuM
	 QYOMu6LVPsOvsorRXi5kkLUzpfXWKuciFVAk30lQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Octavian Purdila <tavip@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.10 343/355] net_sched: sch_sfq: dont allow 1 packet limit
Date: Mon, 23 Jun 2025 15:09:04 +0200
Message-ID: <20250623130637.035961647@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Octavian Purdila <tavip@google.com>

[ Upstream commit 10685681bafce6febb39770f3387621bf5d67d0b ]

The current implementation does not work correctly with a limit of
1. iproute2 actually checks for this and this patch adds the check in
kernel as well.

This fixes the following syzkaller reported crash:

UBSAN: array-index-out-of-bounds in net/sched/sch_sfq.c:210:6
index 65535 is out of range for type 'struct sfq_head[128]'
CPU: 0 PID: 2569 Comm: syz-executor101 Not tainted 5.10.0-smp-DEV #1
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
  __dump_stack lib/dump_stack.c:79 [inline]
  dump_stack+0x125/0x19f lib/dump_stack.c:120
  ubsan_epilogue lib/ubsan.c:148 [inline]
  __ubsan_handle_out_of_bounds+0xed/0x120 lib/ubsan.c:347
  sfq_link net/sched/sch_sfq.c:210 [inline]
  sfq_dec+0x528/0x600 net/sched/sch_sfq.c:238
  sfq_dequeue+0x39b/0x9d0 net/sched/sch_sfq.c:500
  sfq_reset+0x13/0x50 net/sched/sch_sfq.c:525
  qdisc_reset+0xfe/0x510 net/sched/sch_generic.c:1026
  tbf_reset+0x3d/0x100 net/sched/sch_tbf.c:319
  qdisc_reset+0xfe/0x510 net/sched/sch_generic.c:1026
  dev_reset_queue+0x8c/0x140 net/sched/sch_generic.c:1296
  netdev_for_each_tx_queue include/linux/netdevice.h:2350 [inline]
  dev_deactivate_many+0x6dc/0xc20 net/sched/sch_generic.c:1362
  __dev_close_many+0x214/0x350 net/core/dev.c:1468
  dev_close_many+0x207/0x510 net/core/dev.c:1506
  unregister_netdevice_many+0x40f/0x16b0 net/core/dev.c:10738
  unregister_netdevice_queue+0x2be/0x310 net/core/dev.c:10695
  unregister_netdevice include/linux/netdevice.h:2893 [inline]
  __tun_detach+0x6b6/0x1600 drivers/net/tun.c:689
  tun_detach drivers/net/tun.c:705 [inline]
  tun_chr_close+0x104/0x1b0 drivers/net/tun.c:3640
  __fput+0x203/0x840 fs/file_table.c:280
  task_work_run+0x129/0x1b0 kernel/task_work.c:185
  exit_task_work include/linux/task_work.h:33 [inline]
  do_exit+0x5ce/0x2200 kernel/exit.c:931
  do_group_exit+0x144/0x310 kernel/exit.c:1046
  __do_sys_exit_group kernel/exit.c:1057 [inline]
  __se_sys_exit_group kernel/exit.c:1055 [inline]
  __x64_sys_exit_group+0x3b/0x40 kernel/exit.c:1055
 do_syscall_64+0x6c/0xd0
 entry_SYSCALL_64_after_hwframe+0x61/0xcb
RIP: 0033:0x7fe5e7b52479
Code: Unable to access opcode bytes at RIP 0x7fe5e7b5244f.
RSP: 002b:00007ffd3c800398 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fe5e7b52479
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 00007fe5e7bcd2d0 R08: ffffffffffffffb8 R09: 0000000000000014
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fe5e7bcd2d0
R13: 0000000000000000 R14: 00007fe5e7bcdd20 R15: 00007fe5e7b24270

The crash can be also be reproduced with the following (with a tc
recompiled to allow for sfq limits of 1):

tc qdisc add dev dummy0 handle 1: root tbf rate 1Kbit burst 100b lat 1s
../iproute2-6.9.0/tc/tc qdisc add dev dummy0 handle 2: parent 1:10 sfq limit 1
ifconfig dummy0 up
ping -I dummy0 -f -c2 -W0.1 8.8.8.8
sleep 1

Scenario that triggers the crash:

* the first packet is sent and queued in TBF and SFQ; qdisc qlen is 1

* TBF dequeues: it peeks from SFQ which moves the packet to the
  gso_skb list and keeps qdisc qlen set to 1. TBF is out of tokens so
  it schedules itself for later.

* the second packet is sent and TBF tries to queues it to SFQ. qdisc
  qlen is now 2 and because the SFQ limit is 1 the packet is dropped
  by SFQ. At this point qlen is 1, and all of the SFQ slots are empty,
  however q->tail is not NULL.

At this point, assuming no more packets are queued, when sch_dequeue
runs again it will decrement the qlen for the current empty slot
causing an underflow and the subsequent out of bounds access.

Reported-by: syzbot <syzkaller@googlegroups.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Octavian Purdila <tavip@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20241204030520.2084663-2-tavip@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_sfq.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -652,6 +652,10 @@ static int sfq_change(struct Qdisc *sch,
 		if (!p)
 			return -ENOMEM;
 	}
+	if (ctl->limit == 1) {
+		NL_SET_ERR_MSG_MOD(extack, "invalid limit");
+		return -EINVAL;
+	}
 	sch_tree_lock(sch);
 	if (ctl->quantum)
 		q->quantum = ctl->quantum;


