Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AED43E095;
	Thu, 30 Jul 2026 14:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422121; cv=none; b=aNjJEPx0EK645sC0KRvemzfL8i9andrHCU2NnkxFj+vOH+q2f0l1qdCiUlLl4sPHJRgj6fELqWMyT0DDqqUHNa6LMq+algF5LnUJNW0/eEf9LJIUrQYiEDKWm8P0K5KcAPv8qNGQJzH7Tcudj3EYJlHFkSe3y+6UHSuCoowg2K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422121; c=relaxed/simple;
	bh=VXqF9w/EKotYVUAOXFaYqf2oEyxyYlPL6MQMZGdvmoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=asnAH2M6MG1rb1SKCB8TlcXLT4H28an74Gd9nno/NvDQP5yKUyXi6fgHkzkuI7l6NqRv2Ejgb3CTvV6sRoTp1isFL3vfq0vFDhMgCVncOWuu6tEdp/cn6PFhMoq9LKpFaso/R0WHOrYBlOb0IwqC5g14BKYbt9C+eNHurhdRhm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jn7503Zj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jn7503Zj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23C51F000E9;
	Thu, 30 Jul 2026 14:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422119;
	bh=bq85O/Y+IcVPN+QUWXgfNYVP9M6ojXA/5lKn0P3cE8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jn7503ZjnQW5VkxE7iSeEpCieZOtJ+VCIcg/XsbdCmgfWLeFSapToPZAyrQ9wGHaR
	 gQojJCt9EDepEMbA1Bh2pLF95Rwb/E0WTl4PtdXOF4OF9z4szoPnRmI3GQFhQlVzkM
	 RvfTwoPhVnQk2Vaj13ld2DBc2AnwoMH6EwwkiOJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Nicholas Dudar <main.kalliope@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 332/744] LoongArch: BPF: Zero-extend signed ALU32 div/mod results
Date: Thu, 30 Jul 2026 16:10:05 +0200
Message-ID: <20260730141451.341303714@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index e4966c178abc56..22c03c02dae6ed 100644
--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -834,7 +834,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx, bool ext
 			move_reg(ctx, t1, src);
 			emit_sext_32(ctx, t1, is32);
 			emit_insn(ctx, divd, dst, dst, t1);
-			emit_sext_32(ctx, dst, is32);
+			emit_zext_32(ctx, dst, is32);
 		}
 		break;
 
@@ -851,7 +851,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx, bool ext
 			emit_sext_32(ctx, t1, is32);
 			emit_sext_32(ctx, dst, is32);
 			emit_insn(ctx, divd, dst, dst, t1);
-			emit_sext_32(ctx, dst, is32);
+			emit_zext_32(ctx, dst, is32);
 		}
 		break;
 
@@ -869,7 +869,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx, bool ext
 			move_reg(ctx, t1, src);
 			emit_sext_32(ctx, t1, is32);
 			emit_insn(ctx, modd, dst, dst, t1);
-			emit_sext_32(ctx, dst, is32);
+			emit_zext_32(ctx, dst, is32);
 		}
 		break;
 
@@ -886,7 +886,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx, bool ext
 			emit_sext_32(ctx, t1, is32);
 			emit_sext_32(ctx, dst, is32);
 			emit_insn(ctx, modd, dst, dst, t1);
-			emit_sext_32(ctx, dst, is32);
+			emit_zext_32(ctx, dst, is32);
 		}
 		break;
 
-- 
2.53.0



