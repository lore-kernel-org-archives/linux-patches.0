Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777BD46C84B;
	Sat, 12 Sep 2026 10:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210193; cv=none; b=SSxofOL5pLPSc6iPxHQAcPNigRK0Xxjdn72kRcmWefxakzsejQyZTjJS0cFWTslzQ9B1MG4j3d0ehDrn2MBUGjJ3qz8/YcvdA+zoPooLXlBz+AVrgDB01WU7xGV5adR4Z1HV+d2V69daNuxd4/OdOvKsWx9W7YSDIn9+419T96c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210193; c=relaxed/simple;
	bh=hcPBXx624CgYAAkAHeAb2CZaoE+gEdxoVoj/rAc+hbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SI5ROegpkUb1FXXGpFRjzzB2hjM1yVviIu5sCnn/RdGu1FJxYelBMvnHbQkD/CgXxtUgOuzvDazgkHMwDfuA8W3IHXz6J8K2KKJDR3XCR1AY3a6Aoec+Zu0B93AB4h8cf9scV8KX1mVf2Z+E4mJ+A8DS9CZ0KMnmh7G85OnfIIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bI1YV7dX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bI1YV7dX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F4F1F000FF;
	Sat, 12 Sep 2026 10:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210187;
	bh=62pejgKNhJ9zzgIcKjj3Vf2nEJenZdnZrJEOMQiu2Cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bI1YV7dX4S18VKJd7I6xI4xA+MnDBrRxlbZy62g3mYACKT98ZnYIPUYydU0X5w8I6
	 He2lKX7mswjk3aC+iECN95TmYGjB0VyMJw1lIT8rdZFWVXtoJobnO+4aTPcCntWqhl
	 4TkLsLOsvR8CSbudaRIwAg7MwvNYq833ayLquD88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0976/1518] bpf, x86: Fix exception table metadata for arena load-acquire
Date: Sat, 12 Sep 2026 08:52:25 +0200
Message-ID: <20260912065645.536787395@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

[ Upstream commit 4cf8def58b779ad2827f81760837b7a844d6c7d6 ]

A load-acquire from an arena pointer is converted to BPF_PROBE_ATOMIC and
gets an exception table entry, but the entry is filled in as if it were a
store, since populate_extable() decides based on instruction class alone
and a load-acquire is of BPF_STX class:

  if (BPF_CLASS(insn->code) == BPF_LDX) {
      arena_reg = reg2pt_regs[src_reg];
      fixup_reg = reg2pt_regs[dst_reg];
  } else {
      arena_reg = reg2pt_regs[dst_reg];
      fixup_reg = DONT_CLEAR;
  }

For a load-acquire dst_reg holds the loaded value and src_reg holds the
address, so both assignments in the else branch are wrong. On a fault
over an unmapped arena page ex_handler_bpf() then:

  - computes the reported address from the value register instead
    of the address register
  - reports the access as a WRITE, since it derives the direction
    from fixup_reg == DONT_CLEAR
  - leaves dst_reg untouched, so the program continues with a stale
    value instead of the 0 that BPF_PROBE_* loads deliver

The access itself is emitted correctly, emit_atomic_ld_st_index() uses
src_reg as the address, so this is a broken probe contract and a wrong
diagnostic rather than a memory safety issue.

Use bpf_atomic_is_load_acq() helper so a load-acquire takes the load path.

Fixes: 5341c9a4d833 ("bpf, x86: Support load-acquire and store-release instructions")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20260806201047.333389-3-daniel@iogearbox.net
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index cfd44906c31dd..39cf6974e11e1 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -2175,8 +2175,13 @@ st:			if (is_imm8(insn->off))
 				 * BPF_PROBE_ATOMIC) before being used for the memory access. Pass
 				 * the reg holding the unmodified 32-bit address to
 				 * ex_handler_bpf().
+				 *
+				 * A load-acquire is of BPF_STX class, but reads from src_reg
+				 * into dst_reg like a BPF_LDX does, hence it must not be
+				 * treated as a store here.
 				 */
-				if (BPF_CLASS(insn->code) == BPF_LDX) {
+				if (BPF_CLASS(insn->code) == BPF_LDX ||
+				    bpf_atomic_is_load_acq(insn)) {
 					arena_reg = reg2pt_regs[src_reg];
 					fixup_reg = reg2pt_regs[dst_reg];
 				} else {
-- 
2.53.0



