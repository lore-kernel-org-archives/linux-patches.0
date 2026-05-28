Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F1F223328;
	Thu, 28 May 2026 20:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000311; cv=none; b=eN6Q1aFQxlKKoNmhd/IL9vnHTZzsRU3+tz107iNn4xstSiukXxOzEWow7/7EQaqTwqwzRShhVa2xEHJpqZeLFB71PGssEHVLXZR5X1Gm6T8Kq6j7MZHsJUwAPjRDqqR1pZH1Q1uAgKwg9NWqXml39BEF1CWv5ZlZpAK+349B7gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000311; c=relaxed/simple;
	bh=4W48ycVlQ+/ow7Q1q+s0ypM9YWXK3tyNrBpy9s+45nQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YyswhrtKNLpug0wUI6Mb9SKXVvwqIiwd11RjkbYBS7k8qfzHRxzYF4mLNgnExBxe+YDPOpnBAuw3/Gatoi7Vis+a/N0ZUQiEtzua8DFUPvTnEgHsgHCCEu1b7qIkGMv9HHPRNcJNwHUM1jvdexTJSC5fm86HV6rbMmJXKpEcWVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bY0bSO3/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bY0bSO3/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38D81F000E9;
	Thu, 28 May 2026 20:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000310;
	bh=sI/YqxyN4hqnuNS0Cg+DDa9mhfEPcCPatUKSZw18U5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bY0bSO3/BADalpi7xllLkUTdJ+Xb+z3tQ4uILEkr2plrbJnMIAZlExIlz1/KXR2y9
	 Q2aBNuYOBOPGFvlDMyemoDQFKG7M6ZNahh7DESQpHde3FxwE/IHU8PHBCocyxxz08r
	 Zq6kQovfku/WpYDPzBKCHLQ084IqEGCkEQNZokoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 377/377] LoongArch: kprobes: Fix handling of fatal unrecoverable recursions
Date: Thu, 28 May 2026 21:50:15 +0200
Message-ID: <20260528194649.348754461@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 1c856e158fd34ef2c4475a81c1dc386329989938 ]

KPROBE_HIT_SS and KPROBE_REENTER are two types of fatal recursions that
can not be safely recovered in kprobes.

KPROBE_HIT_SS means that a kprobe is hit during single-stepping. At
this point, the architecture-specific single-step context is already
active. Nested single-stepping would corrupt the state, as the kprobe
control block (kcb) and hardware registers cannot safely store multiple
levels of stepping state.

KPROBE_REENTER means that a third-level recursion occurs when a probe
is hit while the system is already handling a nested probe (second-
level). The kcb only provides a single slot (prev_kprobe) to backup the
state. When a third probe is hit, there is no more space to save the
state without corrupting the first-level backup.

Kprobes work by replacing instructions with breakpoints. In order to
execute the original instruction and continue, it must be moved to a
temporary "single-step" slot. Since there is no backup space left to
set up this slot safely, the CPU would be forced to return to the same
original breakpoint address, triggering an endless loop.

Currently, the code only prints a warning and returns. This leads to
an infinite re-entry loop as the CPU repeatedly hits the same trap and
a "stuck" CPU core because preemption was disabled at the start of the
handler and never re-enabled in this early return path.

Fix the logic by:
1. Merging KPROBE_HIT_SS and KPROBE_REENTER cases, as both represent
   fatal recursions that cannot be safely recovered.
2. Replacing WARN_ON_ONCE() with BUG() to terminate the system. This
   aligns LoongArch with other architectures (x86, arm64, riscv) and
   prevents stack overflow while providing diagnostic information.

Fixes: 6d4cc40fb5f5 ("LoongArch: Add kprobes support")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/kprobes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/kernel/kprobes.c b/arch/loongarch/kernel/kprobes.c
index 04b5b05715cdc..1985ed30dd16f 100644
--- a/arch/loongarch/kernel/kprobes.c
+++ b/arch/loongarch/kernel/kprobes.c
@@ -186,16 +186,16 @@ static bool reenter_kprobe(struct kprobe *p, struct pt_regs *regs,
 			   struct kprobe_ctlblk *kcb)
 {
 	switch (kcb->kprobe_status) {
-	case KPROBE_HIT_SS:
 	case KPROBE_HIT_SSDONE:
 	case KPROBE_HIT_ACTIVE:
 		kprobes_inc_nmissed_count(p);
 		setup_singlestep(p, regs, kcb, 1);
 		break;
+	case KPROBE_HIT_SS:
 	case KPROBE_REENTER:
 		pr_warn("Failed to recover from reentered kprobes.\n");
 		dump_kprobe(p);
-		WARN_ON_ONCE(1);
+		BUG();
 		break;
 	default:
 		WARN_ON(1);
-- 
2.53.0



