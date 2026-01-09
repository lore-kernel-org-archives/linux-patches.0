Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53BE2FD699;
	Fri,  9 Jan 2026 12:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961034; cv=none; b=f4QvHFkby2sTyMZS6fSaLRtGTVs40sDW3olo7GxpnTwMcJF+pU20DCzl9U+7vAOq8crBtfw2WvG9JRxdujMrulNQHlUInherq8jp+DE7k1t98uJGjv7fXAGeVeom9kXNF1gYOFdgc8mljfbmNJMpHC5Fd4wdDm+nW6q1JD5VpEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961034; c=relaxed/simple;
	bh=Dn1NAVNyvdpuR2FPyY25aR4OoY911fMzAQK1E1e9UDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QnDHohHwL8tiybG7m4OVUGKKDTjJHXMo64PvN3ZBiXpJLJS3wJI6R6tdTaWHSC4JmImKx3B2EwQb7fQL4dWU/YEZq1Rc5cRZecvQj7opEAacmkebm8ewdpDhmW+Z3oTc0jI2d8/o12RiVd7TNT3+vp13KAMbTOB2rMwviSTpfr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Tln5Yd1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Tln5Yd1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A4DC4CEF1;
	Fri,  9 Jan 2026 12:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961033;
	bh=Dn1NAVNyvdpuR2FPyY25aR4OoY911fMzAQK1E1e9UDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Tln5Yd1lBHFNISFQKvat9liVwdR/Qy6I1aJz0Wsy+u38JUUe7cW3t8d0fCBz3lxv
	 rpaddvzEVAEgLCU7o2gdArKPPaK8DACPD3KgKVaas19bv7xhZoSfzmt0HgadEgpXdN
	 DU9hekD2TLbclcyQcGHzmky0L3W0MlbsCLPqAHIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hengqi Chen <hengqi.chen@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 612/737] LoongArch: BPF: Sign extend kfunc call arguments
Date: Fri,  9 Jan 2026 12:42:31 +0100
Message-ID: <20260109112157.027516614@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Hengqi Chen <hengqi.chen@gmail.com>

commit 3f5a238f24d7b75f9efe324d3539ad388f58536e upstream.

The kfunc calls are native calls so they should follow LoongArch calling
conventions. Sign extend its arguments properly to avoid kernel panic.
This is done by adding a new emit_abi_ext() helper. The emit_abi_ext()
helper performs extension in place meaning a value already store in the
target register (Note: this is different from the existing sign_extend()
helper and thus we can't reuse it).

Cc: stable@vger.kernel.org
Fixes: 5dc615520c4d ("LoongArch: Add BPF JIT support")
Signed-off-by: Hengqi Chen <hengqi.chen@gmail.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/net/bpf_jit.c |   16 ++++++++++++++++
 arch/loongarch/net/bpf_jit.h |   26 ++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -834,6 +834,22 @@ static int build_insn(const struct bpf_i
 		if (ret < 0)
 			return ret;
 
+		if (insn->src_reg == BPF_PSEUDO_KFUNC_CALL) {
+			const struct btf_func_model *m;
+			int i;
+
+			m = bpf_jit_find_kfunc_model(ctx->prog, insn);
+			if (!m)
+				return -EINVAL;
+
+			for (i = 0; i < m->nr_args; i++) {
+				u8 reg = regmap[BPF_REG_1 + i];
+				bool sign = m->arg_flags[i] & BTF_FMODEL_SIGNED_ARG;
+
+				emit_abi_ext(ctx, reg, m->arg_size[i], sign);
+			}
+		}
+
 		move_addr(ctx, t1, func_addr);
 		emit_insn(ctx, jirl, LOONGARCH_GPR_RA, t1, 0);
 
--- a/arch/loongarch/net/bpf_jit.h
+++ b/arch/loongarch/net/bpf_jit.h
@@ -87,6 +87,32 @@ static inline void emit_sext_32(struct j
 	emit_insn(ctx, addiw, reg, reg, 0);
 }
 
+/* Emit proper extension according to ABI requirements.
+ * Note that it requires a value of size `size` already resides in register `reg`.
+ */
+static inline void emit_abi_ext(struct jit_ctx *ctx, int reg, u8 size, bool sign)
+{
+	/* ABI requires unsigned char/short to be zero-extended */
+	if (!sign && (size == 1 || size == 2))
+		return;
+
+	switch (size) {
+	case 1:
+		emit_insn(ctx, extwb, reg, reg);
+		break;
+	case 2:
+		emit_insn(ctx, extwh, reg, reg);
+		break;
+	case 4:
+		emit_insn(ctx, addiw, reg, reg, 0);
+		break;
+	case 8:
+		break;
+	default:
+		pr_warn("bpf_jit: invalid size %d for extension\n", size);
+	}
+}
+
 static inline void move_addr(struct jit_ctx *ctx, enum loongarch_gpr rd, u64 addr)
 {
 	u64 imm_11_0, imm_31_12, imm_51_32, imm_63_52;


