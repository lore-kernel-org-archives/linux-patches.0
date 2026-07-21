Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B05F3B7B64;
	Tue, 21 Jul 2026 20:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667385; cv=none; b=dVGqufTjhDn83RZWbhHhklIqDuXA09q7D7AqRltrNFz8blUuD6w1B6JjmxXp50M5vSBYHVoaNyzlPGuBdpfuSNE7wNskO3DPTCrQhp0/yADOan/S5xWvADo4bkcpr6b6ZQdQtvP37vTsDBs7+oYZaNcD127fqbTr0XgLp3hlwRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667385; c=relaxed/simple;
	bh=CjmrYT1S1uTDaqiZEgF7mJ46ptPFeqO1j22bNVnt4nI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXaMxuVyNPtFZscAtiEZrJGVvM0eXlgTieVw8WEQ2wNpD375pJ0O4s0FYRlOnUmjTDLagO4IeGWzV+sNvaeJOJ3m3jpbsYNCqs/pz7vUDrSV8NS1IGvPQZABTC1MwkdL6s6yC4YKHc1ND/5fvuVGY4iWyICOX6ahdhv7RxezmNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Drz+R6Ad; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Drz+R6Ad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05021F00A3A;
	Tue, 21 Jul 2026 20:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667384;
	bh=xLtWDB9RCKW3qM/hztwc8muB27KyazMsbEVHKU2EWzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Drz+R6AdHlNOOhXCA/aIMHH9gEGfMpwTnkWht2kKrYZLHwii//8poKNCakeReTAp9
	 wTV8kDOYn3IZzptrGfmf7/K39QGANZok8BfOh1hXiQV6KAFHWqWJz8DL9MSUhk0KHB
	 Dp+ON7Pf73uldoLgp0qG9JtDExU35J9cRRX+jgdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jann Horn <jannh@google.com>,
	Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH 6.6 1041/1266] bpf,fork: wipe ->bpf_storage before bailouts that access it
Date: Tue, 21 Jul 2026 17:24:38 +0200
Message-ID: <20260721152505.114965037@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit 9b51a6155d14389876916726430da30eabb1d4ed upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/fork.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1205,6 +1205,11 @@ static struct task_struct *dup_task_stru
 	tsk->mm_cid_active = 0;
 	tsk->migrate_from_cpu = -1;
 #endif
+
+#ifdef CONFIG_BPF_SYSCALL
+	RCU_INIT_POINTER(tsk->bpf_storage, NULL);
+	tsk->bpf_ctx = NULL;
+#endif
 	return tsk;
 
 free_stack:
@@ -2469,10 +2474,6 @@ __latent_entropy struct task_struct *cop
 	p->sequential_io	= 0;
 	p->sequential_io_avg	= 0;
 #endif
-#ifdef CONFIG_BPF_SYSCALL
-	RCU_INIT_POINTER(p->bpf_storage, NULL);
-	p->bpf_ctx = NULL;
-#endif
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */
 	retval = sched_fork(clone_flags, p);


