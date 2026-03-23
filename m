Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A8239A7EF;
	Mon, 23 Mar 2026 15:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278831; cv=none; b=VEmK5dbtp3HjcLz9f6I+M3AMyl/F46VzZxE96k35OZpSgW9vVFJZSPWFDyxSI0UXX/9DYPloyavqNN48OTGQaR/GOblmG1QLkGzbFLzdp+xGP37TVRmRf/SdClpuKSqtEMPChHgHSj9tE5zGRVMTXbGf8/ge5XeAGuPV15mMoog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278831; c=relaxed/simple;
	bh=yrVP9z37BGd8etf5VXgSagBQO6XYx4lWY8aSAvwahO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJm1aoTmoVmFr5vTrAFJa91jfLzJnCr7eowFFcEOO99CjFjSaos8cCGsapshvsaHXfQdXN9W8KzqVZFcFVjLwHk2h90p7cNJky5PnM689SfhqaTjrOGLtwS6ghJPG4/cE1kx1cxr3g62aAaVSGI1wAp3okpiZRAhfQK+ETYxe/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0t45pNPe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0t45pNPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BB3C2BCB3;
	Mon, 23 Mar 2026 15:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278831;
	bh=yrVP9z37BGd8etf5VXgSagBQO6XYx4lWY8aSAvwahO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0t45pNPePHBHSboccXjBcWxFsDx5cx9i0Ylpu0wLlhC8WhwLQ7aYq6h/zRtiloBCm
	 Wfy7b2AsMgr5Gn0dWdo1HrWtCfoMiYeEFd9Chwlr5wYtBJGRMptIsZPtGA3Ch8AfwJ
	 XOXOUu8bJpd0r/2aIvfmma8Xjsp/PB9w7YlBK1FE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Wenshan Lan <jetlan9@163.com>
Subject: [PATCH 6.6 416/567] x86/sev: Harden #VC instruction emulation somewhat
Date: Mon, 23 Mar 2026 14:45:36 +0100
Message-ID: <20260323134544.180238029@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Borislav Petkov (AMD)" <bp@alien8.de>

[ Upstream commit e3ef461af35a8c74f2f4ce6616491ddb355a208f ]

Compare the opcode bytes at rIP for each #VC exit reason to verify the
instruction which raised the #VC exception is actually the right one.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/20240105101407.11694-1-bp@alien8.de
Signed-off-by: Wenshan Lan <jetlan9@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/sev.c |    4 +
 arch/x86/kernel/sev-shared.c   |  102 ++++++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/sev.c          |    5 +-
 3 files changed, 108 insertions(+), 3 deletions(-)

