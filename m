Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110573DC4C2;
	Tue, 21 Jul 2026 17:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653387; cv=none; b=NwDFPfCeiYX3CWREtm92d6DBZdrhbweDcKD0r4fTryJksdFcOD157khKe04q600pLJigPTZQxCOH8tvdrLIXqpQ6mXAX+bp3/6AHhECWNBQouTi0kslU1TDAgziDitrWSuqFCe+fzW/0UN9mqpc2Ds2j4n6tdRLrRkNFzSDGzHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653387; c=relaxed/simple;
	bh=Cd5c1ttDjtax7KaM9q3gAMC4x8DQEgjCUDE/3/SIXAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qzInJ/5f5l9SqiuMAx9/S/j1nYUpyPQN1WRo5L1Qu2vkeXy4rtBunF33dEI5BOWfVofna725mGzu+uN0iCVeSxT0eX2roE59qCCGnbeR5S/Hlbmem1oe28b+YwwDiv1ClfgniaCulcbN8GOjAzgt0MDNIKBi4DFLrDsCg1zPcyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g1sQsqPv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g1sQsqPv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054631F000E9;
	Tue, 21 Jul 2026 17:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653385;
	bh=P3FR4rSr22qO4IHwNvnpFrIj7F6JJ7Xen5gdPcFcxhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g1sQsqPvs2jwAVNoq8jg0Smm5iV1Kzb1plTaVifNaXXG23U/1gURC09QkyKNrtM7y
	 VKqgAF/6dMuin4I6VqOO8/KxNyzWOhrDeJuS3yxerKLwBJW9lYyJsd1mwnnoA1FeZ2
	 WRqQcQgHbTJKg+hreBODoZMHgc8oxNjavelmho1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1290/2077] LoongArch: BPF: Fix off-by-one error in tail call
Date: Tue, 21 Jul 2026 17:16:03 +0200
Message-ID: <20260721152623.245618262@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 0379d10f09bc21ba739636796669dfb4936172a3 ]

The current code updates the tail call counter (TCC) using a pre-increment
approach, it stores the incremented value back to memory before performing
any boundary or target validation checks.

This causes two major issues:
1. When a tail call fails because the target program is NULL, the TCC is
   incorrectly incremented and saved in memory anyway.
2. This dummy increment implicitly consumes one slot of the allowed tail
   call budget. As a result, the subsequent loop reaches the maximum limit
   prematurely, leading to a test failure where the actual loop count is
   32 instead of the expected 33.

Fix this by deferring the counter update. Change the branch condition to
BPF_JSGE (greater or equal) so that we check the boundary first. The TCC
is only incremented and stored back to memory after the boundary check
and the NULL-target check both pass.

Before:

  $ sudo ./test_progs -t tailcalls/tailcall_3
  ...
  test_tailcall_count:FAIL:tailcall count unexpected tailcall count: actual 32 != expected 33
  ...
  #465/3   tailcalls/tailcall_3:FAIL
  #465     tailcalls:FAIL

After:

  $ sudo ./test_progs -t tailcalls/tailcall_3
  #465/3   tailcalls/tailcall_3:OK
  #465     tailcalls:OK
  Summary: 1/1 PASSED, 0 SKIPPED, 0 FAILED

Fixes: c0fcc955ff82 ("LoongArch: BPF: Fix the tailcall hierarchy")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/net/bpf_jit.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/loongarch/net/bpf_jit.c b/arch/loongarch/net/bpf_jit.c
index 64a7f7e60a01e8..e4966c178abc56 100644
--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -324,12 +324,12 @@ static int emit_bpf_tail_call(struct jit_ctx *ctx, int insn)
 	 */
 	emit_insn(ctx, ldd, REG_TCC, LOONGARCH_GPR_SP, tcc_ptr_off);
 	emit_insn(ctx, ldd, t3, REG_TCC, 0);
-	emit_insn(ctx, addid, t3, t3, 1);
-	emit_insn(ctx, std, t3, REG_TCC, 0);
 	emit_insn(ctx, addid, t2, LOONGARCH_GPR_ZERO, MAX_TAIL_CALL_CNT);
-	if (emit_tailcall_jmp(ctx, BPF_JSGT, t3, t2, jmp_offset) < 0)
+	if (emit_tailcall_jmp(ctx, BPF_JSGE, t3, t2, jmp_offset) < 0)
 		goto toofar;
 
+	emit_insn(ctx, addid, t3, t3, 1);
+
 	/*
 	 * prog = array->ptrs[index];
 	 * if (!prog)
@@ -342,6 +342,8 @@ static int emit_bpf_tail_call(struct jit_ctx *ctx, int insn)
 	if (emit_tailcall_jmp(ctx, BPF_JEQ, t2, LOONGARCH_GPR_ZERO, jmp_offset) < 0)
 		goto toofar;
 
+	emit_insn(ctx, std, t3, REG_TCC, 0);
+
 	/* goto *(prog->bpf_func + 4); */
 	off = offsetof(struct bpf_prog, bpf_func);
 	emit_insn(ctx, ldd, t3, t2, off);
-- 
2.53.0



