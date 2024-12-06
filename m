Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9558113E03A;
	Fri,  6 Dec 2024 15:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497493; cv=none; b=n2YymobA6snHzw7ePvYIbztHLlQrCfbZoRpVv4fobz2sap0JCG0IqNBzfK5j8s/8MXYk08KBBDMnSk7pQvJNNqvuISnqYX1ItK2zbT0Tz0caFxU09BKKK6FBm6+GXUWN8JTZ1JEYhKtImfwln2JLVqlcnQLLn2V3FWkSI9GLAmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497493; c=relaxed/simple;
	bh=Upfg6QJbcaVN2wIyvCbnjuFjETMDnne5ryKcgEVdwMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTRXq19AmTNpJ7CuK+hrmylmF4TCzEFZc++jb3lWsF5bRzDHC/5LCyeGekwNJoMIFN8uhlT8ik5zaziezsg/D5KV3IHaI+nNi/X479S/SCfHDgJadSAK/KYwMLp806as58qdI20xpexb1P4wOI/yWQ3qNmcccUrCJfghwV0Cgd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KPKgLxek; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KPKgLxek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBD6C4CED1;
	Fri,  6 Dec 2024 15:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497493;
	bh=Upfg6QJbcaVN2wIyvCbnjuFjETMDnne5ryKcgEVdwMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KPKgLxekfyCCbPpO77Ua0id9yU8+gwY5AesmmJjGzWmmfBJLHFyFHbeplgCjfK+om
	 ujm3jKnxbReMR74r9GOacQSZhO6Ldk33vlNOYmSra5vJFwdgNrTvt5KBxQl15WqeLa
	 CHH/r+UT1g2J8m+bOK2zmuKmZB1MX4JO9772sLck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Kai Huang <kai.huang@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 306/676] x86/tdx: Skip saving output regs when SEAMCALL fails with VMFailInvalid
Date: Fri,  6 Dec 2024 15:32:05 +0100
Message-ID: <20241206143705.293540160@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Huang <kai.huang@intel.com>

[ Upstream commit 03a423d40cb30e0e1cb77a801acb56ddb0bf6f5e ]

If SEAMCALL fails with VMFailInvalid, the SEAM software (e.g., the TDX
module) won't have chance to set any output register.  Skip saving the
output registers to the structure in this case.

Also, as '.Lno_output_struct' is the very last symbol before RET, rename
it to '.Lout' to make it short.

Opportunistically make the asm directives unindented.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/all/704088f5b4d72c7e24084f7f15bd1ac5005b7213.1692096753.git.kai.huang%40intel.com
Stable-dep-of: f65aa0ad79fc ("x86/tdx: Dynamically disable SEPT violations from causing #VEs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/coco/tdx/tdcall.S      |  3 ---
 arch/x86/virt/vmx/tdx/tdxcall.S | 29 ++++++++++++++++++++---------
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/arch/x86/coco/tdx/tdcall.S b/arch/x86/coco/tdx/tdcall.S
index 2eca5f43734fe..e5d4b7d8ecd4a 100644
--- a/arch/x86/coco/tdx/tdcall.S
+++ b/arch/x86/coco/tdx/tdcall.S
@@ -78,10 +78,7 @@
  * Return status of TDCALL via RAX.
  */
 SYM_FUNC_START(__tdx_module_call)
-	FRAME_BEGIN
 	TDX_MODULE_CALL host=0
-	FRAME_END
-	RET
 SYM_FUNC_END(__tdx_module_call)
 
 /*
diff --git a/arch/x86/virt/vmx/tdx/tdxcall.S b/arch/x86/virt/vmx/tdx/tdxcall.S
index 49a54356ae992..6bdf6e1379534 100644
--- a/arch/x86/virt/vmx/tdx/tdxcall.S
+++ b/arch/x86/virt/vmx/tdx/tdxcall.S
@@ -1,5 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #include <asm/asm-offsets.h>
+#include <asm/frame.h>
 #include <asm/tdx.h>
 
 /*
@@ -18,6 +19,7 @@
  *            TDX module.
  */
 .macro TDX_MODULE_CALL host:req
+	FRAME_BEGIN
 	/*
 	 * R12 will be used as temporary storage for struct tdx_module_output
 	 * pointer. Since R12-R15 registers are not used by TDCALL/SEAMCALL
@@ -44,7 +46,7 @@
 	mov %rsi, %rcx
 	/* Leave input param 2 in RDX */
 
-	.if \host
+.if \host
 	seamcall
 	/*
 	 * SEAMCALL instruction is essentially a VMExit from VMX root
@@ -57,13 +59,10 @@
 	 * This value will never be used as actual SEAMCALL error code as
 	 * it is from the Reserved status code class.
 	 */
-	jnc .Lno_vmfailinvalid
-	mov $TDX_SEAMCALL_VMFAILINVALID, %rax
-.Lno_vmfailinvalid:
-
-	.else
+	jc .Lseamcall_vmfailinvalid
+.else
 	tdcall
-	.endif
+.endif
 
 	/*
 	 * Fetch output pointer from stack to R12 (It is used
@@ -80,7 +79,7 @@
 	 * Other registers may contain details of the failure.
 	 */
 	test %r12, %r12
-	jz .Lno_output_struct
+	jz .Lout
 
 	/* Copy result registers to output struct: */
 	movq %rcx, TDX_MODULE_rcx(%r12)
@@ -90,7 +89,19 @@
 	movq %r10, TDX_MODULE_r10(%r12)
 	movq %r11, TDX_MODULE_r11(%r12)
 
-.Lno_output_struct:
+.Lout:
 	/* Restore the state of R12 register */
 	pop %r12
+
+	FRAME_END
+	RET
+
+.if \host
+.Lseamcall_vmfailinvalid:
+	mov $TDX_SEAMCALL_VMFAILINVALID, %rax
+	/* pop the unused output pointer back to %r9 */
+	pop %r9
+	jmp .Lout
+.endif	/* \host */
+
 .endm
-- 
2.43.0



