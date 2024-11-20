Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E251991AA;
	Wed, 20 Nov 2024 13:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107665; cv=none; b=DuVibHdT9D07swL3q1X9QIji3TrqoLLRcDNgRNSDyMYcWq4HPYXJ/DvKNQ/YLivX/Gdfwg2H2XwSSda2Tzw2GY43dwLJkFWmY1uUjL/56c0hsc+h5kyEJZwn8nB395BYhdnx8+alWM1ScGj8yEqxpB7dX0jyz+uN80qaQ67f/Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107665; c=relaxed/simple;
	bh=6OVQlpeqnZbohzUvkJWXMEwG7dgujHAhm6Ebc0VnrN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=denr6msN/Q5vfGAQVisskHjs+ccF8eN7vcMgkPpnxxZPqYaRXBlNhtkjaJaLPpRkOaArNnaTmjQlMWMW734wOGkPhe9J3eYdvJpDw3w3Lwe428f5G38yu3kzP4VrDU9BwW8eYhMlOWPrzssNTjYkhK4FcgBJyc0Oi1JHkpWlmFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VGEyuWu5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGEyuWu5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1FB5C4CECD;
	Wed, 20 Nov 2024 13:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107664;
	bh=6OVQlpeqnZbohzUvkJWXMEwG7dgujHAhm6Ebc0VnrN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VGEyuWu5FrJ96NmMpU9+Z8163xRp1tzO/+nPUj0YNpoN9OxLNa7SUF92Nf3n7/PoG
	 x+BdUnd1T1DicxkW08Xb/CpmSFxs7EFgtLd4pFbx0n9CG1sWBUHJQhpHcsWbEVUmXo
	 QmsK+/fhX3Ki5XccRW/ofQitzxH6uRy2qp4JtDVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 04/73] mptcp: error out earlier on disconnect
Date: Wed, 20 Nov 2024 13:57:50 +0100
Message-ID: <20241120125809.729850920@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 581302298524e9d77c4c44ff5156a6cd112227ae ]

Eric reported a division by zero splat in the MPTCP protocol:

Oops: divide error: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 1 UID: 0 PID: 6094 Comm: syz-executor317 Not tainted
6.12.0-rc5-syzkaller-00291-g05b92660cdfe #0
Hardware name: Google Google Compute Engine/Google Compute Engine,
BIOS Google 09/13/2024
RIP: 0010:__tcp_select_window+0x5b4/0x1310 net/ipv4/tcp_output.c:3163
Code: f6 44 01 e3 89 df e8 9b 75 09 f8 44 39 f3 0f 8d 11 ff ff ff e8
0d 74 09 f8 45 89 f4 e9 04 ff ff ff e8 00 74 09 f8 44 89 f0 99 <f7> 7c
24 14 41 29 d6 45 89 f4 e9 ec fe ff ff e8 e8 73 09 f8 48 89
RSP: 0018:ffffc900041f7930 EFLAGS: 00010293
RAX: 0000000000017e67 RBX: 0000000000017e67 RCX: ffffffff8983314b
RDX: 0000000000000000 RSI: ffffffff898331b0 RDI: 0000000000000004
RBP: 00000000005d6000 R08: 0000000000000004 R09: 0000000000017e67
R10: 0000000000003e80 R11: 0000000000000000 R12: 0000000000003e80
R13: ffff888031d9b440 R14: 0000000000017e67 R15: 00000000002eb000
FS: 00007feb5d7f16c0(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007feb5d8adbb8 CR3: 0000000074e4c000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
__tcp_cleanup_rbuf+0x3e7/0x4b0 net/ipv4/tcp.c:1493
mptcp_rcv_space_adjust net/mptcp/protocol.c:2085 [inline]
mptcp_recvmsg+0x2156/0x2600 net/mptcp/protocol.c:2289
inet_recvmsg+0x469/0x6a0 net/ipv4/af_inet.c:885
sock_recvmsg_nosec net/socket.c:1051 [inline]
sock_recvmsg+0x1b2/0x250 net/socket.c:1073
__sys_recvfrom+0x1a5/0x2e0 net/socket.c:2265
__do_sys_recvfrom net/socket.c:2283 [inline]
__se_sys_recvfrom net/socket.c:2279 [inline]
__x64_sys_recvfrom+0xe0/0x1c0 net/socket.c:2279
do_syscall_x64 arch/x86/entry/common.c:52 [inline]
do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7feb5d857559
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 51 18 00 00 90 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007feb5d7f1208 EFLAGS: 00000246 ORIG_RAX: 000000000000002d
RAX: ffffffffffffffda RBX: 00007feb5d8e1318 RCX: 00007feb5d857559
RDX: 000000800000000e RSI: 0000000000000000 RDI: 0000000000000003
RBP: 00007feb5d8e1310 R08: 0000000000000000 R09: ffffffff81000000
R10: 0000000000000100 R11: 0000000000000246 R12: 00007feb5d8e131c
R13: 00007feb5d8ae074 R14: 000000800000000e R15: 00000000fffffdef

and provided a nice reproducer.

The root cause is the current bad handling of racing disconnect.
After the blamed commit below, sk_wait_data() can return (with
error) with the underlying socket disconnected and a zero rcv_mss.

Catch the error and return without performing any additional
operations on the current socket.

Reported-by: Eric Dumazet <edumazet@google.com>
Fixes: 419ce133ab92 ("tcp: allow again tcp_disconnect() when threads are waiting")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/8c82ecf71662ecbc47bf390f9905de70884c9f2d.1731060874.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index d68e93dab88c3..78ac5c538e139 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2180,7 +2180,7 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		cmsg_flags = MPTCP_CMSG_INQ;
 
 	while (copied < len) {
-		int bytes_read;
+		int err, bytes_read;
 
 		bytes_read = __mptcp_recvmsg_mskq(msk, msg, len - copied, flags, &tss, &cmsg_flags);
 		if (unlikely(bytes_read < 0)) {
@@ -2245,9 +2245,16 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		}
 
 		pr_debug("block timeout %ld\n", timeo);
-		sk_wait_data(sk, &timeo, NULL);
+		mptcp_rcv_space_adjust(msk, copied);
+		err = sk_wait_data(sk, &timeo, NULL);
+		if (err < 0) {
+			err = copied ? : err;
+			goto out_err;
+		}
 	}
 
+	mptcp_rcv_space_adjust(msk, copied);
+
 out_err:
 	if (cmsg_flags && copied >= 0) {
 		if (cmsg_flags & MPTCP_CMSG_TS)
@@ -2263,8 +2270,6 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	pr_debug("msk=%p rx queue empty=%d:%d copied=%d\n",
 		 msk, skb_queue_empty_lockless(&sk->sk_receive_queue),
 		 skb_queue_empty(&msk->receive_queue), copied);
-	if (!(flags & MSG_PEEK))
-		mptcp_rcv_space_adjust(msk, copied);
 
 	release_sock(sk);
 	return copied;
-- 
2.43.0



