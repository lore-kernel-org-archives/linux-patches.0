Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B620221E085;
	Thu, 12 Dec 2024 17:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024063; cv=none; b=fXx5exlm4G0Uy50NJQIqZ8hPSp/QzsK9THff6kag5RUKHr4CL65KoquDt9Y10LF5ymB6YgSBNevb4a5Kz6M90kVXZwpeilX0des7+cQqEhtBXZcjTtqivkVa4LiiGV79crP8qCxopAPxhyBLiGQQDy2eWGQUKKPZmTKeWdyatsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024063; c=relaxed/simple;
	bh=2NqoK/t11uxSjGYJPhsJgnytfG/pq+xPL8vB1ID/syw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YXFPwnF5oJEVHjavOgBVsDiaUGNMpijPmdbEVIMcvxIuqvjVaWFelJEW/zbtg1Pfm5FXMJomuvtRp4DDrwq9TwiAnw8kFzeplLj5t4qfQFogWV5uguQi6Gkx8MpPbkgWdwmeU5fW77sjIvgBLx7yzaBnXu8mxl1GC4iUnGWDkzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XUp78jn+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XUp78jn+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327B2C4CECE;
	Thu, 12 Dec 2024 17:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024063;
	bh=2NqoK/t11uxSjGYJPhsJgnytfG/pq+xPL8vB1ID/syw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XUp78jn+sobEGmsRGNuRHpTWeJ+e8vkcXW1N56iEL4Jzayg9SBltg5V6cq9F8PDSF
	 0514GNBHkMZjG6/56W85q0vBCRTXVQEGeg9avcQZhf3GdmXz97WhWorIv9RLNjKMk2
	 01alpzPZIrIV9e9Ev3PHbvDZe6hmq2I04vuZmrP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kajol Jain <kjain@linux.ibm.com>,
	"Nysal Jan K.A" <nysal@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 173/459] powerpc/pseries: Fix dtl_access_lock to be a rw_semaphore
Date: Thu, 12 Dec 2024 15:58:31 +0100
Message-ID: <20241212144300.355000550@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit cadae3a45d23aa4f6485938a67cbc47aaaa25e38 ]

The dtl_access_lock needs to be a rw_sempahore, a sleeping lock, because
the code calls kmalloc() while holding it, which can sleep:

  # echo 1 > /proc/powerpc/vcpudispatch_stats
  BUG: sleeping function called from invalid context at include/linux/sched/mm.h:337
  in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 199, name: sh
  preempt_count: 1, expected: 0
  3 locks held by sh/199:
   #0: c00000000a0743f8 (sb_writers#3){.+.+}-{0:0}, at: vfs_write+0x324/0x438
   #1: c0000000028c7058 (dtl_enable_mutex){+.+.}-{3:3}, at: vcpudispatch_stats_write+0xd4/0x5f4
   #2: c0000000028c70b8 (dtl_access_lock){+.+.}-{2:2}, at: vcpudispatch_stats_write+0x220/0x5f4
  CPU: 0 PID: 199 Comm: sh Not tainted 6.10.0-rc4 #152
  Hardware name: IBM pSeries (emulated by qemu) POWER9 (raw) 0x4e1202 0xf000005 of:SLOF,HEAD hv:linux,kvm pSeries
  Call Trace:
    dump_stack_lvl+0x130/0x148 (unreliable)
    __might_resched+0x174/0x410
    kmem_cache_alloc_noprof+0x340/0x3d0
    alloc_dtl_buffers+0x124/0x1ac
    vcpudispatch_stats_write+0x2a8/0x5f4
    proc_reg_write+0xf4/0x150
    vfs_write+0xfc/0x438
    ksys_write+0x88/0x148
    system_call_exception+0x1c4/0x5a0
    system_call_common+0xf4/0x258

Fixes: 06220d78f24a ("powerpc/pseries: Introduce rwlock to gatekeep DTLB usage")
Tested-by: Kajol Jain <kjain@linux.ibm.com>
Reviewed-by: Nysal Jan K.A <nysal@linux.ibm.com>
Reviewed-by: Kajol Jain <kjain@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://patch.msgid.link/20240819122401.513203-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/dtl.h        | 4 ++--
 arch/powerpc/platforms/pseries/dtl.c  | 8 ++++----
 arch/powerpc/platforms/pseries/lpar.c | 8 ++++----
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/include/asm/dtl.h b/arch/powerpc/include/asm/dtl.h
index 1625888f27ef6..5e40f27aa76e5 100644
--- a/arch/powerpc/include/asm/dtl.h
+++ b/arch/powerpc/include/asm/dtl.h
@@ -1,8 +1,8 @@
 #ifndef _ASM_POWERPC_DTL_H
 #define _ASM_POWERPC_DTL_H
 
