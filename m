Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9258D1E505;
	Mon, 12 May 2025 18:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073506; cv=none; b=E7w4vmZUx+UJ1p4fUAVoQTUQaWI6oOXtWn7eW+yRLuMVVnTsy0fNy25x9RYWe5pqwBKOKxfyisUCuLg214DMTRysJA47A/8bjvvRECKcw4xYJwiN6d99Pdoo9/Qm0XWFdHGXaohGymw+jXv6F4u37AM8UznHNllUyK7Lm07kKQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073506; c=relaxed/simple;
	bh=6cWgP9cJAGeCFlBDqLyUWa28EXK2sehPgBXy5LRGF+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SXw2Bu2Pcl6vD8fmn0rMcyG1tONwIO3WHEjALEp3ur2IzcU3wDTsZj6d0c3FLFkEule77aPaX1U/hrhJ3jUeOJUTDXZfqqfgH2S4Vt3awx/53/Pw5qN0Q5lLzPPjmm1XD9nabgMlaQKQ1eCAZaKi4XXSH6eBOL8OG2m1RKpKl1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I39ZlO5l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I39ZlO5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A3AC4CEE7;
	Mon, 12 May 2025 18:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073506;
	bh=6cWgP9cJAGeCFlBDqLyUWa28EXK2sehPgBXy5LRGF+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I39ZlO5leKhlUp87p+RRDm8q0CX7TNKd0b4TJeVH95SNJnYg1x0kPHfFCTm0XJXsw
	 iQcbLeu/oMOGTxn6GK4dMDO+KHnPjJAzLfbOdqI7fz6xME1dU3rHfkS8tq9AVEY9on
	 P39iUXXpo7M9RdfMZrXD3YYX4WbvMVqF6+RKMoMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexandre Chartre <alexandre.chartre@oracle.com>
Subject: [PATCH 6.6 098/113] x86/bpf: Call branch history clearing sequence on exit
Date: Mon, 12 May 2025 19:46:27 +0200
Message-ID: <20250512172031.664924933@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 arch/x86/net/bpf_jit_comp.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1072,6 +1072,30 @@ static void emit_shiftx(u8 **pprog, u32
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
+		ip += x86_call_depth_emit_accounting(&prog, func);
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
@@ -1945,6 +1969,15 @@ emit_jmp:
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


