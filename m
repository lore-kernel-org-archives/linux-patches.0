Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3C73128B1;
	Tue,  2 Sep 2025 13:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819738; cv=none; b=DDvZFVrljxna1gpvJfPhZ9y5A4v+36z+01Slm1QBMv2vxUYehDw+pX8HW5fm4zdl8WIJ9jp84QPOi6C3FXuhq/zESB6t/202F092M7fpBEe3fwrP0sxNbTf8vHts9M1Ey7oVSt0fjrRamX9lyikSZ+PNU1ocuCigvLwMA2O+3gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819738; c=relaxed/simple;
	bh=fndUhGcFBiZ1UQAze7WXCl83THLNrFaz6XIAk3Tt080=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DBuSLELbMua1nzpMHW+CuUeQMavEvcscjfRnG7bWS8T6CfREWeomCFJ3gx3yb7yVtnvzJVZgc0VA6yABzxbMOqg08FfTdqU7+LzOk8bwOXsfUeYRLxTpqf/InaKAYJsu8dpROBFNE39+FLmhSoU1cx8lOuLDUVvZe+v1icV0UqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g7G6a7UN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g7G6a7UN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DE5C4CEED;
	Tue,  2 Sep 2025 13:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819738;
	bh=fndUhGcFBiZ1UQAze7WXCl83THLNrFaz6XIAk3Tt080=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g7G6a7UNl9nelNqjr64HxAhzfaKV2IZotWuqHWSNotdVPMvTxr1ySHycnX6eQ1kND
	 gUsNVAkap5XsF2XRCk3ld3JrLNfxD09go33nlv74oCi7Qz5PuTuFrPZ6IxiUQMIIza
	 ojiIQIf0VvGjB0KCQhVlYWNswoN+W5A4aKS0h09w=
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
Subject: [PATCH 6.16 097/142] sctp: initialize more fields in sctp_v6_from_sk()
Date: Tue,  2 Sep 2025 15:19:59 +0200
Message-ID: <20250902131951.986312455@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index a9ed2ccab1bdb..2bb5e19e10caa 100644
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



