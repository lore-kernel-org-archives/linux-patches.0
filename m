Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F83F15CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:03:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB908C433D6;
	Tue,  8 Nov 2022 14:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916224;
	bh=QiqluafjqolUkYl3jFiPP+gAdOgI1pzM/I+yc5TFvdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qio/p5Gd4g2+CzcAbxb22H0ABwleLN3OIHHBHYNuwZixDXRKquSv0ba+zuWmV0vSe
	 xGl+aFpEoYOusI11vUweumYfkG8L0f+T2ZPLOZqMK4hlsozoDsGeCpuBql7qERWnGP
	 Y66Wvy5QQedE65AZhmENE9MNbqPYvUks3+tMHRt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	"David S. Miller" <davem@davemloft.net>,
	Anil Altinay <aaltinay@google.com>
Subject: [PATCH 5.15 099/144] af_unix: Fix memory leaks of the whole sk due to OOB skb.
Date: Tue,  8 Nov 2022 14:39:36 +0100
Message-Id: <20221108133349.482630545@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
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

commit 7a62ed61367b8fd01bae1e18e30602c25060d824 upstream.

syzbot reported a sequence of memory leaks, and one of them indicated we
failed to free a whole sk:

  unreferenced object 0xffff8880126e0000 (size 1088):
    comm "syz-executor419", pid 326, jiffies 4294773607 (age 12.609s)
    hex dump (first 32 bytes):
      00 00 00 00 00 00 00 00 7d 00 00 00 00 00 00 00  ........}.......
      01 00 07 40 00 00 00 00 00 00 00 00 00 00 00 00  ...@............
    backtrace:
      [<000000006fefe750>] sk_prot_alloc+0x64/0x2a0 net/core/sock.c:1970
      [<0000000074006db5>] sk_alloc+0x3b/0x800 net/core/sock.c:2029
      [<00000000728cd434>] unix_create1+0xaf/0x920 net/unix/af_unix.c:928
      [<00000000a279a139>] unix_create+0x113/0x1d0 net/unix/af_unix.c:997
      [<0000000068259812>] __sock_create+0x2ab/0x550 net/socket.c:1516
      [<00000000da1521e1>] sock_create net/socket.c:1566 [inline]
      [<00000000da1521e1>] __sys_socketpair+0x1a8/0x550 net/socket.c:1698
      [<000000007ab259e1>] __do_sys_socketpair net/socket.c:1751 [inline]
      [<000000007ab259e1>] __se_sys_socketpair net/socket.c:1748 [inline]
      [<000000007ab259e1>] __x64_sys_socketpair+0x97/0x100 net/socket.c:1748
      [<000000007dedddc1>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
      [<000000007dedddc1>] do_syscall_64+0x38/0x90 arch/x86/entry/common.c:80
      [<000000009456679f>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

We can reproduce this issue by creating two AF_UNIX SOCK_STREAM sockets,
send()ing an OOB skb to each other, and close()ing them without consuming
the OOB skbs.

  int skpair[2];

  socketpair(AF_UNIX, SOCK_STREAM, 0, skpair);

  send(skpair[0], "x", 1, MSG_OOB);
  send(skpair[1], "x", 1, MSG_OOB);

  close(skpair[0]);
  close(skpair[1]);

Currently, we free an OOB skb in unix_sock_destructor() which is called via
__sk_free(), but it's too late because the receiver's unix_sk(sk)->oob_skb
is accounted against the sender's sk->sk_wmem_alloc and __sk_free() is
called only when sk->sk_wmem_alloc is 0.

In the repro sequences, we do not consume the OOB skb, so both two sk's
sock_put() never reach __sk_free() due to the positive sk->sk_wmem_alloc.
Then, no one can consume the OOB skb nor call __sk_free(), and we finally
leak the two whole sk.

Thus, we must free the unconsumed OOB skb earlier when close()ing the
socket.

Fixes: 314001f0bf92 ("af_unix: Add OOB support")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Anil Altinay <aaltinay@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/unix/af_unix.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -504,12 +504,6 @@ static void unix_sock_destructor(struct
 
 	skb_queue_purge(&sk->sk_receive_queue);
 
-#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
-	if (u->oob_skb) {
-		kfree_skb(u->oob_skb);
-		u->oob_skb = NULL;
-	}
-#endif
 	WARN_ON(refcount_read(&sk->sk_wmem_alloc));
 	WARN_ON(!sk_unhashed(sk));
 	WARN_ON(sk->sk_socket);
@@ -556,6 +550,13 @@ static void unix_release_sock(struct soc
 
 	unix_state_unlock(sk);
 
+#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
+	if (u->oob_skb) {
+		kfree_skb(u->oob_skb);
+		u->oob_skb = NULL;
+	}
+#endif
+
 	wake_up_interruptible_all(&u->peer_wait);
 
 	if (skpair != NULL) {


