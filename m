Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E314EDCC1;
	Tue, 13 Oct 2026 12:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894286; cv=none; b=Hz2Jdji1iaEg1ph+7BSNJOL4CaoVJhh8IjjaEUpmX9Txyc4VLW+TYbR3kVRi9cWZlR1FmEaJuHF4+0Pm3OIiMfINrjH9pkKY1Zcg8sBFQRASYGgZvAjHfAsWuDRz1+/U7GUbo+wW0LMnD0J3tnkoLcC6H7joxWmUFgxsYqKtgvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894286; c=relaxed/simple;
	bh=xncnNhYyzMA8EcKgLj5Dd+rUYihbJtF2ZL22fbdlL1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NuxMDvE+KjlZXvdFu6nzxML5WPMsphovwzwxgSQ2dbVRpE3KtYMVSg78OWdy+8sblY7lt5JJNe2AgiS6MOPaSr9Pc1Jq0bdP3dmHyDcaWIHxaTOJ+fH6wqzRXX0AFo//4rtrkXPSqV0KgEc6kYKtGIwJM1xNuV/m2nyaSSY+nRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BPT6yzTR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BPT6yzTR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FAD61F000FF;
	Tue, 13 Oct 2026 12:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894284;
	bh=GzflZrV2FcVG2sAO1FYk8Am2gZiAqdf8W0Jgol1sLi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BPT6yzTROIvpL8M51ojvr0D0GTA4por+Rn+8hlnGermbUWoxfcZoD+cMnLExBM18T
	 2HMdluwIdzKY9YFnmsiYP0/hu8ME77QvgEiaOwFEr9BRPpZtuuV9JVBFzibUCB1vov
	 7/NAlDKanE+FCZZkFqPkKNeUah122mOxhbqWB1XU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 509/621] bpf: mark a NULL call argument precise
Date: Tue, 13 Oct 2026 13:38:24 +0200
Message-ID: <20261013112932.905754737@linuxfoundation.org>
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

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit 1a3a10b030c96ea88868ccc060a16827c01eaa5a ]

check_func_arg() allows bpf_register_is_null() for nullable arguments
w/o marking the underlying scalar register precise. Hence a checkpoint
created on such a path would prune against arbitrary scalar value.

check_helper_call() enforces second parameter of the
bpf_get_local_storage() to be zero, w/o marking the underlying scalar
register precise. Hence a checkpoint created on such a path would
prune against arbitrary scalar value.

Grouping these two into one patch, as they share the same fixes tag.

Fixes: b5dc0163d8fd ("bpf: precise scalar_value tracking")
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260904-register-is-null-precise-fixes-v1-1-0f5a360ff15d@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c                                |  9 ++++++++-
 .../selftests/bpf/progs/verifier_subprog_precision.c | 12 ++++++------
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 419455fe03267..a5c8826e36896 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9871,11 +9871,15 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 			return err;
 	}
 
-	if (register_is_null(reg) && type_may_be_null(arg_type))
+	if (register_is_null(reg) && type_may_be_null(arg_type)) {
 		/* A NULL register has a SCALAR_VALUE type, so skip
 		 * type checking.
 		 */
+		err = mark_chain_precision(env, regno);
+		if (err)
+			return err;
 		goto skip_type_check;
+	}
 
 	/* arg_btf_id and arg_size are in a union. */
 	if (base_type(arg_type) == ARG_PTR_TO_BTF_ID ||
@@ -11811,6 +11815,9 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 			verbose(env, "get_local_storage() doesn't support non-zero flags\n");
 			return -EINVAL;
 		}
+		err = mark_chain_precision(env, BPF_REG_2);
+		if (err)
+			return err;
 		break;
 	case BPF_FUNC_for_each_map_elem:
 		err = push_callback_call(env, insn, insn_idx, meta.subprogno,
diff --git a/tools/testing/selftests/bpf/progs/verifier_subprog_precision.c b/tools/testing/selftests/bpf/progs/verifier_subprog_precision.c
index ac3e418c2a961..d55fd063dc59e 100644
--- a/tools/testing/selftests/bpf/progs/verifier_subprog_precision.c
+++ b/tools/testing/selftests/bpf/progs/verifier_subprog_precision.c
@@ -287,9 +287,9 @@ __msg("17: (b7) r0 = 0")
 __msg("18: (95) exit")
 __msg("returning from callee:")
 __msg("to caller at 9:")
-__msg("frame 0: propagating r1,r4")
+__msg("frame 0: propagating r1,r3,r4")
 __msg("mark_precise: frame0: last_idx 9 first_idx 9 subseq_idx -1")
-__msg("mark_precise: frame0: regs=r1,r4 stack= before 18: (95) exit")
+__msg("mark_precise: frame0: regs=r1,r3,r4 stack= before 18: (95) exit")
 __msg("from 18 to 9: safe")
 __naked int callback_result_precise(void)
 {
@@ -419,9 +419,9 @@ __msg("to caller at 9:")
 /* r1, r4 are always precise for bpf_loop(),
  * r6 was marked before backtracking to callback body.
  */
-__msg("frame 0: propagating r1,r4,r6")
+__msg("frame 0: propagating r1,r3,r4,r6")
 __msg("mark_precise: frame0: last_idx 9 first_idx 9 subseq_idx -1")
-__msg("mark_precise: frame0: regs=r1,r4,r6 stack= before 16: (95) exit")
+__msg("mark_precise: frame0: regs=r1,r3,r4,r6 stack= before 16: (95) exit")
 __msg("mark_precise: frame1: regs= stack= before 15: (b7) r0 = 0")
 __msg("mark_precise: frame1: regs= stack= before 9: (85) call bpf_loop")
 __msg("mark_precise: frame0: parent state regs= stack=:")
@@ -575,9 +575,9 @@ __msg("to caller at 10:")
 /* r1, r4 are always precise for bpf_loop(),
  * fp-8 was marked before backtracking to callback body.
  */
-__msg("frame 0: propagating r1,r4,fp-8")
+__msg("frame 0: propagating r1,r3,r4,fp-8")
 __msg("mark_precise: frame0: last_idx 10 first_idx 10 subseq_idx -1")
-__msg("mark_precise: frame0: regs=r1,r4 stack=-8 before 18: (95) exit")
+__msg("mark_precise: frame0: regs=r1,r3,r4 stack=-8 before 18: (95) exit")
 __msg("mark_precise: frame1: regs= stack= before 17: (b7) r0 = 0")
 __msg("mark_precise: frame1: regs= stack= before 10: (85) call bpf_loop#181")
 __msg("mark_precise: frame0: parent state regs= stack=:")
-- 
2.53.0



