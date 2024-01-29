Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5964C157053;
	Mon, 29 Jan 2024 17:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548147; cv=none; b=OMRZbUDLyCF6hyY1VK1jc9OvAomIDAL3xxO2by1AtecOvY3IAlmnMe4lOm7R4qaHE7tLD2t0Ie+uAPWJElFJU5WL7EWLJL7XabqET/j0WajpxC+HpPFAHloWEhtX/kNy4dTUKlaa09r8121MS+KIA7d9IDOjTbE4j5IOGcWw+Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548147; c=relaxed/simple;
	bh=KoMqMszHfLr55pgm5OcAqLoVAIOAWi/VyvZZskEsaN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q9biMgsYauqIhb0wx88sFoCvKszgSEN1io9fu0/a3JCYlJEBfagxzyigjtZ/JhsSYWE5wHR2K+MSRidMtsVvew49l5HZD9FwxGFQJmu0T5Dej3Kf6Et/HeA2zmG5sCU2NRsMX/YAkNymmkgL3bg7zE+fH4cKEWoXK8SzQUDgfac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FZM/tsla; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FZM/tsla"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D36C43390;
	Mon, 29 Jan 2024 17:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548147;
	bh=KoMqMszHfLr55pgm5OcAqLoVAIOAWi/VyvZZskEsaN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FZM/tsla9kzS8KzmDhvJFMLrEZhS7zms3LZRVSaucGS61fzAWtyFaful5NbmQ1aNj
	 s9S1Eu5ad0q7ULhUGVePArIGHRqJZZeRoVBFoBXU1LjtDc8jXI4NMC86kZ4zmQf68J
	 uu6JHCPgrOObYcKKjrwyXTfz4BsjT/enfALKq1c4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 183/346] ipv6: init the accept_queues spinlocks in inet6_create
Date: Mon, 29 Jan 2024 09:03:34 -0800
Message-ID: <20240129170021.779329707@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 435e202d645c197dcfd39d7372eb2a56529b6640 ]

In commit 198bc90e0e73("tcp: make sure init the accept_queue's spinlocks
once"), the spinlocks of accept_queue are initialized only when socket is
created in the inet4 scenario. The locks are not initialized when socket
is created in the inet6 scenario. The kernel reports the following error:
INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
Call Trace:
<TASK>
	dump_stack_lvl (lib/dump_stack.c:107)
	register_lock_class (kernel/locking/lockdep.c:1289)
	__lock_acquire (kernel/locking/lockdep.c:5015)
	lock_acquire.part.0 (kernel/locking/lockdep.c:5756)
	_raw_spin_lock_bh (kernel/locking/spinlock.c:178)
	inet_csk_listen_stop (net/ipv4/inet_connection_sock.c:1386)
	tcp_disconnect (net/ipv4/tcp.c:2981)
	inet_shutdown (net/ipv4/af_inet.c:935)
	__sys_shutdown (./include/linux/file.h:32 net/socket.c:2438)
	__x64_sys_shutdown (net/socket.c:2445)
	do_syscall_64 (arch/x86/entry/common.c:52)
	entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:129)
RIP: 0033:0x7f52ecd05a3d
Code: 5b 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa 48 89 f8 48 89 f7
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
ff 73 01 c3 48 8b 0d ab a3 0e 00 f7 d8 64 89 01 48
RSP: 002b:00007f52ecf5dde8 EFLAGS: 00000293 ORIG_RAX: 0000000000000030
RAX: ffffffffffffffda RBX: 00007f52ecf5e640 RCX: 00007f52ecd05a3d
RDX: 00007f52ecc8b188 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 00007f52ecf5de20 R08: 00007ffdae45c69f R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000293 R12: 00007f52ecf5e640
R13: 0000000000000000 R14: 00007f52ecc8b060 R15: 00007ffdae45c6e0

Fixes: 198bc90e0e73 ("tcp: make sure init the accept_queue's spinlocks once")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240122102001.2851701-1-shaozhengchao@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/af_inet6.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 13a1833a4df5..959bfd9f6344 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -199,6 +199,9 @@ static int inet6_create(struct net *net, struct socket *sock, int protocol,
 	if (INET_PROTOSW_REUSE & answer_flags)
 		sk->sk_reuse = SK_CAN_REUSE;
 
+	if (INET_PROTOSW_ICSK & answer_flags)
+		inet_init_csk_locks(sk);
+
 	inet = inet_sk(sk);
 	inet_assign_bit(IS_ICSK, sk, INET_PROTOSW_ICSK & answer_flags);
 
-- 
2.43.0



