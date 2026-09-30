Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96714379EC4;
	Wed, 30 Sep 2026 15:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783886; cv=none; b=aYtbp5XCocVw1qBih6/x5QUBdD5myPzvLs5Fm++A2bk+HYcUl5vqM5qF01D7HUOaLdli8EZMYwgAEKMToaDYuvPJSYpXm2d9ZJhV09wV/kFfGAOnx/tdP94Gi8UuW8PInRNTDRW5bcgerLXa9R+Gk+UXWmKsbZNQ82VIphlfrPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783886; c=relaxed/simple;
	bh=+smwKTrH3RMXc862iqd2V7NmtrKW9C/fglUZYRmMcH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pADtgwZqlYYUzpyxD2p2NGAKXZH/n+grQVNTtGsKvwWC8d8iwhnpROcxivqUlYKUbbSBf9gB9y763JyUcw4vo3silDxPTTGYXh+fTqUjenpCwAZuJx23QUKjlFhl92nwZKfs47T//LznYy3WSR4CN3eTyhgdtHGmgc+55xZJVGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KPkUyedP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KPkUyedP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1EA31F000FF;
	Wed, 30 Sep 2026 15:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783881;
	bh=sIT653r2/jDksjqloLxlbX+t3MbfM2La8tful7eCOzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KPkUyedP8cvGDLRwv8L0s9+dlL8Bg5khOtoOAEpu9MT1jMDCCVU8/IYvuoaSO0Nta
	 HobwugCKYAS5N0nzWRwm612Ksyc1J0e3GLWc0ZDfplOxqPO+NkEvsG5a1ZY+4uzzVf
	 oo7/R1BnQF6K32Nvv3vtbp7xrUJ2rFOYlwMUEFJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavankumar Kondeti <pavan.kondeti@oss.qualcomm.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.10 556/595] workqueue: Fix NULL current_pwq deref in flush dependency check
Date: Wed, 30 Sep 2026 17:27:29 +0200
Message-ID: <20260930152359.677208296@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2617,7 +2617,7 @@ static void check_flush_dependency(struc
 	WARN_ONCE(current->flags & PF_MEMALLOC,
 		  "workqueue: PF_MEMALLOC task %d(%s) is flushing !WQ_MEM_RECLAIM %s:%ps",
 		  current->pid, current->comm, target_wq->name, target_func);
-	WARN_ONCE(worker && ((worker->current_pwq->wq->flags &
+	WARN_ONCE(worker && worker->current_pwq && ((worker->current_pwq->wq->flags &
 			      (WQ_MEM_RECLAIM | __WQ_LEGACY)) == WQ_MEM_RECLAIM),
 		  "workqueue: WQ_MEM_RECLAIM %s:%ps is flushing !WQ_MEM_RECLAIM %s:%ps",
 		  worker->current_pwq->wq->name, worker->current_func,


