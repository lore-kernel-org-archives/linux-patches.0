Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138344C8FE4;
	Tue, 21 Jul 2026 17:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656479; cv=none; b=F+1euaSAFssiq54RzJwUM35QCPYM02/wEQsbgcAfRpyPvKjXyt4gAg6GFr3qr2tC8ZHjcLuE4kUpbw3KFd+bFDc7yGnNEwhTxUN/lLPMxkZk3QorVI4UA1GSHYQwS/NWTVakOP+tSDw+asANfhoOq5bL+ydxfqpEzONknaGRx7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656479; c=relaxed/simple;
	bh=x1Mt+m/Ts0IZ01rKrpbpcL9BK9OOkKLel/8lcQzWnfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J3do0Bh8/qAggqk2P8DPyECZQxGrpvoMROlbB7eXCp3qRXI1z5jadmnOsrfsBuuaE0cntKygoLUD5BVCl/WuVVc7zhmOL/ABi6hNXuwn5TaYual3xl7BEibnmegUHFV3ymbqw1fNwQMVICGUiq+ZFoIytWK/Pmuh+8flc3Fsw+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ha87rJ2J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ha87rJ2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 550021F000E9;
	Tue, 21 Jul 2026 17:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656476;
	bh=QXnY3PkBFEvI1ofTVZmCap0IV1bSQvF3ryQj37RXHns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ha87rJ2J5BC3Jw9uH7zxwaYQ/R5NMsj9B6bVJ7tGYMcvISM99pD40FWZgoR+dBeQr
	 OwGCp8pwdE2MqWEUf1VjA7/IS1HZBznOzI9TZSzqFk6VszpH/0OSpXWdN7MFTGTtro
	 MrJj4f2wWC2p2ESJ4hxvNclKZpXVoTB+25C5o0pY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sechang Lim <rhkrqnwk98@gmail.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0375/1611] bpf: Fix NULL pointer dereference in bpf_task_from_vpid()
Date: Tue, 21 Jul 2026 17:08:11 +0200
Message-ID: <20260721152523.619027037@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Sechang Lim <rhkrqnwk98@gmail.com>

[ Upstream commit 50dff00615522f3ec03449680ca23beb4cfc549c ]

bpf_task_from_vpid() looks up a task in the pid namespace of the
current task, via find_task_by_vpid():

  find_task_by_vpid(vpid)
    find_task_by_pid_ns(vpid, task_active_pid_ns(current))
      find_pid_ns(nr, ns) -> idr_find(&ns->idr, nr)

cgroup_skb programs run in softirq, which may interrupt a task that is
itself in do_exit(). Once that task has passed
exit_notify() -> release_task() -> __unhash_process(), its thread_pid is
cleared, so task_active_pid_ns(current) returns NULL and find_pid_ns()
dereferences &NULL->idr:

  BUG: kernel NULL pointer dereference, address: 0000000000000050
  RIP: 0010:idr_find+0x11/0x30 lib/idr.c:176
  Call Trace:
   <IRQ>
   find_pid_ns kernel/pid.c:370 [inline]
   find_task_by_pid_ns+0x3b/0xe0 kernel/pid.c:485
   bpf_task_from_vpid+0x5b/0x200 kernel/bpf/helpers.c:2916
   bpf_prog_run_array_cg+0x17e/0x530 kernel/bpf/cgroup.c:81
   __cgroup_bpf_run_filter_skb+0x12b/0x250 kernel/bpf/cgroup.c:1612
   sk_filter_trim_cap+0x1dc/0x4c0 net/core/filter.c:148
   tcp_v4_rcv+0x18d1/0x2200 net/ipv4/tcp_ipv4.c:2223
   </IRQ>
   <TASK>
   do_exit+0xa63/0x1270 kernel/exit.c:1010
   get_signal+0x141c/0x1530 kernel/signal.c:3037

Bail out when current has no pid namespace.

Fixes: 675c3596ff32 ("bpf: Add bpf_task_from_vpid() kfunc")
Signed-off-by: Sechang Lim <rhkrqnwk98@gmail.com>
Acked-by: Leon Hwang <leon.hwang@linux.dev>
Link: https://lore.kernel.org/bpf/20260608050001.2545245-1-rhkrqnwk98@gmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index a62cbdf5a3cde5..7357ddc1fc9283 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -2672,11 +2672,13 @@ __bpf_kfunc struct task_struct *bpf_task_from_vpid(s32 vpid)
 {
 	struct task_struct *p;
 
-	rcu_read_lock();
+	guard(rcu)();
+	if (!task_active_pid_ns(current))
+		return NULL;
+
 	p = find_task_by_vpid(vpid);
 	if (p)
 		p = bpf_task_acquire(p);
-	rcu_read_unlock();
 
 	return p;
 }
-- 
2.53.0



