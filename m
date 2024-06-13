Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67DD13D881;
	Thu, 13 Jun 2024 12:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280676; cv=none; b=o/PIx6AHJpJf9ylErobIaME8jyNSdzLxSa+sfOXpN6+7EHyfneNpATr4cBniPA0wrJrUCAkUHF/KaVIntr23XiaGpFmU9JMgvSSn2JRYmwMJG6fmYFdBnyTSFbr4ShNjtiJAuK3J8iC0iwEUHhQQpz6XzRURI2CndWbsgjMHgto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280676; c=relaxed/simple;
	bh=kqNdxCCy/6NBCMm7jOBjSTrmZwVLcxmDu642YbhgBfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T5ZAV66ydGbhnsyt+YYqc98R1KwVxOAkYRdVe6tWaLmdT3MQbdP3BHKyqgEXoTtBnLIhKj7uL+nd4BzNrDb35DUJFxmvMoCa2/toNwLCFfCZeKLOx3FpEsc7gJ9nlC13eAIBtW3nb9DnEPS4+/53/99SpAnPY+7+P65YXYjPzKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X5sFt3F+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X5sFt3F+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED36C2BBFC;
	Thu, 13 Jun 2024 12:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280676;
	bh=kqNdxCCy/6NBCMm7jOBjSTrmZwVLcxmDu642YbhgBfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X5sFt3F+HV726Svvt8iV3tGpg1dg9kKRgz8EgnFrl6cwrtQiWm5VzU0mlEbwgiS35
	 sD2TI6BSAdCrHVBtQRW01LSofxq37epynmkMtWwlxKWF/KwCE/E1ckLl9AzYncXIsH
	 Uvg2e/JC3s3hRVNQUHLNTGRVcoMfS/O9Jf6R03pA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Bathini <hbathini@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.6 134/137] powerpc/64/bpf: fix tail calls for PCREL addressing
Date: Thu, 13 Jun 2024 13:35:14 +0200
Message-ID: <20240613113228.500841625@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

From: Hari Bathini <hbathini@linux.ibm.com>

commit 2ecfe59cd7de1f202e9af2516a61fbbf93d0bd4d upstream.

With PCREL addressing, there is no kernel TOC. So, it is not setup in
prologue when PCREL addressing is used. But the number of instructions
to skip on a tail call was not adjusted accordingly. That resulted in
not so obvious failures while using tailcalls. 'tailcalls' selftest
crashed the system with the below call trace:

  bpf_test_run+0xe8/0x3cc (unreliable)
  bpf_prog_test_run_skb+0x348/0x778
  __sys_bpf+0xb04/0x2b00
  sys_bpf+0x28/0x38
  system_call_exception+0x168/0x340
  system_call_vectored_common+0x15c/0x2ec

Also, as bpf programs are always module addresses and a bpf helper in
general is a core kernel text address, using PC relative addressing
often fails with "out of range of pcrel address" error. Switch to
using kernel base for relative addressing to handle this better.

Fixes: 7e3a68be42e1 ("powerpc/64: vmlinux support building with PCREL addresing")
Cc: stable@vger.kernel.org # v6.4+
Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240502173205.142794-1-hbathini@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/net/bpf_jit_comp64.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -202,7 +202,8 @@ void bpf_jit_build_epilogue(u32 *image,
 	EMIT(PPC_RAW_BLR());
 }
 
-static int bpf_jit_emit_func_call_hlp(u32 *image, struct codegen_context *ctx, u64 func)
+static int
+bpf_jit_emit_func_call_hlp(u32 *image, u32 *fimage, struct codegen_context *ctx, u64 func)
 {
 	unsigned long func_addr = func ? ppc_function_entry((void *)func) : 0;
 	long reladdr;
@@ -211,19 +212,20 @@ static int bpf_jit_emit_func_call_hlp(u3
 		return -EINVAL;
 
 	if (IS_ENABLED(CONFIG_PPC_KERNEL_PCREL)) {
-		reladdr = func_addr - CTX_NIA(ctx);
+		reladdr = func_addr - local_paca->kernelbase;
 
 		if (reladdr >= (long)SZ_8G || reladdr < -(long)SZ_8G) {
-			pr_err("eBPF: address of %ps out of range of pcrel address.\n",
-				(void *)func);
+			pr_err("eBPF: address of %ps out of range of 34-bit relative address.\n",
+			       (void *)func);
 			return -ERANGE;
 		}
-		/* pla r12,addr */
-		EMIT(PPC_PREFIX_MLS | __PPC_PRFX_R(1) | IMM_H18(reladdr));
-		EMIT(PPC_INST_PADDI | ___PPC_RT(_R12) | IMM_L(reladdr));
-		EMIT(PPC_RAW_MTCTR(_R12));
-		EMIT(PPC_RAW_BCTR());
-
+		EMIT(PPC_RAW_LD(_R12, _R13, offsetof(struct paca_struct, kernelbase)));
+		/* Align for subsequent prefix instruction */
+		if (!IS_ALIGNED((unsigned long)fimage + CTX_NIA(ctx), 8))
+			EMIT(PPC_RAW_NOP());
+		/* paddi r12,r12,addr */
+		EMIT(PPC_PREFIX_MLS | __PPC_PRFX_R(0) | IMM_H18(reladdr));
+		EMIT(PPC_INST_PADDI | ___PPC_RT(_R12) | ___PPC_RA(_R12) | IMM_L(reladdr));
 	} else {
 		reladdr = func_addr - kernel_toc_addr();
 		if (reladdr > 0x7FFFFFFF || reladdr < -(0x80000000L)) {
@@ -233,9 +235,9 @@ static int bpf_jit_emit_func_call_hlp(u3
 
 		EMIT(PPC_RAW_ADDIS(_R12, _R2, PPC_HA(reladdr)));
 		EMIT(PPC_RAW_ADDI(_R12, _R12, PPC_LO(reladdr)));
-		EMIT(PPC_RAW_MTCTR(_R12));
-		EMIT(PPC_RAW_BCTRL());
 	}
+	EMIT(PPC_RAW_MTCTR(_R12));
+	EMIT(PPC_RAW_BCTRL());
 
 	return 0;
 }
@@ -285,7 +287,7 @@ static int bpf_jit_emit_tail_call(u32 *i
 	int b2p_index = bpf_to_ppc(BPF_REG_3);
 	int bpf_tailcall_prologue_size = 8;
 
-	if (IS_ENABLED(CONFIG_PPC64_ELF_ABI_V2))
+	if (!IS_ENABLED(CONFIG_PPC_KERNEL_PCREL) && IS_ENABLED(CONFIG_PPC64_ELF_ABI_V2))
 		bpf_tailcall_prologue_size += 4; /* skip past the toc load */
 
 	/*
@@ -993,7 +995,7 @@ emit_clear:
 				return ret;
 
 			if (func_addr_fixed)
-				ret = bpf_jit_emit_func_call_hlp(image, ctx, func_addr);
+				ret = bpf_jit_emit_func_call_hlp(image, fimage, ctx, func_addr);
 			else
 				ret = bpf_jit_emit_func_call_rel(image, ctx, func_addr);
 


