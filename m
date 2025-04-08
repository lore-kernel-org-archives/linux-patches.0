Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EAF326981C;
	Tue,  8 Apr 2025 12:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113639; cv=none; b=YEbRcGlMRXZzWjoZ2LqGPcqalXYzVvzFkfSabVn08MNx1WuN3CaEJVK0y0X1PC29DjyRHl6r1FzgIyCTlZC03X3E6tOmkbIl/5bDYkDpcAeVWzHCZkIR3wtcclr16tOlcbypY7AUV20UE1wgIPU9+OJjczrnF756baBqjZzcCuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113639; c=relaxed/simple;
	bh=R2MJhlLqCM+XZEdah4jibaBZGAvXhF2nyYYPymTl+JM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ULDZihiOBU1TEaouxVwr+0lH3AgqcC3pubvqTUs/FbiQW4+DkJVV9BMDf1BN3nMgtJIKhXmKwxytcw/ZxlME1ohkDlLVASqpQ2ETkR1OpNYszIaUfrSOzcS/mGvRBDxvDs9FZPvmOnx4qY0sp1sDxlS6D0/bzEbp93t18xQ69Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RFwrGPj8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RFwrGPj8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C62C4CEE5;
	Tue,  8 Apr 2025 12:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113639;
	bh=R2MJhlLqCM+XZEdah4jibaBZGAvXhF2nyYYPymTl+JM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RFwrGPj8Nhrd6Liulxi+xZPad+7K2dyh2FnVdRfsHWQ8x0vzJ/g5bH3nuaqTbbnZN
	 /9e3fIHHFTnjdt0fchYZle3d8rkdAoLkPXHEW1X5Fj11yyQ8+oReIhwkxVUtrqjo2o
	 6EW/l0/rABbHDlM/fjo5DJAOWFj4JbC6squSJE3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Li <vincent.mc.li@gmail.com>,
	Hengqi Chen <hengqi.chen@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 232/268] LoongArch: BPF: Fix off-by-one error in build_prologue()
Date: Tue,  8 Apr 2025 12:50:43 +0200
Message-ID: <20250408104834.846980240@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hengqi Chen <hengqi.chen@gmail.com>

commit 7e2586991e36663c9bc48c828b83eab180ad30a9 upstream.

Vincent reported that running BPF progs with tailcalls on LoongArch
causes kernel hard lockup. Debugging the issues shows that the JITed
image missing a jirl instruction at the end of the epilogue.

There are two passes in JIT compiling, the first pass set the flags and
the second pass generates JIT code based on those flags. With BPF progs
mixing bpf2bpf and tailcalls, build_prologue() generates N insns in the
first pass and then generates N+1 insns in the second pass. This makes
epilogue_offset off by one and we will jump to some unexpected insn and
cause lockup. Fix this by inserting a nop insn.

Cc: stable@vger.kernel.org
Fixes: 5dc615520c4d ("LoongArch: Add BPF JIT support")
Fixes: bb035ef0cc91 ("LoongArch: BPF: Support mixing bpf2bpf and tailcalls")
Reported-by: Vincent Li <vincent.mc.li@gmail.com>
Tested-by: Vincent Li <vincent.mc.li@gmail.com>
Closes: https://lore.kernel.org/loongarch/CAK3+h2w6WESdBN3UCr3WKHByD7D6Q_Ve1EDAjotVrnx6Or_c8g@mail.gmail.com/
Closes: https://lore.kernel.org/bpf/CAK3+h2woEjG_N=-XzqEGaAeCmgu2eTCUc7p6bP4u8Q+DFHm-7g@mail.gmail.com/
Signed-off-by: Hengqi Chen <hengqi.chen@gmail.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/net/bpf_jit.c |    2 ++
 arch/loongarch/net/bpf_jit.h |    5 +++++
 2 files changed, 7 insertions(+)

--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -142,6 +142,8 @@ static void build_prologue(struct jit_ct
 	 */
 	if (seen_tail_call(ctx) && seen_call(ctx))
 		move_reg(ctx, TCC_SAVED, REG_TCC);
+	else
+		emit_insn(ctx, nop);
 
 	ctx->stack_size = stack_adjust;
 }
--- a/arch/loongarch/net/bpf_jit.h
+++ b/arch/loongarch/net/bpf_jit.h
@@ -27,6 +27,11 @@ struct jit_data {
 	struct jit_ctx ctx;
 };
 
+static inline void emit_nop(union loongarch_instruction *insn)
+{
+	insn->word = INSN_NOP;
+}
+
 #define emit_insn(ctx, func, ...)						\
 do {										\
 	if (ctx->image != NULL) {						\


