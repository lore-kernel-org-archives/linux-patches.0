Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907DB47DD42;
	Thu, 20 Aug 2026 17:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248170; cv=none; b=g1MP/qZR4gv+l+LkXS5Wp/FxQ+5mZCV8bCJ1fzqZtOsPoRtRliazNyUpYSSSc47CQ3tM/FdrRJPEpmHp3KO7VTsT2hYk2wgxVgU6qxDa0qQVnIkgM5CBt8opyQhC74oGgVcmvEAFOrfJ5uqVOtQ1VZ8OqsCQaobrOBWhAhjQtZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248170; c=relaxed/simple;
	bh=daf7CIBc1sH0+v4GaiLnO76V/4cYJf7stMSRhLZUwfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tplDAd3EaKy3ZwuRMEkrsSzRbhZvBmjZrwNyaweW0v4XEDFIPhicTTUsc9j6RMeFcxL8jyUFuDcQWURVU47obJG4b4hNfRN6CUa8L64VM1bL2SP3fVIjJsY4Z8MfI+KZIRc9GyJS3jTsiS7ByCIBEjFJtmG98RnUBviIm0A/HXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A19TPk+2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A19TPk+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC661F000E9;
	Thu, 20 Aug 2026 17:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248169;
	bh=O4p2GB9kIkAFTBLBIEOoO9/NFfrbGB0IeGEiQZJZtH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A19TPk+2f2xTcMKiNAUzG7cbI1fgnF0OE59drKb+ui6JB38iv9WLm3QXJbJJOJf7f
	 zHdvqi6CURGtlfBUr+sedQABAiDXNKsR4pX9fs6JghqTFHFNA+H8nTOuE4GeCGLzXn
	 W53jzHSY+9wKIVI0paAc3R6SBCT7ABwHjIoHCpRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jann Horn <jannh@google.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 133/303] bpf,fork: wipe ->bpf_storage before bailouts that access it
Date: Thu, 20 Aug 2026 16:54:29 +0200
Message-ID: <20260820145257.268866736@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 kernel/fork.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1068,6 +1068,10 @@ static struct task_struct *dup_task_stru
 	tsk->reported_split_lock = 0;
 #endif
 
+#ifdef CONFIG_BPF_SYSCALL
+	RCU_INIT_POINTER(tsk->bpf_storage, NULL);
+	tsk->bpf_ctx = NULL;
+#endif
 	return tsk;
 
 free_stack:
@@ -2319,10 +2323,6 @@ static __latent_entropy struct task_stru
 	p->sequential_io	= 0;
 	p->sequential_io_avg	= 0;
 #endif
-#ifdef CONFIG_BPF_SYSCALL
-	RCU_INIT_POINTER(p->bpf_storage, NULL);
-	p->bpf_ctx = NULL;
-#endif
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */
 	retval = sched_fork(clone_flags, p);


