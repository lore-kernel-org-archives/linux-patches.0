Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C70C1DED58;
	Wed,  6 Nov 2024 12:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896135; cv=none; b=jsG8d89VbLArgdb4ERxNMWfMU7mPtE4PZ4kH0jFDYDWBpP2fqKPj6BEvXCyVrvFkaP5ecGv6mQEITME6TbaRKsbOjc9ofQ1tuWcOM3nEQsPITQP/Bkf17gWvYazTVVzr2vn7zWfPaOgeaTp7E7Qv8UvbJM2hGS2TnL44edIAf98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896135; c=relaxed/simple;
	bh=Deq93Ey3lPU5t1SFMyfgJYO5QOw77Vw4NAlK+BFNtMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qjdC4qLLnFsj0KgiCNLY0ROaT2qZHeUVI43sadmvL5q6btBjMxdKxhXjDsNCtkUEQjB3qcQETsIMSO1Z3489W/cBcUC43dJzz/VVziVvHYBbsMF6QSmGCL0Cd0eA8iD6K4mqzwNC4nMveIkF9FBdld79zA2L+OKIt+o3FdJr6Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ha9lya1e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ha9lya1e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2373CC4CECD;
	Wed,  6 Nov 2024 12:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896135;
	bh=Deq93Ey3lPU5t1SFMyfgJYO5QOw77Vw4NAlK+BFNtMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ha9lya1ezr50VOitCBQxbL+lsshrWLmx/kta3j+faAlGT+Jd9zrfTH1NBqhL67Hfd
	 mWD7iRg00LV4Ur5m9+G0a6INEXMhDDcupK1tZWX7RmLtdeq4P+RBtlccQR5uyCgChu
	 cDuWpm+VCb1HutKONvDVsQ37cwXbj1vksmK6tJHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dimitri Sivanich <sivanich@hpe.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 101/245] misc: sgi-gru: Dont disable preemption in GRU driver
Date: Wed,  6 Nov 2024 13:02:34 +0100
Message-ID: <20241106120321.699622125@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dimitri Sivanich <sivanich@hpe.com>

[ Upstream commit b983b271662bd6104d429b0fd97af3333ba760bf ]

Disabling preemption in the GRU driver is unnecessary, and clashes with
sleeping locks in several code paths.  Remove preempt_disable and
preempt_enable from the GRU driver.

Signed-off-by: Dimitri Sivanich <sivanich@hpe.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/sgi-gru/grukservices.c | 2 --
 drivers/misc/sgi-gru/grumain.c      | 4 ----
 drivers/misc/sgi-gru/grutlbpurge.c  | 2 --
 3 files changed, 8 deletions(-)

diff --git a/drivers/misc/sgi-gru/grukservices.c b/drivers/misc/sgi-gru/grukservices.c
index 37e804bbb1f28..205945ce9e86a 100644
--- a/drivers/misc/sgi-gru/grukservices.c
+++ b/drivers/misc/sgi-gru/grukservices.c
@@ -258,7 +258,6 @@ static int gru_get_cpu_resources(int dsr_bytes, void **cb, void **dsr)
 	int lcpu;
 
 	BUG_ON(dsr_bytes > GRU_NUM_KERNEL_DSR_BYTES);
-	preempt_disable();
 	bs = gru_lock_kernel_context(-1);
 	lcpu = uv_blade_processor_id();
 	*cb = bs->kernel_cb + lcpu * GRU_HANDLE_STRIDE;
@@ -272,7 +271,6 @@ static int gru_get_cpu_resources(int dsr_bytes, void **cb, void **dsr)
 static void gru_free_cpu_resources(void *cb, void *dsr)
 {
 	gru_unlock_kernel_context(uv_numa_blade_id());
-	preempt_enable();
 }
 
 /*
diff --git a/drivers/misc/sgi-gru/grumain.c b/drivers/misc/sgi-gru/grumain.c
index 0f5b09e290c89..3036c15f36892 100644
--- a/drivers/misc/sgi-gru/grumain.c
+++ b/drivers/misc/sgi-gru/grumain.c
@@ -937,10 +937,8 @@ vm_fault_t gru_fault(struct vm_fault *vmf)
 
 again:
 	mutex_lock(&gts->ts_ctxlock);
-	preempt_disable();
 
 	if (gru_check_context_placement(gts)) {
-		preempt_enable();
 		mutex_unlock(&gts->ts_ctxlock);
 		gru_unload_context(gts, 1);
 		return VM_FAULT_NOPAGE;
@@ -949,7 +947,6 @@ vm_fault_t gru_fault(struct vm_fault *vmf)
 	if (!gts->ts_gru) {
 		STAT(load_user_context);
 		if (!gru_assign_gru_context(gts)) {
-			preempt_enable();
 			mutex_unlock(&gts->ts_ctxlock);
 			set_current_state(TASK_INTERRUPTIBLE);
 			schedule_timeout(GRU_ASSIGN_DELAY);  /* true hack ZZZ */
@@ -965,7 +962,6 @@ vm_fault_t gru_fault(struct vm_fault *vmf)
 				vma->vm_page_prot);
 	}
 
-	preempt_enable();
 	mutex_unlock(&gts->ts_ctxlock);
 
 	return VM_FAULT_NOPAGE;
diff --git a/drivers/misc/sgi-gru/grutlbpurge.c b/drivers/misc/sgi-gru/grutlbpurge.c
index 10921cd2608df..1107dd3e2e9fa 100644
--- a/drivers/misc/sgi-gru/grutlbpurge.c
+++ b/drivers/misc/sgi-gru/grutlbpurge.c
@@ -65,7 +65,6 @@ static struct gru_tlb_global_handle *get_lock_tgh_handle(struct gru_state
 	struct gru_tlb_global_handle *tgh;
 	int n;
 
-	preempt_disable();
 	if (uv_numa_blade_id() == gru->gs_blade_id)
 		n = get_on_blade_tgh(gru);
 	else
@@ -79,7 +78,6 @@ static struct gru_tlb_global_handle *get_lock_tgh_handle(struct gru_state
 static void get_unlock_tgh_handle(struct gru_tlb_global_handle *tgh)
 {
 	unlock_tgh_handle(tgh);
-	preempt_enable();
 }
 
 /*
-- 
2.43.0



