Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2EB83546E1;
	Sat, 12 Sep 2026 08:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203428; cv=none; b=idaO/HsKOJAVYITv0YCnITxK830ZfKMf4CurKAjrL7fHxyHQ5qSsDH5XCA/dslnLlCjGlyfWTtaR17AfxmFplmKVQFW5Z1FurhQfHeCu2RvjpTOAHcGiTvi2kuDFjZ85Iftu3q4voF2wFS1gRTrEV+zRy+XnFQBDAlTEyici6uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203428; c=relaxed/simple;
	bh=tx2X6JFBtRHAcRT8dPIA1svL34at7Pce+uZZ8otRlnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7nVBomPYlx9mm0ySp1OaaXRofwa7p9OU3BEM5Vo4fvx6bNtMsRRZjE+W7KyXZYkONm8Y0CSrqXLHqSOgaqmVnkft0hAWrzrGWklppmdDzut98dFHCj1xsXLZRKmbg6giUGUVQtnhTw7h9VESzMwVcQkB4xQyGFCYzFaKUwFPfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLEWZ0Fd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLEWZ0Fd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04451F000FF;
	Sat, 12 Sep 2026 08:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203427;
	bh=atfjO1mqGb1vvGObPAWqIpP6E3mRYTGQ8qI9k7dXN+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kLEWZ0Fdv/CN7xlVxudM1eWga8yziBh3gAS1wMDEhp62NQNW0s6bIxJUeG7VXF+v6
	 ispxt7+Yf1DySBVDdPLrrZOGglbOp/t83flZqZ2fzEGk0/w5eaxhNmh2BHD7eNJ8ur
	 1nPpInlYKylP+uukV5jBeuFcTGZEigFps/U/Ueao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Puranjay Mohan <puranjay@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1405/1815] bpf, x86: Clear fetch destination on faulting arena atomic
Date: Sat, 12 Sep 2026 08:52:35 +0200
Message-ID: <20260912065722.007445187@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit cf92a108601a3f2465b550e44a98c8a78cabf8d1 ]

populate_extable() encodes "there is no destination register to clear" as
DONT_CLEAR in the DST_REG field of the exception table metadata, and later
ex_handler_bpf() then reuses that very value to derive the direction it
reports the fault with is_write = (reg == DONT_CLEAR). The two coincide
for a plain load or store, but not for a RMW carrying BPF_FETCH. Such an
atomic writes memory, so it has to be reported as a WRITE, and it also reads
the old value into a register, src_reg for BPF_ADD | BPF_FETCH and BPF_XCHG,
r0 for BPF_CMPXCHG, so that register has to be cleared on fault. A single
DONT_CLEAR cannot say both, and the store branch picks it unconditionally:

  [...]
  } else {
          arena_reg = reg2pt_regs[dst_reg];
          fixup_reg = DONT_CLEAR;
  }
  [...]

The reported direction is therefore right, but on a fault over an unmapped
arena page the fetch destination keeps whatever it held before the atomic,
where every other BPF_PROBE_* access delivers 0. Give the metadata its own
ARENA_WRITE bit so that the reported direction no longer depends on whether
there is a register to clear, and fill DST_REG in from bpf_atomic_load_reg().
BPF_{AND,OR,XOR} | BPF_FETCH need no handling here, bpf_jit_supports_insn()
already rejects those in the arena.

