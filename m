Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD4834AAE8;
	Tue, 26 Aug 2025 13:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214123; cv=none; b=Q7wGLUsDz9POEgQgiJ5WH+ajdXO4CsYoBnwrzCBykoc1APfXTXx7uDaLL6uaACar03AGr5vCkon7bRjU/mTftGJ8pZEDA8P/kzqR5Q1tncYGjhQArLoGGs1NCF5n0vE4C0/hIJM+RjJpysoo9Zhfx/G6l07p3Fogs5BjkF+L56w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214123; c=relaxed/simple;
	bh=uZUG65esQhKKnYsQ+8tGwQ3PvYrtm9YMsRTu+Bcppz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YlSgpwMCeBmgFKzpgsSgBF4s5MhzfV4WJtuC8eJJVY3W1DMFFsPTiRh36NoN9h/YQfwMKneYxJ5VUdyErnwZjK9S4N8XaGydlFUe/1/yWsePQmFmYFzULwzH2fWX4WiszQ1kv+OCIEv9yAyEiSA3svpZ6mIUlgjEZwARbYVuEfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CQp2LknL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CQp2LknL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE61C4CEF1;
	Tue, 26 Aug 2025 13:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214123;
	bh=uZUG65esQhKKnYsQ+8tGwQ3PvYrtm9YMsRTu+Bcppz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CQp2LknLRyd/x/xob7kJFtwVT0d2vo9YLUYJ2Qo+LaTLwmRtTawoeSmAq1ZT6I33T
	 cnK+RYd1aE+A/w42cUeJjArPiK8lUfa907HSXVB/XscLQgcimmgJEVOovLtFQnn/yt
	 xtLWeBtPF2SY0hPo5aBJ7Cl7JMyffBW7yXN6P6GE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hengqi Chen <hengqi.chen@gmail.com>,
	Haoran Jiang <jianghaoran@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.1 020/482] LoongArch: BPF: Fix jump offset calculation in tailcall
Date: Tue, 26 Aug 2025 13:04:33 +0200
Message-ID: <20250826110931.288673442@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -201,11 +201,9 @@ bool bpf_jit_supports_kfunc_call(void)
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
@@ -215,7 +213,7 @@ static int emit_bpf_tail_call(struct jit
 	const int idx0 = ctx->idx;
 
 #define cur_offset (ctx->idx - idx0)
-#define jmp_offset (out_offset - (cur_offset))
+#define jmp_offset (tc_ninsn - (cur_offset))
 
 	/*
 	 * a0: &ctx
@@ -225,6 +223,7 @@ static int emit_bpf_tail_call(struct jit
 	 * if (index >= array->map.max_entries)
 	 *	 goto out;
 	 */
+	tc_ninsn = insn ? ctx->offset[insn+1] - ctx->offset[insn] : ctx->offset[0];
 	off = offsetof(struct bpf_array, map.max_entries);
 	emit_insn(ctx, ldwu, t1, a1, off);
 	/* bgeu $a2, $t1, jmp_offset */
@@ -256,15 +255,6 @@ static int emit_bpf_tail_call(struct jit
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
@@ -789,7 +779,7 @@ static int build_insn(const struct bpf_i
 	/* tail call */
 	case BPF_JMP | BPF_TAIL_CALL:
 		mark_tail_call(ctx);
-		if (emit_bpf_tail_call(ctx) < 0)
+		if (emit_bpf_tail_call(ctx, i) < 0)
 			return -EINVAL;
 		break;
 
@@ -1170,7 +1160,6 @@ out:
 	if (tmp_blinded)
 		bpf_jit_prog_release_other(prog, prog == orig_prog ? tmp : orig_prog);
 
-	out_offset = -1;
 
 	return prog;
 }


