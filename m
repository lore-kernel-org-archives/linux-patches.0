Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F951471262;
	Tue, 21 Jul 2026 18:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657890; cv=none; b=a1wseMhnPTonZpw9j5dgtude/HaM61qTZU3ywe1PQDP6tOp9OkkI1tQh8kINBhz6QAF1hK3C+43aRFoKyluhCe3hRfOc/e39PEl9A446X6wGeBVHr/dSbBcXo5TFPcud9UGzcFlQykDYPj89asllWRPK7O2TZD04rhIjojHukdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657890; c=relaxed/simple;
	bh=bQbSdskbxpF3aZhAR19nzZxt71XrmyqYbOeaEpvbMv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KgFWkIxjCNj5b3QfsbQnhS0RjJRc3edIpZpAWAXFwNA3p83+rFnU/7H/qoy2CeDxjjacyffkVzg9QKYbrHL8l+76VJgkIhS8IboaxUwMQ9+Ze0eVzipMrAb9TRDTb2kSa+9wZomPvuWH3Yvw5ya1AvqaEVoR3Sy5X/IFUvT6DH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QuVbbawA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QuVbbawA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8414B1F000E9;
	Tue, 21 Jul 2026 18:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657889;
	bh=EpGxXUlilDjgRURnzGOoYpI8wmnVz0LcgIQ544+R0jQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QuVbbawAIoyVbFINvBLkOkoivFUXFtzFfVZtoLkW72tBeu9Cc8SNZP2yCX0UJrrtN
	 AqC6GX5SDlH7VWl1dvsF9TFmW9cLpnoDPGGQy6F6GlGU06disCyk6MiTxxpgBkHD8A
	 mc0GpoEoYuGQCBe4wRn5lgWTVzQVbGhSptVKQsoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0937/1611] LoongArch: BPF: Fix outdated tail call comments
Date: Tue, 21 Jul 2026 17:17:33 +0200
Message-ID: <20260721152536.463437205@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 25d9127bb0e27275d55a5b3d0fd30b04bafffd5a ]

The current LoongArch BPF JIT implementation hardcodes the number of
prologue instructions skipped during a tail call as a magic number '7'
in the jirl instruction. However, the accompanying comment explaining
this offset is completely outdated. It inaccurately states that only
a single TCC initialization instruction is bypassed, but in reality,
multiple setup slots are skipped, so fix these outdated comments in
__build_epilogue().

While at it, refine the comments in build_prologue() to describe the
skipped setup slots (RA saving, fentry nops, and the TCC register slot)
using proper dynamic tracing context. Also, remove the magic number '7'
by introducing descriptive macros to formally define the prologue layout
and make the tail call jump offset self-documenting.

Fixes: 61319d15a560 ("LoongArch: BPF: Adjust the jump offset of tail calls")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/net/bpf_jit.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/loongarch/net/bpf_jit.c b/arch/loongarch/net/bpf_jit.c
index a000620ca99da7..5bfed3c4e08398 100644
--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -9,7 +9,13 @@
 
 #define LOONGARCH_MAX_REG_ARGS 8
 
+#define LOONGARCH_SAVE_RA_NINSNS   1
 #define LOONGARCH_LONG_JUMP_NINSNS 5
+#define LOONGARCH_TCC_SLOT_NINSNS  1
+
+#define LOONGARCH_PROLOGUE_SKIP_INSNS \
+	(LOONGARCH_SAVE_RA_NINSNS + LOONGARCH_LONG_JUMP_NINSNS + LOONGARCH_TCC_SLOT_NINSNS)
+
 #define LOONGARCH_LONG_JUMP_NBYTES (LOONGARCH_LONG_JUMP_NINSNS * 4)
 
 #define LOONGARCH_FENTRY_NINSNS 2
@@ -139,8 +145,13 @@ static void build_prologue(struct jit_ctx *ctx)
 	stack_adjust = round_up(stack_adjust, 16);
 	stack_adjust += bpf_stack_adjust;
 
+	/*
+	 * Save the original return address to a temporary register to prevent
+	 * it from being overwritten, then reserve space for the long jump and
+	 * fentry trampoline slot for dynamically patching by ftrace at runtime.
+	 * These instructions are bypassed during a tail call invocation.
+	 */
 	move_reg(ctx, LOONGARCH_GPR_T0, LOONGARCH_GPR_RA);
-	/* Reserve space for the move_imm + jirl instruction */
 	for (i = 0; i < LOONGARCH_LONG_JUMP_NINSNS; i++)
 		emit_insn(ctx, nop);
 
@@ -236,10 +247,11 @@ static void __build_epilogue(struct jit_ctx *ctx, bool is_tail_call)
 		emit_insn(ctx, jirl, LOONGARCH_GPR_ZERO, LOONGARCH_GPR_RA, 0);
 	} else {
 		/*
-		 * Call the next bpf prog and skip the first instruction
-		 * of TCC initialization.
+		 * Tail call to the next BPF program, passing offset in number
+		 * of instructions to jirl to bypass the initial setup slots.
 		 */
-		emit_insn(ctx, jirl, LOONGARCH_GPR_ZERO, LOONGARCH_GPR_T3, 7);
+		emit_insn(ctx, jirl, LOONGARCH_GPR_ZERO,
+			  LOONGARCH_GPR_T3, LOONGARCH_PROLOGUE_SKIP_INSNS);
 	}
 }
 
-- 
2.53.0



