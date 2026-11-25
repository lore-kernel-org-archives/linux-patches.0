Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622439;
	b=yRl0XvK0lbus6j5plhBSdUgq7jFYQf/cyNAy07V2P9+M+3uXOWvmeONqSAxQ097Hb0P6
	 B3Z4mjWm1M82/MaJB349EPEybPFzqsgyiI4NHf3Ev0oDtiJrLdeHk+JwjwGDQFwhI8UG2
	 iGWKNULqGNkYfaXCVlFeoDjCMmCcOpym6Gj+07mssCKqigXQT2181fFTYkGz2EWz8Lq5j
	 +PauNIR7V4XJJqatWRAQlKwn4iafyMd3GoVGcUXzBvgYoH+xHJRvgajDrFgjkBdN9YsL0
	 /C9wWTZPr/s6B/loS/HYxRSUTAS0qdipISCpoEtGrzCeZ6M6Dxt0O/GZHo+wSMSxr1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622439;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7CTFsnu/tIxJ9qOWUgfINbJgP3Dx6m79gne4sMKDdQ0=;
	b=uHYsrspFplNCN7J0VWPNkXEmyzN7bIAQOw9BwzcT++XLA3+tVop1qCjVRwZSKStmXIRA
	 dywYNW1YDAr0ppi7sDufuKIlzEW3IO6F6xmEOfOkFoADmoXDt3PfsVec2sdI3o70Vk0Ua
	 2cG0Npe4cETkwcaiJgrUeJqwgPg3C6wzMdhlDcDyRLQlxV8o+46fN8+gWWNA4nwjya20D
	 +jbPhq4lmf8wlFl2bjqAgk2+sCVvT/Ul5U8Nb/msAroDRCxkI98iu94BiFlJShXLY6Gic
	 5Br1PAhG0UiXc/U27SJH3oh6c1638EkTsHeXbGZPmIkw5UetbOtX9B1Si3tQrJcPDjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ZVgUtqp/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D08606A31E;
	Wed, 25 Nov 2026 16:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZVgUtqp/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0BA1F000C4;
	Wed, 25 Nov 2026 16:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622438;
	bh=7CTFsnu/tIxJ9qOWUgfINbJgP3Dx6m79gne4sMKDdQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZVgUtqp/hv8EDmoxOwsLwyWa+8Q/QI4X42IzLRX/ftJjQijWaqqvX8t4lj20oaXif
	 sU9FuEEM5tlv33Ar8TkittHNpsWA0CZhxhF4k6Z0w4YeeP8wQEYdeCRYO1aUkU6rsv
	 K8J1PzfR0EtPvBRENjHqykIJT6ix47GWwjLluz5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 536/990] bpf: Adjust pc-relative insn copied into its own patch
Date: Wed, 25 Nov 2026 15:31:43 +0100
Message-ID: <20261125143834.648217814@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Applied the changes to kernel/bpf/verifier.c instead of fixups.c, using the local function names convert_ctx_accesses() and do_misc_fixups() in place of the bpf_-prefixed upstream ones. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 55 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 53 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 8ac91e5ced84b..13864488b5a07 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -21471,6 +21471,44 @@ static struct bpf_prog *bpf_patch_insn_data(struct bpf_verifier_env *env, u32 of
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
@@ -21962,7 +22000,13 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 			struct bpf_insn *patch = insn_buf;
 
 			*patch++ = BPF_ST_NOSPEC();
-			*patch++ = *insn;
+			*patch = *insn;
+			ret = bpf_adj_moved_insn(patch++, 1);
+			if (ret) {
+				verbose(env, "insn %d cannot be patched due to 16-bit range\n",
+					env->insn_aux_data[i + delta].orig_idx);
+				return ret;
+			}
 			cnt = patch - insn_buf;
 			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, cnt);
 			if (!new_prog)
@@ -23576,7 +23620,14 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 						     BPF_MAX_LOOPS);
 		}
 		/* Copy first actual insn to preserve it */
-		insn_buf[cnt++] = env->prog->insnsi[subprog_start];
+		insn_buf[cnt] = env->prog->insnsi[subprog_start];
+		ret = bpf_adj_moved_insn(&insn_buf[cnt], cnt);
+		if (ret) {
+			verbose(env, "insn %d cannot be patched due to 16-bit range\n",
+				env->insn_aux_data[subprog_start].orig_idx);
+			return ret;
+		}
+		cnt++;
 
 		new_prog = bpf_patch_insn_data(env, subprog_start, insn_buf, cnt);
 		if (!new_prog)
-- 
2.53.0



