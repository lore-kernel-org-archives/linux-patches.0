Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560033FFADF;
	Tue, 31 Mar 2026 16:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974325; cv=none; b=V+pjokTXe2QRTLq498M4CgRQD5QgcN3uIXSzigXgyLgYfmhfNDYFJ+wK5ESyPyZgK5daYZ1QXqnF+VZ9FZeuORaTbNChHWUkgAOc3pQTcdra6CUkyTk6quU51ji+kg1QbLusA9ksIXYk5PhPrpanDe1DigQhmwy7fwOmyVTkFBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974325; c=relaxed/simple;
	bh=6V4cZYRaLalD4PxWuYyIoBx05x+icDI4fUZInZ/zclo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RkkW1c6OlwYhoazbrOT6jT+/UdPl480o9RRb4s+6x7Sn+6zLuJPNk+HcH2t4AyB6SFNq7mmU2A4V5ClHgQFzxFEW5ghI5ebpmOqsZnCkN7qVeX+uIniFZ/zxBEEjrEqsE/EqfwjaTLEblg3RRNxjCxcBiwGm1XKTS/pUNoTxzlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k06fio4Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k06fio4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB827C19423;
	Tue, 31 Mar 2026 16:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974325;
	bh=6V4cZYRaLalD4PxWuYyIoBx05x+icDI4fUZInZ/zclo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k06fio4YgzJHqinWeAqC/5ghIyWqwyw/LNihQcTHijUM12vaTD+nU+Quj5b9mXJJB
	 fHDUJqF37BUhrmLMVcRjyc9RmqyTqT4XoFluGdyythpVf82YG3ho909GADtJFyNZ8I
	 A65VceZf02MP9Z/7QUmT/FQRIL3/RQrlsgJ+FZKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Jenny Guanni Qu <qguanni@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/175] bpf: Fix undefined behavior in interpreter sdiv/smod for INT_MIN
Date: Tue, 31 Mar 2026 18:19:53 +0200
Message-ID: <20260331161730.124951594@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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
index a343248c35ded..3011add7c4a88 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1667,6 +1667,12 @@ bool bpf_opcode_in_insntable(u8 code)
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
@@ -1831,8 +1837,8 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
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
@@ -1859,8 +1865,8 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
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
@@ -1886,8 +1892,8 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
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
@@ -1913,8 +1919,8 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
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



