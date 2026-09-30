Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30AD446EF89;
	Wed, 30 Sep 2026 19:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797090; cv=none; b=r1QCLdbhHrMGlvU4jdOB7aQLtfy6U467j8jxIIE6elljya6ufoSc7L4xnGjHH1KQ7A1kFXOvpxjq+mLm+kqhCZ1cED1DKNfwbYjm6DsuU54aszLst3K1rYXiI4+nrBcYMBshOXW/ysvvL/BLWCoMUpQ1KT2IH+2YE87w0/FhhZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797090; c=relaxed/simple;
	bh=avkm/SKkspZGq1DQ7OwOEH1+o1SPvoFjGicJSQTKPqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=syodyweoOPeS/gPM0emnUmK0S8V88i7hBBbTqSSkksfYWaGH2eyaiOkUyIJjbD3o592q3aPukk9ExaHXJZZHminnLLC0SmbqvwtdL7GSpzy6ZYqu6BUMiTkOTZLR4bcDzMTFR/ZptBMXhYoXb+PAua7MokCB0/ekuZfoixlT0eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/z3lGQE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/z3lGQE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DC61F000FF;
	Wed, 30 Sep 2026 19:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797088;
	bh=lUp0tZ1YHrZyQocOYXg4pqrh/tHwb3XrXDcKIkggXSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y/z3lGQEDB5nECe7mPKpukntWoou4h2thWGG4JFdj4W3PezOftvfwGILxgFw0e4km
	 XWzjVil3Qx43TisNM0qxmpGwiJQ3/2aH1oECVLltuEn+Hb66H1176M61xfv5dB1rlO
	 acImlMGUuIoWbe24zOjO78IRfWZQWbj2Pxwpi54k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavankumar Kondeti <pavan.kondeti@oss.qualcomm.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.6 1098/1193] workqueue: Fix NULL current_pwq deref in flush dependency check
Date: Wed, 30 Sep 2026 17:29:42 +0200
Message-ID: <20260930152458.627900150@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Pavankumar Kondeti <pavan.kondeti@oss.qualcomm.com>

commit db6365ced4d5855e321f772b240c0e473bcfcdd5 upstream.

check_flush_dependency() uses current_wq_worker() to determine whether
the caller is a workqueue worker and then dereferences worker->current_pwq
to test whether the current workqueue is WQ_MEM_RECLAIM.

current_wq_worker() only means that %current has PF_WQ_WORKER set. A
kworker can reach check_flush_dependency() while it is not executing a
work item. One such path is worker_thread() acting as the pool manager,
where create_worker() does GFP_KERNEL allocation and the allocation path
invokes the OOM notifier. In that state worker->current_pwq is NULL
because current_pwq is set only by process_one_work() and cleared again
after the work function returns.

[  416.760634][  T375] Call trace:
[  416.760638][  T375]  check_flush_dependency+0x80/0x120 (P)
[  416.760648][  T375]  __flush_work+0x98/0x224
[  416.760657][  T375]  flush_work+0x30/0x44
[  416.760665][  T375]  ...
[  416.760710][  T375]  blocking_notifier_call_chain+0x58/0xa0
[  416.760719][  T375]  out_of_memory+0xb4/0x458
[  416.760730][  T375]  __alloc_pages_may_oom+0x11c/0x1a8
[  416.760739][  T375]  __alloc_pages_slowpath+0x314/0x46c
[  416.760746][  T375]  __alloc_frozen_pages_noprof+0x110/0x1a4
[  416.760753][  T375]  new_slab+0x12c/0x484
[  416.760759][  T375]  ___slab_alloc+0x7a8/0xc7c
[  416.760765][  T375]  __slab_alloc+0x74/0xd8
[  416.760772][  T375]  __kmalloc_cache_node_noprof+0x2ac/0x304
[  416.760779][  T375]  alloc_worker+0x28/0x60
[  416.760785][  T375]  create_worker+0x4c/0x20c
[  416.760790][  T375]  worker_thread+0xe8/0x2b8
[  416.760796][  T375]  kthread+0x1a8/0x200
[  416.760805][  T375]  ret_from_fork+0x10/0x20

Guard the WQ_MEM_RECLAIM-worker warning with worker->current_pwq. If the
kworker is not currently executing a work item, there is no current
workqueue to diagnose with that warning. The PF_MEMALLOC warning is left
unchanged so explicit reclaim context flushing a !WQ_MEM_RECLAIM target
is still reported.

Fixes: fca839c00a12 ("workqueue: warn if memory reclaim tries to flush !WQ_MEM_RECLAIM workqueue")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Pavankumar Kondeti <pavan.kondeti@oss.qualcomm.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/workqueue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3017,7 +3017,7 @@ static void check_flush_dependency(struc
 	WARN_ONCE(current->flags & PF_MEMALLOC,
 		  "workqueue: PF_MEMALLOC task %d(%s) is flushing !WQ_MEM_RECLAIM %s:%ps",
 		  current->pid, current->comm, target_wq->name, target_func);
-	WARN_ONCE(worker && ((worker->current_pwq->wq->flags &
+	WARN_ONCE(worker && worker->current_pwq && ((worker->current_pwq->wq->flags &
 			      (WQ_MEM_RECLAIM | __WQ_LEGACY)) == WQ_MEM_RECLAIM),
 		  "workqueue: WQ_MEM_RECLAIM %s:%ps is flushing !WQ_MEM_RECLAIM %s:%ps",
 		  worker->current_pwq->wq->name, worker->current_func,


