Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842EF171B9
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:33:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C5FC433D2;
	Wed,  7 Jun 2023 20:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170014;
	bh=SYJdGkSCNix6ZGpqFaNlKMG2GT4tdVI7s0eJPeLpRiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=noh2oWkKb8u2J4v9/2G3sADaqmnTAOyL6lSyWm/txV0vg2eLZ+VBR0OIpAiRR89yU
	 fHzPYXNTUOfjdNOhVoWHqSY2B1DSRWq1/3iyiXdy1cQoROp0COgXaoJkEWI+McOhwC
	 ffL/5DtoYuAZct5v1YKADQ5/38grqeEzpqncj8Zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzkaller <syzkaller@googlegroups.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 13/88] af_packet: Fix data-races of pkt_sk(sk)->num.
Date: Wed,  7 Jun 2023 22:15:30 +0200
Message-ID: <20230607200858.083960243@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200854.030202132@linuxfoundation.org>
References: <20230607200854.030202132@linuxfoundation.org>
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

[ Upstream commit 822b5a1c17df7e338b9f05d1cfe5764e37c7f74f ]

syzkaller found a data race of pkt_sk(sk)->num.

The value is changed under lock_sock() and po->bind_lock, so we
need READ_ONCE() to access pkt_sk(sk)->num without these locks in
packet_bind_spkt(), packet_bind(), and sk_diag_fill().

Note that WRITE_ONCE() is already added by commit c7d2ef5dd4b0
("net/packet: annotate accesses to po->bind").

BUG: KCSAN: data-race in packet_bind / packet_do_bind

write (marked) to 0xffff88802ffd1cee of 2 bytes by task 7322 on cpu 0:
 packet_do_bind+0x446/0x640 net/packet/af_packet.c:3236
 packet_bind+0x99/0xe0 net/packet/af_packet.c:3321
 __sys_bind+0x19b/0x1e0 net/socket.c:1803
 __do_sys_bind net/socket.c:1814 [inline]
 __se_sys_bind net/socket.c:1812 [inline]
 __x64_sys_bind+0x40/0x50 net/socket.c:1812
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3b/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x72/0xdc

read to 0xffff88802ffd1cee of 2 bytes by task 7318 on cpu 1:
 packet_bind+0xbf/0xe0 net/packet/af_packet.c:3322
 __sys_bind+0x19b/0x1e0 net/socket.c:1803
 __do_sys_bind net/socket.c:1814 [inline]
 __se_sys_bind net/socket.c:1812 [inline]
 __x64_sys_bind+0x40/0x50 net/socket.c:1812
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3b/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x72/0xdc

value changed: 0x0300 -> 0x0000

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 7318 Comm: syz-executor.4 Not tainted 6.3.0-13380-g7fddb5b5300c #4
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014

Fixes: 96ec6327144e ("packet: Diag core and basic socket info dumping")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/20230524232934.50950-1-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 4 ++--
 net/packet/diag.c      | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index aa12bee4133a9..7409e042305d4 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3219,7 +3219,7 @@ static int packet_bind_spkt(struct socket *sock, struct sockaddr *uaddr,
 	memcpy(name, uaddr->sa_data, sizeof(uaddr->sa_data));
 	name[sizeof(uaddr->sa_data)] = 0;
 
-	return packet_do_bind(sk, name, 0, pkt_sk(sk)->num);
+	return packet_do_bind(sk, name, 0, READ_ONCE(pkt_sk(sk)->num));
 }
 
 static int packet_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
@@ -3237,7 +3237,7 @@ static int packet_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len
 		return -EINVAL;
 
 	return packet_do_bind(sk, NULL, sll->sll_ifindex,
-			      sll->sll_protocol ? : pkt_sk(sk)->num);
+			      sll->sll_protocol ? : READ_ONCE(pkt_sk(sk)->num));
 }
 
 static struct proto packet_proto = {
diff --git a/net/packet/diag.c b/net/packet/diag.c
index d9f912ad23dfa..ecabf78d29b8e 100644
--- a/net/packet/diag.c
+++ b/net/packet/diag.c
@@ -142,7 +142,7 @@ static int sk_diag_fill(struct sock *sk, struct sk_buff *skb,
 	rp = nlmsg_data(nlh);
 	rp->pdiag_family = AF_PACKET;
 	rp->pdiag_type = sk->sk_type;
-	rp->pdiag_num = ntohs(po->num);
+	rp->pdiag_num = ntohs(READ_ONCE(po->num));
 	rp->pdiag_ino = sk_ino;
 	sock_diag_save_cookie(sk, rp->pdiag_cookie);
 
-- 
2.39.2



