Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9DA375AC3;
	Tue, 21 Jul 2026 17:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654482; cv=none; b=JULwEtSfkA8b7Z70baaqGKS5LdS3f+tS1+1dyywCaCBvpn+WtVP2N4OQ48Vbq4M+P9FLnEOIT8Vpz63A2toNUAZaclV+ZhHbQGNzPh7lXNNcQYKbkZVW4ULBjdxto3LlUEcr2y/h1EZtCYySSu4j8Qf+zn8M0NF9rOnNeLu3+oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654482; c=relaxed/simple;
	bh=ipZLbL2cUadWfQxaJeR3nty9Nl8OU49JqOz3W5z3/Zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/8aePYWtBOQeQHn4f+t7rino5TjnZTqod8biGGorJCyraDeJzWJCSl0Wr1j25aLGGMFjDwusDvJF0EagPeMHVfLohIUOc3kjQqp+bYQ+dU4ppi+Tmcjpxq4sI783zgcZ4bvu3MWUI75sYcE3VvoJ5eUGMXDMGMs9gCZ0ldKOjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fUzceEap; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fUzceEap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0190A1F000E9;
	Tue, 21 Jul 2026 17:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654481;
	bh=eLJeLJHTObEQ4nAtVENIEPpjpTBxMExBY5JaO8wm9xY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fUzceEapkjYn5xgV2PbAhVrwTHpWTClw6ZwHVZ1FI1g/af8rGvIWxuqUHMprhX6f3
	 pzAWwUunmk3AjIYGINtTELK7olmwMNbMN61CoJqik+cXScmHya+WkotT5A7mUiXJnq
	 o+qdZOATBGNdl8gmKv8D4s6zXnHh/CSAUoMi/WMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Tomlin <atomlin@atomlin.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 7.1 1722/2077] mips: sched: Fix CPUMASK_OFFSTACK memory corruption
Date: Tue, 21 Jul 2026 17:23:15 +0200
Message-ID: <20260721152633.368638024@linuxfoundation.org>
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
@@ -71,11 +71,16 @@ asmlinkage long mipsmt_sys_sched_setaffi
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
@@ -84,7 +89,8 @@ asmlinkage long mipsmt_sys_sched_setaffi
 	if (!p) {
 		rcu_read_unlock();
 		cpus_read_unlock();
-		return -ESRCH;
+		retval = -ESRCH;
+		goto out_free_new_mask;
 	}
 
 	/* Prevent p going away */
@@ -95,13 +101,9 @@ asmlinkage long mipsmt_sys_sched_setaffi
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
@@ -142,13 +144,13 @@ asmlinkage long mipsmt_sys_sched_setaffi
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
 


