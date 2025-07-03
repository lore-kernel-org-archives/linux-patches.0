Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27E42ED143;
	Thu,  3 Jul 2025 15:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555415; cv=none; b=UQksOpK0FqaZ2WAlMhrr2u/PA0Knm8zaJa/xxhi2VfWEKlfVa4zMyz+N6aS1BnFHFITn/8dTHIDxPjMqU7qDSgcgJhij0L4zCWnDe+3QRFFIm3g6SNEAc6QjlYgM6auQGw7qNTbXNXFwmpP2ShT4Tt9MDkf0cAFqxLeXyp07ekU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555415; c=relaxed/simple;
	bh=5C0S64BK+QHXI8Ucx+sFrQMa5qGCNby4IAxF4ZA/oEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHf2qh480+L7Yaz21JiOXi41aK0FtKoN6DI6JXutEL0rssE936R+HGOprGkan+l/684jYOVaVRR2au3YmRTX3i1/JvbUKwUTlnCU0nS/vYEVUbVQ0vZrTcIEKO5TV0tx8WsvuP2dkc7bqQ1mSB7xhJwide7NKmLSAFnYsdP6x+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oaLeR2TD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oaLeR2TD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A30C4CEE3;
	Thu,  3 Jul 2025 15:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555415;
	bh=5C0S64BK+QHXI8Ucx+sFrQMa5qGCNby4IAxF4ZA/oEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oaLeR2TDm1CCSxmD7Ozx9gNYoL5wiW6x7I1ixQavRt2PqTK7plf851+D4uUlMlWHR
	 YJOjPZSAG1JM4zOrSINwojbGsXUqW+jPV8SFV84u+usa4S6mdEfk9/5xJ0Xug1ICIz
	 GdtdLlSXswEkGqByf/HDBftcXMsSCf/2BBfdFzxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cyril Bur <cyrilbur@tenstorrent.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@dabbelt.com>
Subject: [PATCH 6.15 263/263] riscv: uaccess: Only restore the CSR_STATUS SUM bit
Date: Thu,  3 Jul 2025 16:43:03 +0200
Message-ID: <20250703144014.959025313@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cyril Bur <cyrilbur@tenstorrent.com>

commit 265d6aba165c500389c80d394ac247460c443ef5 upstream.

During switch to csrs will OR the value of the register into the
corresponding csr. In this case we're only interested in restoring the
SUM bit not the entire register.

Signed-off-by: Cyril Bur <cyrilbur@tenstorrent.com>
Link: https://lore.kernel.org/r/20250522160954.429333-1-cyrilbur@tenstorrent.com
Co-developed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Fixes: 788aa64c01f1 ("riscv: save the SR_SUM status over switches")
Link: https://lore.kernel.org/r/20250602121543.1544278-1-alexghiti@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/processor.h |    2 +-
 arch/riscv/kernel/asm-offsets.c    |    6 +++---
 arch/riscv/kernel/entry.S          |    9 +++++----
 3 files changed, 9 insertions(+), 8 deletions(-)

--- a/arch/riscv/include/asm/processor.h
+++ b/arch/riscv/include/asm/processor.h
@@ -103,7 +103,7 @@ struct thread_struct {
 	struct __riscv_d_ext_state fstate;
 	unsigned long bad_cause;
 	unsigned long envcfg;
-	unsigned long status;
+	unsigned long sum;
 	u32 riscv_v_flags;
 	u32 vstate_ctrl;
 	struct __riscv_v_ext_state vstate;
--- a/arch/riscv/kernel/asm-offsets.c
+++ b/arch/riscv/kernel/asm-offsets.c
@@ -34,7 +34,7 @@ void asm_offsets(void)
 	OFFSET(TASK_THREAD_S9, task_struct, thread.s[9]);
 	OFFSET(TASK_THREAD_S10, task_struct, thread.s[10]);
 	OFFSET(TASK_THREAD_S11, task_struct, thread.s[11]);
-	OFFSET(TASK_THREAD_STATUS, task_struct, thread.status);
+	OFFSET(TASK_THREAD_SUM, task_struct, thread.sum);
 
 	OFFSET(TASK_TI_CPU, task_struct, thread_info.cpu);
 	OFFSET(TASK_TI_PREEMPT_COUNT, task_struct, thread_info.preempt_count);
@@ -347,8 +347,8 @@ void asm_offsets(void)
 		  offsetof(struct task_struct, thread.s[11])
 		- offsetof(struct task_struct, thread.ra)
 	);
-	DEFINE(TASK_THREAD_STATUS_RA,
-		  offsetof(struct task_struct, thread.status)
+	DEFINE(TASK_THREAD_SUM_RA,
+		  offsetof(struct task_struct, thread.sum)
 		- offsetof(struct task_struct, thread.ra)
 	);
 
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -399,14 +399,15 @@ SYM_FUNC_START(__switch_to)
 	REG_S s11, TASK_THREAD_S11_RA(a3)
 
 	/* save the user space access flag */
-	li    s0, SR_SUM
-	csrr  s1, CSR_STATUS
-	REG_S s1, TASK_THREAD_STATUS_RA(a3)
+	csrr  s0, CSR_STATUS
+	REG_S s0, TASK_THREAD_SUM_RA(a3)
 
 	/* Save the kernel shadow call stack pointer */
 	scs_save_current
 	/* Restore context from next->thread */
-	REG_L s0,  TASK_THREAD_STATUS_RA(a4)
+	REG_L s0,  TASK_THREAD_SUM_RA(a4)
+	li    s1,  SR_SUM
+	and   s0,  s0, s1
 	csrs  CSR_STATUS, s0
 	REG_L ra,  TASK_THREAD_RA_RA(a4)
 	REG_L sp,  TASK_THREAD_SP_RA(a4)


