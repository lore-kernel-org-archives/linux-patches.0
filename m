Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA611A08CA;
	Mon, 12 May 2025 17:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072560; cv=none; b=r2bJgAvefeXaE3SYUyEat0u8CCAbEy+3z2FviXaJjjVYWGtX+xJthXa87sD3UMB7dTnDeXxAulCSWNxgLP8Ezhv9gxBgLezcywi/6FGhYz1eHJlhnDCUGCGRkIxxh022AXc0DUMrOVjGGew00B3ZL/SnYlKuWycQ+ESMfjDd5xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072560; c=relaxed/simple;
	bh=IzDeBHaMTHhWpiBN6+jsMDhQVkDZ6z+LhNfTC821QCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQKL8bS8mB6qBWDCsc4JFrDJ+WOs6OsQ163RqwImTY7UwjoUsL0QZKy0ye7KLcfram0P9SntHt2SK2VCnzEXGbJTuuaF2y3cX5oHvAIDsDGUgF3/hp2n2Sdn5q0atBcNMCobFoyj/XLEGx0rbEMbi0udatCxfYTk3rVKxn4IGmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TJYGHyaY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TJYGHyaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C8BC4CEE7;
	Mon, 12 May 2025 17:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072560;
	bh=IzDeBHaMTHhWpiBN6+jsMDhQVkDZ6z+LhNfTC821QCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TJYGHyaYT+7btZDqM0HA/+9AO7FPEMM1EOK4cUi75Agb3vukDiWDWecRvwGs8AZpA
	 juq+VhC/m4JjAK2QYB2EnPF55pZAvRkTxdIBFtOSP2O94ceOY7odtdZj8C/rf2y71f
	 FTPlJPB5jWRDamgMsB4O/U9V+Q813DJOoTXCF7N0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexandre Chartre <alexandre.chartre@oracle.com>
Subject: [PATCH 6.1 78/92] x86/bpf: Call branch history clearing sequence on exit
Date: Mon, 12 May 2025 19:45:53 +0200
Message-ID: <20250512172026.301040205@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
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
 arch/x86/net/bpf_jit_comp.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -947,6 +947,29 @@ static void emit_nops(u8 **pprog, int le
 #define RESTORE_TAIL_CALL_CNT(stack)				\
 	EMIT3_off32(0x48, 0x8B, 0x85, -round_up(stack, 8) - 8)
 
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
@@ -1760,6 +1783,15 @@ emit_jmp:
 			seen_exit = true;
 			/* Update cleanup_addr */
 			ctx->cleanup_addr = proglen;
+
+			if (bpf_prog_was_classic(bpf_prog) &&
+			    !capable(CAP_SYS_ADMIN)) {
+				u8 *ip = image + addrs[i - 1];
+
+				if (emit_spectre_bhb_barrier(&prog, ip, bpf_prog))
+					return -EINVAL;
+			}
+
 			pop_callee_regs(&prog, callee_regs_used);
 			EMIT1(0xC9);         /* leave */
 			emit_return(&prog, image + addrs[i - 1] + (prog - temp));


