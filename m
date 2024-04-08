Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1ED2DF73;
	Mon,  8 Apr 2024 13:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581606; cv=none; b=kWRFpXF3prVibVFJRyMY4KYWxMfOyJ+5OUNojvQGpKDQjQVRG0kLZ3IpRJPpDBiAnK/lFKsVX6krNrAGBd6IbH3ZBpG5s8zZvBY7ZV9gFrvwKjxiYMjTW51jHTcU1hfVd+ANDlIices0l4PyNzdaKooSYCyQ4B20gHYPAgDYImc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581606; c=relaxed/simple;
	bh=CCDxNZ7Ykk0JYoEAPZ0SGHm8fw9X6PIfCBKk/3fcC1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VzLEQ7G03+4oDciWGqLqZ4l3rvxGEXkVNa+9CzqU4T354ZghGddUikvhKy/8m4tRXgsgXq400FFXHlC+i6DeNgMBZSnDgc+HScUVhX1aZLXx0xA6USwGceCwQRRzWwhFq0Mje9OGywyFxnb5PQFlGUNtRD/o2aqQUFO2QyaYGE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ozy4fubk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ozy4fubk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D34C433F1;
	Mon,  8 Apr 2024 13:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581606;
	bh=CCDxNZ7Ykk0JYoEAPZ0SGHm8fw9X6PIfCBKk/3fcC1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ozy4fubkNliqD9uLHbJ4k6caJHG80E+7IV0+yO+e1YsAk1q7mpavicBa351pvePLa
	 si2XmAd9UJEmG2dsbc/UiO30vj3Zt5krngNd0XKBDaVuhnHZmHA2MXphyT6x01spaF
	 Dck4tkVRDVuvSMMVPqcy8Htgts3/LVlojQd5fAPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay12@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 004/273] bpf, arm64: fix bug in BPF_LDX_MEMSX
Date: Mon,  8 Apr 2024 14:54:39 +0200
Message-ID: <20240408125309.419268184@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 8955da5c47cf7..582c4c2491edc 100644
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



