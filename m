Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116E21422B8;
	Wed, 19 Jun 2024 13:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802863; cv=none; b=QFd28n3tcXSIveHcvwdKOsgD0XRBOQrRwBxuqonZx2T+Lx4GQbf1mV6WntzMQKeMOnX8mwLmh5YCd1AH/jYW9LYloRC2jXakmcE8ceN8mFv6LpSfeOkkOGGpUGUa0sKy7Dt7LI1nnkwsKr99tV/eXmZPhsvFYvBWnrgU5UjYJ8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802863; c=relaxed/simple;
	bh=lgu4kQ01zmtQXPotEc5nNiXHSMChZauOnWlH287yKQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ss7HdPA2TFUvUP1ceVXQBwLJfHa1oq7m90uszQGG31M+Dy/HUajKVbnHOwQpwqjk79C+ICatbSbylmQM84T4FPX2IpNuyLmFgaNaVsQUlbfhA5NhQ9y5/G/aNJ3qDugwy7O+147as+4G4UAxgyLqV9+AK6+Mlaacu80wylu8PXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=drAePVd/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="drAePVd/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B8FC2BBFC;
	Wed, 19 Jun 2024 13:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802862;
	bh=lgu4kQ01zmtQXPotEc5nNiXHSMChZauOnWlH287yKQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=drAePVd/G8nklDRL3+jR39cb74huqUi87zbqsHvR0xBmmhYa8wiTLFeyfx7MpdvIA
	 6BgnwTT1wxYkcZchhUnbCNt6nGfPVzXuWSSbbuscI19+e5EAxhYp1+adkfXGLJk93U
	 jR/R69wpSrwwENWwntDZOxHRwwh/MrS6pUY4Hj7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Martin KaFai Lau <kafai@fb.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 071/281] ipv6: fix possible race in __fib6_drop_pcpu_from()
Date: Wed, 19 Jun 2024 14:53:50 +0200
Message-ID: <20240619125612.575526016@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b01e1c030770ff3b4fe37fc7cc6bca03f594133f ]

syzbot found a race in __fib6_drop_pcpu_from() [1]

If compiler reads more than once (*ppcpu_rt),
second read could read NULL, if another cpu clears
the value in rt6_get_pcpu_route().

Add a READ_ONCE() to prevent this race.

Also add rcu_read_lock()/rcu_read_unlock() because
we rely on RCU protection while dereferencing pcpu_rt.

