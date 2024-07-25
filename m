Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8959519D066;
	Thu, 25 Jul 2024 14:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918476; cv=none; b=PwnFNssn+IGhTa4Lz8/OqP5s7Ta1lllmXbySVKpdxJS5RVWBJ/TOuwbt8MGUT6NSurAm3DTciB7Nvg9M/Vu4xT0WORS+BmHt8b3kkcJWCXaHCBm0TWGeFjCKqAS98HqSsrVA/0fiLTora7lgJeBD/Krjw6s94z/JR/S6eCAaZ/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918476; c=relaxed/simple;
	bh=wnUyVKHmzf0dB3ILZy1ciP0qN6IDzexLCYMDEMwFo+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zf+IXN1paznAW7eK/oxJ3H8qK9hdmBWNU3PQ6HeyKKnVyGTImk+g6M14t8MqUXxbGg8MEa/To6WzRZjPHGUqtX3YCzS4rh+3m1Os/2Q0oKcvyzlh54LyGwsJUdsoHAhPv/BjnpNFRtNfickIqSPQeKvnSbG5KHCTM2AV7x3kZAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KDMJhCOO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KDMJhCOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D626FC32782;
	Thu, 25 Jul 2024 14:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918476;
	bh=wnUyVKHmzf0dB3ILZy1ciP0qN6IDzexLCYMDEMwFo+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KDMJhCOOISWKOlbAE3yyfU5VeUGsIuJLOR3XedY9W2eCOtZSUincK1H1DgGsYVl+W
	 iHGSiiMyXAIN9YgqK/zQNvQ5kxtns8KH5sb8szNUNDb5iYkceL9UM0ayP6c4ufM2Cf
	 BoU8kSE7r1TtVnIvP1oq/Za8uKzIq83T38yhXbkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Paasch <cpaasch@apple.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Nikolay Kuratov <kniv@yandex-team.ru>
Subject: [PATCH 4.19 30/33] net: relax socket state check at accept time.
Date: Thu, 25 Jul 2024 16:36:53 +0200
Message-ID: <20240725142729.647183391@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142728.511303502@linuxfoundation.org>
References: <20240725142728.511303502@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit 26afda78cda3da974fd4c287962c169e9462c495 upstream.

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
Signed-off-by: Nikolay Kuratov <kniv@yandex-team.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/af_inet.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -749,7 +749,9 @@ int inet_accept(struct socket *sock, str
 	sock_rps_record_flow(sk2);
 	WARN_ON(!((1 << sk2->sk_state) &
 		  (TCPF_ESTABLISHED | TCPF_SYN_RECV |
-		  TCPF_CLOSE_WAIT | TCPF_CLOSE)));
+		   TCPF_FIN_WAIT1 | TCPF_FIN_WAIT2 |
+		   TCPF_CLOSING | TCPF_CLOSE_WAIT |
+		   TCPF_CLOSE)));
 
 	sock_graft(sk2, newsock);
 


