Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1107E168C4;
	Mon, 27 May 2024 19:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837651; cv=none; b=To0wtEQuah6bLdPu2E36FFFdwVyqboBusTqaC5/rFSu3jF0i90r3KuB8BUdUXm9eC5dMVlDMjDBCvIa9rUGCeFqCmJZl48udaD7cBFXfpOuHh0b8OFg+6wzNqFdB4wHHn9Cyj1psrIxDhBvQOO6fJW1zgwcKsgOYzS2kXftkd+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837651; c=relaxed/simple;
	bh=9fXBWPzTpPTzZhAzxEIroWgWQRRdG5Dtnwbl6X7VRSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EL/mxqMm4iTQ/p2rTS0uNpP3dz5Pnr+7Fd/U7/uY2UblripIHe4AYsQV9qLL41DsWVPMoVlwFOJzV8ZprMttFUQGX6FJ+xMa46o9mPUlQSbs2d8Lm5y95KHbMt95FMK14OPKaxkK+hf4SwCzVRxlpW9xJEe3+vxLTCWO+00TyW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=maOR7mu6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="maOR7mu6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976F3C2BBFC;
	Mon, 27 May 2024 19:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837650;
	bh=9fXBWPzTpPTzZhAzxEIroWgWQRRdG5Dtnwbl6X7VRSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=maOR7mu6yTzQjrpzL2eXNCnTK2EWqV6ohSfC0B4G0hmnBOkrghs6Rgqr/7AeUKqZX
	 m/m99+DOIvHwcOlwMIHPl4pLSd8U8FRY/CnRiKy59msFf97//e1qFERLGNp792PO46
	 K/9tHOspN1TiqANFBen3RAnSx+/1odXTbOh+o2Kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 084/493] bpf, x86: Fix PROBE_MEM runtime load check
Date: Mon, 27 May 2024 20:51:26 +0200
Message-ID: <20240527185632.999482974@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Puranjay Mohan <puranjay@kernel.org>

[ Upstream commit b599d7d26d6ad1fc9975218574bc2ca6d0293cfd ]

When a load is marked PROBE_MEM - e.g. due to PTR_UNTRUSTED access - the
address being loaded from is not necessarily valid. The BPF jit sets up
exception handlers for each such load which catch page faults and 0 out
the destination register.

If the address for the load is outside kernel address space, the load
will escape the exception handling and crash the kernel. To prevent this
from happening, the emits some instruction to verify that addr is > end
of userspace addresses.

x86 has a legacy vsyscall ABI where a page at address 0xffffffffff600000
is mapped with user accessible permissions. The addresses in this page
are considered userspace addresses by the fault handler. Therefore, a
BPF program accessing this page will crash the kernel.

This patch fixes the runtime checks to also check that the PROBE_MEM
address is below VSYSCALL_ADDR.

Example BPF program:

 SEC("fentry/tcp_v4_connect")
 int BPF_PROG(fentry_tcp_v4_connect, struct sock *sk)
 {
	*(volatile unsigned long *)&sk->sk_tsq_flags;
	return 0;
 }

BPF Assembly:

 0: (79) r1 = *(u64 *)(r1 +0)
 1: (79) r1 = *(u64 *)(r1 +344)
 2: (b7) r0 = 0
 3: (95) exit

			       x86-64 JIT
			       ==========

            BEFORE                                    AFTER
	    ------                                    -----

 0:   nopl   0x0(%rax,%rax,1)             0:   nopl   0x0(%rax,%rax,1)
 5:   xchg   %ax,%ax                      5:   xchg   %ax,%ax
 7:   push   %rbp                         7:   push   %rbp
 8:   mov    %rsp,%rbp                    8:   mov    %rsp,%rbp
 b:   mov    0x0(%rdi),%rdi               b:   mov    0x0(%rdi),%rdi
-------------------------------------------------------------------------------
 f:   movabs $0x100000000000000,%r11      f:   movabs $0xffffffffff600000,%r10
19:   add    $0x2a0,%rdi                 19:   mov    %rdi,%r11
20:   cmp    %r11,%rdi                   1c:   add    $0x2a0,%r11
23:   jae    0x0000000000000029          23:   sub    %r10,%r11
25:   xor    %edi,%edi                   26:   movabs $0x100000000a00000,%r10
27:   jmp    0x000000000000002d          30:   cmp    %r10,%r11
29:   mov    0x0(%rdi),%rdi              33:   ja     0x0000000000000039
--------------------------------\        35:   xor    %edi,%edi
2d:   xor    %eax,%eax           \       37:   jmp    0x0000000000000040
2f:   leave                       \      39:   mov    0x2a0(%rdi),%rdi
30:   ret                          \--------------------------------------------
                                         40:   xor    %eax,%eax
                                         42:   leave
                                         43:   ret

Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Link: https://lore.kernel.org/r/20240424100210.11982-3-puranjay@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 57 ++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 32 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index df484885ccd4a..f415c2cf53582 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1585,36 +1585,41 @@ st:			if (is_imm8(insn->off))
 			if (BPF_MODE(insn->code) == BPF_PROBE_MEM ||
 			    BPF_MODE(insn->code) == BPF_PROBE_MEMSX) {
 				/* Conservatively check that src_reg + insn->off is a kernel address:
-				 *   src_reg + insn->off >= TASK_SIZE_MAX + PAGE_SIZE
-				 * src_reg is used as scratch for src_reg += insn->off and restored
-				 * after emit_ldx if necessary
+				 *   src_reg + insn->off > TASK_SIZE_MAX + PAGE_SIZE
+				 *   and
+				 *   src_reg + insn->off < VSYSCALL_ADDR
 				 */
 
-				u64 limit = TASK_SIZE_MAX + PAGE_SIZE;
+				u64 limit = TASK_SIZE_MAX + PAGE_SIZE - VSYSCALL_ADDR;
 				u8 *end_of_jmp;
 
-				/* At end of these emitted checks, insn->off will have been added
-				 * to src_reg, so no need to do relative load with insn->off offset
-				 */
-				insn_off = 0;
+				/* movabsq r10, VSYSCALL_ADDR */
+				emit_mov_imm64(&prog, BPF_REG_AX, (long)VSYSCALL_ADDR >> 32,
+					       (u32)(long)VSYSCALL_ADDR);
 
-				/* movabsq r11, limit */
-				EMIT2(add_1mod(0x48, AUX_REG), add_1reg(0xB8, AUX_REG));
-				EMIT((u32)limit, 4);
-				EMIT(limit >> 32, 4);
+				/* mov src_reg, r11 */
+				EMIT_mov(AUX_REG, src_reg);
 
 				if (insn->off) {
-					/* add src_reg, insn->off */
-					maybe_emit_1mod(&prog, src_reg, true);
-					EMIT2_off32(0x81, add_1reg(0xC0, src_reg), insn->off);
+					/* add r11, insn->off */
+					maybe_emit_1mod(&prog, AUX_REG, true);
+					EMIT2_off32(0x81, add_1reg(0xC0, AUX_REG), insn->off);
 				}
 
-				/* cmp src_reg, r11 */
-				maybe_emit_mod(&prog, src_reg, AUX_REG, true);
-				EMIT2(0x39, add_2reg(0xC0, src_reg, AUX_REG));
+				/* sub r11, r10 */
+				maybe_emit_mod(&prog, AUX_REG, BPF_REG_AX, true);
+				EMIT2(0x29, add_2reg(0xC0, AUX_REG, BPF_REG_AX));
+
+				/* movabsq r10, limit */
+				emit_mov_imm64(&prog, BPF_REG_AX, (long)limit >> 32,
+					       (u32)(long)limit);
+
+				/* cmp r10, r11 */
+				maybe_emit_mod(&prog, AUX_REG, BPF_REG_AX, true);
+				EMIT2(0x39, add_2reg(0xC0, AUX_REG, BPF_REG_AX));
 
-				/* if unsigned '>=', goto load */
-				EMIT2(X86_JAE, 0);
+				/* if unsigned '>', goto load */
+				EMIT2(X86_JA, 0);
 				end_of_jmp = prog;
 
 				/* xor dst_reg, dst_reg */
@@ -1640,18 +1645,6 @@ st:			if (is_imm8(insn->off))
 				/* populate jmp_offset for JMP above */
 				start_of_ldx[-1] = prog - start_of_ldx;
 
-				if (insn->off && src_reg != dst_reg) {
-					/* sub src_reg, insn->off
-					 * Restore src_reg after "add src_reg, insn->off" in prev
-					 * if statement. But if src_reg == dst_reg, emit_ldx
-					 * above already clobbered src_reg, so no need to restore.
-					 * If add src_reg, insn->off was unnecessary, no need to
-					 * restore either.
-					 */
-					maybe_emit_1mod(&prog, src_reg, true);
-					EMIT2_off32(0x81, add_1reg(0xE8, src_reg), insn->off);
-				}
-
 				if (!bpf_prog->aux->extable)
 					break;
 
-- 
2.43.0



