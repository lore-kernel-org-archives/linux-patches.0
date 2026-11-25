Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618322;
	b=sr5U+dPQm96iepcpn0l798eXfZklJRjciCqw6ZBL9/MGrj1onv1l+8RhllToZkHpO7JD
	 IQ/nl5K/D625r4sQQx630cb8721yCwhv9l5EqDoGG/zGEXubTpRO016pUaNgVR2LBMbi5
	 yvVmu3VHhwGd6VBXywarHcW8xSho+X3U7qCrHPlDE6PoyAtS5nsZRNiWOLRXHeZKkH135
	 IY8rY733XLI2QYBBAHhwNYmIJMNZlDgs4EvFqddT4QDubYP0PfKiS7gQhBaMVl7AmXrpA
	 adRdWZMw6wjvh4We/qVI6Iom9kRIWXmSpd3E4T1gd10qe2HznTiW7V1O73LC0EHcCxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618322;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d4tf1YZ9hl7+kpdGOH5TvJA3Rnpp0xRGa3E3k1Uvdqw=;
	b=cR9LrUXItXE7Z04II255KRZG7Si2G2CVQuza7+7jJz8pV76QKzt9T+mogCd3EwB32XPo
	 B312Mn+h+o4lXMSsfFeeAUCE4rgXl7q/X1GM1wcX2jKMCcO6wKtmpAmsp8iLwIofGitjl
	 i6jVtdBzbrVnT11Qw33frp8RoBmXe3PxCCEFmXM9IVECjXVsch6OvaJ/uWxcjfGvLB7y0
	 6ExJb4+2DjTJECrpQ6Qc/Ay8v2cZW1Fa2wjdS+FyWJVAEoxH84olmqxFXzvkrhyw6IOHF
	 4FanyTse6P96KyuLIbgzSFjbbksw456xuYsPZhQLKlsdjwHPnYfOTeElCbUF0o4oxsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dM76hEAs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B557606A323;
	Wed, 25 Nov 2026 14:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dM76hEAs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01BB91F000C0;
	Wed, 25 Nov 2026 14:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618322;
	bh=d4tf1YZ9hl7+kpdGOH5TvJA3Rnpp0xRGa3E3k1Uvdqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dM76hEAsACzuNseYdvmuufxgDCaCHxk1sa7Nhd/1GSA5vPLJXL9isNgIcjtItGPp2
	 ohCf07ZZJgZ0trJxWJP/x82Q2S3HAP06SdbxRfUT035eH4cSQdV55At49f7l52+zzT
	 b2o0iiHdo6xOotUi5XVkPjFGid97eqV8Fen9XjUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0216/1005] bpf: Emit timed may_goto for JITed progs only
Date: Wed, 25 Nov 2026 15:25:54 +0100
Message-ID: <20261125143826.801319878@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 1ddffb57b36239e84b8224b12e34b87f6031b29c ]

The timed form of may_goto calls arch_bpf_timed_may_goto(). This function
takes its argument and returns its result in BPF_REG_AX, in a register of
the cpu. Only JITed code can call it.

The verifier emits the timed form when the arch has a JIT that supports it.
It does not look at the prog. With CONFIG_BPF_JIT_ALWAYS_ON=n the
interpreter can run such a prog: the JIT is off, or it fails. The
interpreter calls the function like a helper. The function takes what the C
code left in that register for a pointer, and bpf_check_timed_may_goto()
reads and writes through it.

Emit the timed form only when the prog asks for a JIT, and make the JIT
mandatory for such a prog. All other progs get the form that counts down
from BPF_MAX_LOOPS.

One test of verifier_may_goto_1 shows the insns of the timed form. Load it
only when progs are JITed.

Fixes: e723608bf428 ("bpf: Add verifier support for timed may_goto")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261031215543.682284-2-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/fixups.c                                     | 9 ++++++---
 tools/testing/selftests/bpf/progs/verifier_may_goto_1.c | 1 +
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/fixups.c b/kernel/bpf/fixups.c
index 5a5f7ec21f2dc..524e6d3de0776 100644
--- a/kernel/bpf/fixups.c
+++ b/kernel/bpf/fixups.c
@@ -1621,6 +1621,8 @@ int bpf_do_misc_fixups(struct bpf_verifier_env *env)
 	struct bpf_subprog_info *subprogs = env->subprog_info;
 	u16 stack_depth = subprogs[cur_subprog].stack_depth;
 	u16 stack_depth_extra = 0;
+	/* arch_bpf_timed_may_goto() takes and returns AX in a cpu register: for JITs only */
+	bool timed_may_goto = prog->jit_requested && bpf_jit_supports_timed_may_goto();
 
 	if (env->seen_exception && !env->exception_callback_subprog) {
 		struct bpf_insn *patch = insn_buf;
@@ -1876,7 +1878,7 @@ int bpf_do_misc_fixups(struct bpf_verifier_env *env)
 			goto next_insn;
 		}
 
-		if (bpf_is_may_goto_insn(insn) && bpf_jit_supports_timed_may_goto()) {
+		if (bpf_is_may_goto_insn(insn) && timed_may_goto) {
 			int stack_off_cnt = -stack_depth - 16;
 			/*
 			 * AX is used as an argument to pass in stack_off_cnt
@@ -1906,6 +1908,7 @@ int bpf_do_misc_fixups(struct bpf_verifier_env *env)
 			 * after subtraction, rinse and repeat.
 			 */
 			stack_depth_extra = 16;
+			prog->jit_required = 1;
 			cnt = may_goto_expand(insn_buf, insn->off, stack_off_cnt,
 					      tail, ARRAY_SIZE(tail));
 
@@ -2527,7 +2530,7 @@ int bpf_do_misc_fixups(struct bpf_verifier_env *env)
 
 	env->prog->aux->stack_depth = subprogs[0].stack_depth;
 	for (i = 0; i < env->subprog_cnt; i++) {
-		int delta = bpf_jit_supports_timed_may_goto() ? 2 : 1;
+		int delta = timed_may_goto ? 2 : 1;
 		int subprog_start = subprogs[i].start;
 		int stack_slots = subprogs[i].stack_extra / 8;
 		int slots = delta, cnt = 0;
@@ -2541,7 +2544,7 @@ int bpf_do_misc_fixups(struct bpf_verifier_env *env)
 		}
 
 		stack_depth = subprogs[i].stack_depth;
-		if (bpf_jit_supports_timed_may_goto()) {
+		if (timed_may_goto) {
 			insn_buf[cnt++] = BPF_ST_MEM(BPF_DW, BPF_REG_FP, -stack_depth,
 						     BPF_MAX_TIMED_LOOPS);
 			insn_buf[cnt++] = BPF_ST_MEM(BPF_DW, BPF_REG_FP, -stack_depth + 8, 0);
diff --git a/tools/testing/selftests/bpf/progs/verifier_may_goto_1.c b/tools/testing/selftests/bpf/progs/verifier_may_goto_1.c
index db7e30da234f1..a95735d98c7cf 100644
--- a/tools/testing/selftests/bpf/progs/verifier_may_goto_1.c
+++ b/tools/testing/selftests/bpf/progs/verifier_may_goto_1.c
@@ -82,6 +82,7 @@ __naked void may_goto_batch_1(void)
 
 SEC("raw_tp")
 __description("may_goto batch with offsets 2/0")
+__load_if_JITed()
 __arch_x86_64
 __arch_s390x
 __arch_arm64
-- 
2.53.0



