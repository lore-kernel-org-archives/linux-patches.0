Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD42125DF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:19:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23DB7C433EF;
	Mon,  8 May 2023 10:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541151;
	bh=1qk3aPiwEGTf7W20rOAtgeOTtR8fM1LKBzCMxX5k3xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hApwvHgPjDQx73/kpjMP0H8qWg3BRHCep2h/D7oT9dENaGiJgmOBsZfXVk3sLeW+C
	 e66at3vcg5uh74DDwWq93gj482UaidV/DOHh/G5QGjDL/My8bwn5EUHn8kAuhlouQ7
	 eaxLH1BRGhaprCFkgauu7e+JfWeqf1wLM2IMULQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.2 022/663] arm64: Always load shadow stack pointer directly from the task struct
Date: Mon,  8 May 2023 11:37:28 +0200
Message-Id: <20230508094429.161291859@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ard Biesheuvel <ardb@kernel.org>

commit 2198d07c509f1db4a1185d1f65aaada794c6ea59 upstream.

All occurrences of the scs_load macro load the value of the shadow call
stack pointer from the task which is current at that point. So instead
of taking a task struct register argument in the scs_load macro to
specify the task struct to load from, let's always reference the current
task directly. This should make it much harder to exploit any
instruction sequences reloading the shadow call stack pointer register
from memory.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20230109174800.3286265-2-ardb@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/scs.h |    7 ++++---
 arch/arm64/kernel/entry.S    |    4 ++--
 arch/arm64/kernel/head.S     |    2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)

--- a/arch/arm64/include/asm/scs.h
+++ b/arch/arm64/include/asm/scs.h
@@ -10,15 +10,16 @@
 #ifdef CONFIG_SHADOW_CALL_STACK
 	scs_sp	.req	x18
 
-	.macro scs_load tsk
-	ldr	scs_sp, [\tsk, #TSK_TI_SCS_SP]
+	.macro scs_load_current
+	get_current_task scs_sp
+	ldr	scs_sp, [scs_sp, #TSK_TI_SCS_SP]
 	.endm
 
 	.macro scs_save tsk
 	str	scs_sp, [\tsk, #TSK_TI_SCS_SP]
 	.endm
 #else
-	.macro scs_load tsk
+	.macro scs_load_current
 	.endm
 
 	.macro scs_save tsk
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -275,7 +275,7 @@ alternative_if ARM64_HAS_ADDRESS_AUTH
 alternative_else_nop_endif
 1:
 
-	scs_load tsk
+	scs_load_current
 	.else
 	add	x21, sp, #PT_REGS_SIZE
 	get_current_task tsk
@@ -848,7 +848,7 @@ SYM_FUNC_START(cpu_switch_to)
 	msr	sp_el0, x1
 	ptrauth_keys_install_kernel x1, x8, x9, x10
 	scs_save x0
-	scs_load x1
+	scs_load_current
 	ret
 SYM_FUNC_END(cpu_switch_to)
 NOKPROBE(cpu_switch_to)
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -404,7 +404,7 @@ SYM_FUNC_END(create_kernel_mapping)
 	stp	xzr, xzr, [sp, #S_STACKFRAME]
 	add	x29, sp, #S_STACKFRAME
 
-	scs_load \tsk
+	scs_load_current
 
 	adr_l	\tmp1, __per_cpu_offset
 	ldr	w\tmp2, [\tsk, #TSK_TI_CPU]


