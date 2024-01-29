Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD1A157E68;
	Mon, 29 Jan 2024 17:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548525; cv=none; b=jkB4VJhsB3rIGdmUxRl50QVf8mUi7gaAKT1ygt3up8VOVi1eakQAKy/C0bIAaL8jf2NtFftZzTxhDt3QQfTYg3ueVjFqHTrK6NI2u3IEuoJ3pBzSAcR0/PPCW2u6K0KTKZGRR2A7W7RM6csad2MGGNBI00OsYO6IZrJ4H6liLIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548525; c=relaxed/simple;
	bh=uz4OrzLB8oitLLYtyJ5AEjflHDUdcmPYJaWEyIgJSa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TmeG64VBH/mf/htfFVBe8XwmmIo5JTYnlCXc/+fS+Kv+QqwpfWpzlvQJruEe9tqvAVGTjAmtH+xp6zvvCw8hsTnI2krw3pgrc/by8dQ0lGQ/RkHTq80NdRv8tHzBL3Qj6LB0iP+rE6tBf91EIDa2Nps/MeKx46uWA/L9xKQGCfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IKuumiCD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IKuumiCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78893C433F1;
	Mon, 29 Jan 2024 17:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548525;
	bh=uz4OrzLB8oitLLYtyJ5AEjflHDUdcmPYJaWEyIgJSa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IKuumiCDvlK0m9Mqv2anQc9e9kq6BPqze+6KUexULcgW4Iv/hgaurS6F1L+hKk71e
	 il/uSFK2fP2kMHjykemV8W8vhQBMzMLsKekoWJJItZUkKmysUX2lo2rFrI2ElzogPu
	 UgL0VGTVBUNUWuAfy2mFL25MFZwdxyn6UlXj6WXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.6 159/331] bpf: widening for callback iterators
Date: Mon, 29 Jan 2024 09:03:43 -0800
Message-ID: <20240129170019.584040644@linuxfoundation.org>
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

commit cafe2c21508a38cdb3ed22708842e957b2572c3e upstream.

Callbacks are similar to open coded iterators, so add imprecise
widening logic for callback body processing. This makes callback based
loops behave identically to open coded iterators, e.g. allowing to
verify programs like below:

  struct ctx { u32 i; };
  int cb(u32 idx, struct ctx* ctx)
  {
          ++ctx->i;
          return 0;
  }
  ...
  struct ctx ctx = { .i = 0 };
  bpf_loop(100, cb, &ctx, 0);
  ...

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20231121020701.26440-9-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9595,9 +9595,10 @@ static bool in_rbtree_lock_required_cb(s
 
 static int prepare_func_exit(struct bpf_verifier_env *env, int *insn_idx)
 {
-	struct bpf_verifier_state *state = env->cur_state;
+	struct bpf_verifier_state *state = env->cur_state, *prev_st;
 	struct bpf_func_state *caller, *callee;
 	struct bpf_reg_state *r0;
+	bool in_callback_fn;
 	int err;
 
 	callee = state->frame[state->curframe];
@@ -9659,7 +9660,8 @@ static int prepare_func_exit(struct bpf_
 	 * there function call logic would reschedule callback visit. If iteration
 	 * converges is_state_visited() would prune that visit eventually.
 	 */
-	if (callee->in_callback_fn)
+	in_callback_fn = callee->in_callback_fn;
+	if (in_callback_fn)
 		*insn_idx = callee->callsite;
 	else
 		*insn_idx = callee->callsite + 1;
@@ -9673,6 +9675,24 @@ static int prepare_func_exit(struct bpf_
 	/* clear everything in the callee */
 	free_func_state(callee);
 	state->frame[state->curframe--] = NULL;
+
+	/* for callbacks widen imprecise scalars to make programs like below verify:
+	 *
+	 *   struct ctx { int i; }
+	 *   void cb(int idx, struct ctx *ctx) { ctx->i++; ... }
+	 *   ...
+	 *   struct ctx = { .i = 0; }
+	 *   bpf_loop(100, cb, &ctx, 0);
+	 *
+	 * This is similar to what is done in process_iter_next_call() for open
+	 * coded iterators.
+	 */
+	prev_st = in_callback_fn ? find_prev_entry(env, state, *insn_idx) : NULL;
+	if (prev_st) {
+		err = widen_imprecise_scalars(env, prev_st, state);
+		if (err)
+			return err;
+	}
 	return 0;
 }
 


