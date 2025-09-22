Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DE02F0C52;
	Mon, 22 Sep 2025 19:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570189; cv=none; b=QfZMJ0ofybrHRbXJPvphg7IQDuWX1uHGfKzld6U7XdoYVyTfdSKHDtFABaIwW3bZ8vzM7GuKl2vh8E4Q7XUlCJwy0s8Km5ltDUCWZKb/pIerhj4EQhCLTym8LieFkJG5lYCbf3MjaziImKMbhEViiMzF+v2IdAZhOqfqoll+yK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570189; c=relaxed/simple;
	bh=syUo8Bukrxpz4ZwNdz/EyQVtMULRHT8J1Fyho5fMTI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6n2cYzuvwrQNhHdXoULvJBLjJTd2EuGjXJNIYrcbvSUtw2UghA7GpuiPHPr3j7dcTeQw4mQVbwb/fYIuMm29a2kIH4tL0Tf4dncoMnwBr49Rs3RL2BfYxWw3cRMzwO/ide3ZiUg7aIf18dbE4yKgS10gGUwdBrRjO2hpmj0y3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rWibgx5L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rWibgx5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE254C4CEF5;
	Mon, 22 Sep 2025 19:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570189;
	bh=syUo8Bukrxpz4ZwNdz/EyQVtMULRHT8J1Fyho5fMTI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rWibgx5Lae5Z2LuXOe684ZwWMKxC2XVlR6QkqMd043s5pXm2r7Sl6uP1sxNslFl2L
	 KRX+J7ChLsUz+lzi9wNUONCjsFU/i2vNo2dbzQOXrscYPIDIaLTjguvxMRCi55MNyL
	 9WeTrfPS3KsTkhEIBwSAp7ODGoZ2wX+K+Nl3bEDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzkaller <syzkaller@googlegroups.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 040/149] tcp: Clear tcp_sk(sk)->fastopen_rsk in tcp_disconnect().
Date: Mon, 22 Sep 2025 21:29:00 +0200
Message-ID: <20250922192413.874278897@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 45c8a6cc2bcd780e634a6ba8e46bffbdf1fc5c01 ]

syzbot reported the splat below where a socket had tcp_sk(sk)->fastopen_rsk
in the TCP_ESTABLISHED state. [0]

syzbot reused the server-side TCP Fast Open socket as a new client before
the TFO socket completes 3WHS:

  1. accept()
  2. connect(AF_UNSPEC)
  3. connect() to another destination

As of accept(), sk->sk_state is TCP_SYN_RECV, and tcp_disconnect() changes
it to TCP_CLOSE and makes connect() possible, which restarts timers.

Since tcp_disconnect() forgot to clear tcp_sk(sk)->fastopen_rsk, the
retransmit timer triggered the warning and the intended packet was not
retransmitted.

Let's call reqsk_fastopen_remove() in tcp_disconnect().

[0]:
WARNING: CPU: 2 PID: 0 at net/ipv4/tcp_timer.c:542 tcp_retransmit_timer (net/ipv4/tcp_timer.c:542 (discriminator 7))
Modules linked in:
CPU: 2 UID: 0 PID: 0 Comm: swapper/2 Not tainted 6.17.0-rc5-g201825fb4278 #62 PREEMPT(voluntary)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:tcp_retransmit_timer (net/ipv4/tcp_timer.c:542 (discriminator 7))
Code: 41 55 41 54 55 53 48 8b af b8 08 00 00 48 89 fb 48 85 ed 0f 84 55 01 00 00 0f b6 47 12 3c 03 74 0c 0f b6 47 12 3c 04 74 04 90 <0f> 0b 90 48 8b 85 c0 00 00 00 48 89 ef 48 8b 40 30 e8 6a 4f 06 3e
RSP: 0018:ffffc900002f8d40 EFLAGS: 00010293
RAX: 0000000000000002 RBX: ffff888106911400 RCX: 0000000000000017
RDX: 0000000002517619 RSI: ffffffff83764080 RDI: ffff888106911400
RBP: ffff888106d5c000 R08: 0000000000000001 R09: ffffc900002f8de8
R10: 00000000000000c2 R11: ffffc900002f8ff8 R12: ffff888106911540
R13: ffff888106911480 R14: ffff888106911840 R15: ffffc900002f8de0
FS:  0000000000000000(0000) GS:ffff88907b768000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8044d69d90 CR3: 0000000002c30003 CR4: 0000000000370ef0
Call Trace:
 <IRQ>
 tcp_write_timer (net/ipv4/tcp_timer.c:738)
 call_timer_fn (kernel/time/timer.c:1747)
 __run_timers (kernel/time/timer.c:1799 kernel/time/timer.c:2372)
 timer_expire_remote (kernel/time/timer.c:2385 kernel/time/timer.c:2376 kernel/time/timer.c:2135)
 tmigr_handle_remote_up (kernel/time/timer_migration.c:944 kernel/time/timer_migration.c:1035)
 __walk_groups.isra.0 (kernel/time/timer_migration.c:533 (discriminator 1))
 tmigr_handle_remote (kernel/time/timer_migration.c:1096)
 handle_softirqs (./arch/x86/include/asm/jump_label.h:36 ./include/trace/events/irq.h:142 kernel/softirq.c:580)
 irq_exit_rcu (kernel/softirq.c:614 kernel/softirq.c:453 kernel/softirq.c:680 kernel/softirq.c:696)
 sysvec_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:1050 (discriminator 35) arch/x86/kernel/apic/apic.c:1050 (discriminator 35))
 </IRQ>

Fixes: 8336886f786f ("tcp: TCP Fast Open Server - support TFO listeners")
Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250915175800.118793-2-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 461a9ab540af0..98da33e0c308b 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3330,6 +3330,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 	int old_state = sk->sk_state;
+	struct request_sock *req;
 	u32 seq;
 
 	if (old_state != TCP_CLOSE)
@@ -3445,6 +3446,10 @@ int tcp_disconnect(struct sock *sk, int flags)
 
 
 	/* Clean up fastopen related fields */
+	req = rcu_dereference_protected(tp->fastopen_rsk,
+					lockdep_sock_is_held(sk));
+	if (req)
+		reqsk_fastopen_remove(sk, req, false);
 	tcp_free_fastopen_req(tp);
 	inet_clear_bit(DEFER_CONNECT, sk);
 	tp->fastopen_client_fail = 0;
-- 
2.51.0



