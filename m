Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB3F47125D;
	Tue, 21 Jul 2026 18:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658961; cv=none; b=HlvBaCAZI6JDBLHWx56XzCMk7Nx+Rek/5367j1+PeR8YGYfRqWMs+3T5qsZZh+i63tVpiHcODP7r74d0+j7lg6DLcfsm0THekfDAtiNRvcpHvdghcORgITr6YPaAyJlucFqwgiq9aHBQEq3tO7C3rsA4SjJ4omc1eFfQYunl3Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658961; c=relaxed/simple;
	bh=nQs2JKMRhB7N62RoTr9RIgaq8UWaEXvQ0gebtWwXX4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=StMvKdwrlCYyeCWCkbP58KzKM/t5irevXVKMs+bLT5JRWTAXEHefOCrb8x5IxIsw9sRgX+/9sT86bmSzdvT+wc0I2Bj0Cj/+FAtZHN0VTs79Ng0IHyWxSWzODiRpRXt1RaaFBX2wgFQv+uOCzppPdm76jlBQAt2w6fjMe6K8z9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q8qsya6l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8qsya6l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E771F000E9;
	Tue, 21 Jul 2026 18:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658959;
	bh=W1n3hb9/4W9cnftx7xI+Nu/yLRvRJJFV8i8JWk0scu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q8qsya6lV/utRTX/ukAor+Q0VRL2pNCtUamrUDY6SggDxN4fESGPuyabXrB+Pa9oK
	 NLFoxuF19J32Iq/iO7nO14iwIusJu6DPQx/v+sUoMp8ix5G5k/qAnBQQPrHWTH+815
	 tDHqnXJrhBPzZUJ/pA+ZhkKFwzwevj1G34KZDAjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jann Horn <jannh@google.com>,
	Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH 6.18 1339/1611] bpf,fork: wipe ->bpf_storage before bailouts that access it
Date: Tue, 21 Jul 2026 17:24:15 +0200
Message-ID: <20260721152545.569873607@linuxfoundation.org>
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
@@ -961,6 +961,11 @@ static struct task_struct *dup_task_stru
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
@@ -2143,10 +2148,6 @@ __latent_entropy struct task_struct *cop
 	p->sequential_io	= 0;
 	p->sequential_io_avg	= 0;
 #endif
-#ifdef CONFIG_BPF_SYSCALL
-	RCU_INIT_POINTER(p->bpf_storage, NULL);
-	p->bpf_ctx = NULL;
-#endif
 
 	unwind_task_init(p);
 


