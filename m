Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E0F390C8A;
	Sat, 17 Oct 2026 16:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254260; cv=none; b=coQwXVsXhfmApH59rxYA9ZgnNZ8dXOFQ2dM+kCUg9jLFQrnWMWgvM2m6aLSoscsWyrrX8NSyjsFODkq9LstESgSmEfvz+DUwxRfhOQXzKgdtHD9L/DCahqUb1L7VUWVbwZF9C1NQ3uUWgNW/YZLB29d1XnGVePo/Z78Wmyzrq+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254260; c=relaxed/simple;
	bh=nEdlLGq7zIXgNhm6Tg+F1AlZqFMOkLNYs7oaOSr7TQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E+UWp+M1f//0F0PcOKyVsVOW/j8GxdO5qjK5COW+o8KKXLE2iify0rkmnCsjON0DR071XU/nkEVX9N1dDiGUMdteDSmSuZANlGDpV1ugnZF0ajEfFCW4O2T7qHpUu9UDqQwjPKhlhh0Sl+xcGEwvmFo8/Nu/rP+Y+28u9O0FIA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pkilR1/u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pkilR1/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1BE1F000C7;
	Sat, 17 Oct 2026 16:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254258;
	bh=XJiF56X3gmWWq7V0RtzdasIyJvIZzjeOL6UjCc6ESK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pkilR1/uQDQ4AUNtbfbKhjG9vgJ+L0plonU8AbY5aigU7srCBWxvSi2XjhUZh6rY3
	 TfpG6bIvD/jKgVCrnLrOsE8V5rwJMQ3Wrnk0aoYhzP1Ku0A1gm0TAyV6mfTa1l/oOR
	 O1MsQdkom8CYv1KrTN9p/KPXOTGf/V21tp5V6ZXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Nicholas Dudar <main.kalliope@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 389/869] LoongArch: BPF: Zero-extend signed ALU32 div/mod results
Date: Sat, 17 Oct 2026 17:53:50 +0200
Message-ID: <20261017160047.090447787@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Nicholas Dudar <main.kalliope@gmail.com>

[ Upstream commit dacd348b8a993373576fe2ee2d8b114740ba57a6 ]

ALU32 operations write a 32-bit result and leave the upper 32 bits of
the BPF register zero. The LoongArch JIT sign-extends the result of
signed ALU32 BPF_DIV and BPF_MOD (off=1), so a negative 32-bit quotient
or remainder leaves bits 63:32 set in JITted code while the verifier
and interpreter model those bits as zero.

Keep sign-extension on the operands, which signed divide needs, and
zero-extend the ALU32 result after the divide or modulo instruction,
matching the unsigned ALU32 div/mod paths and every other ALU32
operation in this JIT.

Fixes: 2425c9e002d2 ("LoongArch: BPF: Support signed div instructions")
Fixes: 7b6b13d32965 ("LoongArch: BPF: Support signed mod instructions")
Assisted-by: Claude:claude-opus-4-8
Acked-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Tested-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Nicholas Dudar <main.kalliope@gmail.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/net/bpf_jit.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/loongarch/net/bpf_jit.c b/arch/loongarch/net/bpf_jit.c
index 29a26b5e7416f..f1aaa4367fc88 100644
--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -564,7 +564,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx, bool ext
 			move_reg(ctx, t1, src);
 			emit_sext_32(ctx, t1, is32);
 			emit_insn(ctx, divd, dst, dst, t1);
-			emit_sext_32(ctx, dst, is32);
+			emit_zext_32(ctx, dst, is32);
 		}
 		break;
 
@@ -581,7 +581,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx, bool ext
 			emit_sext_32(ctx, t1, is32);
 			emit_sext_32(ctx, dst, is32);
 			emit_insn(ctx, divd, dst, dst, t1);
-			emit_sext_32(ctx, dst, is32);
+			emit_zext_32(ctx, dst, is32);
 		}
 		break;
 
@@ -599,7 +599,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx, bool ext
 			move_reg(ctx, t1, src);
 			emit_sext_32(ctx, t1, is32);
 			emit_insn(ctx, modd, dst, dst, t1);
-			emit_sext_32(ctx, dst, is32);
+			emit_zext_32(ctx, dst, is32);
 		}
 		break;
 
@@ -616,7 +616,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx, bool ext
 			emit_sext_32(ctx, t1, is32);
 			emit_sext_32(ctx, dst, is32);
 			emit_insn(ctx, modd, dst, dst, t1);
-			emit_sext_32(ctx, dst, is32);
+			emit_zext_32(ctx, dst, is32);
 		}
 		break;
 
-- 
2.53.0



