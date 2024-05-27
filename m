Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82066DDA9;
	Mon, 27 May 2024 19:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836421; cv=none; b=mLyz4sn6rPPCvmSSyb0vKRTyLN7kwUH+4vdWov0HL7Cv9qP1DZTZMMOSBNClnbseLX813l4Tf4Knf/Jh5fIKIe3c3zXoLsu7/MGdUuvmXdDE+RYWKy7NlOk5MNRSeiI9/4QUJGQBvfki97L/MXlwVQbAhiTwi1hat/D8C1gBwAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836421; c=relaxed/simple;
	bh=Cb5tYots0ZpebM/hMNExZWN8iwtzbV2qWzRkRwVp4Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uAAojmkIjH5AeOF1zjzQXPEyLbL3Z0G6zdcLPM8akLq/rUsh1s0uNdZGedbsa1ulOu6s8HFcUm7TF09L/jBzHU8cpCisaeAy2BANV2vjK/kJoZ1Kai/Zvv9dq/oSmox9uelRwkYhjjPCvLWL7vPnGWavDGKnx1cXWmkUYafVkWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RzEqbWDB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RzEqbWDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1848EC2BBFC;
	Mon, 27 May 2024 19:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836421;
	bh=Cb5tYots0ZpebM/hMNExZWN8iwtzbV2qWzRkRwVp4Bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RzEqbWDBrfKJ+SpOUSk7go5BDlEDF/gngGjrorNlxXUY10kzgfBtZG2Gwb+9aPOi4
	 ha7pKKztLQW81kFloGdJoJ6pWt/S1LArVCIuB1tQDZDOTbcZAGNEWFqVdQohesqyS/
	 KHDhJrVS2zGcSsptqmpS2VI1TiOitAzFLtNAN4L4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Nixdorf <mixi@shadowice.org>,
	Mark Brown <broonie@kernel.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Janne Grunau <j@jannau.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Will Deacon <will@kernel.org>,
	Florian Klink <flokli@flokli.de>
Subject: [PATCH 6.9 006/427] arm64/fpsimd: Avoid erroneous elide of user state reload
Date: Mon, 27 May 2024 20:50:53 +0200
Message-ID: <20240527185602.383594825@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit e92bee9f861b466c676f0200be3e46af7bc4ac6b upstream.

TIF_FOREIGN_FPSTATE is a 'convenience' flag that should reflect whether
the current CPU holds the most recent user mode FP/SIMD state of the
current task. It combines two conditions:
- whether the current CPU's FP/SIMD state belongs to the task;
- whether that state is the most recent associated with the task (as a
  task may have executed on other CPUs as well).

When a task is scheduled in and TIF_KERNEL_FPSTATE is set, it means the
task was in a kernel mode NEON section when it was scheduled out, and so
the kernel mode FP/SIMD state is restored. Since this implies that the
current CPU is *not* holding the most recent user mode FP/SIMD state of
the current task, the TIF_FOREIGN_FPSTATE flag is set too, so that the
user mode FP/SIMD state is reloaded from memory when returning to
userland.

However, the task may be scheduled out after completing the kernel mode
NEON section, but before returning to userland. When this happens, the
TIF_FOREIGN_FPSTATE flag will not be preserved, but will be set as usual
the next time the task is scheduled in, and will be based on the above
conditions.

This means that, rather than setting TIF_FOREIGN_FPSTATE when scheduling
in a task with TIF_KERNEL_FPSTATE set, the underlying state should be
updated so that TIF_FOREIGN_FPSTATE will assume the expected value as a
result.

So instead, call fpsimd_flush_cpu_state(), which takes care of this.

Closes: https://lore.kernel.org/all/cb8822182231850108fa43e0446a4c7f@kernel.org
Reported-by: Johannes Nixdorf <mixi@shadowice.org>
Fixes: aefbab8e77eb ("arm64: fpsimd: Preserve/restore kernel mode NEON at context switch")
Cc: Mark Brown <broonie@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>
Cc: Janne Grunau <j@jannau.net>
Cc: stable@vger.kernel.org
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Janne Grunau <j@jannau.net>
Tested-by: Johannes Nixdorf <mixi@shadowice.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20240522091335.335346-2-ardb+git@google.com
Signed-off-by: Will Deacon <will@kernel.org>
Cc: Florian Klink <flokli@flokli.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/fpsimd.c |   44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1517,6 +1517,27 @@ static void fpsimd_save_kernel_state(str
 	fpsimd_save_state(&task->thread.kernel_fpsimd_state);
 }
 
+/*
+ * Invalidate any task's FPSIMD state that is present on this cpu.
+ * The FPSIMD context should be acquired with get_cpu_fpsimd_context()
+ * before calling this function.
+ */
+static void fpsimd_flush_cpu_state(void)
+{
+	WARN_ON(!system_supports_fpsimd());
+	__this_cpu_write(fpsimd_last_state.st, NULL);
+
+	/*
+	 * Leaving streaming mode enabled will cause issues for any kernel
+	 * NEON and leaving streaming mode or ZA enabled may increase power
+	 * consumption.
+	 */
+	if (system_supports_sme())
+		sme_smstop();
+
+	set_thread_flag(TIF_FOREIGN_FPSTATE);
+}
+
 void fpsimd_thread_switch(struct task_struct *next)
 {
 	bool wrong_task, wrong_cpu;
@@ -1534,7 +1555,7 @@ void fpsimd_thread_switch(struct task_st
 
 	if (test_tsk_thread_flag(next, TIF_KERNEL_FPSTATE)) {
 		fpsimd_load_kernel_state(next);
-		set_tsk_thread_flag(next, TIF_FOREIGN_FPSTATE);
+		fpsimd_flush_cpu_state();
 	} else {
 		/*
 		 * Fix up TIF_FOREIGN_FPSTATE to correctly describe next's
@@ -1825,27 +1846,6 @@ void fpsimd_flush_task_state(struct task
 }
 
 /*
- * Invalidate any task's FPSIMD state that is present on this cpu.
- * The FPSIMD context should be acquired with get_cpu_fpsimd_context()
- * before calling this function.
- */
-static void fpsimd_flush_cpu_state(void)
-{
-	WARN_ON(!system_supports_fpsimd());
-	__this_cpu_write(fpsimd_last_state.st, NULL);
-
-	/*
-	 * Leaving streaming mode enabled will cause issues for any kernel
-	 * NEON and leaving streaming mode or ZA enabled may increase power
-	 * consumption.
-	 */
-	if (system_supports_sme())
-		sme_smstop();
-
-	set_thread_flag(TIF_FOREIGN_FPSTATE);
-}
-
-/*
  * Save the FPSIMD state to memory and invalidate cpu view.
  * This function must be called with preemption disabled.
  */