+#include <linux/rwsem.h>
 #include <asm/lppaca.h>
-#include <linux/spinlock_types.h>
 
 /*
  * Layout of entries in the hypervisor's dispatch trace log buffer.
@@ -35,7 +35,7 @@ struct dtl_entry {
 #define DTL_LOG_ALL		(DTL_LOG_CEDE | DTL_LOG_PREEMPT | DTL_LOG_FAULT)
 
 extern struct kmem_cache *dtl_cache;
-extern rwlock_t dtl_access_lock;
+extern struct rw_semaphore dtl_access_lock;
 
 /*
  * When CONFIG_VIRT_CPU_ACCOUNTING_NATIVE = y, the cpu accounting code controls
diff --git a/arch/powerpc/platforms/pseries/dtl.c b/arch/powerpc/platforms/pseries/dtl.c
index 982f069e4c318..36a2eb23dbdc4 100644
--- a/arch/powerpc/platforms/pseries/dtl.c
+++ b/arch/powerpc/platforms/pseries/dtl.c
@@ -181,7 +181,7 @@ static int dtl_enable(struct dtl *dtl)
 		return -EBUSY;
 
 	/* ensure there are no other conflicting dtl users */
-	if (!read_trylock(&dtl_access_lock))
+	if (!down_read_trylock(&dtl_access_lock))
 		return -EBUSY;
 
 	n_entries = dtl_buf_entries;
@@ -189,7 +189,7 @@ static int dtl_enable(struct dtl *dtl)
 	if (!buf) {
 		printk(KERN_WARNING "%s: buffer alloc failed for cpu %d\n",
 				__func__, dtl->cpu);
-		read_unlock(&dtl_access_lock);
+		up_read(&dtl_access_lock);
 		return -ENOMEM;
 	}
 
@@ -207,7 +207,7 @@ static int dtl_enable(struct dtl *dtl)
 	spin_unlock(&dtl->lock);
 
 	if (rc) {
-		read_unlock(&dtl_access_lock);
+		up_read(&dtl_access_lock);
 		kmem_cache_free(dtl_cache, buf);
 	}
 
@@ -222,7 +222,7 @@ static void dtl_disable(struct dtl *dtl)
 	dtl->buf = NULL;
 	dtl->buf_entries = 0;
 	spin_unlock(&dtl->lock);
-	read_unlock(&dtl_access_lock);
+	up_read(&dtl_access_lock);
 }
 
 /* file interface */
diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index aed67f1a1bc56..b19de0faf913c 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -166,7 +166,7 @@ struct vcpu_dispatch_data {
  */
 #define NR_CPUS_H	NR_CPUS
 
-DEFINE_RWLOCK(dtl_access_lock);
+DECLARE_RWSEM(dtl_access_lock);
 static DEFINE_PER_CPU(struct vcpu_dispatch_data, vcpu_disp_data);
 static DEFINE_PER_CPU(u64, dtl_entry_ridx);
 static DEFINE_PER_CPU(struct dtl_worker, dtl_workers);
@@ -460,7 +460,7 @@ static int dtl_worker_enable(unsigned long *time_limit)
 {
 	int rc = 0, state;
 
-	if (!write_trylock(&dtl_access_lock)) {
+	if (!down_write_trylock(&dtl_access_lock)) {
 		rc = -EBUSY;
 		goto out;
 	}
@@ -476,7 +476,7 @@ static int dtl_worker_enable(unsigned long *time_limit)
 		pr_err("vcpudispatch_stats: unable to setup workqueue for DTL processing\n");
 		free_dtl_buffers(time_limit);
 		reset_global_dtl_mask();
-		write_unlock(&dtl_access_lock);
+		up_write(&dtl_access_lock);
 		rc = -EINVAL;
 		goto out;
 	}
@@ -491,7 +491,7 @@ static void dtl_worker_disable(unsigned long *time_limit)
 	cpuhp_remove_state(dtl_worker_state);
 	free_dtl_buffers(time_limit);
 	reset_global_dtl_mask();
-	write_unlock(&dtl_access_lock);
+	up_write(&dtl_access_lock);
 }
 
 static ssize_t vcpudispatch_stats_write(struct file *file, const char __user *p,
-- 
2.43.0



