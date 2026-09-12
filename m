Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328FA46C852;
	Sat, 12 Sep 2026 10:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210189; cv=none; b=ZXltY+4RvoDYmfstsMsHru6dNJ5eUeTq2Rg7UtBvczdnw4R0pvIklckVzXYyMphPMZKNb48I+LIicuMaLv5A+bQ7q45oseBLQ1x7lK9koFRuETlnZQF4/T7WmBvgUoqtyFbTzxUvn87KrSwvevDWsef9aXfh2+2SJ1JVwVPSmfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210189; c=relaxed/simple;
	bh=w4cMSbRGx4eGwmJZt9uf4KNnCux1bMrNnWjkl7QLIwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQtUsgCvXy1yGXpwp0Y1ZHkyPDqQ5d89ODYJSPgjf4f7fmvTfCs+LYvS+JFp/7Es6rXVHS+pGqMuDd1oxW7ZFK4Gx3Ff3yvpCk7ucZR//c+emhm+esoS8T6HaVK8+/OjNq16i8ZJHG4TQesXtn6QkR2RwWFEyvRHcRn78RX+5NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/E/guYX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/E/guYX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB151F00893;
	Sat, 12 Sep 2026 10:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210183;
	bh=rPrXixqcL5ir5P7infNm8CCBAN8eEQOC/3Jz8xHhca0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m/E/guYXWVyx2oXCJ8eKBxJAVin1ac3O1QjT0V2wsB4g1az8yk1EMz3RYfrNr+vHG
	 5VI+nQcfCLb9U8310/gFB38Cuts4VTgAerxjhVQXeY5z5+XhwEqoHcFuwFJZbrkqOr
	 F8+xNOygpTkcWbSUVgIGOue5t5/RpI2mu2a+EqCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0975/1518] bpf, riscv: Add and use bpf_atomic_is_load_acq() helper
Date: Sat, 12 Sep 2026 08:52:24 +0200
Message-ID: <20260912065645.514083116@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit e2577cd62060be91a3d7d11a56e5a61faae4b7f7 ]

A load-acquire is the only BPF_STX class instruction that reads from
src_reg into dst_reg, that is, it has the operand roles of a BPF_LDX.
JIT code which tells loads from stores apart by instruction class alone
has to special case it, for example when deciding which register holds
the faulting address and which one to clear from an exception handler.

riscv64 already does so, open coded as a bare insn->imm test. Add a
bpf_atomic_is_load_acq() helper and convert riscv64 over to it, so that
the x86-64 and arm64 JITs can use the same helper in subsequent patches.

Unlike bpf_atomic_is_load_store(), which presumes that its argument is
already known to be a BPF_ATOMIC instruction, the new helper is called
from code which still sees all instruction classes, so it checks class
and mode itself.

Also, move bpf_atomic_is_load_store() to filter.h next to BPF_ATOMIC_OP,
so that both helpers stay together. No functional change intended.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20260806201047.333389-2-daniel@iogearbox.net
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Stable-dep-of: 4cf8def58b77 ("bpf, x86: Fix exception table metadata for arena load-acquire")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/net/bpf_jit_comp64.c |  2 +-
 include/linux/bpf.h             | 15 ---------------
 include/linux/filter.h          | 31 +++++++++++++++++++++++++++++++
 3 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
index 93beb95d0a886..a90066cc9d58b 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -1928,7 +1928,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 		/* ret can be 1 (skip-zext); extable entry still needs to be added */
 		if (ret >= 0)
 			ret = add_exception_handler(insn,
-				insn->imm == BPF_LOAD_ACQ ? rd : REG_DONT_CLEAR_MARKER,
+				bpf_atomic_is_load_acq(insn) ? rd : REG_DONT_CLEAR_MARKER,
 				ctx) ?: ret;
 
 		if (ret)
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 84a8afc6e6df3..7052507ed4517 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1044,21 +1044,6 @@ static inline bool bpf_pseudo_func(const struct bpf_insn *insn)
 	return bpf_is_ldimm64(insn) && insn->src_reg == BPF_PSEUDO_FUNC;
 }
 
-/* Given a BPF_ATOMIC instruction @atomic_insn, return true if it is an
- * atomic load or store, and false if it is a read-modify-write instruction.
- */
-static inline bool
-bpf_atomic_is_load_store(const struct bpf_insn *atomic_insn)
-{
-	switch (atomic_insn->imm) {
-	case BPF_LOAD_ACQ:
-	case BPF_STORE_REL:
-		return true;
-	default:
-		return false;
-	}
-}
-
 struct bpf_prog_ops {
 	int (*test_run)(struct bpf_prog *prog, const union bpf_attr *kattr,
 			union bpf_attr __user *uattr);
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 2469fd2e40157..260a190634055 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -383,6 +383,37 @@ static inline bool insn_is_cast_user(const struct bpf_insn *insn)
 /* Legacy alias */
 #define BPF_STX_XADD(SIZE, DST, SRC, OFF) BPF_ATOMIC_OP(SIZE, BPF_ADD, DST, SRC, OFF)
 
+/*
+ * Given a BPF_ATOMIC instruction @atomic_insn, return true if it is an
+ * atomic load or store, and false if it is a read-modify-write instruction.
+ */
+static inline bool
+bpf_atomic_is_load_store(const struct bpf_insn *atomic_insn)
+{
+	switch (atomic_insn->imm) {
+	case BPF_LOAD_ACQ:
+	case BPF_STORE_REL:
+		return true;
+	default:
+		return false;
+	}
+}
+
+/*
+ * A load-acquire is the only BPF_STX class instruction that reads into
+ * dst_reg from src_reg + off16, i.e. it has the operand roles of a BPF_LDX.
+ * Unlike bpf_atomic_is_load_store(), @insn is not assumed to be a BPF_ATOMIC
+ * instruction here, so that callers which walk all instruction classes can
+ * use this directly.
+ */
+static inline bool bpf_atomic_is_load_acq(const struct bpf_insn *insn)
+{
+	return BPF_CLASS(insn->code) == BPF_STX &&
+	       (BPF_MODE(insn->code) == BPF_ATOMIC ||
+		BPF_MODE(insn->code) == BPF_PROBE_ATOMIC) &&
+	       insn->imm == BPF_LOAD_ACQ;
+}
+
 /* Memory store, *(uint *) (dst_reg + off16) = imm32 */
 
 #define BPF_ST_MEM(SIZE, DST, OFF, IMM)				\
-- 
2.53.0



