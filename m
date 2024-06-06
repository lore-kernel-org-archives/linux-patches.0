Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD981C8A01;
	Thu,  6 Jun 2024 14:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683713; cv=none; b=J+Z8oAOZsCW/LheHjX+fk5UZFbHQVMzFXiXW9cXjvNTTSZTR3cnY7R04OBcbbX7OYCrm1sb/fsl26JscocAhU3aS2oonXyQBE7BGURDVyYDSB0j8t89xNw3yHoe5i0YeOl4cfQC8sf3yX8pEp9Xt58ADbKQzCllHT2FuMwNc8XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683713; c=relaxed/simple;
	bh=ruCmxuVlVYFV1y9IZmF9L3Jh+eh/gsQ7toul35STge8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/1jHz/q9MnaBkYN/89zoy3C72QIaButSPiTc+f7U1NclItOlRpVHqzQjO/CJI3O7N+cvByLrUiqGmn2acLpz6x2FNbR2Cf6sGZtTrdk9OrJj+NNvaIWkUkAfNO51z6Ati38w9eSUNUspyRQw9cZJaXzwt6Kr+X4S3DzyuvjR24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lc2LvZsp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lc2LvZsp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39A0C2BD10;
	Thu,  6 Jun 2024 14:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683713;
	bh=ruCmxuVlVYFV1y9IZmF9L3Jh+eh/gsQ7toul35STge8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lc2LvZspX+/VlXgN8FqzQpLKZIvvU8ZsMp8EO4NBCHaEkCVz9zs8n181AhnAqK6qX
	 EVmooNdvT+075HxEVzrrxtL2W72y3B7c60l8zOfOPzMbiIxpNTVNUlvk+2PMFFmXOE
	 8kIhryqaQvngdZGQShD+f0arFTDHy2g8XMCgFbMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Billy Jheng Bing-Jhong <billy@starlabs.sg>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 645/744] af_unix: Update unix_sk(sk)->oob_skb under sk_receive_queue lock.
Date: Thu,  6 Jun 2024 16:05:17 +0200
Message-ID: <20240606131753.157465077@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 9841991a446c87f90f66f4b9fee6fe934c1336a2 ]

Billy Jheng Bing-Jhong reported a race between __unix_gc() and
queue_oob().

__unix_gc() tries to garbage-collect close()d inflight sockets,
and then if the socket has MSG_OOB in unix_sk(sk)->oob_skb, GC
will drop the reference and set NULL to it locklessly.

However, the peer socket still can send MSG_OOB message and
queue_oob() can update unix_sk(sk)->oob_skb concurrently, leading
NULL pointer dereference. [0]

To fix the issue, let's update unix_sk(sk)->oob_skb under the
sk_receive_queue's lock and take it everywhere we touch oob_skb.

Note that we defer kfree_skb() in manage_oob() to silence lockdep
false-positive (See [1]).

[0]:
BUG: kernel NULL pointer dereference, address: 0000000000000008
 PF: supervisor write access in kernel mode
 PF: error_code(0x0002) - not-present page
