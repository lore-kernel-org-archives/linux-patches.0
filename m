Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2164184D26;
	Tue, 14 May 2024 11:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684595; cv=none; b=LdF3bHxb7aASGt5mVY283cHMSkpqTKPACQfuPc4YS/sBjlyJzw7id2iItC0duspPpgzQO60sOFqFupCNAc3k3q+hgkHbMdobaR/50ZbMYD10nP5veYZ9Xwf2BRy0TNk34iRdDGega1UvfZeAWjhJRgAYzXjK4iZScD2pwzYQbNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684595; c=relaxed/simple;
	bh=kHXbhJfe7rDxaU2KzvlYrX1J8ESMmswxUkEi0T2G9Sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pkkJsVf8/7qy4NWZ9kDSXnj6smdWV76TluHRTPcO9td86jFq5wXV9D+leKD0GDaoPxa4k8HPnWFYmLMCAxH+6gr8jeOgfbCSUJ7US/XRuNiKL8YoptgkhbKFGqrWBzgpGg6h2U7rA3v+0+Q/AwKeG1MizV4eseBlWQkhlQwmUoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wS6vElGn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wS6vElGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A554BC2BD10;
	Tue, 14 May 2024 11:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684594;
	bh=kHXbhJfe7rDxaU2KzvlYrX1J8ESMmswxUkEi0T2G9Sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wS6vElGnlJQcbqlvUCPoFmS/SgdXnhD5wpbjSa/AodhMJ5cvIQAh11dC3ARr32Rre
	 x/y6W3DYzgEb8W55KYaItW0QtqTNn0CqgkqP6pd5jRC+2nE/54njolTNBiYyqITmqz
	 TnnF0DThpTPGeXuazFmol0fLLS7wY6vrF418UXRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+aa8c8ec2538929f18f2d@syzkaller.appspotmail.com,
	Jason Xing <kernelxing@tencent.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/301] bpf, skmsg: Fix NULL pointer dereference in sk_psock_skb_ingress_enqueue
Date: Tue, 14 May 2024 12:15:00 +0200
Message-ID: <20240514101033.346401180@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: Jason Xing <kernelxing@tencent.com>

[ Upstream commit 6648e613226e18897231ab5e42ffc29e63fa3365 ]

Fix NULL pointer data-races in sk_psock_skb_ingress_enqueue() which
syzbot reported [1].

[1]
BUG: KCSAN: data-race in sk_psock_drop / sk_psock_skb_ingress_enqueue

write to 0xffff88814b3278b8 of 8 bytes by task 10724 on cpu 1:
 sk_psock_stop_verdict net/core/skmsg.c:1257 [inline]
 sk_psock_drop+0x13e/0x1f0 net/core/skmsg.c:843
 sk_psock_put include/linux/skmsg.h:459 [inline]
 sock_map_close+0x1a7/0x260 net/core/sock_map.c:1648
 unix_release+0x4b/0x80 net/unix/af_unix.c:1048
 __sock_release net/socket.c:659 [inline]
 sock_close+0x68/0x150 net/socket.c:1421
 __fput+0x2c1/0x660 fs/file_table.c:422
 __fput_sync+0x44/0x60 fs/file_table.c:507
 __do_sys_close fs/open.c:1556 [inline]
 __se_sys_close+0x101/0x1b0 fs/open.c:1541
 __x64_sys_close+0x1f/0x30 fs/open.c:1541
 do_syscall_64+0xd3/0x1d0
 entry_SYSCALL_64_after_hwframe+0x6d/0x75

read to 0xffff88814b3278b8 of 8 bytes by task 10713 on cpu 0:
 sk_psock_data_ready include/linux/skmsg.h:464 [inline]
 sk_psock_skb_ingress_enqueue+0x32d/0x390 net/core/skmsg.c:555
 sk_psock_skb_ingress_self+0x185/0x1e0 net/core/skmsg.c:606
 sk_psock_verdict_apply net/core/skmsg.c:1008 [inline]
 sk_psock_verdict_recv+0x3e4/0x4a0 net/core/skmsg.c:1202
 unix_read_skb net/unix/af_unix.c:2546 [inline]
 unix_stream_read_skb+0x9e/0xf0 net/unix/af_unix.c:2682
 sk_psock_verdict_data_ready+0x77/0x220 net/core/skmsg.c:1223
 unix_stream_sendmsg+0x527/0x860 net/unix/af_unix.c:2339
 sock_sendmsg_nosec net/socket.c:730 [inline]
 __sock_sendmsg+0x140/0x180 net/socket.c:745
 ____sys_sendmsg+0x312/0x410 net/socket.c:2584
 ___sys_sendmsg net/socket.c:2638 [inline]
 __sys_sendmsg+0x1e9/0x280 net/socket.c:2667
 __do_sys_sendmsg net/socket.c:2676 [inline]
 __se_sys_sendmsg net/socket.c:2674 [inline]
 __x64_sys_sendmsg+0x46/0x50 net/socket.c:2674
 do_syscall_64+0xd3/0x1d0
 entry_SYSCALL_64_after_hwframe+0x6d/0x75

value changed: 0xffffffff83d7feb0 -> 0x0000000000000000

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 10713 Comm: syz-executor.4 Tainted: G        W          6.8.0-syzkaller-08951-gfe46a7dd189e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/29/2024

Prior to this, commit 4cd12c6065df ("bpf, sockmap: Fix NULL pointer
dereference in sk_psock_verdict_data_ready()") fixed one NULL pointer
similarly due to no protection of saved_data_ready. Here is another
different caller causing the same issue because of the same reason. So
we should protect it with sk_callback_lock read lock because the writer
side in the sk_psock_drop() uses "write_lock_bh(&sk->sk_callback_lock);".

To avoid errors that could happen in future, I move those two pairs of
lock into the sk_psock_data_ready(), which is suggested by John Fastabend.

Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Reported-by: syzbot+aa8c8ec2538929f18f2d@syzkaller.appspotmail.com
Signed-off-by: Jason Xing <kernelxing@tencent.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=aa8c8ec2538929f18f2d
Link: https://lore.kernel.org/all/20240329134037.92124-1-kerneljasonxing@gmail.com
Link: https://lore.kernel.org/bpf/20240404021001.94815-1-kerneljasonxing@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skmsg.h | 2 ++
 net/core/skmsg.c      | 5 +----
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index bd4418377bacf..062fe440f5d09 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -456,10 +456,12 @@ static inline void sk_psock_put(struct sock *sk, struct sk_psock *psock)
 
 static inline void sk_psock_data_ready(struct sock *sk, struct sk_psock *psock)
 {
+	read_lock_bh(&sk->sk_callback_lock);
 	if (psock->saved_data_ready)
 		psock->saved_data_ready(sk);
 	else
 		sk->sk_data_ready(sk);
+	read_unlock_bh(&sk->sk_callback_lock);
 }
 
 static inline void psock_set_prog(struct bpf_prog **pprog,
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 4d75ef9d24bfa..fd20aae30be23 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -1226,11 +1226,8 @@ static void sk_psock_verdict_data_ready(struct sock *sk)
 
 		rcu_read_lock();
 		psock = sk_psock(sk);
-		if (psock) {
-			read_lock_bh(&sk->sk_callback_lock);
+		if (psock)
 			sk_psock_data_ready(sk, psock);
-			read_unlock_bh(&sk->sk_callback_lock);
-		}
 		rcu_read_unlock();
 	}
 }
-- 
2.43.0



