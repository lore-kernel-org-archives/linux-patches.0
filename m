Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFFE2D1F40;
	Tue, 31 Mar 2026 16:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975588; cv=none; b=SRU2a3CkQwwgPiTRbBA3CUdZP1XXoTprLBT7NzqVY3c/AbQegNPRXzl0btjWh6uWp2TUn02DCQgQKsk+S/fdp7xnvxIe2zGw+dR1x0eo3ManMqhu3I9PCd+6SzEut7JKGWBl/Q2oa8yqLGvvEYza6b7gCwBGLG/VRLlGSKI4IZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975588; c=relaxed/simple;
	bh=0el4LM025nn2evVJRDYoTJoRW9kB0ZHomt8xNBgfMxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7BsbwWFGO8TvgFeHWMLLQtFruEv4qj6Lp1eYkmlcCv9oy+Mwof0uetbhekGHU78GeNoM7Kd53zZs8tu9ODVHfUEjFWKBT1LbDAkvYAYUUN0isapSLJG9zfvT4Meh3VQpsKKNiXfuyLlnhDj49eOkvqn2kk56lpdhqMOlamISnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IbAi3+in; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IbAi3+in"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 961CDC19423;
	Tue, 31 Mar 2026 16:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975587;
	bh=0el4LM025nn2evVJRDYoTJoRW9kB0ZHomt8xNBgfMxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IbAi3+intkpSzbk556iuCVdyoX+vNIvewj+wlYE0K1gz94NZ2MenZg2B7NZF7PK3Z
	 5ZuytHBpcibk24+W/Jh+Lc/d1mA1VsQMyx++mJOV+IdYLn9Ougw02l2ew6/Rx1llGE
	 N6J4Bur75IPBSD6YYvqX38SDH/Qztyq0F+ri4mFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Jenny Guanni Qu <qguanni@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 010/244] bpf: Fix undefined behavior in interpreter sdiv/smod for INT_MIN
Date: Tue, 31 Mar 2026 18:19:20 +0200
Message-ID: <20260331161742.085567930@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jenny Guanni Qu <qguanni@gmail.com>

[ Upstream commit c77b30bd1dcb61f66c640ff7d2757816210c7cb0 ]

The BPF interpreter's signed 32-bit division and modulo handlers use
the kernel abs() macro on s32 operands. The abs() macro documentation
(include/linux/math.h) explicitly states the result is undefined when
the input is the type minimum. When DST contains S32_MIN (0x80000000),
abs((s32)DST) triggers undefined behavior and returns S32_MIN unchanged
on arm64/x86. This value is then sign-extended to u64 as
0xFFFFFFFF80000000, causing do_div() to compute the wrong result.

The verifier's abstract interpretation (scalar32_min_max_sdiv) computes
the mathematically correct result for range tracking, creating a
verifier/interpreter mismatch that can be exploited for out-of-bounds
map value access.

Introduce abs_s32() which handles S32_MIN correctly by casting to u32
before negating, avoiding signed overflow entirely. Replace all 8
abs((s32)...) call sites in the interpreter's sdiv32/smod32 handlers.

s32 is the only affected case -- the s64 division/modulo handlers do
not use abs().

Fixes: ec0e2da95f72 ("bpf: Support new signed div/mod instructions.")
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Acked-by: Mykyta Yatsenko <yatsenko@meta.com>
Signed-off-by: Jenny Guanni Qu <qguanni@gmail.com>
Link: https://lore.kernel.org/r/20260311011116.2108005-2-qguanni@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/core.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index fbd5d292d8bf9..b58833e99969a 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1735,6 +1735,12 @@ bool bpf_opcode_in_insntable(u8 code)
 }
 
 #ifndef CONFIG_BPF_JIT_ALWAYS_ON
+/* Absolute value of s32 without undefined behavior for S32_MIN */
+static u32 abs_s32(s32 x)
+{
+	return x >= 0 ? (u32)x : -(u32)x;
+}
+
 /**
  *	___bpf_prog_run - run eBPF program on a given context
  *	@regs: is the array of MAX_BPF_EXT_REG eBPF pseudo-registers
@@ -1899,8 +1905,8 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
 			DST = do_div(AX, (u32) SRC);
 			break;
 		case 1:
-			AX = abs((s32)DST);
-			AX = do_div(AX, abs((s32)SRC));
+			AX = abs_s32((s32)DST);
+			AX = do_div(AX, abs_s32((s32)SRC));
 			if ((s32)DST < 0)
 				DST = (u32)-AX;
 			else
@@ -1927,8 +1933,8 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
 			DST = do_div(AX, (u32) IMM);
 			break;
 		case 1:
-			AX = abs((s32)DST);
-			AX = do_div(AX, abs((s32)IMM));
+			AX = abs_s32((s32)DST);
+			AX = do_div(AX, abs_s32((s32)IMM));
 			if ((s32)DST < 0)
 				DST = (u32)-AX;
 			else
@@ -1954,8 +1960,8 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
 			DST = (u32) AX;
 			break;
 		case 1:
-			AX = abs((s32)DST);
-			do_div(AX, abs((s32)SRC));
+			AX = abs_s32((s32)DST);
+			do_div(AX, abs_s32((s32)SRC));
 			if (((s32)DST < 0) == ((s32)SRC < 0))
 				DST = (u32)AX;
 			else
@@ -1981,8 +1987,8 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
 			DST = (u32) AX;
 			break;
 		case 1:
-			AX = abs((s32)DST);
-			do_div(AX, abs((s32)IMM));
+			AX = abs_s32((s32)DST);
+			do_div(AX, abs_s32((s32)IMM));
 			if (((s32)DST < 0) == ((s32)IMM < 0))
 				DST = (u32)AX;
 			else
-- 
2.51.0