--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -277,6 +277,10 @@ void do_boot_stage2_vc(struct pt_regs *r
 	if (result != ES_OK)
 		goto finish;
 
+	result = vc_check_opcode_bytes(&ctxt, exit_code);
+	if (result != ES_OK)
+		goto finish;
+
 	switch (exit_code) {
 	case SVM_EXIT_RDTSC:
 	case SVM_EXIT_RDTSCP:
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -10,11 +10,15 @@
  */
 
 #ifndef __BOOT_COMPRESSED
-#define error(v)	pr_err(v)
-#define has_cpuflag(f)	boot_cpu_has(f)
+#define error(v)			pr_err(v)
+#define has_cpuflag(f)			boot_cpu_has(f)
+#define sev_printk(fmt, ...)		printk(fmt, ##__VA_ARGS__)
+#define sev_printk_rtl(fmt, ...)	printk_ratelimited(fmt, ##__VA_ARGS__)
 #else
 #undef WARN
 #define WARN(condition, format...) (!!(condition))
+#define sev_printk(fmt, ...)
+#define sev_printk_rtl(fmt, ...)
 #endif
 
 /* I/O parameters for CPUID-related helpers */
@@ -570,6 +574,7 @@ void __head do_vc_no_ghcb(struct pt_regs
 {
 	unsigned int subfn = lower_bits(regs->cx, 32);
 	unsigned int fn = lower_bits(regs->ax, 32);
+	u16 opcode = *(unsigned short *)regs->ip;
 	struct cpuid_leaf leaf;
 	int ret;
 
@@ -577,6 +582,10 @@ void __head do_vc_no_ghcb(struct pt_regs
 	if (exit_code != SVM_EXIT_CPUID)
 		goto fail;
 
+	/* Is it really a CPUID insn? */
+	if (opcode != 0xa20f)
+		goto fail;
+
 	leaf.fn = fn;
 	leaf.subfn = subfn;
 
@@ -1203,3 +1212,92 @@ static int vmgexit_psc(struct ghcb *ghcb
 out:
 	return ret;
 }
+
+static enum es_result vc_check_opcode_bytes(struct es_em_ctxt *ctxt,
+					    unsigned long exit_code)
+{
+	unsigned int opcode = (unsigned int)ctxt->insn.opcode.value;
+	u8 modrm = ctxt->insn.modrm.value;
+
+	switch (exit_code) {
+
+	case SVM_EXIT_IOIO:
+	case SVM_EXIT_NPF:
+		/* handled separately */
+		return ES_OK;
+
+	case SVM_EXIT_CPUID:
+		if (opcode == 0xa20f)
+			return ES_OK;
+		break;
+
+	case SVM_EXIT_INVD:
+		if (opcode == 0x080f)
+			return ES_OK;
+		break;
+
+	case SVM_EXIT_MONITOR:
+		if (opcode == 0x010f && modrm == 0xc8)
+			return ES_OK;
+		break;
+
+	case SVM_EXIT_MWAIT:
+		if (opcode == 0x010f && modrm == 0xc9)
+			return ES_OK;
+		break;
+
+	case SVM_EXIT_MSR:
+		/* RDMSR */
+		if (opcode == 0x320f ||
+		/* WRMSR */
+		    opcode == 0x300f)
+			return ES_OK;
+		break;
+
+	case SVM_EXIT_RDPMC:
+		if (opcode == 0x330f)
+			return ES_OK;
+		break;
+
+	case SVM_EXIT_RDTSC:
+		if (opcode == 0x310f)
+			return ES_OK;
+		break;
+
+	case SVM_EXIT_RDTSCP:
+		if (opcode == 0x010f && modrm == 0xf9)
+			return ES_OK;
+		break;
+
+	case SVM_EXIT_READ_DR7:
+		if (opcode == 0x210f &&
+		    X86_MODRM_REG(ctxt->insn.modrm.value) == 7)
+			return ES_OK;
+		break;
+
+	case SVM_EXIT_VMMCALL:
+		if (opcode == 0x010f && modrm == 0xd9)
+			return ES_OK;
+
+		break;
+
+	case SVM_EXIT_WRITE_DR7:
+		if (opcode == 0x230f &&
+		    X86_MODRM_REG(ctxt->insn.modrm.value) == 7)
+			return ES_OK;
+		break;
+
+	case SVM_EXIT_WBINVD:
+		if (opcode == 0x90f)
+			return ES_OK;
+		break;
+
+	default:
+		break;
+	}
+
+	sev_printk(KERN_ERR "Wrong/unhandled opcode bytes: 0x%x, exit_code: 0x%lx, rIP: 0x%lx\n",
+		   opcode, exit_code, ctxt->regs->ip);
+
+	return ES_UNSUPPORTED;
+}
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -1749,7 +1749,10 @@ static enum es_result vc_handle_exitcode
 					 struct ghcb *ghcb,
 					 unsigned long exit_code)
 {
-	enum es_result result;
+	enum es_result result = vc_check_opcode_bytes(ctxt, exit_code);
+
+	if (result != ES_OK)
+		return result;
 
 	switch (exit_code) {
 	case SVM_EXIT_READ_DR7:


