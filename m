Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97983E0083;
	Fri, 15 May 2026 16:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861055; cv=none; b=pEgkE1qM6VS2Tk2kTAm412JZDHmbMBaOWrq4M7rYHGnvn9h82EEaZZeZFT4lAHww7gHNZMwHut6ZaOETTndbt/MgUx8LDOBrhkc6D6q6lX12P/i2g96R+bhIah/jcP23LALUFjkZXHbePdiLSXEGFr6r5zizqBoNeXVoDWevms4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861055; c=relaxed/simple;
	bh=YZP6Nk0Xgj2h8V32gButauDhMa2KLCUxE4gp5F8bEJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MpUmpK8iLnytPru8mANfn0o7sJM8LCxPmijl/pd3l6nkY/92l2aCEn5aWzfhPpS7T27e62B2EqxunoAX8RFzmNKt4eYDJlon0w/gZm6952rq/BVpXnuS7ca7UUHuhpSPMKLnADyfAyeIEF/bnNyDusj83OC7Ud8HzGF+6QxV0/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GFl++Eyi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GFl++Eyi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52917C2BCB3;
	Fri, 15 May 2026 16:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861054;
	bh=YZP6Nk0Xgj2h8V32gButauDhMa2KLCUxE4gp5F8bEJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GFl++Eyiyr1y9YqLburPjBZmNJDDZ66zZyq+pljlnwCrWKFycOzkm4mCpHhBbQ82Y
	 6SmRojLBgQWzZh8HG7hA2StO3vJ9vg08CdI8jYloB9Y0fPh4u5dCOEpAJTmWhid2D2
	 oGf92NwYojQN8P2pq4VrafR8PQQtFXE8Iqh8BJTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 181/474] selftests/bpf: validate fake register spill/fill precision backtracking logic
Date: Fri, 15 May 2026 17:44:50 +0200
Message-ID: <20260515154718.941111514@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 7d8ed51bcb32716a40d71043fcd01c4118858c51 ]

Add two tests validating that verifier's precision backtracking logic
handles BPF_ST_MEM instructions that produce fake register spill into
register slot. This is happening when non-zero constant is written
directly to a slot, e.g., *(u64 *)(r10 -8) = 123.

Add both full 64-bit register spill, as well as 32-bit "sub-spill".

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20231209010958.66758-2-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[ Note: Adapted the expected log format for the selftests because it
  changed later on in commits 67d43dfbb42d, 0c95c9fdb696, and
  1db747d75b1d. ]
Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Acked-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/progs/verifier_spill_fill.c | 154 ++++++++++++++++++
 1 file changed, 154 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/verifier_spill_fill.c b/tools/testing/selftests/bpf/progs/verifier_spill_fill.c
index df4920da34728..1f71f596d33f8 100644
--- a/tools/testing/selftests/bpf/progs/verifier_spill_fill.c
+++ b/tools/testing/selftests/bpf/progs/verifier_spill_fill.c
@@ -577,4 +577,158 @@ __naked void partial_stack_load_preserves_zeros(void)
 	: __clobber_common);
 }
 
+char two_byte_buf[2] SEC(".data.two_byte_buf");
+
+SEC("raw_tp")
+__log_level(2) __flag(BPF_F_TEST_STATE_FREQ)
+__success
+/* make sure fp-8 is IMPRECISE fake register spill */
+__msg("3: (7a) *(u64 *)(r10 -8) = 1          ; R10=fp0 fp-8_w=1")
+/* and fp-16 is spilled IMPRECISE const reg */
+__msg("5: (7b) *(u64 *)(r10 -16) = r0        ; R0_w=1 R10=fp0 fp-16_w=1")
+/* validate load from fp-8, which was initialized using BPF_ST_MEM */
+__msg("8: (79) r2 = *(u64 *)(r10 -8)         ; R2_w=1 R10=fp0 fp-8=1")
+__msg("9: (0f) r1 += r2")
+__msg("mark_precise: frame0: last_idx 9 first_idx 7 subseq_idx -1")
+__msg("mark_precise: frame0: regs=r2 stack= before 8: (79) r2 = *(u64 *)(r10 -8)")
+__msg("mark_precise: frame0: regs= stack=-8 before 7: (bf) r1 = r6")
+/* note, fp-8 is precise, fp-16 is not yet precise, we'll get there */
+__msg("mark_precise: frame0: parent state regs= stack=-8:  R0_w=1 R1=ctx(off=0,imm=0) R6_r=map_value(off=0,ks=4,vs=2,imm=0) R10=fp0 fp-8_rw=P1 fp-16_w=1")
+__msg("mark_precise: frame0: last_idx 6 first_idx 3 subseq_idx 7")
+__msg("mark_precise: frame0: regs= stack=-8 before 6: (05) goto pc+0")
+__msg("mark_precise: frame0: regs= stack=-8 before 5: (7b) *(u64 *)(r10 -16) = r0")
+__msg("mark_precise: frame0: regs= stack=-8 before 4: (b7) r0 = 1")
+__msg("mark_precise: frame0: regs= stack=-8 before 3: (7a) *(u64 *)(r10 -8) = 1")
+__msg("10: R1_w=map_value(off=1,ks=4,vs=2,imm=0) R2_w=1")
+/* validate load from fp-16, which was initialized using BPF_STX_MEM */
+__msg("12: (79) r2 = *(u64 *)(r10 -16)       ; R2_w=1 R10=fp0 fp-16=1")
+__msg("13: (0f) r1 += r2")
+__msg("mark_precise: frame0: last_idx 13 first_idx 7 subseq_idx -1")
+__msg("mark_precise: frame0: regs=r2 stack= before 12: (79) r2 = *(u64 *)(r10 -16)")
+__msg("mark_precise: frame0: regs= stack=-16 before 11: (bf) r1 = r6")
+__msg("mark_precise: frame0: regs= stack=-16 before 10: (73) *(u8 *)(r1 +0) = r2")
+__msg("mark_precise: frame0: regs= stack=-16 before 9: (0f) r1 += r2")
+__msg("mark_precise: frame0: regs= stack=-16 before 8: (79) r2 = *(u64 *)(r10 -8)")
+__msg("mark_precise: frame0: regs= stack=-16 before 7: (bf) r1 = r6")
+/* now both fp-8 and fp-16 are precise, very good */
+__msg("mark_precise: frame0: parent state regs= stack=-16:  R0_w=1 R1=ctx(off=0,imm=0) R6_r=map_value(off=0,ks=4,vs=2,imm=0) R10=fp0 fp-8_rw=P1 fp-16_rw=P1")
+__msg("mark_precise: frame0: last_idx 6 first_idx 3 subseq_idx 7")
+__msg("mark_precise: frame0: regs= stack=-16 before 6: (05) goto pc+0")
+__msg("mark_precise: frame0: regs= stack=-16 before 5: (7b) *(u64 *)(r10 -16) = r0")
+__msg("mark_precise: frame0: regs=r0 stack= before 4: (b7) r0 = 1")
+__msg("14: R1_w=map_value(off=1,ks=4,vs=2,imm=0) R2_w=1")
+__naked void stack_load_preserves_const_precision(void)
+{
+	asm volatile (
+		/* establish checkpoint with state that has no stack slots;
+		 * if we bubble up to this state without finding desired stack
+		 * slot, then it's a bug and should be caught
+		 */
+		"goto +0;"
+
+		/* fp-8 is const 1 *fake* register */
+		".8byte %[fp8_st_one];" /* LLVM-18+: *(u64 *)(r10 -8) = 1; */
+
+		/* fp-16 is const 1 register */
+		"r0 = 1;"
+		"*(u64 *)(r10 -16) = r0;"
+
+		/* force checkpoint to check precision marks preserved in parent states */
+		"goto +0;"
+
+		/* load single U64 from aligned FAKE_REG=1 slot */
+		"r1 = %[two_byte_buf];"
+		"r2 = *(u64 *)(r10 -8);"
+		"r1 += r2;"
+		"*(u8 *)(r1 + 0) = r2;" /* this should be fine */
+
+		/* load single U64 from aligned REG=1 slot */
+		"r1 = %[two_byte_buf];"
+		"r2 = *(u64 *)(r10 -16);"
+		"r1 += r2;"
+		"*(u8 *)(r1 + 0) = r2;" /* this should be fine */
+
+		"r0 = 0;"
+		"exit;"
+	:
+	: __imm_ptr(two_byte_buf),
+	  __imm_insn(fp8_st_one, BPF_ST_MEM(BPF_DW, BPF_REG_FP, -8, 1))
+	: __clobber_common);
+}
+
+SEC("raw_tp")
+__log_level(2) __flag(BPF_F_TEST_STATE_FREQ)
+__success
+/* make sure fp-8 is 32-bit FAKE subregister spill */
+__msg("3: (62) *(u32 *)(r10 -8) = 1          ; R10=fp0 fp-8=1")
+/* but fp-16 is spilled IMPRECISE zero const reg */
+__msg("5: (63) *(u32 *)(r10 -16) = r0        ; R0_w=1 R10=fp0 fp-16=1")
+/* validate load from fp-8, which was initialized using BPF_ST_MEM */
+__msg("8: (61) r2 = *(u32 *)(r10 -8)         ; R2_w=1 R10=fp0 fp-8=1")
+__msg("9: (0f) r1 += r2")
+__msg("mark_precise: frame0: last_idx 9 first_idx 7 subseq_idx -1")
+__msg("mark_precise: frame0: regs=r2 stack= before 8: (61) r2 = *(u32 *)(r10 -8)")
+__msg("mark_precise: frame0: regs= stack=-8 before 7: (bf) r1 = r6")
+__msg("mark_precise: frame0: parent state regs= stack=-8:  R0_w=1 R1=ctx(off=0,imm=0) R6_r=map_value(off=0,ks=4,vs=2,imm=0) R10=fp0 fp-8_r=P1 fp-16=1")
+__msg("mark_precise: frame0: last_idx 6 first_idx 3 subseq_idx 7")
+__msg("mark_precise: frame0: regs= stack=-8 before 6: (05) goto pc+0")
+__msg("mark_precise: frame0: regs= stack=-8 before 5: (63) *(u32 *)(r10 -16) = r0")
+__msg("mark_precise: frame0: regs= stack=-8 before 4: (b7) r0 = 1")
+__msg("mark_precise: frame0: regs= stack=-8 before 3: (62) *(u32 *)(r10 -8) = 1")
+__msg("10: R1_w=map_value(off=1,ks=4,vs=2,imm=0) R2_w=1")
+/* validate load from fp-16, which was initialized using BPF_STX_MEM */
+__msg("12: (61) r2 = *(u32 *)(r10 -16)       ; R2_w=1 R10=fp0 fp-16=1")
+__msg("13: (0f) r1 += r2")
+__msg("mark_precise: frame0: last_idx 13 first_idx 7 subseq_idx -1")
+__msg("mark_precise: frame0: regs=r2 stack= before 12: (61) r2 = *(u32 *)(r10 -16)")
+__msg("mark_precise: frame0: regs= stack=-16 before 11: (bf) r1 = r6")
+__msg("mark_precise: frame0: regs= stack=-16 before 10: (73) *(u8 *)(r1 +0) = r2")
+__msg("mark_precise: frame0: regs= stack=-16 before 9: (0f) r1 += r2")
+__msg("mark_precise: frame0: regs= stack=-16 before 8: (61) r2 = *(u32 *)(r10 -8)")
+__msg("mark_precise: frame0: regs= stack=-16 before 7: (bf) r1 = r6")
+__msg("mark_precise: frame0: parent state regs= stack=-16:  R0_w=1 R1=ctx(off=0,imm=0) R6_r=map_value(off=0,ks=4,vs=2,imm=0) R10=fp0 fp-8_r=P1 fp-16_r=P1")
+__msg("mark_precise: frame0: last_idx 6 first_idx 3 subseq_idx 7")
+__msg("mark_precise: frame0: regs= stack=-16 before 6: (05) goto pc+0")
+__msg("mark_precise: frame0: regs= stack=-16 before 5: (63) *(u32 *)(r10 -16) = r0")
+__msg("mark_precise: frame0: regs=r0 stack= before 4: (b7) r0 = 1")
+__msg("14: R1_w=map_value(off=1,ks=4,vs=2,imm=0) R2_w=1")
+__naked void stack_load_preserves_const_precision_subreg(void)
+{
+	asm volatile (
+		/* establish checkpoint with state that has no stack slots;
+		 * if we bubble up to this state without finding desired stack
+		 * slot, then it's a bug and should be caught
+		 */
+		"goto +0;"
+
+		/* fp-8 is const 1 *fake* SUB-register */
+		".8byte %[fp8_st_one];" /* LLVM-18+: *(u32 *)(r10 -8) = 1; */
+
+		/* fp-16 is const 1 SUB-register */
+		"r0 = 1;"
+		"*(u32 *)(r10 -16) = r0;"
+
+		/* force checkpoint to check precision marks preserved in parent states */
+		"goto +0;"
+
+		/* load single U32 from aligned FAKE_REG=1 slot */
+		"r1 = %[two_byte_buf];"
+		"r2 = *(u32 *)(r10 -8);"
+		"r1 += r2;"
+		"*(u8 *)(r1 + 0) = r2;" /* this should be fine */
+
+		/* load single U32 from aligned REG=1 slot */
+		"r1 = %[two_byte_buf];"
+		"r2 = *(u32 *)(r10 -16);"
+		"r1 += r2;"
+		"*(u8 *)(r1 + 0) = r2;" /* this should be fine */
+
+		"r0 = 0;"
+		"exit;"
+	:
+	: __imm_ptr(two_byte_buf),
+	  __imm_insn(fp8_st_one, BPF_ST_MEM(BPF_W, BPF_REG_FP, -8, 1)) /* 32-bit spill */
+	: __clobber_common);
+}
+
 char _license[] SEC("license") = "GPL";
-- 
2.53.0



