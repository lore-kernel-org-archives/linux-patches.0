Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8142FA62D;
	Tue, 17 Jun 2025 16:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178482; cv=none; b=SWSizmeSxVuDSa/MmBF+1t3ZdyJntEpNoqnBdvvztF7w3CFl1cDeW9nj5+Ebp6w5j5AJqXSK+2Tqbt2z9jt5tBHRq792BZE1mpQ9DUcLEo53Dw+1svgnnNS5puT7wH+gMy8UGoofvFR7iwZm3O0tDqH/kQmhmRqamx/G8/Xr4v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178482; c=relaxed/simple;
	bh=l8rxJ8RkEfOpnW7BQ3irEEWjkuv6xPNbgXLiOmIMsdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OVqOthnixUKrljpQLmsqGDdhBsoLWqQFsCiz8ksAEcmE+/sxMh9rpiNSfP08tGJFYfOwqrApGudPBnyNTJ8VZz3+dj6DbkikpElikS3ylePe8OKe/1RoC150CW8APh9jPf8RdGlAeWiv31Kqv803xRQ4bgd9VcaCvp3R3MPIUUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=boCyeBBq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="boCyeBBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E53C4CEE3;
	Tue, 17 Jun 2025 16:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178482;
	bh=l8rxJ8RkEfOpnW7BQ3irEEWjkuv6xPNbgXLiOmIMsdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=boCyeBBqQGMw8oDTnUTnOxD4D30F5Iwv0ohJ61uHd2mfC6nOG1oviWINBSfwgP+hF
	 vTjkWRfWtounO0ebxvxC/8ppVSgSFJ75hHunH+0zlDgqvLFkfLcFPovYFpFlusZfXa
	 gMhkujomzd96muMQk+HWHH1WdB5fzcyyD0cnV3ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"H. Peter Anvin (Intel)" <hpa@zytor.com>,
	"Xin Li (Intel)" <xin@zytor.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sohil Mehta <sohil.mehta@intel.com>
Subject: [PATCH 6.12 505/512] x86/fred/signal: Prevent immediate repeat of single step trap on return from SIGTRAP handler
Date: Tue, 17 Jun 2025 17:27:51 +0200
Message-ID: <20250617152440.082336050@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Li (Intel) <xin@zytor.com>

commit e34dbbc85d64af59176fe59fad7b4122f4330fe2 upstream.

Clear the software event flag in the augmented SS to prevent immediate
repeat of single step trap on return from SIGTRAP handler if the trap
flag (TF) is set without an external debugger attached.

Following is a typical single-stepping flow for a user process:

1) The user process is prepared for single-stepping by setting
   RFLAGS.TF = 1.
2) When any instruction in user space completes, a #DB is triggered.
3) The kernel handles the #DB and returns to user space, invoking the
   SIGTRAP handler with RFLAGS.TF = 0.
4) After the SIGTRAP handler finishes, the user process performs a
   sigreturn syscall, restoring the original state, including
   RFLAGS.TF = 1.
5) Goto step 2.

According to the FRED specification:

A) Bit 17 in the augmented SS is designated as the software event
   flag, which is set to 1 for FRED event delivery of SYSCALL,
   SYSENTER, or INT n.
B) If bit 17 of the augmented SS is 1 and ERETU would result in
   RFLAGS.TF = 1, a single-step trap will be pending upon completion
   of ERETU.

In step 4) above, the software event flag is set upon the sigreturn
syscall, and its corresponding ERETU would restore RFLAGS.TF = 1.
This combination causes a pending single-step trap upon completion of
ERETU.  Therefore, another #DB is triggered before any user space
instruction is executed, which leads to an infinite loop in which the
SIGTRAP handler keeps being invoked on the same user space IP.

Fixes: 14619d912b65 ("x86/fred: FRED entry/exit and dispatch code")
Suggested-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Tested-by: Sohil Mehta <sohil.mehta@intel.com>
Cc:stable@vger.kernel.org
Link: https://lore.kernel.org/all/20250609084054.2083189-2-xin%40zytor.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/sighandling.h |   22 ++++++++++++++++++++++
 arch/x86/kernel/signal_32.c        |    4 ++++
 arch/x86/kernel/signal_64.c        |    4 ++++
 3 files changed, 30 insertions(+)

--- a/arch/x86/include/asm/sighandling.h
+++ b/arch/x86/include/asm/sighandling.h
@@ -24,4 +24,26 @@ int ia32_setup_rt_frame(struct ksignal *
 int x64_setup_rt_frame(struct ksignal *ksig, struct pt_regs *regs);
 int x32_setup_rt_frame(struct ksignal *ksig, struct pt_regs *regs);
 
+/*
+ * To prevent immediate repeat of single step trap on return from SIGTRAP
+ * handler if the trap flag (TF) is set without an external debugger attached,
+ * clear the software event flag in the augmented SS, ensuring no single-step
+ * trap is pending upon ERETU completion.
+ *
+ * Note, this function should be called in sigreturn() before the original
+ * state is restored to make sure the TF is read from the entry frame.
+ */
+static __always_inline void prevent_single_step_upon_eretu(struct pt_regs *regs)
+{
+	/*
+	 * If the trap flag (TF) is set, i.e., the sigreturn() SYSCALL instruction
+	 * is being single-stepped, do not clear the software event flag in the
+	 * augmented SS, thus a debugger won't skip over the following instruction.
+	 */
+#ifdef CONFIG_X86_FRED
+	if (!(regs->flags & X86_EFLAGS_TF))
+		regs->fred_ss.swevent = 0;
+#endif
+}
+
 #endif /* _ASM_X86_SIGHANDLING_H */
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -152,6 +152,8 @@ SYSCALL32_DEFINE0(sigreturn)
 	struct sigframe_ia32 __user *frame = (struct sigframe_ia32 __user *)(regs->sp-8);
 	sigset_t set;
 
+	prevent_single_step_upon_eretu(regs);
+
 	if (!access_ok(frame, sizeof(*frame)))
 		goto badframe;
 	if (__get_user(set.sig[0], &frame->sc.oldmask)
@@ -175,6 +177,8 @@ SYSCALL32_DEFINE0(rt_sigreturn)
 	struct rt_sigframe_ia32 __user *frame;
 	sigset_t set;
 
+	prevent_single_step_upon_eretu(regs);
+
 	frame = (struct rt_sigframe_ia32 __user *)(regs->sp - 4);
 
 	if (!access_ok(frame, sizeof(*frame)))
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -250,6 +250,8 @@ SYSCALL_DEFINE0(rt_sigreturn)
 	sigset_t set;
 	unsigned long uc_flags;
 
+	prevent_single_step_upon_eretu(regs);
+
 	frame = (struct rt_sigframe __user *)(regs->sp - sizeof(long));
 	if (!access_ok(frame, sizeof(*frame)))
 		goto badframe;
@@ -366,6 +368,8 @@ COMPAT_SYSCALL_DEFINE0(x32_rt_sigreturn)
 	sigset_t set;
 	unsigned long uc_flags;
 
+	prevent_single_step_upon_eretu(regs);
+
 	frame = (struct rt_sigframe_x32 __user *)(regs->sp - 8);
 
 	if (!access_ok(frame, sizeof(*frame)))


