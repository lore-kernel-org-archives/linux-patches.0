Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFC43546E1;
	Sat, 12 Sep 2026 08:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203435; cv=none; b=S6CPHMHqIX6XuwZDpTaZgZrzRi4PQ+/binuGyiYsUhcH0IBRilQFuqdHLXzkz6leX3ffSJaJxfAQlJ1kvWC1qjMxLK93WjeckOT9FOnFT/QCeVrx+CYx0/cAGhGnSIcZlg2W2tw//PJ5ECkr+wQ7k1tQuRUS0lWysU0Ex2Av0U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203435; c=relaxed/simple;
	bh=JLoLNBJpLJ0IIk3SK6A5WIznGgJIdOXilUGemL64mxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNRWfkTDAGO4r9CQcgXSWPx/fv4MQAjJ9Z1msdOHmTydbRy9fplUOp9NsE6vsGFwfqW/QapQ79wySTiL1NsJYJS/AkluAq7JzIlPVbxMdoIG5YkWmfa0zlsAI2fJpl+NyqMiW/DNvZi+OcSzAbBhYIqF0LRaFyhUWMeVfPrtjhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V6oLSe+D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V6oLSe+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50AFE1F000FF;
	Sat, 12 Sep 2026 08:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203432;
	bh=Gr5zLD1kEBExa8ZLZLpxmHd1hsq05T3kbnlLIr23xnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V6oLSe+D0A+scvNIMC+DgTGcDLZV6MJYANIpoAQaXzD2efPAK5vUQm7EOaCqLXOOe
	 M+Vu8SMfLpkHifiv4738MBW02ohN157oQle372wi1hY+YLqvncmlyYeOmwNL/zoAON
	 OZ0JzV+P2vMaUZLRaI5Mx8MYsxvjTBPUA/eFek/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Puranjay Mohan <puranjay@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1406/1815] bpf, arm64: Clear fetch destination on faulting arena atomic
Date: Sat, 12 Sep 2026 08:52:36 +0200
Message-ID: <20260912065722.030545590@linuxfoundation.org>
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

[ Upstream commit ea3f20cb5918fea8e3786899b78fc7bb867c6a5e ]

Same problem as on x86-64: add_exception_handler() folds "there is no
destination register to clear" and "this is a store" into one DONT_CLEAR
value ...

  if (BPF_CLASS(insn->code) != BPF_LDX && !bpf_atomic_is_load_acq(insn))
          dst_reg = DONT_CLEAR;

... which ex_handler_bpf() then reads back as the access direction:

  bool is_write = (dst_reg == DONT_CLEAR);

A RMW carrying BPF_FETCH is both. emit_lse_atomic() reads the old value
into src_reg for BPF_{ADD,AND,OR,XOR} | BPF_FETCH and BPF_XCHG, and into
r0 for BPF_CMPXCHG, so a fault over an unmapped arena page is correctly
reported as a WRITE but leaves that register holding a stale value instead
of the 0 that every other BPF_PROBE_* access delivers. Same as on x86-64,
add a separate ARENA_WRITE bit for the direction.

FIXUP_REG is now filled in by the callers of add_exception_handler(), the
BPF_PROBE_ATOMIC one deriving it from bpf_atomic_load_reg(), so that the
helper only has to determine the direction. This is how the riscv64 JIT
already does it, and it stops the two store callers from handing in a
dst_reg that was only going to be overwritten with DONT_CLEAR anyway.

Fixes: e612b5c1d3ee ("bpf, arm64: Add support for lse atomics in bpf_arena")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Puranjay Mohan <puranjay@kernel.org>
Link: https://patch.msgid.link/20260811131600.506721-4-daniel@iogearbox.net
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/net/bpf_jit_comp.c | 44 ++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 8bc604dd9aab8..6d9d2ecc4fe46 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -1082,23 +1082,27 @@ static void build_epilogue(struct jit_ctx *ctx, bool was_classic)
  *
  * Bit layout of `fixup` (32-bit):
  *
- * +-----------+--------+-----------+-----------+----------+
- * |   31-27   | 26-22  |     21    |   20-16   |   15-0   |
- * |           |        |           |           |          |
- * | FIXUP_REG | Unused | ARENA_ACC | ARENA_REG |  OFFSET  |
- * +-----------+--------+-----------+-----------+----------+
+ * +-----------+--------+-------------+-----------+-----------+----------+
+ * |   31-27   | 26-23  |      22     |     21    |   20-16   |   15-0   |
+ * |           |        |             |           |           |          |
+ * | FIXUP_REG | Unused | ARENA_WRITE | ARENA_ACC | ARENA_REG |  OFFSET  |
+ * +-----------+--------+-------------+-----------+-----------+----------+
  *
  * - OFFSET (16 bits): Offset used to compute address for Load/Store instruction.
  * - ARENA_REG (5 bits): Register that is used to calculate the address for load/store when
  *                       accessing the arena region.
  * - ARENA_ACCESS (1 bit): This bit is set when the faulting instruction accessed the arena region.
