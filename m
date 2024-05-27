Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4828168C4;
	Mon, 27 May 2024 19:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837524; cv=none; b=Td83O0pGtfwTCv/Ab+KMjKFbHyPoiZK5ExsUxPhkJDi6O1eQrYSnRmCD1gGf25zLqBAlM3xJB/WzwSILSgZ5XDdiRYJp1eYOlfyNpExBKEkKaXezByHtbSHU35oZDojnv30E4XJgsGhfWjuNPooTPAdwtH+nwPfZfAlUpfGJnis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837524; c=relaxed/simple;
	bh=uTx9wIo9gAZ9HLN4i7uKOAOlfopMf39YM3zkQw3MtSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYXvlPIOJDLbJu61QBkzgfU3WmDkzT7umj1yMzdvahMvKbHiN8lbog1Sn+zP5mWwhR1anMRB08zGxCfNTWaHiO3+VpF8gLMcKf9fGU/Cn6v31rPRXQZ4KL7+FO7c/Du28lekplAuvQMUPM/G/W/Ru7Jr+g+u6d4Urgsr0TEjTIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dd42F9A1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dd42F9A1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E959BC2BBFC;
	Mon, 27 May 2024 19:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837524;
	bh=uTx9wIo9gAZ9HLN4i7uKOAOlfopMf39YM3zkQw3MtSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dd42F9A1XiMnk/ZGxDTRkAjDEAb3RGBSWM7SBjJYM+I/4mx2X9e0JoTVP1oHPWRIE
	 Ka8PSVHABnmB6tCF/+nKsLSXEDUPcmVtK62Svsaoq0evRm/6YhxO2iWxz3ccRwziBy
	 MbFNEI9YR08GK4BQPYlNcQCE/kZBWHa8FR3DeEAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.8 007/493] Reapply "arm64: fpsimd: Implement lazy restore for kernel mode FPSIMD"
Date: Mon, 27 May 2024 20:50:09 +0200
Message-ID: <20240527185627.242627059@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -169,6 +169,7 @@ struct thread_struct {
 	struct debug_info	debug;		/* debugging */
 
 	struct user_fpsimd_state	kernel_fpsimd_state;
+	unsigned int			kernel_fpsimd_cpu;
 #ifdef CONFIG_ARM64_PTR_AUTH
 	struct ptrauth_keys_user	keys_user;
 #ifdef CONFIG_ARM64_PTR_AUTH_KERNEL
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1492,12 +1492,30 @@ void do_fpsimd_exc(unsigned long esr, st
 
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


