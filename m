Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6685FDD8;
	Tue, 13 Feb 2024 17:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845415; cv=none; b=h+yb6qdYQCvhFTnlmv+wRRN4D3IpSTioOJV3nxbb9DKQUzQA7jQi5NeP9EQQtgik+Cp2hplxVMEf+NPrb2DAIPpj/J9r54G9ckT/LU+Gg8CaPjALcT3/upfi+b1OQIZncvXbqKB6CbVyPG8ie4E8ozrOdZ6mQ3GXwjEwaGx/cYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845415; c=relaxed/simple;
	bh=FqHbYsubR9ORHyc0bFBu6h2KLtAIO23Pu2KQTQ6P4XA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gbr2sZzGbN5+9ljNTQejVsFAIancd4No+dqSNgoyIN1yw+/+GvLz6ShKLzuNjokGxL7FUHev8U9E9YYURfu9Qut3uCqkjUHGTCVz4VwLBQdvwmE/xJyXeyj6q9zYYR8NEMri9h2yhlTxfZh14syniK9gT+EAMOWTPHiMlDia+oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O87EFjSL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O87EFjSL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06696C433C7;
	Tue, 13 Feb 2024 17:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845415;
	bh=FqHbYsubR9ORHyc0bFBu6h2KLtAIO23Pu2KQTQ6P4XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O87EFjSLDF0BZZJy29aimW6uzNHqz491RkrLvg59fKatu7NelBzbIZXu4jfbg2gXu
	 Mr6HsGyF0OufAu/9qFL9ZaT/CpyjvMsHd8i1/imsGg8Czg3E0DKArBXfbBHKaAv+Xl
	 yedGV3TBRTanqQrPUNbDdu8aN9jLpUGQUxc+fud4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+fa3ef895554bdbfd1183@syzkaller.appspotmail.com,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 071/121] af_unix: Call kfree_skb() for dead unix_(sk)->oob_skb in GC.
Date: Tue, 13 Feb 2024 18:21:20 +0100
Message-ID: <20240213171855.067435165@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

[ Upstream commit 1279f9d9dec2d7462823a18c29ad61359e0a007d ]

syzbot reported a warning [0] in __unix_gc() with a repro, which
creates a socketpair and sends one socket's fd to itself using the
peer.

  socketpair(AF_UNIX, SOCK_STREAM, 0, [3, 4]) = 0
  sendmsg(4, {msg_name=NULL, msg_namelen=0, msg_iov=[{iov_base="\360", iov_len=1}],
          msg_iovlen=1, msg_control=[{cmsg_len=20, cmsg_level=SOL_SOCKET,
                                      cmsg_type=SCM_RIGHTS, cmsg_data=[3]}],
          msg_controllen=24, msg_flags=0}, MSG_OOB|MSG_PROBE|MSG_DONTWAIT|MSG_ZEROCOPY) = 1

This forms a self-cyclic reference that GC should finally untangle
but does not due to lack of MSG_OOB handling, resulting in memory
leak.

Recently, commit 11498715f266 ("af_unix: Remove io_uring code for
GC.") removed io_uring's dead code in GC and revealed the problem.

The code was executed at the final stage of GC and unconditionally
moved all GC candidates from gc_candidates to gc_inflight_list.
That papered over the reported problem by always making the following
WARN_ON_ONCE(!list_empty(&gc_candidates)) false.

The problem has been there since commit 2aab4b969002 ("af_unix: fix
struct pid leaks in OOB support") added full scm support for MSG_OOB
while fixing another bug.

To fix this problem, we must call kfree_skb() for unix_sk(sk)->oob_skb
if the socket still exists in gc_candidates after purging collected skb.

Then, we need to set NULL to oob_skb before calling kfree_skb() because
it calls last fput() and triggers unix_release_sock(), where we call
duplicate kfree_skb(u->oob_skb) if not NULL.

Note that the leaked socket remained being linked to a global list, so
kmemleak also could not detect it.  We need to check /proc/net/protocol
to notice the unfreed socket.

[0]:
WARNING: CPU: 0 PID: 2863 at net/unix/garbage.c:345 __unix_gc+0xc74/0xe80 net/unix/garbage.c:345
Modules linked in:
CPU: 0 PID: 2863 Comm: kworker/u4:11 Not tainted 6.8.0-rc1-syzkaller-00583-g1701940b1a02 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/25/2024
Workqueue: events_unbound __unix_gc
RIP: 0010:__unix_gc+0xc74/0xe80 net/unix/garbage.c:345
Code: 8b 5c 24 50 e9 86 f8 ff ff e8 f8 e4 22 f8 31 d2 48 c7 c6 30 6a 69 89 4c 89 ef e8 97 ef ff ff e9 80 f9 ff ff e8 dd e4 22 f8 90 <0f> 0b 90 e9 7b fd ff ff 48 89 df e8 5c e7 7c f8 e9 d3 f8 ff ff e8
RSP: 0018:ffffc9000b03fba0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffffc9000b03fc10 RCX: ffffffff816c493e
RDX: ffff88802c02d940 RSI: ffffffff896982f3 RDI: ffffc9000b03fb30
RBP: ffffc9000b03fce0 R08: 0000000000000001 R09: fffff52001607f66
R10: 0000000000000003 R11: 0000000000000002 R12: dffffc0000000000
R13: ffffc9000b03fc10 R14: ffffc9000b03fc10 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8880b9400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005559c8677a60 CR3: 000000000d57a000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 process_one_work+0x889/0x15e0 kernel/workqueue.c:2633
 process_scheduled_works kernel/workqueue.c:2706 [inline]
 worker_thread+0x8b9/0x12a0 kernel/workqueue.c:2787
 kthread+0x2c6/0x3b0 kernel/kthread.c:388
 ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1b/0x30 arch/x86/entry/entry_64.S:242
 </TASK>

Reported-by: syzbot+fa3ef895554bdbfd1183@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=fa3ef895554bdbfd1183
Fixes: 2aab4b969002 ("af_unix: fix struct pid leaks in OOB support")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240203183149.63573-1-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/garbage.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/unix/garbage.c b/net/unix/garbage.c
index 2405f0f9af31..8f63f0b4bf01 100644
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -314,6 +314,17 @@ void unix_gc(void)
 	/* Here we are. Hitlist is filled. Die. */
 	__skb_queue_purge(&hitlist);
 
+#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
+	list_for_each_entry_safe(u, next, &gc_candidates, link) {
+		struct sk_buff *skb = u->oob_skb;
+
+		if (skb) {
+			u->oob_skb = NULL;
+			kfree_skb(skb);
+		}
+	}
+#endif
+
 	spin_lock(&unix_gc_lock);
 
 	/* There could be io_uring registered files, just push them back to
-- 
2.43.0



