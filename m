Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FD12BDC0E;
	Sat, 12 Sep 2026 07:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197964; cv=none; b=BgzKQaIDC9dX8UpYa2j3nrUHtiJiXMtErr4mqlLBEo6oxPnokUMj1Fb7xtF3VlOD8BvSY/3Qcy5U8CSs5teRVdki13/TbrJJhTM0PT3LZFZidB2a/OvcYgGjd8JYEUz5N1W+q4f3PfOP4kcTL2dgvXZ7Dhwo0qvvc1NfE0h+sjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197964; c=relaxed/simple;
	bh=bkgBBiJ6Xz96RXiI4kCX6gqE20EeRFcSRbADVwR37Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2zR5tyVcmx1hIyXBGZdH3lvYVBIR2AxNYuGCMZ8C0yC+z/2tMMcg/ObCONzuLm/6dgL7t8SdPsLZO9CeV5pe+VOGK475MbRpOS2wrr/hJScsWcFM1b2zXgL3go3pmVaMsLPFbjTxXlrTv5E/pSF8NneLj7g3lWV8rJIReQqqBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZBQQO06; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZBQQO06"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC131F000FF;
	Sat, 12 Sep 2026 07:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197962;
	bh=VPd1d9kNvsyTEYaOb7K7ymnU1qGrDSiq0oUnsWYeVSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vZBQQO06UnA5cHNq9hdeLRHjnFdKLuc1JIiFH8vl7IxhpVM9EdsrQL2gQxPjLI7pf
	 gQadUOWOFsXElxVGmpeXAa/6nvgRosPh0l+QBhMM0vahLRMaq6T9uiICivS+2LvPab
	 b7PPrTvZSspcWpz4fNLdvhBfTlsbMeOrt+vZhngM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	KaFai Wan <kafai.wan@linux.dev>,
	Leon Hwang <leon.hwang@linux.dev>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0284/1815] bpf: Reject programs with inlined helpers if JIT is not available
Date: Sat, 12 Sep 2026 08:33:54 +0200
Message-ID: <20260912065655.630283169@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit f1c27922576edccb99d0257827d09bd05c0304a6 ]

When an architecture (such as LoongArch, ARM64, and RISC-V) implements
bpf_jit_inlines_helper_call(), the verifier skips rewriting the helper
call offset (insn->imm) in bpf_do_misc_fixups(). This is because the
helper is expected to be inlined by the JIT compiler later. Therefore,
insn->imm remains as the raw helper enum ID.

However, if JIT is disabled at runtime (net.core.bpf_jit_enable=0) or
if JIT compilation fails dynamically (e.g., due to OOM), the program
falls back to the BPF interpreter.

When the interpreter executes (__bpf_call_base + insn->imm) with the
unpatched raw ID, it jumps into an invalid address space, triggering
an instruction alignment fault or a kernel panic.

Although these helpers have valid C implementations in the kernel, the
omission of offset rewriting makes runtime interpreter fallback fatal.

Fix this by setting 'prog->jit_required = 1' when helper call rewriting
is skipped for JIT inlining. This ensures that such programs are safely
rejected if JIT is not available, preventing the runtime kernel panic.

Fixes: 2ddec2c80b44 ("riscv, bpf: inline bpf_get_smp_processor_id()")
Suggested-by: Alexei Starovoitov <ast@kernel.org>
Suggested-by: KaFai Wan <kafai.wan@linux.dev>
Acked-by: Leon Hwang <leon.hwang@linux.dev>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/fixups.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/fixups.c b/kernel/bpf/fixups.c
index a577050651e3e..d9019ebe71a9c 100644
--- a/kernel/bpf/fixups.c
+++ b/kernel/bpf/fixups.c
@@ -1840,8 +1840,10 @@ int bpf_do_misc_fixups(struct bpf_verifier_env *env)
 		}
 
 		/* Skip inlining the helper call if the JIT does it. */
-		if (bpf_jit_inlines_helper_call(insn->imm))
+		if (bpf_jit_inlines_helper_call(insn->imm)) {
+			prog->jit_required = 1;
 			goto next_insn;
+		}
 
 		if (insn->imm == BPF_FUNC_get_route_realm)
 			prog->dst_needed = 1;
-- 
2.53.0



