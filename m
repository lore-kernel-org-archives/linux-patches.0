Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B97470456;
	Tue, 21 Jul 2026 19:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663897; cv=none; b=KG1SfPt5XflK9sXQ7NdvSocLxYjJPUAAkn8W9ACgz4q86ce7rKikIs/WGR6jOoPWC/VkMZAFxhDzS+gyDnduzzqJJ+dRCsY3QHRNWSmc+rCTPHlepVyfRf6FJ6dfUevZG3kcF0SoxiLNcNREx5jytaXRd2K25lyNYQOS+gB1CgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663897; c=relaxed/simple;
	bh=V9RIoQ5CyTIWjyNHc0ZuBLpyGJgbqE9+b8GYo2D/yaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZnUIC8Ytvq7Nt1uy8z4AHi2B2q+mVC0dKyD/OR3o0/tHkIpG/uDgxTcjwAj24RzVGUzRIOYxyX4gQ2UvCW5+96/f+IG8onOItOwYkDlyM4mSUUulZOemdRpVnV12gJozaCZCsoyGBO8SHmxVSUPbDpbbk7jZr3MjCrzyOsbAIDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SULvZSG4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SULvZSG4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B581F000E9;
	Tue, 21 Jul 2026 19:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663895;
	bh=01Xkh2qmqG+egUKWtnGzC4sokS14bm1AQkKA07k2Uzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SULvZSG4I2bm8Cp1KZNivugmaTLiOflhtkWcFA9EYT9FLadCLiIigU1esxcbTLilF
	 tHDHsXoWyVL9onUNd0RWh2SRycJF3Ci2znHSHCtThVhBYZLYZJckvCjJDofij9+sVE
	 UnuSo0qcHorF/HfqXpABieB7OxMiQlVFHTcuTVzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jann Horn <jannh@google.com>,
	Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH 6.12 0996/1276] bpf,fork: wipe ->bpf_storage before bailouts that access it
Date: Tue, 21 Jul 2026 17:23:59 +0200
Message-ID: <20260721152508.299956853@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1213,6 +1213,11 @@ static struct task_struct *dup_task_stru
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
@@ -2368,10 +2373,6 @@ __latent_entropy struct task_struct *cop
 	p->sequential_io	= 0;
 	p->sequential_io_avg	= 0;
 #endif
-#ifdef CONFIG_BPF_SYSCALL
-	RCU_INIT_POINTER(p->bpf_storage, NULL);
-	p->bpf_ctx = NULL;
-#endif
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */
 	retval = sched_fork(clone_flags, p);


