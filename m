Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9693B6354;
	Fri, 15 May 2026 16:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861030; cv=none; b=oKIqkEUqPamCE5Bje1ZIFPEa6oPUCX4lV2dQdEJjHU3tbDyYrVOwuZiyNGJo1EXgcitqANRwy+HnvV30JlyTtrL2vLPci+S4Fz9KUV8RCJ2GKcVB8t0ZN6he1KJ9D7dD3USY/LRHojS8gE5PLAUtJI8A8omdDE3mQK3PIox5OAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861030; c=relaxed/simple;
	bh=QSJj8JPar4FNdJ7yxenSoIODCL4QesM62FHv43c/HrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kzz43mevUXrHHagT6H9kS8cD2TQJ/ydlj9khgrm8ugJjf6j6Vsvx5beYXMSxlNcSWqIbPI7GoedspCKBaC3K5qe+XpXY6lZ6j3KpmImI8OJ0n7ipFYgCgrpVzqgW/i9JCqPuztBU1BCsPtS0u8arz3lt4FlqoUVDKA3eYwAvXDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lFYLqLm2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lFYLqLm2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D12C2BCB0;
	Fri, 15 May 2026 16:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861030;
	bh=QSJj8JPar4FNdJ7yxenSoIODCL4QesM62FHv43c/HrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lFYLqLm2HBe3zYQSnnWVVsv5SHAt/pDS0S1FA9Ykhi9AEzGTfVtDwERdjba5ix1vc
	 zZk0qd0h4CCMp75fcoWvEBd1PCflYY0gUcx2hgBSSoI8z6rwRURTGwWx5qfAx08XI4
	 eLF8rYrULSWrMCmZugdxVRM+RdKw4k/x6S59Hebw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 173/474] selftests/bpf: add stack access precision test
Date: Fri, 15 May 2026 17:44:42 +0200
Message-ID: <20260515154718.766758549@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 876301881c436bf38e83a2c0d276a24b642e4aab ]

Add a new selftests that validates precision tracking for stack access
instruction, using both r10-based and non-r10-based accesses. For
non-r10 ones we also make sure to have non-zero var_off to validate that
final stack offset is tracked properly in instruction history
information inside verifier.

Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20231205184248.1502704-3-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Acked-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bpf/progs/verifier_subprog_precision.c    | 64 +++++++++++++++++--
 1 file changed, 59 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/verifier_subprog_precision.c b/tools/testing/selftests/bpf/progs/verifier_subprog_precision.c
index 7c159b5618624..4b8b0f45d17d7 100644
--- a/tools/testing/selftests/bpf/progs/verifier_subprog_precision.c
+++ b/tools/testing/selftests/bpf/progs/verifier_subprog_precision.c
@@ -593,14 +593,68 @@ __naked int subprog_spill_into_parent_stack_slot_precise(void)
 	);
 }
 
-__naked __noinline __used
-static __u64 subprog_with_checkpoint(void)
+SEC("?raw_tp")
+__success __log_level(2)
+__msg("17: (0f) r1 += r0")
+__msg("mark_precise: frame0: last_idx 17 first_idx 0 subseq_idx -1")
+__msg("mark_precise: frame0: regs=r0 stack= before 16: (bf) r1 = r7")
+__msg("mark_precise: frame0: regs=r0 stack= before 15: (27) r0 *= 4")
+__msg("mark_precise: frame0: regs=r0 stack= before 14: (79) r0 = *(u64 *)(r10 -16)")
+__msg("mark_precise: frame0: regs= stack=-16 before 13: (7b) *(u64 *)(r7 -8) = r0")
+__msg("mark_precise: frame0: regs=r0 stack= before 12: (79) r0 = *(u64 *)(r8 +16)")
+__msg("mark_precise: frame0: regs= stack=-16 before 11: (7b) *(u64 *)(r8 +16) = r0")
+__msg("mark_precise: frame0: regs=r0 stack= before 10: (79) r0 = *(u64 *)(r7 -8)")
+__msg("mark_precise: frame0: regs= stack=-16 before 9: (7b) *(u64 *)(r10 -16) = r0")
+__msg("mark_precise: frame0: regs=r0 stack= before 8: (07) r8 += -32")
+__msg("mark_precise: frame0: regs=r0 stack= before 7: (bf) r8 = r10")
+__msg("mark_precise: frame0: regs=r0 stack= before 6: (07) r7 += -8")
+__msg("mark_precise: frame0: regs=r0 stack= before 5: (bf) r7 = r10")
+__msg("mark_precise: frame0: regs=r0 stack= before 21: (95) exit")
+__msg("mark_precise: frame1: regs=r0 stack= before 20: (bf) r0 = r1")
+__msg("mark_precise: frame1: regs=r1 stack= before 4: (85) call pc+15")
+__msg("mark_precise: frame0: regs=r1 stack= before 3: (bf) r1 = r6")
+__msg("mark_precise: frame0: regs=r6 stack= before 2: (b7) r6 = 1")
+__naked int stack_slot_aliases_precision(void)
 {
 	asm volatile (
-		"r0 = 0;"
-		/* guaranteed checkpoint if BPF_F_TEST_STATE_FREQ is used */
-		"goto +0;"
+		"r6 = 1;"
+		/* pass r6 through r1 into subprog to get it back as r0;
+		 * this whole chain will have to be marked as precise later
+		 */
+		"r1 = r6;"
+		"call identity_subprog;"
+		/* let's setup two registers that are aliased to r10 */
+		"r7 = r10;"
+		"r7 += -8;"			/* r7 = r10 - 8 */
+		"r8 = r10;"
+		"r8 += -32;"			/* r8 = r10 - 32 */
+		/* now spill subprog's return value (a r6 -> r1 -> r0 chain)
+		 * a few times through different stack pointer regs, making
+		 * sure to use r10, r7, and r8 both in LDX and STX insns, and
+		 * *importantly* also using a combination of const var_off and
+		 * insn->off to validate that we record final stack slot
+		 * correctly, instead of relying on just insn->off derivation,
+		 * which is only valid for r10-based stack offset
+		 */
+		"*(u64 *)(r10 - 16) = r0;"
+		"r0 = *(u64 *)(r7 - 8);"	/* r7 - 8 == r10 - 16 */
+		"*(u64 *)(r8 + 16) = r0;"	/* r8 + 16 = r10 - 16 */
+		"r0 = *(u64 *)(r8 + 16);"
+		"*(u64 *)(r7 - 8) = r0;"
+		"r0 = *(u64 *)(r10 - 16);"
+		/* get ready to use r0 as an index into array to force precision */
+		"r0 *= 4;"
+		"r1 = %[vals];"
+		/* here r0->r1->r6 chain is forced to be precise and has to be
+		 * propagated back to the beginning, including through the
+		 * subprog call and all the stack spills and loads
+		 */
+		"r1 += r0;"
+		"r0 = *(u32 *)(r1 + 0);"
 		"exit;"
+		:
+		: __imm_ptr(vals)
+		: __clobber_common, "r6"
 	);
 }
 
-- 
2.53.0



