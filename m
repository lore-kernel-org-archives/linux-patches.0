Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02F619F485;
	Tue, 27 Aug 2024 15:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772557; cv=none; b=FXWCfxyOJlxDF5VVHcqM/W7vxLL4TDaM0tzI3JPGIEng2IzZHdQxXk6RVgS1vFxWx79Len/F/WBMS1rdYGVl+R8g5qQcXgq+yz8CH97SKoOH4kThxPQ+yIcBqArYdYeTD7UWLAVGTC2Gx8wXKGcwEvWMUdIaBYUKeJ3FiVHc41A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772557; c=relaxed/simple;
	bh=uPiZfyzlKUHvGQWhcMBLY36C7MQJKZELV5Eb0yZ7giU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GRyhV2VNwwbKrIKczTZg3Qjo80HY3MgFgZH7WYkDERe9bIyBNmOldJUKABzvlpoWOxZVXkwf3T1Y6vEY+yB0V0EQquCoyzdjFenkixAomk3PhJ7+RCV8+RnFhTUo2OST2YbogaL0IKcgvFPGMxymf/Q3sgKxS8G0lqemV9N7ScM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jdktZMoj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jdktZMoj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F51EC4AF15;
	Tue, 27 Aug 2024 15:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772557;
	bh=uPiZfyzlKUHvGQWhcMBLY36C7MQJKZELV5Eb0yZ7giU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jdktZMoj4a9lfApP22/MSgGsjhCWuyJiOSoldBzkVbw+MVm13nzw7l//LH7ysZzco
	 ve47yQPjT43LqY7Tls9gJt/zrz12xmGEkdI0Sj1oYkuqPxKjJNfuymcNJDlh2+1ff0
	 7+and5+0r6fZJi296aXWqxD6On4YG4xHoTp/aEA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	syzbot <syzkaller@googlegroups.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 251/321] ipv6: prevent UAF in ip6_send_skb()
Date: Tue, 27 Aug 2024 16:39:19 +0200
Message-ID: <20240827143847.799560265@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit faa389b2fbaaec7fd27a390b4896139f9da662e3 ]

syzbot reported an UAF in ip6_send_skb() [1]

After ip6_local_out() has returned, we no longer can safely
dereference rt, unless we hold rcu_read_lock().

A similar issue has been fixed in commit
a688caa34beb ("ipv6: take rcu lock in rawv6_send_hdrinc()")

Another potential issue in ip6_finish_output2() is handled in a
separate patch.

[1]
 BUG: KASAN: slab-use-after-free in ip6_send_skb+0x18d/0x230 net/ipv6/ip6_output.c:1964
Read of size 8 at addr ffff88806dde4858 by task syz.1.380/6530

CPU: 1 UID: 0 PID: 6530 Comm: syz.1.380 Not tainted 6.11.0-rc3-syzkaller-00306-gdf6cbc62cc9b #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
Call Trace:
 <TASK>
  __dump_stack lib/dump_stack.c:93 [inline]
  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:119
  print_address_description mm/kasan/report.c:377 [inline]
  print_report+0x169/0x550 mm/kasan/report.c:488
  kasan_report+0x143/0x180 mm/kasan/report.c:601
  ip6_send_skb+0x18d/0x230 net/ipv6/ip6_output.c:1964
  rawv6_push_pending_frames+0x75c/0x9e0 net/ipv6/raw.c:588
  rawv6_sendmsg+0x19c7/0x23c0 net/ipv6/raw.c:926
  sock_sendmsg_nosec net/socket.c:730 [inline]
  __sock_sendmsg+0x1a6/0x270 net/socket.c:745
  sock_write_iter+0x2dd/0x400 net/socket.c:1160
 do_iter_readv_writev+0x60a/0x890
  vfs_writev+0x37c/0xbb0 fs/read_write.c:971
  do_writev+0x1b1/0x350 fs/read_write.c:1018
  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f936bf79e79
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f936cd7f038 EFLAGS: 00000246 ORIG_RAX: 0000000000000014
RAX: ffffffffffffffda RBX: 00007f936c115f80 RCX: 00007f936bf79e79
RDX: 0000000000000001 RSI: 0000000020000040 RDI: 0000000000000004
RBP: 00007f936bfe7916 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f936c115f80 R15: 00007fff2860a7a8
 </TASK>

