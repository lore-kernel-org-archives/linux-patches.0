Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FF236405A;
	Wed, 20 May 2026 17:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299680; cv=none; b=B4MKXzGhL+bXaZc0R8KbSO3kVAM6AswCOtJy42H8tbEXzriJWA6h2KCJ+uuTMqtJZLLTW+vigWLinz25ayt7i6ZUZ0Kxf5RYwLeDTWufikLIpqa44oS1jPxwSqDOzHzhXcBdr7ONVpTyIqTAFP3C+CEsMweHYA3wHbXlxB6N7cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299680; c=relaxed/simple;
	bh=xeC5DanbDuAqMhrGdphYIi9aSjOCmP0GwaVNaYdJGWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dc+udf933hJTeizNLcPOHsmj6UFeJndgsjC8iYSDGFnN6z+mtm+eNsXVbZyotfoDqfoIYpOmhIjamNT87SRfVA+DlTqTcytncCxd1W3iUTLWHb050F6+JLMSdxc8jNSSz9EW8zsi1s31bcRcoPa8FZJUSBWrIXsvjT368mPUpx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hXXeFUKt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hXXeFUKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2C81F000E9;
	Wed, 20 May 2026 17:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299679;
	bh=jI93fEztf4amiAlwJC4EbEUMPhIsah4YdXMaEVgyFSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hXXeFUKtcn041f3WGgsjo0zMiqbPo6o2Pea9g2YbBxljyfrSEX0NvSAqNUq/96YeU
	 NU5FEO+YTMZ4ojocpxT+SczUFL6mop9ybHS4MmVNTp2iUAwp3oAVDXyMrrxYhSn1kc
	 LFixaZ0c7Oww+BuuVFtEyWeqB2486PFUPCPLnhRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jenny Guanni Qu <qguanni@gmail.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 864/957] bpf: Fix sync_linked_regs regarding BPF_ADD_CONST32 zext propagation
Date: Wed, 20 May 2026 18:22:27 +0200
Message-ID: <20260520162153.304028325@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit bc308be380c136800e1e94c6ce49cb53141d6506 ]

Jenny reported that in sync_linked_regs() the BPF_ADD_CONST32 flag is
checked on known_reg (the register narrowed by a conditional branch)
instead of reg (the linked target register created by an alu32 operation).

Example case with reg:

  1. r6 = bpf_get_prandom_u32()
  2. r7 = r6 (linked, same id)
  3. w7 += 5 (alu32 -- r7 gets BPF_ADD_CONST32, zero-extended by CPU)
  4. if w6 < 0xFFFFFFFC goto safe (narrows r6 to [0xFFFFFFFC, 0xFFFFFFFF])
  5. sync_linked_regs() propagates to r7 but does NOT call zext_32_to_64()
  6. Verifier thinks r7 is [0x100000001, 0x100000004] instead of [1, 4]

Since known_reg above does not have BPF_ADD_CONST32 set above, zext_32_to_64()
is never called on alu32-derived linked registers. This causes the verifier
to track incorrect 64-bit bounds, while the CPU correctly zero-extends the
32-bit result.

The code checking known_reg->id was correct however (see scalars_alu32_wrap
selftest case), but the real fix needs to handle both directions - zext
propagation should be done when either register has BPF_ADD_CONST32, since
the linked relationship involves a 32-bit operation regardless of which
side has the flag.

