Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CFD224B04;
	Tue,  6 Jan 2026 17:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721155; cv=none; b=oXLsC640T7kSOgv7I+tVi21LMjwNi48O5+F90cPWbDpmtyyLE/RFMFsplJJEfkqvpOOTfJ8nqO3b7YoMAWJ78W56thci8v97gClGzyYcbpqJkhN1c8BSwhWyzVkA0JdCvhIAexJVY+vefIpgZ8wq6WEEXSUt3EQppi4VGyDR4do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721155; c=relaxed/simple;
	bh=MdThh7U06pnHXBCUjCxNwCgJvAXeu51aBEDA/D2FX/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HcxpqrvzAXK0N2lUGDO1oje/+DF+eQ2XLQplz7jdScw68yBZ2sMxvQsf8WxZGpr7BCDjtxnDNHjOV6tQ652x8Fe606uS/ZnI9RYstFA+oQ3T69HsIyBl7V7qxKwg3N0nQghcEFkdCRxwq9OH4mHgeFHaM0xpAC6XBg+02aT4Yl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kRMwobui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kRMwobui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84C1C116C6;
	Tue,  6 Jan 2026 17:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721155;
	bh=MdThh7U06pnHXBCUjCxNwCgJvAXeu51aBEDA/D2FX/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kRMwobuiF0ZcpYNCXKTbq+f5pPAm3qApmqJptaXRzTCY5etIg5jf5h8b8I6ivevL5
	 b+j0Je/Rv1XGSTZRRpMGA9lu42Y9uAkKNzb14s4/3dGJKP5llVEWEwGnOOnBQv9wg+
	 jheW5vyCX5H3m6+T89Uv06B4LaaFMVcR652dmUZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hengqi Chen <hengqi.chen@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 451/567] LoongArch: BPF: Sign extend kfunc call arguments
Date: Tue,  6 Jan 2026 18:03:53 +0100
Message-ID: <20260106170508.031358902@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -897,6 +897,22 @@ static int build_insn(const struct bpf_i
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


