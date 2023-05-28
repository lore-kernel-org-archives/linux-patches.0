Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BACF2569E
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:13:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6DAC433EF;
	Sun, 28 May 2023 19:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301194;
	bh=nhV7KGgkMqY2g/XLwvQZElIC26CIz2CgGzK4ssMKeHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X1nrxqRc1tsH8KoqmNrJK4yyyDglZrp9GNv6tDkb6Vo/uBLkiB+w26aCb6YGFuI4r
	 +q+6P3YpcFn4vJU4d1Fcw1ekQgCHnzTii+GvamMcDZwfGv95jUDolRWsXTw2hOHbP5
	 h5aTvF08gxOVWvFsvh1uT2gWmz3DNUPJbbWmwVm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 05/86] af_unix: Fix a data race of sk->sk_receive_queue->qlen.
Date: Sun, 28 May 2023 20:09:39 +0100
Message-Id: <20230528190828.755150621@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190828.564682883@linuxfoundation.org>
References: <20230528190828.564682883@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 679ed006d416ea0cecfe24a99d365d1dea69c683 ]

KCSAN found a data race of sk->sk_receive_queue->qlen where recvmsg()
updates qlen under the queue lock and sendmsg() checks qlen under
unix_state_sock(), not the queue lock, so the reader side needs
READ_ONCE().

BUG: KCSAN: data-race in __skb_try_recv_from_queue / unix_wait_for_peer

write (marked) to 0xffff888019fe7c68 of 4 bytes by task 49792 on cpu 0:
 __skb_unlink include/linux/skbuff.h:2347 [inline]
 __skb_try_recv_from_queue+0x3de/0x470 net/core/datagram.c:197
 __skb_try_recv_datagram+0xf7/0x390 net/core/datagram.c:263
 __unix_dgram_recvmsg+0x109/0x8a0 net/unix/af_unix.c:2452
 unix_dgram_recvmsg+0x94/0xa0 net/unix/af_unix.c:2549
 sock_recvmsg_nosec net/socket.c:1019 [inline]
 ____sys_recvmsg+0x3a3/0x3b0 net/socket.c:2720
 ___sys_recvmsg+0xc8/0x150 net/socket.c:2764
 do_recvmmsg+0x182/0x560 net/socket.c:2858
 __sys_recvmmsg net/socket.c:2937 [inline]
 __do_sys_recvmmsg net/socket.c:2960 [inline]
 __se_sys_recvmmsg net/socket.c:2953 [inline]
 __x64_sys_recvmmsg+0x153/0x170 net/socket.c:2953
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3b/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x72/0xdc

read to 0xffff888019fe7c68 of 4 bytes by task 49793 on cpu 1:
 skb_queue_len include/linux/skbuff.h:2127 [inline]
 unix_recvq_full net/unix/af_unix.c:229 [inline]
 unix_wait_for_peer+0x154/0x1a0 net/unix/af_unix.c:1445
 unix_dgram_sendmsg+0x13bc/0x14b0 net/unix/af_unix.c:2048
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg+0x148/0x160 net/socket.c:747
 ____sys_sendmsg+0x20e/0x620 net/socket.c:2503
 ___sys_sendmsg+0xc6/0x140 net/socket.c:2557
 __sys_sendmmsg+0x11d/0x370 net/socket.c:2643
 __do_sys_sendmmsg net/socket.c:2672 [inline]
 __se_sys_sendmmsg net/socket.c:2669 [inline]
 __x64_sys_sendmmsg+0x58/0x70 net/socket.c:2669
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3b/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x72/0xdc

value changed: 0x0000000b -> 0x00000001

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 49793 Comm: syz-executor.0 Not tainted 6.3.0-rc7-02330-gca6270c12e20 #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 0e494902fadaa..375d4e20efd6b 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1236,7 +1236,7 @@ static long unix_wait_for_peer(struct sock *other, long timeo)
 
 	sched = !sock_flag(other, SOCK_DEAD) &&
 		!(other->sk_shutdown & RCV_SHUTDOWN) &&
-		unix_recvq_full(other);
+		unix_recvq_full_lockless(other);
 
 	unix_state_unlock(other);
 
-- 
2.39.2



