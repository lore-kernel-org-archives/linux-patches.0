Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49406238C1A;
	Wed,  9 Sep 2026 14:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962586; cv=none; b=JlkxQDNS3MhouF5lITzn0C/qmhMPlTWTxG08/Dg7PmPtgS8/TG00x7RmHQ0lfYKb3mbtkLll2OIqbQdjO3KsL9OduKbgKxN6c6/1sOM50y++nKFQcrywA50kuKPPhlyWpkxWGo5E8mi6XcnLnB1b2tRkryI8+1KPq9Bj+n0Hu00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962586; c=relaxed/simple;
	bh=lQxX1bHDQRlp2MST3ly9sZey1BvyuadBzzvNQMK43Oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gpwrZQFIKfz42RDSQqNc9jz6z5yfn2rFHaU5S8kInEcv4mcQYe2ny3IqmUN84ynz2to8ezt/K8t3o5W/oy/cUp0f5sA6bYHOqtnzaZ4xw2rGUrBc/I3y+rKW+S4ArJd7C2fgCE4DgJflcK1Wc1u48msl87cqC5CKFXbY8qlIuc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fp80bUlw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fp80bUlw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 498AF1F00A3A;
	Wed,  9 Sep 2026 14:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962584;
	bh=kko5ME2QRxmvyNbVSfWw80BSEqpX50vKaS41e40QkJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fp80bUlw7S1znf70moyS48y2HRal/YufvBWIVsZEQQBuGFoKQ12s0trio7uQVHAJe
	 wd4niI6pmtm1lSNxVB2vnGRiN/bOXjmEBs/2pzmaY2RV5grZzU+/X5CbAvPLP5lcWY
	 EB+UPdcDJPPsCqgnd7lyQ7Zp7V1Kj5lNJmrieGdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.2 339/556] LoongArch: BPF: Move arena register slot below TCC context
Date: Wed,  9 Sep 2026 15:40:19 +0200
Message-ID: <20260909134242.580520496@linuxfoundation.org>
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

commit cd7e356b07a27e91394838cf3fb655862b519294 upstream.

Currently, the stack layout places the optional arena register slot
above the tail call counter context. When arena_vm_start is dynamically
enabled, it shifts the relative offset of the tcc_ptr slot within the
stack frame, causing hardcoded tracking macros to mismatch and leading
to memory misalignment or corruption potentially.

To fix this, move the arena register save and restore sequences below
the tail call counter context slots in both build_prologue() and the
epilogue.

Update __build_epilogue() to insert a proper offset decrement to safely
skip the unneeded tcc_ptr reading block while accurately aligning with
the relocated arena slot at the very bottom.

With this patch, the tcc_ptr slot is always positioned at a fixed
distance directly underneath the base callee-saved registers that is
independent of whether the arena features are on.

Cc: stable@vger.kernel.org
Fixes: ef54c517a937 ("LoongArch: BPF: Implement PROBE_MEM32 pseudo instructions")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/net/bpf_jit.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/loongarch/net/bpf_jit.c b/arch/loongarch/net/bpf_jit.c
index b0c39d45d6a6..fd5f8c4e5360 100644
--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -124,6 +124,9 @@ static void prepare_bpf_tail_call_cnt(struct jit_ctx *ctx, int *store_offset)
  *                            |           tcc           |
  *                            +-------------------------+
  *                            |           tcc_ptr       |
+ *                            +-------------------------+
+ *                            |           arena         |
+ *                            |         (optional)      |
  *                            +-------------------------+ <--BPF_REG_FP
  *                            |  prog->aux->stack_depth |
  *                            |        (optional)       |
@@ -145,7 +148,7 @@ static void build_prologue(struct jit_ctx *ctx)
 	stack_adjust += sizeof(long) * 2;
 
 	if (ctx->arena_vm_start)
-		stack_adjust += 8;
+		stack_adjust += sizeof(long);
 
 	stack_adjust = round_up(stack_adjust, 16);
 	stack_adjust += bpf_stack_adjust;
@@ -194,13 +197,13 @@ static void build_prologue(struct jit_ctx *ctx)
 	store_offset -= sizeof(long);
 	emit_insn(ctx, std, LOONGARCH_GPR_S5, LOONGARCH_GPR_SP, store_offset);
 
+	prepare_bpf_tail_call_cnt(ctx, &store_offset);
+
 	if (ctx->arena_vm_start) {
 		store_offset -= sizeof(long);
 		emit_insn(ctx, std, REG_ARENA, LOONGARCH_GPR_SP, store_offset);
 	}
 
-	prepare_bpf_tail_call_cnt(ctx, &store_offset);
-
 	emit_insn(ctx, addid, LOONGARCH_GPR_FP, LOONGARCH_GPR_SP, stack_adjust);
 
 	if (bpf_stack_adjust)
@@ -241,15 +244,18 @@ static void __build_epilogue(struct jit_ctx *ctx, bool is_tail_call)
 	load_offset -= sizeof(long);
 	emit_insn(ctx, ldd, LOONGARCH_GPR_S5, LOONGARCH_GPR_SP, load_offset);
 
+	/* Only restore the TCC state into REG_TCC from the higher slot */
+	load_offset -= sizeof(long);
+	emit_insn(ctx, ldd, REG_TCC, LOONGARCH_GPR_SP, load_offset);
+
+	/* Skip the unused local 'tcc_ptr' slot to align with arena */
+	load_offset -= sizeof(long);
+
 	if (ctx->arena_vm_start) {
 		load_offset -= sizeof(long);
 		emit_insn(ctx, ldd, REG_ARENA, LOONGARCH_GPR_SP, load_offset);
 	}
 
-	/* Only restore the TCC state into REG_TCC from the higher slot */
-	load_offset -= sizeof(long);
-	emit_insn(ctx, ldd, REG_TCC, LOONGARCH_GPR_SP, load_offset);
-
 	emit_insn(ctx, addid, LOONGARCH_GPR_SP, LOONGARCH_GPR_SP, stack_adjust);
 
 	if (!is_tail_call) {
-- 
2.55.0



