Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857FA1519B4;
	Wed,  5 Feb 2025 15:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768593; cv=none; b=dp5coEagd3dMNLXLoNWBzgvLDs+gFsIcisjni1vbVaH4tKlCHJ4yABsIvRb8qdn6NVA1Vmsa3xTFpNF4+e97EU7wjo+CXNeL/QSevjhr+cWNJbboBStS2PWxAQB+iaMpRlC5lje78l95xFmCqULkKfBIXlnrxFI8I0BitqEc+k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768593; c=relaxed/simple;
	bh=X2Ybnono/q4BpMkM1JBrwCl2Mjd2w2b0DKxK56GPb5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYirn7uTGAcjrux0+Cs0m+x9ySsKo+NUFk8Cq/JeFUDcKDEqGTOMlFgY8Yf9Zyi7ixRjEm5utKbdPBUSog4lK8L5bIlPsUTkpKKO16NufSqo8tc80+ivffbkUmTJsohiQqYm3uEuxYYWHAaSxTp/eJP1KiooUEujepIAV7C5sTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WvMZb1Vi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WvMZb1Vi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1AFC4CED1;
	Wed,  5 Feb 2025 15:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768593;
	bh=X2Ybnono/q4BpMkM1JBrwCl2Mjd2w2b0DKxK56GPb5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WvMZb1VicluU9ymnfbmbrhlwyDS4dDcK3nO30RUZdKjuMgPUJyRMMaJyzpleFDw6F
	 p8SQ3RXWlsDDQMQxlv46fPAr4MLtwi5CxfyY+iNjqFC/I847ZQE2w+zT5BEfZrYQAt
	 P00jOJpy+SIjwR6sqhOzSILTRBEjYio7Mls2ysgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ebc0b8ae5d3590b2c074@syzkaller.appspotmail.com,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.13 601/623] mptcp: handle fastopen disconnect correctly
Date: Wed,  5 Feb 2025 14:45:43 +0100
Message-ID: <20250205134519.215258101@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit 619af16b3b57a3a4ee50b9a30add9ff155541e71 upstream.

Syzbot was able to trigger a data stream corruption:

  WARNING: CPU: 0 PID: 9846 at net/mptcp/protocol.c:1024 __mptcp_clean_una+0xddb/0xff0 net/mptcp/protocol.c:1024
  Modules linked in:
  CPU: 0 UID: 0 PID: 9846 Comm: syz-executor351 Not tainted 6.13.0-rc2-syzkaller-00059-g00a5acdbf398 #0
  Hardware name: Google Compute Engine/Google Compute Engine, BIOS Google 11/25/2024
  RIP: 0010:__mptcp_clean_una+0xddb/0xff0 net/mptcp/protocol.c:1024
  Code: fa ff ff 48 8b 4c 24 18 80 e1 07 fe c1 38 c1 0f 8c 8e fa ff ff 48 8b 7c 24 18 e8 e0 db 54 f6 e9 7f fa ff ff e8 e6 80 ee f5 90 <0f> 0b 90 4c 8b 6c 24 40 4d 89 f4 e9 04 f5 ff ff 44 89 f1 80 e1 07
  RSP: 0018:ffffc9000c0cf400 EFLAGS: 00010293
  RAX: ffffffff8bb0dd5a RBX: ffff888033f5d230 RCX: ffff888059ce8000
  RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
  RBP: ffffc9000c0cf518 R08: ffffffff8bb0d1dd R09: 1ffff110170c8928
  R10: dffffc0000000000 R11: ffffed10170c8929 R12: 0000000000000000
  R13: ffff888033f5d220 R14: dffffc0000000000 R15: ffff8880592b8000
  FS:  00007f6e866496c0(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f6e86f491a0 CR3: 00000000310e6000 CR4: 00000000003526f0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   <TASK>
   __mptcp_clean_una_wakeup+0x7f/0x2d0 net/mptcp/protocol.c:1074
   mptcp_release_cb+0x7cb/0xb30 net/mptcp/protocol.c:3493
   release_sock+0x1aa/0x1f0 net/core/sock.c:3640
   inet_wait_for_connect net/ipv4/af_inet.c:609 [inline]
   __inet_stream_connect+0x8bd/0xf30 net/ipv4/af_inet.c:703
   mptcp_sendmsg_fastopen+0x2a2/0x530 net/mptcp/protocol.c:1755
   mptcp_sendmsg+0x1884/0x1b10 net/mptcp/protocol.c:1830
   sock_sendmsg_nosec net/socket.c:711 [inline]
   __sock_sendmsg+0x1a6/0x270 net/socket.c:726
   ____sys_sendmsg+0x52a/0x7e0 net/socket.c:2583
   ___sys_sendmsg net/socket.c:2637 [inline]
   __sys_sendmsg+0x269/0x350 net/socket.c:2669
   do_syscall_x64 arch/x86/entry/common.c:52 [inline]
   do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  RIP: 0033:0x7f6e86ebfe69
  Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 1f 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
  RSP: 002b:00007f6e86649168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
  RAX: ffffffffffffffda RBX: 00007f6e86f491b8 RCX: 00007f6e86ebfe69
  RDX: 0000000030004001 RSI: 0000000020000080 RDI: 0000000000000003
  RBP: 00007f6e86f491b0 R08: 00007f6e866496c0 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000246 R12: 00007f6e86f491bc
  R13: 000000000000006e R14: 00007ffe445d9420 R15: 00007ffe445d9508
   </TASK>

The root cause is the bad handling of disconnect() generated internally
by the MPTCP protocol in case of connect FASTOPEN errors.

Address the issue increasing the socket disconnect counter even on such
a case, to allow other threads waiting on the same socket lock to
properly error out.

Fixes: c2b2ae3925b6 ("mptcp: handle correctly disconnect() failures")
Cc: stable@vger.kernel.org
Reported-by: syzbot+ebc0b8ae5d3590b2c074@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/67605870.050a0220.37aaf.0137.GAE@google.com
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/537
Tested-by: syzbot+ebc0b8ae5d3590b2c074@syzkaller.appspotmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250123-net-mptcp-syzbot-issues-v1-3-af73258a726f@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1767,8 +1767,10 @@ static int mptcp_sendmsg_fastopen(struct
 		 * see mptcp_disconnect().
 		 * Attempt it again outside the problematic scope.
 		 */
-		if (!mptcp_disconnect(sk, 0))
+		if (!mptcp_disconnect(sk, 0)) {
+			sk->sk_disconnects++;
 			sk->sk_socket->state = SS_UNCONNECTED;
+		}
 	}
 	inet_clear_bit(DEFER_CONNECT, sk);
 


