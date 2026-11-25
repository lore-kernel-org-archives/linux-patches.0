Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625294;
	b=uY5n+21v0eEgh0a6gOloIksKfDaIeOj6yxCO2Ix/bYsccw3/P/s/m7YEeoncjdjSAaEq
	 hhomxq5wl5PP3pwBtExv0sk6HH0ja9j4kFaf30yqmTr0KjYzTVL/CzpVZ4viEGpGjX/YG
	 3CwFXqep0f0ySmmJkVBNYDsT7JuoMsnXpDXZOUxcZUtFGJ4Kgw2kBBcoCqS4oS9TL1Eu0
	 RGsxp1opbX/Urrax3R+XnAUwPxgsakh7ea6QFZLrJwmgPg8NJwM3BpHdxF+LFbh9BYAyq
	 OPdvDkBykMxmnvX4Qh87N9+bg8IqEI//b/MYxBzRmR8ADHrPLN/snSYmsVR5ECeN1Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625294;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H6EZe8x9toRW4rrn1DnOuK2QG2DoIGI53u5s28YzFiQ=;
	b=1a/DiN+z25o7kzHKyq+K00p/RornHbImq+kf4w1Lpq2yZt6DdmlFjoOfdKR3Mql+FiyJ
	 YDUiAZvO4HBeGTz5Po3U1n3yAaBveERj3IcoSUqmQzM0tkFdP0pDGG+7qE/ANFzCQH/uk
	 +PX6a0jd8lZn3YFKJbX6V4iIy/0w3ausH5BfO4NBDWV31rh/Q+eI7Be7oyX4skDhuJhGt
	 e37hvU+UKFiox+cXVGzQnGRL/xei9verRJPDLy7135uUQguZTX1HAcBxHsZPEORNTMu0F
	 CDeQ8gkBAo5HnyFfSO9JR3L/vM4K6ch9MS+wEOND5QLSzv+7rJjaT+4N51naZ43VhxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ql6nZflF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1D7606A326;
	Wed, 25 Nov 2026 16:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ql6nZflF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5193E1F000E6;
	Wed, 25 Nov 2026 16:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625293;
	bh=H6EZe8x9toRW4rrn1DnOuK2QG2DoIGI53u5s28YzFiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ql6nZflFcpPat/Iy3qKSP1d9KPiBywxPrEB2Z/ExPy8Z/zcZCI51NQwefQiR3AnH5
	 TXZ4b8l72rM1Mw84K2r77Fq5HgEsERwzxO8EQviwjdopUSDhAP9kKuadEw9wZKboGb
	 GKWUIRstL34EjoDmBWrclm/qXFRcyyeTyK4GhWUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 424/816] bpf: Adjust pc-relative insn copied into its own patch
Date: Wed, 25 Nov 2026 15:32:52 +0100
Message-ID: <20261125143859.011045774@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 67a3b916a7ae7c1a6bed08555417d444de6f5838 ]

bpf_do_misc_fixups() inits may_goto count by patching the first insn
of a subprog with [ST, ST, first insn]. bpf_convert_ctx_accesses()
patches insn that needs a barrier with [nospec, insn].
bpf_adj_branches() doesn't adjust insns inside the patch, so when
the copy is a call, ld_imm64 of a func or a jump that points backward
its target is off by the number of insns in front of it:

  static int A(void)  { return 1; }
  static int A2(void) { return 2; }
  static int B(void)
  {
          int i, ret = A();

          for (i = 0; i < 10 && can_loop; i++)
                  ...
          return ret;
  }

When A is placed in front of B and may_goto is timed 'call A' becomes
call of A + 2. B returns 2 when A + 2 is the start of A2. Otherwise
the prog is rejected with "verifier bug: No program to jit at insn".

Add bpf_adj_moved_insn() and use it for both copies.

Fixes: 011832b97b31 ("bpf: Introduce may_goto instruction")
Fixes: d6f1c85f2253 ("bpf: Fall back to nospec for Spectre v1")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20260924233130.1213812-4-alexei.starovoitov@gmail.com
[ sashal: Ported the fix into the monolithic verifier file and dropped the nospec hunk, since the original insn stays at index 0 in this tree's patch layout. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 44 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 17f3f39df27c0..ab7cf92771d81 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -19952,6 +19952,44 @@ static struct bpf_prog *bpf_patch_insn_data(struct bpf_verifier_env *env, u32 of
 	return new_prog;
 }
 
+/*
+ * insn was moved down by delta insns inside its own patch. Operands relative
+ * to the pc that point in front of the old position did not move with it.
+ */
+static int bpf_adj_moved_insn(struct bpf_insn *insn, u32 delta)
+{
+	u8 class = BPF_CLASS(insn->code), op = BPF_OP(insn->code);
+	s64 off = insn->imm, off_min = S32_MIN;
+	bool is_imm = true;
+
+	if (bpf_pseudo_func(insn) || bpf_pseudo_call(insn)) {
+		/* subprog that started at the old position starts with the patch */
+		if (off >= 0)
+			return 0;
+	} else if ((class == BPF_JMP || class == BPF_JMP32) &&
+		   op != BPF_CALL && op != BPF_EXIT) {
+		if (insn->code != (BPF_JMP32 | BPF_JA)) {
+			off = insn->off;
+			off_min = S16_MIN;
+			is_imm = false;
+		}
+		/* jump to itself stays */
+		if (off >= -1)
+			return 0;
+	} else {
+		return 0;
+	}
+
+	off -= delta;
+	if (off < off_min)
+		return -ERANGE;
+	if (is_imm)
+		insn->imm = off;
+	else
+		insn->off = off;
+	return 0;
+}
+
 /*
  * For all jmp insns in a given 'prog' that point to 'tgt_idx' insn adjust the
  * jump offset by 'delta'.
@@ -21959,6 +21997,12 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 					 -subprogs[i].stack_depth, BPF_MAX_LOOPS);
 		/* Copy first actual insn to preserve it */
 		insn_buf[1] = env->prog->insnsi[subprog_start];
+		ret = bpf_adj_moved_insn(&insn_buf[1], 1);
+		if (ret) {
+			verbose(env, "insn %d cannot be patched due to 16-bit range\n",
+				env->insn_aux_data[subprog_start].orig_idx);
+			return ret;
+		}
 
 		new_prog = bpf_patch_insn_data(env, subprog_start, insn_buf, 2);
 		if (!new_prog)
-- 
2.53.0



