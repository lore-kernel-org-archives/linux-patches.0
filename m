Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCC33148B2;
	Tue,  2 Sep 2025 13:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820025; cv=none; b=qelCQRaGi067TyBJdOFczILsZrnFlzfRB3+XcgSz4n+oBELgibbRCbO2kh2HZ21M7oRorNfY6HZdjuD15LiV2spzh0TxIYZ4M3kOD4chGrCEha7FnXO/cmDRbEjZjtxu4d3f+jRMHjvtI1h42kbe85NiH9qZ4ZS5pC8H36z/9tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820025; c=relaxed/simple;
	bh=pfriYSCPw0hSOKchjAOGDYo6y/3pdkDd6VUBUJ9PPpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T6AUYNW0B6gBHi/ylOXfPGzkKv8o5ZTMaT+xyMQOOQxYV1LT/i5M5mCgdXd+9mDEkmKmHrRnEYTfcePMzzF9Fq2aOrQ+dCEY13D6G0yJN3h5599wT3VsVL/WWpDCgA46e7LpsZF0o+ddLgPIdASqATQDbBStG72L5tMjh4D5Yi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YFPP04s1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YFPP04s1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A1BC4CEED;
	Tue,  2 Sep 2025 13:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820025;
	bh=pfriYSCPw0hSOKchjAOGDYo6y/3pdkDd6VUBUJ9PPpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YFPP04s1pzFkYsj1IsBtTl8m3WiuoD1BB89Lvk1jffGLOuHaz0eBbaNZwFXF+5c1k
	 d8ViqJm9sYrL8WqjlCcnh4faJ5J7l3S0sj7hLwway48ShwEMFtzHpfhe+C/+uUZ4Mg
	 aSjoCv3fgqGpuNMftjse12QsL4HZyx8tpX4xmrRw=
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
Subject: [PATCH 6.12 62/95] sctp: initialize more fields in sctp_v6_from_sk()
Date: Tue,  2 Sep 2025 15:20:38 +0200
Message-ID: <20250902131941.983606614@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 38e2fbdcbeac4..9f835e674c599 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -546,7 +546,9 @@ static void sctp_v6_from_sk(union sctp_addr *addr, struct sock *sk)
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



