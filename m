Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9334E2BE039;
	Wed, 17 Sep 2025 12:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112684; cv=none; b=e9tsLoMrRDisznz3hpTJtRuA9KCGJ6PcxZBV7WEoQpL0UpT4DcMsAuC2FyJvZRAdZZ6IW7siIeKYqUzrfsn8TzCZZ9ZgaZ86E961bW/aYwgmo0xo+aHgzG2NEribqhgDt93qIS2Xvu96ah8oVOQHqKnCuBmvB0/peg8Fl23WzTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112684; c=relaxed/simple;
	bh=6UdmYTUjOMBamqT9QeVc6zl3hcFarTxKNQtBkFTCezo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSRKMfE3AoaLO00AvVvsH+hht19D/Ct/RrXXlDbUbqyB1FoMkhzLt9o/Mdz/EssgfgPGqUNax1P901DnNiaHW/ir1+RXvAwOlYfSE6TM2ZDBTKChKK7Q3ClXcVGeeXpiQ8tpnAciy/S7HuAxV/KkqtlCn27kwQ9+S8K/fCAtpYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tl6UsUc+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tl6UsUc+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5EB0C4CEF0;
	Wed, 17 Sep 2025 12:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112684;
	bh=6UdmYTUjOMBamqT9QeVc6zl3hcFarTxKNQtBkFTCezo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tl6UsUc+4fKRuailqQMvaxiaTCNegLNBRbEda4vdMkhcTRHnQ91vy/s7Rj1njWhHh
	 aoOgsxJoSozX1IFYc3+3Mb8tqMeC6vso9R9NQuswPQXsaI+gBMA6MaW+yaWXOKnhix
	 jh69Da3qtDbiMLs+LoxlHWI9vHEnhLBdVgZkWVxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	KaFai Wan <kafai.wan@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 044/189] bpf: Allow fall back to interpreter for programs with stack size <= 512
Date: Wed, 17 Sep 2025 14:32:34 +0200
Message-ID: <20250917123352.939591870@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: KaFai Wan <kafai.wan@linux.dev>

[ Upstream commit df0cb5cb50bd54d3cd4d0d83417ceec6a66404aa ]

OpenWRT users reported regression on ARMv6 devices after updating to latest
HEAD, where tcpdump filter:

tcpdump "not ether host 3c37121a2b3c and not ether host 184ecbca2a3a \
and not ether host 14130b4d3f47 and not ether host f0f61cf440b7 \
and not ether host a84b4dedf471 and not ether host d022be17e1d7 \
and not ether host 5c497967208b and not ether host 706655784d5b"

fails with warning: "Kernel filter failed: No error information"
when using config:
 # CONFIG_BPF_JIT_ALWAYS_ON is not set
 CONFIG_BPF_JIT_DEFAULT_ON=y

The issue arises because commits:
1. "bpf: Fix array bounds error with may_goto" changed default runtime to
   __bpf_prog_ret0_warn when jit_requested = 1
2. "bpf: Avoid __bpf_prog_ret0_warn when jit fails" returns error when
   jit_requested = 1 but jit fails

This change restores interpreter fallback capability for BPF programs with
stack size <= 512 bytes when jit fails.

Reported-by: Felix Fietkau <nbd@nbd.name>
Closes: https://lore.kernel.org/bpf/2e267b4b-0540-45d8-9310-e127bf95fc63@nbd.name/
Fixes: 6ebc5030e0c5 ("bpf: Fix array bounds error with may_goto")
Signed-off-by: KaFai Wan <kafai.wan@linux.dev>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20250909144614.2991253-1-kafai.wan@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/core.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index d966e971893ab..829f0792d8d83 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2354,8 +2354,7 @@ static unsigned int __bpf_prog_ret0_warn(const void *ctx,
 					 const struct bpf_insn *insn)
 {
 	/* If this handler ever gets executed, then BPF_JIT_ALWAYS_ON
-	 * is not working properly, or interpreter is being used when
-	 * prog->jit_requested is not 0, so warn about it!
+	 * is not working properly, so warn about it!
 	 */
 	WARN_ON_ONCE(1);
 	return 0;
@@ -2456,8 +2455,9 @@ static int bpf_check_tail_call(const struct bpf_prog *fp)
 	return ret;
 }
 
-static void bpf_prog_select_func(struct bpf_prog *fp)
+static bool bpf_prog_select_interpreter(struct bpf_prog *fp)
 {
+	bool select_interpreter = false;
 #ifndef CONFIG_BPF_JIT_ALWAYS_ON
 	u32 stack_depth = max_t(u32, fp->aux->stack_depth, 1);
 	u32 idx = (round_up(stack_depth, 32) / 32) - 1;
@@ -2466,15 +2466,16 @@ static void bpf_prog_select_func(struct bpf_prog *fp)
 	 * But for non-JITed programs, we don't need bpf_func, so no bounds
 	 * check needed.
 	 */
-	if (!fp->jit_requested &&
-	    !WARN_ON_ONCE(idx >= ARRAY_SIZE(interpreters))) {
+	if (idx < ARRAY_SIZE(interpreters)) {
 		fp->bpf_func = interpreters[idx];
+		select_interpreter = true;
 	} else {
 		fp->bpf_func = __bpf_prog_ret0_warn;
 	}
 #else
 	fp->bpf_func = __bpf_prog_ret0_warn;
 #endif
+	return select_interpreter;
 }
 
 /**
@@ -2493,7 +2494,7 @@ struct bpf_prog *bpf_prog_select_runtime(struct bpf_prog *fp, int *err)
 	/* In case of BPF to BPF calls, verifier did all the prep
 	 * work with regards to JITing, etc.
 	 */
-	bool jit_needed = fp->jit_requested;
+	bool jit_needed = false;
 
 	if (fp->bpf_func)
 		goto finalize;
@@ -2502,7 +2503,8 @@ struct bpf_prog *bpf_prog_select_runtime(struct bpf_prog *fp, int *err)
 	    bpf_prog_has_kfunc_call(fp))
 		jit_needed = true;
 
-	bpf_prog_select_func(fp);
+	if (!bpf_prog_select_interpreter(fp))
+		jit_needed = true;
 
 	/* eBPF JITs can rewrite the program in case constant
 	 * blinding is active. However, in case of error during
-- 
2.51.0



