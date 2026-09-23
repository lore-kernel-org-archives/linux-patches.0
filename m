Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5C3517BAA;
	Wed, 23 Sep 2026 14:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174506; cv=none; b=qf/QQUFbyvHkflIHCzo2809CRRWjH5TKFNPrTLI2S7HNF8n2Llg2d1JOYGNMYUrNGDCYGyH2oand5ghY5ajTNUOvtdWok8P7xjh9mmZnwdrWqwl/UIMDL8+bGebMF9HcnRSDI+c3OHCCbtpsfsz1VwgMXaJi9pvItNoLcW9lQkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174506; c=relaxed/simple;
	bh=+PJ2FgmDCYnHt1KUOhKBB3hCfEOR68+HWoUckESfaJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XxyzqziFY2hYPF0yyQ14elSsmLiAgm/2xQqEq0t6b+PgV/Gm+3F+7pbOKOmWFlqid3KF+9XUHkK3CzzUO9bvUoBfiuIqi3XlS7CkyW2ttsu39tDzcFx9VSIW4Db080QlXtFX/dEuFNA6b5BPDoN9pRjvvPHFS49j4HHa/2U/c6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s6MJmCXj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s6MJmCXj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221E91F000FF;
	Wed, 23 Sep 2026 14:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174504;
	bh=C7I16SndJobe0a7jlhU3cyVXIKlk3ua3X0yD1Td5nqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s6MJmCXj/gEmAxC16G9UUZO3MJ8s3UapIZVWlPUtsgkEz5zV2lAHijkOUOSp/pr1E
	 imoXEHh6/vWnpHhidmqm85BjD7zoyDJXBkj23PNGjhNa0+KIKMLvvEAJaAD1b3Pr+2
	 RUh4k/X5Yk0Gddh3Q/pliLSfTd4YdXg+b1Xem/z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taras Madan <tarasmadan@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 135/398] tcp: Dont call skb_clone_and_charge_r() for close()d listener in tcp_v6_do_rcv().
Date: Wed, 23 Sep 2026 16:03:29 +0200
Message-ID: <20260923140646.934011956@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 8e759cd1f6444a946bd1fd2b2b29eea582eea1d5 ]

tcp_v6_do_rcv() no longer calls skb_clone_and_charge_r() for
TCP_LISTEN since commit 073d89808c06 ("net: fix data-races around
sk->sk_forward_alloc").

However, there is still a small race window between tcp_v6_rcv()
and tcp_v6_do_rcv(), where concurrent close() changes TCP_LISTEN
to TCP_CLOSE, causing skb_clone_and_charge_r() to be called
locklessly and resulting in the splat below. [0]

Let's avoid calling skb_clone_and_charge_r() for TCP_CLOSE as well.

This is fine for non-listeners because tcp_rcv_state_process()
drops skb for TCP_CLOSE and opt_skb was freed immediately anyway.

[0]:
sk->sk_forward_alloc
WARNING: net/ipv4/af_inet.c:162 at inet_sock_destruct+0x64d/0x810 net/ipv4/af_inet.c:162, CPU#1: ksoftirqd/1/28
Modules linked in:
CPU: 1 UID: 0 PID: 28 Comm: ksoftirqd/1 Not tainted 7.2.0 #17 PREEMPT(full)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.17.0-debian-1.17.0-1 04/01/2014
RIP: 0010:inet_sock_destruct+0x64d/0x810 net/ipv4/af_inet.c:162
Code: 3d 49 ff e9 06 fd ff ff e8 d0 5b 83 f8 90 0f 0b 90 e9 35 fe ff ff e8 c2 5b 83 f8 90 0f 0b 90 e9 c5 fe ff ff e8 b4 5b 83 f8 90 <0f> 0b 90 e9 04 ff ff ff e8 a6 5b 83 f8 90 0f 0b 90 e9 65 fe ff ff
RSP: 0018:ffffc90000677bb8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8880117bde80 RCX: ffffffff8957eb41
RDX: ffff88801dad5d00 RSI: ffffffff8957ec3c RDI: 0000000000000005
RBP: 00000000fffff000 R08: ffffffff8957eb41 R09: 00000000fffff000
R10: 0000000000000005 R11: 0000000000000000 R12: dffffc0000000000
R13: ffff8880117bdf10 R14: ffffffff81c08eb7 R15: 0000000000000003
FS:  0000000000000000(0000) GS:ffff8880d7ae5000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f93a1021138 CR3: 00000000207a9000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 __sk_destruct+0x82/0xae0 net/core/sock.c:2356
 rcu_do_batch kernel/rcu/tree.c:2645 [inline]
 rcu_core+0x59c/0x1100 kernel/rcu/tree.c:2897
 handle_softirqs+0x1e4/0x9b0 kernel/softirq.c:622
 run_ksoftirqd kernel/softirq.c:1076 [inline]
 run_ksoftirqd+0x38/0x60 kernel/softirq.c:1068
 smpboot_thread_fn+0x458/0xc80 kernel/smpboot.c:160
 kthread+0x396/0x4a0 kernel/kthread.c:436
 ret_from_fork+0x8e0/0xe40 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Fixes: e994b2f0fb92 ("tcp: do not lock listener to process SYN packets")
Reported-by: Taras Madan <tarasmadan@google.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260914011420.115556-1-kuniyu@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/tcp_ipv6.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index aca71fbb6c292..761cafdc8d2e8 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1618,7 +1618,8 @@ int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 	   by tcp. Feel free to propose better solution.
 					       --ANK (980728)
 	 */
-	if (np->rxopt.all && sk->sk_state != TCP_LISTEN)
+	if (np->rxopt.all &&
+	    !((1 << sk->sk_state) & (TCPF_LISTEN | TCPF_CLOSE)))
 		opt_skb = skb_clone_and_charge_r(skb, sk);
 
 	if (sk->sk_state == TCP_ESTABLISHED) { /* Fast path */
-- 
2.53.0



