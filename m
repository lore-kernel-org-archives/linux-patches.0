Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3FC256C84;
	Tue, 21 Jul 2026 15:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649338; cv=none; b=ILp01gRwsKtE3ow5cM1hZO7t/fOa1Um2rc5WN7q8oZVvFzxB12sXddXUboH0TcnDXhMFehU5SGbRel/1j/s1aCGlubIcljjc/AabWW0UOJuYPp0nzvAtMOEDwBY7nba4u+DWNl1hKfTic2E8AMI77F0Ki4dN1MHmOom7OdnQpxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649338; c=relaxed/simple;
	bh=HR7RRit4DKZW6QswLD9MGtB2D9ULAi8RlLA5xF0gFjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRF4eWXpqvLV12TIHru+kpLybXMog1YaGvc52M6jzjSzCijnqRnl6uFSToO2QeNWsCIG82LQ6jhbSWl4Hd5qar6SD2mPn8/KTVyRiLhl746zRR6C41ANWYtxHZ/yxdlKrXL4Keocjly/FAoqy7+2HoxuQLbUcYx/6pQB+xDi0+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wc6fyLZn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wc6fyLZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5E81F000E9;
	Tue, 21 Jul 2026 15:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649336;
	bh=ZfqRqjSaD1jvC/huHEXOQ2so/mv+x2arA+rOwvSW+fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wc6fyLZnvRizarJE6gFCWdVIjUiRG9UYPJoIN9yUaJ5XSy2xNQKeSneaKwlQZcKA7
	 Uzsj1XkEpZysne7uHPw1BXJin9BNz/JiVcqPpUAeNxYVyZGtbXN60NQc2W1+9Otu0q
	 kODONHxsjz25Yx7QYxaGejkUDUmPptIWzyqarQ5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sechang Lim <rhkrqnwk98@gmail.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0539/2077] bpf: Fix NULL pointer dereference in bpf_task_from_vpid()
Date: Tue, 21 Jul 2026 17:03:32 +0200
Message-ID: <20260721152605.522975090@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5c1e5c8812b12b..c2032af98e0836 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -2919,11 +2919,13 @@ __bpf_kfunc struct task_struct *bpf_task_from_vpid(s32 vpid)
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