[1]

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000012: 0000 [#1] PREEMPT SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000090-0x0000000000000097]
CPU: 0 PID: 7543 Comm: kworker/u8:17 Not tainted 6.10.0-rc1-syzkaller-00013-g2bfcfd584ff5 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
Workqueue: netns cleanup_net
 RIP: 0010:__fib6_drop_pcpu_from.part.0+0x10a/0x370 net/ipv6/ip6_fib.c:984
Code: f8 48 c1 e8 03 80 3c 28 00 0f 85 16 02 00 00 4d 8b 3f 4d 85 ff 74 31 e8 74 a7 fa f7 49 8d bf 90 00 00 00 48 89 f8 48 c1 e8 03 <80> 3c 28 00 0f 85 1e 02 00 00 49 8b 87 90 00 00 00 48 8b 0c 24 48
RSP: 0018:ffffc900040df070 EFLAGS: 00010206
RAX: 0000000000000012 RBX: 0000000000000001 RCX: ffffffff89932e16
RDX: ffff888049dd1e00 RSI: ffffffff89932d7c RDI: 0000000000000091
RBP: dffffc0000000000 R08: 0000000000000005 R09: 0000000000000007
R10: 0000000000000001 R11: 0000000000000006 R12: ffff88807fa080b8
R13: fffffbfff1a9a07d R14: ffffed100ff41022 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8880b9200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b32c26000 CR3: 000000005d56e000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
  __fib6_drop_pcpu_from net/ipv6/ip6_fib.c:966 [inline]
  fib6_drop_pcpu_from net/ipv6/ip6_fib.c:1027 [inline]
  fib6_purge_rt+0x7f2/0x9f0 net/ipv6/ip6_fib.c:1038
  fib6_del_route net/ipv6/ip6_fib.c:1998 [inline]
  fib6_del+0xa70/0x17b0 net/ipv6/ip6_fib.c:2043
  fib6_clean_node+0x426/0x5b0 net/ipv6/ip6_fib.c:2205
  fib6_walk_continue+0x44f/0x8d0 net/ipv6/ip6_fib.c:2127
  fib6_walk+0x182/0x370 net/ipv6/ip6_fib.c:2175
  fib6_clean_tree+0xd7/0x120 net/ipv6/ip6_fib.c:2255
  __fib6_clean_all+0x100/0x2d0 net/ipv6/ip6_fib.c:2271
  rt6_sync_down_dev net/ipv6/route.c:4906 [inline]
  rt6_disable_ip+0x7ed/0xa00 net/ipv6/route.c:4911
  addrconf_ifdown.isra.0+0x117/0x1b40 net/ipv6/addrconf.c:3855
  addrconf_notify+0x223/0x19e0 net/ipv6/addrconf.c:3778
  notifier_call_chain+0xb9/0x410 kernel/notifier.c:93
  call_netdevice_notifiers_info+0xbe/0x140 net/core/dev.c:1992
  call_netdevice_notifiers_extack net/core/dev.c:2030 [inline]
  call_netdevice_notifiers net/core/dev.c:2044 [inline]
  dev_close_many+0x333/0x6a0 net/core/dev.c:1585
  unregister_netdevice_many_notify+0x46d/0x19f0 net/core/dev.c:11193
  unregister_netdevice_many net/core/dev.c:11276 [inline]
  default_device_exit_batch+0x85b/0xae0 net/core/dev.c:11759
  ops_exit_list+0x128/0x180 net/core/net_namespace.c:178
  cleanup_net+0x5b7/0xbf0 net/core/net_namespace.c:640
  process_one_work+0x9fb/0x1b60 kernel/workqueue.c:3231
  process_scheduled_works kernel/workqueue.c:3312 [inline]
  worker_thread+0x6c8/0xf70 kernel/workqueue.c:3393
  kthread+0x2c1/0x3a0 kernel/kthread.c:389
  ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:147
  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Fixes: d52d3997f843 ("ipv6: Create percpu rt6_info")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/r/20240604193549.981839-1-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_fib.c | 6 +++++-
 net/ipv6/route.c   | 1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index c1f62352a4814..1ace4ac3ee04c 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -965,6 +965,7 @@ static void __fib6_drop_pcpu_from(struct fib6_nh *fib6_nh,
 	if (!fib6_nh->rt6i_pcpu)
 		return;
 
+	rcu_read_lock();
 	/* release the reference to this fib entry from
 	 * all of its cached pcpu routes
 	 */
@@ -973,7 +974,9 @@ static void __fib6_drop_pcpu_from(struct fib6_nh *fib6_nh,
 		struct rt6_info *pcpu_rt;
 
 		ppcpu_rt = per_cpu_ptr(fib6_nh->rt6i_pcpu, cpu);
-		pcpu_rt = *ppcpu_rt;
+
+		/* Paired with xchg() in rt6_get_pcpu_route() */
+		pcpu_rt = READ_ONCE(*ppcpu_rt);
 
 		/* only dropping the 'from' reference if the cached route
 		 * is using 'match'. The cached pcpu_rt->from only changes
@@ -987,6 +990,7 @@ static void __fib6_drop_pcpu_from(struct fib6_nh *fib6_nh,
 			fib6_info_release(from);
 		}
 	}
+	rcu_read_unlock();
 }
 
 struct fib6_nh_pcpu_arg {
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index f090e7bcb784f..bca6f33c7bb9e 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1409,6 +1409,7 @@ static struct rt6_info *rt6_get_pcpu_route(const struct fib6_result *res)
 		struct rt6_info *prev, **p;
 
 		p = this_cpu_ptr(res->nh->rt6i_pcpu);
+		/* Paired with READ_ONCE() in __fib6_drop_pcpu_from() */
 		prev = xchg(p, NULL);
 		if (prev) {
 			dst_dev_put(&prev->dst);
-- 
2.43.0



