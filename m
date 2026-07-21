Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F02436BC6;
	Tue, 21 Jul 2026 19:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663830; cv=none; b=l5nVmzJMD4W2D6SfNhB2wIXuPE39pEjldpcUompcm/CeuyaHOaGNbri5QhTLhjFDpMJiMzuMwJ0vwM0YItW7+7BRnbhOpFwqwf8DzCn9J5nhP82FsMRPZgWwW6ElBYnnCJi5ijpK0FbMJFhqbM2zQUGIcxKYW9DgpAY49eJUphs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663830; c=relaxed/simple;
	bh=Wo5ZJHgqb5xFmhLo4gmeMn83ZJ5eg6NpA7XvPvRqvzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMcOYWD8YLz8NfDKRChe/5cy7ks6aAodS7LR+EuUCv14XvAJ/uCYbNCJ+GYeBTOw1fyf1Lf4D1FUs70+t2+UMiQptRVZCXgpwjrrCDSU3AGcB4rB15C4MdGYvNtd9q1oCjrIkNOErytbDX3khVvpAoZfNqg6Hj5roVOukCEZm5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JRuhYJuO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JRuhYJuO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04AF61F00A3A;
	Tue, 21 Jul 2026 19:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663829;
	bh=+64j3r2cE+Ck7X7/JwdvmgndtuDouctNls/EMOio93o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JRuhYJuOXVChjjizV0WMcgC6TpMTdQ6/GGCsxtD8ChfXq9Uk9kxJs7+NvujrbA7oJ
	 bdkEcbsYxmLPIlziNV04R0KCywqfTYpL9X395Lus87FxuWSVjnaHIXqaagcd19ggqu
	 f0vxXfeGnU4kXXhdrAHLMC7UmsJIkSPPlpt43KAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Tomlin <atomlin@atomlin.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.12 0928/1276] mips: sched: Fix CPUMASK_OFFSTACK memory corruption
Date: Tue, 21 Jul 2026 17:22:51 +0200
Message-ID: <20260721152506.798530291@linuxfoundation.org>
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
 


