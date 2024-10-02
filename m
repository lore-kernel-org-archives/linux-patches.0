Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DAE29CE7;
	Wed,  2 Oct 2024 13:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876886; cv=none; b=Zxpu8nSvfZtoVl3T7c4rOrKTPPsigyBdzH+yPw7EsyifHtrNaYa5abHF6kC6xetWTbBkZPoLumlbH0Dcu8ooR8kyPJOhm3XSwfGGp0wV9FKmmwYcwbQEHHUpP/1N+0VvfN51ybHjh8WH5ZQ2yD8lTPr9x3ICCL9q+2RWGMrktlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876886; c=relaxed/simple;
	bh=hPfV0PHuHPL2cKkuwWTtd8M2ePYqfuw9fgtLIuYx+5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KWp5s7tmV/mBwsggkN1JLU5wmbSg32Ouyg9WSJx6rXhCwHjdfsOUe7/7T4VVPQWeCLeTXynSKHQ4HgY5Kl1B+UKsts54HY/mlxa0TaVWErccl+RXQa571QvfOoY88PhNpEgPZSq/fs++qbSBar6a72VYwksSfZbpfIHBCH83yOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k5W79Eyr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k5W79Eyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF35C4CEC2;
	Wed,  2 Oct 2024 13:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876886;
	bh=hPfV0PHuHPL2cKkuwWTtd8M2ePYqfuw9fgtLIuYx+5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k5W79Eyr+ROl0AjXBjnuk01R+oFBZ6o75dvn3JkQ2+Q9Y0oHtIdrxO+TM12vHfgwx
	 ivrjcb1LqQ+vgJBWLjCaiA2foLEZPosW+EbNn77AIFwEmAdY6/b+vBS4MegVBm/whY
	 jGUfJJti1irJbF2BJIV8rMJ8qFdUUvAXHFOGqkXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.11 562/695] objtool: Handle frame pointer related instructions
Date: Wed,  2 Oct 2024 14:59:20 +0200
Message-ID: <20241002125844.937337788@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit da5b2ad1c2f18834cb1ce429e2e5a5cf5cbdf21b upstream.

