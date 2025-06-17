Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9C12ECEA8;
	Tue, 17 Jun 2025 15:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175195; cv=none; b=WlQI8/quwSUZBb56BL54ruQqmEqvE26rSw0tjYGJkH8VHrF0qL1go7DXI9i/E3tCMZ1giXZC9VGoCRaw7q2+LyzDXxGfPBlb1O3V1mP5HKZ2qaLvA/P7GeM5U9ChzQsQ4M+rvv0sPotZSLBza6jZ/XUAvePwGa48PeSYlyEQOwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175195; c=relaxed/simple;
	bh=iXmnWLFAXysEQNaBpPg8sK79kkIL5gXQpRd0JOq+L7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOD2q1wUkkEcTrhx3CtlpUKZ+BlnGPVUl1jZY/7Xcot6f6YVXd6s2EiY1PytMy4LQxV5c2y3mELr/X63PUE7LX85EY7S5ziR0bd19Wk0cde+5xaLsV/pJZhyl3eLDGiPdkhjVQ/NhEnkzdnAsXNO6i++l++gx47+GloogPU8Xa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aaK81szb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aaK81szb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4C0C4CEE3;
	Tue, 17 Jun 2025 15:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175194;
	bh=iXmnWLFAXysEQNaBpPg8sK79kkIL5gXQpRd0JOq+L7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aaK81szbkF8R1poMnIlP/LiKV6TfcMh/3wGg7fk/FZpC+mjRosXSp7iMyDabkR2+7
	 H+BdgiudKuzaYj7Hns2dhf0X5PXRM1HtN/ONdwWYYqYkMMAepB/ZMYWhX+uczYoXLN
	 og140cXXUNgANYq0HRXASrJ6mroAP51eS6tdLir0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzkaller <syzkaller@googlegroups.com>,
	John Cheung <john.cs.hey@gmail.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paul Moore <paul@paul-moore.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 152/356] calipso: Dont call calipso functions for AF_INET sk.
Date: Tue, 17 Jun 2025 17:24:27 +0200
Message-ID: <20250617152344.351682118@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 6e9f2df1c550ead7cecb3e450af1105735020c92 ]

syzkaller reported a null-ptr-deref in txopt_get(). [0]

The offset 0x70 was of struct ipv6_txoptions in struct ipv6_pinfo,
so struct ipv6_pinfo was NULL there.

However, this never happens for IPv6 sockets as inet_sk(sk)->pinet6
is always set in inet6_create(), meaning the socket was not IPv6 one.

The root cause is missing validation in netlbl_conn_setattr().

netlbl_conn_setattr() switches branches based on struct
sockaddr.sa_family, which is passed from userspace.  However,
netlbl_conn_setattr() does not check if the address family matches
the socket.

The syzkaller must have called connect() for an IPv6 address on
an IPv4 socket.

We have a proper validation in tcp_v[46]_connect(), but
security_socket_connect() is called in the earlier stage.

Let's copy the validation to netlbl_conn_setattr().

[0]:
Oops: general protection fault, probably for non-canonical address 0xdffffc000000000e: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000070-0x0000000000000077]
CPU: 2 UID: 0 PID: 12928 Comm: syz.9.1677 Not tainted 6.12.0 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
RIP: 0010:txopt_get include/net/ipv6.h:390 [inline]
RIP: 0010:
Code: 02 00 00 49 8b ac 24 f8 02 00 00 e8 84 69 2a fd e8 ff 00 16 fd 48 8d 7d 70 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 53 02 00 00 48 8b 6d 70 48 85 ed 0f 84 ab 01 00
RSP: 0018:ffff88811b8afc48 EFLAGS: 00010212
RAX: dffffc0000000000 RBX: 1ffff11023715f8a RCX: ffffffff841ab00c
RDX: 000000000000000e RSI: ffffc90007d9e000 RDI: 0000000000000070
RBP: 0000000000000000 R08: ffffed1023715f9d R09: ffffed1023715f9e
R10: ffffed1023715f9d R11: 0000000000000003 R12: ffff888123075f00
R13: ffff88810245bd80 R14: ffff888113646780 R15: ffff888100578a80
FS:  00007f9019bd7640(0000) GS:ffff8882d2d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f901b927bac CR3: 0000000104788003 CR4: 0000000000770ef0
PKRU: 80000000
Call Trace:
 <TASK>
 calipso_sock_setattr+0x56/0x80 net/netlabel/netlabel_calipso.c:557
 netlbl_conn_setattr+0x10c/0x280 net/netlabel/netlabel_kapi.c:1177
 selinux_netlbl_socket_connect_helper+0xd3/0x1b0 security/selinux/netlabel.c:569
 selinux_netlbl_socket_connect_locked security/selinux/netlabel.c:597 [inline]
 selinux_netlbl_socket_connect+0xb6/0x100 security/selinux/netlabel.c:615
 selinux_socket_connect+0x5f/0x80 security/selinux/hooks.c:4931
 security_socket_connect+0x50/0xa0 security/security.c:4598
 __sys_connect_file+0xa4/0x190 net/socket.c:2067
 __sys_connect+0x12c/0x170 net/socket.c:2088
 __do_sys_connect net/socket.c:2098 [inline]
 __se_sys_connect net/socket.c:2095 [inline]
 __x64_sys_connect+0x73/0xb0 net/socket.c:2095
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xaa/0x1b0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f901b61a12d
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9019bd6fa8 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: ffffffffffffffda RBX: 00007f901b925fa0 RCX: 00007f901b61a12d
RDX: 000000000000001c RSI: 0000200000000140 RDI: 0000000000000003
RBP: 00007f901b701505 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f901b5b62a0 R15: 00007f9019bb7000
 </TASK>
Modules linked in:

Fixes: ceba1832b1b2 ("calipso: Set the calipso socket label to match the secattr.")
Reported-by: syzkaller <syzkaller@googlegroups.com>
Reported-by: John Cheung <john.cs.hey@gmail.com>
Closes: https://lore.kernel.org/netdev/CAP=Rh=M1LzunrcQB1fSGauMrJrhL6GGps5cPAKzHJXj6GQV+-g@mail.gmail.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Link: https://patch.msgid.link/20250522221858.91240-1-kuniyu@amazon.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlabel/netlabel_kapi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
index 27511c90a26f4..75b645c1928db 100644
--- a/net/netlabel/netlabel_kapi.c
+++ b/net/netlabel/netlabel_kapi.c
@@ -1140,6 +1140,9 @@ int netlbl_conn_setattr(struct sock *sk,
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
 	case AF_INET6:
+		if (sk->sk_family != AF_INET6)
+			return -EAFNOSUPPORT;
+
 		addr6 = (struct sockaddr_in6 *)addr;
 		entry = netlbl_domhsh_getentry_af6(secattr->domain,
 						   &addr6->sin6_addr);
-- 
2.39.5



