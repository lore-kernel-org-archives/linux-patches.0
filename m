Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36095158B7;
	Wed, 30 Sep 2026 16:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786837; cv=none; b=W8MKqeVH5ajLdPW6isvlmrOvQQG8soUAWXwOEj2BSx2P1lBOZB4N+n9Kr233ArFL2HrZG0KcUsO7f6TCJa2BZUNJilMhh9JpfzaE7wy6Yl1N1HZ9NL8yHw/u66zd/d75vBROEd6EhijnoifFW660meKJFLq6+UOf9j4tXI7pkjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786837; c=relaxed/simple;
	bh=xPyz+NvAPGGUOrzsodVlSgQCoYuBFjIQKjVffhXW68A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KLLPJgVtocGGWGmaEygY0VToDSB3KWF8KtBBIc/gmH80CM9FuL91h7TAb69OaF0MiZNu8r5SPx20FaAyBw6o5OdV/makUC3WlUVOHaQw21jir9lJCZOTXryBECDjo1yStsFh0CoqtfZ3NQPssITu2xdjX83ZJU5Z0v4FXahQFuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QXEVTtpW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QXEVTtpW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E13B1F0089A;
	Wed, 30 Sep 2026 16:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786835;
	bh=TNQ6k3xxw+Y7qRpZhDtwwSbsytVQvZQdfsK88Px1cmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QXEVTtpW3SbCI677bBQmL/azhfkejX8xFalZQZxWxJk7rGrHKNiaFBhPYUx7Wp0aE
	 pujiIkQDlnm8RYgRx+Hxi2NWGfo90/feeEQ9C/1GuiUw9Pxl0Pu0qdUNLXtMEa1cNh
	 TbbvFaE/rlg/oB8c1DEOb/ihKqd9Lw4OaSp2ny2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 020/457] tcp: Skip cond_resched() in inet_csk_listen_stop() under BPF context
Date: Wed, 30 Sep 2026 17:22:05 +0200
Message-ID: <20260930152346.464116177@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit eaab8cab451b9502ce224cd202550375b894a467 ]

bpf_sock_destroy() runs from the tcp iterator, under rcu_read_lock(). If
the sock is a listener that still has children in its accept queue,
tcp_abort() ends up in inet_csk_listen_stop() and the cond_resched()
there trips the debug check:

BUG: sleeping function called from invalid context at net/ipv4/inet_connection_sock.c:1523
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 628, name: test_progs
preempt_count: 0, expected: 0
RCU nest depth: 1, expected: 0
locks held by test_progs/628: 3, last CPU#3:
 #0: ffff8881158cee18 (&p->lock){+.+.}-{4:4}, at: bpf_seq_read+0x56/0x1210
 #1: ffff8881106bb858 (sk_lock-AF_INET6){+.+.}-{0:0}, at: bpf_iter_tcp_seq_show+0x32b/0x4b0
 #2: ffffffffb435af20 (rcu_read_lock){....}-{1:3}, at: bpf_iter_run_prog+0x46b/0xde0
CPU: 3 UID: 0 PID: 628 Comm: test_progs Tainted: G        W           7.2.0+ #65 PREEMPT
Tainted: [W]=WARN
Call Trace:
 <TASK>
 dump_stack_lvl+0xc1/0xf0
 dump_stack+0x10/0x20
 __might_resched+0x3d2/0x610
 inet_csk_listen_stop+0x7b/0xbf0
 tcp_abort+0x23b/0x3b0
 bpf_sock_destroy+0xfc/0x140
 bpf_prog_448133d24601754f_iter_tcp6_server+0x81/0x8a
 bpf_iter_run_prog+0x538/0xde0
 bpf_iter_tcp_seq_show+0x26b/0x4b0
 bpf_seq_read+0x424/0x1210
 vfs_read+0x197/0xe40
 ksys_read+0x119/0x240
 __x64_sys_read+0x72/0xc0
 x64_sys_call+0x647/0x27e0
 do_syscall_64+0xe5/0x610
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7fad39b28aca
RSP: 002b:00007ffc381c61c0 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 00007ffc381c6a88 RCX: 00007fad39b28aca
RDX: 0000000000000032 RSI: 00007ffc381c6250 RDI: 0000000000000014
RBP: 00007ffc381c61e0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
R13: 0000000000000000 R14: 000055f077c1bbb0 R15: 00007fad3a0f3000
 </TASK>

The commit that added the kfunc already guards lock_sock() in tcp_abort()
and udp_abort() with has_current_bpf_ctx(), but missed the listener path.
Do the same for the cond_resched(). The loop runs inside the iterator's
rcu_read_lock(), it must not reschedule or report a quiescent state there.

Fixes: 4ddbcb886268 ("bpf: Add bpf_sock_destroy kfunc")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://lore.kernel.org/r/20260910112736.153710-1-jiayuan.chen@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_connection_sock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 6257459bcee24..6a30f11384547 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1520,7 +1520,8 @@ void inet_csk_listen_stop(struct sock *sk)
 		local_bh_enable();
 		sock_put(child);
 
-		cond_resched();
+		if (!has_current_bpf_ctx())
+			cond_resched();
 	}
 	if (queue->fastopenq.rskq_rst_head) {
 		/* Free all the reqs queued in rskq_rst_head. */
-- 
2.53.0



