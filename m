Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D897C3AEF36;
	Sat, 17 Oct 2026 16:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255435; cv=none; b=cMRnwrA9UvTTkCj2bosajl1tmkJ7efdfbsCrQcbcwjn39KMvcrWCERkqqE2qtJrQ+2fmZAZPqGolBQ41fEhXJ8IdvnF5jmNoATOC3IRCtNkPn0AIB4hLRPzBCfEdoaa4SptedzVb1AsKUbk0/Vw5QOyCTdZzq6z1ZP0JTEsTlks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255435; c=relaxed/simple;
	bh=nMpRJbo06HYK9hVvZwEU2S17KAPrkpW8nFwXfLRecZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mtdfnxhUUSjRNFtlDCYghYKUPpw+/y/u/f9cwHoIttutYxNUl9bzG2saqV/w+6Xi54Ewz4qL0vkvkO/EDmfHOqS7P4cNFL2yTAbJUqxab3qpDNZ1CAZIJxtHeyb/vSaZRfgX93NypY+dO7LBuBK34J0MQDehx2PNIjIV050CLAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I98gs7Pz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I98gs7Pz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C111F000C4;
	Sat, 17 Oct 2026 16:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255434;
	bh=6CJsvVJbWawZ+gXd0a2d8xNrodbt8XJ9S4dTCHQnXNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I98gs7Pz50bpYvuQsDTpH25mdrZmMObhM7fZQ29lwEX6ut9vsd2e+PzudKNQIARbs
	 TlWmxveaw8WVNE7HvQDpunad4TtXh6O8M2ki19Kun2a5NUpm6Rx78mVq0SWqqTllT9
	 270gTpX2hEU3ZHwMSTfuPCapalMfWNgl/7/IO4L8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 775/869] bpf: mark a NULL call argument precise
Date: Sat, 17 Oct 2026 18:00:16 +0200
Message-ID: <20261017160056.789428765@linuxfoundation.org>
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
index 9f5eed4a7290a..67a250c439035 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9172,11 +9172,15 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
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
@@ -10961,6 +10965,9 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
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
index 9d415f7ce599b..8fcbb2ef5a533 100644
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



