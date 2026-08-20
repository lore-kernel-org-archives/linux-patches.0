Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A957747CA7A;
	Thu, 20 Aug 2026 16:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243548; cv=none; b=cMQOUMFnk3fIIFkJpeU9MSfZP7bu2Vb8Ek71we+5Y1aK7Uk8Xwy9Alu/MC+F82w8whalNVh9fQu0TOjEmNacY7Sw5LimIUYp8emPPNPH3xFcR9fiCqknm/ZWgMwrvqb/FdHgbXIZiWR39rdfiP+sYHpcFwqnd/4hopk0JNijW8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243548; c=relaxed/simple;
	bh=Q2dNSZIAzQulB2Ue+6wfTTzMk7hfrYjjk2QeXw26Zro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pcpXgVa7wU9WPU3hq1vqfo12Lj3UXn8aH63HpXM4H2Vs0pRUKt4h/2gnmXRMbgMuykjjODz+kZDWeQaScRjcoURmjSat/JuGNCNwwL+yBJNdgROBmuI7ie0k442q5nAty6fwcmgnVZGQJJfLYNDOUqujJTU6t7FyPWrJsjagLeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v6VMiNxg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v6VMiNxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6121F000E9;
	Thu, 20 Aug 2026 16:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243547;
	bh=NTmcJoFOomQo/G5RVivZN1kZGwl7fIciDl1lVYDemCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v6VMiNxgwZME8sQtmIi12EIsnwsgvuY5OcqhxsFRvKh5TI0nxUFMPB0xihb+Hd5hV
	 uBtUdSrSxKgK69xL66kD0WchMFeWajLZ1eSemXvdzNiwU97FeRkB5srlcqUG+2kiFH
	 MIIrA3LKMpr6rpVkggTmPjwI+KZKYHsS6OCtDK6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jann Horn <jannh@google.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/272] bpf,fork: wipe ->bpf_storage before bailouts that access it
Date: Thu, 20 Aug 2026 16:55:17 +0200
Message-ID: <20260820145235.253971165@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

[ Upstream commit 9b51a6155d14389876916726430da30eabb1d4ed ]

Currently, copy_process() can bail out to free_task() before p->bpf_storage
has been initialized, with this call graph (shown here for the
!CONFIG_MEMCG case):

copy_process
  dup_task_struct
    arch_dup_task_struct
      [copies the entire task_struct, including ->bpf_storage member]
  [RLIMIT_NPROC check fails]
  delayed_free_task
    free_task
      bpf_task_storage_free
        rcu_dereference(task->bpf_storage)
        bpf_local_storage_destroy

In this case, the nascent task's ->bpf_storage member that
bpf_local_storage_destroy() operates on is a plain copy of the parent's
->bpf_storage pointer, not a real initialized pointer.
This leads to badness (kernel hangs, UAF).

This is reachable as long as the process calling fork() has been inserted
into a task storage map.

Cc: stable@kernel.org
Fixes: a10787e6d58c ("bpf: Enable task local storage for tracing programs")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/fork.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -983,6 +983,11 @@ static struct task_struct *dup_task_stru
 #ifdef CONFIG_MEMCG
 	tsk->active_memcg = NULL;
 #endif
+
+#ifdef CONFIG_BPF_SYSCALL
+	RCU_INIT_POINTER(tsk->bpf_storage, NULL);
+	tsk->bpf_ctx = NULL;
+#endif
 	return tsk;
 
 free_stack:
@@ -2252,10 +2257,6 @@ static __latent_entropy struct task_stru
 	p->sequential_io	= 0;
 	p->sequential_io_avg	= 0;
 #endif
-#ifdef CONFIG_BPF_SYSCALL
-	RCU_INIT_POINTER(p->bpf_storage, NULL);
-	p->bpf_ctx = NULL;
-#endif
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */
 	retval = sched_fork(clone_flags, p);


