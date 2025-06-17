Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9BA2FA626;
	Tue, 17 Jun 2025 16:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179565; cv=none; b=YKctSbMgDUcs6jwwguh8ey6ofjYgGva+6IduIlp6CUpsm4wtw2Z4ovIZKcHrmy0BlyM6QLasxxGIe+6JxOFIlws/2JP1G+7swFzzIEspq7mHb8vfflOGLLv3FExhuzAv8+bnLQJi/0Smdy7TQ3GgbB51Cjw+sjsi/aki/b2rkO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179565; c=relaxed/simple;
	bh=RQqqlo0eXbjQ6O0raZxq1bMVa20CbsWywAhWlB58YMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eVS0EYgKjbz/G0823Ok0TAPmuROISw+b2VT/VB0LAkh2bt/wAkTkZoZrPYmMjeVvtWOUSQtHY1fo5SYnYoLbtDmyikRAAZNO2AJhANJmdBY3yUj9VX2nF/Aajr6JaziFer1JjshTFFIFP6K8hfce6vshu6qRoPWtGmUy4JHHy+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1KkRjME6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1KkRjME6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D060C4CEE3;
	Tue, 17 Jun 2025 16:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179565;
	bh=RQqqlo0eXbjQ6O0raZxq1bMVa20CbsWywAhWlB58YMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1KkRjME6Iw48UTElRcqvFAYT2pcEjsDCILboRXtWYGoFvrW+YcWxx8UiTrWGBbepZ
	 lYhOwmiDnj3Z39l5TgGZ8YFZ8kMXVPJHlOo5mbx28h9dhwFQv+6RCv8LWsghFWsfc4
	 sLj5Igx9+mkC7lMC+joGEMkWh/Cq+4qJBVKWwwHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"H. Peter Anvin (Intel)" <hpa@zytor.com>,
	"Xin Li (Intel)" <xin@zytor.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sohil Mehta <sohil.mehta@intel.com>
Subject: [PATCH 6.15 773/780] x86/fred/signal: Prevent immediate repeat of single step trap on return from SIGTRAP handler
Date: Tue, 17 Jun 2025 17:28:01 +0200
Message-ID: <20250617152522.991999794@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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


