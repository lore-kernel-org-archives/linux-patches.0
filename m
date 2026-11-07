Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063651;
	b=I8RNnyRgw1red/Opq4WxpvbwtK9E1PMZ7eiZk1btehtGbZGIZDpEjd9DU53XreyTMVQV
	 xI/3hsR9CgT9SYNhiNhLyfjGJIHde5iiLU8BFesze4h8xh1okN8xVfdwHmCkIqMIu76A6
	 CxQiSDREC9Ar+2TB1ADCWMN2CP+KLb6CNoQdGUeh+GNPt6ToG3ZSGp7LOB76ZSJ1eKH9o
	 vzL0SD6sd786TywbDS4NzT232Z9OA5zczDJAFWBe4UxOm7ubGELrhEbuH+cA/xk7l45s4
	 FR4h/H8QchMmGgqwmahwGwzWXZxRVNZGiGQhNms6Nxhq/qxLf8gwlJ35VHBn7FXZdbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063651;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mbQjr5k0WQWacovhPIw9kly20ztdUIQTh94loln8zP4=;
	b=im8GQlOk/1KjO5QZo4l9wr6E1x3Pb+6g6wqbQ0lxvB3LSy6p5tcFaHcrr1dZ7ZyZEu96
	 at7G1AKGJWoUrSoX5aglbUmksSsSi9gK3UVq0DiCLw/81UNPW2EDPNKcHDwCCkQeULFdW
	 y0vnrRCOnABgtQn5/Zb7mxxX6XpfIdH6ixOyNcvT2QGsirK2wLiqtK2y5A+3NWWDuCUMb
	 69yUyaUlZu9VP/maNEGneybc5C23ShRIoJE8+byOUXlh792fWnnLhqkyNFhelgftcR9zl
	 73t80HfPqjFvkOwK2sHLqVU1Q5xcC3usOhtUm7FufEHSH4piMCPUb7+On5cQgZ/oqeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lOlRCoDN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7FC606A9C9;
	Sat,  7 Nov 2026 15:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lOlRCoDN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F281F0089F;
	Sat,  7 Nov 2026 15:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063650;
	bh=mbQjr5k0WQWacovhPIw9kly20ztdUIQTh94loln8zP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lOlRCoDNGCrlTtLpXvInqoBGZLPG2AcJwHGtmZ+cI6tlR6ODou4J1uBGFqvozfYRD
	 i7+Y/aU1VCvFMD+5YHfnApD6+M/WvomcjEvShWySTinVhxg2wuk7nMT9gq2v5AFjpb
	 DZ8RdJIwo+4T8JqnK8SQ1RtOYtx8gAIZ0jPhRa0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.18 727/869] cgroup: dont kill migrated processes through their exiting threads
Date: Sat,  7 Nov 2026 08:56:49 -0500
Message-ID: <20261107134917.440838981@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

[ Upstream commit 5f4a3f743acc96987ae5c2e966947942c34ba56c ]

Since commit da13e0e72a73 ("cgroup: fix cgroup.kill for exited thread
group leader"), __cgroup_kill() visits every thread in the cgroup and
sends SIGKILL with PIDTYPE_TGID, so each visited thread takes down its
whole thread group.

A thread that has started exiting can stay in a cgroup after its process
has been moved out of it. cgroup_migrate_add_task() skips PF_EXITING
tasks, and the thread is only unlinked by cgroup_task_dead() after its
final context switch. mm_release() clears the thread's clear_child_tid
word and wakes the joiner well before that, so pthread_join() can return
while the thread is still in the old cgroup.

If cgroup.kill is written in that window, __cgroup_kill() finds the
exiting thread and complete_signal() passes the group-wide SIGKILL on to
a live thread, killing a process that already left the cgroup. The cgroup
selftest test_stress.sh runs into this: test_cgcore_proc_migration()
joins its threads, moves itself back to the root cgroup, and cg_destroy()
falls back to cgroup.kill on the old cgroup when rmdir() fails with
EBUSY, so test_core kills itself. KernelCI has been reporting
"with_stress.sh: line 94: ... Killed" on several arm64 boards since the
commit reached linux-next.

Keep visiting every thread, but go back to sending SIGKILL to the thread
that was found. A SIGKILL sent to a live thread still kills its whole
thread group, so both cases fixed by that commit stay fixed, and
task_can_queue_signal() drops one sent to a thread that is already
exiting.

Fixes: da13e0e72a73 ("cgroup: fix cgroup.kill for exited thread group leader")
Cc: stable@vger.kernel.org # v5.14+
Link: https://lore.kernel.org/all/179272264722.329188.4773475583351189022@6e52bff8000c/
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 28db81da10b81..aa629b7d76e53 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4229,7 +4229,7 @@ static void __cgroup_kill(struct cgroup *cgrp)
 		if (__fatal_signal_pending(task))
 			continue;
 
-		do_send_sig_info(SIGKILL, SEND_SIG_NOINFO, task, PIDTYPE_TGID);
+		send_sig(SIGKILL, task, 0);
 	}
 	css_task_iter_end(&it);
 }
-- 
2.53.0



