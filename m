Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9981F1AA1E6;
	Wed, 20 Nov 2024 12:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107578; cv=none; b=oMdoO9Hz6M9uvrPEIB7/9XYia1FKXSqw3y/zGbiBn+dkyGPV9NYsIasi5ZXJEUckLzRN9BC47UsMyarturUXxx4/uE458qtq2uA5X/8NN4/5KFyDyBqfS0mdj4dVNV0OZxWt73nyX+5uwdFD7P9IsPq4B5V38SPgflJqyoRMxtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107578; c=relaxed/simple;
	bh=ybaW5HgCU+9+KxC+8pNyoUdobb7pAobp+TD4zaDgEsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uyyvEFMdbJwZEd27HcnvT765+FHjyGqmknJw+njhAVTpecfggBS0owPiIqXgPeEmFDssOjc3/bdyjD7/fzOz6rK0cZ3k30HtkdBh0fzEPx3rfPjc9ASRN+PfRUE24sXZTTMlctSE8BxS3l7BXcg/GLDTabiXhiJiVpTco0F/SbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r/rGbcNa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r/rGbcNa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C645C4CECD;
	Wed, 20 Nov 2024 12:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107578;
	bh=ybaW5HgCU+9+KxC+8pNyoUdobb7pAobp+TD4zaDgEsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/rGbcNa10xJ7bNZiaBURGmUThoiDw3zrUyKVdPIVFDkvRCPIJnrbFZPiHkZBWtXi
	 1wFicpYrbyoRj4d7Cin9hcqIr8QwXaeqBB/+3lML5JWLwrMv/7nD4LIldgHJqgR4CF
	 p0XLw5GlJ8y/eHlHTeffb3a+zHexYpmYsVqBehjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 02/82] sctp: fix possible UAF in sctp_v6_available()
Date: Wed, 20 Nov 2024 13:56:12 +0100
Message-ID: <20241120125629.677748520@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit eb72e7fcc83987d5d5595b43222f23b295d5de7f ]

A lockdep report [1] with CONFIG_PROVE_RCU_LIST=y hints
that sctp_v6_available() is calling dev_get_by_index_rcu()
and ipv6_chk_addr() without holding rcu.

[1]
 =============================
 WARNING: suspicious RCU usage
 6.12.0-rc5-virtme #1216 Tainted: G        W
 -----------------------------
 net/core/dev.c:876 RCU-list traversed in non-reader section!!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
 1 lock held by sctp_hello/31495:
 #0: ffff9f1ebbdb7418 (sk_lock-AF_INET6){+.+.}-{0:0}, at: sctp_bind (./arch/x86/include/asm/jump_label.h:27 net/sctp/socket.c:315) sctp

stack backtrace:
 CPU: 7 UID: 0 PID: 31495 Comm: sctp_hello Tainted: G        W          6.12.0-rc5-virtme #1216
 Tainted: [W]=WARN
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
 Call Trace:
  <TASK>
 dump_stack_lvl (lib/dump_stack.c:123)
 lockdep_rcu_suspicious (kernel/locking/lockdep.c:6822)
 dev_get_by_index_rcu (net/core/dev.c:876 (discriminator 7))
 sctp_v6_available (net/sctp/ipv6.c:701) sctp
 sctp_do_bind (net/sctp/socket.c:400 (discriminator 1)) sctp
 sctp_bind (net/sctp/socket.c:320) sctp
 inet6_bind_sk (net/ipv6/af_inet6.c:465)
 ? security_socket_bind (security/security.c:4581 (discriminator 1))
 __sys_bind (net/socket.c:1848 net/socket.c:1869)
 ? do_user_addr_fault (./include/linux/rcupdate.h:347 ./include/linux/rcupdate.h:880 ./include/linux/mm.h:729 arch/x86/mm/fault.c:1340)
 ? do_user_addr_fault (./arch/x86/include/asm/preempt.h:84 (discriminator 13) ./include/linux/rcupdate.h:98 (discriminator 13) ./include/linux/rcupdate.h:882 (discriminator 13) ./include/linux/mm.h:729 (discriminator 13) arch/x86/mm/fault.c:1340 (discriminator 13))
 __x64_sys_bind (net/socket.c:1877 (discriminator 1) net/socket.c:1875 (discriminator 1) net/socket.c:1875 (discriminator 1))
 do_syscall_64 (arch/x86/entry/common.c:52 (discriminator 1) arch/x86/entry/common.c:83 (discriminator 1))
 entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
 RIP: 0033:0x7f59b934a1e7
 Code: 44 00 00 48 8b 15 39 8c 0c 00 f7 d8 64 89 02 b8 ff ff ff ff eb bd 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 b8 31 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 09 8c 0c 00 f7 d8 64 89 01 48
