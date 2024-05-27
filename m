Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E9017E8F5;
	Mon, 27 May 2024 19:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836424; cv=none; b=DPTGEoe5yLhaNb+Aete2mBLacXUpvdlbxSW+Q620re5L9n/LkgejS6IBE3GbuzRxTJC+/fRApZoxG0OYemMnSPOpBBjxSJT07atwQLQLsqUhMtEIoQ35wERjxFvg8pB0sIH9Lz9RFyEZM2n06d1Qc4XhCdBgSPw0039q1lyfNUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836424; c=relaxed/simple;
	bh=d4p79zdtoa4a313bF/B+tWhT0sKlN59Mktau491PO6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bFQ0jnOkAuBX5KCdb1lTW9XRd8ViK8mHx2FoEfALPbJzOY6BCIMIspoJs41cAsN/nbcCz4dXEMmJjVYe5aknjdVKQFOxJrHhBB3EM8Td6z2GNGfT2KTaIV2Qv+9munezv1k86r6/diX41fOQadnj68snhmIR2RBNHnsCEEqcgo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b6+ZSria; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b6+ZSria"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909D3C2BBFC;
	Mon, 27 May 2024 19:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836423;
	bh=d4p79zdtoa4a313bF/B+tWhT0sKlN59Mktau491PO6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b6+ZSriaKDkQ8xYuLi0kDHt3Kc8pNT10lfIRoJRCl6bUWPpakfGRIS3Ln8VUpY/gG
	 nrd2x38tlC54FvtYtg+zjUIRcLb3XAfaYm1cqbda75Xzjm2LFoSoENcCNlzT/THWQl
	 /f+dm1ebj5E2iuY5ZzSQEEAz3SX8v8euX+GT1lpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.9 007/427] Reapply "arm64: fpsimd: Implement lazy restore for kernel mode FPSIMD"
Date: Mon, 27 May 2024 20:50:54 +0200
Message-ID: <20240527185602.507389437@linuxfoundation.org>
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

From: Will Deacon <will@kernel.org>

commit f481bb32d60e45fb3d19ea68ce79c5629f3fc3a0 upstream.

This reverts commit b8995a18417088bb53f87c49d200ec72a9dd4ec1.

Ard managed to reproduce the dm-crypt corruption problem and got to the
bottom of it, so re-apply the problematic patch in preparation for
fixing things properly.

Cc: stable@vger.kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/processor.h |    1 +
 arch/arm64/kernel/fpsimd.c         |   18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -171,6 +171,7 @@ struct thread_struct {
 	struct debug_info	debug;		/* debugging */
 
 	struct user_fpsimd_state	kernel_fpsimd_state;
+	unsigned int			kernel_fpsimd_cpu;
 #ifdef CONFIG_ARM64_PTR_AUTH
 	struct ptrauth_keys_user	keys_user;
 #ifdef CONFIG_ARM64_PTR_AUTH_KERNEL
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1509,12 +1509,30 @@ void do_fpsimd_exc(unsigned long esr, st
 
 static void fpsimd_load_kernel_state(struct task_struct *task)
 {
+	struct cpu_fp_state *last = this_cpu_ptr(&fpsimd_last_state);
+
+	/*
+	 * Elide the load if this CPU holds the most recent kernel mode
+	 * FPSIMD context of the current task.
+	 */
+	if (last->st == &task->thread.kernel_fpsimd_state &&
+	    task->thread.kernel_fpsimd_cpu == smp_processor_id())
+		return;
+
 	fpsimd_load_state(&task->thread.kernel_fpsimd_state);
 }
 
 static void fpsimd_save_kernel_state(struct task_struct *task)
 {
+	struct cpu_fp_state cpu_fp_state = {
+		.st		= &task->thread.kernel_fpsimd_state,
+		.to_save	= FP_STATE_FPSIMD,
+	};
+
 	fpsimd_save_state(&task->thread.kernel_fpsimd_state);
+	fpsimd_bind_state_to_cpu(&cpu_fp_state);
+
+	task->thread.kernel_fpsimd_cpu = smp_processor_id();
 }
 
 /*


