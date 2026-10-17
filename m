Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0FC3A380C;
	Sat, 17 Oct 2026 18:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260827; cv=none; b=aKlRq0Rytv6IGSoXYQii2k2180HCcaB4xR4+IkTHIjvZ7m3ah1Sc62ph33g6mHgEdx4N3xWfQ3gkFgsJV9i4zTIsPI7ulPLOMwIBus55DwtrTPOrkzZy5stTd1hf8ZPks7kuPvfXADmlZaneLvc0cRtAoDL+PXiAwEq7PxUAxfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260827; c=relaxed/simple;
	bh=fKP6oI3OcK7gYCOkTq1JzONikLrtrf8H0zilyjF2/nE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/q0kHe1ETevX7loFYx/PE5bqvnM96xRXC02KoJN/vFSiuiGZ9r7DROg/daO1BI//1NE1RuudA8jDPsG41fL8mqqjcrw7neMK6VFDKvCot9nc4zmHbTxKnvzcxC/IbAZFBRhZrFyMMYudCwyShj1O4Q0QCFU25e3fwjl0xqfRI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zo63Q1Ea; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zo63Q1Ea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73D81F000C4;
	Sat, 17 Oct 2026 18:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260826;
	bh=zhrcUSSGlUATzkLE+OEP5HN/k/Ms6U+o0IL0UJXaYJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zo63Q1EaUGEUmMWgcxYpTeiNEdbU6nA9XRwC4d5yfA92ZrSXuH+E/jZ6Tv8Nl79J3
	 ioBwuo0aneDc76Cg2JmoMYx3k3gey1hTxdxzCrj8j1Q/GnMDjp36H20wGZGAgerOco
	 t8DnyFF4utmyaDnjR/mWxXiZ9VVcvQfKLHmu6j/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1633/1674] bpf: generalize is_scalar_branch_taken() logic
Date: Sat, 17 Oct 2026 18:05:05 +0200
Message-ID: <20261017160512.996980141@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 96381879a370425a30b810906946f64c0726450e ]

Generalize is_branch_taken logic for SCALAR_VALUE register to handle
cases when both registers are not constants. Previously supported
<range> vs <scalar> cases are a natural subset of more generic <range>
vs <range> set of cases.

