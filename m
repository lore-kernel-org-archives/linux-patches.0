Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76977134C7
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:17:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BEA3C433C0;
	Mon, 26 Jun 2023 18:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803466;
	bh=ATeqmohmC7ApjdUKQrxX1/IysGnwlFz/al57jn1DCkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ahEzEK9g3CPjAihGZDOqs6kEw8/b0ciHXhpgOWWvcRybE9oymVOWYGPB2YHYv1eF7
	 ECrVoQx4NnGAdD+sFtlQe2fqlz7PsdR66cIKzYdzWuW42892R2g0hCl8ChtYBa7l2a
	 aRVAgCc6YhfQ4jhQVcO82bL1Jf17cOlZD536qeSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Paasch <cpaasch@apple.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.3 071/199] mptcp: fix possible divide by zero in recvmsg()
Date: Mon, 26 Jun 2023 20:09:37 +0200
Message-ID: <20230626180808.644068537@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paolo Abeni <pabeni@redhat.com>

commit 0ad529d9fd2bfa3fc619552a8d2fb2f2ef0bce2e upstream.

Christoph reported a divide by zero bug in mptcp_recvmsg():

divide error: 0000 [#1] PREEMPT SMP
CPU: 1 PID: 19978 Comm: syz-executor.6 Not tainted 6.4.0-rc2-gffcc7899081b #20
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.el7 04/01/2014
RIP: 0010:__tcp_select_window+0x30e/0x420 net/ipv4/tcp_output.c:3018
Code: 11 ff 0f b7 cd c1 e9 0c b8 ff ff ff ff d3 e0 89 c1 f7 d1 01 cb 21 c3 eb 17 e8 2e 83 11 ff 31 db eb 0e e8 25 83 11 ff 89 d8 99 <f7> 7c 24 04 29 d3 65 48 8b 04 25 28 00 00 00 48 3b 44 24 10 75 60
RSP: 0018:ffffc90000a07a18 EFLAGS: 00010246
RAX: 000000000000ffd7 RBX: 000000000000ffd7 RCX: 0000000000040000
RDX: 0000000000000000 RSI: 000000000003ffff RDI: 0000000000040000
RBP: 000000000000ffd7 R08: ffffffff820cf297 R09: 0000000000000001
R10: 0000000000000000 R11: ffffffff8103d1a0 R12: 0000000000003f00
R13: 0000000000300000 R14: ffff888101cf3540 R15: 0000000000180000
FS:  00007f9af4c09640(0000) GS:ffff88813bd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b33824000 CR3: 000000012f241001 CR4: 0000000000170ee0
Call Trace:
 <TASK>
 __tcp_cleanup_rbuf+0x138/0x1d0 net/ipv4/tcp.c:1611
 mptcp_recvmsg+0xcb8/0xdd0 net/mptcp/protocol.c:2034
 inet_recvmsg+0x127/0x1f0 net/ipv4/af_inet.c:861
 ____sys_recvmsg+0x269/0x2b0 net/socket.c:1019
 ___sys_recvmsg+0xe6/0x260 net/socket.c:2764
 do_recvmmsg+0x1a5/0x470 net/socket.c:2858
 __do_sys_recvmmsg net/socket.c:2937 [inline]
 __se_sys_recvmmsg net/socket.c:2953 [inline]
 __x64_sys_recvmmsg+0xa6/0x130 net/socket.c:2953
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x47/0xa0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x72/0xdc
RIP: 0033:0x7f9af58fc6a9
Code: 5c c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 4f 37 0d 00 f7 d8 64 89 01 48
RSP: 002b:00007f9af4c08cd8 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
RAX: ffffffffffffffda RBX: 00000000006bc050 RCX: 00007f9af58fc6a9
RDX: 0000000000000001 RSI: 0000000020000140 RDI: 0000000000000004
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000f00 R11: 0000000000000246 R12: 00000000006bc05c
R13: fffffffffffffea8 R14: 00000000006bc050 R15: 000000000001fe40
 </TASK>

mptcp_recvmsg is allowed to release the msk socket lock when
blocking, and before re-acquiring it another thread could have
switched the sock to TCP_LISTEN status - with a prior
connect(AF_UNSPEC) - also clearing icsk_ack.rcv_mss.

Address the issue preventing the disconnect if some other process is
concurrently performing a blocking syscall on the same socket, alike
commit 4faeee0cf8a5 ("tcp: deny tcp_disconnect() when threads are waiting").

Fixes: a6b118febbab ("mptcp: add receive buffer auto-tuning")
Cc: stable@vger.kernel.org
Reported-by: Christoph Paasch <cpaasch@apple.com>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/404
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Tested-by: Christoph Paasch <cpaasch@apple.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3054,6 +3054,12 @@ static int mptcp_disconnect(struct sock
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
+	/* Deny disconnect if other threads are blocked in sk_wait_event()
+	 * or inet_wait_for_connect().
+	 */
+	if (sk->sk_wait_pending)
+		return -EBUSY;
+
 	/* We are on the fastopen error path. We can't call straight into the
 	 * subflows cleanup code due to lock nesting (we are already under
 	 * msk->firstsocket lock).
@@ -3120,6 +3126,7 @@ struct sock *mptcp_sk_clone_init(const s
 		inet_sk(nsk)->pinet6 = mptcp_inet6_sk(nsk);
 #endif
 
+	nsk->sk_wait_pending = 0;
 	__mptcp_init_sock(nsk);
 
 	msk = mptcp_sk(nsk);