Allocated by task 6530:
  kasan_save_stack mm/kasan/common.c:47 [inline]
  kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
  unpoison_slab_object mm/kasan/common.c:312 [inline]
  __kasan_slab_alloc+0x66/0x80 mm/kasan/common.c:338
  kasan_slab_alloc include/linux/kasan.h:201 [inline]
  slab_post_alloc_hook mm/slub.c:3988 [inline]
  slab_alloc_node mm/slub.c:4037 [inline]
  kmem_cache_alloc_noprof+0x135/0x2a0 mm/slub.c:4044
  dst_alloc+0x12b/0x190 net/core/dst.c:89
  ip6_blackhole_route+0x59/0x340 net/ipv6/route.c:2670
  make_blackhole net/xfrm/xfrm_policy.c:3120 [inline]
  xfrm_lookup_route+0xd1/0x1c0 net/xfrm/xfrm_policy.c:3313
  ip6_dst_lookup_flow+0x13e/0x180 net/ipv6/ip6_output.c:1257
  rawv6_sendmsg+0x1283/0x23c0 net/ipv6/raw.c:898
  sock_sendmsg_nosec net/socket.c:730 [inline]
  __sock_sendmsg+0x1a6/0x270 net/socket.c:745
  ____sys_sendmsg+0x525/0x7d0 net/socket.c:2597
  ___sys_sendmsg net/socket.c:2651 [inline]
  __sys_sendmsg+0x2b0/0x3a0 net/socket.c:2680
  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 45:
  kasan_save_stack mm/kasan/common.c:47 [inline]
  kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
  kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:579
  poison_slab_object+0xe0/0x150 mm/kasan/common.c:240
  __kasan_slab_free+0x37/0x60 mm/kasan/common.c:256
  kasan_slab_free include/linux/kasan.h:184 [inline]
  slab_free_hook mm/slub.c:2252 [inline]
  slab_free mm/slub.c:4473 [inline]
  kmem_cache_free+0x145/0x350 mm/slub.c:4548
  dst_destroy+0x2ac/0x460 net/core/dst.c:124
  rcu_do_batch kernel/rcu/tree.c:2569 [inline]
  rcu_core+0xafd/0x1830 kernel/rcu/tree.c:2843
  handle_softirqs+0x2c4/0x970 kernel/softirq.c:554
  __do_softirq kernel/softirq.c:588 [inline]
  invoke_softirq kernel/softirq.c:428 [inline]
  __irq_exit_rcu+0xf4/0x1c0 kernel/softirq.c:637
  irq_exit_rcu+0x9/0x30 kernel/softirq.c:649
  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1043 [inline]
  sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1043
  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702

Last potentially related work creation:
  kasan_save_stack+0x3f/0x60 mm/kasan/common.c:47
  __kasan_record_aux_stack+0xac/0xc0 mm/kasan/generic.c:541
  __call_rcu_common kernel/rcu/tree.c:3106 [inline]
  call_rcu+0x167/0xa70 kernel/rcu/tree.c:3210
  refdst_drop include/net/dst.h:263 [inline]
  skb_dst_drop include/net/dst.h:275 [inline]
  nf_ct_frag6_queue net/ipv6/netfilter/nf_conntrack_reasm.c:306 [inline]
  nf_ct_frag6_gather+0xb9a/0x2080 net/ipv6/netfilter/nf_conntrack_reasm.c:485
  ipv6_defrag+0x2c8/0x3c0 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c:67
  nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
  nf_hook_slow+0xc3/0x220 net/netfilter/core.c:626
  nf_hook include/linux/netfilter.h:269 [inline]
  __ip6_local_out+0x6fa/0x800 net/ipv6/output_core.c:143
  ip6_local_out+0x26/0x70 net/ipv6/output_core.c:153
  ip6_send_skb+0x112/0x230 net/ipv6/ip6_output.c:1959
  rawv6_push_pending_frames+0x75c/0x9e0 net/ipv6/raw.c:588
  rawv6_sendmsg+0x19c7/0x23c0 net/ipv6/raw.c:926
  sock_sendmsg_nosec net/socket.c:730 [inline]
  __sock_sendmsg+0x1a6/0x270 net/socket.c:745
  sock_write_iter+0x2dd/0x400 net/socket.c:1160
 do_iter_readv_writev+0x60a/0x890

Fixes: 0625491493d9 ("ipv6: ip6_push_pending_frames() should increment IPSTATS_MIB_OUTDISCARDS")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20240820160859.3786976-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_output.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index df79044fbf3c4..796cf0a0a4225 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1993,6 +1993,7 @@ int ip6_send_skb(struct sk_buff *skb)
 	struct rt6_info *rt = (struct rt6_info *)skb_dst(skb);
 	int err;
 
+	rcu_read_lock();
 	err = ip6_local_out(net, skb->sk, skb);
 	if (err) {
 		if (err > 0)
@@ -2002,6 +2003,7 @@ int ip6_send_skb(struct sk_buff *skb)
 				      IPSTATS_MIB_OUTDISCARDS);
 	}
 
+	rcu_read_unlock();
 	return err;
 }
 
-- 
2.43.0



