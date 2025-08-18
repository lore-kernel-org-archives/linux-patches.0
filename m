Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3228D2E228D;
	Mon, 18 Aug 2025 14:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526306; cv=none; b=Io6XU9U5e+xCXWIAPE83T6ADX9wVQFBB2MTabwl6yFqC1TQfJnVliIMjhNabwLl7Lngbqd1BD/IFz0qw8CB/YqyGLJWUPd4qVtCh61Jw00Hpc84a3Q/7pdPPDEw7esZcYUnJcgq6h7tCdGHw5V/kQdnwR3KWdLxyphx+AsS6Pyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526306; c=relaxed/simple;
	bh=dttK70k0Hck1Q/i9Qbc4J3V0TwItLXXnbnOC+O7Cdt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xk1xe6+RJwlCjewuUtQz7ML2UPQ0DrQXEV1niC7j1QzHLcc7LjejKFhQu/lR9XPwY91s/8oT+H1NPdJFm2FydQxDBELNSKCuoJjwFVixapcvn0810PLZOsme4CRS158QIl/5eGupW1mR++9y23V8LDY5h4UcZY8SEq75MfMoTlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fFVB6470; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fFVB6470"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E87C4CEEB;
	Mon, 18 Aug 2025 14:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526306;
	bh=dttK70k0Hck1Q/i9Qbc4J3V0TwItLXXnbnOC+O7Cdt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fFVB6470o+nDJ94wUL6hKd0EAtYWpzzH9s2TXr74QEscxM5k5hRzffWrMkcsYW6qM
	 R5N536fCp8K/N5lQ4mVrWJRmpCFC+qQXEn+Sp7o3w92xhgdAWncfmQCRCFw/GH8oIu
	 0b1wdyatCnvEnBeYmPfYRbOw9I2s/FEXmgNyRzmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sohil Mehta <sohil.mehta@intel.com>,
	Fushuai Wang <wangfushuai@baidu.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 6.16 484/570] x86/fpu: Fix NULL dereference in avx512_status()
Date: Mon, 18 Aug 2025 14:47:51 +0200
Message-ID: <20250818124524.528774935@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fushuai Wang <wangfushuai@baidu.com>

commit 31cd31c9e17ece125aad27259501a2af69ccb020 upstream.

Problem
-------
With CONFIG_X86_DEBUG_FPU enabled, reading /proc/[kthread]/arch_status
causes a warning and a NULL pointer dereference.

This is because the AVX-512 timestamp code uses x86_task_fpu() but
doesn't check it for NULL. CONFIG_X86_DEBUG_FPU addles that function
for kernel threads (PF_KTHREAD specifically), making it return NULL.

The point of the warning was to ensure that kernel threads only access
task->fpu after going through kernel_fpu_begin()/_end(). Note: all
kernel tasks exposed in /proc have a valid task->fpu.

Solution
--------
One option is to silence the warning and check for NULL from
x86_task_fpu(). However, that warning is fairly fresh and seems like a
defense against misuse of the FPU state in kernel threads.

Instead, stop outputting AVX-512_elapsed_ms for kernel threads
altogether. The data was garbage anyway because avx512_timestamp is
only updated for user threads, not kernel threads.

If anyone ever wants to track kernel thread AVX-512 use, they can come
back later and do it properly, separate from this bug fix.

[ dhansen: mostly rewrite changelog ]

Fixes: 22aafe3bcb67 ("x86/fpu: Remove init_task FPU state dependencies, add debugging warning for PF_KTHREAD tasks")
Co-developed-by: Sohil Mehta <sohil.mehta@intel.com>
Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>
Signed-off-by: Fushuai Wang <wangfushuai@baidu.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20250811185044.2227268-1-sohil.mehta%40intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/fpu/xstate.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1855,19 +1855,20 @@ long fpu_xstate_prctl(int option, unsign
 #ifdef CONFIG_PROC_PID_ARCH_STATUS
 /*
  * Report the amount of time elapsed in millisecond since last AVX512
- * use in the task.
+ * use in the task. Report -1 if no AVX-512 usage.
  */
 static void avx512_status(struct seq_file *m, struct task_struct *task)
 {
-	unsigned long timestamp = READ_ONCE(x86_task_fpu(task)->avx512_timestamp);
-	long delta;
+	unsigned long timestamp;
+	long delta = -1;
 
-	if (!timestamp) {
-		/*
-		 * Report -1 if no AVX512 usage
-		 */
-		delta = -1;
-	} else {
+	/* AVX-512 usage is not tracked for kernel threads. Don't report anything. */
+	if (task->flags & (PF_KTHREAD | PF_USER_WORKER))
+		return;
+
+	timestamp = READ_ONCE(x86_task_fpu(task)->avx512_timestamp);
+
+	if (timestamp) {
 		delta = (long)(jiffies - timestamp);
 		/*
 		 * Cap to LONG_MAX if time difference > LONG_MAX


