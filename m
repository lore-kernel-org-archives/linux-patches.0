Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0068E321F20;
	Mon, 18 Aug 2025 13:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522983; cv=none; b=n/wBoufdGT3SsWvPRkXOhJXunsR84WrBQSklJWHuHK/9QqUMTwInp57gkpjUUUqJqf0N+NyoqfW2puo1KGlwBY0Yw+LNS54Zk6+6VksKTNwaRX75AzNVSVC8SB+cK0drL/TuPiox3yrqEcjVCZ/CfaXLH3AOujF5Dii8GexJDic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522983; c=relaxed/simple;
	bh=98EBs2zcM3QzgbFmDaIjqQs+lAWqNcT2ZJ83DlecipU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmJacgNiP7UNuiWm9vZkyynKObZGvwZ08P0Hu8jp6cNnD6GRJIBGpGiCOjx4Cp8+Hn1Rz0cfrwMG1TBG7g/nE/QnuUP5JcJnBIMw4oV6J11ZT6SSufYsFzD6RWMxJq3/nES6eFrE8Ojayzp9hAXCTYByFPHqZU5MlWYPg5dJ2Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H+1uw4I1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H+1uw4I1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77EAAC4CEEB;
	Mon, 18 Aug 2025 13:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522982;
	bh=98EBs2zcM3QzgbFmDaIjqQs+lAWqNcT2ZJ83DlecipU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H+1uw4I1C+CazoBUTWU+l5r1Pw+GO1iWqqpk1LQd0VliWibhd1QDdrzmIdoMhJ5Re
	 HXSc3ahUQroVGyc0i+dcycwhEwSOU3jWgrJtNIcrvoTi95wXJP3Icz7DgsFDYoK/pp
	 DML3yGV0VgsE29SubBPocrBofympHO/svXfIsHtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hengqi Chen <hengqi.chen@gmail.com>,
	Haoran Jiang <jianghaoran@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.15 034/515] LoongArch: BPF: Fix jump offset calculation in tailcall
Date: Mon, 18 Aug 2025 14:40:20 +0200
Message-ID: <20250818124459.761701689@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

From: Haoran Jiang <jianghaoran@kylinos.cn>

commit cd39d9e6b7e4c58fa77783e7aedf7ada51d02ea3 upstream.

The extra pass of bpf_int_jit_compile() skips JIT context initialization
which essentially skips offset calculation leaving out_offset = -1, so
the jmp_offset in emit_bpf_tail_call is calculated by

"#define jmp_offset (out_offset - (cur_offset))"

is a negative number, which is wrong. The final generated assembly are
as follow.

54:	bgeu        	$a2, $t1, -8	    # 0x0000004c
58:	addi.d      	$a6, $s5, -1
5c:	bltz        	$a6, -16	    # 0x0000004c
60:	alsl.d      	$t2, $a2, $a1, 0x3
64:	ld.d        	$t2, $t2, 264
68:	beq         	$t2, $zero, -28	    # 0x0000004c

Before apply this patch, the follow test case will reveal soft lock issues.

cd tools/testing/selftests/bpf/
./test_progs --allow=tailcalls/tailcall_bpf2bpf_1

dmesg:
watchdog: BUG: soft lockup - CPU#2 stuck for 26s! [test_progs:25056]

Cc: stable@vger.kernel.org
Fixes: 5dc615520c4d ("LoongArch: Add BPF JIT support")
Reviewed-by: Hengqi Chen <hengqi.chen@gmail.com>
Signed-off-by: Haoran Jiang <jianghaoran@kylinos.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/net/bpf_jit.c |   21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -208,11 +208,9 @@ bool bpf_jit_supports_far_kfunc_call(voi
 	return true;
 }
 
-/* initialized on the first pass of build_body() */
-static int out_offset = -1;
-static int emit_bpf_tail_call(struct jit_ctx *ctx)
+static int emit_bpf_tail_call(struct jit_ctx *ctx, int insn)
 {
-	int off;
+	int off, tc_ninsn = 0;
 	u8 tcc = tail_call_reg(ctx);
 	u8 a1 = LOONGARCH_GPR_A1;
 	u8 a2 = LOONGARCH_GPR_A2;
@@ -222,7 +220,7 @@ static int emit_bpf_tail_call(struct jit
 	const int idx0 = ctx->idx;
 
 #define cur_offset (ctx->idx - idx0)
-#define jmp_offset (out_offset - (cur_offset))
+#define jmp_offset (tc_ninsn - (cur_offset))
 
 	/*
 	 * a0: &ctx
@@ -232,6 +230,7 @@ static int emit_bpf_tail_call(struct jit
 	 * if (index >= array->map.max_entries)
 	 *	 goto out;
 	 */
+	tc_ninsn = insn ? ctx->offset[insn+1] - ctx->offset[insn] : ctx->offset[0];
 	off = offsetof(struct bpf_array, map.max_entries);
 	emit_insn(ctx, ldwu, t1, a1, off);
 	/* bgeu $a2, $t1, jmp_offset */
@@ -263,15 +262,6 @@ static int emit_bpf_tail_call(struct jit
 	emit_insn(ctx, ldd, t3, t2, off);
 	__build_epilogue(ctx, true);
 
-	/* out: */
-	if (out_offset == -1)
-		out_offset = cur_offset;
-	if (cur_offset != out_offset) {
-		pr_err_once("tail_call out_offset = %d, expected %d!\n",
-			    cur_offset, out_offset);
-		return -1;
-	}
-
 	return 0;
 
 toofar:
@@ -916,7 +906,7 @@ static int build_insn(const struct bpf_i
 	/* tail call */
 	case BPF_JMP | BPF_TAIL_CALL:
 		mark_tail_call(ctx);
-		if (emit_bpf_tail_call(ctx) < 0)
+		if (emit_bpf_tail_call(ctx, i) < 0)
 			return -EINVAL;
 		break;
 
@@ -1342,7 +1332,6 @@ out:
 	if (tmp_blinded)
 		bpf_jit_prog_release_other(prog, prog == orig_prog ? tmp : orig_prog);
 
-	out_offset = -1;
 
 	return prog;
 


