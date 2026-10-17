Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4963B3880;
	Sat, 17 Oct 2026 16:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255457; cv=none; b=IDvPgU3MyzvgZGcj6pRwxuvjsQyMBmUZc1pVyLJrl5j9Ooieb0rXTVVM5GLrIHwvW6Hfq5x3G1lMEjg3S15P99NsQIrtTio5fgSS1Re6oYEy7OcUgVREZMGy+pa5ukBD+TzJm6uexLjOoPx1ysGAVBU9l1VADzR5hbJjDYjD/Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255457; c=relaxed/simple;
	bh=K+I7QvUv5jtrUtZQqM8f5s1Oa3yu2XJWIyhDW9hkhRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m3I2P4D2mZMAomNlG+rSEvLk2kDFBPL1ruWz2LXw0wrGtmxE14NM5hf6CHV94lGYUALT8gSaoORnK4hAom7IOlr5sg/lFsHD0O8zGwJdBgEAgDEGf4If9LSutzWc8VwVqjuk1Dw2X/4d4n9Y9m0V+TvqOALVeyoRZ/wS9lyd4+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hrSNxaQr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hrSNxaQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B58B1F000C4;
	Sat, 17 Oct 2026 16:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255455;
	bh=gPuFlIpXM3UDqgiY4le98fNwf/1VWby8R8/Rwi/GiUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hrSNxaQroTGI4vOFWxjsT/sJydhhb7k9UIgvbn6Uqi6dJ+VLGq9D+9bPbSwfKQdNN
	 VodoFVhOMTT6KM4Yxy28okTGYWg9gRACE+s9POzGnWzQRMnQUVzGCZBI7691pEjg4W
	 jTNN++D4d01P8SdIulTzmF3XGXeGB4v1W8pAoQw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 781/869] bpf: Reject legacy packet loads from callbacks
Date: Sat, 17 Oct 2026 18:00:22 +0200
Message-ID: <20261017160056.940390283@linuxfoundation.org>
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

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit e7d28823c662128caae63f14e16bd394916c139b ]

check_ld_abs() models a failed BPF_LD_ABS or BPF_LD_IND in a
subprogram as an implicit return with R0 set to zero. It calls
prepare_func_exit() to explore this synthesized path.

When the load is reached directly from a synchronous callback,
prepare_func_exit() enforces the callback return contract and marks R0
precise. R0 is not derived from a real instruction on this path, so
precision backtracking reaches the callback call with R0 still requested
and triggers the "callback unexpected regs" verifier bug. A privileged
program loader can therefore cause a verifier warning and an -EFAULT
BPF_PROG_LOAD.

These legacy packet-load instructions are deprecated. Reject them from
callbacks rather than complicating their implicit-return model. Check all
active frames before constructing the implicit return so nested static
subprograms cannot hide the callback context.

Global functions are verified independently with a fresh frame zero, so
an active-frame check cannot identify a global function called from a
callback. Also check the complete subprogram call graph during stack-depth
validation and reject a function containing a legacy load when any caller
is a callback. This covers global and static descendants without making
has_ld_abs transitive, preserving its per-function BTF return-type check.
Ordinary uses outside callbacks remain supported.

Fixes: ee861486e377 ("bpf: Fix ld_{abs,ind} failure path analysis in subprogs")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/bpf/20260903152147.C0E241F00A3A@smtp.kernel.org
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20260903214758.2727663-8-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 61df484f39ff2..424cf2b196f27 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6257,6 +6257,17 @@ static int check_max_stack_depth_subprog(struct bpf_verifier_env *env, int idx,
 	if (!priv_stack_supported)
 		subprog[idx].priv_stack_mode = NO_PRIV_STACK;
 process_func:
+	if (subprog[idx].has_ld_abs) {
+		bool in_cb = subprog[idx].is_cb;
+
+		for (j = 0; j < frame && !in_cb; j++)
+			in_cb = subprog[ret_prog[j]].is_cb;
+		if (in_cb) {
+			verbose(env, "cannot use BPF_LD_[ABS|IND] within callback\n");
+			return -EINVAL;
+		}
+	}
+
 	/* protect against potential stack overflow that might happen when
 	 * bpf2bpf calls get combined with tailcalls. Limit the caller's stack
 	 * depth for such case down to 256 so that the worst case scenario
@@ -16202,6 +16213,7 @@ static bool may_access_skb(enum bpf_prog_type type)
  */
 static int check_ld_abs(struct bpf_verifier_env *env, struct bpf_insn *insn)
 {
+	struct bpf_verifier_state *state = env->cur_state;
 	struct bpf_reg_state *regs = cur_regs(env);
 	static const int ctx_reg = BPF_REG_6;
 	u8 mode = BPF_MODE(insn->code);
@@ -16212,6 +16224,13 @@ static int check_ld_abs(struct bpf_verifier_env *env, struct bpf_insn *insn)
 		return -EINVAL;
 	}
 
+	for (i = state->curframe; i; i--) {
+		if (state->frame[i]->in_callback_fn) {
+			verbose(env, "cannot use BPF_LD_[ABS|IND] within callback\n");
+			return -EINVAL;
+		}
+	}
+
 	if (!env->ops->gen_ld_abs) {
 		verbose(env, "bpf verifier is misconfigured\n");
 		return -EINVAL;
-- 
2.53.0



