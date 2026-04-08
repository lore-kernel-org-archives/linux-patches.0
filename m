Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473EF3D8125;
	Wed,  8 Apr 2026 18:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673060; cv=none; b=qCQDa6BUY5wJA6EaNcCfGCTIVW9pJORhMQYQKWZ2mxvWZ3LMD8pnJXpKZWtmg+6gzzSzytlqix6WC/rkPLI9FAnMd6O5CClny5J2BMW81BKCOchKlpMc9XNHAM5mtShbb8UJey+ofKuFpZ7EnwjysKb0MyAkXmyGjxWgKuhj0Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673060; c=relaxed/simple;
	bh=41u6ZTjVE0BToI8J+x4MXtJsGe3rPHQPycWXm68Jo6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/Qb1UCC90rUjzzs8YSkAlknJYeIgBeTYdPHsjp7BZ7dVc1jSjCPAFaKyZhOEHrUV56ymCPKTI1UpwqEtH7CAWojhvjEdwzKZxvS8viTIpEcYxUMvNodRHEV+IEPFjVdcUD+vvyg20m131JI00kDox2mf2HCPY9lJOObtxlslf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QmDUqQWg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QmDUqQWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A89C19421;
	Wed,  8 Apr 2026 18:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673060;
	bh=41u6ZTjVE0BToI8J+x4MXtJsGe3rPHQPycWXm68Jo6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QmDUqQWgTckyffi0v7YCiYRaoeuGPBe0mRdTdW/KTVYURpoXdPWOHl/5s47hFTC8J
	 iqa74MCYYJnGFEZWAXWh9MMLuuq1Xj+7/3XJ/oTW0XC2ptACgIEK/ikaJqQOXyLY1a
	 8oqOqZ4F4BWPssMZWLkN6Aodm+1NLLRtPHA+/5Fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2184232f07e3677fbaef@syzkaller.appspotmail.com,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 086/277] bpf: sockmap: Fix use-after-free of sk->sk_socket in sk_psock_verdict_data_ready().
Date: Wed,  8 Apr 2026 20:01:11 +0200
Message-ID: <20260408175937.075686950@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit ad8391d37f334ee73ba91926f8b4e4cf6d31ea04 ]

syzbot reported use-after-free of AF_UNIX socket's sk->sk_socket
in sk_psock_verdict_data_ready(). [0]

In unix_stream_sendmsg(), the peer socket's ->sk_data_ready() is
called after dropping its unix_state_lock().

Although the sender socket holds the peer's refcount, it does not
prevent the peer's sock_orphan(), and the peer's sk_socket might
be freed after one RCU grace period.

Let's fetch the peer's sk->sk_socket and sk->sk_socket->ops under
RCU in sk_psock_verdict_data_ready().

[0]:
BUG: KASAN: slab-use-after-free in sk_psock_verdict_data_ready+0xec/0x590 net/core/skmsg.c:1278
Read of size 8 at addr ffff8880594da860 by task syz.4.1842/11013

CPU: 1 UID: 0 PID: 11013 Comm: syz.4.1842 Not tainted syzkaller #0 PREEMPT(full)
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xba/0x230 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 sk_psock_verdict_data_ready+0xec/0x590 net/core/skmsg.c:1278
 unix_stream_sendmsg+0x8a3/0xe80 net/unix/af_unix.c:2482
 sock_sendmsg_nosec net/socket.c:721 [inline]
 __sock_sendmsg net/socket.c:736 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
 __sys_sendmsg net/socket.c:2671 [inline]
 __do_sys_sendmsg net/socket.c:2676 [inline]
 __se_sys_sendmsg net/socket.c:2674 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7facf899c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007facf9827028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007facf8c15fa0 RCX: 00007facf899c819
RDX: 0000000000000000 RSI: 0000200000000500 RDI: 0000000000000004
RBP: 00007facf8a32c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007facf8c16038 R14: 00007facf8c15fa0 R15: 00007ffd41b01c78
 </TASK>

Allocated by task 11013:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 unpoison_slab_object mm/kasan/common.c:340 [inline]
 __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:366
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4538 [inline]
 slab_alloc_node mm/slub.c:4866 [inline]
 kmem_cache_alloc_lru_noprof+0x2b8/0x640 mm/slub.c:4885
 sock_alloc_inode+0x28/0xc0 net/socket.c:316
 alloc_inode+0x6a/0x1b0 fs/inode.c:347
 new_inode_pseudo include/linux/fs.h:3003 [inline]
 sock_alloc net/socket.c:631 [inline]
 __sock_create+0x12d/0x9d0 net/socket.c:1562
 sock_create net/socket.c:1656 [inline]
 __sys_socketpair+0x1c4/0x560 net/socket.c:1803
 __do_sys_socketpair net/socket.c:1856 [inline]
 __se_sys_socketpair net/socket.c:1853 [inline]
 __x64_sys_socketpair+0x9b/0xb0 net/socket.c:1853
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 15:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2685 [inline]
 slab_free mm/slub.c:6165 [inline]
 kmem_cache_free+0x187/0x630 mm/slub.c:6295
 rcu_do_batch kernel/rcu/tree.c:2617 [inline]
 rcu_core+0x7cd/0x1070 kernel/rcu/tree.c:2869
 handle_softirqs+0x22a/0x870 kernel/softirq.c:622
 run_ksoftirqd+0x36/0x60 kernel/softirq.c:1063
 smpboot_thread_fn+0x541/0xa50 kernel/smpboot.c:160
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Fixes: c63829182c37 ("af_unix: Implement ->psock_update_sk_prot()")
Closes: https://lore.kernel.org/bpf/69cc6b9f.a70a0220.128fd0.004b.GAE@google.com/
Reported-by: syzbot+2184232f07e3677fbaef@syzkaller.appspotmail.com
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://patch.msgid.link/20260401005418.2452999-1-kuniyu@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skmsg.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 12fbb0545c712..35a6acbf9a579 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -1267,17 +1267,20 @@ static int sk_psock_verdict_recv(struct sock *sk, struct sk_buff *skb)
 
 static void sk_psock_verdict_data_ready(struct sock *sk)
 {
-	struct socket *sock = sk->sk_socket;
-	const struct proto_ops *ops;
+	const struct proto_ops *ops = NULL;
+	struct socket *sock;
 	int copied;
 
 	trace_sk_data_ready(sk);
 
-	if (unlikely(!sock))
-		return;
-	ops = READ_ONCE(sock->ops);
+	rcu_read_lock();
+	sock = READ_ONCE(sk->sk_socket);
+	if (likely(sock))
+		ops = READ_ONCE(sock->ops);
+	rcu_read_unlock();
 	if (!ops || !ops->read_skb)
 		return;
+
 	copied = ops->read_skb(sk, sk_psock_verdict_recv);
 	if (copied >= 0) {
 		struct sk_psock *psock;
-- 
2.53.0



