Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568C871742;
	Mon,  8 Apr 2024 13:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581463; cv=none; b=flMb+erHEUZuSmqcydB04bUUtk6nyAe66xBviGM7M+vx28YNhh0BHIXPxCbIFMZE/etz0r4IQMbb3L9wld35B0Zh4HYADRaruWAHqYqwPCAEcMIBEpSJj3x2+a7VBN9ySpNkNsD7xfEw5Q7JXGZ41FDA4rI3C6noA1pFKVViqE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581463; c=relaxed/simple;
	bh=ASRjNpvftRSE5otoamRla/xuPeq4dz/2hbG4UYE5FUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Es4ZO70nmF+D2WqU+R1j03d57N2P5P1i98fPgL49K56T2QtXprjyFXJBqT5O8T9UgcqhshIRTAaHOGWt0l/dDJe4CBRqG33M65US0TW2m9RVR1wLP4bKcbbR7v7dPBqDTd+vcZQW0N3U2wm/LfpRj+jVW8aIRvbp7lVBmiGs9Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RPK2+g4r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RPK2+g4r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C92C433C7;
	Mon,  8 Apr 2024 13:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581463;
	bh=ASRjNpvftRSE5otoamRla/xuPeq4dz/2hbG4UYE5FUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RPK2+g4rzOQoGIq+cfJblWlThHTt1Vqp314j3px/qBFQQE5TDMVqjG6w3qvMgnvcD
	 RCjpjl8gx3oIK4RvTd9SWaZ7qeN6kcZIbSk3wQg2LILNXLAT2mjbsatMtyl616+Pdi
	 SUHrIuN1juRfUJqxJwl9W9ySmsjBXdLwc9K3JQ5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay12@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/252] bpf, arm64: fix bug in BPF_LDX_MEMSX
Date: Mon,  8 Apr 2024 14:55:04 +0200
Message-ID: <20240408125306.814844262@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Puranjay Mohan <puranjay12@gmail.com>

[ Upstream commit 114b5b3b4bde7358624437be2f12cde1b265224e ]

A64_LDRSW() takes three registers: Xt, Xn, Xm as arguments and it loads
and sign extends the value at address Xn + Xm into register Xt.

Currently, the offset is being directly used in place of the tmp
register which has the offset already loaded by the last emitted
instruction.

This will cause JIT failures. The easiest way to reproduce this is to
test the following code through test_bpf module:

{
	"BPF_LDX_MEMSX | BPF_W",
	.u.insns_int = {
		BPF_LD_IMM64(R1, 0x00000000deadbeefULL),
		BPF_LD_IMM64(R2, 0xffffffffdeadbeefULL),
		BPF_STX_MEM(BPF_DW, R10, R1, -7),
		BPF_LDX_MEMSX(BPF_W, R0, R10, -7),
		BPF_JMP_REG(BPF_JNE, R0, R2, 1),
		BPF_ALU64_IMM(BPF_MOV, R0, 0),
		BPF_EXIT_INSN(),
	},
	INTERNAL,
	{ },
	{ { 0, 0 } },
	.stack_depth = 7,
},

We need to use the offset as -7 to trigger this code path, there could
be other valid ways to trigger this from proper BPF programs as well.

This code is rejected by the JIT because -7 is passed to A64_LDRSW() but
it expects a valid register (0 - 31).

 roott@pjy:~# modprobe test_bpf test_name="BPF_LDX_MEMSX | BPF_W"
 [11300.490371] test_bpf: test_bpf: set 'test_bpf' as the default test_suite.
 [11300.491750] test_bpf: #345 BPF_LDX_MEMSX | BPF_W
 [11300.493179] aarch64_insn_encode_register: unknown register encoding -7
 [11300.494133] aarch64_insn_encode_register: unknown register encoding -7
 [11300.495292] FAIL to select_runtime err=-524
 [11300.496804] test_bpf: Summary: 0 PASSED, 1 FAILED, [0/0 JIT'ed]
 modprobe: ERROR: could not insert 'test_bpf': Invalid argument

Applying this patch fixes the issue.

 root@pjy:~# modprobe test_bpf test_name="BPF_LDX_MEMSX | BPF_W"
 [  292.837436] test_bpf: test_bpf: set 'test_bpf' as the default test_suite.
 [  292.839416] test_bpf: #345 BPF_LDX_MEMSX | BPF_W jited:1 156 PASS
 [  292.844794] test_bpf: Summary: 1 PASSED, 0 FAILED, [1/1 JIT'ed]

Fixes: cc88f540da52 ("bpf, arm64: Support sign-extension load instructions")
Signed-off-by: Puranjay Mohan <puranjay12@gmail.com>
Message-ID: <20240312235917.103626-1-puranjay12@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/net/bpf_jit_comp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 150d1c6543f7f..5fe4d8b3fdc89 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -1189,7 +1189,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 			} else {
 				emit_a64_mov_i(1, tmp, off, ctx);
 				if (sign_extend)
-					emit(A64_LDRSW(dst, src_adj, off_adj), ctx);
+					emit(A64_LDRSW(dst, src, tmp), ctx);
 				else
 					emit(A64_LDR32(dst, src, tmp), ctx);
 			}
-- 
2.43.0