PGD 8000000009f5e067 P4D 8000000009f5e067 PUD 9f5d067 PMD 0
Oops: 0002 [#1] PREEMPT SMP PTI
CPU: 3 PID: 50 Comm: kworker/3:1 Not tainted 6.9.0-rc5-00191-gd091e579b864 #110
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
Workqueue: events delayed_fput
RIP: 0010:skb_dequeue (./include/linux/skbuff.h:2386 ./include/linux/skbuff.h:2402 net/core/skbuff.c:3847)
Code: 39 e3 74 3e 8b 43 10 48 89 ef 83 e8 01 89 43 10 49 8b 44 24 08 49 c7 44 24 08 00 00 00 00 49 8b 14 24 49 c7 04 24 00 00 00 00 <48> 89 42 08 48 89 10 e8 e7 c5 42 00 4c 89 e0 5b 5d 41 5c c3 cc cc
RSP: 0018:ffffc900001bfd48 EFLAGS: 00000002
RAX: 0000000000000000 RBX: ffff8880088f5ae8 RCX: 00000000361289f9
RDX: 0000000000000000 RSI: 0000000000000206 RDI: ffff8880088f5b00
RBP: ffff8880088f5b00 R08: 0000000000080000 R09: 0000000000000001
R10: 0000000000000003 R11: 0000000000000001 R12: ffff8880056b6a00
R13: ffff8880088f5280 R14: 0000000000000001 R15: ffff8880088f5a80
FS:  0000000000000000(0000) GS:ffff88807dd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000008 CR3: 0000000006314000 CR4: 00000000007506f0
PKRU: 55555554
Call Trace:
 <TASK>
 unix_release_sock (net/unix/af_unix.c:654)
 unix_release (net/unix/af_unix.c:1050)
 __sock_release (net/socket.c:660)
 sock_close (net/socket.c:1423)
 __fput (fs/file_table.c:423)
 delayed_fput (fs/file_table.c:444 (discriminator 3))
 process_one_work (kernel/workqueue.c:3259)
 worker_thread (kernel/workqueue.c:3329 kernel/workqueue.c:3416)
 kthread (kernel/kthread.c:388)
 ret_from_fork (arch/x86/kernel/process.c:153)
 ret_from_fork_asm (arch/x86/entry/entry_64.S:257)
 </TASK>
Modules linked in:
CR2: 0000000000000008

Link: https://lore.kernel.org/netdev/a00d3993-c461-43f2-be6d-07259c98509a@rbox.co/ [1]
Fixes: 1279f9d9dec2 ("af_unix: Call kfree_skb() for dead unix_(sk)->oob_skb in GC.")
Reported-by: Billy Jheng Bing-Jhong <billy@starlabs.sg>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/r/20240516134835.8332-1-kuniyu@amazon.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index aaa4d7878b5de..a4c41906faec1 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2147,13 +2147,15 @@ static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other
 	maybe_add_creds(skb, sock, other);
 	skb_get(skb);
 
+	scm_stat_add(other, skb);
+
+	spin_lock(&other->sk_receive_queue.lock);
 	if (ousk->oob_skb)
 		consume_skb(ousk->oob_skb);
-
 	WRITE_ONCE(ousk->oob_skb, skb);
+	__skb_queue_tail(&other->sk_receive_queue, skb);
+	spin_unlock(&other->sk_receive_queue.lock);
 
-	scm_stat_add(other, skb);
-	skb_queue_tail(&other->sk_receive_queue, skb);
 	sk_send_sigurg(other);
 	unix_state_unlock(other);
 	other->sk_data_ready(other);
@@ -2538,8 +2540,10 @@ static int unix_stream_recv_urg(struct unix_stream_read_state *state)
 
 	mutex_lock(&u->iolock);
 	unix_state_lock(sk);
+	spin_lock(&sk->sk_receive_queue.lock);
 
 	if (sock_flag(sk, SOCK_URGINLINE) || !u->oob_skb) {
+		spin_unlock(&sk->sk_receive_queue.lock);
 		unix_state_unlock(sk);
 		mutex_unlock(&u->iolock);
 		return -EINVAL;
@@ -2551,6 +2555,8 @@ static int unix_stream_recv_urg(struct unix_stream_read_state *state)
 		WRITE_ONCE(u->oob_skb, NULL);
 	else
 		skb_get(oob_skb);
+
+	spin_unlock(&sk->sk_receive_queue.lock);
 	unix_state_unlock(sk);
 
 	chunk = state->recv_actor(oob_skb, 0, chunk, state);
@@ -2579,6 +2585,10 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
 		consume_skb(skb);
 		skb = NULL;
 	} else {
+		struct sk_buff *unlinked_skb = NULL;
+
+		spin_lock(&sk->sk_receive_queue.lock);
+
 		if (skb == u->oob_skb) {
 			if (copied) {
 				skb = NULL;
@@ -2590,13 +2600,19 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
 			} else if (flags & MSG_PEEK) {
 				skb = NULL;
 			} else {
-				skb_unlink(skb, &sk->sk_receive_queue);
+				__skb_unlink(skb, &sk->sk_receive_queue);
 				WRITE_ONCE(u->oob_skb, NULL);
-				if (!WARN_ON_ONCE(skb_unref(skb)))
-					kfree_skb(skb);
+				unlinked_skb = skb;
 				skb = skb_peek(&sk->sk_receive_queue);
 			}
 		}
+
+		spin_unlock(&sk->sk_receive_queue.lock);
+
+		if (unlinked_skb) {
+			WARN_ON_ONCE(skb_unref(unlinked_skb));
+			kfree_skb(unlinked_skb);
+		}
 	}
 	return skb;
 }
-- 
2.43.0



