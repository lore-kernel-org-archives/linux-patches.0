Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8910276059;
	Wed, 30 Jul 2025 09:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869272; cv=none; b=b8W/ngjBbMBwBJAU8lRItgIICejKu3l9s5c7b5tMDToPM2JgiFkHsGv6bVqqXj4InQn8VLVKmJYPG+plHYU9hHu9XbysGsAdVLZzFfWYaMlLJY0LnmajhEDHFjppYSb1AS3mskjl8i2OkNvpe/9miKTWdQt5IvVXVlGi8zZZPG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869272; c=relaxed/simple;
	bh=rYFkhXpCM1Sr8i8X/VUQXeZb/HIIv8cvsTqBqrtdlZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0FBdbzy5afQ0uQQhJ9y4sqFLBjyLtP2mHfqAvgkPdPyEXnLaCweBZQ0VBsPwk9dzkzlygvSyA/YvcxYPwOKP92MH2lCG+ATpsVZlzDm5hvO/a2+SICGExAF0dDrWgUX8zLQDlK6Hx+n1DWdH6AZntc0huFd9c/gpchp91S+fGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pnDSCtKP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pnDSCtKP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03217C4CEF5;
	Wed, 30 Jul 2025 09:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869272;
	bh=rYFkhXpCM1Sr8i8X/VUQXeZb/HIIv8cvsTqBqrtdlZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pnDSCtKP/jOJtfb+LvttceNuANPI1924WFoeD2sNdTHZnE2TNiyiTc/kr8o3yI3qj
	 5hSn9j5lyhrwH2Jno7jVfpRRpBXiG4GPaKT01puuG8GrnmMOtk5YlfX3s1HFEzPzAs
	 G+iFG6IVkmglunFmfvIf1DWZuwCHUyt0sx9bEqAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.15 80/92] selftests/bpf: Add tests with stack ptr register in conditional jmp
Date: Wed, 30 Jul 2025 11:36:28 +0200
Message-ID: <20250730093233.847811442@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonghong Song <yonghong.song@linux.dev>

commit 5ffb537e416ee22dbfb3d552102e50da33fec7f6 upstream.

Add two tests:
  - one test has 'rX <op> r10' where rX is not r10, and
  - another test has 'rX <op> rY' where rX and rY are not r10
    but there is an early insn 'rX = r10'.

Without previous verifier change, both tests will fail.

Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250524041340.4046304-1-yonghong.song@linux.dev
[ shung-hsi.yu: contains additional hunks for kernel/bpf/verifier.c that
  should be part of the previous patch in the series, commit
  e2d2115e56c4 "bpf: Do not include stack ptr register in precision
  backtracking bookkeeping", which already incorporated. ]
Link: https://lore.kernel.org/all/9b41f9f5-396f-47e0-9a12-46c52087df6c@linux.dev/
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Verified that newly added test passes in 6.15.y[1] as well as 6.12.y[2]

1: https://github.com/shunghsiyu/libbpf/actions/runs/16561115937/job/46830912531
2: https://github.com/shunghsiyu/libbpf/actions/runs/16561115937/job/46830912533
---
 kernel/bpf/verifier.c                                  |    7 +-
 tools/testing/selftests/bpf/progs/verifier_precision.c |   53 +++++++++++++++++
 2 files changed, 58 insertions(+), 2 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -16441,6 +16441,8 @@ static int check_cond_jmp_op(struct bpf_
 
 		if (src_reg->type == PTR_TO_STACK)
 			insn_flags |= INSN_F_SRC_REG_STACK;
+		if (dst_reg->type == PTR_TO_STACK)
+			insn_flags |= INSN_F_DST_REG_STACK;
 	} else {
 		if (insn->src_reg != BPF_REG_0) {
 			verbose(env, "BPF_JMP/JMP32 uses reserved fields\n");
@@ -16450,10 +16452,11 @@ static int check_cond_jmp_op(struct bpf_
 		memset(src_reg, 0, sizeof(*src_reg));
 		src_reg->type = SCALAR_VALUE;
 		__mark_reg_known(src_reg, insn->imm);
+
+		if (dst_reg->type == PTR_TO_STACK)
+			insn_flags |= INSN_F_DST_REG_STACK;
 	}
 
-	if (dst_reg->type == PTR_TO_STACK)
-		insn_flags |= INSN_F_DST_REG_STACK;
 	if (insn_flags) {
 		err = push_insn_history(env, this_branch, insn_flags, 0);
 		if (err)
--- a/tools/testing/selftests/bpf/progs/verifier_precision.c
+++ b/tools/testing/selftests/bpf/progs/verifier_precision.c
@@ -179,4 +179,57 @@ __naked int state_loop_first_last_equal(
 	);
 }
 
+__used __naked static void __bpf_cond_op_r10(void)
+{
+	asm volatile (
+	"r2 = 2314885393468386424 ll;"
+	"goto +0;"
+	"if r2 <= r10 goto +3;"
+	"if r1 >= -1835016 goto +0;"
+	"if r2 <= 8 goto +0;"
+	"if r3 <= 0 goto +0;"
+	"exit;"
+	::: __clobber_all);
+}
+
+SEC("?raw_tp")
+__success __log_level(2)
+__msg("8: (bd) if r2 <= r10 goto pc+3")
+__msg("9: (35) if r1 >= 0xffe3fff8 goto pc+0")
+__msg("10: (b5) if r2 <= 0x8 goto pc+0")
+__msg("mark_precise: frame1: last_idx 10 first_idx 0 subseq_idx -1")
+__msg("mark_precise: frame1: regs=r2 stack= before 9: (35) if r1 >= 0xffe3fff8 goto pc+0")
+__msg("mark_precise: frame1: regs=r2 stack= before 8: (bd) if r2 <= r10 goto pc+3")
+__msg("mark_precise: frame1: regs=r2 stack= before 7: (05) goto pc+0")
+__naked void bpf_cond_op_r10(void)
+{
+	asm volatile (
+	"r3 = 0 ll;"
+	"call __bpf_cond_op_r10;"
+	"r0 = 0;"
+	"exit;"
+	::: __clobber_all);
+}
+
+SEC("?raw_tp")
+__success __log_level(2)
+__msg("3: (bf) r3 = r10")
+__msg("4: (bd) if r3 <= r2 goto pc+1")
+__msg("5: (b5) if r2 <= 0x8 goto pc+2")
+__msg("mark_precise: frame0: last_idx 5 first_idx 0 subseq_idx -1")
+__msg("mark_precise: frame0: regs=r2 stack= before 4: (bd) if r3 <= r2 goto pc+1")
+__msg("mark_precise: frame0: regs=r2 stack= before 3: (bf) r3 = r10")
+__naked void bpf_cond_op_not_r10(void)
+{
+	asm volatile (
+	"r0 = 0;"
+	"r2 = 2314885393468386424 ll;"
+	"r3 = r10;"
+	"if r3 <= r2 goto +1;"
+	"if r2 <= 8 goto +2;"
+	"r0 = 2 ll;"
+	"exit;"
+	::: __clobber_all);
+}
+
 char _license[] SEC("license") = "GPL";


