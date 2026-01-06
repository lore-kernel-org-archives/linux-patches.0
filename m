Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B3F376BC5;
	Tue,  6 Jan 2026 17:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722385; cv=none; b=cwkV8HQKD5zj48BWSMToFX+VZ4Pq1jzgbcWlHjimlY1xABjL9oJP/C1sWaHm/n09r0PaYzs/5WKYlCW7V+vXWrN2Sg/E7B+SkQbbIOjA+mYWe9ldR1RcmsMTlAQNPWMRDB89osQFYXdJefgMfkiZNSrbkIxjfQkkOY1n1VyUzy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722385; c=relaxed/simple;
	bh=huF2bwhD6SiVPOyA+wFbOEPxzGcL4TlPtvURnH8jZ2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=syh7X6wkVlrxVkIa2kt2NMJH2UUmfOnRsFYbBDqwUCxIV91HDrjiuCscyCKwlLKPB5UGwFIRs96Kv2Ov5ZP/5/5Gu0Ew6eCWkA5mStO1tNA7vccmXT7sZgu0vgEODxWho0kfAKajiESyKZgQD3CmmVKKuVRWE+51OXzo0E9sNSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k43kL5tp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k43kL5tp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E22C116C6;
	Tue,  6 Jan 2026 17:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722384;
	bh=huF2bwhD6SiVPOyA+wFbOEPxzGcL4TlPtvURnH8jZ2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k43kL5tpHUImtJDhwuRfirwWjv4M1Y+5lKt6Uz8bzUxCApwpxFXhfNzFi5jwYNzf9
	 ymlTa2FD0rDex6DAKVXaAJWESonCdFhXQVji0C/rmXrroMEPBy6UrLa1E+0/O8YbdV
	 EGf5wpLiEe7809vnEpBlHkq+9ZmOH+pO3OfPhQg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghao Duan <duanchenghao@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 249/312] LoongArch: BPF: Enable trampoline-based tracing for module functions
Date: Tue,  6 Jan 2026 18:05:23 +0100
Message-ID: <20260106170556.857248151@linuxfoundation.org>
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

From: Chenghao Duan <duanchenghao@kylinos.cn>

commit 26138762d9a27a7f1c33f467c4123c600f64a36e upstream.

Remove the previous restrictions that blocked the tracing of kernel
module functions. Fix the issue that previously caused kernel lockups
when attempting to trace module functions.

Before entering the trampoline code, the return address register ra
shall store the address of the next assembly instruction after the
'bl trampoline' instruction, which is the traced function address, and
the register t0 shall store the parent function return address. Refine
the trampoline return logic to ensure that register data remains correct
when returning to both the traced function and the parent function.

Before this patch was applied, the module_attach test in selftests/bpf
encountered a deadlock issue. This was caused by an incorrect jump
address after the trampoline execution, which resulted in an infinite
loop within the module function.

Cc: stable@vger.kernel.org
Fixes: 677e6123e3d2 ("LoongArch: BPF: Disable trampoline for kernel module function trace")
Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/net/bpf_jit.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -1284,7 +1284,7 @@ static int emit_jump_or_nops(void *targe
 		return 0;
 	}
 
-	return emit_jump_and_link(&ctx, is_call ? LOONGARCH_GPR_T0 : LOONGARCH_GPR_ZERO, (u64)target);
+	return emit_jump_and_link(&ctx, is_call ? LOONGARCH_GPR_RA : LOONGARCH_GPR_ZERO, (u64)target);
 }
 
 static int emit_call(struct jit_ctx *ctx, u64 addr)
@@ -1638,14 +1638,12 @@ static int __arch_prepare_bpf_trampoline
 
 	/* To traced function */
 	/* Ftrace jump skips 2 NOP instructions */
-	if (is_kernel_text((unsigned long)orig_call))
+	if (is_kernel_text((unsigned long)orig_call) ||
+	    is_module_text_address((unsigned long)orig_call))
 		orig_call += LOONGARCH_FENTRY_NBYTES;
 	/* Direct jump skips 5 NOP instructions */
 	else if (is_bpf_text_address((unsigned long)orig_call))
 		orig_call += LOONGARCH_BPF_FENTRY_NBYTES;
-	/* Module tracing not supported - cause kernel lockups */
-	else if (is_module_text_address((unsigned long)orig_call))
-		return -ENOTSUPP;
 
 	if (flags & BPF_TRAMP_F_CALL_ORIG) {
 		move_addr(ctx, LOONGARCH_GPR_A0, (const u64)im);
@@ -1738,12 +1736,16 @@ static int __arch_prepare_bpf_trampoline
 		emit_insn(ctx, ldd, LOONGARCH_GPR_FP, LOONGARCH_GPR_SP, 0);
 		emit_insn(ctx, addid, LOONGARCH_GPR_SP, LOONGARCH_GPR_SP, 16);
 
-		if (flags & BPF_TRAMP_F_SKIP_FRAME)
+		if (flags & BPF_TRAMP_F_SKIP_FRAME) {
 			/* return to parent function */
-			emit_insn(ctx, jirl, LOONGARCH_GPR_ZERO, LOONGARCH_GPR_RA, 0);
-		else
-			/* return to traced function */
+			move_reg(ctx, LOONGARCH_GPR_RA, LOONGARCH_GPR_T0);
 			emit_insn(ctx, jirl, LOONGARCH_GPR_ZERO, LOONGARCH_GPR_T0, 0);
+		} else {
+			/* return to traced function */
+			move_reg(ctx, LOONGARCH_GPR_T1, LOONGARCH_GPR_RA);
+			move_reg(ctx, LOONGARCH_GPR_RA, LOONGARCH_GPR_T0);
+			emit_insn(ctx, jirl, LOONGARCH_GPR_ZERO, LOONGARCH_GPR_T1, 0);
+		}
 	}
 
 	ret = ctx->idx;


