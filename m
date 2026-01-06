Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4AA36D51D;
	Tue,  6 Jan 2026 17:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722378; cv=none; b=touqLbWHOgURxWsQAAF6XmKYxJR8YsOdCq9ed4de8gj5SMDfEok/5s+lhyLYxmD4uPq38QFPjDtsVz8EqG16ess4uGu5lp4mujChi+wxkMiKvK2kNpHmlCYYB/88dcJYAXtT1TT1frTZmysV7DFqqRUnDgyNFWqwebGVTub6p04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722378; c=relaxed/simple;
	bh=uPXaqtXP10YTk/JppKOADjSTnxGJ20voo/e+1pSFArM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFeYB0yL9aan8hiRN7Z3AhTMWMvhe+mq+uBgkHja1paTLoW9Z1JV7rHLJdzX09+xq4FYqYTHQdo6dGWpj4g3rVLTFSDCAv0upnMhFaVtAzQlWvrUOhd2OZtcK0G5IUxDD46VqwlkwfFS4IHp+cbt4si7SmdinGGKhKoN4qb7VJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yzVyKMLO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yzVyKMLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4C1C116C6;
	Tue,  6 Jan 2026 17:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722377;
	bh=uPXaqtXP10YTk/JppKOADjSTnxGJ20voo/e+1pSFArM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yzVyKMLORErCy/g/G3pc37OC4yGN9XINUBojqO7Ten0YwAwkHg+KRkN92qPQj0GLC
	 a18AxyGx6EcnWXdGyzS2pJItAq00NGLPhK1lnfYKfpq34VgtLm80d/Dp2tioq+p2Eq
	 XnGUALl2QmN45TnJY3PATdKNVcR5sawrgpyT7O9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hengqi Chen <hengqi.chen@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 247/312] LoongArch: BPF: Sign extend kfunc call arguments
Date: Tue,  6 Jan 2026 18:05:21 +0100
Message-ID: <20260106170556.785233169@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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
@@ -952,6 +952,22 @@ static int build_insn(const struct bpf_i
 			emit_insn(ctx, ldd, REG_TCC, LOONGARCH_GPR_SP, tcc_ptr_off);
 		}
 
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
@@ -88,6 +88,32 @@ static inline void emit_sext_32(struct j
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


