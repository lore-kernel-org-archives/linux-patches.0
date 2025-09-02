Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1238332A81A;
	Tue,  2 Sep 2025 13:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820504; cv=none; b=NZs7xR1dc9yAeMQSd2LT46UF4LkmualnhIBned47lQvw0/vj7hOt0fkCHvibCrhxJaHK1yw9IsO+rWM2INHjxNxakyGUdRgQ2RrkcXz70cP5XxxXQAePXXwl4xD0/FS+tNuBAaUDykcslwGMH3OVsa4uPWbJdeqSp4TJYI7x980=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820504; c=relaxed/simple;
	bh=QWTvrnAXtkBTrfmFgTLPXCjCRu3C8+vhS0JTTWDMQ88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TX4YCDvEdTdl4+BmKvFp0Gz5kEWR76/PjWZt+f5Dk+LM3xUU8BBPfaNsjo8R+xKTe1RMWEzqBgDZlQIHgGM6wq71Hi5t1PuN9E6SzkuUOSDjfMIBDefRc0axm63znjJ3F4SbaeW8LmjwTHHwernGKUCQ1U3mXa21zwnxJGQA4Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YmtaOF8v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YmtaOF8v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9395FC4CEED;
	Tue,  2 Sep 2025 13:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820503;
	bh=QWTvrnAXtkBTrfmFgTLPXCjCRu3C8+vhS0JTTWDMQ88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YmtaOF8vLfsyxg4Gkp/jr3uq/GOs9rSyHHHHSwar7WTIlrJZxi6MKJDP3mB6Rz13y
	 o0SyeZ+y74qEfC8l/cfypWOBmkfc63ABcxR40eK494aW339AC45u95NfqE7kg6uTk3
	 sYBqntAePRxg+FrcJ7zjs6Lc/t4xmwPu4a6XH20o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e69f06a0f30116c68056@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 33/50] sctp: initialize more fields in sctp_v6_from_sk()
Date: Tue,  2 Sep 2025 15:21:24 +0200
Message-ID: <20250902131931.834827603@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131930.509077918@linuxfoundation.org>
References: <20250902131930.509077918@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 2e8750469242cad8f01f320131fd5a6f540dbb99 ]

syzbot found that sin6_scope_id was not properly initialized,
leading to undefined behavior.

Clear sin6_scope_id and sin6_flowinfo.

BUG: KMSAN: uninit-value in __sctp_v6_cmp_addr+0x887/0x8c0 net/sctp/ipv6.c:649
  __sctp_v6_cmp_addr+0x887/0x8c0 net/sctp/ipv6.c:649
  sctp_inet6_cmp_addr+0x4f2/0x510 net/sctp/ipv6.c:983
  sctp_bind_addr_conflict+0x22a/0x3b0 net/sctp/bind_addr.c:390
  sctp_get_port_local+0x21eb/0x2440 net/sctp/socket.c:8452
  sctp_get_port net/sctp/socket.c:8523 [inline]
  sctp_listen_start net/sctp/socket.c:8567 [inline]
  sctp_inet_listen+0x710/0xfd0 net/sctp/socket.c:8636
  __sys_listen_socket net/socket.c:1912 [inline]
  __sys_listen net/socket.c:1927 [inline]
  __do_sys_listen net/socket.c:1932 [inline]
  __se_sys_listen net/socket.c:1930 [inline]
  __x64_sys_listen+0x343/0x4c0 net/socket.c:1930
  x64_sys_call+0x271d/0x3e20 arch/x86/include/generated/asm/syscalls_64.h:51
  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
  do_syscall_64+0xd9/0x210 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Local variable addr.i.i created at:
  sctp_get_port net/sctp/socket.c:8515 [inline]
  sctp_listen_start net/sctp/socket.c:8567 [inline]
  sctp_inet_listen+0x650/0xfd0 net/sctp/socket.c:8636
  __sys_listen_socket net/socket.c:1912 [inline]
  __sys_listen net/socket.c:1927 [inline]
  __do_sys_listen net/socket.c:1932 [inline]
  __se_sys_listen net/socket.c:1930 [inline]
  __x64_sys_listen+0x343/0x4c0 net/socket.c:1930

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+e69f06a0f30116c68056@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/68adc0a2.050a0220.37038e.00c4.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20250826141314.1802610-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/ipv6.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index d081858c2d073..a1cb8ac0408af 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -547,7 +547,9 @@ static void sctp_v6_from_sk(union sctp_addr *addr, struct sock *sk)
 {
 	addr->v6.sin6_family = AF_INET6;
 	addr->v6.sin6_port = 0;
+	addr->v6.sin6_flowinfo = 0;
 	addr->v6.sin6_addr = sk->sk_v6_rcv_saddr;
+	addr->v6.sin6_scope_id = 0;
 }
 
 /* Initialize sk->sk_rcv_saddr from sctp_addr. */
-- 
2.50.1



