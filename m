Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E963BBFAE;
	Sat, 17 Oct 2026 16:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255572; cv=none; b=OTw4YeizPmsdc31j4phf9Z+d9A8ptFYHMvf2R3aO6ar7bbgciJ7LziBSUrXvtZmL3X9gRNFwXkfMqC1TDXS3/CH2HaTJjpLtQ/cjZWZVM6rh63sGpgEvv0HNAvjuejYDt3nRqiAZE32XM3vEaWqQAoY3OA4vG02bl3EMjGdHqHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255572; c=relaxed/simple;
	bh=DwC599DGYRzJj9bvxB6bT+Jv03VvBQtTXgsFZG3fmws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szJF0Xc/nZrSbylIFTe0Ql4UKI/GjAgF1knvC+XvJrZuWA3U0JeLLAZCAx6euJvxSI0Rp/VzGPQnTVjsr1xExbtZlHBTRr38LkDcbinQE7lv7l3JwhQM30aCKhrvTnHgp+32UkKpmWldnZlGjXlc8DztGigls5ROg7QaOTHtJig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AUMof6E3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AUMof6E3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251AA1F000C4;
	Sat, 17 Oct 2026 16:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255571;
	bh=1qcoDKQVehc2ezgorZCaDsz/ua/etqLpvmUdNYuJBzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AUMof6E3aYFu5YQTRuf/6K1nNUOlVdikF5CULxZXf9441eAGa09qvUKeH48R6Kei7
	 p1NpjqYzc3dEQ7V6n+8nfqmZqC/I5ic7rJmywdlp4dpzH77NHo6N5uFadSfe4MJ+Ls
	 JeCUp2tu8AHA2rmOAbfOft4PUzDks8wTaKTopm5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cyril Bur <cyrilbur@tenstorrent.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 820/869] riscv: uaccess: Only restore the CSR_STATUS SUM bit
Date: Sat, 17 Oct 2026 18:01:01 +0200
Message-ID: <20261017160057.909825479@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Cyril Bur <cyrilbur@tenstorrent.com>

[ Upstream commit 265d6aba165c500389c80d394ac247460c443ef5 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/processor.h | 2 +-
 arch/riscv/kernel/asm-offsets.c    | 6 +++---
 arch/riscv/kernel/entry.S          | 9 +++++----
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/include/asm/processor.h b/arch/riscv/include/asm/processor.h
index 8b00833d24937..25a1385dcd3fd 100644
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
diff --git a/arch/riscv/kernel/asm-offsets.c b/arch/riscv/kernel/asm-offsets.c
index 1b575ddcb26ac..1d93658825f77 100644
--- a/arch/riscv/kernel/asm-offsets.c
+++ b/arch/riscv/kernel/asm-offsets.c
@@ -35,7 +35,7 @@ void asm_offsets(void)
 	OFFSET(TASK_THREAD_S9, task_struct, thread.s[9]);
 	OFFSET(TASK_THREAD_S10, task_struct, thread.s[10]);
 	OFFSET(TASK_THREAD_S11, task_struct, thread.s[11]);
-	OFFSET(TASK_THREAD_STATUS, task_struct, thread.status);
+	OFFSET(TASK_THREAD_SUM, task_struct, thread.sum);
 
 	OFFSET(TASK_TI_CPU, task_struct, thread_info.cpu);
 	OFFSET(TASK_TI_FLAGS, task_struct, thread_info.flags);
@@ -349,8 +349,8 @@ void asm_offsets(void)
 		  offsetof(struct task_struct, thread.s[11])
 		- offsetof(struct task_struct, thread.ra)
 	);
-	DEFINE(TASK_THREAD_STATUS_RA,
-		  offsetof(struct task_struct, thread.status)
+	DEFINE(TASK_THREAD_SUM_RA,
+		  offsetof(struct task_struct, thread.sum)
 		- offsetof(struct task_struct, thread.ra)
 	);
 
diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index c4d7a9ece593b..d8f74743134a7 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -404,14 +404,15 @@ SYM_FUNC_START(__switch_to)
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
-- 
2.53.0