Generalized logic relies on straightforward segment intersection checks.

Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Link: https://lore.kernel.org/r/20231112010609.848406-3-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: e51179a4e098 ("bpf: Don't predict JMP32 pointer vs zero comparisons")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 98 +++++++++++++++++++++++++------------------
 1 file changed, 58 insertions(+), 40 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 8fee0a528fdd5..824b5b2b1d9de 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -14096,82 +14096,99 @@ static int is_scalar_branch_taken(struct bpf_reg_state *reg1, struct bpf_reg_sta
 				  u8 opcode, bool is_jmp32)
 {
 	struct tnum t1 = is_jmp32 ? tnum_subreg(reg1->var_off) : reg1->var_off;
+	struct tnum t2 = is_jmp32 ? tnum_subreg(reg2->var_off) : reg2->var_off;
 	u64 umin1 = is_jmp32 ? (u64)reg1->u32_min_value : reg1->umin_value;
 	u64 umax1 = is_jmp32 ? (u64)reg1->u32_max_value : reg1->umax_value;
 	s64 smin1 = is_jmp32 ? (s64)reg1->s32_min_value : reg1->smin_value;
 	s64 smax1 = is_jmp32 ? (s64)reg1->s32_max_value : reg1->smax_value;
-	u64 uval = is_jmp32 ? (u32)tnum_subreg(reg2->var_off).value : reg2->var_off.value;
-	s64 sval = is_jmp32 ? (s32)uval : (s64)uval;
+	u64 umin2 = is_jmp32 ? (u64)reg2->u32_min_value : reg2->umin_value;
+	u64 umax2 = is_jmp32 ? (u64)reg2->u32_max_value : reg2->umax_value;
+	s64 smin2 = is_jmp32 ? (s64)reg2->s32_min_value : reg2->smin_value;
+	s64 smax2 = is_jmp32 ? (s64)reg2->s32_max_value : reg2->smax_value;
 
 	switch (opcode) {
 	case BPF_JEQ:
-		if (tnum_is_const(t1))
-			return !!tnum_equals_const(t1, uval);
-		else if (uval < umin1 || uval > umax1)
+		/* constants, umin/umax and smin/smax checks would be
+		 * redundant in this case because they all should match
+		 */
+		if (tnum_is_const(t1) && tnum_is_const(t2))
+			return t1.value == t2.value;
+		/* non-overlapping ranges */
+		if (umin1 > umax2 || umax1 < umin2)
 			return 0;
-		else if (sval < smin1 || sval > smax1)
+		if (smin1 > smax2 || smax1 < smin2)
 			return 0;
 		break;
 	case BPF_JNE:
-		if (tnum_is_const(t1))
-			return !tnum_equals_const(t1, uval);
-		else if (uval < umin1 || uval > umax1)
+		/* constants, umin/umax and smin/smax checks would be
+		 * redundant in this case because they all should match
+		 */
+		if (tnum_is_const(t1) && tnum_is_const(t2))
+			return t1.value != t2.value;
+		/* non-overlapping ranges */
+		if (umin1 > umax2 || umax1 < umin2)
 			return 1;
-		else if (sval < smin1 || sval > smax1)
+		if (smin1 > smax2 || smax1 < smin2)
 			return 1;
 		break;
 	case BPF_JSET:
-		if ((~t1.mask & t1.value) & uval)
+		if (!is_reg_const(reg2, is_jmp32)) {
+			swap(reg1, reg2);
+			swap(t1, t2);
+		}
+		if (!is_reg_const(reg2, is_jmp32))
+			return -1;
+		if ((~t1.mask & t1.value) & t2.value)
 			return 1;
-		if (!((t1.mask | t1.value) & uval))
+		if (!((t1.mask | t1.value) & t2.value))
 			return 0;
 		break;
 	case BPF_JGT:
-		if (umin1 > uval )
+		if (umin1 > umax2)
 			return 1;
-		else if (umax1 <= uval)
+		else if (umax1 <= umin2)
 			return 0;
 		break;
 	case BPF_JSGT:
-		if (smin1 > sval)
+		if (smin1 > smax2)
 			return 1;
-		else if (smax1 <= sval)
+		else if (smax1 <= smin2)
 			return 0;
 		break;
 	case BPF_JLT:
-		if (umax1 < uval)
+		if (umax1 < umin2)
 			return 1;
-		else if (umin1 >= uval)
+		else if (umin1 >= umax2)
 			return 0;
 		break;
 	case BPF_JSLT:
-		if (smax1 < sval)
+		if (smax1 < smin2)
 			return 1;
-		else if (smin1 >= sval)
+		else if (smin1 >= smax2)
 			return 0;
 		break;
 	case BPF_JGE:
-		if (umin1 >= uval)
+		if (umin1 >= umax2)
 			return 1;
-		else if (umax1 < uval)
+		else if (umax1 < umin2)
 			return 0;
 		break;
 	case BPF_JSGE:
-		if (smin1 >= sval)
+		if (smin1 >= smax2)
 			return 1;
-		else if (smax1 < sval)
+		else if (smax1 < smin2)
 			return 0;
 		break;
 	case BPF_JLE:
-		if (umax1 <= uval)
+		if (umax1 <= umin2)
 			return 1;
-		else if (umin1 > uval)
+		else if (umin1 > umax2)
 			return 0;
 		break;
 	case BPF_JSLE:
-		if (smax1 <= sval)
+		if (smax1 <= smin2)
 			return 1;
-		else if (smin1 > sval)
+		else if (smin1 > smax2)
 			return 0;
 		break;
 	}
@@ -14250,28 +14267,28 @@ static int is_pkt_ptr_branch_taken(struct bpf_reg_state *dst_reg,
 static int is_branch_taken(struct bpf_reg_state *reg1, struct bpf_reg_state *reg2,
 			   u8 opcode, bool is_jmp32)
 {
-	u64 val;
-
 	if (reg_is_pkt_pointer_any(reg1) && reg_is_pkt_pointer_any(reg2) && !is_jmp32)
 		return is_pkt_ptr_branch_taken(reg1, reg2, opcode);
 
-	/* try to make sure reg2 is a constant SCALAR_VALUE */
-	if (!is_reg_const(reg2, is_jmp32)) {
-		opcode = flip_opcode(opcode);
-		swap(reg1, reg2);
-	}
-	/* for now we expect reg2 to be a constant to make any useful decisions */
-	if (!is_reg_const(reg2, is_jmp32))
-		return -1;
-	val = reg_const_value(reg2, is_jmp32);
+	if (__is_pointer_value(false, reg1) || __is_pointer_value(false, reg2)) {
+		u64 val;
+
+		/* arrange that reg2 is a scalar, and reg1 is a pointer */
+		if (!is_reg_const(reg2, is_jmp32)) {
+			opcode = flip_opcode(opcode);
+			swap(reg1, reg2);
+		}
+		/* and ensure that reg2 is a constant */
+		if (!is_reg_const(reg2, is_jmp32))
+			return -1;
 
-	if (__is_pointer_value(false, reg1)) {
 		if (!reg_not_null(reg1))
 			return -1;
 
 		/* If pointer is valid tests against zero will fail so we can
 		 * use this to direct branch taken.
 		 */
+		val = reg_const_value(reg2, is_jmp32);
 		if (val != 0)
 			return -1;
 
@@ -14285,6 +14302,7 @@ static int is_branch_taken(struct bpf_reg_state *reg1, struct bpf_reg_state *reg
 		}
 	}
 
+	/* now deal with two scalars, but not necessarily constants */
 	return is_scalar_branch_taken(reg1, reg2, opcode, is_jmp32);
 }
 
-- 
2.53.0



