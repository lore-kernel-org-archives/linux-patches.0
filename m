Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7FCF4432F7;
	Tue, 21 Jul 2026 22:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672429; cv=none; b=ByfwsIctyv/3APNKn6FGcxBiU+1rCe0zdRT/8KlrMO4pKiJvywinB8qAHOc/KLE1GiRfUwh1pgSUAAJ/YGKFJk+xgH1/Ru8mzMRF941YdJ21BGGtVudQDKGDB129oivmnjcGoX8td5ihDzoZ+eSE4aGgii8FMMbqeILcn98JF9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672429; c=relaxed/simple;
	bh=NSqLAnMwfDtPBJJpI3D3lHxDqUte74/9tRyUA/1NQj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYa4FxD44apIQtbqym5fS+ntkMPoLrwydf2no/NrNzowCtWfZOnqzQGY8Nq5Mjmal9fOisCtAi9Km8hCmnF1KslN2Is+fNuDz42SnMNnfc0sN98fSCTBGD5FOODUnSN+59prG8+BeZ+d0kxdXVR4PI5jMpqL0BrQPtZUCKqqwlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VjPMrKZk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VjPMrKZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144441F000E9;
	Tue, 21 Jul 2026 22:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672428;
	bh=RugGV9n/IFYAHlTqxPGNjzEozRJI2j0+4nJUuAbqWxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VjPMrKZkzTLKLXq9vdWk3viIVEcAz1aMSbxp/r/3ux5sGk74yYelNbNoTS8AlLzzP
	 7335U98ThvGR3Ih0KKcAh2twQrAY3iZgggsMygSK81KUol9uZ+lDH7UWnQVc69e3/A
	 OFZ+cGz2o/cj6zuA0egYZgiFUQjxVH6AET1PVJbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Tomlin <atomlin@atomlin.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.15 620/843] mips: sched: Fix CPUMASK_OFFSTACK memory corruption
Date: Tue, 21 Jul 2026 17:24:15 +0200
Message-ID: <20260721152420.006941502@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Tomlin <atomlin@atomlin.com>

commit 98e37db4a34d3af3fb2f4648295c25b5e40b20e3 upstream.

This patch addresses a critical memory management flaw. When
CONFIG_CPUMASK_OFFSTACK is enabled, cpumask_var_t is a pointer.
Consequently, sizeof(new_mask) evaluates to the pointer size, causing
copy_from_user() to clobber the mask pointer. Furthermore, the old
logic performed copy_from_user() before allocating the mask.

Fix this by allocating new_mask first. To handle variable-sized user
masks correctly, use cpumask_size() to truncate overly large user masks
or pad undersized masks with zeros before copying the data directly into
the allocated buffer.

Fixes: 295cbf6d63165 ("[MIPS] Move FPU affinity code into separate file.")
Cc: stable@vger.kernel.org
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/kernel/mips-mt-fpaff.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

--- a/arch/mips/kernel/mips-mt-fpaff.c
+++ b/arch/mips/kernel/mips-mt-fpaff.c
@@ -70,11 +70,16 @@ asmlinkage long mipsmt_sys_sched_setaffi
 	struct task_struct *p;
 	int retval;
 
-	if (len < sizeof(new_mask))
-		return -EINVAL;
-
-	if (copy_from_user(&new_mask, user_mask_ptr, sizeof(new_mask)))
-		return -EFAULT;
+	if (!alloc_cpumask_var(&new_mask, GFP_KERNEL))
+		return -ENOMEM;
+	if (len < cpumask_size())
+		cpumask_clear(new_mask);
+	else if (len > cpumask_size())
+		len = cpumask_size();
+	if (copy_from_user(new_mask, user_mask_ptr, len)) {
+		retval = -EFAULT;
+		goto out_free_new_mask;
+	}
 
 	cpus_read_lock();
 	rcu_read_lock();
@@ -83,7 +88,8 @@ asmlinkage long mipsmt_sys_sched_setaffi
 	if (!p) {
 		rcu_read_unlock();
 		cpus_read_unlock();
-		return -ESRCH;
+		retval = -ESRCH;
+		goto out_free_new_mask;
 	}
 
 	/* Prevent p going away */
@@ -94,13 +100,9 @@ asmlinkage long mipsmt_sys_sched_setaffi
 		retval = -ENOMEM;
 		goto out_put_task;
 	}
-	if (!alloc_cpumask_var(&new_mask, GFP_KERNEL)) {
-		retval = -ENOMEM;
-		goto out_free_cpus_allowed;
-	}
 	if (!alloc_cpumask_var(&effective_mask, GFP_KERNEL)) {
 		retval = -ENOMEM;
-		goto out_free_new_mask;
+		goto out_free_cpus_allowed;
 	}
 	if (!check_same_owner(p) && !capable(CAP_SYS_NICE)) {
 		retval = -EPERM;
@@ -141,13 +143,13 @@ asmlinkage long mipsmt_sys_sched_setaffi
 	}
 out_unlock:
 	free_cpumask_var(effective_mask);
-out_free_new_mask:
-	free_cpumask_var(new_mask);
 out_free_cpus_allowed:
 	free_cpumask_var(cpus_allowed);
 out_put_task:
 	put_task_struct(p);
 	cpus_read_unlock();
+out_free_new_mask:
+	free_cpumask_var(new_mask);
 	return retval;
 }
 


