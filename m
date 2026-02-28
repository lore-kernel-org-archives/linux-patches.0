Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B9233F8A1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300950; cv=none; b=XCLjdf4DcTKoc1PF1EHSjpYVs9I0EzqkWfLPSI+6F4E6N4dL17VuoadpVNn2ubpe8eRW2GTX8WrRowOilSjQ8UwL8S1tovJ4F2Lda/SlldzbB9uWa5DywnyvHymGJNAAJTc+/v6wPt/p6ZLj6tBEJbneLxaK5zoWVbwufvIk//s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300950; c=relaxed/simple;
	bh=5FWSGWoP1DeTrBtFBKNXyNxpZ0WVhV/7ov6m7oEI/PI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oIhNvLGkr1V5Ko0GcYehC7451dbr/BXs+oeL9M+mdUuS/hbUSgJpvNEEwm97J+I8WhmBrHx8gpzOMEFgRwiEtShzEQTQK+aroRVptTMrZ1uKuP1IB11ruhZIS7yvHfQRLXq+Xbn2KNMU7pREYW3LZN/obN2HRWp3nS7jhkpKrG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LXRMEuMv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LXRMEuMv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85835C19423;
	Sat, 28 Feb 2026 17:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300950;
	bh=5FWSGWoP1DeTrBtFBKNXyNxpZ0WVhV/7ov6m7oEI/PI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LXRMEuMvNZDCVlnwqCb7i0seHUVIVjzWZplXqH3iZFFaE1zUPruAFaDI1aZkDI7ir
	 MGuh3Ik07a0wH90O5Wf8evm8/HDCVwjubSqUWc4iN/TjealCrCs8WndVj4ta4UTH3D
	 46Bk3elpgXr6z78KwVjGAaRtlTyycv02+kzT+80FiqOJsQFAA3mANnKPMT1a8AokaH
	 b68MJqD1Lr58/dJtUwoBlqfMGzA6uWLtWkrvAQyTdoasQ42/G6iQ8Djciz3/Ai9mix
	 lfEG5z/RGX/5YjBGAX5y+SlbGVCzG8ySmDcc0WrJBLmehT3ElOXDRWiHb7+8JrDV+4
	 w5S1JqtZQTBJg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Andreas Larsson <andreas@gaisler.com>,
	Ludwig Rydberg <ludwig.rydberg@gaisler.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 073/752] sparc: Synchronize user stack on fork and clone
Date: Sat, 28 Feb 2026 12:36:24 -0500
Message-ID: <20260228174750.1542406-73-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Andreas Larsson <andreas@gaisler.com>

[ Upstream commit e38eba3b77878ada327a572a41596a3b0b44e522 ]

Flush all uncommitted user windows before calling the generic syscall
handlers for clone, fork, and vfork.

Prior to entering the arch common handlers sparc_{clone|fork|vfork}, the
arch-specific syscall wrappers for these syscalls will attempt to flush
all windows (including user windows).

In the window overflow trap handlers on both SPARC{32|64},
if the window can't be stored (i.e due to MMU related faults) the routine
backups the user window and increments a thread counter (wsaved).

By adding a synchronization point after the flush attempt, when fault
handling is enabled, any uncommitted user windows will be flushed.

Link: https://sourceware.org/bugzilla/show_bug.cgi?id=31394
Closes: https://lore.kernel.org/sparclinux/fe5cc47167430007560501aabb28ba154985b661.camel@physik.fu-berlin.de/
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Ludwig Rydberg <ludwig.rydberg@gaisler.com>
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Link: https://lore.kernel.org/r/20260119144753.27945-2-ludwig.rydberg@gaisler.com
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/kernel/process.c | 38 +++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/arch/sparc/kernel/process.c b/arch/sparc/kernel/process.c
index 0442ab00518d3..7d69877511fac 100644
--- a/arch/sparc/kernel/process.c
+++ b/arch/sparc/kernel/process.c
@@ -17,14 +17,18 @@
 
 asmlinkage long sparc_fork(struct pt_regs *regs)
 {
-	unsigned long orig_i1 = regs->u_regs[UREG_I1];
+	unsigned long orig_i1;
 	long ret;
 	struct kernel_clone_args args = {
 		.exit_signal	= SIGCHLD,
-		/* Reuse the parent's stack for the child. */
-		.stack		= regs->u_regs[UREG_FP],
 	};
 
+	synchronize_user_stack();
+
+	orig_i1 = regs->u_regs[UREG_I1];
+	/* Reuse the parent's stack for the child. */
+	args.stack = regs->u_regs[UREG_FP];
+
 	ret = kernel_clone(&args);
 
 	/* If we get an error and potentially restart the system
@@ -40,16 +44,19 @@ asmlinkage long sparc_fork(struct pt_regs *regs)
 
 asmlinkage long sparc_vfork(struct pt_regs *regs)
 {
-	unsigned long orig_i1 = regs->u_regs[UREG_I1];
+	unsigned long orig_i1;
 	long ret;
-
 	struct kernel_clone_args args = {
 		.flags		= CLONE_VFORK | CLONE_VM,
 		.exit_signal	= SIGCHLD,
-		/* Reuse the parent's stack for the child. */
-		.stack		= regs->u_regs[UREG_FP],
 	};
 
+	synchronize_user_stack();
+
+	orig_i1 = regs->u_regs[UREG_I1];
+	/* Reuse the parent's stack for the child. */
+	args.stack = regs->u_regs[UREG_FP];
+
 	ret = kernel_clone(&args);
 
 	/* If we get an error and potentially restart the system
@@ -65,15 +72,18 @@ asmlinkage long sparc_vfork(struct pt_regs *regs)
 
 asmlinkage long sparc_clone(struct pt_regs *regs)
 {
-	unsigned long orig_i1 = regs->u_regs[UREG_I1];
-	unsigned int flags = lower_32_bits(regs->u_regs[UREG_I0]);
+	unsigned long orig_i1;
+	unsigned int flags;
 	long ret;
+	struct kernel_clone_args args = {0};
 
-	struct kernel_clone_args args = {
-		.flags		= (flags & ~CSIGNAL),
-		.exit_signal	= (flags & CSIGNAL),
-		.tls		= regs->u_regs[UREG_I3],
-	};
+	synchronize_user_stack();
+
+	orig_i1 = regs->u_regs[UREG_I1];
+	flags = lower_32_bits(regs->u_regs[UREG_I0]);
+	args.flags		= (flags & ~CSIGNAL);
+	args.exit_signal	= (flags & CSIGNAL);
+	args.tls		= regs->u_regs[UREG_I3];
 
 #ifdef CONFIG_COMPAT
 	if (test_thread_flag(TIF_32BIT)) {
-- 
2.51.0

