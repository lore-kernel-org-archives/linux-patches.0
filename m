Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BBD14A4DF;
	Thu, 11 Apr 2024 10:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831832; cv=none; b=ibM/qzW0nH6fPldfh+GpCiQDB3QY0zJLhCZvSEHFzlCAlulJCzQyOlh4FLxc4PdKHqbIRMzvPYYl1A86WESqW+9oAm2dTaWChUGDkDMIzgB6oNyVBlFsG9xnvziHWfdlm63x50ygHV9vPV7GADEG04PZHUWc+9ePvXl3xwS9O9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831832; c=relaxed/simple;
	bh=qk5vKb6xdFgEJAkxtt45I85/vsldIwXBsRS/h2PM+iM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9ydIPyd7m5aP/6h/QIPlIj+r+N9R2eLQgIl5o1txMsF1+GEUdxLj8Gg7SxLFAQT8QoNG9qPTVUmQ6jO3olKNiLhNQrZmb6gdKRrADiGdvH75z+ItpvvR0BQv9BPFOFBWBZfDf9wdQGznF8RS7FrtTU60KP+GO9dE6oeRHA0sq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JuF1LJRI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JuF1LJRI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E1A2C43390;
	Thu, 11 Apr 2024 10:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831832;
	bh=qk5vKb6xdFgEJAkxtt45I85/vsldIwXBsRS/h2PM+iM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JuF1LJRI9da2PWiDmi+GoB1lg/9gYQWz9TaMMgaL+4QU9JfuqOFOzyDZYUs/cEDRo
	 ytI4yOf05n3mAx3zKdNgMcZ1Ugijz7qdUb0Scflprl0OUax5kd7ZQWAmhZrAoj2OFI
	 q8F6bHFEX0mycuEo13JE+Kxwx67EAEiPRrc0h2rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@intel.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 5.10 140/294] x86/entry_64: Add VERW just before userspace transition
Date: Thu, 11 Apr 2024 11:55:03 +0200
Message-ID: <20240411095439.872263227@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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

  1. It is rare to get an NMI after VERW, but before returning to user.
  2. For an unprivileged user, there is no known way to make that NMI
     less rare or target it.
  3. It would take a large number of these precisely-timed NMIs to mount
     an actual attack.  There's presumably not enough bandwidth.
  4. The NMI in question occurs after a VERW, i.e. when user state is
     restored and most interesting data is already scrubbed. Whats left
     is only the data that NMI touches, and that may or may not be of
     any interest.

  [ pawan: resolved conflict in syscall_return_via_sysret, added
           CLEAR_CPU_BUFFERS to USERGS_SYSRET64 ]

Suggested-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/20240213-delay-verw-v8-2-a6216d83edb7%40linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry_64.S        |   10 ++++++++++
 arch/x86/entry/entry_64_compat.S |    1 +
 arch/x86/include/asm/irqflags.h  |    1 +
 3 files changed, 12 insertions(+)

--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -615,6 +615,7 @@ SYM_INNER_LABEL(swapgs_restore_regs_and_
 	/* Restore RDI. */
 	popq	%rdi
 	SWAPGS
+	CLEAR_CPU_BUFFERS
 	INTERRUPT_RETURN
 
 
@@ -721,6 +722,8 @@ native_irq_return_ldt:
 	 */
 	popq	%rax				/* Restore user RAX */
 
+	CLEAR_CPU_BUFFERS
+
 	/*
 	 * RSP now points to an ordinary IRET frame, except that the page
 	 * is read-only and RSP[31:16] are preloaded with the userspace
@@ -1488,6 +1491,12 @@ nmi_restore:
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
@@ -1504,6 +1513,7 @@ SYM_CODE_END(asm_exc_nmi)
 SYM_CODE_START(ignore_sysret)
 	UNWIND_HINT_EMPTY
 	mov	$-ENOSYS, %eax
+	CLEAR_CPU_BUFFERS
 	sysretl
 SYM_CODE_END(ignore_sysret)
 #endif
--- a/arch/x86/entry/entry_64_compat.S
+++ b/arch/x86/entry/entry_64_compat.S
@@ -319,6 +319,7 @@ sysret32_from_system_call:
 	xorl	%r9d, %r9d
 	xorl	%r10d, %r10d
 	swapgs
+	CLEAR_CPU_BUFFERS
 	sysretl
 SYM_CODE_END(entry_SYSCALL_compat)
 
--- a/arch/x86/include/asm/irqflags.h
+++ b/arch/x86/include/asm/irqflags.h
@@ -134,6 +134,7 @@ static __always_inline unsigned long arc
 #define INTERRUPT_RETURN	jmp native_iret
 #define USERGS_SYSRET64				\
 	swapgs;					\
+	CLEAR_CPU_BUFFERS;			\
 	sysretq;
 #define USERGS_SYSRET32				\
 	swapgs;					\


