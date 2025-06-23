Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C3E4C74;
	Mon, 23 Jun 2025 22:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716184; cv=none; b=rVAQRmYKrPuhNl1bf9oZtIlC9lma8zXD3XYu72vGV0tsGw8ufF7WnHvlHugxv1vfHTkhJJGeLeLA2fnmBBzu+wIVUexOu8fafPBm5Xiw42vgp4d/O8zmOqG0JUFj1KotLC5RX/SaOEqhKs0jT9EjvzBnFuJZ/+k1oTPX+rzEOKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716184; c=relaxed/simple;
	bh=+4fwdKmN8JiVBkSkXH8EhxsUVLKNCNVhQIcdRWD9+z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OKrknff4t4pPAtoshV6QtMy4NkQXcikOxhVyzhFe/lF/ZODc7o9pwfub0va9GxXs9Q7cZGKCoK2xn86zLRm6yRLX6N25saLjgqQ6R0udkb0S9aOjNhwE3Qw7/X+1QiGsardUKcLi4r6/fJxqQUtgz+Dw523Lblm8H5DEloPTZOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CeI7aq7Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CeI7aq7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8910DC4CEEA;
	Mon, 23 Jun 2025 22:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716183;
	bh=+4fwdKmN8JiVBkSkXH8EhxsUVLKNCNVhQIcdRWD9+z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CeI7aq7YU5x30s+6LOBZeiPR+N+6eouZnx8OhBojpO8wwl0YJ3l1auwNo1RsULpzI
	 DST8gWK7cN8naFU7sbAMj3XBQMspgdtEdWfOBUb8SL7Ulqi6c1JDLZso7bdWiYFDoI
	 sB4K5q2q1SyJbjXRZ5a5gSJIRjs420j55PoqaJFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Wei <weiwei.danny@bytedance.com>,
	Aaron Lu <ziqianlu@bytedance.com>
Subject: [PATCH 5.10 353/355] Revert "bpf: allow precision tracking for programs with subprogs"
Date: Mon, 23 Jun 2025 15:09:14 +0200
Message-ID: <20250623130637.331791675@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Lu <ziqianlu@bytedance.com>

This reverts commit 2474ec58b96d8a028b046beabdf49f5475eefcf8 which is
commit be2ef8161572ec1973124ebc50f56dafc2925e07 upstream.

The backport of bpf precision tracking related changes has caused bpf
verifier to panic while loading some certain bpf prog so revert them.

Link: https://lkml.kernel.org/r/20250605070921.GA3795@bytedance/
Reported-by: Wei Wei <weiwei.danny@bytedance.com>
Signed-off-by: Aaron Lu <ziqianlu@bytedance.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   35 +----------------------------------
 1 file changed, 1 insertion(+), 34 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1359,7 +1359,7 @@ static void __mark_reg_unknown(const str
 	reg->type = SCALAR_VALUE;
 	reg->var_off = tnum_unknown;
 	reg->frameno = 0;
-	reg->precise = !env->bpf_capable;
+	reg->precise = env->subprog_cnt > 1 || !env->bpf_capable;
 	__mark_reg_unbounded(reg);
 }
 
@@ -2102,42 +2102,12 @@ static int __mark_chain_precision(struct
 		return 0;
 	if (!reg_mask && !stack_mask)
 		return 0;
-
 	for (;;) {
 		DECLARE_BITMAP(mask, 64);
 		u32 history = st->jmp_history_cnt;
 
 		if (env->log.level & BPF_LOG_LEVEL)
 			verbose(env, "last_idx %d first_idx %d\n", last_idx, first_idx);
-
-		if (last_idx < 0) {
-			/* we are at the entry into subprog, which
-			 * is expected for global funcs, but only if
-			 * requested precise registers are R1-R5
-			 * (which are global func's input arguments)
-			 */
-			if (st->curframe == 0 &&
-			    st->frame[0]->subprogno > 0 &&
-			    st->frame[0]->callsite == BPF_MAIN_FUNC &&
-			    stack_mask == 0 && (reg_mask & ~0x3e) == 0) {
-				bitmap_from_u64(mask, reg_mask);
-				for_each_set_bit(i, mask, 32) {
-					reg = &st->frame[0]->regs[i];
-					if (reg->type != SCALAR_VALUE) {
-						reg_mask &= ~(1u << i);
-						continue;
-					}
-					reg->precise = true;
-				}
-				return 0;
-			}
-
-			verbose(env, "BUG backtracing func entry subprog %d reg_mask %x stack_mask %llx\n",
-				st->frame[0]->subprogno, reg_mask, stack_mask);
-			WARN_ONCE(1, "verifier backtracking bug");
-			return -EFAULT;
-		}
-
 		for (i = last_idx;;) {
 			if (skip_first) {
 				err = 0;
@@ -11896,9 +11866,6 @@ static int do_check_common(struct bpf_ve
 			0 /* frameno */,
 			subprog);
 
-	state->first_insn_idx = env->subprog_info[subprog].start;
-	state->last_insn_idx = -1;
-
 	regs = state->frame[state->curframe]->regs;
 	if (subprog || env->prog->type == BPF_PROG_TYPE_EXT) {
 		ret = btf_prepare_func_args(env, subprog, regs);


