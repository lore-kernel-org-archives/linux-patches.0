Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819FC2BFC9F;
	Mon, 12 May 2025 18:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073142; cv=none; b=Q8o1fYVNxq9xsbq6KOVyZMVA2pyMFC9wPwkCtPpRh+wg2RXAm1JqcyT/OyWwNmpT8R2bDK7wKFkTo/sqLAsXsr88Bdjs/XEHRvrUlJg0bjW9vLbEscQj2ZW5ZBgMZuNa42SCSrvn7dQolp3OCk+5ccYu2i7Bgb9a5v+2cEX4Lxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073142; c=relaxed/simple;
	bh=c4UwLIaiUrwAeBTn3QmvldHsJE9lNq5b66pkHrWTqVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZOz0TCKIdxRnEVuB5PD8+78RcltL64X65WUvmd0FpZ+Ao37ddmmzW5151UZnnUilwz3oXuHBIB8quByDUv1PWSgv9+I03yLa4Wmw9iANuJ+rV86Dd+zle3pjdbxsEvtW/LJKOidLWKAAoCClZpNbS5fYe0RDhIzjSrAXTEClKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IOJChlEh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IOJChlEh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5F0C4CEE9;
	Mon, 12 May 2025 18:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073142;
	bh=c4UwLIaiUrwAeBTn3QmvldHsJE9lNq5b66pkHrWTqVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IOJChlEhvS7coRu0wb7ag1Ob+c0bSjx+BjinQGzp/bK01vnM+NJNb7zxdj8Di/RDD
	 wLLm9zBc3YV8OIHXNBFI9091WmQMeJ9wiXsEzQZrfxtOp9apn6wpYNnxfJPE89YSgF
	 GnkXf6k3N1pOO/YJFHlbOkHV5Wj3lMiqr34dM4Ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexandre Chartre <alexandre.chartre@oracle.com>
Subject: [PATCH 6.12 168/184] x86/bpf: Call branch history clearing sequence on exit
Date: Mon, 12 May 2025 19:46:09 +0200
Message-ID: <20250512172048.654310778@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Sneddon <daniel.sneddon@linux.intel.com>

commit d4e89d212d401672e9cdfe825d947ee3a9fbe3f5 upstream.

Classic BPF programs have been identified as potential vectors for
intra-mode Branch Target Injection (BTI) attacks. Classic BPF programs can
be run by unprivileged users. They allow unprivileged code to execute
inside the kernel. Attackers can use unprivileged cBPF to craft branch
history in kernel mode that can influence the target of indirect branches.

Introduce a branch history buffer (BHB) clearing sequence during the JIT
compilation of classic BPF programs. The clearing sequence is the same as
is used in previous mitigations to protect syscalls. Since eBPF programs
already have their own mitigations in place, only insert the call on
classic programs that aren't run by privileged users.

Signed-off-by: Daniel Sneddon <daniel.sneddon@linux.intel.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/net/bpf_jit_comp.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1412,6 +1412,30 @@ static void emit_shiftx(u8 **pprog, u32
 #define LOAD_TAIL_CALL_CNT_PTR(stack)				\
 	__LOAD_TCC_PTR(BPF_TAIL_CALL_CNT_PTR_STACK_OFF(stack))
 
+static int emit_spectre_bhb_barrier(u8 **pprog, u8 *ip,
+				    struct bpf_prog *bpf_prog)
+{
+	u8 *prog = *pprog;
+	u8 *func;
+
+	if (cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_LOOP)) {
+		/* The clearing sequence clobbers eax and ecx. */
+		EMIT1(0x50); /* push rax */
+		EMIT1(0x51); /* push rcx */
+		ip += 2;
+
+		func = (u8 *)clear_bhb_loop;
+		ip += x86_call_depth_emit_accounting(&prog, func, ip);
+
+		if (emit_call(&prog, func, ip))
+			return -EINVAL;
+		EMIT1(0x59); /* pop rcx */
+		EMIT1(0x58); /* pop rax */
+	}
+	*pprog = prog;
+	return 0;
+}
+
 static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image, u8 *rw_image,
 		  int oldproglen, struct jit_context *ctx, bool jmp_padding)
 {
@@ -2402,6 +2426,13 @@ emit_jmp:
 			seen_exit = true;
 			/* Update cleanup_addr */
 			ctx->cleanup_addr = proglen;
+			if (bpf_prog_was_classic(bpf_prog) &&
+			    !capable(CAP_SYS_ADMIN)) {
+				u8 *ip = image + addrs[i - 1];
+
+				if (emit_spectre_bhb_barrier(&prog, ip, bpf_prog))
+					return -EINVAL;
+			}
 			if (bpf_prog->aux->exception_boundary) {
 				pop_callee_regs(&prog, all_callee_regs_used);
 				pop_r12(&prog);


