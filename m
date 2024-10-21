Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268851E47C6;
	Mon, 21 Oct 2024 10:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506471; cv=none; b=mjrc98gYtyhsHuHKhE95fWXuY3UrYIjBAwMqHWCreP9xBtPz3vq73LF1kTE1Wl3U916nijR/f68G5/CnwfO9Yl72ec5Kr3QzrGdT+Z8BA1SINEbJt91lZ9Ywou9CYA1QX0QWoeOVJvIRRY6m13fPCtK318iC8eQrXDEKpeXOvho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506471; c=relaxed/simple;
	bh=F4S9OBOD85Krvj9iYyJjlXVx0IjatMIt32zsVD9N2hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oGnDVXO/u6+4z84/3jKahWuERHwl4hd/OuJn5CvGblPylDbYQiH+YUfO0XNUaNPJQQvkGUQzTSA0ACS1aiG3hG3eOnifohdzAIMhgaigOlxTS7QbVUoy2FUD8MHr46G96nFN3UO6BpGgjxs12vVazafo66JPdEDGsmYI83qYX50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AM+SLSr2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AM+SLSr2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6022FC4CEC3;
	Mon, 21 Oct 2024 10:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506470;
	bh=F4S9OBOD85Krvj9iYyJjlXVx0IjatMIt32zsVD9N2hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AM+SLSr2lOJaiwpBF8XHeMxJuq45auCcflWx61hv7xLDSwSu61iojhVIMjS728+gw
	 6pZBzNx6pUlgyqUIrdwoArWjjcpx2p6CW46RuMbnrRE8xt8078l7nGVP2NSWR08g1u
	 Juwv2Zv4IuT+iv0wzblkkPbktiAPGVsr8YBPzfDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.11 016/135] arm64: probes: Fix simulate_ldr*_literal()
Date: Mon, 21 Oct 2024 12:22:52 +0200
Message-ID: <20241021102259.977153532@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -171,17 +171,15 @@ simulate_tbz_tbnz(u32 opcode, long addr,
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
@@ -189,14 +187,12 @@ simulate_ldr_literal(u32 opcode, long ad
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


