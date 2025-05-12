Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B861DC1A7;
	Mon, 12 May 2025 17:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071136; cv=none; b=lOgAMrYeNwbQRqUSB+LxuGpxlwfVwGFWzi7Ublerr9MuU77xNTn0LCxyYF8pkJeBNyXRjDMwJwk3dcHHMRCWzsZmX4sp+MxXFLfOfQM/sd5HxvUjfVj8wP3EREyUEsvWV15YgRI+ZUx5eqWHGV3wcDeZGwpZuNPqi7sVGTz6wus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071136; c=relaxed/simple;
	bh=rDJZr0wIIXOBDAnecFRQ7Ka75sSQk2au9QfOywJTNTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kkJwfENh7tfn2fzOyXC68tiQtJQRWLVlozTIXtwoR9YBvpLqUUCiofrjVhyATmDu50+cUSKObnwJgS6/QqpKbZ4OfiyjQC5zS4P4cL/ZQTbhStWwiN5DHoaszXq/VvZ7db8ZwtqDFjCkuVII2Lg+gimFTGVRELd9z0Ld5loZv/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E2gYocqI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E2gYocqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB974C4CEE7;
	Mon, 12 May 2025 17:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071136;
	bh=rDJZr0wIIXOBDAnecFRQ7Ka75sSQk2au9QfOywJTNTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E2gYocqIn1xWD76NrR84IHEJt4U0kHM9DNB52xEsOVR3CiCNgZkjeS72xYNKIdNlj
	 lw7zYaIRfV7oCrFQ1IpVib8U+smoWXxMxDPKFPX9sbJesk8of9DR7rhRrInQvcXrIw
	 MEZ0++kUiVGg0+xgYQZr9AXEI6yhO/BWeDAgDz/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexandre Chartre <alexandre.chartre@oracle.com>
Subject: [PATCH 5.15 52/54] x86/bpf: Call branch history clearing sequence on exit
Date: Mon, 12 May 2025 19:30:04 +0200
Message-ID: <20250512172017.737057329@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
References: <20250512172015.643809034@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -932,6 +932,29 @@ static void emit_nops(u8 **pprog, int le
 
 #define INSN_SZ_DIFF (((addrs[i] - addrs[i - 1]) - (prog - temp)))
 
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
 static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 		  int oldproglen, struct jit_context *ctx, bool jmp_padding)
 {
@@ -1737,6 +1760,15 @@ emit_jmp:
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