After commit a0f7085f6a63 ("LoongArch: Add RANDOMIZE_KSTACK_OFFSET
support"), there are three new instructions "addi.d $fp, $sp, 32",
"sub.d $sp, $sp, $t0" and "addi.d $sp, $fp, -32" for the secondary
stack in do_syscall(), then there is a objtool warning "return with
modified stack frame" and no handle_syscall() which is the previous
frame of do_syscall() in the call trace when executing the command
"echo l > /proc/sysrq-trigger".

objdump shows something like this:

0000000000000000 <do_syscall>:
   0:   02ff8063        addi.d          $sp, $sp, -32
   4:   29c04076        st.d            $fp, $sp, 16
   8:   29c02077        st.d            $s0, $sp, 8
   c:   29c06061        st.d            $ra, $sp, 24
  10:   02c08076        addi.d          $fp, $sp, 32
  ...
  74:   0011b063        sub.d           $sp, $sp, $t0
  ...
  a8:   4c000181        jirl            $ra, $t0, 0
  ...
  dc:   02ff82c3        addi.d          $sp, $fp, -32
  e0:   28c06061        ld.d            $ra, $sp, 24
  e4:   28c04076        ld.d            $fp, $sp, 16
  e8:   28c02077        ld.d            $s0, $sp, 8
  ec:   02c08063        addi.d          $sp, $sp, 32
  f0:   4c000020        jirl            $zero, $ra, 0

The instruction "sub.d $sp, $sp, $t0" changes the stack bottom and the
new stack size is a random value, in order to find the return address of
do_syscall() which is stored in the original stack frame after executing
"jirl $ra, $t0, 0", it should use fp which points to the original stack
top.

At the beginning, the thought is tended to decode the secondary stack
instruction "sub.d $sp, $sp, $t0" and set it as a label, then check this
label for the two frame pointer instructions to change the cfa base and
cfa offset during the period of secondary stack in update_cfi_state().
This is valid for GCC but invalid for Clang due to there are different
secondary stack instructions for ClangBuiltLinux on LoongArch, something
like this:

0000000000000000 <do_syscall>:
  ...
  88:   00119064        sub.d           $a0, $sp, $a0
  8c:   00150083        or              $sp, $a0, $zero
  ...

Actually, it equals to a single instruction "sub.d $sp, $sp, $a0", but
there is no proper condition to check it as a label like GCC, and so the
beginning thought is not a good way.

Essentially, there are two special frame pointer instructions which are
"addi.d $fp, $sp, imm" and "addi.d $sp, $fp, imm", the first one points
fp to the original stack top and the second one restores the original
stack bottom from fp.

Based on the above analysis, in order to avoid adding an arch-specific
update_cfi_state(), we just add a member "frame_pointer" in the "struct
symbol" as a label to avoid affecting the current normal case, then set
it as true only if there is "addi.d $sp, $fp, imm". The last is to check
this label for the two frame pointer instructions to change the cfa base
and cfa offset in update_cfi_state().

Tested with the following two configs:
(1) CONFIG_RANDOMIZE_KSTACK_OFFSET=y &&
    CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT=n
(2) CONFIG_RANDOMIZE_KSTACK_OFFSET=y &&
    CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT=y

By the way, there is no effect for x86 with this patch, tested on the
x86 machine with Fedora 40 system.

Cc: stable@vger.kernel.org # 6.9+
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/arch/loongarch/decode.c |   11 ++++++++++-
 tools/objtool/check.c                 |   23 ++++++++++++++++++++---
 tools/objtool/include/objtool/elf.h   |    1 +
 3 files changed, 31 insertions(+), 4 deletions(-)

--- a/tools/objtool/arch/loongarch/decode.c
+++ b/tools/objtool/arch/loongarch/decode.c
@@ -122,7 +122,7 @@ static bool decode_insn_reg2i12_fomat(un
 	switch (inst.reg2i12_format.opcode) {
 	case addid_op:
 		if ((inst.reg2i12_format.rd == CFI_SP) || (inst.reg2i12_format.rj == CFI_SP)) {
-			/* addi.d sp,sp,si12 or addi.d fp,sp,si12 */
+			/* addi.d sp,sp,si12 or addi.d fp,sp,si12 or addi.d sp,fp,si12 */
 			insn->immediate = sign_extend64(inst.reg2i12_format.immediate, 11);
 			ADD_OP(op) {
 				op->src.type = OP_SRC_ADD;
@@ -132,6 +132,15 @@ static bool decode_insn_reg2i12_fomat(un
 				op->dest.reg = inst.reg2i12_format.rd;
 			}
 		}
+		if ((inst.reg2i12_format.rd == CFI_SP) && (inst.reg2i12_format.rj == CFI_FP)) {
+			/* addi.d sp,fp,si12 */
+			struct symbol *func = find_func_containing(insn->sec, insn->offset);
+
+			if (!func)
+				return false;
+
+			func->frame_pointer = true;
+		}
 		break;
 	case ldd_op:
 		if (inst.reg2i12_format.rj == CFI_SP) {
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2993,10 +2993,27 @@ static int update_cfi_state(struct instr
 				break;
 			}
 
-			if (op->dest.reg == CFI_SP && op->src.reg == CFI_BP) {
+			if (op->dest.reg == CFI_BP && op->src.reg == CFI_SP &&
+			    insn->sym->frame_pointer) {
+				/* addi.d fp,sp,imm on LoongArch */
+				if (cfa->base == CFI_SP && cfa->offset == op->src.offset) {
+					cfa->base = CFI_BP;
+					cfa->offset = 0;
+				}
+				break;
+			}
 
-				/* lea disp(%rbp), %rsp */
-				cfi->stack_size = -(op->src.offset + regs[CFI_BP].offset);
+			if (op->dest.reg == CFI_SP && op->src.reg == CFI_BP) {
+				/* addi.d sp,fp,imm on LoongArch */
+				if (cfa->base == CFI_BP && cfa->offset == 0) {
+					if (insn->sym->frame_pointer) {
+						cfa->base = CFI_SP;
+						cfa->offset = -op->src.offset;
+					}
+				} else {
+					/* lea disp(%rbp), %rsp */
+					cfi->stack_size = -(op->src.offset + regs[CFI_BP].offset);
+				}
 				break;
 			}
 
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -68,6 +68,7 @@ struct symbol {
 	u8 warned	     : 1;
 	u8 embedded_insn     : 1;
 	u8 local_label       : 1;
+	u8 frame_pointer     : 1;
 	struct list_head pv_target;
 	struct reloc *relocs;
 };


