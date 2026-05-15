Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C0E30568A;
	Fri, 15 May 2026 16:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861038; cv=none; b=HoRef73/1AIZBeaGVmNVSKtd1RhGlDewjpd63g6JEGzKSGZ6XO7WlHrvemzYZ0VKS03yxQV34mnTxM8cDw2pPT4YZHuR3FdnE2ZFDmO5RmzQK0SxcdTYCyBDMIS8e8Dy4cLSRDZ/2q8v3wnYSn5ba3ZWb7Du8o+ZCmQEv/rXWBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861038; c=relaxed/simple;
	bh=F8X9LC040/yvQupX3w+ajtv7AVaOLyH0XgwKdRG2AmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PY+ktchA6dvdk1WeMkaLhccgjKn9vigZwNmSAVQ+4o28yecpLggSIFsF0XRfTTolCqQMlXADWk3LVnoyIoBC7HFveuoCPbA09LpQkA9FzNF4m1A20BQja4JJojyJeGUAnWFJQSjXaWuyptjBc11alqF01oC26qssQ8Fp/Ew1qRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GQTd4IUE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GQTd4IUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5984C2BCB0;
	Fri, 15 May 2026 16:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861038;
	bh=F8X9LC040/yvQupX3w+ajtv7AVaOLyH0XgwKdRG2AmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GQTd4IUE8aEidwW6bZrBPogECG7ucnpQzSLI//+5JYFNibeg9IrbnkRzFXWi/ll1x
	 K3FtblBRT2QqPgx2LblLfbpK+zyhkfEq8K+dioT0EYx1hUPOi5sHr64L4fwd/yviou
	 Gpsmlv0lAB5RrA1J+nm4BzuZiMIqQQX8Cj6vqT7o=
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
Subject: [PATCH 6.6 175/474] selftests/bpf: validate STACK_ZERO is preserved on subreg spill
Date: Fri, 15 May 2026 17:44:44 +0200
Message-ID: <20260515154718.809843047@linuxfoundation.org>
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

[ Upstream commit b33ceb6a3d2ee07fdd836373383a6d4783581324 ]

Add tests validating that STACK_ZERO slots are preserved when slot is
partially overwritten with subregister spill.

Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20231205184248.1502704-6-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Acked-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/progs/verifier_spill_fill.c | 40 +++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/verifier_spill_fill.c b/tools/testing/selftests/bpf/progs/verifier_spill_fill.c
index 6115520154e33..d9dabae811767 100644
--- a/tools/testing/selftests/bpf/progs/verifier_spill_fill.c
+++ b/tools/testing/selftests/bpf/progs/verifier_spill_fill.c
@@ -4,6 +4,7 @@
 #include <linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 #include "bpf_misc.h"
+#include <../../../tools/include/linux/filter.h>
 
 struct {
 	__uint(type, BPF_MAP_TYPE_RINGBUF);
@@ -450,4 +451,43 @@ l0_%=:	r1 >>= 16;					\
 	: __clobber_all);
 }
 
+SEC("raw_tp")
+__log_level(2)
+__success
+__msg("fp-8=0m??mmmm")
+__msg("fp-16=00mm??mm")
+__msg("fp-24=00mm???m")
+__naked void spill_subregs_preserve_stack_zero(void)
+{
+	asm volatile (
+		"call %[bpf_get_prandom_u32];"
+
+		/* 32-bit subreg spill with ZERO, MISC, and INVALID */
+		".8byte %[fp1_u8_st_zero];"   /* ZERO, LLVM-18+: *(u8 *)(r10 -1) = 0; */
+		"*(u8 *)(r10 -2) = r0;"       /* MISC */
+		/* fp-3 and fp-4 stay INVALID */
+		"*(u32 *)(r10 -8) = r0;"
+
+		/* 16-bit subreg spill with ZERO, MISC, and INVALID */
+		".8byte %[fp10_u16_st_zero];" /* ZERO, LLVM-18+: *(u16 *)(r10 -10) = 0; */
+		"*(u16 *)(r10 -12) = r0;"     /* MISC */
+		/* fp-13 and fp-14 stay INVALID */
+		"*(u16 *)(r10 -16) = r0;"
+
+		/* 8-bit subreg spill with ZERO, MISC, and INVALID */
+		".8byte %[fp18_u16_st_zero];" /* ZERO, LLVM-18+: *(u16 *)(r18 -10) = 0; */
+		"*(u16 *)(r10 -20) = r0;"     /* MISC */
+		/* fp-21, fp-22, and fp-23 stay INVALID */
+		"*(u8 *)(r10 -24) = r0;"
+
+		"r0 = 0;"
+		"exit;"
+	:
+	: __imm(bpf_get_prandom_u32),
+	  __imm_insn(fp1_u8_st_zero, BPF_ST_MEM(BPF_B, BPF_REG_FP, -1, 0)),
+	  __imm_insn(fp10_u16_st_zero, BPF_ST_MEM(BPF_H, BPF_REG_FP, -10, 0)),
+	  __imm_insn(fp18_u16_st_zero, BPF_ST_MEM(BPF_H, BPF_REG_FP, -18, 0))
+	: __clobber_all);
+}
+
 char _license[] SEC("license") = "GPL";
-- 
2.53.0



