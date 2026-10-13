Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8738336E466;
	Tue, 13 Oct 2026 12:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894005; cv=none; b=AZXKeH+xkL4rczcrtJNNg1u3cjiyMcAEHcY79pblXyUkqfJXG6znfJqzSaaH/Y9vh37THJRV0mLPCUDzsTW+S8shlZw8VnLliwu3G63Q5faQZEliJYiICZVwQa7569YHFnLz3zXrTzx291J3clITxi5uf/03eEIdh3kmXgRv0Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894005; c=relaxed/simple;
	bh=pKw+PhUEcpvW5v07p4Vfz5Uk1KNOHmskQNoUKDqkPnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pl7dt70aD5RLWYx2HaV4kGgOd4iCglzqlhl3JlGTcTEVwF3sRbTIQAQuRjeFpNv4HumYDCmp6aWermfDliNU3zKEE15xgePL/JWT5XjPFfxvBSDCsgf+X7zzqlvnvmdlDP9gT752WfYbSNkKalzmldGSQgmSD6weIi2jaL7rbpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FPjcU1VM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FPjcU1VM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E581F000FF;
	Tue, 13 Oct 2026 12:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894004;
	bh=MKWjaQ/A+HvDpSj7zS8miiMwhdprQQnysiplevwOutg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FPjcU1VMdMuRCM3NwyXa4S2FiJUXyb3reJR7D+4UhxtmDMRyeQ3I0ExpzsQ8EGXMG
	 dMifAeilsYxS87DzXL3UbgHgz8+f4w5hxa46NCtTzTCFtKNTj48hkbaNv/zm+kV5Sr
	 57jvycb7rTPI49Gom2IbqLLg3N/wKTYQysLjDLpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 415/621] bpf: Check pointer type for all atomic RMW paths
Date: Tue, 13 Oct 2026 13:36:50 +0200
Message-ID: <20261013112930.683563592@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 34ebabc01fa1e..8cd9526c0dac9 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8036,11 +8036,9 @@ static int check_atomic_rmw(struct bpf_verifier_env *env,
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



