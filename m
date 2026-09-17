Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49768515965;
	Thu, 17 Sep 2026 17:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665597; cv=none; b=jEcZ6tYum2tuYpebkm/c3/pbeNmn4nSS6A7Hk0x3gYiDxNRNumTlSOlmgEUurokUFCE0QnmIv7NyATuJoq1AJP6L8eCpErakQw5IG+EY7CbVSTcnSo7I/OSwaMdZy/XKUcTh2mVMGqgSsSvxxTD2gGTnG01Tyk4+T9/hKbUYUGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665597; c=relaxed/simple;
	bh=JBY/DN5YcYs17z2mzqlLvwo345E8cHszC4bGO4lSxCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gsPKlSX/LKnm8AcM/QMLmemxNoDh0FB9u7lE3QBB6b37K+hkqMJvCgeBVN7EbJJ8TsXeD9vS+c6UUFReBCWw+fvKeGgO1y1cjl1/AL837dbD/0aLJBnMCX6FshhBUHHTQ4jcS4T2SMyUJNkTO5PdqcracEGe+4eNQRaeNJ4bsrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SZE6nUiP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SZE6nUiP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9C01F000FF;
	Thu, 17 Sep 2026 17:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665596;
	bh=nwxKqT0bd7qrsFIDuLE2XH0OKGbLbcxjmNIoS0zPlTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SZE6nUiPIwiogjRYu2IiR7X2NGkzjiBj8QK+TFb134D31U70UpoEfJlCi/8nImZ0i
	 QLKVZYtNeAlYEND636vEMzXG2v/fGNuHk3rUD9hNUmvJLDy2YKLG2UYJBeVVAk3p2t
	 f6688flRKVYwBVypYdUZemcX84CjXHVnYSTubOyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0757/1250] bpf: Reject tail calls directly from callback frames
Date: Thu, 17 Sep 2026 16:09:12 +0100
Message-ID: <20260917151612.395101723@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 266aa4ad0b2e82397cd9045752c9bff03d98eddd ]

A tail call from a non-zero frame is modeled as a return from that frame.
The verifier makes R0 unknown and calls prepare_func_exit() for the taken
branch.

When the current frame is a synchronous callback, prepare_func_exit()
enforces the callback return-value contract and marks R0 precise. Since the
tail-call path synthesized R0 rather than deriving it from an instruction,
precision backtracking reaches the callback-calling instruction with R0
still requested and triggers the "callback unexpected regs" verifier bug.
A CAP_BPF task can therefore cause a WARN and an -EFAULT BPF_PROG_LOAD.

Tail calls reachable from callbacks are already rejected later by
check_max_stack_depth(). Reject a tail call made directly by a callback
before constructing the inconsistent return state, using the existing
diagnostic. Tail calls from ordinary subprograms keep their current
behavior.

Fixes: e3245f899043 ("bpf: properly verify tail call behavior")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20260903144433.1716731-4-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c0564cbb9154a..c2e71bb4a2cd7 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -12046,6 +12046,17 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 		if (env->cur_state->curframe) {
 			struct bpf_verifier_state *branch;
 
+			/*
+			 * A taken tail call is modeled as a return from the current
+			 * frame. A callback frame cannot be left that way because
+			 * prepare_func_exit() would apply its return contract to the
+			 * unknown R0 synthesized below. Stack-depth validation rejects
+			 * this construct anyway.
+			 */
+			if (cur_func(env)->in_callback_fn) {
+				verbose(env, "cannot tail call within callback\n");
+				return -EINVAL;
+			}
 			mark_reg_scratched(env, BPF_REG_0);
 			branch = push_stack(env, env->insn_idx + 1, env->insn_idx, false);
 			if (IS_ERR(branch))
-- 
2.53.0



