Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C32A425CC4;
	Tue, 31 Mar 2026 16:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976236; cv=none; b=jnr7VeMqC5Wc7MxLEi4rtJ+wQY5QLJJIcB2E5vkiy14rAQq8KUIbmjfyL1xNclwsRJA/oeu4hIW//8QswoUWTfd+D4eiX5ATvLxFEwYcbF1xgbo2fbHLUqnkhVO12xBPFlnFkZ5sIT2HsMDzomG715JoFQ+qCIwin51GlaSN6G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976236; c=relaxed/simple;
	bh=vLep7z2yQDSMIHlWhP/siLdFMqGk5aw6Mv4WTQ/TWUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJZGGjMFrZudQPR10lpVqfzL3LoCdKJ9/ZNy49Lg47oMmqmn5RiMRgp4PPTvkSMfIQzQUo0GbCG7nzeOaK+DwaSiL02hLQGNHscywpb67vfAyjH0oXDbGFUFDljC2DoRUVvgw/TiUhE3ekMyZIVez84DduaoLJ381Z2rtNqXPmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=px9vPxS/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="px9vPxS/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53303C19423;
	Tue, 31 Mar 2026 16:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976235;
	bh=vLep7z2yQDSMIHlWhP/siLdFMqGk5aw6Mv4WTQ/TWUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=px9vPxS/gKzuwXu+IndbhgmmBWCGcLiiulCw2lVGN5RPLx0ma+JlARSJzlmNfy/d4
	 2/FWGCOOWaO3F8aGQbbvldxePFcC4ILNNPMAsusotxyRTsQcD5pNXOBFEhNB9psbM8
	 tswYjzwGzvvLckj2dl0jz0QKH0MEfTBT/gxQWzM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Jenny Guanni Qu <qguanni@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 015/309] bpf: Fix undefined behavior in interpreter sdiv/smod for INT_MIN
Date: Tue, 31 Mar 2026 18:18:38 +0200
Message-ID: <20260331161754.039664351@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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
index a17e42ff89853..8de006d388f67 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1717,6 +1717,12 @@ bool bpf_opcode_in_insntable(u8 code)
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
@@ -1881,8 +1887,8 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
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
@@ -1909,8 +1915,8 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
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
@@ -1936,8 +1942,8 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
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
@@ -1963,8 +1969,8 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
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



