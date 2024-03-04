Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECB17C0A7;
	Mon,  4 Mar 2024 21:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587948; cv=none; b=MUtLZosUkmkn4LVNLuBb45Ta1EgcwL/YOJr2ixgnwt0qCh/ZcOTTWVmNze7BQG/LPHnOwSBXY89VX0pMsT89yU5CwOdU8Gverp4CdAMieT8FkTMRj77if+lK7IhTOd1DwyQAvxUWVraWe+XXIXY0bdJ6yb4Xn9C0GqHjcDbIJK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587948; c=relaxed/simple;
	bh=+LlG2SVMsb1AezHtr67PCAGfAUhk3bjR5n2KUCHAuk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y6+jCkSMLD5NNuffycNhMX9F80u6axouqwpL6vQ4WquwiJII5Jh+nqMR9F0b7dcGLlBqyEU9nvy09IGmpLUbx9dpuoApF3/0dqBnW/tNODZ/loAeqxAWmBGUWedTXq6hT575Qbsuq0kQPIbDzc6UDn2cItwy9vroGqo3Fm9DSDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wqPk2ETo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wqPk2ETo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3061AC433F1;
	Mon,  4 Mar 2024 21:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587948;
	bh=+LlG2SVMsb1AezHtr67PCAGfAUhk3bjR5n2KUCHAuk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wqPk2ETo+n1yKHtOlQu8lJoaZNtaQZqiv/rl1n0Pr8/vvgzHCd9R4Ya182Zz/QK+h
	 99bAl+zjChZAhphqv8dMYuI3yi6Xxvb6T+s9YHaK/e0M44PzqxJcdM5aCQFujwQKtb
	 TjmOqEoSzI03GeUQaoQzl8A8cukaSHFr7RK+4Z8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@intel.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 6.7 152/162] x86/entry_64: Add VERW just before userspace transition
Date: Mon,  4 Mar 2024 21:23:37 +0000
Message-ID: <20240304211556.543394506@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit 3c7501722e6b31a6e56edd23cea5e77dbb9ffd1a upstream.

Mitigation for MDS is to use VERW instruction to clear any secrets in
CPU Buffers. Any memory accesses after VERW execution can still remain
in CPU buffers. It is safer to execute VERW late in return to user path
to minimize the window in which kernel data can end up in CPU buffers.
There are not many kernel secrets to be had after SWITCH_TO_USER_CR3.

Add support for deploying VERW mitigation after user register state is
restored. This helps minimize the chances of kernel data ending up into
CPU buffers after executing VERW.

Note that the mitigation at the new location is not yet enabled.

  Corner case not handled
  =======================
  Interrupts returning to kernel don't clear CPUs buffers since the
  exit-to-user path is expected to do that anyways. But, there could be
  a case when an NMI is generated in kernel after the exit-to-user path
  has cleared the buffers. This case is not handled and NMI returning to
  kernel don't clear CPU buffers because:

  1. It is rare to get an NMI after VERW, but before returning to userspace.
  2. For an unprivileged user, there is no known way to make that NMI
     less rare or target it.
  3. It would take a large number of these precisely-timed NMIs to mount
     an actual attack.  There's presumably not enough bandwidth.
  4. The NMI in question occurs after a VERW, i.e. when user state is
     restored and most interesting data is already scrubbed. Whats left
     is only the data that NMI touches, and that may or may not be of
     any interest.

  [ pawan: resolved conflict for hunk swapgs_restore_regs_and_return_to_usermode in backport ]

Suggested-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/20240213-delay-verw-v8-2-a6216d83edb7%40linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry_64.S        |   11 +++++++++++
 arch/x86/entry/entry_64_compat.S |    1 +
 2 files changed, 12 insertions(+)

--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -161,6 +161,7 @@ syscall_return_via_sysret:
 SYM_INNER_LABEL(entry_SYSRETQ_unsafe_stack, SYM_L_GLOBAL)
 	ANNOTATE_NOENDBR
 	swapgs
+	CLEAR_CPU_BUFFERS
 	sysretq
 SYM_INNER_LABEL(entry_SYSRETQ_end, SYM_L_GLOBAL)
 	ANNOTATE_NOENDBR
@@ -601,6 +602,7 @@ SYM_INNER_LABEL(swapgs_restore_regs_and_
 	/* Restore RDI. */
 	popq	%rdi
 	swapgs
+	CLEAR_CPU_BUFFERS
 	jmp	.Lnative_iret
 
 
@@ -712,6 +714,8 @@ native_irq_return_ldt:
 	 */
 	popq	%rax				/* Restore user RAX */
 
+	CLEAR_CPU_BUFFERS
+
 	/*
 	 * RSP now points to an ordinary IRET frame, except that the page
 	 * is read-only and RSP[31:16] are preloaded with the userspace
@@ -1439,6 +1443,12 @@ nmi_restore:
 	movq	$0, 5*8(%rsp)		/* clear "NMI executing" */
 
 	/*
+	 * Skip CLEAR_CPU_BUFFERS here, since it only helps in rare cases like
+	 * NMI in kernel after user state is restored. For an unprivileged user
+	 * these conditions are hard to meet.
+	 */
+
+	/*
 	 * iretq reads the "iret" frame and exits the NMI stack in a
 	 * single instruction.  We are returning to kernel mode, so this
 	 * cannot result in a fault.  Similarly, we don't need to worry
@@ -1455,6 +1465,7 @@ SYM_CODE_START(entry_SYSCALL32_ignore)
 	UNWIND_HINT_END_OF_STACK
 	ENDBR
 	mov	$-ENOSYS, %eax
+	CLEAR_CPU_BUFFERS
 	sysretl
 SYM_CODE_END(entry_SYSCALL32_ignore)
 
--- a/arch/x86/entry/entry_64_compat.S
+++ b/arch/x86/entry/entry_64_compat.S
@@ -270,6 +270,7 @@ SYM_INNER_LABEL(entry_SYSRETL_compat_uns
 	xorl	%r9d, %r9d
 	xorl	%r10d, %r10d
 	swapgs
+	CLEAR_CPU_BUFFERS
 	sysretl
 SYM_INNER_LABEL(entry_SYSRETL_compat_end, SYM_L_GLOBAL)
 	ANNOTATE_NOENDBR


