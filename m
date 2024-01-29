Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A282A157E66;
	Mon, 29 Jan 2024 17:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548522; cv=none; b=BDMU+/94NJsoIlGf+7TMci2W5LgHC+iubccS2lcQrp9Lbg1r3BJZtufwvC7p0QA60gk+IC77IQ9HArYqz16011nLJPT5WRcLiea1KbQsZPDVIs9JNOVPcSiAu67w1PLUjCQdb4gxi1SD/hVpZzWZlVKgjLKX9dXFDiH8lpxLk2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548522; c=relaxed/simple;
	bh=JbsjgUkfGrLCUpEDQfZbGGfB/27/vLolnQOTJEukm90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0X9Rjl9Rz1y1Pv0Df+u4kMK4lq2HTB6kFh1H8kQbGb0FsCwXde/ypygnpZ318/pS+wcHTtj3SjvsWpPlOiMcv/3ahVjgb7RYmUfti90kM24U9N+4P2mAxORNgnKus7ZtS/RpoL9JsXX2fjkHttBCXDv4uIU1VeFG0lsKepJAJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UbDaCrQz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UbDaCrQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16798C433F1;
	Mon, 29 Jan 2024 17:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548522;
	bh=JbsjgUkfGrLCUpEDQfZbGGfB/27/vLolnQOTJEukm90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UbDaCrQzjd8YV1FQKzeL17gDvox4kYeSLZqz1cotIFNlrkGM0087k/hsU3H8DK4Bi
	 eqC+s7tppLyWuXHOvI61cPu1JRH8yvu+cKdglhefsktBO9AZNrr+ol1AtfjcnJqdXL
	 kAzNotEf3Hzk3ritm71oR3sjQWnQK7iy7X/qCORE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.6 155/331] bpf: extract __check_reg_arg() utility function
Date: Mon, 29 Jan 2024 09:03:39 -0800
Message-ID: <20240129170019.455903780@linuxfoundation.org>
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

commit 683b96f9606ab7308ffb23c46ab43cecdef8a241 upstream.

Split check_reg_arg() into two utility functions:
- check_reg_arg() operating on registers from current verifier state;
- __check_reg_arg() operating on a specific set of registers passed as
  a parameter;

The __check_reg_arg() function would be used by a follow-up change for
callbacks handling.

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20231121020701.26440-5-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3321,13 +3321,11 @@ static void mark_insn_zext(struct bpf_ve
 	reg->subreg_def = DEF_NOT_SUBREG;
 }
 
-static int check_reg_arg(struct bpf_verifier_env *env, u32 regno,
-			 enum reg_arg_type t)
+static int __check_reg_arg(struct bpf_verifier_env *env, struct bpf_reg_state *regs, u32 regno,
+			   enum reg_arg_type t)
 {
-	struct bpf_verifier_state *vstate = env->cur_state;
-	struct bpf_func_state *state = vstate->frame[vstate->curframe];
 	struct bpf_insn *insn = env->prog->insnsi + env->insn_idx;
-	struct bpf_reg_state *reg, *regs = state->regs;
+	struct bpf_reg_state *reg;
 	bool rw64;
 
 	if (regno >= MAX_BPF_REG) {
@@ -3368,6 +3366,15 @@ static int check_reg_arg(struct bpf_veri
 	return 0;
 }
 
+static int check_reg_arg(struct bpf_verifier_env *env, u32 regno,
+			 enum reg_arg_type t)
+{
+	struct bpf_verifier_state *vstate = env->cur_state;
+	struct bpf_func_state *state = vstate->frame[vstate->curframe];
+
+	return __check_reg_arg(env, state->regs, regno, t);
+}
+
 static void mark_jmp_point(struct bpf_verifier_env *env, int idx)
 {
 	env->insn_aux_data[idx].jmp_point = true;
@@ -9147,7 +9154,7 @@ static void clear_caller_saved_regs(stru
 	/* after the call registers r0 - r5 were scratched */
 	for (i = 0; i < CALLER_SAVED_REGS; i++) {
 		mark_reg_not_init(env, regs, caller_saved[i]);
-		check_reg_arg(env, caller_saved[i], DST_OP_NO_MARK);
+		__check_reg_arg(env, regs, caller_saved[i], DST_OP_NO_MARK);
 	}
 }
 


