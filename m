Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F2F30568A;
	Fri, 15 May 2026 16:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861043; cv=none; b=ehr6IU17tZkdyKhZN9aZ4P72XAfoO/OGDyWPz7iyGZTWZdK2dUnYPiWFOyqjiSQYcYzuvTIrx1qZTLReDVhX4S7pGYz+P77RsQdzAOMJAwFMieyqA5n/fILCtijTW18yeTYXxJE3HNYYrd+/yNYT9HYO5idCzioTFGPx8YfO/XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861043; c=relaxed/simple;
	bh=O6ZaKQI126z/4NGo/T0qrbU2R5PTphXyx2tZaB8LOaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYC80vczkJqPYqo460uADJwzcxefNSZzen5Wf/mZaSEmzhBSKvvoT/9kufjkM27sKqirmJ8HRjuEl21cQ8imEdhtdOMzeuFGo/py8l84qfeOzd1bRfpiN6y7UswQGGeYAGW2m5I1qJLPPf+iPTynX4RdaWLFnN7Pqskdp9bi4Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VNGbfn9B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VNGbfn9B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F21C2BCB0;
	Fri, 15 May 2026 16:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861043;
	bh=O6ZaKQI126z/4NGo/T0qrbU2R5PTphXyx2tZaB8LOaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VNGbfn9B7FN2KRYBPOnSt8XeymoV9V/3LUspZX4i5dnnFFBtyi4Gl1baZMMYcioad
	 nRItXDlD4vaNaPZcfxBHw42YsUSTGDt4wNJx7UV8OK3VF2Y1QDaJ8tax1nfo0y+iFR
	 Q0NxlwFu72Ypg0WhZMlnIj00+U2GtcoyBCqy2/Uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 177/474] selftests/bpf: validate zero preservation for sub-slot loads
Date: Fri, 15 May 2026 17:44:46 +0200
Message-ID: <20260515154718.854675008@linuxfoundation.org>
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

[ Upstream commit add1cd7f22e61756987865ada9fe95cd86569025 ]

Validate that 1-, 2-, and 4-byte loads from stack slots not aligned on
8-byte boundary still preserve zero, when loading from all-STACK_ZERO
sub-slots, or when stack sub-slots are covered by spilled register with
known constant zero value.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20231205184248.1502704-8-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Acked-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/progs/verifier_spill_fill.c | 71 +++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/verifier_spill_fill.c b/tools/testing/selftests/bpf/progs/verifier_spill_fill.c
index d9dabae811767..41fd61299eab0 100644
--- a/tools/testing/selftests/bpf/progs/verifier_spill_fill.c
+++ b/tools/testing/selftests/bpf/progs/verifier_spill_fill.c
@@ -490,4 +490,75 @@ __naked void spill_subregs_preserve_stack_zero(void)
 	: __clobber_all);
 }
 
+char single_byte_buf[1] SEC(".data.single_byte_buf");
+
+SEC("raw_tp")
+__log_level(2)
+__success
+__naked void partial_stack_load_preserves_zeros(void)
+{
+	asm volatile (
+		/* fp-8 is all STACK_ZERO */
+		".8byte %[fp8_st_zero];" /* LLVM-18+: *(u64 *)(r10 -8) = 0; */
+
+		/* fp-16 is const zero register */
+		"r0 = 0;"
+		"*(u64 *)(r10 -16) = r0;"
+
+		/* load single U8 from non-aligned STACK_ZERO slot */
+		"r1 = %[single_byte_buf];"
+		"r2 = *(u8 *)(r10 -1);"
+		"r1 += r2;"
+		"*(u8 *)(r1 + 0) = r2;" /* this should be fine */
+
+		/* load single U8 from non-aligned ZERO REG slot */
+		"r1 = %[single_byte_buf];"
+		"r2 = *(u8 *)(r10 -9);"
+		"r1 += r2;"
+		"*(u8 *)(r1 + 0) = r2;" /* this should be fine */
+
+		/* load single U16 from non-aligned STACK_ZERO slot */
+		"r1 = %[single_byte_buf];"
+		"r2 = *(u16 *)(r10 -2);"
+		"r1 += r2;"
+		"*(u8 *)(r1 + 0) = r2;" /* this should be fine */
+
+		/* load single U16 from non-aligned ZERO REG slot */
+		"r1 = %[single_byte_buf];"
+		"r2 = *(u16 *)(r10 -10);"
+		"r1 += r2;"
+		"*(u8 *)(r1 + 0) = r2;" /* this should be fine */
+
+		/* load single U32 from non-aligned STACK_ZERO slot */
+		"r1 = %[single_byte_buf];"
+		"r2 = *(u32 *)(r10 -4);"
+		"r1 += r2;"
+		"*(u8 *)(r1 + 0) = r2;" /* this should be fine */
+
+		/* load single U32 from non-aligned ZERO REG slot */
+		"r1 = %[single_byte_buf];"
+		"r2 = *(u32 *)(r10 -12);"
+		"r1 += r2;"
+		"*(u8 *)(r1 + 0) = r2;" /* this should be fine */
+
+		/* for completeness, load U64 from STACK_ZERO slot */
+		"r1 = %[single_byte_buf];"
+		"r2 = *(u64 *)(r10 -8);"
+		"r1 += r2;"
+		"*(u8 *)(r1 + 0) = r2;" /* this should be fine */
+
+		/* for completeness, load U64 from ZERO REG slot */
+		"r1 = %[single_byte_buf];"
+		"r2 = *(u64 *)(r10 -16);"
+		"r1 += r2;"
+		"*(u8 *)(r1 + 0) = r2;" /* this should be fine */
+
+		"r0 = 0;"
+		"exit;"
+	:
+	: __imm_ptr(single_byte_buf),
+	  __imm_insn(fp8_st_zero, BPF_ST_MEM(BPF_DW, BPF_REG_FP, -8, 0))
+	: __clobber_common);
+}
+
 char _license[] SEC("license") = "GPL";
-- 
2.53.0



