Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038701F75B1;
	Tue,  3 Dec 2024 15:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238814; cv=none; b=QTmjb6apQY0SHM9ZBPTYTmWKy+e89sG2gVULiHyvboxRwvFgKSL/J1A5LpYwDO192VdLBWgWjHJHsi3W0hO2SggeEiSAxZCmS2jQMbdneYFCqx3j6IPpU9UglziJsM6Ni3UjdRbmuXznVB3iqHYS8VpjRQll6ywFB1ERtVuBsgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238814; c=relaxed/simple;
	bh=W2MZd3RslxayT3eZjJy8Jm1BjGyRYqY70BmCeisFpJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kI7A8Lstuvo4eG1WtIvguEWcOXXnkg0RBfDOAUmKoNxyvAqQVPgNl1RiZP/s2NFFcF64T5+Dcxzy+4GK99cQdt8Vlx+4PLf+SnD5mf8rx87GCer9Rlsueqvk4KkRPyTCAfA5WjcKpgtNs45hIEi3/H1dCQQKqP1NVLfhFb+0Gek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nEquwquA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nEquwquA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC75C4CECF;
	Tue,  3 Dec 2024 15:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238813;
	bh=W2MZd3RslxayT3eZjJy8Jm1BjGyRYqY70BmCeisFpJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nEquwquA4nojuj2S9oD7pioeJElymRgB3SgabtX8Aru3TcfE/X41Tk/AkiSwNuw1H
	 wD08tQbRpvvldbxhjZMoNsK4Pc/wCmVpYDRFGJvfsT7D5EoW1bZVhRojnDJGfEL2Bl
	 sOrdC4pc1iMucXjGmWPH49t8KjxfWlTWnDtbILVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kajol Jain <kjain@linux.ibm.com>,
	"Nysal Jan K.A" <nysal@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 404/817] powerpc/pseries: Fix dtl_access_lock to be a rw_semaphore
Date: Tue,  3 Dec 2024 15:39:36 +0100
Message-ID: <20241203144011.644343845@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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
index d6f43d149f8dc..a5c21bc623cb0 100644
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
 
 extern void register_dtl_buffer(int cpu);
 extern void alloc_dtl_buffers(unsigned long *time_limit);
diff --git a/arch/powerpc/platforms/pseries/dtl.c b/arch/powerpc/platforms/pseries/dtl.c
index 3f1cdccebc9c1..ecc04ef8c53e3 100644
--- a/arch/powerpc/platforms/pseries/dtl.c
+++ b/arch/powerpc/platforms/pseries/dtl.c
@@ -191,7 +191,7 @@ static int dtl_enable(struct dtl *dtl)
 		return -EBUSY;
 
 	/* ensure there are no other conflicting dtl users */
-	if (!read_trylock(&dtl_access_lock))
+	if (!down_read_trylock(&dtl_access_lock))
 		return -EBUSY;
 
 	n_entries = dtl_buf_entries;
@@ -199,7 +199,7 @@ static int dtl_enable(struct dtl *dtl)
 	if (!buf) {
 		printk(KERN_WARNING "%s: buffer alloc failed for cpu %d\n",
 				__func__, dtl->cpu);
-		read_unlock(&dtl_access_lock);
+		up_read(&dtl_access_lock);
 		return -ENOMEM;
 	}
 
@@ -217,7 +217,7 @@ static int dtl_enable(struct dtl *dtl)
 	spin_unlock(&dtl->lock);
 
 	if (rc) {
-		read_unlock(&dtl_access_lock);
+		up_read(&dtl_access_lock);
 		kmem_cache_free(dtl_cache, buf);
 	}
 
@@ -232,7 +232,7 @@ static void dtl_disable(struct dtl *dtl)
 	dtl->buf = NULL;
 	dtl->buf_entries = 0;
 	spin_unlock(&dtl->lock);
-	read_unlock(&dtl_access_lock);
+	up_read(&dtl_access_lock);
 }
 
 /* file interface */
diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index c1d8bee8f7018..bb09990eec309 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -169,7 +169,7 @@ struct vcpu_dispatch_data {
  */
 #define NR_CPUS_H	NR_CPUS
 
-DEFINE_RWLOCK(dtl_access_lock);
+DECLARE_RWSEM(dtl_access_lock);
 static DEFINE_PER_CPU(struct vcpu_dispatch_data, vcpu_disp_data);
 static DEFINE_PER_CPU(u64, dtl_entry_ridx);
 static DEFINE_PER_CPU(struct dtl_worker, dtl_workers);
@@ -463,7 +463,7 @@ static int dtl_worker_enable(unsigned long *time_limit)
 {
 	int rc = 0, state;
 
-	if (!write_trylock(&dtl_access_lock)) {
+	if (!down_write_trylock(&dtl_access_lock)) {
 		rc = -EBUSY;
 		goto out;
 	}
@@ -479,7 +479,7 @@ static int dtl_worker_enable(unsigned long *time_limit)
 		pr_err("vcpudispatch_stats: unable to setup workqueue for DTL processing\n");
 		free_dtl_buffers(time_limit);
 		reset_global_dtl_mask();
-		write_unlock(&dtl_access_lock);
+		up_write(&dtl_access_lock);
 		rc = -EINVAL;
 		goto out;
 	}
@@ -494,7 +494,7 @@ static void dtl_worker_disable(unsigned long *time_limit)
 	cpuhp_remove_state(dtl_worker_state);
 	free_dtl_buffers(time_limit);
 	reset_global_dtl_mask();
-	write_unlock(&dtl_access_lock);
+	up_write(&dtl_access_lock);
 }
 
 static ssize_t vcpudispatch_stats_write(struct file *file, const char __user *p,
-- 
2.43.0



