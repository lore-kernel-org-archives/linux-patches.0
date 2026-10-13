Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6783EC830;
	Tue, 13 Oct 2026 12:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895971; cv=none; b=tXnPBAEluRiUQYunkTtS3EC9pOkmUEkEKI4WbII32GkPO01mlkZP0KtxQ+9qkPtbvKZ9ayNsQvVbENYoDeu7PqI8GypAg4/6ivLWnmCxWAxb+tIi7VbKIE+2klSqPP7Q/e9AWM+aNQpdJLp0sIVIhtAY9qQTNwqxWhHcEbeZfSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895971; c=relaxed/simple;
	bh=BEbtuB9hMqwttJ5XaLtd51+8P0pBeIprYQdSEGtgUIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EwvUkGJEt1kVikH9Hs1DNXLUYH23zeQ6LWMwMfegE8IZ01Pp39Wub4vWUby/GH0nH/AFdWHddbiiG4g0/eReqByZhUU4S9xRy559HyltNUkJu4uVRbJzi4DABNeHsSNmiptddxgFlIez8Ilo+IBaskbLefslHktwECgq5v6J8gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f6uXcaQI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f6uXcaQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07551F000FF;
	Tue, 13 Oct 2026 12:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895970;
	bh=2YhySHjH77QE4LWAn06WhEalE2yiCNXXh1NxASDLMG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f6uXcaQI0QJR0QQU0uar9DNPcstMVObxIUdPUxt9NGBsjRUyWnagORIvsdcE11r3e
	 JH9FeW/D5E1yTxTGtE0fhIQZ/MMU7Ia8hyCO+RuPFARwoeMT4aDrH4j3j7o5NHcIu5
	 fFojUY+Yb25nvwFSP/3fSz09v8XfvZgMsyYz/R1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyi Guo <guoziyi114@gmail.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.12 417/497] riscv: entry: gate shadow call stack reload on sstatus.SPP, not tp
Date: Tue, 13 Oct 2026 13:39:44 +0200
Message-ID: <20261013112917.786345119@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Ziyi Guo <guoziyi114@gmail.com>

commit 4d0697f192975dab5985e921989be1d85cf580e9 upstream.

Under CONFIG_SHADOW_CALL_STACK, handle_exception() reloads the kernel
shadow call stack pointer (gp) only when the trap came from userspace.
It made that decision with scs_load_current_if_task_changed, which
compares the trap-time tp (read back from sscratch into s5) against the
current tp:

	beq	\prev, tp, _skip_scs
	scs_load_current
_skip_scs:

tp is a user-writable register.  A user task that sets tp to the
linear-map address of its own task_struct (&current) before trapping
makes the comparison succeed (can achieve by brute force with KASLR
enable under our test), so the kernel skips scs_load_current and
keeps running with the gp that userspace left in place.  Under
CONFIG_SHADOW_CALL_STACK gp is the shadow call stack pointer and
load_global_pointer is a no-op, so the compiler-emitted
"sd ra, -8(gp)" / "ld ra, -8(gp)" in every non-leaf function then write
to, and return through, an attacker-controlled address -- an
unprivileged kernel arbitrary-write and control-flow-hijack primitive.
The poisoned gp is saved to task_struct.scs_sp on return, so the reload
is skipped on every subsequent entry as well.

Decide "came from userspace" from the hardware sstatus.SPP bit (already
in s1 at this point) instead of from tp, mirroring the check that
ret_from_exception already uses a few instructions later.  SPP is
written by hardware on trap entry and cannot be forged from U-mode.
Legitimate behaviour is unchanged: user entries (SPP=0) reload the task
shadow call stack, nested kernel entries (SPP=1) skip it.

Fixes: d1584d791a29 ("riscv: Implement Shadow Call Stack")
Signed-off-by: Ziyi Guo <guoziyi114@gmail.com>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Link: https://patch.msgid.link/20261001135711.934152-1-guoziyi114@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/scs.h |   17 +++++++++++++----
 arch/riscv/kernel/entry.S    |    2 +-
 2 files changed, 14 insertions(+), 5 deletions(-)

--- a/arch/riscv/include/asm/scs.h
+++ b/arch/riscv/include/asm/scs.h
@@ -4,6 +4,7 @@
 
 #ifdef __ASSEMBLY__
 #include <asm/asm-offsets.h>
+#include <asm/csr.h>
 
 #ifdef CONFIG_SHADOW_CALL_STACK
 
@@ -23,9 +24,17 @@
 	REG_L	gp, TASK_TI_SCS_SP(tp)
 .endm
 
-/* Load task_scs_sp(current) to gp, but only if tp has changed. */
-.macro scs_load_current_if_task_changed prev
-	beq	\prev, tp, _skip_scs
+/*
+ * Load task_scs_sp(current) to gp, but only when the trap came from U-mode.
+ * The source privilege level is taken from the saved sstatus.SPP bit (written
+ * by hardware on trap entry), not by comparing tp.  tp is a user-writable
+ * register, so gating the shadow call stack reload on it let a user task that
+ * set tp == &current skip the reload and run the kernel with an attacker
+ * controlled gp (the shadow call stack pointer).
+ */
+.macro scs_load_current_if_from_user status, tmp
+	andi	\tmp, \status, SR_SPP
+	bnez	\tmp, _skip_scs
 	scs_load_current
 _skip_scs:
 .endm
@@ -43,7 +52,7 @@ _skip_scs:
 .endm
 .macro scs_load_current
 .endm
-.macro scs_load_current_if_task_changed prev
+.macro scs_load_current_if_from_user status, tmp
 .endm
 .macro scs_save_current
 .endm
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -173,7 +173,7 @@ SYM_CODE_START(handle_exception)
 	load_global_pointer
 
 	/* Load the kernel shadow call stack pointer if coming from userspace */
-	scs_load_current_if_task_changed s5
+	scs_load_current_if_from_user s1, s5
 
 #ifdef CONFIG_RISCV_ISA_V_PREEMPTIVE
 	move a0, sp


