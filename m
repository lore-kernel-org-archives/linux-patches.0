Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809F54C10E1;
	Thu, 17 Sep 2026 15:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659666; cv=none; b=hA8FBAcn0bCvLal/oO2dHSGshfYssULhbwYhhR+PBScwqCvEXioq0lkHlf7+UOImDb1jCbEB2+QWQAyyxz212/KE2Cb2byI6rWQNQhF6xk7vcilSgZ5cnzIIjgekiDrKlz3Kl/2EV0xqz3Pp9AOvFwM3VSqDJX04wygwN8oZz0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659666; c=relaxed/simple;
	bh=c/L4c2E5YFk989IwT5xfeNZXjXDaVoe8f4AwfSCLV2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4XF2LDiT12AlPLnGj1Hbu2b95HwqbFcjF5qLGbWsDd+SLF492k6zu/AJcznKBSKMIF1GVHeVdX5P4J5SgbOwrMaWQh74AWuQufvd6sPrI8jUuUA5A+c894StpKooaIT4xPaU5kMF5y3qiIRDVU2elFrtm6t08R7N9d1lhaVZ1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AAIpRplh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AAIpRplh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C141F1F00898;
	Thu, 17 Sep 2026 15:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659655;
	bh=hS2uFiNccQPQ5fg+D6vzzfzuxvRtY3iSy/UOXTWMcxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AAIpRplhs6IZOIz9/8fWJL/QMePTjsyGF5sy9iVKKNy+HaocSO+4SF+ZmfiKjKKkG
	 0szvJxmwJJ0cjWw/Q8zJ1uuZSDB/2l6W57iW3+BSSY0EMCY+Wfrzeux5x9uHu0Oq0Z
	 F6m43sxJyWYYW6tOonm9u7DVaEggYyZ7UwqS3irs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 290/733] bpf: propagate mark_chain_precision() errors out of loop_flag_is_zero()
Date: Thu, 17 Sep 2026 16:09:58 +0100
Message-ID: <20260917151358.630589941@linuxfoundation.org>
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

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit 1d7f8f191c06f967a85922c4652dc33c132b585d ]

Stop verification if mark_chain_precision() fails when called from
loop_flag_is_zero(). No functional change intended for the paths where
backtracking succeeds.

Fixes: 1ade23711971 ("bpf: Inline calls to bpf_loop when callback is known")
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260904-register-is-null-precise-fixes-v1-9-0f5a360ff15d@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1b2df166e0849..54a4435f50fba 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -10188,33 +10188,45 @@ static struct bpf_insn_aux_data *cur_aux(const struct bpf_verifier_env *env)
 	return &env->insn_aux_data[env->insn_idx];
 }
 
-static bool loop_flag_is_zero(struct bpf_verifier_env *env)
+/* Returns 1 if R4 is a known zero, 0 if it is not, a negative errno on error. */
+static int loop_flag_is_zero(struct bpf_verifier_env *env)
 {
 	struct bpf_reg_state *reg = reg_state(env, BPF_REG_4);
-	bool reg_is_null = bpf_register_is_null(reg);
+	int err;
 
-	if (reg_is_null)
-		mark_chain_precision(env, BPF_REG_4);
+	if (!bpf_register_is_null(reg))
+		return 0;
 
-	return reg_is_null;
+	err = mark_chain_precision(env, BPF_REG_4);
+	if (err)
+		return err;
+	return 1;
 }
 
-static void update_loop_inline_state(struct bpf_verifier_env *env, u32 subprogno)
+static int update_loop_inline_state(struct bpf_verifier_env *env, u32 subprogno)
 {
 	struct bpf_loop_inline_state *state = &cur_aux(env)->loop_inline_state;
+	int flag_is_zero;
 
 	if (!state->initialized) {
+		flag_is_zero = loop_flag_is_zero(env);
+		if (flag_is_zero < 0)
+			return flag_is_zero;
 		state->initialized = 1;
-		state->fit_for_inline = loop_flag_is_zero(env);
+		state->fit_for_inline = flag_is_zero;
 		state->callback_subprogno = subprogno;
-		return;
+		return 0;
 	}
 
 	if (!state->fit_for_inline)
-		return;
+		return 0;
 
-	state->fit_for_inline = (loop_flag_is_zero(env) &&
+	flag_is_zero = loop_flag_is_zero(env);
+	if (flag_is_zero < 0)
+		return flag_is_zero;
+	state->fit_for_inline = (flag_is_zero &&
 				 state->callback_subprogno == subprogno);
+	return 0;
 }
 
 /* Returns whether or not the given map can potentially elide
@@ -10426,7 +10438,9 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 		err = check_bpf_snprintf_call(env, regs);
 		break;
 	case BPF_FUNC_loop:
-		update_loop_inline_state(env, meta.subprogno);
+		err = update_loop_inline_state(env, meta.subprogno);
+		if (err)
+			return err;
 		/* Verifier relies on R1 value to determine if bpf_loop() iteration
 		 * is finished, thus mark it precise.
 		 */
-- 
2.53.0



