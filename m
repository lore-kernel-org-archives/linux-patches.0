Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E521E1A1885;
	Thu,  6 Jun 2024 14:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683722; cv=none; b=sfybX+0Moa0Ks4MgyRChmbojj+2K8xlvL4ddqORFvEvsB9TDgguCQSye5lCdbS45ErQvgJ0ctRwtgzIRYWQl8+YXb0Y3bAaULsuHoK3YmAXblN8nDEO1IXhp2HaWre5/rN1JAD8eAlBeh+pnexKMTYnnuvGUCKHGP2unjdBxFPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683722; c=relaxed/simple;
	bh=yS3Qrq/6fLr2zoAMrYBiaj35JKIIVYXgcBiQbwGfnL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BsWsuG6ubKYozcFwXdduw2Zwz/6uHxLTyA8rVrMV6+wGu6J22LcWVMF6CqCCWyGmohF1Tvt4yX3in8mvZcL3r4Rus9eeiwOWUOWZvtKOw1tNOLZG9JAaCYs8TRtwBB8VwcydTXjt8zrq2iocuGzTK0PECKOmqE6WV4UjbFa2bb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u1tpIuqt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u1tpIuqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DDBC2BD10;
	Thu,  6 Jun 2024 14:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683721;
	bh=yS3Qrq/6fLr2zoAMrYBiaj35JKIIVYXgcBiQbwGfnL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u1tpIuqt2tdC2nNq8oPwPo+Vka7dQu9FO4cKIrSRxHkp5arCz8r5z/ZjaHxARlrrY
	 sdLbniHwgBoQAKpldTGpHbaezQZ6H9dmQ+EF6XZApLpYae/yUlqjFFseBCU0pQsRvj
	 0pFUu3+0tNh6gpqrMp6tC38LrvBv3fah/AchLHms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Paasch <cpaasch@apple.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 665/744] net: relax socket state check at accept time.
Date: Thu,  6 Jun 2024 16:05:37 +0200
Message-ID: <20240606131753.797847413@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 26afda78cda3da974fd4c287962c169e9462c495 ]

Christoph reported the following splat:

WARNING: CPU: 1 PID: 772 at net/ipv4/af_inet.c:761 __inet_accept+0x1f4/0x4a0
Modules linked in:
CPU: 1 PID: 772 Comm: syz-executor510 Not tainted 6.9.0-rc7-g7da7119fe22b #56
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.el7 04/01/2014
RIP: 0010:__inet_accept+0x1f4/0x4a0 net/ipv4/af_inet.c:759
Code: 04 38 84 c0 0f 85 87 00 00 00 41 c7 04 24 03 00 00 00 48 83 c4 10 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc e8 ec b7 da fd <0f> 0b e9 7f fe ff ff e8 e0 b7 da fd 0f 0b e9 fe fe ff ff 89 d9 80
RSP: 0018:ffffc90000c2fc58 EFLAGS: 00010293
RAX: ffffffff836bdd14 RBX: 0000000000000000 RCX: ffff888104668000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: dffffc0000000000 R08: ffffffff836bdb89 R09: fffff52000185f64
R10: dffffc0000000000 R11: fffff52000185f64 R12: dffffc0000000000
R13: 1ffff92000185f98 R14: ffff88810754d880 R15: ffff8881007b7800
FS:  000000001c772880(0000) GS:ffff88811b280000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb9fcf2e178 CR3: 00000001045d2002 CR4: 0000000000770ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <TASK>
 inet_accept+0x138/0x1d0 net/ipv4/af_inet.c:786
 do_accept+0x435/0x620 net/socket.c:1929
 __sys_accept4_file net/socket.c:1969 [inline]
 __sys_accept4+0x9b/0x110 net/socket.c:1999
 __do_sys_accept net/socket.c:2016 [inline]
 __se_sys_accept net/socket.c:2013 [inline]
 __x64_sys_accept+0x7d/0x90 net/socket.c:2013
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0x58/0x100 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x4315f9
Code: fd ff 48 81 c4 80 00 00 00 e9 f1 fe ff ff 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 ab b4 fd ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffdb26d9c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002b
RAX: ffffffffffffffda RBX: 0000000000400300 RCX: 00000000004315f9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 00000000006e1018 R08: 0000000000400300 R09: 0000000000400300
R10: 0000000000400300 R11: 0000000000000246 R12: 0000000000000000
R13: 000000000040cdf0 R14: 000000000040ce80 R15: 0000000000000055
 </TASK>

The reproducer invokes shutdown() before entering the listener status.
After commit 94062790aedb ("tcp: defer shutdown(SEND_SHUTDOWN) for
TCP_SYN_RECV sockets"), the above causes the child to reach the accept
syscall in FIN_WAIT1 status.

Eric noted we can relax the existing assertion in __inet_accept()

Reported-by: Christoph Paasch <cpaasch@apple.com>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/490
Suggested-by: Eric Dumazet <edumazet@google.com>
Fixes: 94062790aedb ("tcp: defer shutdown(SEND_SHUTDOWN) for TCP_SYN_RECV sockets")
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/23ab880a44d8cfd967e84de8b93dbf48848e3d8c.1716299669.git.pabeni@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/af_inet.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index b50308105551f..3feff7f738a48 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -757,7 +757,9 @@ void __inet_accept(struct socket *sock, struct socket *newsock, struct sock *new
 	sock_rps_record_flow(newsk);
 	WARN_ON(!((1 << newsk->sk_state) &
 		  (TCPF_ESTABLISHED | TCPF_SYN_RECV |
-		  TCPF_CLOSE_WAIT | TCPF_CLOSE)));
+		   TCPF_FIN_WAIT1 | TCPF_FIN_WAIT2 |
+		   TCPF_CLOSING | TCPF_CLOSE_WAIT |
+		   TCPF_CLOSE)));
 
 	if (test_bit(SOCK_SUPPORT_ZC, &sock->flags))
 		set_bit(SOCK_SUPPORT_ZC, &newsock->flags);
-- 
2.43.0



