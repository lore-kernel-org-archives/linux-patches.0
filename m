Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E3D375AC3;
	Tue, 21 Jul 2026 17:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654787; cv=none; b=P+kWvh0EQFHzkR4grhuq/dAaPogw32mKB+9smv2i/Td6WmogSzuaTSAlcE1UYDe8jSe4YmboPC15RatTsyDj1f/lzDpgjXQIoOL5VjhxJkXQ+HFZ/GR4QLqmIb7A/wr1s7hkiiVgUvm783SjRL90LQ64OBSIrvuG9JZj/gGpPZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654787; c=relaxed/simple;
	bh=GngwnG23ckxhu0seVgGR0Kf56sqMa9fcQANdd5VeG6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQZoVwzvgXwkoEB+umBIBIVD8EdHn6qm6H8M/Ix5pxds2GjbBv0uJtWOVLTZE3LdYCnpJW7fGqWUSCJI8bC2hKl2bfiiOeQY4fqbCodsJoh/jemHg7qh5v2P4sU/FaoHW2QOJ5C7WZctUiIMQBj3Wb1TiZMhTCkHjQONIePda3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YMTt0myi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YMTt0myi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C871F00A3D;
	Tue, 21 Jul 2026 17:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654786;
	bh=EWudmBFm5l3cwXTiGMHvaR8w4jep2al90zYOlg34zPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YMTt0myiODeyLxuodN4uXzOli+AVPBU9kHNq/zS1qtieHlM3L/M8+jmUGyPVoKJk/
	 +VZVXdJ0ej47GJLd+cw77Uo9ZVdNATunW2mj6UOFTrD+1HuHD8Nv2aSXHMOc5ckkSX
	 ZVCy2xF+tTAocH2gOZDoB1bCzJL5on/Nf+m0qJos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jann Horn <jannh@google.com>,
	Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH 7.1 1836/2077] bpf,fork: wipe ->bpf_storage before bailouts that access it
Date: Tue, 21 Jul 2026 17:25:09 +0200
Message-ID: <20260721152636.044545367@linuxfoundation.org>
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
@@ -1004,6 +1004,11 @@ static struct task_struct *dup_task_stru
 	tsk->mm_cid.active = 0;
 	INIT_HLIST_NODE(&tsk->mm_cid.node);
 #endif
+
+#ifdef CONFIG_BPF_SYSCALL
+	RCU_INIT_POINTER(tsk->bpf_storage, NULL);
+	tsk->bpf_ctx = NULL;
+#endif
 	return tsk;
 
 free_stack:
@@ -2223,10 +2228,6 @@ __latent_entropy struct task_struct *cop
 	p->sequential_io	= 0;
 	p->sequential_io_avg	= 0;
 #endif
-#ifdef CONFIG_BPF_SYSCALL
-	RCU_INIT_POINTER(p->bpf_storage, NULL);
-	p->bpf_ctx = NULL;
-#endif
 
 	unwind_task_init(p);
 


