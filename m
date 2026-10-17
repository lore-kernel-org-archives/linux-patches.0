Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C335A36CE19;
	Sat, 17 Oct 2026 16:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254980; cv=none; b=PMZCPHDVFy4F5UK1v7XODgbd7EOLyDJCnKYIGtMoHwfgPkWwkEKnG2sIfngwTHnBWXuimZBkLjh0ETDC7nZI+ta96ezWFC1CmrOeTLn7tbissuGD7pybfIJclcODp2MNTBeBhLr75p964npRm2i6BKdViC5AHTEKqYWTxAlzgSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254980; c=relaxed/simple;
	bh=BFCOJdvWQPNhLxH7DHAbnW2bE7OXElHy3kvxdsrXWHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aXIY3fqB8vs++3NAqkDG924uv2H/Iv/RE3AyvaQDuwFQnnvUJTV3J+LpbwfmDKSCaCwDZRtdlxoUvnmYVSLf54AL3CXsg2rFzHtKSJsQvi1/2TrRilwZ98Hqg4ZD9O96vshwkehJCSYtw5xLtaoGJcHG3NYfqggSHx0aw5D/hN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g8yzg9Sk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g8yzg9Sk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23FBA1F000C4;
	Sat, 17 Oct 2026 16:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254979;
	bh=LvflhYGY7ma2DbgDqq8IR0kRK4r3vvY+hHQvN30pMNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g8yzg9SkCMvxevcYuqrHN1sWFl0xCUyZtZGRMu9WOPFNW5d2QhO9wRNM7JaFO9SpN
	 gN0ZOUTHQ/w0hNj61YkvbL1duTnPaWDHm11pAVn3nQl5YL2g/rvy9876NdUjUyVLhi
	 SHXJWuLRkD2jT64tTkpm1P+CV4F8aPiaSzLict3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 625/869] bpf: Check pointer type for all atomic RMW paths
Date: Sat, 17 Oct 2026 17:57:46 +0200
Message-ID: <20261017160053.052840010@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>

[ Upstream commit 4bc49ae344d65cfcef738f281ac575cf73ca2fc5 ]

Atomic RMW verification records an instruction pointer type only when the
current destination is PTR_TO_ARENA. A second path can therefore reach the
same instruction with an ordinary pointer without comparing it against the
saved arena type.

The post-verification fixup uses the saved type to rewrite the instruction
to BPF_PROBE_ATOMIC for every path. Record the actual destination type for
all atomic RMW paths so the existing mismatch check rejects incompatible
uses of one instruction.

Fixes: d503a04f8bc0 ("bpf: Add support for certain atomics in bpf_arena to x86 JIT")
Signed-off-by: Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://patch.msgid.link/20260816-bpf-next-038-mixed-atomic-v1-v2-1-4644c1886dbc@mails.tsinghua.edu.cn
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 03d5e7db3df76..752bc2d57d2bf 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7559,11 +7559,9 @@ static int check_atomic_rmw(struct bpf_verifier_env *env,
 	if (err)
 		return err;
 
-	if (is_arena_reg(env, insn->dst_reg)) {
-		err = save_aux_ptr_type(env, PTR_TO_ARENA, false);
-		if (err)
-			return err;
-	}
+	err = save_aux_ptr_type(env, reg_state(env, insn->dst_reg)->type, false);
+	if (err)
+		return err;
 	/* Check whether we can write into the same memory. */
 	err = check_mem_access(env, env->insn_idx, insn->dst_reg, insn->off,
 			       BPF_SIZE(insn->code), BPF_WRITE, -1, true, false);
-- 
2.53.0



