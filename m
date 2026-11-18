Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021914;
	b=4TVv+iOhn8Sr1Lq9q8Ct0dVn6khOopE738LcIN0fUTxY1VKwaDwIl+TXXFuHO/PkEms5
	 /JfFfPBYdjxhgDxvYusrL/M4ZB4bZBzi7HexKgniVcZFQdU8ScqWbd4lVsve6WC8GaStH
	 sSnygbAvLT3saafqwtQsdxBHhf4sLy2kcxxw5vtlXZ5ldvZaWKaG0JQxmEYtisbtxy5XS
	 4xAxbBCs4K/zDJMqyAUWyQgGjILGkcz5G3Q/XgOMN8yFRAtc5aOLMoJOl16IZnCaIadAT
	 r38MmA1lBoSVgsCH7VGzSPrcAFeTJoNdPn0Be4bEnJjgzUEfGNv0lR3QY2KjNYNJ7Lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021914;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gERFka5pz+fpPKvRJke4wtf0RT61PLE4KstebUYoOHs=;
	b=a5CGjyaHOvG09U2TsllM6UfYuA000cfJdR9QmT6Qj6A1wlav809kwhyP710TshYF/yef
	 drcE2VxlEhPdD0W1yx/x4QRmrKmegGVdJHowSS5poi1c2S/5DAX8h0h26F5dm3L8SbaeF
	 SCsDiLqdrxguws5wd/xXyzuIWSpwJFNC/JqPp/+EM8dFFXZLQ0QiUptchZjcSLFWCNN3L
	 oHjr2Mqy88zgIFfP4D903qrbMaDpESyJ79OoMsY0aXhKxUl+jsPS4QKc+UCUqjoL4Lnmm
	 YPaRUpznr0xxX+b51V2Hb9fkRoxAIDly8HyeDbfiVzc6kau4iZOejJE+ichAr85IbhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BSpaELsC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF2F606A33F;
	Wed, 18 Nov 2026 17:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BSpaELsC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5951F000C5;
	Wed, 18 Nov 2026 17:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021914;
	bh=gERFka5pz+fpPKvRJke4wtf0RT61PLE4KstebUYoOHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BSpaELsCqE4jQlnL+hY3IPtyZaAz3M4tVSOLMih/9MefvkEowlpaBNzn3lGIRSZC9
	 JtGvXCv5Q2TbPzMiRh9u/Ew4E8SJwfpRIGtq1kOoG/Lwsv5zpilITnGfbNbtofDdEe
	 A8gnuJ3oiZDc92Y+6MP1h0WfLN7HuYbR670MOpD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hengqi Chen <hengqi.chen@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2476/2651] LoongArch: BPF: Fix stack arguments for indirect trampolines
Date: Wed, 18 Nov 2026 16:01:56 +0100
Message-ID: <20261118150414.093258425@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 67ab1a331481ef282c53003e6c041c8c4348d4cd ]

LoongArch passes arguments beyond a0-a7 at the caller stack pointer. The
trampoline store_args() helper always reads those arguments at FP + 16,
which is correct for a regular fentry trampoline: its prologue leaves FP
16 bytes below the stack pointer at trampoline entry to hold the saved
RA/FP frame record of the parent function.

A struct_ops indirect trampoline is entered through a function pointer
and only saves its own RA and FP before setting FP to the entry stack
pointer. Its stack arguments therefore start at FP rather than FP + 16.
As a result, every stack-passed struct_ops argument is currently read
two slots late.

Select the source offset based on whether the trampoline is indirect.
This also prepares the stack-passed arena argument path to consume the
actual pointer slot.

With this patch the BPF selftest "./test_progs -t struct_ops_multi_args"
passed on LoongArch.

Fixes: c9ebe2016de9 ("LoongArch: BPF: Support up to 12 function arguments for trampoline")
Acked-by: Hengqi Chen <hengqi.chen@gmail.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/net/bpf_jit.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/loongarch/net/bpf_jit.c b/arch/loongarch/net/bpf_jit.c
index e78eb582c3005..119a20a7edf18 100644
--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -1674,17 +1674,17 @@ int bpf_arch_text_invalidate(void *dst, size_t len)
 	return ret;
 }
 
-static void store_args(struct jit_ctx *ctx, int nr_arg_slots, int args_off)
+static void store_args(struct jit_ctx *ctx, int nr_arg_slots, int args_off, bool is_struct_ops)
 {
 	int i;
+	int stack_args_off = is_struct_ops ? 0 : 16;
 
 	for (i = 0; i < nr_arg_slots; i++) {
 		if (i < LOONGARCH_MAX_REG_ARGS)
 			emit_insn(ctx, std, LOONGARCH_GPR_A0 + i, LOONGARCH_GPR_FP, -args_off);
 		else {
-			/* Skip slots for T0 and FP of traced function */
 			emit_insn(ctx, ldd, LOONGARCH_GPR_T1, LOONGARCH_GPR_FP,
-				  16 + (i - LOONGARCH_MAX_REG_ARGS) * 8);
+				  stack_args_off + (i - LOONGARCH_MAX_REG_ARGS) * 8);
 			emit_insn(ctx, std, LOONGARCH_GPR_T1, LOONGARCH_GPR_FP, -args_off);
 		}
 		args_off -= 8;
@@ -2017,7 +2017,7 @@ static int __arch_prepare_bpf_trampoline(struct jit_ctx *ctx, struct bpf_tramp_i
 	func_meta = nr_arg_slots;
 	emit_store_stack_imm64(ctx, LOONGARCH_GPR_T1, -func_meta_off, func_meta);
 
-	store_args(ctx, nr_arg_slots, args_off);
+	store_args(ctx, nr_arg_slots, args_off, is_struct_ops);
 
 	if (bpf_fsession_cnt(tnodes)) {
 		/* clear all session cookies' value */
-- 
2.53.0



