Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052823;
	b=UuEkURkBmC4IcrLwer6PUoKi7VAQ+Rw2IHzv7IVEetgBut0JuPt5aarO+FDGfZdgQ+j1
	 yL4P//yReAwjeszSS55w0eqJd3RAJG1EOxrbMKHrEGJwgF9NR46aZFPOIt4RXCw9tFHQi
	 rz0T9Ov/t4i7Wni3vshVfLENLMy4PH3deeu5QhxRdVmC3nczo3kKWVv6newCHGslinszz
	 0AsdpOIKSozW6QfjlDLZKjj3Xm4Jpmqj5WmUnx2pBP2UiME1AYPlIziL2D0hqUACJGBqH
	 z7YEeCzZ3lEyu+Pplbpr63+iFI6E5zijry4SDLJUpkzY4cVKKjCI7fe+VhoHSjB2Owg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052823;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g38W4YQyPEs5Jm0pSH6YFlDHY4JsP8soKwP2jwGdKpU=;
	b=llExufZwdeQWRqnZNr5iWkjihCFCl4jLwiAppoONcEfk87ohJKs+mo/l8Mcm5v9km7zs
	 FQdsNJqBnKFmvknpimNb+sg4Q96KjMbCRXLUXUP3RzAeogoSDOn64b8FIDv7SIh+CsQL7
	 bXBuirVhGdSr5Noegc0EuO6SvGBQCJUEt00lH93svDbAHzKeAK7GrDeHQGn6bS5jx0tmo
	 8wRxaAgw/uC99mYcg/aoHKRA1T5xGcJhFfK0/JBIVBd8a70Um8ZyhS2W0IYeAi5fyoDOC
	 /yGf5ilD02Q8WuErejaAOOc7xDEt0wGhzNKf8T1Eqb8h95km1Wpa9GOluDs/vdOTR4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WAvRyHFa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513CA606A32A;
	Thu, 19 Nov 2026 01:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WAvRyHFa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B571F000C4;
	Thu, 19 Nov 2026 01:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052822;
	bh=g38W4YQyPEs5Jm0pSH6YFlDHY4JsP8soKwP2jwGdKpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WAvRyHFalHnGXnsH0tFeb7DETX7H4zy71wOEwRQf4HmqLVgiOklHiyhcSgo4e2W0q
	 QKvVyyDgdeWEq/arRZT6QlyNp3s2iydE+WhDWnpXs1Ry7rrjMULABPn5IT1FTmd5rQ
	 xWYO/TLcdlSMUn6EWL9+l+cXVEPwSSILJof+CLYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.15 0701/2214] cgroup: dont kill migrated processes through their exiting threads
Date: Wed, 18 Nov 2026 15:39:37 +0100
Message-ID: <20261118150039.842376521@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 93ea53974e312..f8d244b3f41b0 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3855,7 +3855,7 @@ static void __cgroup_kill(struct cgroup *cgrp)
 		if (__fatal_signal_pending(task))
 			continue;
 
-		do_send_sig_info(SIGKILL, SEND_SIG_NOINFO, task, PIDTYPE_TGID);
+		send_sig(SIGKILL, task, 0);
 	}
 	css_task_iter_end(&it);
 }
-- 
2.53.0



