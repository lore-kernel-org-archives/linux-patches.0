Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D284FDE6C;
	Wed,  9 Sep 2026 14:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962589; cv=none; b=pwzPFvNpu7OK5uq6eaF7WpMS7GPNDwUcgzaAum6KLjdIQaDVL1BLx1kGoMHSATapPPflEBE3cXM7YRVtLKpONBFbQJusORQuD8IBkZttD77aS3HzY78Z9HVW5LORNl4d/+d9PZAbJFWJnpe3BB2WV6/vbkqnAQ8EkEM25pYlDeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962589; c=relaxed/simple;
	bh=IqzBocDLNx4iuhjxz59Qc8rmMtAZCgxCGlc9xjuABqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNOIYgs7x0fDAlu/smKnTu+sgDXk/d9Mz+xd5HPe5mmkFtL6wcdcOOvQ40wiBNLYzFIbBlqa5426wLXyFMoWIkyKNnY+DosDfcExg92koEgzCKLPAhHM9gh+vPiUns5ZjHYjEahXEv4H8BY/ha07wVC7/FTicYv0AF/fxvr39TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Do7Fuvzl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Do7Fuvzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34BA51F00A3A;
	Wed,  9 Sep 2026 14:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962587;
	bh=7+OaFE1zg+5f/b8CAKqHo2w1LICO0aRX/Ebrg7Ou6CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Do7FuvzlCq9Msk9CbYqMQdUAe7I99Z6+2e7fOxC1y4l+jZ79sWLdYQHX9Vpuvc6Ww
	 x4xhhFwOU8RsWREpZTS6Ey7FJDU5TQl+mcNwCpDQ14HFi09YP3E0hAliWAUObkHUWc
	 xBphZoFlA8oFye6zTrKvahXH7q2i6mwWDa5kL3YI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.2 340/556] LoongArch: BPF: Fix off-by-one error for insn_is_cast_user()
Date: Wed,  9 Sep 2026 15:40:20 +0200
Message-ID: <20260909134242.616108682@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit 30419a0aa128135a81be917eaa3bd2f1a10c9ca3 upstream.

In the LoongArch BPF JIT code, the branch offset represents the number
of instructions. An offset of 1 means the target of the "beq" is the
current PC plus 1 instruction (PC + 4 bytes). This matches the exact
same path as the sequential non-branch execution, the "or" instruction
is always executed for the cast_user JIT arm in build_insn().

If the pointer is not NULL, there is no side effect. But if the pointer
is NULL, it is incorrectly combined with the base address and turns into
a non-zero address, meaning a zero arena offset no longer casts to NULL.

Fix this by changing the branch offset from 1 to 2, which properly skips
the "or" instruction and jumps directly to the "move_reg" instruction if
the pointer is NULL, ensuring the destination register is safely cleared
to 0.

Cc: stable@vger.kernel.org
Fixes: 4fdb5dd8aeba ("LoongArch: BPF: Implement bpf_addr_space_cast instruction")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/net/bpf_jit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -734,7 +734,7 @@ static int build_insn(const struct bpf_i
 			move_reg(ctx, t1, src);
 			emit_zext_32(ctx, t1, true);
 			move_imm(ctx, dst, (ctx->user_vm_start >> 32) << 32, false);
-			emit_insn(ctx, beq, t1, LOONGARCH_GPR_ZERO, 1);
+			emit_insn(ctx, beq, t1, LOONGARCH_GPR_ZERO, 2);
 			emit_insn(ctx, or, t1, dst, t1);
 			move_reg(ctx, dst, t1);
 			break;


