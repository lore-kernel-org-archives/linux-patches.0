Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8521E98E8;
	Thu, 30 Jan 2025 14:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247172; cv=none; b=GqOEn44H1eC7ErEb4ioaVqhlYnLO5S+4FDZwz0hlk+rsw8xcE6aQsNL8C2W6IKz+CsGhhRqjHqbpZziNPN+zKvq/s5Tobrvfu/w52eAd3ZGSdGGzOiHs+6TfzY0VYRmArpSUtn+mG5RFa7tZdwUNp42TfQ6rCeP9GvXM0vXbQLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247172; c=relaxed/simple;
	bh=jI1gwmQaRiEx/21LafF//9rNKegc05plLZJCHURCM6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p0PQFQXRlR1Lsi8mvIKgU0Wts7hVqi3aJ4cUm812Yuo8WnFCrH5rflPDNm9qIOuXgaIrlhSmYH1AlbMS3st1y0YZ4G6W2Wj1v5qj/ZuqUrO8KOWKNH81GSu6prjP22Ib0bDlinM4ozmbg2yDkT6TL9IaGl5A+bNWiSRww35HKiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MuLKO8eq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MuLKO8eq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC5BC4CED2;
	Thu, 30 Jan 2025 14:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247171;
	bh=jI1gwmQaRiEx/21LafF//9rNKegc05plLZJCHURCM6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MuLKO8eq2sz9FHcl/RBLukwRzdeP9L1b1ySmdkHf0RdYBjEwS/Z3T16Vn9QQtFy9J
	 3KHK5MtHlZ70zkrGZwk7td++41uflZYsipxhCZMb4O8LD3oHmrp57bB/9wVsaxj+dp
	 InluyCM0dcl6G4rBEGGbfAg4cMYyQBNGZ/Zn7WcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	BRUNO VERNAY <bruno.vernay@se.com>,
	Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Subject: [PATCH 5.10 107/133] ipv6: avoid possible NULL deref in rt6_uncached_list_flush_dev()
Date: Thu, 30 Jan 2025 15:01:36 +0100
Message-ID: <20250130140146.844544319@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

commit 04ccecfa959d3b9ae7348780d8e379c6486176ac upstream.

Blamed commit accidentally removed a check for rt->rt6i_idev being NULL,
as spotted by syzbot:

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 UID: 0 PID: 10998 Comm: syz-executor Not tainted 6.11.0-rc6-syzkaller-00208-g625403177711 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
 RIP: 0010:rt6_uncached_list_flush_dev net/ipv6/route.c:177 [inline]
 RIP: 0010:rt6_disable_ip+0x33e/0x7e0 net/ipv6/route.c:4914
Code: 41 80 3c 04 00 74 0a e8 90 d0 9b f7 48 8b 7c 24 08 48 8b 07 48 89 44 24 10 4c 89 f0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 4c 89 f7 e8 64 d0 9b f7 48 8b 44 24 18 49 39 06
RSP: 0018:ffffc900047374e0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 1ffff1100fdf8f33 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffff88807efc78c0
RBP: ffffc900047375d0 R08: 0000000000000003 R09: fffff520008e6e8c
R10: dffffc0000000000 R11: fffff520008e6e8c R12: 1ffff1100fdf8f18
R13: ffff88807efc7998 R14: 0000000000000000 R15: ffff88807efc7930
FS:  0000000000000000(0000) GS:ffff8880b8900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020002a80 CR3: 0000000022f62000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
  addrconf_ifdown+0x15d/0x1bd0 net/ipv6/addrconf.c:3856
 addrconf_notify+0x3cb/0x1020
  notifier_call_chain+0x19f/0x3e0 kernel/notifier.c:93
  call_netdevice_notifiers_extack net/core/dev.c:2032 [inline]
  call_netdevice_notifiers net/core/dev.c:2046 [inline]
  unregister_netdevice_many_notify+0xd81/0x1c40 net/core/dev.c:11352
  unregister_netdevice_many net/core/dev.c:11414 [inline]
  unregister_netdevice_queue+0x303/0x370 net/core/dev.c:11289
  unregister_netdevice include/linux/netdevice.h:3129 [inline]
  __tun_detach+0x6b9/0x1600 drivers/net/tun.c:685
  tun_detach drivers/net/tun.c:701 [inline]
  tun_chr_close+0x108/0x1b0 drivers/net/tun.c:3510
  __fput+0x24a/0x8a0 fs/file_table.c:422
  task_work_run+0x24f/0x310 kernel/task_work.c:228
  exit_task_work include/linux/task_work.h:40 [inline]
  do_exit+0xa2f/0x27f0 kernel/exit.c:882
  do_group_exit+0x207/0x2c0 kernel/exit.c:1031
  __do_sys_exit_group kernel/exit.c:1042 [inline]
  __se_sys_exit_group kernel/exit.c:1040 [inline]
  __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1040
  x64_sys_call+0x2634/0x2640 arch/x86/include/generated/asm/syscalls_64.h:232
  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1acc77def9
Code: Unable to access opcode bytes at 0x7f1acc77decf.
RSP: 002b:00007ffeb26fa738 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f1acc77def9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000043
RBP: 00007f1acc7dd508 R08: 00007ffeb26f84d7 R09: 0000000000000003
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 0000000000000003 R14: 00000000ffffffff R15: 00007ffeb26fa8e0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
 RIP: 0010:rt6_uncached_list_flush_dev net/ipv6/route.c:177 [inline]
 RIP: 0010:rt6_disable_ip+0x33e/0x7e0 net/ipv6/route.c:4914
Code: 41 80 3c 04 00 74 0a e8 90 d0 9b f7 48 8b 7c 24 08 48 8b 07 48 89 44 24 10 4c 89 f0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 4c 89 f7 e8 64 d0 9b f7 48 8b 44 24 18 49 39 06
RSP: 0018:ffffc900047374e0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 1ffff1100fdf8f33 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffff88807efc78c0
RBP: ffffc900047375d0 R08: 0000000000000003 R09: fffff520008e6e8c
R10: dffffc0000000000 R11: fffff520008e6e8c R12: 1ffff1100fdf8f18
R13: ffff88807efc7998 R14: 0000000000000000 R15: ffff88807efc7930
FS:  0000000000000000(0000) GS:ffff8880b8900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020002a80 CR3: 0000000022f62000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

Fixes: e332bc67cf5e ("ipv6: Don't call with rt6_uncached_list_flush_dev")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://patch.msgid.link/20240913083147.3095442-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: BRUNO VERNAY <bruno.vernay@se.com>
Signed-off-by: Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -174,7 +174,7 @@ static void rt6_uncached_list_flush_dev(
 			struct inet6_dev *rt_idev = rt->rt6i_idev;
 			struct net_device *rt_dev = rt->dst.dev;
 
-			if (rt_idev->dev == dev) {
+			if (rt_idev && rt_idev->dev == dev) {
 				rt->rt6i_idev = in6_dev_get(loopback_dev);
 				in6_dev_put(rt_idev);
 			}


