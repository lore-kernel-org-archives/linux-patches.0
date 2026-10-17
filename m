Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E94935C1BC;
	Sat, 17 Oct 2026 16:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253831; cv=none; b=V66/heQVYBw8TWvvzbjZqpfjQ0i9zGTEPwscoP9rhLwl46BoOVgNqui1BgWsOrOyrFozuEINox3iV4XCEEASqja0N7MUQa1tRLNoDQajauOuCujEmway0SdJFZSKDvAt7J+yf0nUHNhJRc1XWAD7Ilnlj1Z8Vs6zgBHfw3N0Y2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253831; c=relaxed/simple;
	bh=g4Gn1f63//6A4x64NlGSI4xpZkaZnwWDX5FRBV41Bwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8/RWZiq1A/BR+ghNx1LuDowuKgEnCXhX2ElV87cVWLMC1AFNEJjoVpKQ5yjbMyXsXu4WeBxzHcLFIniIi7nrulMqVPMh490ctroQE4an8wfJZWPaPi/CjI5oYmJCKcNZaL2xAeu9xdsXJ8vMgdn9VhvX986kRqm0BW4qasWe3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i6jIVhfg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i6jIVhfg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795AC1F000C4;
	Sat, 17 Oct 2026 16:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253830;
	bh=QaOvW5YIkKb9kPrKeGxyaoiBjeKBcWHMy/Svj8bAoAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i6jIVhfg3cKIthqt4qe2gGI3Z89oE3VYGkpGJ2KblZ9wTRrY9Z7VcRCH8bYf2zyYk
	 Oy6Tpm7bmUoy4M3oUQ5tWYPYHSgDVMEu6LcrJFwCwEZEfJr7aOjY6Evz0bIp7lTku0
	 CiFmmk3ujWQ1AiqZRfKPKHq9hWD5fyYiGlJ3fLmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peilin Ye <yepeilin@google.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 207/869] bpf: Factor out atomic_ptr_type_ok()
Date: Sat, 17 Oct 2026 17:50:48 +0200
Message-ID: <20261017160042.362738909@linuxfoundation.org>
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

From: Peilin Ye <yepeilin@google.com>

[ Upstream commit 66faaea94e1a8e8197d98de6e9d07591970837d6 ]

Factor out atomic_ptr_type_ok() as a helper function to be used later.

Signed-off-by: Peilin Ye <yepeilin@google.com>
Link: https://lore.kernel.org/r/e5ef8b3116f3fffce78117a14060ddce05eba52a.1740978603.git.yepeilin@google.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 179ee84a8911 ("bpf: Fix incorrect pruning due to atomic fetch precision tracking")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 4978c1d68bd98..1f5c8b5b74ffb 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5986,6 +5986,26 @@ static bool is_arena_reg(struct bpf_verifier_env *env, int regno)
 	return reg->type == PTR_TO_ARENA;
 }
 
+/* Return false if @regno contains a pointer whose type isn't supported for
+ * atomic instruction @insn.
+ */
+static bool atomic_ptr_type_ok(struct bpf_verifier_env *env, int regno,
+			       struct bpf_insn *insn)
+{
+	if (is_ctx_reg(env, regno))
+		return false;
+	if (is_pkt_reg(env, regno))
+		return false;
+	if (is_flow_key_reg(env, regno))
+		return false;
+	if (is_sk_reg(env, regno))
+		return false;
+	if (is_arena_reg(env, regno))
+		return bpf_jit_supports_insn(insn, true);
+
+	return true;
+}
+
 static u32 *reg2btf_ids[__BPF_REG_TYPE_MAX] = {
 #ifdef CONFIG_NET
 	[PTR_TO_SOCKET] = &btf_sock_ids[BTF_SOCK_TYPE_SOCK],
@@ -7439,11 +7459,7 @@ static int check_atomic(struct bpf_verifier_env *env, int insn_idx, struct bpf_i
 		return -EACCES;
 	}
 
-	if (is_ctx_reg(env, insn->dst_reg) ||
-	    is_pkt_reg(env, insn->dst_reg) ||
-	    is_flow_key_reg(env, insn->dst_reg) ||
-	    is_sk_reg(env, insn->dst_reg) ||
-	    (is_arena_reg(env, insn->dst_reg) && !bpf_jit_supports_insn(insn, true))) {
+	if (!atomic_ptr_type_ok(env, insn->dst_reg, insn)) {
 		verbose(env, "BPF_ATOMIC stores into R%d %s is not allowed\n",
 			insn->dst_reg,
 			reg_type_str(env, reg_state(env, insn->dst_reg)->type));
-- 
2.53.0



