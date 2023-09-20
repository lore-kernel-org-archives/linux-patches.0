Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD1715AD3
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:38:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C78C433CD;
	Wed, 20 Sep 2023 12:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213537;
	bh=WR8het9bkiUtbJrYZPQFR6MyCgDSU2Omcjrp8zdI3V0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=benm1qVm/nJuDTaygZajwBnsag84szPhp+7LzLEcKLiNgbywEOs7SRt2Xb0PXkCzb
	 xjU5Jzu787MixoE/zS8bomQM83N7uJdkz/b1ayohssOvrACBwHkjANknArlXborMYZ
	 Stn1EiPtQXIf/L2kE70lZnPu2MG+dvM/+sWiio4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzkaller <syzkaller@googlegroups.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 266/367] af_unix: Fix data-races around sk->sk_shutdown.
Date: Wed, 20 Sep 2023 13:30:43 +0200
Message-ID: <20230920112905.451546032@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit afe8764f76346ba838d4f162883e23d2fcfaa90e ]

sk->sk_shutdown is changed under unix_state_lock(sk), but
unix_dgram_sendmsg() calls two functions to read sk_shutdown locklessly.

  sock_alloc_send_pskb
  `- sock_wait_for_wmem

Let's use READ_ONCE() there.

Note that the writer side was marked by commit e1d09c2c2f57 ("af_unix:
Fix data races around sk->sk_shutdown.").

BUG: KCSAN: data-race in sock_alloc_send_pskb / unix_release_sock

write (marked) to 0xffff8880069af12c of 1 bytes by task 1 on cpu 1:
 unix_release_sock+0x75c/0x910 net/unix/af_unix.c:631
 unix_release+0x59/0x80 net/unix/af_unix.c:1053
 __sock_release+0x7d/0x170 net/socket.c:654
 sock_close+0x19/0x30 net/socket.c:1386
 __fput+0x2a3/0x680 fs/file_table.c:384
 ____fput+0x15/0x20 fs/file_table.c:412
 task_work_run+0x116/0x1a0 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x174/0x180 kernel/entry/common.c:204
 __syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
 syscall_exit_to_user_mode+0x1a/0x30 kernel/entry/common.c:297
 do_syscall_64+0x4b/0x90 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x6e/0xd8

read to 0xffff8880069af12c of 1 bytes by task 28650 on cpu 0:
 sock_alloc_send_pskb+0xd2/0x620 net/core/sock.c:2767
 unix_dgram_sendmsg+0x2f8/0x14f0 net/unix/af_unix.c:1944
 unix_seqpacket_sendmsg net/unix/af_unix.c:2308 [inline]
 unix_seqpacket_sendmsg+0xba/0x130 net/unix/af_unix.c:2292
 sock_sendmsg_nosec net/socket.c:725 [inline]
 sock_sendmsg+0x148/0x160 net/socket.c:748
 ____sys_sendmsg+0x4e4/0x610 net/socket.c:2494
 ___sys_sendmsg+0xc6/0x140 net/socket.c:2548
 __sys_sendmsg+0x94/0x140 net/socket.c:2577
 __do_sys_sendmsg net/socket.c:2586 [inline]
 __se_sys_sendmsg net/socket.c:2584 [inline]
 __x64_sys_sendmsg+0x45/0x50 net/socket.c:2584
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3b/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x6e/0xd8

value changed: 0x00 -> 0x03

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 28650 Comm: systemd-coredum Not tainted 6.4.0-11989-g6843306689af #6
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 1fed45f29e0ec..79d61be285186 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2223,7 +2223,7 @@ static long sock_wait_for_wmem(struct sock *sk, long timeo)
 		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
 		if (refcount_read(&sk->sk_wmem_alloc) < READ_ONCE(sk->sk_sndbuf))
 			break;
-		if (sk->sk_shutdown & SEND_SHUTDOWN)
+		if (READ_ONCE(sk->sk_shutdown) & SEND_SHUTDOWN)
 			break;
 		if (sk->sk_err)
 			break;
@@ -2253,7 +2253,7 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
 			goto failure;
 
 		err = -EPIPE;
-		if (sk->sk_shutdown & SEND_SHUTDOWN)
+		if (READ_ONCE(sk->sk_shutdown) & SEND_SHUTDOWN)
 			goto failure;
 
 		if (sk_wmem_alloc_get(sk) < READ_ONCE(sk->sk_sndbuf))
-- 
2.40.1



