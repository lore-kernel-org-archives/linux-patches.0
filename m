Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6984CDDC7;
	Thu, 17 Sep 2026 15:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659372; cv=none; b=FA8HWqDbT1BTPnBMe1uUyAx08QKBG1AIgKNt/NIl7PPoyAj3c4Ocm2v6b56Yb36ywV8P6V3FPvdX3Om8dLEXa76LHdG6bam1A/9uKNfKe3wR15rFvUapNZ8QMJM2rU4xJcDZNQNE3Q45UrGMP0uBQsMggqnD1L2lFQAtpWPT8SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659372; c=relaxed/simple;
	bh=7SkPpNzUcrKTeOuevhIlIADjWPg+CY4nmYETpHaVNvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ofserCiv12wEmC8EPMvUenEOEp1jZob9JAIlyH2HP9uraXrAP+MJwFXxfpqqoO3mAimqNXub1EV02tKNoaOi9MVgg3Ni2YN5i8J0NFwu43FaCJxtFPwTtKMeIrlVugLWSaO9Ucij8VDkUL5m9X8MR2Go9BA3w6bJPzvfcZtnZ58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FkLihJNf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FkLihJNf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C091F00893;
	Thu, 17 Sep 2026 15:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659359;
	bh=0tk4Ok0/9PwmS7xQy32bemVwrmaOyCF1vziFbOor2dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FkLihJNfmQ45YMMjfp9PgsDXr25hAPLLFxQRFWaLFTGIakpvsXlpfr5mod2ZiFGuW
	 RJ/tpSRuVmtYpp0t6GRKp5YHAyCihgbxWK3kbJgrQ5J3oBGN8SNpqRpGuexSgk1kXt
	 vHb+EjeU+RxgQZ7HWbI7i4rhqR5So6zK6JOHOyb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 230/733] bpf: Reject tail calls directly from callback frames
Date: Thu, 17 Sep 2026 16:08:58 +0100
Message-ID: <20260917151356.960713994@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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
index b0118bccf3280..aeb5711211245 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -10672,6 +10672,17 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
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



