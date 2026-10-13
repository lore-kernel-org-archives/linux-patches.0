Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13B44CB8A8;
	Tue, 13 Oct 2026 12:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893535; cv=none; b=r+aAJ5CwDjNGU7wzuSKhQqGalPqE73crZXLZY4jvv5lEtyZau3R+qyAN9cEXs+RQ9V9GZL+Cu+A7ZfGDPg3qo5rtS2AfWM5XqF2aYViNXHIWUK4kwAA5Rdquy6HdtXwFU1e/L+wm99VCgE9E8lYLu52UFln2cF0NI3X9qaL3qT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893535; c=relaxed/simple;
	bh=UzuLFfIBqUGP5QXVQHycJ3WHs31/1ykKZE0ISkfWlnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJWovWjNRtAg7WhJJBTT92e6vC7ZTbDeuU4luJOsSmZIfkgHkQRrR8FXxcrDAdxeh5vmDivDOI9I67gztiqd7Denly54Fdl1yunECOvClBWidTKCeQLT1tVbQ5ydHSIUkI3QZiVGWR3J/9ICxtDmDMMZGDfkxxA1UjRiqh6XKxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QYbWbyYQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QYbWbyYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E885E1F000FF;
	Tue, 13 Oct 2026 12:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893534;
	bh=kMtinQDbq51dKFe2xyHFYLpzpBI7qJcxrQcTqdlNaI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QYbWbyYQG6gM/sVZR1r9+XtgXM3PthOcaKo25bcKHReC5Lv6YIqCkiCJZ+74aNI3v
	 L24wcQXR9qnJY0y76KCaOBZju1IzlhNgnqWvqjR8fBm5U2ByEvoVUVaccLdA5eojKD
	 VsRdLXNvVNsGKQc98X/zpFvKOc+tu3ywqFZeQSss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Nicholas Dudar <main.kalliope@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 259/621] LoongArch: BPF: Zero-extend signed ALU32 div/mod results
Date: Tue, 13 Oct 2026 13:34:14 +0200
Message-ID: <20261013112927.007854720@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index 5b5de4f91eb94..3fb764bc5e1b9 100644
--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -620,7 +620,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx, bool ext
 			move_reg(ctx, t1, src);
 			emit_sext_32(ctx, t1, is32);
 			emit_insn(ctx, divd, dst, dst, t1);
-			emit_sext_32(ctx, dst, is32);
+			emit_zext_32(ctx, dst, is32);
 		}
 		break;
 
@@ -637,7 +637,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx, bool ext
 			emit_sext_32(ctx, t1, is32);
 			emit_sext_32(ctx, dst, is32);
 			emit_insn(ctx, divd, dst, dst, t1);
-			emit_sext_32(ctx, dst, is32);
+			emit_zext_32(ctx, dst, is32);
 		}
 		break;
 
@@ -655,7 +655,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx, bool ext
 			move_reg(ctx, t1, src);
 			emit_sext_32(ctx, t1, is32);
 			emit_insn(ctx, modd, dst, dst, t1);
-			emit_sext_32(ctx, dst, is32);
+			emit_zext_32(ctx, dst, is32);
 		}
 		break;
 
@@ -672,7 +672,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx, bool ext
 			emit_sext_32(ctx, t1, is32);
 			emit_sext_32(ctx, dst, is32);
 			emit_insn(ctx, modd, dst, dst, t1);
-			emit_sext_32(ctx, dst, is32);
+			emit_zext_32(ctx, dst, is32);
 		}
 		break;
 
-- 
2.53.0



