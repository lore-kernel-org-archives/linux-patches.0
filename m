Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062507;
	b=lkA3tH5Btlf1l2t1Ucp8ZvEKjUXfJ6HgtwEh5hw+bR0mXt8fUOS93+Bd6lAMjI97ipiS
	 byGoQ/dyoYVDBFMVs3eKZ3qbakginMG952XMw412EOVz7y7KOfnvUrGH/dRgw1KGVG7z2
	 Ja9yC165uRtjuLVWxxqcx9aN9KJgJrZ4FVe5bws+sJ16EOJ6PeV8OHNb3WePtE5fkBxLa
	 fVWsviHSaP6l87nISnS4qk/0/32iA71UjnBZCJhpTrZkhqPpjKyFy2LVtn5vFersBLkOs
	 RyN/lHc97ITHbN9RzsvOZ3SnLv1fNIeuOeX6XdSfUxnukvdRdtd7cripc8Yl05x5Qnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062507;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HYRQ2s4/6ryUtAn0QG4HUUi7sKmArfB9yw6Qih1IZH0=;
	b=y550Jd5/qSvvZqTzjouxQGTDjT0FVP1Iky3bqgvXkpSYw1omCMEsevq/a4mUDrFhFqVN
	 9wrl+k0LBy4FxSf3+CcS/+xNP5svIVk97Rq9dmxoc/wuaXNAVm5IbTPKEpMC2OcQ8BQf6
	 Jy8B4+gSO192Es9l8z/m44f2KZULAoEZU2LlJjstStasKvadpgt8Lt3lORlxq92ZUqzzC
	 VeTDxv4XICE3hlVS2FA0+aFqcaS+XqUHc7yHhIsR9PA1mzB+aAO9su2sDyb/cfyw4zy0y
	 RqxRaEu+UKDp5zO+iNGGVw1JNfMz5RHwIXXOSf+VRS6dUjfNmbM091MK8Xdeah8yz3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nmYSq6Ta;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DA4606A330;
	Sat,  7 Nov 2026 14:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nmYSq6Ta
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151821F008A1;
	Sat,  7 Nov 2026 14:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062507;
	bh=HYRQ2s4/6ryUtAn0QG4HUUi7sKmArfB9yw6Qih1IZH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nmYSq6TawTSK3eqQH56T4e3MHwFfzv/fX7uEJ4/rl6qhnq5pDm/p0HnsQhoo/AlHl
	 wZcal0Di5bFJXdOcUlAdr56+bitHuNx7tvkbIjZSPac309KRHQN+m19lp70FcqcLBK
	 +IhPoDfm0ExTtSek6PKQ/RP1EHt4kaF4kdkCE3Gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kir Kolyshkin <kolyshkin@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1366/1536] cgroup: fix cgroup.kill for exited thread group leader
Date: Sat,  7 Nov 2026 08:56:22 -0500
Message-ID: <20261107135036.206443530@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kir Kolyshkin <kolyshkin@gmail.com>

[ Upstream commit da13e0e72a7329c95642c44b2d03d194ab071e04 ]

cgroup.kill does not work in case a process' thread group leader is gone
but other threads are still running. This is because __cgroup_kill()
only walks the thread group leaders and sends SIGKILL to each of them
with send_sig(), which uses PIDTYPE_PID:

1. The exited leader is still listed by CSS_TASK_ITER_PROCS as long as
   the process has live threads, but a signal directed at a single
   exiting task never takes effect: complete_signal() does not look for
   another thread to deliver it to, and __send_signal_locked() now drops
   it altogether.  The process keeps running.

2. The live threads of such a process can be migrated to another cgroup
   by writing any of their IDs to cgroup.procs, while the exited leader
   stays behind.  The destination cgroup has no thread group leader to
   iterate, so writing to its cgroup.kill does nothing at all.

In both cases the cgroup stays populated after cgroup.kill, and a
process inside a container can use this to survive the container being
killed.  This also works with a private PID namespace when the init of
the container is the process, as the PID namespace is not torn down
while init has live threads.

Case 1 can be fixed by using do_send_sig_info(..., PIDTYPE_TGID) instead
of send_sig(), so that the signal is taken by a live thread even if the
task found by the iterator is exiting. Note it was pointed out by Eric
in [1] while reviewing v2 of cgroup.kill patchset, and v3 was meant to
switch to it, but the change was only made in cgroup_post_fork(),
leaving __cgroup_kill() with send_sig().

Case 2 can only be fixed by iterating over all threads, so this is what
the fix also does. Once a thread group is being killed, its other
threads are skipped since they already have a fatal signal pending.

I ran some performance checks and the added cost is ~60 ns per every
thread on my laptop (and less than a millisecond for 10K threads),
which seems low. The time to "populated 0" seems unchanged.

The issue was found in crun by Anthropic's OSS Scanner, and crun is
getting a workaround for it [2] (which does what we needed to do
before cgroup.kill was added).

[1] https://lore.kernel.org/all/m1v97x6niq.fsf@fess.ebiederm.org/
[2] https://github.com/containers/crun/pull/2351

Fixes: 661ee6280931 ("cgroup: introduce cgroup.kill")
Cc: stable@vger.kernel.org # v5.14+
Signed-off-by: Kir Kolyshkin <kolyshkin@gmail.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 4983d7b71cd42..766351c0e34e6 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4103,7 +4103,7 @@ static void __cgroup_kill(struct cgroup *cgrp)
 	cgrp->kill_seq++;
 	spin_unlock_irq(&css_set_lock);
 
-	css_task_iter_start(&cgrp->self, CSS_TASK_ITER_PROCS | CSS_TASK_ITER_THREADED, &it);
+	css_task_iter_start(&cgrp->self, CSS_TASK_ITER_THREADED, &it);
 	while ((task = css_task_iter_next(&it))) {
 		/* Ignore kernel threads here. */
 		if (task->flags & PF_KTHREAD)
@@ -4113,7 +4113,7 @@ static void __cgroup_kill(struct cgroup *cgrp)
 		if (__fatal_signal_pending(task))
 			continue;
 
-		send_sig(SIGKILL, task, 0);
+		do_send_sig_info(SIGKILL, SEND_SIG_NOINFO, task, PIDTYPE_TGID);
 	}
 	css_task_iter_end(&it);
 }
-- 
2.53.0