Fixes: d503a04f8bc0 ("bpf: Add support for certain atomics in bpf_arena to x86 JIT")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Puranjay Mohan <puranjay@kernel.org>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://patch.msgid.link/20260811131600.506721-3-daniel@iogearbox.net
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index f1e042fb3556e..ea74ff1d166cd 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1473,17 +1473,20 @@ static int emit_atomic_ld_st_index(u8 **pprog, u32 atomic_op, u32 size,
  *
  * Bit layout of `fixup` (32-bit):
  *
- * +-----------+--------+-----------+---------+----------+
- * | 31        | 30-24  |   23-16   |   15-8  |    7-0   |
- * |           |        |           |         |          |
- * | ARENA_ACC | Unused | ARENA_REG | DST_REG | INSN_LEN |
- * +-----------+--------+-----------+---------+----------+
+ * +-----------+-------------+--------+-----------+---------+----------+
+ * | 31        | 30          | 29-24  |   23-16   |   15-8  |    7-0   |
+ * |           |             |        |           |         |          |
+ * | ARENA_ACC | ARENA_WRITE | Unused | ARENA_REG | DST_REG | INSN_LEN |
+ * +-----------+-------------+--------+-----------+---------+----------+
  *
  * - INSN_LEN (8 bits): Length of faulting insn (max x86 insn = 15 bytes (fits in 8 bits)).
  * - DST_REG  (8 bits): Offset of dst_reg from reg2pt_regs[] (max offset = 112 (fits in 8 bits)).
- *                      This is set to DONT_CLEAR if the insn is a store.
+ *                      This is set to DONT_CLEAR if the insn does not read into a register.
  * - ARENA_REG (8 bits): Offset of the register that is used to calculate the
  *                       address for load/store when accessing the arena region.
+ * - ARENA_WRITE (1 bit): This bit is set when the faulting instruction wrote to the arena region.
+ *                        It is independent of DST_REG, since a read-modify-write both writes to
+ *                        memory and reads the old value into a register.
  * - ARENA_ACCESS (1 bit): This bit is set when the faulting instruction accessed the arena region.
  *
  * Bit layout of `data` (32-bit):
@@ -1502,6 +1505,7 @@ static int emit_atomic_ld_st_index(u8 **pprog, u32 atomic_op, u32 size,
 #define FIXUP_INSN_LEN_MASK	GENMASK(7, 0)
 #define FIXUP_REG_MASK		GENMASK(15, 8)
 #define FIXUP_ARENA_REG_MASK	GENMASK(23, 16)
+#define FIXUP_ARENA_WRITE	BIT(30)
 #define FIXUP_ARENA_ACCESS	BIT(31)
 #define DATA_ARENA_OFFSET_MASK	GENMASK(31, 16)
 
@@ -1510,7 +1514,7 @@ bool ex_handler_bpf(const struct exception_table_entry *x, struct pt_regs *regs)
 	u32 reg = FIELD_GET(FIXUP_REG_MASK, x->fixup);
 	u32 insn_len = FIELD_GET(FIXUP_INSN_LEN_MASK, x->fixup);
 	bool is_arena = !!(x->fixup & FIXUP_ARENA_ACCESS);
-	bool is_write = (reg == DONT_CLEAR);
+	bool is_write = !!(x->fixup & FIXUP_ARENA_WRITE);
 	unsigned long addr;
 	s16 off;
 	u32 arena_reg;
@@ -2304,6 +2308,7 @@ st:			insn_off = insn->off;
 				struct exception_table_entry *ex;
 				u8 *_insn = image + proglen + (start_of_ldx - temp);
 				u32 arena_reg, fixup_reg;
+				bool is_write;
 				s64 delta;
 
 				if (!bpf_prog->aux->extable)
@@ -2340,15 +2345,29 @@ st:			insn_off = insn->off;
 				    bpf_atomic_is_load_acq(insn)) {
 					arena_reg = reg2pt_regs[src_reg];
 					fixup_reg = reg2pt_regs[dst_reg];
+					is_write = false;
 				} else {
+					/*
+					 * A store has no destination register to clear,
+					 * except for a read-modify-write with BPF_FETCH,
+					 * which also reads the old value into src_reg, or
+					 * into r0 for a BPF_CMPXCHG. Either way the access
+					 * is still reported as a write.
+					 */
+					int load_reg = bpf_atomic_load_reg(insn);
+
 					arena_reg = reg2pt_regs[dst_reg];
-					fixup_reg = DONT_CLEAR;
+					fixup_reg = load_reg < 0 ? DONT_CLEAR :
+						    reg2pt_regs[load_reg];
+					is_write = true;
 				}
 
 				ex->fixup = FIELD_PREP(FIXUP_INSN_LEN_MASK, prog - start_of_ldx) |
 					    FIELD_PREP(FIXUP_ARENA_REG_MASK, arena_reg) |
 					    FIELD_PREP(FIXUP_REG_MASK, fixup_reg);
 				ex->fixup |= FIXUP_ARENA_ACCESS;
+				if (is_write)
+					ex->fixup |= FIXUP_ARENA_WRITE;
 
 				ex->data |= FIELD_PREP(DATA_ARENA_OFFSET_MASK, insn->off);
 			}
-- 
2.53.0



