Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DBD218942;
	Tue, 12 Nov 2024 10:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408196; cv=none; b=Lm0E1WcDtXZnc2N2+o4IT7QukHxW7L/qlq9gzeMJrL7xc9HZLido4lSRo2L4jvw7VhGdAul2TRW7F2a6jF39zNPgb8RuQ1CyUyk/hdkDp5A087DSMkIPqpTzSkoVhIbSM0JSuDPAhEE2lZrgNedbaJADOFR5wmQ6IbQoLJ7K1Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408196; c=relaxed/simple;
	bh=9CN8cE3SYGlsx2nDA+Lm5/VkQ10wXzEQ69s0lEMGMJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZ1aMkt2PzArG3xYoDJxd7L5PIEM4zWrUWUZ3+j5os1cky4ZDHDK+NtDowj4HlVwK7iCmm3s7Fm9W1m7nJK2yigC3MwxqnzlxfvvMrLDNcnjboI2mE34ultt8IatXa87YemktVWbWK4qt5pUdBjDkKi3P2pNBOHlmosriLiULc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HSmEinxz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HSmEinxz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC59C4CECD;
	Tue, 12 Nov 2024 10:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408196;
	bh=9CN8cE3SYGlsx2nDA+Lm5/VkQ10wXzEQ69s0lEMGMJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HSmEinxz82mhazWZQvvPiV01P2OQTNSdEVvoc2Yi86UyjweGr5OzYN0Ek/0yimE7C
	 LL8eNlC5OpVTTI1Tzaqqn8F4Btnzm49LwIkyNopkPGNqFLZAokpKwTqf0ZGghDE7TQ
	 kGuw7ThnvPX0MbQzQCOU+uz/26dLKl11kTxqlzt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Ignat Korchagin <ignat@cloudflare.com>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 062/184] net/smc: do not leave a dangling sk pointer in __smc_create()
Date: Tue, 12 Nov 2024 11:20:20 +0100
Message-ID: <20241112101903.239177077@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d293958a8595ba566fb90b99da4d6263e14fee15 ]

Thanks to commit 4bbd360a5084 ("socket: Print pf->create() when
it does not clear sock->sk on failure."), syzbot found an issue with AF_SMC:

smc_create must clear sock->sk on failure, family: 43, type: 1, protocol: 0
 WARNING: CPU: 0 PID: 5827 at net/socket.c:1565 __sock_create+0x96f/0xa30 net/socket.c:1563
Modules linked in:
CPU: 0 UID: 0 PID: 5827 Comm: syz-executor259 Not tainted 6.12.0-rc6-next-20241106-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
 RIP: 0010:__sock_create+0x96f/0xa30 net/socket.c:1563
Code: 03 00 74 08 4c 89 e7 e8 4f 3b 85 f8 49 8b 34 24 48 c7 c7 40 89 0c 8d 8b 54 24 04 8b 4c 24 0c 44 8b 44 24 08 e8 32 78 db f7 90 <0f> 0b 90 90 e9 d3 fd ff ff 89 e9 80 e1 07 fe c1 38 c1 0f 8c ee f7
RSP: 0018:ffffc90003e4fda0 EFLAGS: 00010246
RAX: 099c6f938c7f4700 RBX: 1ffffffff1a595fd RCX: ffff888034823c00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 00000000ffffffe9 R08: ffffffff81567052 R09: 1ffff920007c9f50
R10: dffffc0000000000 R11: fffff520007c9f51 R12: ffffffff8d2cafe8
R13: 1ffffffff1a595fe R14: ffffffff9a789c40 R15: ffff8880764298c0
FS:  000055557b518380(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa62ff43225 CR3: 0000000031628000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
  sock_create net/socket.c:1616 [inline]
  __sys_socket_create net/socket.c:1653 [inline]
  __sys_socket+0x150/0x3c0 net/socket.c:1700
  __do_sys_socket net/socket.c:1714 [inline]
  __se_sys_socket net/socket.c:1712 [inline]

For reference, see commit 2d859aff775d ("Merge branch
'do-not-leave-dangling-sk-pointers-in-pf-create-functions'")

Fixes: d25a92ccae6b ("net/smc: Introduce IPPROTO_SMC")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Ignat Korchagin <ignat@cloudflare.com>
Cc: D. Wythe <alibuda@linux.alibaba.com>
Cc: Dust Li <dust.li@linux.alibaba.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Link: https://patch.msgid.link/20241106221922.1544045-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 8e3093938cd22..c61a02aba319a 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -3367,8 +3367,10 @@ static int __smc_create(struct net *net, struct socket *sock, int protocol,
 	else
 		rc = smc_create_clcsk(net, sk, family);
 
-	if (rc)
+	if (rc) {
 		sk_common_release(sk);
+		sock->sk = NULL;
+	}
 out:
 	return rc;
 }
-- 
2.43.0