+ * - ARENA_WRITE (1 bit): This bit is set when the faulting instruction wrote to the arena region.
+ *                        It is independent of FIXUP_REG, since a read-modify-write both writes to
+ *                        memory and reads the old value into a register.
  * - FIXUP_REG (5 bits): Destination register for the load instruction (cleared on fault) or set to
- *                       DONT_CLEAR if it is a store instruction.
+ *                       DONT_CLEAR if the instruction does not read into a register.
  */
 
 #define BPF_FIXUP_OFFSET_MASK      GENMASK(15, 0)
 #define BPF_FIXUP_ARENA_REG_MASK   GENMASK(20, 16)
 #define BPF_ARENA_ACCESS           BIT(21)
+#define BPF_ARENA_WRITE            BIT(22)
 #define BPF_FIXUP_REG_MASK	GENMASK(31, 27)
 #define DONT_CLEAR 5 /* Unused ARM64 register from BPF's POV */
 
@@ -1109,7 +1113,7 @@ bool ex_handler_bpf(const struct exception_table_entry *ex,
 	s16 off = FIELD_GET(BPF_FIXUP_OFFSET_MASK, ex->fixup);
 	int arena_reg = FIELD_GET(BPF_FIXUP_ARENA_REG_MASK, ex->fixup);
 	bool is_arena = !!(ex->fixup & BPF_ARENA_ACCESS);
-	bool is_write = (dst_reg == DONT_CLEAR);
+	bool is_write = !!(ex->fixup & BPF_ARENA_WRITE);
 	unsigned long addr;
 
 	if (is_arena) {
@@ -1132,7 +1136,7 @@ static int add_exception_handler(const struct bpf_insn *insn,
 {
 	off_t ins_offset;
 	s16 off = insn->off;
-	bool is_arena;
+	bool is_arena, is_write;
 	int arena_reg;
 	unsigned long pc;
 	struct exception_table_entry *ex;
@@ -1181,15 +1185,18 @@ static int add_exception_handler(const struct bpf_insn *insn,
 	/*
 	 * A load-acquire is of BPF_STX class, but reads from src_reg into
 	 * dst_reg like a BPF_LDX does, hence it must not be treated as a store
-	 * here.
+	 * here. A read-modify-write carrying BPF_FETCH is reported as a write
+	 * even though it does have a register to clear, see the callers.
 	 */
-	if (BPF_CLASS(insn->code) != BPF_LDX && !bpf_atomic_is_load_acq(insn))
-		dst_reg = DONT_CLEAR;
+	is_write = BPF_CLASS(insn->code) != BPF_LDX &&
+		   !bpf_atomic_is_load_acq(insn);
 
 	ex->fixup = FIELD_PREP(BPF_FIXUP_REG_MASK, dst_reg);
 
 	if (is_arena) {
 		ex->fixup |= BPF_ARENA_ACCESS;
+		if (is_write)
+			ex->fixup |= BPF_ARENA_WRITE;
 		/*
 		 * insn->src_reg/dst_reg holds the address in the arena region with upper 32-bits
 		 * being zero because of a preceding addr_space_cast(r<n>, 0x0, 0x1) instruction.
@@ -1876,7 +1883,7 @@ static int build_insn(const struct bpf_verifier_env *env, const struct bpf_insn
 			break;
 		}
 
-		ret = add_exception_handler(insn, ctx, dst);
+		ret = add_exception_handler(insn, ctx, DONT_CLEAR);
 		if (ret)
 			return ret;
 		break;
@@ -1943,7 +1950,7 @@ static int build_insn(const struct bpf_verifier_env *env, const struct bpf_insn
 			break;
 		}
 
-		ret = add_exception_handler(insn, ctx, dst);
+		ret = add_exception_handler(insn, ctx, DONT_CLEAR);
 		if (ret)
 			return ret;
 		break;
@@ -1966,7 +1973,16 @@ static int build_insn(const struct bpf_verifier_env *env, const struct bpf_insn
 			return ret;
 
 		if (BPF_MODE(insn->code) == BPF_PROBE_ATOMIC) {
-			ret = add_exception_handler(insn, ctx, dst);
+			/*
+			 * A load-acquire reads into dst_reg, and a read-modify-write
+			 * carrying BPF_FETCH reads the old value into src_reg, or into
+			 * r0 for a BPF_CMPXCHG. Clear that register on fault, the
+			 * remaining atomics have no destination register.
+			 */
+			int load_reg = bpf_atomic_load_reg(insn);
+
+			ret = add_exception_handler(insn, ctx, load_reg < 0 ?
+						    DONT_CLEAR : bpf2a64[load_reg]);
 			if (ret)
 				return ret;
 		}
-- 
2.53.0



