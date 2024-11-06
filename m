Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5271DF24A;
	Wed,  6 Nov 2024 12:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895594; cv=none; b=PJvsS07IR7PsUzel/Gtr42gVtTV78JxFh2CIwJNuxWQPLJE8XVI9zHSZStg757NMWV7AvyhKxFQXFace3EemKSE/Bv7QYnpBt2vGtT/ksBK6cGAEJYGefYRHvI+A+lZUHk5J81LEaZNKST2z0TkBx+STP0b1jzmCCE4AEP8A8bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895594; c=relaxed/simple;
	bh=miE8BaOh0c3aUp4FGKJ9zqHzFZJgQjYXtuNt60VC1ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4o7TsgTIyUvXjLga66FCVwEr1uh3mm4SPkTLS7FJhcKWDEVFnjAgHgCsQwFLRNQMCxTu+sPVEcVn4BDspsrNn76iSyOemZ0aOENft8X8wcPP2LbqPwIdYJIFSjoqMi4baX/sTZlRuMUgWsGWNlJSLYbx4jPH5mVAbZUnlVBWug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZsFptAin; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZsFptAin"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14764C4CECD;
	Wed,  6 Nov 2024 12:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895594;
	bh=miE8BaOh0c3aUp4FGKJ9zqHzFZJgQjYXtuNt60VC1ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZsFptAinO/CcDQ2VlSRCzhrF/Z9TbmHfqs1LxWy8xBgRa9FpEhMG6QpCRLD9V+33j
	 BboC/DFLuqVtGnN07HD8C9RHmUOYXujPZWhqO/SPBEiO56f/3eYULgZOU2cVXWy0Un
	 KDavs7Dm44UTIUSxiQJkA4ZG1xBcIEBQvl0pkpHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 4.19 270/350] arm64: probes: Fix simulate_ldr*_literal()
Date: Wed,  6 Nov 2024 13:03:18 +0100
Message-ID: <20241106120327.559409149@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

commit 50f813e57601c22b6f26ced3193b9b94d70a2640 upstream.

The simulate_ldr_literal() code always loads a 64-bit quantity, and when
simulating a 32-bit load into a 'W' register, it discards the most
significant 32 bits. For big-endian kernels this means that the relevant
bits are discarded, and the value returned is the the subsequent 32 bits
in memory (i.e. the value at addr + 4).

Additionally, simulate_ldr_literal() and simulate_ldrsw_literal() use a
plain C load, which the compiler may tear or elide (e.g. if the target
is the zero register). Today this doesn't happen to matter, but it may
matter in future if trampoline code uses a LDR (literal) or LDRSW
(literal).

Update simulate_ldr_literal() and simulate_ldrsw_literal() to use an
appropriately-sized READ_ONCE() to perform the access, which avoids
these problems.

Fixes: 39a67d49ba35 ("arm64: kprobes instruction simulation support")
Cc: stable@vger.kernel.org
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20241008155851.801546-3-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/probes/simulate-insn.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

--- a/arch/arm64/kernel/probes/simulate-insn.c
+++ b/arch/arm64/kernel/probes/simulate-insn.c
@@ -178,17 +178,15 @@ simulate_tbz_tbnz(u32 opcode, long addr,
 void __kprobes
 simulate_ldr_literal(u32 opcode, long addr, struct pt_regs *regs)
 {
-	u64 *load_addr;
+	unsigned long load_addr;
 	int xn = opcode & 0x1f;
-	int disp;
 
-	disp = ldr_displacement(opcode);
-	load_addr = (u64 *) (addr + disp);
+	load_addr = addr + ldr_displacement(opcode);
 
 	if (opcode & (1 << 30))	/* x0-x30 */
-		set_x_reg(regs, xn, *load_addr);
+		set_x_reg(regs, xn, READ_ONCE(*(u64 *)load_addr));
 	else			/* w0-w30 */
-		set_w_reg(regs, xn, *load_addr);
+		set_w_reg(regs, xn, READ_ONCE(*(u32 *)load_addr));
 
 	instruction_pointer_set(regs, instruction_pointer(regs) + 4);
 }
@@ -196,14 +194,12 @@ simulate_ldr_literal(u32 opcode, long ad
 void __kprobes
 simulate_ldrsw_literal(u32 opcode, long addr, struct pt_regs *regs)
 {
-	s32 *load_addr;
+	unsigned long load_addr;
 	int xn = opcode & 0x1f;
-	int disp;
 
-	disp = ldr_displacement(opcode);
-	load_addr = (s32 *) (addr + disp);
+	load_addr = addr + ldr_displacement(opcode);
 
-	set_x_reg(regs, xn, *load_addr);
+	set_x_reg(regs, xn, READ_ONCE(*(s32 *)load_addr));
 
 	instruction_pointer_set(regs, instruction_pointer(regs) + 4);
 }