All code
========
   0:	44 00 00             	add    %r8b,(%rax)
   3:	48 8b 15 39 8c 0c 00 	mov    0xc8c39(%rip),%rdx        # 0xc8c43
   a:	f7 d8                	neg    %eax
   c:	64 89 02             	mov    %eax,%fs:(%rdx)
   f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  14:	eb bd                	jmp    0xffffffffffffffd3
  16:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  1d:	00 00 00
  20:	0f 1f 00             	nopl   (%rax)
  23:	b8 31 00 00 00       	mov    $0x31,%eax
  28:	0f 05                	syscall
  2a:*	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax		<-- trapping instruction
  30:	73 01                	jae    0x33
  32:	c3                   	ret
  33:	48 8b 0d 09 8c 0c 00 	mov    0xc8c09(%rip),%rcx        # 0xc8c43
  3a:	f7 d8                	neg    %eax
  3c:	64 89 01             	mov    %eax,%fs:(%rcx)
  3f:	48                   	rex.W

Code starting with the faulting instruction
===========================================
   0:	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax
   6:	73 01                	jae    0x9
   8:	c3                   	ret
   9:	48 8b 0d 09 8c 0c 00 	mov    0xc8c09(%rip),%rcx        # 0xc8c19
  10:	f7 d8                	neg    %eax
  12:	64 89 01             	mov    %eax,%fs:(%rcx)
  15:	48                   	rex.W
 RSP: 002b:00007ffe2d0ad398 EFLAGS: 00000202 ORIG_RAX: 0000000000000031
 RAX: ffffffffffffffda RBX: 00007ffe2d0ad3d0 RCX: 00007f59b934a1e7
 RDX: 000000000000001c RSI: 00007ffe2d0ad3d0 RDI: 0000000000000005
 RBP: 0000000000000005 R08: 1999999999999999 R09: 0000000000000000
 R10: 00007f59b9253298 R11: 0000000000000202 R12: 00007ffe2d0ada61
 R13: 0000000000000000 R14: 0000562926516dd8 R15: 00007f59b9479000
  </TASK>

Fixes: 6fe1e52490a9 ("sctp: check ipv6 addr with sk_bound_dev if set")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20241107192021.2579789-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/ipv6.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 43f2731bf590e..08acda9ecdf56 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -684,7 +684,7 @@ static int sctp_v6_available(union sctp_addr *addr, struct sctp_sock *sp)
 	struct sock *sk = &sp->inet.sk;
 	struct net *net = sock_net(sk);
 	struct net_device *dev = NULL;
-	int type;
+	int type, res, bound_dev_if;
 
 	type = ipv6_addr_type(in6);
 	if (IPV6_ADDR_ANY == type)
@@ -698,14 +698,21 @@ static int sctp_v6_available(union sctp_addr *addr, struct sctp_sock *sp)
 	if (!(type & IPV6_ADDR_UNICAST))
 		return 0;
 
-	if (sk->sk_bound_dev_if) {
-		dev = dev_get_by_index_rcu(net, sk->sk_bound_dev_if);
+	rcu_read_lock();
+	bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
+	if (bound_dev_if) {
+		res = 0;
+		dev = dev_get_by_index_rcu(net, bound_dev_if);
 		if (!dev)
-			return 0;
+			goto out;
 	}
 
-	return ipv6_can_nonlocal_bind(net, &sp->inet) ||
-	       ipv6_chk_addr(net, in6, dev, 0);
+	res = ipv6_can_nonlocal_bind(net, &sp->inet) ||
+	      ipv6_chk_addr(net, in6, dev, 0);
+
+out:
+	rcu_read_unlock();
+	return res;
 }
 
 /* This function checks if the address is a valid address to be used for
-- 
2.43.0