Example case with known_reg (exercised also by scalars_alu32_wrap):

  1. r1 = r0; w1 += 0x100 (alu32 -- r1 gets BPF_ADD_CONST32)
  2. if r1 > 0x80 - known_reg = r1 (has BPF_ADD_CONST32), reg = r0 (doesn't)

Hence, fix it by checking for (reg->id | known_reg->id) & BPF_ADD_CONST32.

Moreover, sync_linked_regs() also has a soundness issue when two linked
registers used different ALU widths: one with BPF_ADD_CONST32 and the
other with BPF_ADD_CONST64. The delta relationship between linked registers
assumes the same arithmetic width though. When one register went through
alu32 (CPU zero-extends the 32-bit result) and the other went through
alu64 (no zero-extension), the propagation produces incorrect bounds.

Example:

  r6 = bpf_get_prandom_u32()     // fully unknown
  if r6 >= 0x100000000 goto out  // constrain r6 to [0, U32_MAX]
  r7 = r6
  w7 += 1                        // alu32: r7.id = N | BPF_ADD_CONST32
  r8 = r6
  r8 += 2                        // alu64: r8.id = N | BPF_ADD_CONST64
  if r7 < 0xFFFFFFFF goto out    // narrows r7 to [0xFFFFFFFF, 0xFFFFFFFF]

At the branch on r7, sync_linked_regs() runs with known_reg=r7
(BPF_ADD_CONST32) and reg=r8 (BPF_ADD_CONST64). The delta path
computes:

  r8 = r7 + (delta_r8 - delta_r7) = 0xFFFFFFFF + (2 - 1) = 0x100000000

Then, because known_reg->id has BPF_ADD_CONST32, zext_32_to_64(r8) is
called, truncating r8 to [0, 0]. But r8 used a 64-bit ALU op -- the
CPU does NOT zero-extend it. The actual CPU value of r8 is
0xFFFFFFFE + 2 = 0x100000000, not 0. The verifier now underestimates
r8's 64-bit bounds, which is a soundness violation.

Fix sync_linked_regs() by skipping propagation when the two registers
have mixed ALU widths (one BPF_ADD_CONST32, the other BPF_ADD_CONST64).

Lastly, fix regsafe() used for path pruning: the existing checks used
"& BPF_ADD_CONST" to test for offset linkage, which treated
BPF_ADD_CONST32 and BPF_ADD_CONST64 as equivalent.

Fixes: 7a433e519364 ("bpf: Support negative offsets, BPF_SUB, and alu32 for linked register tracking")
Reported-by: Jenny Guanni Qu <qguanni@gmail.com>
Co-developed-by: Puranjay Mohan <puranjay@kernel.org>
Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260319211507.213816-1-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ebfa27d4002c5..3dcf591acd50d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -16913,6 +16913,12 @@ static void sync_linked_regs(struct bpf_verifier_state *vstate, struct bpf_reg_s
 			continue;
 		if ((reg->id & ~BPF_ADD_CONST) != (known_reg->id & ~BPF_ADD_CONST))
 			continue;
+		/*
+		 * Skip mixed 32/64-bit links: the delta relationship doesn't
+		 * hold across different ALU widths.
+		 */
+		if (((reg->id ^ known_reg->id) & BPF_ADD_CONST) == BPF_ADD_CONST)
+			continue;
 		if ((!(reg->id & BPF_ADD_CONST) && !(known_reg->id & BPF_ADD_CONST)) ||
 		    reg->off == known_reg->off) {
 			s32 saved_subreg_def = reg->subreg_def;
@@ -16940,7 +16946,7 @@ static void sync_linked_regs(struct bpf_verifier_state *vstate, struct bpf_reg_s
 			scalar32_min_max_add(reg, &fake_reg);
 			scalar_min_max_add(reg, &fake_reg);
 			reg->var_off = tnum_add(reg->var_off, fake_reg.var_off);
-			if (known_reg->id & BPF_ADD_CONST32)
+			if ((reg->id | known_reg->id) & BPF_ADD_CONST32)
 				zext_32_to_64(reg);
 			reg_bounds_sync(reg);
 		}
@@ -19056,11 +19062,14 @@ static bool regsafe(struct bpf_verifier_env *env, struct bpf_reg_state *rold,
 		 * Also verify that new value satisfies old value range knowledge.
 		 */
 
-		/* ADD_CONST mismatch: different linking semantics */
-		if ((rold->id & BPF_ADD_CONST) && !(rcur->id & BPF_ADD_CONST))
-			return false;
-
-		if (rold->id && !(rold->id & BPF_ADD_CONST) && (rcur->id & BPF_ADD_CONST))
+		/*
+		 * ADD_CONST flags must match exactly: BPF_ADD_CONST32 and
+		 * BPF_ADD_CONST64 have different linking semantics in
+		 * sync_linked_regs() (alu32 zero-extends, alu64 does not),
+		 * so pruning across different flag types is unsafe.
+		 */
+		if (rold->id &&
+		    (rold->id & BPF_ADD_CONST) != (rcur->id & BPF_ADD_CONST))
 			return false;
 
 		/* Both have offset linkage: offsets must match */
-- 
2.53.0



