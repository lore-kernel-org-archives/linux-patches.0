Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9A54C10EC;
	Thu, 17 Sep 2026 15:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659550; cv=none; b=SAMjiaWc82p/VCIkV5p6boxMAYd7vBOJmJy14qEAG2Zb3ugPEpdOmlIqX1HrGP/hXy4Db9ie86mxfDFTZ8Pwzuccl8F7wRnLTjUl/xGeG/r07FIdnTbob/mBVtrttMkb4PN+YoziCZZYT0QZlMSx4omfMRDVcVcZLdNiGD0ocTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659550; c=relaxed/simple;
	bh=7a8iTaBBdCcEIyx0n3nlhLXaCmUxFLCSG6XuXyOPFb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OsrazzWXUGCIi8FzAvOIVSrInatI3w0DmxVpowLpox402TDkYTVq9wlZHTW9LVPconCl3u1Gwg0QZwXH5NyPcoyR/5fX8cS3uf9XLsbhJ/uGe7cKwm9uKTjIEkyGumJaI1p1wwbf56H9sDjpXTWnh89kdDq6luQIS7RZ+ihS9eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e4dmjSkK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e4dmjSkK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9D51F000FF;
	Thu, 17 Sep 2026 15:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659540;
	bh=2P5sPNJjtmB08CtE1DNyyRBMKN0avUfc8GpLWJ86VTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e4dmjSkK0Iz9u5JBquNZtrg+F1Ya24g2MaS0IMK0/ftTrymQyJZ/n2id1qjWEItJ6
	 DBLHG8CSUoBr/s3KjQMy7YEMHc+52Hv+aLV8eJvYahqJcIHgCRI1loXItOwYh8GlIG
	 Y8IrlEF/XqNDIJz3G9nI3RHpGMmqaqMXWUII1GOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 253/733] bpf: Reject legacy packet loads from callbacks
Date: Thu, 17 Sep 2026 16:09:21 +0100
Message-ID: <20260917151357.600452419@linuxfoundation.org>
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
 kernel/bpf/verifier.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 9554eb6bd2016..96aaa9155e59e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5119,6 +5119,15 @@ static int check_max_stack_depth_subprog(struct bpf_verifier_env *env, int idx,
 	if (!priv_stack_supported)
 		subprog[idx].priv_stack_mode = NO_PRIV_STACK;
 process_func:
+	if (subprog[idx].has_ld_abs) {
+		for (tmp = idx; tmp >= 0; tmp = dinfo[tmp].caller) {
+			if (subprog[tmp].is_cb) {
+				verbose(env, "cannot use BPF_LD_[ABS|IND] within callback\n");
+				return -EINVAL;
+			}
+		}
+	}
+
 	/* protect against potential stack overflow that might happen when
 	 * bpf2bpf calls get combined with tailcalls. Limit the caller's stack
 	 * depth for such case down to 256 so that the worst case scenario
@@ -16420,6 +16429,7 @@ static bool may_access_skb(enum bpf_prog_type type)
  */
 static int check_ld_abs(struct bpf_verifier_env *env, struct bpf_insn *insn)
 {
+	struct bpf_verifier_state *state = env->cur_state;
 	struct bpf_reg_state *regs = cur_regs(env);
 	static const int ctx_reg = BPF_REG_6;
 	u8 mode = BPF_MODE(insn->code);
@@ -16430,6 +16440,13 @@ static int check_ld_abs(struct bpf_verifier_env *env, struct bpf_insn *insn)
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
 		verifier_bug(env, "gen_ld_abs is null");
 		return -EFAULT;
-- 
2.53.0



