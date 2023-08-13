Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865679446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:33:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06ED4C433C8;
	Sun, 13 Aug 2023 21:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962407;
	bh=DydW2V1J9O0eBNZ1mGCnvd3FaiLk8ElHNb24ai5z93Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BCbzNz5iJGDaj7xM4YY3eCk2cUR/DN1AE2DXH39+Asy9CftwDF7iq2WiXvMVVCFFQ
	 0n33khPzLHiUBieUle3VPxRQBK8fbnEFhfEBy4/UkrtwNm89bh9+adGv67i1gjbxWw
	 FcvJfzAdVPpDYl0cKY/FH581pfYKl4ocBiTyXbY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Paasch <cpaasch@apple.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 018/149] mptcp: fix disconnect vs accept race
Date: Sun, 13 Aug 2023 23:17:43 +0200
Message-ID: <20230813211719.344826148@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
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

commit 511b90e39250135a7f900f1c3afbce25543018a2 upstream.

Despite commit 0ad529d9fd2b ("mptcp: fix possible divide by zero in
recvmsg()"), the mptcp protocol is still prone to a race between
disconnect() (or shutdown) and accept.

The root cause is that the mentioned commit checks the msk-level
flag, but mptcp_stream_accept() does acquire the msk-level lock,
as it can rely directly on the first subflow lock.

As reported by Christoph than can lead to a race where an msk
socket is accepted after that mptcp_subflow_queue_clean() releases
the listener socket lock and just before it takes destructive
actions leading to the following splat:

BUG: kernel NULL pointer dereference, address: 0000000000000012
PGD 5a4ca067 P4D 5a4ca067 PUD 37d4c067 PMD 0
Oops: 0000 [#1] PREEMPT SMP
CPU: 2 PID: 10955 Comm: syz-executor.5 Not tainted 6.5.0-rc1-gdc7b257ee5dd #37
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.el7 04/01/2014
RIP: 0010:mptcp_stream_accept+0x1ee/0x2f0 include/net/inet_sock.h:330
Code: 0a 09 00 48 8b 1b 4c 39 e3 74 07 e8 bc 7c 7f fe eb a1 e8 b5 7c 7f fe 4c 8b 6c 24 08 eb 05 e8 a9 7c 7f fe 49 8b 85 d8 09 00 00 <0f> b6 40 12 88 44 24 07 0f b6 6c 24 07 bf 07 00 00 00 89 ee e8 89
RSP: 0018:ffffc90000d07dc0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff888037e8d020 RCX: ffff88803b093300
RDX: 0000000000000000 RSI: ffffffff833822c5 RDI: ffffffff8333896a
RBP: 0000607f82031520 R08: ffff88803b093300 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000003e83 R12: ffff888037e8d020
R13: ffff888037e8c680 R14: ffff888009af7900 R15: ffff888009af6880
FS:  00007fc26d708640(0000) GS:ffff88807dd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000012 CR3: 0000000066bc5001 CR4: 0000000000370ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 do_accept+0x1ae/0x260 net/socket.c:1872
 __sys_accept4+0x9b/0x110 net/socket.c:1913
 __do_sys_accept4 net/socket.c:1954 [inline]
 __se_sys_accept4 net/socket.c:1951 [inline]
 __x64_sys_accept4+0x20/0x30 net/socket.c:1951
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x47/0xa0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x6e/0xd8

Address the issue by temporary removing the pending request socket
from the accept queue, so that racing accept() can't touch them.

After depleting the msk - the ssk still exists, as plain TCP sockets,
re-insert them into the accept queue, so that later inet_csk_listen_stop()
will complete the tcp socket disposal.

Fixes: 2a6a870e44dd ("mptcp: stops worker on unaccepted sockets at listener close")
Cc: stable@vger.kernel.org
Reported-by: Christoph Paasch <cpaasch@apple.com>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/423
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Link: https://lore.kernel.org/r/20230803-upstream-net-20230803-misc-fixes-6-5-v1-4-6671b1ab11cc@tessares.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.h |    1 
 net/mptcp/subflow.c  |   60 +++++++++++++++++++++++++--------------------------
 2 files changed, 30 insertions(+), 31 deletions(-)

--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -312,7 +312,6 @@ struct mptcp_sock {
 
 	u32 setsockopt_seq;
 	char		ca_name[TCP_CA_NAME_MAX];
-	struct mptcp_sock	*dl_next;
 };
 
 #define mptcp_data_lock(sk) spin_lock_bh(&(sk)->sk_lock.slock)
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1724,16 +1724,31 @@ static void subflow_state_change(struct
 void mptcp_subflow_queue_clean(struct sock *listener_sk, struct sock *listener_ssk)
 {
 	struct request_sock_queue *queue = &inet_csk(listener_ssk)->icsk_accept_queue;
-	struct mptcp_sock *msk, *next, *head = NULL;
-	struct request_sock *req;
-	struct sock *sk;
-
-	/* build a list of all unaccepted mptcp sockets */
+	struct request_sock *req, *head, *tail;
+	struct mptcp_subflow_context *subflow;
+	struct sock *sk, *ssk;
+
+	/* Due to lock dependencies no relevant lock can be acquired under rskq_lock.
+	 * Splice the req list, so that accept() can not reach the pending ssk after
+	 * the listener socket is released below.
+	 */
 	spin_lock_bh(&queue->rskq_lock);
-	for (req = queue->rskq_accept_head; req; req = req->dl_next) {
-		struct mptcp_subflow_context *subflow;
-		struct sock *ssk = req->sk;
+	head = queue->rskq_accept_head;
+	tail = queue->rskq_accept_tail;
+	queue->rskq_accept_head = NULL;
+	queue->rskq_accept_tail = NULL;
+	spin_unlock_bh(&queue->rskq_lock);
+
+	if (!head)
+		return;
+
+	/* can't acquire the msk socket lock under the subflow one,
+	 * or will cause ABBA deadlock
+	 */
+	release_sock(listener_ssk);
 
+	for (req = head; req; req = req->dl_next) {
+		ssk = req->sk;
 		if (!sk_is_mptcp(ssk))
 			continue;
 
@@ -1741,32 +1756,10 @@ void mptcp_subflow_queue_clean(struct so
 		if (!subflow || !subflow->conn)
 			continue;
 
-		/* skip if already in list */
 		sk = subflow->conn;
-		msk = mptcp_sk(sk);
-		if (msk->dl_next || msk == head)
-			continue;
-
 		sock_hold(sk);
-		msk->dl_next = head;
-		head = msk;
-	}
-	spin_unlock_bh(&queue->rskq_lock);
-	if (!head)
-		return;
-
-	/* can't acquire the msk socket lock under the subflow one,
-	 * or will cause ABBA deadlock
-	 */
-	release_sock(listener_ssk);
-
-	for (msk = head; msk; msk = next) {
-		sk = (struct sock *)msk;
 
 		lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
-		next = msk->dl_next;
-		msk->dl_next = NULL;
-
 		__mptcp_unaccepted_force_close(sk);
 		release_sock(sk);
 
@@ -1790,6 +1783,13 @@ void mptcp_subflow_queue_clean(struct so
 
 	/* we are still under the listener msk socket lock */
 	lock_sock_nested(listener_ssk, SINGLE_DEPTH_NESTING);
+
+	/* restore the listener queue, to let the TCP code clean it up */
+	spin_lock_bh(&queue->rskq_lock);
+	WARN_ON_ONCE(queue->rskq_accept_head);
+	queue->rskq_accept_head = head;
+	queue->rskq_accept_tail = tail;
+	spin_unlock_bh(&queue->rskq_lock);
 }
 
 static int subflow_ulp_init(struct sock *sk)


