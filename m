Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49841F9F6E;
	Tue,  3 Dec 2024 15:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238621; cv=none; b=JJ2/Ad6pZ18gY1e7uFFXaRebCPi5Qk7ZPtEKnO6PrM6seais6+PyzYZem08cvXfXGQU0SoAQN6Q4fYkjK2G7gc0V2hFv8oyCjZiXevOPTSDTdbH0LUr5LxSHo+HIKmS458aoXtJNGgy0sS0SbcXgrGMyQlM/LdlNKfEDS4uHfNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238621; c=relaxed/simple;
	bh=uObt0zRF1yP9QbV29wo3AjShE8ykN9W1gcyEvY0X274=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKHEw570CX+wQ2PKmzq8xx71DMAVLH9JiRT4w+lsYbMN11cU1ihtptPVa2CQ0zvGme2stKgN7ygOBun4Sl4jRCwlNbYYpjN0cFUzm3/kOczP1yf1J4c1oRN9irc3ctkdYkk1Qf0uVnZ0YRYexvvrR/aqf1y5RCXUwxM2c3GEFq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x5EWP6HQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x5EWP6HQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6815FC4CED6;
	Tue,  3 Dec 2024 15:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238620;
	bh=uObt0zRF1yP9QbV29wo3AjShE8ykN9W1gcyEvY0X274=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x5EWP6HQwAsGlc5OYp8/dNRYNeLI2aoic6HNdtcUXmV0dbeVj5zlGClWkwITOzzSN
	 hQoVmWQHDrto5b1l/0Yky5W/2L+INUE0lnd8i2DKvRZAik3i6k4SnUSGD2wVkkgLlY
	 BO96hA0/pE+90illsORDoxXZo1n2JLiBwdizM4bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <leon.hwang@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Quentin Monnet <qmo@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 309/817] bpf, bpftool: Fix incorrect disasm pc
Date: Tue,  3 Dec 2024 15:38:01 +0100
Message-ID: <20241203144007.879066256@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Hwang <leon.hwang@linux.dev>

[ Upstream commit 4d99e509c161f8610de125202c648fa4acd00541 ]

This patch addresses the bpftool issue "Wrong callq address displayed"[0].

The issue stemmed from an incorrect program counter (PC) value used during
disassembly with LLVM or libbfd.

For LLVM: The PC argument must represent the actual address in the kernel
to compute the correct relative address.

For libbfd: The relative address can be adjusted by adding func_ksym within
the custom info->print_address_func to yield the correct address.

Links:
[0] https://github.com/libbpf/bpftool/issues/109

Changes:
v2 -> v3:
  * Address comment from Quentin:
    * Remove the typedef.

v1 -> v2:
  * Fix the broken libbfd disassembler.

Fixes: e1947c750ffe ("bpftool: Refactor disassembler for JIT-ed programs")
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Tested-by: Quentin Monnet <qmo@kernel.org>
Reviewed-by: Quentin Monnet <qmo@kernel.org>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/bpf/20241031152844.68817-1-leon.hwang@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/jit_disasm.c | 40 ++++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 11 deletions(-)

diff --git a/tools/bpf/bpftool/jit_disasm.c b/tools/bpf/bpftool/jit_disasm.c
index 7b8d9ec89ebd3..c032d2c6ab6d5 100644
--- a/tools/bpf/bpftool/jit_disasm.c
+++ b/tools/bpf/bpftool/jit_disasm.c
@@ -80,7 +80,8 @@ symbol_lookup_callback(__maybe_unused void *disasm_info,
 static int
 init_context(disasm_ctx_t *ctx, const char *arch,
 	     __maybe_unused const char *disassembler_options,
-	     __maybe_unused unsigned char *image, __maybe_unused ssize_t len)
+	     __maybe_unused unsigned char *image, __maybe_unused ssize_t len,
+	     __maybe_unused __u64 func_ksym)
 {
 	char *triple;
 
@@ -109,12 +110,13 @@ static void destroy_context(disasm_ctx_t *ctx)
 }
 
 static int
