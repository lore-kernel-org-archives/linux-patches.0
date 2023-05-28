Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A68611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:22:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53DFEC4339B;
	Sun, 28 May 2023 19:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301729;
	bh=HuayMjO89gWx18c1IMs1LluOCUqY9ForkCLk5xr3zHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YquWXNfrKUc5pzCVh6HEJF5l99aCQ1yifqaAZZoDufbgNpaFiX4aKqms4p7Myr6BC
	 MxXTtnTqXkMoKs0I6QtqqOqlF2rCJdz0fMUYk6VWPgDlATX/Z2YfHGoPQeh0TRJcwl
	 wqJwFYC+EfRiFxxpygnaRknfT0/TFAdJ8xOlsQ48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 005/161] net: Fix load-tearing on sk->sk_stamp in sock_recv_cmsgs().
Date: Sun, 28 May 2023 20:08:49 +0100
Message-Id: <20230528190837.255793677@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190837.051205996@linuxfoundation.org>
References: <20230528190837.051205996@linuxfoundation.org>
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

[ Upstream commit dfd9248c071a3710c24365897459538551cb7167 ]

KCSAN found a data race in sock_recv_cmsgs() where the read access
to sk->sk_stamp needs READ_ONCE().

BUG: KCSAN: data-race in packet_recvmsg / packet_recvmsg

write (marked) to 0xffff88803c81f258 of 8 bytes by task 19171 on cpu 0:
 sock_write_timestamp include/net/sock.h:2670 [inline]
 sock_recv_cmsgs include/net/sock.h:2722 [inline]
 packet_recvmsg+0xb97/0xd00 net/packet/af_packet.c:3489
 sock_recvmsg_nosec net/socket.c:1019 [inline]
 sock_recvmsg+0x11a/0x130 net/socket.c:1040
 sock_read_iter+0x176/0x220 net/socket.c:1118
 call_read_iter include/linux/fs.h:1845 [inline]
 new_sync_read fs/read_write.c:389 [inline]
 vfs_read+0x5e0/0x630 fs/read_write.c:470
 ksys_read+0x163/0x1a0 fs/read_write.c:613
 __do_sys_read fs/read_write.c:623 [inline]
 __se_sys_read fs/read_write.c:621 [inline]
 __x64_sys_read+0x41/0x50 fs/read_write.c:621
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3b/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x72/0xdc

read to 0xffff88803c81f258 of 8 bytes by task 19183 on cpu 1:
 sock_recv_cmsgs include/net/sock.h:2721 [inline]
 packet_recvmsg+0xb64/0xd00 net/packet/af_packet.c:3489
 sock_recvmsg_nosec net/socket.c:1019 [inline]
 sock_recvmsg+0x11a/0x130 net/socket.c:1040
 sock_read_iter+0x176/0x220 net/socket.c:1118
 call_read_iter include/linux/fs.h:1845 [inline]
 new_sync_read fs/read_write.c:389 [inline]
 vfs_read+0x5e0/0x630 fs/read_write.c:470
 ksys_read+0x163/0x1a0 fs/read_write.c:613
 __do_sys_read fs/read_write.c:623 [inline]
 __se_sys_read fs/read_write.c:621 [inline]
 __x64_sys_read+0x41/0x50 fs/read_write.c:621
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3b/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x72/0xdc

value changed: 0xffffffffc4653600 -> 0x0000000000000000

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 19183 Comm: syz-executor.5 Not tainted 6.3.0-rc7-02330-gca6270c12e20 #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014

Fixes: 6c7c98bad488 ("sock: avoid dirtying sk_stamp, if possible")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230508175543.55756-1-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 26dd07e47a7c7..fa19c6ba24441 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2448,7 +2448,7 @@ static inline void sock_recv_ts_and_drops(struct msghdr *msg, struct sock *sk,
 		__sock_recv_ts_and_drops(msg, sk, skb);
 	else if (unlikely(sock_flag(sk, SOCK_TIMESTAMP)))
 		sock_write_timestamp(sk, skb->tstamp);
-	else if (unlikely(sk->sk_stamp == SK_DEFAULT_STAMP))
+	else if (unlikely(sock_read_timestamp(sk) == SK_DEFAULT_STAMP))
 		sock_write_timestamp(sk, 0);
 }
 
-- 
2.39.2



