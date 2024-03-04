Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3090C1C6AB;
	Mon,  4 Mar 2024 21:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589166; cv=none; b=GDCwQgTMcpJL75Fh9s/W5xHftZ76QiN8lGGVyuS4G1JXH2uThY4W0QtCz19TaI1qJeWZZMxHsAoT5KATK6wZjgZtmVNmTol/U+Po8TnMn8xrKJIQi32G/ZlvhLeDtaA2HPkmo7XJtmackwRtMXPfGDb8o146SxE2pEx3tFUWCIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589166; c=relaxed/simple;
	bh=zZF/ybR2GrhySrqfjYe6e0a0DyFzEstJtiOjPXxU45w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KxdNvxKkw1JrSy8XIEUnXHXtzTL+cQaoBdl2zq1fNbk2qsRild8Egrn1KUWeydddzsQQTYJ7XmwVsAM7z24UOxycAFjI6yQUbcmQhoQwbv966TcMTt3LLkFwqXgw3wLIR9YtCLFtTiLVzhFEdfcEP0qO9QmdBk1lPTn2Q1xVALg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s6CUqRxP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s6CUqRxP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA408C433F1;
	Mon,  4 Mar 2024 21:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589166;
	bh=zZF/ybR2GrhySrqfjYe6e0a0DyFzEstJtiOjPXxU45w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s6CUqRxPjVM+KN7o8xlgf6osIlyWVSsFc1LcOreaCC/xxqvUjMXy5laqhPLffWzwB
	 hDFoA3Axu23AD1CaX1gSBHOCjxqCQ7y4qfnbAwZwmBDIh36GvmMzVGkmKeUVwVjViG
	 KuAJm2AQ7tpjG/nXXCRGOTfEB95GgJGhOK1vKvGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alyssa Milburn <alyssa.milburn@intel.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 6.1 206/215] x86/bugs: Add asm helpers for executing VERW
Date: Mon,  4 Mar 2024 21:24:29 +0000
Message-ID: <20240304211603.525758714@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit baf8361e54550a48a7087b603313ad013cc13386 upstream.

MDS mitigation requires clearing the CPU buffers before returning to
user. This needs to be done late in the exit-to-user path. Current
location of VERW leaves a possibility of kernel data ending up in CPU
buffers for memory accesses done after VERW such as:

  1. Kernel data accessed by an NMI between VERW and return-to-user can
     remain in CPU buffers since NMI returning to kernel does not
     execute VERW to clear CPU buffers.
  2. Alyssa reported that after VERW is executed,
     CONFIG_GCC_PLUGIN_STACKLEAK=y scrubs the stack used by a system
     call. Memory accesses during stack scrubbing can move kernel stack
     contents into CPU buffers.
  3. When caller saved registers are restored after a return from
     function executing VERW, the kernel stack accesses can remain in
     CPU buffers(since they occur after VERW).

To fix this VERW needs to be moved very late in exit-to-user path.

In preparation for moving VERW to entry/exit asm code, create macros
that can be used in asm. Also make VERW patching depend on a new feature
flag X86_FEATURE_CLEAR_CPU_BUF.

  [pawan: - Runtime patch jmp instead of verw in macro CLEAR_CPU_BUFFERS
	    due to lack of relative addressing support for relocations
	    in kernels < v6.5.
	  - Add UNWIND_HINT_EMPTY to avoid warning:
	    arch/x86/entry/entry.o: warning: objtool: mds_verw_sel+0x0: unreachable instruction]

Reported-by: Alyssa Milburn <alyssa.milburn@intel.com>
Suggested-by: Andrew Cooper <andrew.cooper3@citrix.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/20240213-delay-verw-v8-1-a6216d83edb7%40linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry.S               |   23 +++++++++++++++++++++++
 arch/x86/include/asm/cpufeatures.h   |    2 +-
 arch/x86/include/asm/nospec-branch.h |   15 +++++++++++++++
 3 files changed, 39 insertions(+), 1 deletion(-)

--- a/arch/x86/entry/entry.S
+++ b/arch/x86/entry/entry.S
@@ -6,6 +6,9 @@
 #include <linux/linkage.h>
 #include <asm/export.h>
 #include <asm/msr-index.h>
+#include <asm/unwind_hints.h>
+#include <asm/segment.h>
+#include <asm/cache.h>
 
 .pushsection .noinstr.text, "ax"
 
@@ -20,3 +23,23 @@ SYM_FUNC_END(entry_ibpb)
 EXPORT_SYMBOL_GPL(entry_ibpb);
 
 .popsection
+
+/*
+ * Define the VERW operand that is disguised as entry code so that
+ * it can be referenced with KPTI enabled. This ensure VERW can be
+ * used late in exit-to-user path after page tables are switched.
+ */
+.pushsection .entry.text, "ax"
+
+.align L1_CACHE_BYTES, 0xcc
+SYM_CODE_START_NOALIGN(mds_verw_sel)
+	UNWIND_HINT_EMPTY
+	ANNOTATE_NOENDBR
+	.word __KERNEL_DS
+.align L1_CACHE_BYTES, 0xcc
+SYM_CODE_END(mds_verw_sel);
+/* For KVM */
+EXPORT_SYMBOL_GPL(mds_verw_sel);
+
+.popsection
+
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -304,7 +304,7 @@
 #define X86_FEATURE_UNRET		(11*32+15) /* "" AMD BTB untrain return */
 #define X86_FEATURE_USE_IBPB_FW		(11*32+16) /* "" Use IBPB during runtime firmware calls */
 #define X86_FEATURE_RSB_VMEXIT_LITE	(11*32+17) /* "" Fill RSB on VM exit when EIBRS is enabled */
-
+#define X86_FEATURE_CLEAR_CPU_BUF	(11*32+18) /* "" Clear CPU buffers using VERW */
 
 #define X86_FEATURE_MSR_TSX_CTRL	(11*32+20) /* "" MSR IA32_TSX_CTRL (Intel) implemented */
 
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -194,6 +194,19 @@
 #endif
 .endm
 
+/*
+ * Macro to execute VERW instruction that mitigate transient data sampling
+ * attacks such as MDS. On affected systems a microcode update overloaded VERW
+ * instruction to also clear the CPU buffers. VERW clobbers CFLAGS.ZF.
+ *
+ * Note: Only the memory operand variant of VERW clears the CPU buffers.
+ */
+.macro CLEAR_CPU_BUFFERS
+	ALTERNATIVE "jmp .Lskip_verw_\@", "", X86_FEATURE_CLEAR_CPU_BUF
+	verw _ASM_RIP(mds_verw_sel)
+.Lskip_verw_\@:
+.endm
+
 #else /* __ASSEMBLY__ */
 
 #define ANNOTATE_RETPOLINE_SAFE					\
@@ -375,6 +388,8 @@ DECLARE_STATIC_KEY_FALSE(switch_mm_cond_
 
 DECLARE_STATIC_KEY_FALSE(mmio_stale_data_clear);
 
+extern u16 mds_verw_sel;
+
 #include <asm/segment.h>
 
 /**