-disassemble_insn(disasm_ctx_t *ctx, unsigned char *image, ssize_t len, int pc)
+disassemble_insn(disasm_ctx_t *ctx, unsigned char *image, ssize_t len, int pc,
+		 __u64 func_ksym)
 {
 	char buf[256];
 	int count;
 
-	count = LLVMDisasmInstruction(*ctx, image + pc, len - pc, pc,
+	count = LLVMDisasmInstruction(*ctx, image + pc, len - pc, func_ksym + pc,
 				      buf, sizeof(buf));
 	if (json_output)
 		printf_json(buf);
@@ -136,8 +138,21 @@ int disasm_init(void)
 #ifdef HAVE_LIBBFD_SUPPORT
 #define DISASM_SPACER "\t"
 
+struct disasm_info {
+	struct disassemble_info info;
+	__u64 func_ksym;
+};
+
+static void disasm_print_addr(bfd_vma addr, struct disassemble_info *info)
+{
+	struct disasm_info *dinfo = container_of(info, struct disasm_info, info);
+
+	addr += dinfo->func_ksym;
+	generic_print_address(addr, info);
+}
+
 typedef struct {
-	struct disassemble_info *info;
+	struct disasm_info *info;
 	disassembler_ftype disassemble;
 	bfd *bfdf;
 } disasm_ctx_t;
@@ -215,7 +230,7 @@ static int fprintf_json_styled(void *out,
 
 static int init_context(disasm_ctx_t *ctx, const char *arch,
 			const char *disassembler_options,
-			unsigned char *image, ssize_t len)
+			unsigned char *image, ssize_t len, __u64 func_ksym)
 {
 	struct disassemble_info *info;
 	char tpath[PATH_MAX];
@@ -238,12 +253,13 @@ static int init_context(disasm_ctx_t *ctx, const char *arch,
 	}
 	bfdf = ctx->bfdf;
 
-	ctx->info = malloc(sizeof(struct disassemble_info));
+	ctx->info = malloc(sizeof(struct disasm_info));
 	if (!ctx->info) {
 		p_err("mem alloc failed");
 		goto err_close;
 	}
-	info = ctx->info;
+	ctx->info->func_ksym = func_ksym;
+	info = &ctx->info->info;
 
 	if (json_output)
 		init_disassemble_info_compat(info, stdout,
@@ -272,6 +288,7 @@ static int init_context(disasm_ctx_t *ctx, const char *arch,
 		info->disassembler_options = disassembler_options;
 	info->buffer = image;
 	info->buffer_length = len;
+	info->print_address_func = disasm_print_addr;
 
 	disassemble_init_for_target(info);
 
@@ -304,9 +321,10 @@ static void destroy_context(disasm_ctx_t *ctx)
 
 static int
 disassemble_insn(disasm_ctx_t *ctx, __maybe_unused unsigned char *image,
-		 __maybe_unused ssize_t len, int pc)
+		 __maybe_unused ssize_t len, int pc,
+		 __maybe_unused __u64 func_ksym)
 {
-	return ctx->disassemble(pc, ctx->info);
+	return ctx->disassemble(pc, &ctx->info->info);
 }
 
 int disasm_init(void)
@@ -331,7 +349,7 @@ int disasm_print_insn(unsigned char *image, ssize_t len, int opcodes,
 	if (!len)
 		return -1;
 
-	if (init_context(&ctx, arch, disassembler_options, image, len))
+	if (init_context(&ctx, arch, disassembler_options, image, len, func_ksym))
 		return -1;
 
 	if (json_output)
@@ -360,7 +378,7 @@ int disasm_print_insn(unsigned char *image, ssize_t len, int opcodes,
 			printf("%4x:" DISASM_SPACER, pc);
 		}
 
-		count = disassemble_insn(&ctx, image, len, pc);
+		count = disassemble_insn(&ctx, image, len, pc, func_ksym);
 
 		if (json_output) {
 			/* Operand array, was started in fprintf_json. Before
-- 
2.43.0



