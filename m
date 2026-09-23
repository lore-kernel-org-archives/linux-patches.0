Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2B239A07C;
	Wed, 23 Sep 2026 14:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173168; cv=none; b=PS2Ayax20s1nUpYXpc52FVfmH16OmQw9Hc7v8Hn2i7LUfR0NsTzp9U9A0MZvA63O82ms+emuZoAc9IL3n6u2wXFKqDvgU+I4buKb982fZVFon/ZqyGz3g3bPGfLJung6ARQI3Cib7gvFwcEO0v7Uh0nvK3SH7Wad0Br3sXTUJ40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173168; c=relaxed/simple;
	bh=paZLMpods6L5fGzzZDKXVSbLQKRaMA8FPEPUKxNfFeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=srZjQOnNLL26QZMHiqg6VSm7N0BtZGKMdY0iPHL9dtprda5UsyWFDQIhAEqZNB8t/z0NNQdWVhVkxM4Udpy4/jqP2V1JEbim41UUj14VXoXRbVez+E9NP3rQ2Nf0LgWgetK8KeZWMSTeZlF64rIg9FZQcVl5JzuFASQCZlQa/NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TthgXL0v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TthgXL0v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 116411F00893;
	Wed, 23 Sep 2026 14:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173166;
	bh=1TJTomzgZGEBilREInS7xUjvgpXSJ/mKAsAtiadZIJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TthgXL0vdPcmw8Um6hRuhotjhruRcaWQCdICHcpEVWSRSGSNaFuzdxpsMQ/6JswkU
	 51C6wmzZKSSIc8t7JrWdLlgSHXRVcI8lkpe8iAFfnCuWhGxvwUpnS/3ckCT9DgYpek
	 LyUrQBDnnk5RYM0NYRjo6Y6OpQR1BZDSryVKXKxM=
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
Subject: [PATCH 7.2 162/438] tcp: Dont call skb_clone_and_charge_r() for close()d listener in tcp_v6_do_rcv().
Date: Wed, 23 Sep 2026 16:03:03 +0200
Message-ID: <20260923140648.971210459@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index df9c29eb5c1f4..7fa4ed2fd4f16 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1604,7 +1604,8 @@ int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
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



