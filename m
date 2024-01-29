Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBE415EA91;
	Mon, 29 Jan 2024 17:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548523; cv=none; b=NBdhbvp8Ik2ods7g3W93ZSyyQTwOxM7bVCwvfMc10llCHresfS6yChszmRj09U+H0Hzq70r2HUsk/FnkXoVUL5uVYDE8Ej5TCeUtp3QwDqwwfVVqpXuMdBSdyaNCsuCZGcQmoUZAVdjJB7pKS+j0tNn9U2jcwbrAjIvHI9iG6ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548523; c=relaxed/simple;
	bh=WUJpd1kurrM9HFBxho0gnOxtDuGjtEHzbi6gBFuRupY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBJr+EZRI02gyvxcI6CI1c60wHUNJuo3FTbt6J85z0KGJ+8pnDKlg7IOv7QT4yRL4UCTyp3IA650RaTGjTJJSegGv7VCANo0w+WfcFXYZdY+svMfdTN87PBZtjYBVZvUUH/tpEdBUEEXdgJdYlatdiV/izucD7BjF4oVtMapbMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lilumy1K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lilumy1K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680E3C43390;
	Mon, 29 Jan 2024 17:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548523;
	bh=WUJpd1kurrM9HFBxho0gnOxtDuGjtEHzbi6gBFuRupY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lilumy1KrZCgw6lT0meeTxueYYwsMW5hnIXVP6KQjw0V6qkq6MBXI3JNSE3FBdyNU
	 O7MbOLetKpIwbcL1hNCCDjAXVxufxSk/m/hrloIXF5C5+nKNtGz5/SFbpHezrq7t70
	 67p7CN55NNuAlNq4+UVaSid6qttvt0y/85po2Qo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.6 156/331] bpf: extract setup_func_entry() utility function
Date: Mon, 29 Jan 2024 09:03:40 -0800
Message-ID: <20240129170019.484882412@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

commit 58124a98cb8eda69d248d7f1de954c8b2767c945 upstream.

Move code for simulated stack frame creation to a separate utility
function. This function would be used in the follow-up change for
callbacks handling.

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20231121020701.26440-6-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   84 ++++++++++++++++++++++++++++----------------------
 1 file changed, 48 insertions(+), 36 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9167,11 +9167,10 @@ static int set_callee_state(struct bpf_v
 			    struct bpf_func_state *caller,
 			    struct bpf_func_state *callee, int insn_idx);
 
-static int __check_func_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
-			     int *insn_idx, int subprog,
-			     set_callee_state_fn set_callee_state_cb)
+static int setup_func_entry(struct bpf_verifier_env *env, int subprog, int callsite,
+			    set_callee_state_fn set_callee_state_cb,
+			    struct bpf_verifier_state *state)
 {
-	struct bpf_verifier_state *state = env->cur_state;
 	struct bpf_func_state *caller, *callee;
 	int err;
 
@@ -9181,13 +9180,53 @@ static int __check_func_call(struct bpf_
 		return -E2BIG;
 	}
 
-	caller = state->frame[state->curframe];
 	if (state->frame[state->curframe + 1]) {
 		verbose(env, "verifier bug. Frame %d already allocated\n",
 			state->curframe + 1);
 		return -EFAULT;
 	}
 
+	caller = state->frame[state->curframe];
+	callee = kzalloc(sizeof(*callee), GFP_KERNEL);
+	if (!callee)
+		return -ENOMEM;
+	state->frame[state->curframe + 1] = callee;
+
+	/* callee cannot access r0, r6 - r9 for reading and has to write
+	 * into its own stack before reading from it.
+	 * callee can read/write into caller's stack
+	 */
+	init_func_state(env, callee,
+			/* remember the callsite, it will be used by bpf_exit */
+			callsite,
+			state->curframe + 1 /* frameno within this callchain */,
+			subprog /* subprog number within this prog */);
+	/* Transfer references to the callee */
+	err = copy_reference_state(callee, caller);
+	err = err ?: set_callee_state_cb(env, caller, callee, callsite);
+	if (err)
+		goto err_out;
+
+	/* only increment it after check_reg_arg() finished */
+	state->curframe++;
+
+	return 0;
+
+err_out:
+	free_func_state(callee);
+	state->frame[state->curframe + 1] = NULL;
+	return err;
+}
+
+static int __check_func_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
+			     int *insn_idx, int subprog,
+			     set_callee_state_fn set_callee_state_cb)
+{
+	struct bpf_verifier_state *state = env->cur_state;
+	struct bpf_func_state *caller, *callee;
+	int err;
+
+	caller = state->frame[state->curframe];
 	err = btf_check_subprog_call(env, subprog, caller->regs);
 	if (err == -EFAULT)
 		return err;
@@ -9256,35 +9295,12 @@ static int __check_func_call(struct bpf_
 		return 0;
 	}
 
-	callee = kzalloc(sizeof(*callee), GFP_KERNEL);
-	if (!callee)
-		return -ENOMEM;
-	state->frame[state->curframe + 1] = callee;
-
-	/* callee cannot access r0, r6 - r9 for reading and has to write
-	 * into its own stack before reading from it.
-	 * callee can read/write into caller's stack
-	 */
-	init_func_state(env, callee,
-			/* remember the callsite, it will be used by bpf_exit */
-			*insn_idx /* callsite */,
-			state->curframe + 1 /* frameno within this callchain */,
-			subprog /* subprog number within this prog */);
-
-	/* Transfer references to the callee */
-	err = copy_reference_state(callee, caller);
+	err = setup_func_entry(env, subprog, *insn_idx, set_callee_state_cb, state);
 	if (err)
-		goto err_out;
-
-	err = set_callee_state_cb(env, caller, callee, *insn_idx);
-	if (err)
-		goto err_out;
+		return err;
 
 	clear_caller_saved_regs(env, caller->regs);
 
-	/* only increment it after check_reg_arg() finished */
-	state->curframe++;
-
 	/* and go analyze first insn of the callee */
 	*insn_idx = env->subprog_info[subprog].start - 1;
 
@@ -9292,14 +9308,10 @@ static int __check_func_call(struct bpf_
 		verbose(env, "caller:\n");
 		print_verifier_state(env, caller, true);
 		verbose(env, "callee:\n");
-		print_verifier_state(env, callee, true);
+		print_verifier_state(env, state->frame[state->curframe], true);
 	}
-	return 0;
 
-err_out:
-	free_func_state(callee);
-	state->frame[state->curframe + 1] = NULL;
-	return err;
+	return 0;
 }
 
 int map_set_for_each_callback_args(struct bpf_verifier_env *env,


